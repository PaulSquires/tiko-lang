'' collect.bas -- declaration collection.
''
'' The first of the three name-resolution sub-phases (docs/plan/07 section 1). It
'' walks the AST and creates a symbol for every declaration, wiring up scopes. It
'' does NOT resolve types or look inside procedure bodies for references: that is
'' Resolve's job, and keeping the two apart is what gives FreeBASIC's
'' order-independence for free.
''
'' Contract:
''   - May report "duplicate declaration".
''   - May NOT report undefined symbols, type errors, or anything needing a lookup of
''     something that might be declared later.

#include once "symbols/collect.bi"

namespace Tko.Collect

type Walker
    as Tko.AstArena ptr     ast
    as Tko.SymbolTable ptr  syms
    as Tko.DiagnosticEngine ptr diags
    as Tko.Interner ptr     names
    as Tko.TypeContext ptr  types
    as Tko.SemanticInfo ptr info
    as boolean              inUnion      '' the immediate enclosing aggregate is a union
    as boolean              unionFirst   '' the next field starts a NEW anonymous group
    as long                 anonDepth    '' anonymous aggregates enclosing the cursor
    as long                 duplicates
end type

private function StmtOf _
    ( byref w as Walker, byval id as Tko.NodeId ) as Tko.StmtPayload ptr

    if id = Tko.NODE_NONE then return 0
    dim as Tko.AstNode ptr n = @w.ast->nodes[cast( long, id )]
    return @w.ast->stmts[cast( long, n->data )]
end function

private function ListOf _
    ( byref w as Walker, byval id as Tko.NodeId ) as Tko.ListPayload ptr

    if id = Tko.NODE_NONE then return 0
    dim as Tko.AstNode ptr n = @w.ast->nodes[cast( long, id )]
    return @w.ast->lists[cast( long, n->data )]
end function

private function Declare_ _
    ( byref w as Walker, byval scope_ as Tko.ScopeId, byval nm as Tko.InternId, _
      byval k as Tko.SymbolKind, byval loc as Tko.SourceLoc ) as Tko.SymbolId

    if nm = Tko.INTERN_NONE then return Tko.SYMBOL_NONE
    dim as boolean dup = false
    dim as Tko.SymbolId id = w.syms->DeclareSym( scope_, nm, k, loc, dup )
    if dup then
        w.duplicates += 1
        dim as Tko.SourceRange r = Tko.PointRange( loc )
        w.diags->Report( Tko.TKO0600, r, w.names->Spelling( nm ) )
        dim as Tko.Symbol ptr prev = w.syms->SymbolAt( id )
        if prev <> 0 then
            w.diags->AddNote( Tko.TKO0901, Tko.PointRange( prev->loc ) )
        end if
    end if
    return id
end function

declare sub SpreadOverloadFlag_ _
    ( byref w as Walker, byval scope_ as Tko.ScopeId, byval nm as Tko.InternId, _
      byval id as Tko.NodeId )
declare function SameTypeRef_ _
    ( byref w as Walker, byval a as Tko.NodeId, byval b as Tko.NodeId ) as boolean
declare function LiteralLen_ _
    ( byref w as Walker, byval id as Tko.NodeId, byref outv as longint ) as boolean
declare function DimCount_( byref w as Walker, byval id as Tko.NodeId ) as long
declare function SameBounds_ _
    ( byref w as Walker, byval a as Tko.NodeId, byval b as Tko.NodeId ) as boolean
declare function SameLiteral_ _
    ( byref w as Walker, byval a as Tko.NodeId, byval b as Tko.NodeId ) as boolean
declare function IsAnyBound_( byref w as Walker, byval id as Tko.NodeId ) as boolean
declare function IsVarLenBounds_( byref w as Walker, byval id as Tko.NodeId ) as boolean
declare function SameConstValue_ _
    ( byref w as Walker, byval a as Tko.NodeId, byval b as Tko.NodeId ) as boolean

'' Do two declarations of one name describe the SAME thing? Used only to decide whether
'' an EXTERN and its later definition are a redeclaration or a duplicate.
''
'' Compared SYNTACTICALLY, on the written type reference, because Collect runs before
'' any type exists -- and PERMISSIVELY: anything this cannot compare is treated as
'' agreeing. Rejecting is the direction that loses a file, and 'extern a as MyInt'
'' against 'dim shared a as integer' is legal when MyInt is a typedef for integer.
''
'' What it does catch is exactly what the corpus's 29 negative tests differ by --
'' measured: a different builtin (fbc error 4), a different array shape (error 54), a
'' different fixed-string length (error 20).
'' A DYNAMIC array ITEM: one declared with no bounds at all, or with every bound
'' written 'any'. 'dim a( )' and 'dim a( any, any )' are dynamic and 'dim a( 0 to 3 )'
'' is fixed -- which is the difference fbc reports as error 4 when a re-declaring
'' REDIM names the second.
private function IsDynArrayItem_ _
    ( byref w as Walker, byval item as Tko.NodeId ) as boolean

    if item = Tko.NODE_NONE then return false
    if cast( long, item ) >= w.ast->nodes.Count then return false
    if (w.ast->nodes[cast( long, item )].flags and Tko.NF_ARRAY) = 0 then return false
    dim as Tko.StmtPayload ptr ip = StmtOf( w, item )
    if ip = 0 then return false
    if ip->c = Tko.NODE_NONE then return true
    if w.ast->Kind( ip->c ) <> Tko.N_BLOCK then return false
    dim as Tko.ListPayload ptr lp = ListOf( w, ip->c )
    if lp = 0 then return false
    for i as long = 0 to lp->count - 1
        dim as Tko.NodeId d = cast( Tko.NodeId, w.ast->children[lp->first + i] )
        if w.ast->Kind( d ) <> Tko.N_IDENT then return false
    next
    return true
end function


private function SameDeclShape_ _
    ( byref w as Walker, byval aItem as Tko.NodeId, byval bItem as Tko.NodeId ) as boolean

    if (aItem = Tko.NODE_NONE) orelse (bItem = Tko.NODE_NONE) then return true
    if (cast( long, aItem ) >= w.ast->nodes.Count) orelse _
       (cast( long, bItem ) >= w.ast->nodes.Count) then return true

    dim as Tko.AstNode ptr an = @w.ast->nodes[cast( long, aItem )]
    dim as Tko.AstNode ptr bn = @w.ast->nodes[cast( long, bItem )]

    '' 'extern a as integer' against 'extern a( ) as integer' -- one is an array and
    '' the other is not. fbc error 54.
    dim as boolean aArr = ((an->flags and Tko.NF_ARRAY) <> 0)
    dim as boolean bArr = ((bn->flags and Tko.NF_ARRAY) <> 0)
    if aArr <> bArr then return false

    dim as Tko.StmtPayload ptr ap = StmtOf( w, aItem )
    dim as Tko.StmtPayload ptr bp = StmtOf( w, bItem )
    if SameBounds_( w, ap->c, bp->c ) = false then return false
    return SameTypeRef_( w, ap->a, bp->a )
end function

'' How many dimensions a bounds block declares. NODE_NONE is none.
private function DimCount_( byref w as Walker, byval id as Tko.NodeId ) as long
    if id = Tko.NODE_NONE then return 0
    if w.ast->Kind( id ) <> Tko.N_BLOCK then return 0
    return w.ast->lists[cast( long, w.ast->nodes[cast( long, id )].data )].count
end function

'' Two bounds blocks: the same number of dimensions, and where both sides wrote an
'' integer LITERAL, the same value. 'extern array(0 to 1)' against 'dim array(0 to 0)'
'' is fbc error 37 -- the dimension count agrees and the bounds do not, so comparing
'' the count alone let seven corpus files through.
private function SameBounds_ _
    ( byref w as Walker, byval a as Tko.NodeId, byval b as Tko.NodeId ) as boolean

    dim as long na = DimCount_( w, a )
    dim as long nb = DimCount_( w, b )

    '' VAR-LEN against FIXED is the distinction, not the dimension count. Measured, and
    '' it took two passes to get right because the obvious rule fits three rows and not
    '' the fourth:
    ''
    ''   ()        vs (any)        accepted, either order
    ''   ()        vs (any,any)    accepted
    ''   (any)     vs (any,any)    fbc error 36, wrong number of dimensions
    ''   ()        vs (0 to 1)     fbc error 54, EXPECTED VAR-LEN ARRAY
    ''
    '' So: a bounds list with no dimensions written, or with every dimension 'any', is
    '' VAR-LEN. One with a real bound is FIXED. The two never agree; two var-len forms
    '' agree unless both wrote a count and the counts differ.
    dim as boolean aVar = IsVarLenBounds_( w, a )
    dim as boolean bVar = IsVarLenBounds_( w, b )
    if aVar <> bVar then return false
    if aVar then
        if (na = 0) orelse (nb = 0) then return true
        return (na = nb)
    end if
    if na <> nb then return false

    dim as Tko.ListPayload ptr la = _
        @w.ast->lists[cast( long, w.ast->nodes[cast( long, a )].data )]
    dim as Tko.ListPayload ptr lb = _
        @w.ast->lists[cast( long, w.ast->nodes[cast( long, b )].data )]
    for i as long = 0 to na - 1
        dim as Tko.NodeId da = cast( Tko.NodeId, w.ast->children[la->first + i] )
        dim as Tko.NodeId db = cast( Tko.NodeId, w.ast->children[lb->first + i] )
        '' 'a(9)' is a bare expression -- the upper bound -- and 'a(0 to 9)' is an
        '' N_CASE_RANGE. A mix of the two spellings is left alone rather than guessed at.
        '' 'any' marks a VAR-LEN dimension. Measured: 'extern a(any)' against
        '' 'dim a(0 to 2)' is fbc error 54, so ANY on one side and a bound on the other
        '' is a difference -- while ANY on both is agreement.
        dim as boolean aa = IsAnyBound_( w, da )
        dim as boolean ab = IsAnyBound_( w, db )
        if aa <> ab then return false
        if aa then continue for

        dim as boolean ra = (w.ast->Kind( da ) = Tko.N_CASE_RANGE)
        dim as boolean rb = (w.ast->Kind( db ) = Tko.N_CASE_RANGE)
        if ra <> rb then continue for
        if ra then
            dim as Tko.StmtPayload ptr sa = StmtOf( w, da )
            dim as Tko.StmtPayload ptr sb = StmtOf( w, db )
            if SameLiteral_( w, sa->a, sb->a ) = false then return false
            if SameLiteral_( w, sa->b, sb->b ) = false then return false
        else
            if SameLiteral_( w, da, db ) = false then return false
        end if
    next
    return true
