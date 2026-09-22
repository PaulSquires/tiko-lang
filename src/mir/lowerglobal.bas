'' lowerglobal.bas -- what a module-level object is CALLED, and where its storage lives.
''
'' Split out of lowerstore.bas at the 1500-line lint cap and INCLUDED from it, inside the
'' same namespace. Nothing moved here changed in the move.


'' A STATIC local: procedure scope, but MODULE lifetime.
''
'' fbc emits it as a function-scoped C static, so it keeps its value across calls and is
'' initialised once rather than on entry:
''
''     void P( void ) { static int32 N$1 = 5;  N$1 = N$1 + 1; }
''
'' As a frame slot it would be reinitialised every call, which is the entire behaviour
'' the keyword exists to provide.
function IsStaticLocal( byref c as Ctx, byval sid as Tko.SymbolId ) as boolean
    dim as Tko.Symbol ptr s = c.syms->SymbolAt( sid )
    if s = 0 then return false
    if (s->flags and Tko.SYMF_SHARED) <> 0 then return false
    return ((s->flags and Tko.SYMF_STATIC) <> 0)
end function

'' The storage name for a static local, which must be unique PER PROCEDURE.
''
'' fbc names both of these N$1 and relies on C function scoping to keep them apart:
''
''     void P( void ) { static int32 N$1; ... }
''     void Q( void ) { static int32 N$1; ... }
''
'' MIR globals are one flat table with no such scoping, so the two would silently merge
'' into one variable -- P and Q sharing a counter, which is exactly the class of bug
'' DIM SHARED had in reverse. The procedure name is therefore part of the storage name.
private function StaticName( byref c as Ctx, byval sid as Tko.SymbolId ) as Tko.InternId
    dim as Tko.Symbol ptr s = c.syms->SymbolAt( sid )
    dim as string owner = "?"
    if c.f <> 0 then owner = c.names->Spelling( c.f->name )
    return c.names->GetString( owner & "$" & c.names->Spelling( s->name ) )
end function

'' The global slot for a DIM SHARED variable, created on first reference.
''
'' This exists because LocalFor matches by NAME WITHIN THE CURRENT FUNCTION, so a shared
'' variable used by two procedures got two unrelated frame slots, and a SUB assigning it
'' updated nothing anyone else could see. Storage has to be per MODULE, not per frame.
declare function UniqueGlobalName _
    ( byref c as Ctx, byval nm as Tko.InternId ) as Tko.InternId

function GlobalFor( byref c as Ctx, byval sid as Tko.SymbolId ) as long
    dim as Tko.Symbol ptr s = c.syms->SymbolAt( sid )
    if s = 0 then return -1

    '' Keyed by SYMBOL, not by spelling. Two statics called 'n' in sibling scopes of one
    '' procedure are two declarations and therefore two symbols; keying on the name
    '' merged them into a single variable that both scopes incremented.
    for i as long = 0 to c.gvarSym.Count - 1
        if c.gvarSym[i] = cast( ulong, sid ) then return c.gvarSlot[i]
    next

    dim as Tko.InternId nm = s->name
    if IsStaticLocal( c, sid ) then
        '' A STATIC MEMBER IS NOT A STATIC LOCAL. 'static x as integer' inside a type
        '' is one object for the whole program, named after the TYPE -- measured,
        '' '_ZN1T8COUNTER$E' -- while a static LOCAL is named per procedure. Naming a
        '' member the local way gave it whichever member function first touched it,
        '' so two translation units would not agree on the symbol.
        dim as Tko.SymScope ptr ps = c.syms->ScopeAt( s->parent )
        dim as boolean memberStatic = false
        if ps <> 0 then memberStatic = (ps->kind = cast( ubyte, Tko.SCOPEK_TYPE ))
        if memberStatic then
            dim as string smn = Tko.Mangle.StaticMemberName( _
                *c.syms, s->parent, *c.names, c.names->Spelling( s->name ) )
            if len( smn ) > 0 then
                nm = c.names->GetString( smn )
            else
                nm = StaticName( c, sid )
            end if
        else
            nm = StaticName( c, sid )
        end if
    end if
    '' AN EXTERN LINKS BY ITS OWN NAME, and is DECLARED rather than defined.
    dim as boolean isExt = ((s->flags and Tko.SYMF_EXTERN) <> 0)
    '' ...AND ITS DEFINITION LINKS BY THAT SAME NAME. 'extern e' then 'dim e = 5' is one
    '' object in two declarations: the reference goes out as 'E$' and the storage went
    '' out as 'e', so a second module reading it stopped at 'undefined symbol: E$'.
    '' Measured, fbc writes 'extern int32 E$;' beside 'int32 E$ = 5;' -- one name, and
    '' external linkage where a plain 'dim shared' is 'static'. ALIAS travels with it:
    '' 'extern e alias "zz"' defines 'zz'.
    dim as boolean isExtDef = ((s->flags and Tko.SYMF_EXTERN_DEF) <> 0)
    dim as boolean linksByName = (isExt orelse isExtDef)
    if linksByName andalso (s->linkName <> 0) then nm = s->linkName
    dim as long sz = SizeOfType( c, s->type_ )
    '' The storage NAME must still be unique, because it is what a linker and a golden
    '' diff see. A collision here means two distinct symbols wanted the same spelling,
    '' so the later one is suffixed rather than silently sharing.
    if linksByName = false then nm = UniqueGlobalName( c, nm )

    dim as long g = c.m->AddVarGlobal( nm, LowerType( s->type_, *c.types ), s->type_, sz )
    if isExt then c.m->globals[g].isExternal = true
    c.gvarSym.Push( cast( ulong, sid ) )
    c.gvarSlot.Push( g )
    return g
end function

'' A module-global name not already taken by a DIFFERENT symbol.
private function UniqueGlobalName _
    ( byref c as Ctx, byval nm as Tko.InternId ) as Tko.InternId

    dim as boolean taken = false
    for i as long = 0 to c.m->globals.Count - 1
        if c.m->globals[i].isVar andalso (c.m->globals[i].name = nm) then taken = true
    next
    if taken = false then return nm

    dim as string base_ = c.names->Spelling( nm )
    for n as long = 2 to 1000
        dim as Tko.InternId cand = c.names->GetString( base_ & "$" & str( n ) )
        dim as boolean used = false
        for i as long = 0 to c.m->globals.Count - 1
            if c.m->globals[i].isVar andalso (c.m->globals[i].name = cand) then used = true
        next
        if used = false then return cand
    next
    return nm
end function
