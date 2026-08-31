'' vtable.bas -- see vtable.bi for the measured rules this implements.

#include once "types/vtable.bi"

namespace Tko

function VTables.Find( byval t as TypeId ) as long
    for i as long = 0 to this.types_.Count - 1
        if this.types_[i].type_ = t then return i
    next
    return -1
end function

function VTables.SlotOf _
    ( byval t as TypeId, byval p as SymbolId, byval decl as NodeId ) as long

    dim as long vi = this.Find( t )
    if vi < 0 then return -1
    dim as VtInfo ptr v = @this.types_[vi]
    for i as long = 0 to v->count - 1
        if this.slots[v->first + i].proc_ = p then return i
    next

    '' AN ABSTRACT SLOT HAS NO PROCEDURE: its entry in the emitted table is null and an
    '' override fills it, so a call to the abstract DECLARATION itself matched nothing
    '' and was emitted as a DIRECT call to a procedure with no body -- silently, and for
    '' every call through a base handle to an abstract method, which is the whole of
    '' fb/comptr.bi's surface. Matched by its DECLARATION NODE instead.
    if decl = NODE_NONE then return -1
    for i as long = 0 to v->count - 1
        if this.slots[v->first + i].decl = decl then return i
    next
    return -1
end function

'' The procedure declaration's PARAMETER TYPES, in order. 'this' is not among them --
'' it is not written and not an N_PARAM -- which is what makes a base's method and a
'' derived type's override comparable at all.
private sub ParamTypes_ _
    ( byref ast as AstArena, byref info as SemanticInfo, byval decl as NodeId, _
      byref outv as FB.Array( of ulong ) )

    if decl = NODE_NONE then return
    if ast.Kind( decl ) <> N_PROC then return
    dim as StmtPayload ptr sp = @ast.stmts[cast( long, ast.nodes[cast( long, decl )].data )]
    for i as long = 0 to sp->count - 1
        dim as NodeId prm = cast( NodeId, ast.children[sp->first + i] )
        if ast.Kind( prm ) <> N_PARAM then continue for
        dim as StmtPayload ptr pp = @ast.stmts[cast( long, ast.nodes[cast( long, prm )].data )]
        outv.Push( cast( ulong, info.TypeOf_( pp->a ) ) )
    next
end sub

'' Does this declaration OVERRIDE that one? Same name, same parameter types.
''
'' fbc does not require the OVERRIDE keyword, and the corpus writes it both ways, so
'' matching on the signature is the rule rather than on the modifier. The return type
'' is deliberately not compared: fbc rejects a mismatched one, and treating it as a
'' NON-match here would silently append a second slot instead.
private function Overrides_ _
    ( byref ast as AstArena, byref info as SemanticInfo, byval a as NodeId, _
      byval b as NodeId ) as boolean

    dim as FB.Array( of ulong ) pa, pb
    ParamTypes_( ast, info, a, pa )
    ParamTypes_( ast, info, b, pb )
    if pa.Count <> pb.Count then return false
    for i as long = 0 to pa.Count - 1
        if pa[i] <> pb[i] then return false
    next
    return true
end function

'' The type this one extends, or TYPE_NONE. 'extends' is a field named 'base' at
'' offset 0 -- see the parser -- so the base type is that field's type.
private function BaseTypeOf_ _
    ( byref syms as SymbolTable, byval s as Symbol ptr, byval baseNm as InternId ) as TypeId

    if s = 0 then return TYPE_NONE
    if s->inner = SCOPE_NONE then return TYPE_NONE
    dim as SymbolId bf = syms.LookupLocal( s->inner, baseNm )
    if bf = SYMBOL_NONE then return TYPE_NONE
    dim as Symbol ptr b = syms.SymbolAt( bf )
    if b = 0 then return TYPE_NONE
    if b->kind <> cast( ubyte, SYM_FIELD ) then return TYPE_NONE
    return b->type_
end function