end function

'' Two constants' initialisers. Compared only when both are integer literals; anything
'' else counts as agreeing, the same permissive rule the shape comparison uses. That
'' can accept a pair fbc would reject -- 'const X = f( 1 )' written twice with different
'' f -- and accepting is the direction that does not lose a working file.
private function SameConstValue_ _
    ( byref w as Walker, byval a as Tko.NodeId, byval b as Tko.NodeId ) as boolean

    if (a = Tko.NODE_NONE) orelse (b = Tko.NODE_NONE) then return true
    dim as Tko.StmtPayload ptr ap = StmtOf( w, a )
    dim as Tko.StmtPayload ptr bp = StmtOf( w, b )
    return SameLiteral_( w, ap->b, bp->b )
end function

'' A VAR-LEN bounds list: none written at all, or every dimension 'any'. Anything with
'' a real bound in it is FIXED, and the two are never the same shape.
private function IsVarLenBounds_( byref w as Walker, byval id as Tko.NodeId ) as boolean
    dim as long n = DimCount_( w, id )
    if n = 0 then return true
    dim as Tko.ListPayload ptr lp = _
        @w.ast->lists[cast( long, w.ast->nodes[cast( long, id )].data )]
    for i as long = 0 to n - 1
        if IsAnyBound_( w, cast( Tko.NodeId, w.ast->children[lp->first + i] ) ) = false then
            return false
        end if
    next
    return true
end function

'' The 'any' of 'a( any )', which arrives as an ordinary identifier.
private function IsAnyBound_( byref w as Walker, byval id as Tko.NodeId ) as boolean
    if id = Tko.NODE_NONE then return false
    if w.ast->Kind( id ) <> Tko.N_IDENT then return false
    dim as Tko.InternId nm = _
        w.ast->idents[cast( long, w.ast->nodes[cast( long, id )].data )].name
    return (w.names->Spelling( nm ) = "any")
end function

'' Equal when BOTH are integer literals and differ; otherwise "cannot tell", which
'' counts as agreeing.
private function SameLiteral_ _
    ( byref w as Walker, byval a as Tko.NodeId, byval b as Tko.NodeId ) as boolean

    dim as longint av = 0, bv = 0
    if LiteralLen_( w, a, av ) = false then return true
    if LiteralLen_( w, b, bv ) = false then return true
    return (av = bv)
end function

'' Two written type references, compared as far as syntax allows.
private function SameTypeRef_ _
    ( byref w as Walker, byval a as Tko.NodeId, byval b as Tko.NodeId ) as boolean

    if (a = Tko.NODE_NONE) orelse (b = Tko.NODE_NONE) then return true
    if (w.ast->Kind( a ) <> Tko.N_TYPEREF) orelse (w.ast->Kind( b ) <> Tko.N_TYPEREF) then
        return true
    end if
    dim as Tko.StmtPayload ptr ap = StmtOf( w, a )
    dim as Tko.StmtPayload ptr bp = StmtOf( w, b )

    '' The builtin keyword, or 0 for a named type. A different builtin is fbc error 4.
    '' The builtin keyword -- but only when BOTH sides wrote one. A named type has
    '' op = TK_IDENT and may be a TYPEDEF for the builtin on the other side, which is
    '' exactly the ULONG / CULONG pair below, so comparing across the two kinds
    '' rejects a legal restatement.
    dim as boolean aNamed = (ap->op = cast( ushort, Tko.TK_IDENT ))
    dim as boolean bNamed = (bp->op = cast( ushort, Tko.TK_IDENT ))
    if (aNamed = false) andalso (bNamed = false) then
        if ap->op <> bp->op then return false
    end if
    '' A NAMED type is NOT compared, even when both sides name something and the
    '' spellings differ. Two names can be one type through a typedef, and Collect has
    '' no types to ask -- crt/io.bi and crt/win32/wchar.bi both declare
    ''
    ''     #ifndef _fsize_t
    ''     type _fsize_t as ulong        (io.bi)
    ''     type _fsize_t as culong       (wchar.bi)
    ''     #endif
    ''
    '' with NOTHING ever defining _fsize_t, so both guards fire and both declarations
    '' happen. fbc accepts them because CULONG is a typedef for ULONG on Windows; a
    '' comparison on spellings cannot see that and rejected four corpus files.
    ''
    '' Nothing is lost that the corpus checks: its duplicate tests differ by BUILTIN
    '' type, which the 'op' comparison above catches, and by array shape and string
    '' length, which are compared below.

    '' 'zstring * 4' against 'zstring * 8' -- fbc error 20. Only comparable when both
    '' lengths are integer literals; anything else is left alone.
    '' The fixed length is in 'c', NOT 'a' -- 'a' is the ELEMENT type reference, and
    '' reading one for the other compared a length against a type and found them equal.
    dim as longint alen = 0, blen = 0
    dim as boolean aHas = LiteralLen_( w, ap->c, alen )
    dim as boolean bHas = LiteralLen_( w, bp->c, blen )
    if aHas andalso bHas andalso (alen <> blen) then return false
    '' One written and one not is a difference too: 'zstring * 4' is not 'zstring'.
    if aHas <> bHas then return false

    '' PTR nests another N_TYPEREF in 'a'; recursing compares the pointed-to type and,
    '' by arriving at different depths, the pointer depth too.
    return SameTypeRef_( w, ap->a, bp->a )
end function

'' The integer literal a fixed-length string's size was written as, if it was one.
private function LiteralLen_ _
    ( byref w as Walker, byval id as Tko.NodeId, byref outv as longint ) as boolean

    if id = Tko.NODE_NONE then return false
    if w.ast->Kind( id ) <> Tko.N_INT_LIT then return false
    outv = w.ast->literals[cast( long, w.ast->nodes[cast( long, id )].data )].intValue
    return true
end function

declare sub WalkNode _
    ( byref w as Walker, byval id as Tko.NodeId, byval scope_ as Tko.ScopeId )
declare function Effective_( byval c as Tko.CallConv ) as Tko.CallConv
declare sub BindCallConv _
    ( byref w as Walker, byval s as Tko.Symbol ptr, _
      byval sp as Tko.StmtPayload ptr, byval id as Tko.NodeId, _
      byval firstSighting as boolean )
declare function ProcArity _
    ( byref w as Walker, byval sp as Tko.StmtPayload ptr ) as long
declare function UndefinedProcWithArity _
    ( byref w as Walker, byval scope_ as Tko.ScopeId, byval nm as Tko.InternId, _
      byval want as long ) as Tko.SymbolId
declare function MemberDeclForDef_ _
    ( byref w as Walker, byval scope_ as Tko.ScopeId, byval nm as Tko.InternId, _
      byval sp as Tko.StmtPayload ptr ) as Tko.SymbolId


'' A possibly-dotted owner name -- 'Widget', 'ns.UDT', 'a.b.UDT' -- resolved to its
'' symbol. Only the FIRST component is visible from the starting scope; each later one
'' is looked up INSIDE what the previous opened.
private function LookupDottedOwner_ _
    ( byref w as Walker, byval scope_ as Tko.ScopeId, _
      byval path as Tko.InternId ) as Tko.SymbolId

    dim as string qpath = w.names->Spelling( path )
    if instr( qpath, "." ) = 0 then
        return w.syms->LookupTyped( scope_, path, true )
    end if

    dim as Tko.ScopeId sc = scope_
    dim as boolean first_ = true
    dim as long at = 0
    dim as Tko.SymbolId found = Tko.SYMBOL_NONE
    while at <= len( qpath )
        dim as long dot = instr( at + 1, qpath, "." )
        dim as long stop_ = dot
        if stop_ = 0 then stop_ = len( qpath ) + 1
        dim as string comp = mid( qpath, at + 1, stop_ - at - 1 )
        if len( comp ) = 0 then return Tko.SYMBOL_NONE
        dim as Tko.InternId cid = w.names->Fold( w.names->GetString( comp ) )

        dim as Tko.SymbolId sid
        if first_ then
            sid = w.syms->LookupTyped( sc, cid, true )
        else
            sid = w.syms->LookupLocalTyped( sc, cid, true )
        end if
        dim as Tko.Symbol ptr sym = w.syms->SymbolAt( sid )
        if sym = 0 then return Tko.SYMBOL_NONE
        found = sid
        first_ = false
        if dot = 0 then exit while
        if sym->inner = Tko.SCOPE_NONE then return Tko.SYMBOL_NONE
        sc = sym->inner
        at = dot
    wend
    return found
