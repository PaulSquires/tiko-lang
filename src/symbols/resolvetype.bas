'' resolvetype.bas -- ResolveTypeRef, a written type reference resolved to a TypeId.
''
'' Split out of resolve.bas at the 1500-line cap and INCLUDED from it in the same place,
'' exactly as resolvedot.bas is. Nothing about it changed in the move.


'' THE TYPE A TYPE LITERAL NAMES, from the list's TARGET. 'type<T>( ... )' keeps its
'' type reference there, so 'typeof' over one is answerable without typing the
'' expression -- and the target may itself be a 'typeof', which recurses.
private function TypeLitTargetType_ _
    ( byref c as Ctx, byval e as Tko.NodeId, byval scope_ as Tko.ScopeId, _
      byref outT as Tko.TypeId ) as boolean

    if e = Tko.NODE_NONE then return false
    if c.ast->Kind( e ) <> Tko.N_TUPLE then return false
    if (c.ast->nodes[cast( long, e )].flags and Tko.NF_TYPE_LITERAL) = 0 then
        return false
    end if
    dim as Tko.NodeId tgt = ListOf( c, e )->target
    if tgt = Tko.NODE_NONE then return false
    if c.ast->Kind( tgt ) <> Tko.N_TYPEREF then return false
    dim as Tko.TypeId lt = ResolveTypeRef( c, tgt, scope_ )
    if lt = Tko.TYPE_NONE then return false
    if c.types->Kind( lt ) = Tko.TK_REFERENCE then lt = c.types->Inner( lt )
    outT = lt
    return true
end function