'' The UDT symbol a TypeId belongs to.
private function UdtSymbolOf_ _
    ( byref syms as SymbolTable, byref types as TypeContext, byval t as TypeId ) as SymbolId

    if t = TYPE_NONE then return SYMBOL_NONE
    if types.Kind( t ) <> TK_UDT then return SYMBOL_NONE
    dim as InternId tn = types.NameOf( t )
    if tn = 0 then return SYMBOL_NONE
    dim as ScopeId ds = cast( ScopeId, types.DeclScopeOf( t ) )
    dim as SymbolId ts = syms.LookupLocalTyped( ds, tn, true )
    if ts = SYMBOL_NONE then ts = syms.LookupTyped( ds, tn, true )
    return ts
end function

'' Does this type extend OBJECT, transitively? That -- and nothing about the methods --
'' is what decides whether there is a table at all.
private function ExtendsObject_ _
    ( byref syms as SymbolTable, byref types as TypeContext, byval t as TypeId, _
      byval baseNm as InternId, byval objNm as InternId ) as boolean

    dim as TypeId cur = t
    dim as long guard = 0
    while (cur <> TYPE_NONE) andalso (guard < 64)
        guard += 1
        if types.NameOf( cur ) = objNm then return true
        dim as SymbolId s = UdtSymbolOf_( syms, types, cur )
        dim as TypeId nx = BaseTypeOf_( syms, syms.SymbolAt( s ), baseNm )
        if nx = cur then return false
        cur = nx
    wend
    return false
end function

'' One type's table: the base's slots, then this type's own virtuals, with an override
'' REPLACING the slot it matches rather than appending.
private function BuildOne_ _
    ( byval t as TypeId, byref ast as AstArena, byref syms as SymbolTable, _
      byref types as TypeContext, byref info as SemanticInfo, _
      byref store as VTables, byval objNm as InternId ) as boolean

    if store.Find( t ) >= 0 then return true
    dim as SymbolId ts = UdtSymbolOf_( syms, types, t )
    dim as Symbol ptr s = syms.SymbolAt( ts )
    if s = 0 then return false

    '' THE BASE FIRST, and only once it has a table of its own: its slots are this
    '' type's leading slots, in its order, and an override has to find them there.
    dim as TypeId bt = BaseTypeOf_( syms, s, store.baseName )
    if (bt <> TYPE_NONE) andalso (bt <> t) then
        if store.Find( bt ) < 0 then return false
    end if

    dim as VtInfo v
    v.type_ = t
    v.first = store.slots.Count
    v.count = 0

    if (bt <> TYPE_NONE) andalso (bt <> t) then
        dim as long bi = store.Find( bt )
        if bi >= 0 then
            dim as VtInfo ptr b = @store.types_[bi]
            for i as long = 0 to b->count - 1
                store.slots.Push( store.slots[b->first + i] )
                v.count += 1
            next
        end if
    end if

    '' This type's own procedures, IN DECLARATION ORDER. Overload chains hang off the
    '' symbol in the scope list, and each link is its own declaration, so both are
    '' walked: two overloads of one virtual name are two slots.
    if s->inner <> SCOPE_NONE then
        dim as SymScope ptr sc = syms.ScopeAt( s->inner )
        if sc <> 0 then
            dim as SymbolId cur = sc->firstSym
            dim as long guard = 0
            while (cur <> SYMBOL_NONE) andalso (guard < 100000)
                guard += 1
                dim as Symbol ptr m = syms.SymbolAt( cur )
                if m = 0 then exit while
                dim as SymbolId nextInScope = m->nextInScope
                dim as SymbolId ov = cur
                while ov <> SYMBOL_NONE
                    dim as Symbol ptr mo = syms.SymbolAt( ov )
                    if mo = 0 then exit while
                    if mo->kind = cast( ubyte, SYM_PROC ) then
                        dim as NodeId decl = cast( NodeId, mo->payload )
                        if (decl <> NODE_NONE) andalso (ast.Kind( decl ) = N_PROC) then
                            dim as StmtPayload ptr pp = _
                                @ast.stmts[cast( long, ast.nodes[cast( long, decl )].data )]
                            dim as boolean isAbstract = ((pp->extra and PF_ABSTRACT) <> 0)
                            dim as boolean isVirtual = ((pp->extra and PF_VIRTUAL) <> 0) orelse _
                                                       isAbstract

                            '' AN OVERRIDE NEED NOT SAY 'virtual'. What makes a
                            '' procedure occupy a slot is matching an inherited one --
                            '' 'declare function f( ) as long override' carries neither
                            '' modifier tiko-lang records, and it is B's f that a call through
                            '' an A ptr must reach.
                            dim as long at = -1
                            for i as long = 0 to v.count - 1
                                dim as VtSlot ptr sl = @store.slots[v.first + i]
                                if sl->name <> mo->name then continue for
                                if Overrides_( ast, info, sl->decl, decl ) then
                                    at = i
                                    exit for
                                end if
                            next

                            if at >= 0 then
                                '' AN ABSTRACT SLOT IS NULL, and an override fills it.
                                store.overrode.Push( cast( ulong, decl ) )
                                dim as VtSlot ptr sl = @store.slots[v.first + at]
                                sl->proc_ = iif( isAbstract, cast( SymbolId, SYMBOL_NONE ), ov )
                                sl->decl = decl
                            elseif isVirtual then
                                dim as VtSlot ns
                                ns.proc_ = iif( isAbstract, cast( SymbolId, SYMBOL_NONE ), ov )
                                ns.name = mo->name
                                ns.decl = decl
                                store.slots.Push( ns )
                                v.count += 1
                            end if
                        end if
                    end if
                    ov = mo->nextOverload
                wend
                cur = nextInScope
            wend
        end if
    end if

    store.types_.Push( v )
    return true