end function

private sub WalkChildren _
    ( byref w as Walker, byval first as long, byval count as long, _
      byval scope_ as Tko.ScopeId )

    for i as long = 0 to count - 1
        WalkNode( w, cast( Tko.NodeId, w.ast->children[first + i] ), scope_ )
    next
end sub

sub WalkNode _
    ( byref w as Walker, byval id as Tko.NodeId, byval scope_ as Tko.ScopeId )

    if id = Tko.NODE_NONE then return
    dim as Tko.NodeKind k = w.ast->Kind( id )
    dim as Tko.AstNode ptr n = @w.ast->nodes[cast( long, id )]

    '' Resolve re-walks this tree and must land in the SAME scopes. Recording them
    '' here is cheaper and far less fragile than duplicating the traversal rules.
    w.info->SetScope( id, scope_ )

    select case k
    case Tko.N_MODULE, Tko.N_BLOCK
        dim as Tko.ListPayload ptr lp = ListOf( w, id )
        WalkChildren( w, lp->first, lp->count, scope_ )

    case Tko.N_VAR, Tko.N_CONST
        '' The items carry the names; the declaration itself carries the storage.
        dim as Tko.StmtPayload ptr sp = StmtOf( w, id )
        '' REDIM re-dimensions an EXISTING array. It is not a declaration, and treating
        '' it as one reported every 'redim a(...)' as a duplicate.
        ''
        '' EXCEPT WITH AN 'AS' CLAUSE. 'redim foo( 1 to 2 ) as integer' declares foo AND
        '' sizes it -- it is how a dynamic array is brought into existence in one line,
        '' and the corpus's own redim test writes nothing else. Skipping those declared
        '' nothing, so lowering had no symbol, no type and no descriptor to build, and
        '' every one produced no code at all.
        ''
        '' The type clause is what tells the two apart, and it has to be read off the
        '' ITEM rather than the statement: 'redim as long baz( 0 to 2 )' puts it there
        '' too, and both spellings mean the same thing.
        if sp->op = cast( ushort, Tko.KW_REDIM ) then
            dim as boolean declares = false
            for i as long = 0 to sp->count - 1
                dim as Tko.NodeId it2 = cast( Tko.NodeId, w.ast->children[sp->first + i] )
                if w.ast->Kind( it2 ) <> Tko.N_VAR_ITEM then continue for
                if StmtOf( w, it2 )->a <> Tko.NODE_NONE then declares = true
            next
            if declares = false then return
        end if
        for i as long = 0 to sp->count - 1
            dim as Tko.NodeId item = cast( Tko.NodeId, w.ast->children[sp->first + i] )
            if w.ast->Kind( item ) <> Tko.N_VAR_ITEM then continue for
            dim as Tko.AstNode ptr itemNode = @w.ast->nodes[cast( long, item )]
            '' 'dim UDT.i as integer' DEFINES a static member declared inside the
            '' type; it does not declare 'i' out here.
            if (itemNode->flags and Tko.NF_QUALIFIED) <> 0 then continue for
            dim as Tko.StmtPayload ptr ip = StmtOf( w, item )
            dim as Tko.SymbolKind sk = Tko.SYM_VARIABLE
            if k = Tko.N_CONST then sk = Tko.SYM_CONSTANT

            '' An EXTERN is a FORWARD DECLARATION, not a definition: 'extern a as
            '' integer' followed by 'dim shared a as integer' is one variable, and so
            '' is the same EXTERN written twice. Measured -- fbc accepts both, and
            '' rejects only when the two disagree about the TYPE (error 4), the array
            '' shape (error 54) or a fixed string's length (error 20).
            ''
            '' So the redeclaration is allowed exactly when the written shapes agree.
            '' The 29 corpus files that exist to check those three disagreements were
            '' passing by ACCIDENT, because tiko-lang rejected the whole construct; they have
            '' to keep failing, for the right reason now.
            '' An IDENTICAL constant is not a duplicate either -- same type AND same
            '' value. Measured: 'const I1 = 0' twice is accepted, a different VALUE is
            '' fbc error 4, and so is the same value at a different type. A VARIABLE is
            '' never redeclarable, which is why this is the CONST branch alone.
            if sk = Tko.SYM_CONSTANT then
                dim as Tko.SymbolId prevC = _
                    w.syms->LookupLocalTyped( scope_, ip->name, false )
                dim as Tko.Symbol ptr pcs = w.syms->SymbolAt( prevC )
                if pcs <> 0 then
                    if pcs->kind = cast( ubyte, Tko.SYM_CONSTANT ) then
                        dim as Tko.NodeId prevItem = cast( Tko.NodeId, pcs->payload )
                        if SameDeclShape_( w, prevItem, item ) then
                            if SameConstValue_( w, prevItem, item ) then continue for
                        end if
                    end if
                end if
            end if

            '' A RE-DECLARING REDIM OVER AN ARRAY THAT ALREADY EXISTS is not a
            '' duplicate. Measured:
            ''
            ''   dim a( ) as long : redim a( 0 to 9 ) as long      accepted
            ''   dim b( ) as long : redim b( 0 to 9 ) as string    error 4
            ''
            '' -- the same "allowed exactly when the written shapes agree" rule the
            '' EXTERN merge below uses, and 'dim a( ) as T' followed by
            '' 'redim a( 0 to 9 ) as T' is what fbc-int/array-size.bas writes for every
            '' element type there is. Reporting it left 24 errors in that one file.
            if (sk = Tko.SYM_VARIABLE) andalso _
               (sp->op = cast( ushort, Tko.KW_REDIM )) then
                dim as Tko.SymbolId prevR = _
                    w.syms->LookupLocalTyped( scope_, ip->name, false )
                dim as Tko.Symbol ptr prs = w.syms->SymbolAt( prevR )
                if prs <> 0 then
                    if prs->kind = cast( ubyte, Tko.SYM_VARIABLE ) then
                        dim as Tko.NodeId prevIt = cast( Tko.NodeId, prs->payload )
                        '' The BOUNDS are what a redim exists to change, so only the
                        '' element TYPE has to agree -- and the previous declaration
                        '' has to be a DYNAMIC array, which is what 'a( )' and
                        '' 'a( any, any )' are and 'a( 0 to 3 )' is not.
                        if IsDynArrayItem_( w, prevIt ) then
                            dim as Tko.StmtPayload ptr pip = StmtOf( w, prevIt )
                            if SameTypeRef_( w, pip->a, ip->a ) then continue for
                        end if
                    end if
                end if
            end if

            dim as boolean isExtern = (sp->op = cast( ushort, Tko.KW_EXTERN ))
            if sk = Tko.SYM_VARIABLE then
                dim as Tko.SymbolId prev = _
                    w.syms->LookupLocalTyped( scope_, ip->name, false )
                dim as Tko.Symbol ptr ps = w.syms->SymbolAt( prev )
                if ps <> 0 then
                    dim as boolean prevExtern = ((ps->flags and Tko.SYMF_EXTERN) <> 0)
                    dim as boolean mergeable = _
                        (ps->kind = cast( ubyte, Tko.SYM_VARIABLE )) andalso _
                        (isExtern orelse prevExtern)
                    '' BYREF is on the DECLARATION, not the item: 'extern byref ri as
                    '' integer' against 'dim shared ri as integer' is fbc error 20, and
                    '' the two items look identical. The flag is carried on the symbol,
                    '' which is the only place both declarations can be compared from.
                    dim as boolean prevByref = ((ps->flags and Tko.SYMF_BYREF) <> 0)
                    dim as boolean thisByref = ((n->flags and Tko.NF_BYREF) <> 0)
                    if prevByref <> thisByref then mergeable = false
                    if mergeable then
                        if SameDeclShape_( w, cast( Tko.NodeId, ps->payload ), item ) then
                            if (n->flags and Tko.NF_SHARED) <> 0 then
                                ps->flags or= Tko.SYMF_SHARED
                            end if
                            '' The DEFINITION owns the symbol from here: its item is
                            '' what carries the initializer, and it is no longer extern.
                            if isExtern = false then
                                ps->flags and= not Tko.SYMF_EXTERN
                                ps->payload = cast( long, item )
                            end if
                            continue for
                        end if
                    end if
                end if
            end if

            dim as Tko.SymbolId sid = Declare_( w, scope_, ip->name, sk, _
                                                w.ast->Loc( item ) )
            dim as Tko.Symbol ptr s = w.syms->SymbolAt( sid )
            if s <> 0 then
                if (n->flags and Tko.NF_SHARED) <> 0 then s->flags or= Tko.SYMF_SHARED
                if (n->flags and Tko.NF_STATIC) <> 0 then s->flags or= Tko.SYMF_STATIC
                '' ...and from the ITEM as well, for a 'byref' written again after a
                '' comma, which belongs to that item rather than to the declaration.
                if ((n->flags or w.ast->nodes[cast( long, item )].flags) and _
                    Tko.NF_BYREF) <> 0 then s->flags or= Tko.SYMF_BYREF
                if isExtern then s->flags or= Tko.SYMF_EXTERN
                if k = Tko.N_CONST then s->flags or= Tko.SYMF_CONST
                s->payload = cast( long, item )
            end if
        next

    case Tko.N_TYPE
        dim as Tko.StmtPayload ptr sp = StmtOf( w, id )
        '' An ANONYMOUS union or type declares nothing and opens no scope: its
        '' members are members of the ENCLOSING aggregate, which is the whole point
        '' of writing one.
        if sp->name = 0 then
            '' An anonymous UNION's members overlap; an anonymous TYPE's are
            '' sequential. The distinction has to survive the splice, or the layout
            '' pass cannot tell them apart afterwards.
            '' An anonymous aggregate is SPLICED into the enclosing type, so its
            '' members become siblings of the enclosing type's own. The nesting they
            '' lose is recorded on each field instead: one more level of anonymity,
            '' and whether THIS level overlaps.
            dim as boolean saved = w.inUnion
            dim as boolean savedFirst = w.unionFirst
            dim as long savedDepth = w.anonDepth
            w.inUnion = ((n->flags and Tko.NF_IS_UNION) <> 0)
            w.anonDepth = savedDepth + 1
            '' Every anonymous group marks its OWN first field -- union or type alike --
            '' so the layout can tell two adjacent groups apart.
            w.unionFirst = true
            WalkChildren( w, sp->first, sp->count, scope_ )
            w.inUnion = saved
            w.unionFirst = savedFirst
            w.anonDepth = savedDepth
            return
        end if
        dim as Tko.SymbolId sid = Declare_( w, scope_, sp->name, Tko.SYM_UDT, _
                                            w.ast->Loc( id ) )
        dim as Tko.ScopeId inner = w.syms->OpenScope( Tko.SCOPEK_TYPE, scope_, sid )
        dim as Tko.Symbol ptr s = w.syms->SymbolAt( sid )
        if s <> 0 then
            s->inner = inner
            '' The layout needs the aggregate's KIND, and nothing else recorded it.
            if (n->flags and Tko.NF_IS_UNION) <> 0 then s->flags or= Tko.SYMF_UNION_KIND
            '' The TypeId exists from the DECLARATION, not from the first use: a
            '' member's signature can name its own type, so waiting would deadlock.
            s->type_ = w.types->NamedType( Tko.TK_UDT, sp->name, cast( ulong, scope_ ) )
            '' The DECLARATION NODE, so a generic can be instantiated later: Resolve
            '' needs the parameter names and the field list, and the symbol is the
            '' only handle it has on them.
            s->payload = cast( long, id )
            '' And the SYMBOL on the node, so the reverse lookup does not have to go
            '' by name. An instantiation is declared in the GLOBAL scope while its
            '' generic sits in a module or namespace scope BELOW it, so a name lookup
            '' from the instantiation's own scope walks the wrong way and finds
            '' nothing.
            w.info->SetRef( id, sid )
            if sp->extra > 0 then
                w.types->SetPacking( s->type_, cast( long, sp->extra ) )
            end if
        end if
        w.info->SetScope( id, inner )

        '' A NAMED union overlaps its members exactly as an anonymous one does. Only
        '' the anonymous SPLICE was marking them, so 'union U : a as ulongint : b as
        '' ulongint : c as ulongint : end union' came out 24 bytes where fbc says 8 --
        '' laid out sequentially, silently, with no diagnostic and no gate to catch it.
        '' check-udt's 24 shapes did not include a named union.
        dim as boolean savedU = w.inUnion
        dim as boolean savedUF = w.unionFirst
        dim as long savedD = w.anonDepth
        w.inUnion = ((n->flags and Tko.NF_IS_UNION) <> 0)
        w.unionFirst = false
        w.anonDepth = 0
        WalkChildren( w, sp->first, sp->count, inner )
        w.inUnion = savedU
        w.unionFirst = savedUF
        w.anonDepth = savedD

    case Tko.N_FIELD
        dim as Tko.StmtPayload ptr sp = StmtOf( w, id )
        dim as Tko.SymbolId fid = Declare_( w, scope_, sp->name, Tko.SYM_FIELD, _
                                            w.ast->Loc( id ) )
        '' Recorded for EVERY field, not only a union's: the layout needs the depth
        '' of a sequential anonymous group as much as an overlapping one.
        dim as Tko.Symbol ptr fs = w.syms->SymbolAt( fid )
        if fs <> 0 then
            '' THE FIELD'S OWN NODE, so a later pass can reach its typeref. A field
            '' whose type is 'typeof( EXPR )' cannot be typed before Check -- Resolve has
            '' no expression types -- and without a way back to the declaration there is
            '' nothing for Check to fill in. Left untyped it does not merely lower badly:
            '' ComputeUdtLayouts refuses the WHOLE UDT, which vanishes from the type
            '' table with nothing said. See InferUnusedVarTypes_.
            ''
            '' A BITFIELD's payload is its WIDTH IN BITS, written by Resolve, and that
            '' overwrites this -- which is right: a bitfield's type is spelled out and
            '' never needs inferring.
            fs->payload = cast( long, id )
            fs->anonDepth = cast( ubyte, w.anonDepth )
            if w.inUnion then fs->flags or= Tko.SYMF_UNION
            if w.unionFirst then fs->flags or= Tko.SYMF_UNION_FIRST
        end if
        w.unionFirst = false

    case Tko.N_ENUM
        dim as Tko.StmtPayload ptr sp = StmtOf( w, id )
        dim as Tko.SymbolId sid = Declare_( w, scope_, sp->name, Tko.SYM_ENUM, _
                                            w.ast->Loc( id ) )
        '' Enum constants land in the ENCLOSING scope, as in FreeBASIC: 'Red' is
        '' usable without qualification.
        dim as Tko.Symbol ptr s = w.syms->SymbolAt( sid )
        if s <> 0 then
            s->inner = scope_
            s->type_ = w.types->NamedType( Tko.TK_ENUM, sp->name, cast( ulong, scope_ ) )
        end if
        WalkChildren( w, sp->first, sp->count, scope_ )

    case Tko.N_ENUM_ITEM
        dim as Tko.StmtPayload ptr sp = StmtOf( w, id )
        Declare_( w, scope_, sp->name, Tko.SYM_ENUMCONST, w.ast->Loc( id ) )

    case Tko.N_TYPEDEF
        dim as Tko.StmtPayload ptr sp = StmtOf( w, id )

        '' An IDENTICAL typedef is not a duplicate. Measured:
        ''
        ''     type INT_ as long   twice          accepted
        ''     type INT_ as long / as double      fbc error 4
        ''     an identical UDT BODY twice        fbc error 4
        ''
        '' The Windows headers rely on it: 'type INT_ as long' appears in ntdef.bi,
        '' windef.bi AND winnt.bi, and 14 corpus files include more than one of them.
        '' Same rule family as the identical '#define' -- an ALIAS may be restated, a
        '' DEFINITION may not.
        dim as Tko.SymbolId prevT = w.syms->LookupLocalTyped( scope_, sp->name, true )
        dim as Tko.Symbol ptr pts = w.syms->SymbolAt( prevT )
        if pts <> 0 then
            if pts->kind = cast( ubyte, Tko.SYM_TYPEDEF ) then
                if SameTypeRef_( w, cast( Tko.NodeId, pts->payload ), sp->a ) then
                    for i as long = 0 to sp->count - 1
                        WalkNode( w, cast( Tko.NodeId, w.ast->children[sp->first + i] ), scope_ )
                    next
                    return
                end if
            end if
        end if

        dim as Tko.SymbolId tid = Declare_( w, scope_, sp->name, Tko.SYM_TYPEDEF, _
                                            w.ast->Loc( id ) )
        dim as Tko.Symbol ptr ts = w.syms->SymbolAt( tid )
        if ts <> 0 then
            ts->type_ = w.types->NamedType( Tko.TK_TYPEDEF, sp->name, cast( ulong, scope_ ) )
            '' The type reference, so a later identical typedef can be compared to it.
            ts->payload = cast( long, sp->a )
        end if
        '' 'type as integer a, b' -- every name after the first is a child N_TYPEDEF
        '' sharing the same type reference.
        for i as long = 0 to sp->count - 1
            WalkNode( w, cast( Tko.NodeId, w.ast->children[sp->first + i] ), scope_ )
        next

    case Tko.N_PROC
        dim as Tko.StmtPayload ptr sp = StmtOf( w, id )
        '' 'sub Stack.Push( )' DEFINES a member declared elsewhere; it does not
        '' declare 'Push' in the enclosing scope. Binding it to the right type is
        '' Resolve's job, so Collect only opens a scope for its parameters.
        '' A constructor or destructor names its TYPE. There is no dot to mark it
        '' qualified, so the keyword is what identifies it as a member definition.
        dim as boolean isCtorDtor = (sp->op = cast( ushort, Tko.KW_CONSTRUCTOR )) orelse _
                                    (sp->op = cast( ushort, Tko.KW_DESTRUCTOR ))
        dim as boolean isMemberDef = ((n->flags and Tko.NF_QUALIFIED) <> 0) orelse isCtorDtor
        '' A constructor or destructor has no name of its own -- 'declare
        '' constructor( )' names nothing and 'constructor T( )' names the TYPE -- so
        '' neither was ever declared as a symbol, and nothing could find them. They
        '' get a synthetic name in the type's scope, which also makes overloaded
        '' constructors chain like any other overload set.
        dim as Tko.InternId declName = sp->name
        if isCtorDtor then
            if sp->op = cast( ushort, Tko.KW_CONSTRUCTOR ) then
                declName = w.names->Fold( w.names->GetString( "__ctor" ) )
            else
                declName = w.names->Fold( w.names->GetString( "__dtor" ) )
            end if
        end if

        dim as Tko.SymbolId sid = Tko.SYMBOL_NONE
        if isMemberDef = false then
            '' A DEFINITION joins its DECLARE rather than chaining beside it. Without
            '' this, 'declare sub F( byval x as long )' followed by 'sub F( byval x as
            '' long )' produced TWO symbols with identical signatures, so every call to
            '' F was AMBIGUOUS and resolved to nothing -- which is most real programs,
            '' and went unnoticed because the corpus's procedures are declared in a
            '' header and defined in a library it never compiles.
            if sp->b <> Tko.NODE_NONE then
                sid = UndefinedProcWithArity( w, scope_, declName, ProcArity( w, sp ) )
            end if
            if sid = Tko.SYMBOL_NONE then
                sid = Declare_( w, scope_, declName, Tko.SYM_PROC, w.ast->Loc( id ) )
            end if
        end if
        '' OVERLOAD BELONGS TO THE NAME, NOT TO THE DECLARATION THAT SPELLED IT.
        ''
        '' Measured: a definition that does not repeat the keyword still mangles as an
        '' overload -- fbc emits '_Z2PRi' for 'function pr( byval p as long )' when the
        '' DECLARE said 'overload'. tiko-lang mangled that definition as the bare name
        '' 'PR', so the definition and every call site named two different symbols; and
        '' because the two also mangled differently, nothing downstream could recognise
        '' them as one procedure and the call resolved to NOTHING.
        SpreadOverloadFlag_( w, scope_, declName, id )

        dim as Tko.Symbol ptr s = w.syms->SymbolAt( sid )
        if s <> 0 then
            if sp->b = Tko.NODE_NONE then
                s->flags or= Tko.SYMF_DECLARED
            else
                s->flags or= Tko.SYMF_DEFINED
            end if
            '' The DECLARATION's node stays the payload: it carries the signature every
            '' call site mangles against, and a declaration mangles identically to its
            '' definition. Its absence is also how the FIRST sighting is recognised,
            '' which is what BindCallConv needs -- the first one records, later ones
            '' must agree.
            dim as boolean firstSighting = (s->payload = 0)
            if firstSighting then s->payload = cast( long, id )
            BindCallConv( w, s, sp, id, firstSighting )
        end if

        '' 'sub Widget.Method( )' defines a member: its scope PARENT is the type's
        '' scope, not the module's. That is what makes 'this', the sibling fields and
        '' the mangled name _ZN6WIDGET6METHODEi all come out right -- an unqualified
        '' member body resolves its own fields by ordinary scope lookup.
        dim as Tko.ScopeId parentScope = scope_
        if isMemberDef then
            '' A CONSTRUCTOR'S OWNER IS ITS LAST COMPONENT, not the one before it.
            '' 'constructor ns.UDT( )' has ownerName 'ns' and name 'UDT': the type is
            '' UDT and the namespace is only how to reach it. Taking ownerName here
            '' opened the body under the NAMESPACE, so BindThis found no enclosing type
            '' scope, 'this' stayed untyped, and its receiver store went into a VOID
            '' slot -- which the MIR verifier reported for twelve corpus files.
            ''
            '' An ordinary member is the other way round: 'sub Widget.Draw( )' has
            '' owner Widget and name Draw.
            dim as Tko.InternId ownerNm = sp->ownerName
            if isCtorDtor then
                if sp->ownerName = 0 then
                    ownerNm = sp->name
                else
                    ownerNm = w.names->GetString( _
                        w.names->Spelling( sp->ownerName ) & "." & _
                        w.names->Spelling( sp->name ) )
                end if
            end if
            if ownerNm <> 0 then
                '' The owner is a TYPE name -- 'sub Widget.Draw( )' -- so a variable
                '' sharing the spelling must not be picked up instead. The name may be
                '' a PATH, which is walked a component at a time.
                dim as Tko.SymbolId osid = LookupDottedOwner_( w, scope_, ownerNm )
                dim as Tko.Symbol ptr os = w.syms->SymbolAt( osid )
                if os <> 0 then
                    if os->inner <> Tko.SCOPE_NONE then parentScope = os->inner
                elseif isCtorDtor then
                    '' A STRUCTOR WHOSE OWNER IS NOT VISIBLE HERE. 'constructor UDT( )'
                    '' written outside the namespace that declares UDT is fbc error
                    '' 160, and eight corpus files exist to assert it. tiko-lang accepted it
                    '' silently, opened the body at module scope, and left 'this'
                    '' untyped -- which surfaced as a verify failure much later with
                    '' nothing to say where it came from.
                    ''
                    '' Only a STRUCTOR: an ordinary 'sub Widget.Draw( )' whose owner is
                    '' unknown may be defining a member of a type from a header this
                    '' build did not read, and that stays silent deliberately.
                    w.diags->Report( Tko.TKO0323, _
                        Tko.PointRange( w.ast->Loc( id ) ), _
                        w.names->Spelling( ownerNm ) )
                end if
            end if
        end if

        '' A ctor/dtor DEFINITION joins the declaration that is already in the
        '' type's scope, so a call site finds one symbol with a body rather than two
        '' halves of one.
        if isCtorDtor andalso (sid = Tko.SYMBOL_NONE) then
            '' A DECLARATION always creates a link, so the overloads chain and each
            '' keeps its own signature. Looking one up first made every 'declare
            '' constructor( ... )' reuse the first symbol, leaving a chain of one and
            '' every constructor call resolving to whichever came first.
            ''
            '' A DEFINITION attaches to what is already there instead, so a call site
            '' finds one symbol rather than two halves of one.
            if sp->b = Tko.NODE_NONE then
                sid = Declare_( w, parentScope, declName, Tko.SYM_PROC, _
                                w.ast->Loc( id ) )
            else
                sid = w.syms->LookupLocal( parentScope, declName )
                if sid = Tko.SYMBOL_NONE then
                    sid = Declare_( w, parentScope, declName, Tko.SYM_PROC, _
                                    w.ast->Loc( id ) )
                end if
            end if
            s = w.syms->SymbolAt( sid )
            if s <> 0 then
                BindCallConv( w, s, sp, id, (s->payload = 0) )
                s->flags or= Tko.SYMF_DEFINED
                '' The payload is NOT overwritten. Every 'constructor T( ... )'
                '' definition looks up the same head-of-chain symbol, so writing the
                '' node here made all three overloads point at whichever was defined
                '' last -- and every constructor call resolved to that one. The
                '' DECLARATIONS carry the signatures, and a declaration node mangles
                '' identically to its definition, so they are what call sites use.
                if s->payload = 0 then s->payload = cast( long, id )
            end if
        end if

        '' Parameters and locals live in the procedure's own scope.
        ''
        '' A member DEFINITION -- 'sub T.M( )' -- declares nothing: the declaration
        '' inside the type already carries the symbol, its flags and its payload. But
        '' the scope still needs an OWNER, or it is a proc scope belonging to no
        '' procedure, and anything walking outward to ask "which procedure am I in"
        '' gets no answer. __FUNCTION__ inside a method is what found this.
        dim as Tko.SymbolId scopeOwner = sid
        if (scopeOwner = Tko.SYMBOL_NONE) andalso (declName <> 0) then
            '' THE OVERLOAD IT DEFINES, not the head of the chain.
            ''
            '' A member DEFINITION declares no symbol of its own, so it has to be
            '' matched to one of the DECLARATIONS inside the type -- and a bare lookup
            '' answers the first one, whatever it was declared as. A type with two cast
            '' operators is the shape that shows it: 'operator TV.cast() as TU' bound to
            '' the 'as string' declaration, so the procedure's RETURN TYPE came from one
            '' overload while its MANGLED NAME came from the other -- which mangle.bas
            '' takes from the definition node. The TU operator then lowered as though it
            '' returned a string and declined, and the same disagreement over an
            '' ordinary overloaded method DID NOT decline: it emitted a function that
            '' returns an integer declared as returning a string descriptor.
            scopeOwner = MemberDeclForDef_( w, parentScope, declName, sp )
        end if
        dim as Tko.ScopeId inner = w.syms->OpenScope( Tko.SCOPEK_PROC, parentScope, _
                                                      scopeOwner )
        '' The DEFINITION's scope is the one that owns THIS and the locals, so it is the
        '' one the symbol points at. A member definition declares no symbol of its own,
        '' so 's' is null there and only 'scopeOwner' names it -- and without this the
        '' body's scope was reachable from nothing and 'this' could not be found.
        if s <> 0 then
            s->inner = inner
        elseif scopeOwner <> Tko.SYMBOL_NONE then
            dim as Tko.Symbol ptr os = w.syms->SymbolAt( scopeOwner )
            if os <> 0 then os->inner = inner
        end if
        '' A member definition body may say 'this'. The receiver is implicit -- it is
        '' never written as a parameter -- so nothing else would ever declare it.
        '' Giving it the OWNING type is Resolve's job; existing is Collect's.
        if isMemberDef then
            Declare_( w, inner, w.names->Fold( w.names->GetString( "this" ) ), _
                      Tko.SYM_PARAMETER, w.ast->Loc( id ) )
        end if
        w.info->SetScope( id, inner )
        '' 'scopeOwner', not 'sid': a member DEFINITION declares no symbol of its own,
        '' so sid is NONE there and the node would carry no reference at all. Lowering
        '' reads this to find the procedure it is in, and without it __FUNCTION__ inside
        '' a method lowered to an UNDEF that the call around it happily passed.
        if scopeOwner <> Tko.SYMBOL_NONE then w.info->SetRef( id, scopeOwner )
        WalkChildren( w, sp->first, sp->count, inner )
        if sp->b <> Tko.NODE_NONE then WalkNode( w, sp->b, inner )

    case Tko.N_PARAM
        dim as Tko.StmtPayload ptr sp = StmtOf( w, id )
        Declare_( w, scope_, sp->name, Tko.SYM_PARAMETER, w.ast->Loc( id ) )

    case Tko.N_NAMESPACE
        dim as Tko.StmtPayload ptr sp = StmtOf( w, id )

        '' AN ANONYMOUS NAMESPACE is a real, CLOSED scope with no symbol of its own --
        '' C++'s rule, and fbc's: measured, a sub declared in one is 'Variable not
        '' declared' from outside, and TWO of them in a file do not collide, so each
        '' opens a FRESH scope rather than reopening.
        ''
        '' Declare_ refuses a nameless symbol, so 's' came back null, no scope was
        '' opened, and THE CHILDREN WERE NEVER WALKED AT ALL: everything inside was
        '' undeclared, and a recursive call within it bound to nothing. 1,016 unlowered
        '' calls in one corpus file are that, all of them 'f( N )' inside
        '' 'namespace : private sub f( ... )'.
        if sp->name = 0 then
            dim as Tko.ScopeId anon = _
                w.syms->OpenScope( Tko.SCOPEK_NAMESPACE, scope_, Tko.SYMBOL_NONE )
            w.info->SetScope( id, anon )
            WalkChildren( w, sp->first, sp->count, anon )
            return
        end if

        '' A NAMED namespace REOPENS rather than redeclares: if the name is already a
        '' namespace in this scope, keep collecting into its existing scope.
        dim as Tko.SymbolId sid = w.syms->LookupLocal( scope_, sp->name )
        dim as Tko.Symbol ptr s = w.syms->SymbolAt( sid )
        dim as boolean reopen = (s <> 0) andalso (s->kind = cast( ubyte, Tko.SYM_NAMESPACE ))
        if reopen = false then
            sid = Declare_( w, scope_, sp->name, Tko.SYM_NAMESPACE, w.ast->Loc( id ) )
            s = w.syms->SymbolAt( sid )
            if s <> 0 then
                s->inner = w.syms->OpenScope( Tko.SCOPEK_NAMESPACE, scope_, sid )
            end if
        end if
        if s <> 0 then
            '' 'namespace aaa alias "zzz"' REPLACES the namespace's name in every
            '' mangled symbol under it, and keeps the alias's CASE -- measured,
            '' '_ZN3zzz1FEv' where the plain form gives '_ZN3AAA1FEv'. Parsing the
            '' clause without carrying it here would have emitted the wrong name for
            '' every procedure in the namespace, silently.
            if sp->aliasName <> 0 then s->payload = cast( long, sp->aliasName )
            w.info->SetScope( id, s->inner )
            WalkChildren( w, sp->first, sp->count, s->inner )
        end if

    case Tko.N_EXTERN_BLOCK
        dim as Tko.StmtPayload ptr sp = StmtOf( w, id )
        '' A linkage block declares into the ENCLOSING scope; it is not a scope.
        WalkChildren( w, sp->first, sp->count, scope_ )

    case Tko.N_LABEL
        dim as Tko.StmtPayload ptr sp = StmtOf( w, id )
        Declare_( w, scope_, sp->name, Tko.SYM_LABEL, w.ast->Loc( id ) )

    case Tko.N_SCOPE, Tko.N_IF, Tko.N_IF_BRANCH, Tko.N_FOR, Tko.N_FOREACH, _
         Tko.N_DO, Tko.N_WHILE, Tko.N_WITH, Tko.N_SELECT, Tko.N_CASE
        '' Compound statements introduce a block scope for their bodies. Declarations
        '' inside are collected; expressions are ignored until Resolve.
        dim as Tko.StmtPayload ptr sp = StmtOf( w, id )
        dim as Tko.ScopeId inner = w.syms->OpenScope( Tko.SCOPEK_BLOCK, scope_, _
                                                      Tko.SYMBOL_NONE )
        w.info->SetScope( id, inner )
        '' 'a' is the FOR counter and the FOR EACH loop variable -- a DECLARATION,
        '' and the reason 14,565 uses of 'i' resolved to nothing. For the other
        '' compound statements 'a' is the condition, which this walk ignores.
        '' 'for i as integer' DECLARES i; 'for i =' uses an existing i. The 'as'
        '' clause is the whole difference, and it is what 'c' holds here. The
        '' counter arrives as an expression, not a declaration node, so Collect
        '' names it directly rather than waiting for a shape that never comes.
        '' FOR EACH ALWAYS DECLARES ITS VARIABLE, with or without an 'as' clause:
        '' the type is inferred from the sequence's ELEMENT. Measured -- 'for each v
        '' in a' then 'print v' after the loop is fbc error 42, "Variable not
        '' declared", and an outer 'v' is not disturbed. Requiring the 'as' clause
        '' here, as the counted FOR must, left the commoner spelling undeclared and
        '' the whole statement unlowerable.
        dim as boolean declaresVar = (sp->c <> Tko.NODE_NONE)
        if k = Tko.N_FOREACH then declaresVar = true
        '' Hoisted to a boolean local: warning 38 fires on a mixed chain, and the
        '' house rule is to name the condition rather than silence it.
        dim as boolean isLoopDecl = ((k = Tko.N_FOR) orelse (k = Tko.N_FOREACH))
        dim as boolean hasIdent = (sp->a <> Tko.NODE_NONE)
        if hasIdent then hasIdent = (w.ast->Kind( sp->a ) = Tko.N_IDENT)
        if isLoopDecl andalso declaresVar andalso hasIdent then
            dim as Tko.IdentPayload ptr ip = _
                @w.ast->idents[cast( long, w.ast->nodes[cast( long, sp->a )].data )]
            Declare_( w, inner, ip->name, Tko.SYM_VARIABLE, w.ast->Loc( sp->a ) )
        end if
        WalkNode( w, sp->a, inner )
        WalkNode( w, sp->b, inner )
        WalkNode( w, sp->c, inner )
        WalkChildren( w, sp->first, sp->count, inner )
    end select
