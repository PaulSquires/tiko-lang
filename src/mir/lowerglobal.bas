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
    dim as long knownG = c.gvarBySym.Find( cast( ulong, sid ) )
    if knownG >= 0 then return knownG

    dim as Tko.InternId nm = s->name
    '' HOISTED because it decides the LINKAGE too, further down: a static MEMBER is the
    '' one static object other modules are entitled to reach.
    dim as boolean memberStatic = false
    if IsStaticLocal( c, sid ) then
        '' A STATIC MEMBER IS NOT A STATIC LOCAL. 'static x as integer' inside a type
        '' is one object for the whole program, named after the TYPE -- measured,
        '' '_ZN1T8COUNTER$E' -- while a static LOCAL is named per procedure. Naming a
        '' member the local way gave it whichever member function first touched it,
        '' so two translation units would not agree on the symbol.
        dim as Tko.SymScope ptr ps = c.syms->ScopeAt( s->parent )
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
    '' A COMMON LINKS BY NAME TOO, as 'NAME$' -- measured, fbc writes 'int32 COMV$
    '' __attribute__((common))' -- and a namespaced extern or common by its NESTED name,
    '' '_ZN2N12V$E', the static member's form. Both went out as the bare name: two
    '' namespaces each with 'extern v : dim v' were ONE variable ('print N1.v, N2.v' gave
    '' '2 2' where fbc gives '1 2'), and a common shared with an fbc-built object was two.
    '' An ALIAS or an extern "C" name is the user's spelling and stays as it is.
    dim as boolean isCommonVar = ((s->flags and Tko.SYMF_COMMON) <> 0)
    if linksByName orelse isCommonVar then
        dim as string dflt = Tko.Text.UpperAscii( c.names->Spelling( s->name ) ) & "$"
        dim as boolean ownSpelling = false
        if linksByName andalso (s->linkName <> 0) then
            ownSpelling = (c.names->Spelling( s->linkName ) <> dflt)
        end if
        if ownSpelling = false then
            nm = c.names->GetString( dflt )
            dim as Tko.SymScope ptr vps = c.syms->ScopeAt( s->parent )
            if vps <> 0 then
                if vps->kind = cast( ubyte, Tko.SCOPEK_NAMESPACE ) then
                    dim as string qn = Tko.Mangle.StaticMemberName( _
                        *c.syms, s->parent, *c.names, c.names->Spelling( s->name ) )
                    if len( qn ) > 0 then nm = c.names->GetString( qn )
                end if
            end if
        end if
        linksByName = true
    end if
    '' A MODULE'S VARIABLE LINKS BY ITS CHAIN (ADR 0017): _ZN4ACME3NET4HTTP7COUNTERE.
    dim as boolean modVar = ((s->flags and Tko.SYMF_MODSRC) <> 0)
    if modVar then modVar = (linksByName = false)
    if modVar then nm = c.names->GetString( Tko.Mangle.ModuleVarName( *c.syms, sid, *c.names ) )
    dim as long sz = SizeOfType( c, s->type_ )
    '' The storage NAME must still be unique, because it is what a linker and a golden
    '' diff see. A collision here means two distinct symbols wanted the same spelling,
    '' so the later one is suffixed rather than silently sharing.
    if linksByName = false then nm = UniqueGlobalName( c, nm )

    dim as long g = c.m->AddVarGlobal( nm, LowerType( s->type_, *c.types ), s->type_, sz )
    c.m->globals[g].sym = cast( ulong, sid )
    '' AND WHO MAY SEE IT. Everything here went out with external linkage, so two modules
    '' that each wrote 'dim shared e' -- or each held a 'private sub P' with a 'static sl'
    '' -- were 'lld-link: error: duplicate symbol: e', where fbc compiles both and gives
    '' each module its own object. Measured, fbc's linkage for every shape this function
    '' names:
    ''
    ''     dim shared sh             static int32 SH$ = 1      d   internal
    ''     static shared st          static int32 ST$ = 3      d   internal
    ''     static sl (in a sub)      static int32 SL$1.1954    d   internal
    ''     common shared cm          int32 CM$                 C   common
    ''     static member T.cnt       int32 _ZN1T4CNT$E         C   common
    ''     extern e : dim e = 5      int32 E$ = 5              D   external
    ''
    '' -- internal unless the object is one OTHER MODULES ARE ENTITLED TO REACH, which
    '' is COMMON, a type's static member, and an EXTERN either way. Those three keep the
    '' linkage they had; the name is what has to stay unique for them.
    '' Those three are TENTATIVE until something initialises them -- see
    '' MirGlobal.isTentative, which the emitter resolves once the initializer, if there
    '' is one, has been attached.
    dim as boolean isCommon = ((s->flags and Tko.SYMF_COMMON) <> 0)
    dim as boolean sharedOut = (isExtDef orelse isCommon orelse memberStatic)
    if isExt then
        c.m->globals[g].isExternal = true
        c.m->globals[g].isDllImport = ((s->flags and Tko.SYMF_DLLIMPORT) <> 0)
    elseif modVar then
        '' Module code: 'private' is internal; 'public' external; the default external
        '' and hidden (RFC-0002 §4).
        if (s->flags and Tko.SYMF_PRIVDECL) <> 0 then
            c.m->globals[g].isInternal = true
        elseif (s->flags and Tko.SYMF_PUBLIC) = 0 then
            c.m->globals[g].isHidden = true
        end if
    elseif sharedOut then
        c.m->globals[g].isTentative = true
    else
        c.m->globals[g].isInternal = true
    end if
    c.gvarSym.Push( cast( ulong, sid ) )
    c.gvarSlot.Push( g )
    c.gvarBySym.Put( cast( ulong, sid ), g )
    return g
end function

'' A module-global name not already taken by a DIFFERENT symbol.
private function UniqueGlobalName _
    ( byref c as Ctx, byval nm as Tko.InternId ) as Tko.InternId

    '' By the module's name index, not a scan of every global (audit F-63).
    if c.m->FindVarGlobal( nm ) < 0 then return nm

    dim as string base_ = c.names->Spelling( nm )
    for n as long = 2 to 1000
        dim as Tko.InternId cand = c.names->GetString( base_ & "$" & str( n ) )
        if c.m->FindVarGlobal( cand ) < 0 then return cand
    next
    return nm
end function