function ResolveTypeRef _
    ( byref c as Ctx, byval id as Tko.NodeId, byval scope_ as Tko.ScopeId ) as Tko.TypeId

    if id = Tko.NODE_NONE then return Tko.TYPE_NONE
    if c.ast->Kind( id ) <> Tko.N_TYPEREF then return Tko.TYPE_NONE

    dim as Tko.AstNode ptr n = @c.ast->nodes[cast( long, id )]
    dim as Tko.StmtPayload ptr sp = StmtOf( c, id )
    c.st->typeRefs += 1

    '' A pointer level wraps whatever it contains.
    if (n->flags and Tko.NF_PTR) <> 0 then
        dim as Tko.TypeId inner = ResolveTypeRef( c, sp->a, scope_ )
        dim as Tko.TypeId t = c.types->Pointer_( inner )
        if (n->flags and Tko.NF_CONST) <> 0 then t = c.types->Qualify( t, Tko.TF_CONST )
        c.info->SetType( id, t )
        return t
    end if

    '' 'as sub( ... )' / 'as function( ... ) as T'. In FreeBASIC a procedure type is
    '' already a POINTER -- 'sub( ) ptr' is PPFvvE, one P for the type itself and one
    '' for the written 'ptr' -- so the pointer is built in here, not by the caller.
    if (n->flags and Tko.NF_PROC_TYPE) <> 0 then
        dim as Tko.TypeId ret = Tko.TYPE_NONE
        if sp->a <> Tko.NODE_NONE then
            ret = ResolveTypeRef( c, sp->a, scope_ )
        else
            ret = c.types->Builtin( Tko.TY_VOID )
        end if
        '' 'as function( ... ) BYREF as long' -- THE RESULT'S BYREF-NESS BELONGS TO THE
        '' TYPE. The parser has recorded it as PF_BYREF_RESULT since the spelling was
        '' accepted and nothing read it back, so a procedure TYPE did not carry it and
        '' every consumer had to guess: 'dim byref as long r = pick( lo, hi )' through a
        '' function POINTER found no address to alias, while the same call over a NAMED
        '' function -- where the PROC NODE carries the flag -- lowered. Measured, fbc:
        '' 'int32* vr$2 = (PICK$0)( &LO$0, &HI$0 ); R$0 = vr$2;'.
        if (sp->extra and Tko.PF_BYREF_RESULT) <> 0 then
            if ret <> Tko.TYPE_NONE then ret = c.types->Reference( ret )
        end if
        dim as Tko.TypeIdVec2 ps
        for i as long = 0 to sp->count - 1
            dim as Tko.NodeId prm = cast( Tko.NodeId, c.ast->children[sp->first + i] )
            if c.ast->Kind( prm ) <> Tko.N_PARAM then continue for
            dim as Tko.StmtPayload ptr pp = StmtOf( c, prm )
            dim as Tko.TypeId pt = ResolveTypeRef( c, pp->a, scope_ )
            if (c.ast->nodes[cast( long, prm )].flags and Tko.NF_BYREF) <> 0 then
                pt = c.types->Reference( pt )
            end if
            ps.Push( cast( ulong, pt ) )
        next
        dim as Tko.TypeId pf = c.types->Pointer_( c.types->ProcType( ret, ps ) )
        if (n->flags and Tko.NF_CONST) <> 0 then
            pf = c.types->Qualify( pf, Tko.TF_CONST )
        end if
        c.info->SetType( id, pf )
        return pf
    end if

    '' A TUPLE type: 'as (long, string)'. DESUGARED into a synthetic UDT with fields
    '' '_1'.._N, because that is exactly what fbc says it is -- the corpus test asserts
    '' the layout equals the equivalent hand-written TYPE, field for field.
    ''
    '' Building a symbol rather than a bare type is what makes the layout free: this
    '' runs BEFORE ComputeUdtLayouts, which walks symbols, so the tuple goes through
    '' the same offset and alignment code as everything else.
    ''
    '' Identity is STRUCTURAL, through a name built from the element type ids: two
    '' '(long, string)' written apart are one type, which is what makes them assignable
    '' to each other.
    if cast( Tko.TokenKind, sp->op ) = Tko.TK_LPAREN then
        dim as string key = "$tup"
        dim as FB.Array( of ulong ) elemTypes
        for i as long = 0 to sp->count - 1
            dim as Tko.NodeId e = cast( Tko.NodeId, c.ast->children[sp->first + i] )
            dim as Tko.TypeId et = ResolveTypeRef( c, e, scope_ )
            if et = Tko.TYPE_NONE then
                '' An element that does not resolve yet: no type rather than a wrong
                '' one. Every use declines, which is the honest outcome.
                return Tko.TYPE_NONE
            end if
            elemTypes.Push( cast( ulong, et ) )
            key += ":" & str( cast( long, et ) )
        next
        '' The builder moved to symbol.bas so CHECK can name the same type for a tuple
        '' LITERAL. Nothing about it changed in the move; 'key' above is now only the
        '' loop's own bookkeeping and the builder rebuilds it from the same ids.
        dim as Tko.TypeId tt = Tko.TupleUdtFor( *c.syms, *c.types, *c.names, _
                                                elemTypes, c.ast->Loc( id ) )
        if tt = Tko.TYPE_NONE then return Tko.TYPE_NONE
        c.info->SetType( id, tt )
        return tt
    end if

    dim as Tko.TypeId base_ = Tko.TYPE_NONE
    dim as Tko.TokenKind k = cast( Tko.TokenKind, sp->op )

    select case k
    case Tko.KW_BYTE     : base_ = c.types->Builtin( Tko.TY_BYTE )
    case Tko.KW_UBYTE    : base_ = c.types->Builtin( Tko.TY_UBYTE )
    case Tko.KW_SHORT    : base_ = c.types->Builtin( Tko.TY_SHORT )
    case Tko.KW_USHORT   : base_ = c.types->Builtin( Tko.TY_USHORT )
    case Tko.KW_LONG     : base_ = c.types->Builtin( Tko.TY_LONG )
    case Tko.KW_ULONG    : base_ = c.types->Builtin( Tko.TY_ULONG )
    case Tko.KW_INTEGER  : base_ = c.types->Builtin( Tko.TY_INTEGER )
    case Tko.KW_UINTEGER : base_ = c.types->Builtin( Tko.TY_UINTEGER )
    case Tko.KW_LONGINT  : base_ = c.types->Builtin( Tko.TY_LONGINT )
    case Tko.KW_ULONGINT : base_ = c.types->Builtin( Tko.TY_ULONGINT )
    case Tko.KW_SINGLE   : base_ = c.types->Builtin( Tko.TY_SINGLE )
    case Tko.KW_DOUBLE   : base_ = c.types->Builtin( Tko.TY_DOUBLE )
    case Tko.KW_BOOLEAN  : base_ = c.types->Builtin( Tko.TY_BOOLEAN )
    case Tko.KW_STRING   : base_ = c.types->Builtin( Tko.TY_STRING )
    case Tko.KW_ZSTRING  : base_ = c.types->Builtin( Tko.TY_ZSTRING )
    case Tko.KW_WSTRING  : base_ = c.types->Builtin( Tko.TY_WSTRING )
    case Tko.KW_USTRING  : base_ = c.types->Builtin( Tko.TY_USTRING )
    case Tko.KW_ANY      : base_ = c.types->Builtin( Tko.TY_ANY )
    case Tko.KW_UNSIGNED
        '' 'unsigned <typedef>'. The parser put the typedef's name here and left the
        '' keyword in 'op'; the type is whatever that name resolves to, made unsigned.
        ''
        '' If it cannot be made unsigned -- a UDT, a pointer, something not integral --
        '' the result is left as TYPE_NONE rather than falling back to the SIGNED type.
        '' A wrong type that compiles is worse than a type error: the parse failure this
        '' replaces was at least visible.
        '' A TYPE name, so the lookup asks for the type-name class: 'dim as ubyte ptr pb'
        '' followed by 'type pb as ubyte' puts the VARIABLE in the slot, and a plain
        '' lookup then typed 'dim as pb v' as a POINTER where fbc gives one byte.
        dim as Tko.SymbolId usid = c.syms->LookupTyped( scope_, sp->name, true )
        if usid <> Tko.SYMBOL_NONE then
            c.info->SetRef( id, usid )
            dim as Tko.Symbol ptr us = c.syms->SymbolAt( usid )
            if us->type_ <> Tko.TYPE_NONE then
                base_ = UnsignedCounterpart( c, us->type_ )
            end if
        end if

    case Tko.KW_TYPEOF
        '' AN EXPRESSION OPERAND IS STILL AN EXPRESSION and has to be resolved, or the
        '' names in it bind to nothing and Check can say nothing about its type.
        '' 'typeof( n + n )' came out untyped for exactly that reason while
        '' 'typeof( cuint( n ) )' worked -- a conversion intrinsic's result type does
        '' not depend on its operand, so it hid the gap.
        '' ...UNLESS THE OPERAND IS A TYPE. 'typeof( integer )' is a type spelled as
        '' a keyword, kept by the parser as a nested TYPEREF; walking one as an
        '' expression would bind nothing.
        if sp->b <> Tko.NODE_NONE then
            if c.ast->Kind( sp->b ) = Tko.N_TYPEREF then
                dim as Tko.TypeId ity = ResolveTypeRef( c, sp->b, scope_ )
                if ity <> Tko.TYPE_NONE then
                    if c.types->Kind( ity ) = Tko.TK_REFERENCE then
                        ity = c.types->Inner( ity )
                    end if
                    base_ = ity
                end if
            elseif TypeLitTargetType_( c, sp->b, scope_, base_ ) then
                '' 'typeof( type<T>( ... ) )' -- A TYPE LITERAL NAMES ITS OWN TYPE,
                '' in the list's TARGET, so this needs no expression typing at all.
                '' The operand is neither a TYPEREF nor a bare name, so it fell to
                '' the expression walk, stayed unresolved, and
                '' 'dim as integer i = type<typeof( type<integer>( 1.5 ) )>( 3 )'
                '' declined -- structs/anon-intrinsic.bas writes it nested twice.
                ''
                '' The nesting resolves itself: the inner literal's target is a
                '' TYPEREF, which may itself be a 'typeof', and ResolveTypeRef is
                '' what is being written here.
            else
                WalkExpr( c, sp->b, scope_ )
            end if
        end if

        '' 'typeof( x )' AS A TYPE. The parser keeps the operand when it is a bare
        '' name, which is what the corpus writes; the type is whatever that name has,
        '' a variable's or a type's alike. fbc agrees on both: '#print typeof( s )'
        '' over 'dim s as double' is DOUBLE, and over a UDT name it is the UDT.
        ''
        '' A more complicated operand was discarded by the parser and stays unresolved
        '' here, which is what it was before.
        if sp->rawName <> 0 then
            dim as Tko.SymbolId tsid2 = c.syms->Lookup( scope_, sp->rawName )
            '' RECORDED ON THE TYPEREF, because Check may have to ask again. A
            '' 'var' has no type yet HERE, and Check's repair pass cannot repeat the
            '' lookup: an expression node inside a procedure has no recorded scope
            '' to look a name up FROM. This is the only record of what the name
            '' meant.
            if tsid2 <> Tko.SYMBOL_NONE then c.info->SetRef( id, tsid2 )
            dim as Tko.Symbol ptr ts2 = c.syms->SymbolAt( tsid2 )
            if ts2 <> 0 then
                '' A 'var' HAS NO TYPE YET. Its inference is Check's, and generic
                '' instantiation runs HERE -- so
                '' 'type BA as BoxOf( of typeof( onA ) )' over 'var onA = sub[...]'
                '' gave an unresolvable type argument, InstantiateGeneric_ refused
                '' to build anything at all, and every use of BA was a zero-sized
                '' local whose field stores declined. Twelve statements in
                '' tui/tuiwidget_.bas, and fbc compiles the file clean.
                ''
                '' THE ONE CASE RESOLVE CAN ANSWER is the one the corpus writes: an
                '' initialiser this pass has ALREADY TYPED. BuildClosureType_ types
                '' the N_CLOSURE node as it builds the closure UDT, so the answer is
                '' sitting on the initialiser by the time the 'typeof' is read. A
                '' 'var' over anything else is still unresolved here and still
                '' declines -- that half is Check's and stays Check's.
                if ts2->type_ = Tko.TYPE_NONE then
                    if ts2->kind = cast( ubyte, Tko.SYM_VARIABLE ) then
                        dim as Tko.NodeId vit = cast( Tko.NodeId, ts2->payload )
                        if vit <> Tko.NODE_NONE then
                            if c.ast->Kind( vit ) = Tko.N_VAR_ITEM then
                                dim as Tko.NodeId iv = StmtOf( c, vit )->b
                                if iv <> Tko.NODE_NONE then
                                    dim as Tko.TypeId it2 = c.info->TypeOf_( iv )
                                    if it2 <> Tko.TYPE_NONE then ts2->type_ = it2
                                end if
                            end if
                        end if
                    end if
                end if
                if ts2->type_ <> Tko.TYPE_NONE then
                    base_ = ts2->type_
                    '' A REFERENCE is transparent: 'typeof( n )' over a byref
                    '' parameter is the referent's type, as it is in an expression.
                    if c.types->Kind( base_ ) = Tko.TK_REFERENCE then
                        base_ = c.types->Inner( base_ )
                    end if
                end if
            end if
        end if

    case else
        '' 'cva_list' IS A PREDEFINED TYPE NAME, not a keyword. fbc treats it as an
        '' ordinary identifier -- 'dim as long cva_list' is error 4, DUPLICATED
        '' DEFINITION, not a syntax error -- so it is resolved here, where a named type
        '' is, rather than in the keyword switch above. Anything the program declares
        '' under that name is found by the lookup below and wins, which is what makes
        '' this a PREDEFINITION rather than a reserved word.
        ''
        '' Its width is target-dependent and lives in TargetLayout; see TY_CVA_LIST.
        if sp->ownerName = 0 then
            if c.syms->LookupTyped( scope_, sp->name, true ) = Tko.SYMBOL_NONE then
                if Tko.Text.LowerAscii( c.names->Spelling( sp->name ) ) = "cva_list" then
                    base_ = c.types->Builtin( Tko.TY_CVA_LIST )
                end if
            end if
        end if

        '' A named type. Not finding it is NOT reported here: a type may come from a
        '' header this build did not parse, and drowning the output in those would
        '' hide the real signal. Check reports what it can prove.
        ''
        '' QUALIFIED first: 'dim as nsab.T1 v' names a type in a namespace, and an
        '' ordinary lookup walks only PARENT scopes -- it never descends into one. The
        '' qualifier is what the parser now keeps in 'ownerName'.
        '' A TYPE PARAMETER, inside a generic being instantiated. It shadows anything
        '' of the same spelling, which is what 'typeparam-shadowing' is about: a
        '' variable named 't' anywhere in scope must not capture 'as T'.
        for gi as long = c.gparamName.Count - 1 to 0 step -1
            if cast( Tko.InternId, c.gparamName[gi] ) = sp->name then
                base_ = cast( Tko.TypeId, c.gparamType[gi] )
                c.info->SetType( id, base_ )
                return base_
            end if
        next

        dim as Tko.SymbolId sid = Tko.SYMBOL_NONE
        if sp->ownerName <> 0 then
            '' The qualifier may be a PATH -- 'a.b.c' -- which the parser keeps dotted
            '' in one field. Walk it a component at a time: only the FIRST component is
            '' visible from the current scope, and each later one is looked up INSIDE
            '' what the previous one opened.
            dim as string qpath = c.names->Spelling( sp->ownerName )
            dim as Tko.ScopeId sc = scope_
            dim as boolean first_ = true
            dim as boolean ok = true
            dim as long at = 0
            '' AN EMPTY FIRST COMPONENT IS THE '..' PREFIX -- the one spelling a real
            '' identifier can never produce. It means START AT THE FILE SCOPE, and the
            '' component itself is skipped.
            if left( qpath, 1 ) = "." then
                sc = FileScopeOf_( c, scope_ )
                at = 1
            elseif qpath = "" then
                sc = FileScopeOf_( c, scope_ )
                first_ = false
                at = len( qpath ) + 1
            end if
            while at <= len( qpath )
                dim as long dot = instr( at + 1, qpath, "." )
                dim as long stop_ = dot
                if stop_ = 0 then stop_ = len( qpath ) + 1
                dim as string comp = mid( qpath, at + 1, stop_ - at - 1 )
                if len( comp ) = 0 then
                    ok = false
                    exit while
                end if
                dim as Tko.InternId cid = c.names->GetString( comp )
                dim as Tko.SymbolId qsid
                if first_ then
                    qsid = c.syms->Lookup( sc, cid )
                else
                    qsid = c.syms->LookupLocalTyped( sc, cid, true )
                end if
                dim as Tko.Symbol ptr qs = c.syms->SymbolAt( qsid )
                if qs = 0 then
                    ok = false
                    exit while
                end if
                dim as boolean qualifies = _
                    (qs->kind = cast( ubyte, Tko.SYM_NAMESPACE )) orelse _
                    (qs->kind = cast( ubyte, Tko.SYM_UDT ))
                if (qualifies = false) orelse (qs->inner = Tko.SCOPE_NONE) then
                    ok = false
                    exit while
                end if
                sc = qs->inner
                first_ = false
                if dot = 0 then exit while
                at = dot
            wend
            if ok andalso (first_ = false) then
                sid = c.syms->LookupLocalTyped( sc, sp->name, true )
            end if
        end if
        if sid = Tko.SYMBOL_NONE then sid = c.syms->LookupTyped( scope_, sp->name, true )

        '' AN INSTANTIATION -- 'Box( of long )'. One type per (generic, arguments),
        '' cached, built in the GLOBAL scope. See InstantiateGeneric_.
        ''
        '' TRIED AFTER THE LOOKUP, and given the symbol it found. It used to look the
        '' generic up itself, unqualified, from the use site's scope -- so
        '' 'FB.Array( of long )' found nothing, instantiated nothing, and bound to the
        '' GENERIC instead. Every container in the runtime headers lives in a namespace,
        '' so that was all of them.
        if sp->count > 0 then
            dim as Tko.TypeId inst = InstantiateGeneric_( c, id, sp, scope_, sid )
            if inst <> Tko.TYPE_NONE then
                c.info->SetType( id, inst )
                return inst
            end if
        end if

        if sid <> Tko.SYMBOL_NONE then
            c.info->SetRef( id, sid )
            dim as Tko.Symbol ptr s = c.syms->SymbolAt( sid )
            '' A TYPEDEF STILL HOLDING ITS PLACEHOLDER is not resolved. Collect gives
            '' every typedef a TK_TYPEDEF named type with nothing behind it. Taking that
            '' here made 'dim as t i', where t aliases a type declared LATER, bind to
            '' something that lowers to VOID -- and the declaration never looked
            '' unresolved, so nothing came back to it.
            dim as boolean ready = (s->type_ <> Tko.TYPE_NONE)
            if ready then ready = (c.types->Kind( s->type_ ) <> Tko.TK_TYPEDEF)
            if ready then base_ = s->type_
        end if
    end select

    '' A BARE ZSTRING OR WSTRING OUT OF A 'typeof' IS ONE CHARACTER.
    ''
    '' Measured: fbc REFUSES 'dim z as zstring' -- error 28, "Expected pointer" -- and
    '' ACCEPTS 'dim v as typeof( *pz )' over a 'zstring ptr', giving sizeof 1;
    '' the wide twin gives 2. So the unbounded builtin is not a variable type, and what
    '' the dereference yields is the single-element fixed one.
    ''
    '' Without this the variable came out TYPE_NONE and lowered to 'local void',
    '' which the emitter reports as "an alloca of a void slot" -- quirk/typeof.bas,
    '' where the corpus checks exactly these two lines.
    if (k = Tko.KW_TYPEOF) andalso (base_ <> Tko.TYPE_NONE) then
        if c.types->Kind( base_ ) = Tko.TK_BUILTIN then
            dim as Tko.BuiltinType bk = c.types->BuiltinOf( base_ )
            if (bk = Tko.TY_ZSTRING) orelse (bk = Tko.TY_WSTRING) then
                base_ = c.types->ArrayOf( base_, 1, 1 )
            end if
        end if
    end if

    '' 'zstring * 5' is FIVE BYTES, and 'wstring * 4' is four code units -- eight
    '' bytes on Windows, sixteen on Linux. Both are modelled as an ARRAY of the
    '' element, which is exactly what they are, so the layout falls out of the array
    '' rule instead of needing its own.
    if (sp->c <> Tko.NODE_NONE) andalso (base_ <> Tko.TYPE_NONE) then
        select case k
        case Tko.KW_ZSTRING, Tko.KW_WSTRING, Tko.KW_USTRING, Tko.KW_STRING
            '' 'string * N' IS NOT 'string'. It is the FIXED-LENGTH, space-padded
            '' flavour -- N raw bytes, no descriptor -- and resolving it to the plain
            '' string builtin gave it a 24-byte descriptor where fbc has N bytes, so
            '' every one was the wrong size and every access read the wrong thing.
            dim as Tko.Check.ConstVal lv = _
                Tko.Check.ConstOf( *c.ast, sp->c, *c.srcMgr, *c.names, _
                                   c.types->target.pointerBits, c.syms, scope_, 0, _
                                   c.types, c.info )
            if lv.known andalso (lv.value > 0) then
                if k = Tko.KW_STRING then base_ = c.types->Builtin( Tko.TY_FIXSTR )
                '' 'ustring * N' NEEDS ITS OWN ELEMENT for the same reason 'string * N'
                '' does: the plain builtin is a 24-byte DESCRIPTOR, so an array of N of
                '' them is N descriptors rather than N characters. Measured -- fbc gives
                '' 'as ustring * 4' a sizeof of 8 and this gave it 96.
                if k = Tko.KW_USTRING then base_ = c.types->Builtin( Tko.TY_FIXUSTR )
                base_ = c.types->ArrayOf( base_, 1, cast( long, lv.value ) )
            end if
        end select
    end if

    if (n->flags and Tko.NF_CONST) <> 0 then
        base_ = c.types->Qualify( base_, Tko.TF_CONST )
    end if
    c.info->SetType( id, base_ )
    return base_
end function