end sub

'' How many parameters a procedure declaration writes.
private function ProcArity _
    ( byref w as Walker, byval sp as Tko.StmtPayload ptr ) as long

    dim as long n = 0
    for i as long = 0 to sp->count - 1
        dim as Tko.NodeId prm = cast( Tko.NodeId, w.ast->children[sp->first + i] )
        if w.ast->Kind( prm ) = Tko.N_PARAM then n += 1
    next
    return n
end function


'' Give every declaration of this name the OVERLOAD flag if any of them has it.
''
'' The flag decides how the name MANGLES, and fbc mangles them all alike: the keyword
'' is written once, usually on the header's declaration, and the definition in the
'' implementation file does not repeat it.
private sub SpreadOverloadFlag_ _
    ( byref w as Walker, byval scope_ as Tko.ScopeId, byval nm as Tko.InternId, _
      byval id as Tko.NodeId )

    if nm = 0 then return
    dim as boolean any_ = ((StmtOf( w, id )->extra and Tko.PF_OVERLOAD) <> 0)
    dim as Tko.SymbolId cur = w.syms->LookupLocal( scope_, nm )
    dim as long guard = 0
    while (cur <> Tko.SYMBOL_NONE) andalso (guard < 100000)
        guard += 1
        dim as Tko.Symbol ptr s = w.syms->SymbolAt( cur )
        if s = 0 then exit while
        if s->kind <> cast( ubyte, Tko.SYM_PROC ) then exit while
        dim as Tko.NodeId pn = cast( Tko.NodeId, s->payload )
        if (pn <> Tko.NODE_NONE) andalso (pn <> 0) then
            if w.ast->Kind( pn ) = Tko.N_PROC then
                if (StmtOf( w, pn )->extra and Tko.PF_OVERLOAD) <> 0 then any_ = true
            end if
        end if
        cur = s->nextOverload
    wend
    if any_ = false then return

    StmtOf( w, id )->extra or= Tko.PF_OVERLOAD
    cur = w.syms->LookupLocal( scope_, nm )
    guard = 0
    while (cur <> Tko.SYMBOL_NONE) andalso (guard < 100000)
        guard += 1
        dim as Tko.Symbol ptr s = w.syms->SymbolAt( cur )
        if s = 0 then exit while
        if s->kind <> cast( ubyte, Tko.SYM_PROC ) then exit while
        dim as Tko.NodeId pn = cast( Tko.NodeId, s->payload )
        if (pn <> Tko.NODE_NONE) andalso (pn <> 0) then
            if w.ast->Kind( pn ) = Tko.N_PROC then
                StmtOf( w, pn )->extra or= Tko.PF_OVERLOAD
            end if
        end if
        cur = s->nextOverload
    wend