end function

function ComputeVTables _
    ( byref ast as AstArena, byref syms as SymbolTable, byref types as TypeContext, _
      byref info as SemanticInfo, byref store as VTables ) as long

    if syms.names = 0 then return 0
    store.baseName = syms.names->GetString( "base" )
    dim as InternId objNm = syms.names->GetString( "object" )

    '' A base must be built before what derives from it, and the depth is small, so the
    '' same repeat-until-nothing-new shape the layout pass uses serves here too: a cycle
    '' stops making progress instead of recursing.
    dim as boolean progress = true
    while progress
        progress = false
        for i as long = 1 to syms.Count( )
            dim as Symbol ptr s = syms.SymbolAt( cast( SymbolId, i ) )
            if s = 0 then continue for
            if s->kind <> cast( ubyte, SYM_UDT ) then continue for
            if s->type_ = TYPE_NONE then continue for
            if store.Find( s->type_ ) >= 0 then continue for
            if ExtendsObject_( syms, types, s->type_, store.baseName, objNm ) = false then
                continue for
            end if
            if BuildOne_( s->type_, ast, syms, types, info, store, objNm ) then
                progress = true
            end if
        next
    wend
    return store.types_.Count
end function

function DumpVTables _
    ( byref ast as AstArena, byref store as VTables, byref types as TypeContext, _
      byref names as Interner, byref syms as SymbolTable, _
      byref info as SemanticInfo ) as string

    dim as string outp = ""
    for i as long = 0 to store.types_.Count - 1
        dim as VtInfo ptr v = @store.types_[i]
        outp += types.Name( v->type_ ) & " vtable " & str( v->count ) & " slot(s)" & chr( 10 )
        for j as long = 0 to v->count - 1
            dim as VtSlot ptr sl = @store.slots[v->first + j]
            dim as string who = "<abstract>"
            if (sl->proc_ <> SYMBOL_NONE) andalso (sl->decl <> NODE_NONE) then
                who = Mangle.ProcName( ast, sl->decl, syms, names, types, info )
            end if
            outp += "  slot " & str( j ) & " " & who & chr( 10 )
        next
    next
    outp += "vtables: " & str( store.types_.Count ) & chr( 10 )
    return outp
end function

end namespace