end sub

'' The one DECLARED-but-not-yet-defined overload of this name taking 'want' parameters,
'' or SYMBOL_NONE when there is not exactly one.
''
'' Arity, not the full signature: Collect runs before any type is resolved, so it cannot
'' compare parameter TYPES. Requiring exactly one candidate is what keeps that
'' approximation safe -- two same-arity overloads leave the definition to declare itself,
'' which is the behaviour this replaces rather than a new way to be wrong.
'' ONE WRITTEN TYPE REFERENCE AGAINST ANOTHER, strictly.
''
'' NOT SameTypeRef_, which exists to decide whether a RESTATEMENT is legal and answers
'' 'same' whenever it cannot tell -- a named type may be a typedef for the builtin on
'' the other side, and refusing that pair rejects four corpus files. Discriminating an
'' OVERLOAD is the opposite question: 'the same as far as I can see' is not an answer,
'' because acting on it moves a body onto the wrong declaration. So a builtin matches
'' only the same builtin and a name only the same name, and anything it cannot decide
'' is reported as DIFFERENT -- which costs nothing, because the caller falls back to
'' the head of the chain, and the head is what it used before this existed.
private function SameWrittenType_ _
    ( byref w as Walker, byval a as Tko.NodeId, byval b as Tko.NodeId ) as boolean

    if (a = Tko.NODE_NONE) andalso (b = Tko.NODE_NONE) then return true
    if (a = Tko.NODE_NONE) orelse (b = Tko.NODE_NONE) then return false
    if w.ast->Kind( a ) <> Tko.N_TYPEREF then return false
    if w.ast->Kind( b ) <> Tko.N_TYPEREF then return false
    dim as ushort af = w.ast->nodes[cast( long, a )].flags
    dim as ushort bf = w.ast->nodes[cast( long, b )].flags
    dim as ushort mask = Tko.NF_PTR or Tko.NF_CONST or Tko.NF_PROC_TYPE
    if (af and mask) <> (bf and mask) then return false
    dim as Tko.StmtPayload ptr ap = StmtOf( w, a )
    dim as Tko.StmtPayload ptr bp = StmtOf( w, b )
    if ap->op <> bp->op then return false
    if ap->op = cast( ushort, Tko.TK_IDENT ) then
        if ap->name <> bp->name then return false
    end if
    '' PTR nests another N_TYPEREF in 'a', so recursing compares the pointed-to type
    '' and, by arriving at different depths, the pointer depth with it.
    return SameWrittenType_( w, ap->a, bp->a )
end function

'' The RETURN TYPE and every PARAMETER TYPE, as written, on two N_PROC payloads whose
'' arities already agree.
private function SameSignature_ _
    ( byref w as Walker, byval a as Tko.StmtPayload ptr, _
      byval b as Tko.StmtPayload ptr ) as boolean

    if SameWrittenType_( w, a->a, b->a ) = false then return false
    if a->count <> b->count then return false
    for i as long = 0 to a->count - 1
        dim as Tko.NodeId an = cast( Tko.NodeId, w.ast->children[a->first + i] )
        dim as Tko.NodeId bn = cast( Tko.NodeId, w.ast->children[b->first + i] )
        if (w.ast->Kind( an ) <> Tko.N_PARAM) orelse _
           (w.ast->Kind( bn ) <> Tko.N_PARAM) then return false
        if SameWrittenType_( w, StmtOf( w, an )->a, StmtOf( w, bn )->a ) = false then
            return false
        end if
    next
    return true
end function

'' The DECLARATION a member DEFINITION belongs to, chosen out of the overload set by
'' signature rather than taken from the head of the chain.
''
'' Collect runs before types exist, so the only thing there is to compare is what was
'' WRITTEN: the arity, and the return type reference. That separates the two cast
'' operators that motivated this, and every overload set it cannot separate falls back
'' to the head -- which is what it did for all of them before.
''
'' UNIQUELY OR NOT AT ALL. Two declarations of the same arity and the same return type
'' differ only in their parameter types, which cannot be compared here, so picking
'' either would be a guess and the guess would move a body onto the wrong symbol.
private function MemberDeclForDef_ _
    ( byref w as Walker, byval scope_ as Tko.ScopeId, byval nm as Tko.InternId, _
      byval sp as Tko.StmtPayload ptr ) as Tko.SymbolId

    dim as Tko.SymbolId head = w.syms->LookupLocal( scope_, nm )
    if head = Tko.SYMBOL_NONE then return head
    dim as long want = ProcArity( w, sp )
    dim as Tko.SymbolId found = Tko.SYMBOL_NONE
    dim as long hits = 0
    dim as Tko.SymbolId cur = head
    dim as long guard = 0
    while (cur <> Tko.SYMBOL_NONE) andalso (guard < 100000)
        guard += 1
        dim as Tko.Symbol ptr s = w.syms->SymbolAt( cur )
        if s = 0 then exit while
        if s->kind <> cast( ubyte, Tko.SYM_PROC ) then exit while
        dim as Tko.NodeId pn = cast( Tko.NodeId, s->payload )
        if (pn <> Tko.NODE_NONE) andalso (w.ast->Kind( pn ) = Tko.N_PROC) then
            dim as Tko.StmtPayload ptr dp = StmtOf( w, pn )
            if ProcArity( w, dp ) = want then
                if SameSignature_( w, dp, sp ) then
                    found = cur
                    hits += 1
                end if
            end if
        end if
        cur = s->nextOverload
    wend
    if hits = 1 then return found
    return head
end function

private function UndefinedProcWithArity _
    ( byref w as Walker, byval scope_ as Tko.ScopeId, byval nm as Tko.InternId, _
      byval want as long ) as Tko.SymbolId

    dim as Tko.SymbolId found = Tko.SYMBOL_NONE
    dim as long hits = 0
    dim as Tko.SymbolId cur = w.syms->LookupLocal( scope_, nm )
    while cur <> Tko.SYMBOL_NONE
        dim as Tko.Symbol ptr s = w.syms->SymbolAt( cur )
        if s = 0 then exit while
        if s->kind <> cast( ubyte, Tko.SYM_PROC ) then exit while
        if (s->flags and Tko.SYMF_DEFINED) = 0 then
            dim as Tko.NodeId pn = cast( Tko.NodeId, s->payload )
            if (pn <> Tko.NODE_NONE) andalso (w.ast->Kind( pn ) = Tko.N_PROC) then
                if ProcArity( w, StmtOf( w, pn ) ) = want then
                    found = cur
                    hits += 1
                end if
            end if
        end if
        cur = s->nextOverload
    wend
    if hits = 1 then return found
    return Tko.SYMBOL_NONE
end function

'' The calling convention across a DECLARE and its definition. The rule is ASYMMETRIC,
'' and measured on both targets rather than reasoned about:
''
''   declare cdecl  + definition (none)     inherits cdecl, emits '_A' on win32
''   declare (none) + definition stdcall    accepted -- ABSENT MEANS STDCALL
''   declare (none) + definition cdecl      error 41
''   declare (none) + definition pascal     error 41
''
'' So absence on the DEFINITION inherits, while absence on the DECLARATION is stdcall
'' and anything else contradicts it. fbc reports the same error on win64, where the
'' convention has no effect on any emitted name at all, so this is a syntactic rule and
'' not a target one.
private function Effective_( byval c as Tko.CallConv ) as Tko.CallConv
    if c = Tko.CC_NONE then return Tko.CC_STDCALL
    return c
end function

private sub BindCallConv _
    ( byref w as Walker, byval s as Tko.Symbol ptr, _
      byval sp as Tko.StmtPayload ptr, byval id as Tko.NodeId, _
      byval firstSighting as boolean )

    dim as Tko.CallConv here = Tko.CallConvOf( sp->extra )
    if here = Tko.CC_NONE then return
    if firstSighting then
        s->callConv = cast( ubyte, here )
        return
    end if
    dim as Tko.CallConv had = cast( Tko.CallConv, s->callConv )
    if Effective_( had ) = here then
        s->callConv = cast( ubyte, here )
        return
    end if
    dim as Tko.SourceRange r = Tko.PointRange( w.ast->Loc( id ) )
    w.diags->Report( Tko.TKO0603, r, w.names->Spelling( s->name ) )
    w.diags->AddNote( Tko.TKO0901, Tko.PointRange( s->loc ) )
end sub

private function DeclareGlobal _
    ( byref syms as Tko.SymbolTable, byref names as Tko.Interner, _
      byref diags as Tko.DiagnosticEngine, byval spelling as string ) as Tko.SymbolId

    dim as boolean dup = false
    return syms.DeclareSym( Tko.SCOPE_GLOBAL, _
                            names.Fold( names.GetString( spelling ) ), _
                            Tko.SYM_CONSTANT, Tko.LOC_NONE, dup )
end function

'' 'true' and 'false' are predeclared CONSTANTS carrying a built-in value: BOOLEAN,
'' and -1 and 0. Every part of that is measured -- 'typeof( true )' is BOOLEAN,
'' 'cint( true )' is -1 and 'sizeof( true )' is 1 -- because a language where a true
'' comparison is -1 is not one where 'true' can be assumed to be 1.
'' __FUNCTION__, whose value depends on WHERE it is used. Collect cannot know that, so
'' it only plants the marker; Check fills in the name and the type.
private sub DeclareFuncName _
    ( byref syms as Tko.SymbolTable, byref names as Tko.Interner, _
      byref diags as Tko.DiagnosticEngine, byval spelling as string )

    dim as Tko.SymbolId sid = DeclareGlobal( syms, names, diags, spelling )
    dim as Tko.Symbol ptr s = syms.SymbolAt( sid )
    if s <> 0 then s->flags or= Tko.SYMF_FUNCNAME
end sub

private sub DeclareBuiltinConst _
    ( byref syms as Tko.SymbolTable, byref names as Tko.Interner, _
      byref types as Tko.TypeContext, byref diags as Tko.DiagnosticEngine, _
      byval spelling as string, byval value as long )

    dim as Tko.SymbolId sid = DeclareGlobal( syms, names, diags, spelling )
    dim as Tko.Symbol ptr s = syms.SymbolAt( sid )
    if s = 0 then return
    s->flags or= Tko.SYMF_BUILTIN
    s->type_ = types.Builtin( Tko.TY_BOOLEAN )
    s->payload = value
end sub

function Run _
    ( byref ast as Tko.AstArena, byval root as Tko.NodeId, _
      byref syms as Tko.SymbolTable, byref names as Tko.Interner, _
      byref types as Tko.TypeContext, byref diags as Tko.DiagnosticEngine, _
      byref info as Tko.SemanticInfo ) as long

    dim as Walker w
    w.types = @types
    w.ast = @ast
    w.syms = @syms
    w.diags = @diags
    w.names = @names
    w.info = @info
    w.duplicates = 0
    info.Resize( ast.Count( ) )

    '' fbc predeclares these in the global scope -- 'dim as integer true' is a
    '' DUPLICATED DEFINITION to fbc, not a syntax error, so they are symbols and not
    '' keywords. typeof(true) is BOOLEAN, measured. __FUNCTION__ is fbc's
    '' compile-time procedure name; giving it the enclosing proc's name is Check's
    '' job, being declared at all is this one's.
    DeclareBuiltinConst( syms, names, types, diags, "true", -1 )
    DeclareBuiltinConst( syms, names, types, diags, "false", 0 )
    DeclareFuncName( syms, names, diags, "__function__" )
    '' __FUNCTION_NQ__ does NOT exist in -lang fb -- fbc reports a syntax error for it
    '' -- so it is declared and left untyped rather than given a value it cannot have.
    DeclareGlobal( syms, names, diags, "__function_nq__" )

    dim as Tko.ScopeId moduleScope = syms.OpenScope( Tko.SCOPEK_MODULE, _
                                                     Tko.SCOPE_GLOBAL, Tko.SYMBOL_NONE )
    WalkNode( w, root, moduleScope )
    return w.duplicates
end function

function One _
    ( byref ast as Tko.AstArena, byval id as Tko.NodeId, byval scope_ as Tko.ScopeId, _
      byref syms as Tko.SymbolTable, byref names as Tko.Interner, _
      byref types as Tko.TypeContext, byref diags as Tko.DiagnosticEngine, _
      byref info as Tko.SemanticInfo ) as long

    dim as Walker w
    w.types = @types
    w.ast = @ast
    w.syms = @syms
    w.diags = @diags
    w.names = @names
    w.info = @info
    w.duplicates = 0
    info.Resize( ast.Count( ) )
    WalkNode( w, id, scope_ )
    return w.duplicates
end function

'' ----------------------------------------------------------------------- dump

function Dump _
    ( byref syms as Tko.SymbolTable, byref names as Tko.Interner, _
      byref types as Tko.TypeContext, byref src as Tko.SourceManager ) as string

    '' THE COUNTS EXCLUDE THE PRELUDE TOO, or they would contradict the rows below --
    '' thirty declarations counted and none of them printed. The prelude's own total is
    '' reported beside them rather than hidden.
    dim as long nbuiltin = 0
    for i as long = 1 to syms.Count( )
        dim as Tko.Symbol ptr s = syms.SymbolAt( cast( Tko.SymbolId, i ) )
        if s = 0 then continue for
        if src.IsBuiltin( s->loc ) then nbuiltin += 1
    next
    dim as long nscopes = 0
    for i as long = 1 to syms.ScopeCount( )
        dim as Tko.SymScope ptr sc = syms.ScopeAt( cast( Tko.ScopeId, i ) )
        if sc = 0 then continue for
        if sc->owner <> Tko.SYMBOL_NONE then
            dim as Tko.Symbol ptr os = syms.SymbolAt( sc->owner )
            if os <> 0 then
                if src.IsBuiltin( os->loc ) then continue for
            end if
        end if
        nscopes += 1
    next

    dim as string outp = ""
    outp += "scopes: " & nscopes & "  symbols: " & (syms.Count( ) - nbuiltin)
    if nbuiltin > 0 then outp += "  (builtin: " & nbuiltin & ")"
    outp += chr( 10 )

    for i as long = 1 to syms.ScopeCount( )
        dim as Tko.SymScope ptr sc = syms.ScopeAt( cast( Tko.ScopeId, i ) )
        if sc->count = 0 then continue for
        '' A scope the prelude opened -- the body of one of its declarations -- is not
        '' printed at all.
        if sc->owner <> Tko.SYMBOL_NONE then
            dim as Tko.Symbol ptr os = syms.SymbolAt( sc->owner )
            if os <> 0 then
                if src.IsBuiltin( os->loc ) then continue for
            end if
        end if
        '' How many of this scope's symbols are the user's, which is what the rows
        '' below will actually show.
        dim as long nvis = 0
        dim as Tko.SymbolId vc = sc->firstSym
        while vc <> Tko.SYMBOL_NONE
            dim as Tko.Symbol ptr vs = syms.SymbolAt( vc )
            if vs = 0 then exit while
            if src.IsBuiltin( vs->loc ) = false then nvis += 1
            vc = vs->nextInScope
        wend
        if nvis = 0 then continue for

        dim as string owner = ""
        if sc->owner <> Tko.SYMBOL_NONE then
            owner = " of '" & names.Spelling( syms.SymbolAt( sc->owner )->name ) & "'"
        end if
        outp += "scope " & i & " " & Tko.ScopeKindName( cast( Tko.ScopeKind, sc->kind ) ) & _
                owner & " parent=" & sc->parent & " (" & nvis & ")" & chr( 10 )

        '' Declaration order, which is the order destruction will reverse.
        dim as Tko.SymbolId cur = sc->firstSym
        while cur <> Tko.SYMBOL_NONE
            dim as Tko.Symbol ptr s = syms.SymbolAt( cur )
            '' Same reason as the AST dump: the prelude is declared, and listing it
            '' under every file would bury the file.
            if src.IsBuiltin( s->loc ) then
                cur = s->nextInScope
                continue while
            end if
            dim as string row = "    " & _
                left( Tko.SymbolKindName( cast( Tko.SymbolKind, s->kind ) ) & "         ", 10 ) & _
                "'" & names.Spelling( s->name ) & "'"
            if (s->flags and Tko.SYMF_SHARED) <> 0 then row += " shared"
            if (s->flags and Tko.SYMF_STATIC) <> 0 then row += " static"
            if (s->flags and Tko.SYMF_CONST) <> 0 then row += " const"
            if (s->flags and Tko.SYMF_DECLARED) <> 0 then row += " declared"
            if (s->flags and Tko.SYMF_DEFINED) <> 0 then row += " defined"
            if (s->flags and Tko.SYMF_BUILTIN) <> 0 then row += " builtin"
            if s->callConv <> cast( ubyte, Tko.CC_NONE ) then
                row += " " & Tko.CallConvName( cast( Tko.CallConv, s->callConv ) )
            end if
            if (s->flags and Tko.SYMF_FUNCNAME) <> 0 then row += " funcname"
            if s->nextOverload <> Tko.SYMBOL_NONE then row += " +overloads"
            outp += row & chr( 10 )
            cur = s->nextInScope
        wend
    next
    return outp
end function

end namespace
