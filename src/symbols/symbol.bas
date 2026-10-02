'' symbol.bas -- see symbol.bi

#include once "symbols/symbol.bi"

namespace Tko

'' ------------------------------------------------------------------- metadata

dim shared as zstring ptr symKindNames( 0 to SYM_KIND_COUNT - 1 )
dim shared as boolean symNamesReady = false

private sub InitSymNames( )
    if symNamesReady then return
    for i as long = 0 to SYM_KIND_COUNT - 1
        symKindNames(i) = @"?"
    next
    #macro SYM( s_id, s_name )
        symKindNames(s_id) = @s_name
    #endmacro
    TKO_SYMKIND_LIST( SYM )
    #undef SYM
    symNamesReady = true
end sub

function SymbolKindName( byval k as SymbolKind ) as string
    InitSymNames( )
    dim as boolean bad = (k < 0) orelse (k >= SYM_KIND_COUNT)
    if bad then return "?"
    return *symKindNames(k)
end function

function ScopeKindName( byval k as ScopeKind ) as string
    select case k
    case SCOPEK_GLOBAL    : return "global"
    case SCOPEK_MODULE    : return "module"
    case SCOPEK_NAMESPACE : return "namespace"
    case SCOPEK_TYPE      : return "type"
    case SCOPEK_PROC      : return "proc"
    case else             : return "block"
    end select
end function

'' ------------------------------------------------------------------- lifetime

const SYMTAB_INITIAL_SLOTS as long = 4096
const SYMTAB_LOAD_NUM as long = 7
const SYMTAB_LOAD_DEN as long = 10

constructor SymbolTable( )
    this.names = 0
    this.mask = 0
    this.occupied = 0

    '' Index 0 is the "none" sentinel for both tables.
    dim as Symbol z
    z.kind = cast( ubyte, SYM_NONE )
    this.symbols.Push( z )

    dim as SymScope zs
    zs.kind = cast( ubyte, SCOPEK_GLOBAL )
    this.scopes.Push( zs )

    '' Scope 1 is always global.
    dim as SymScope g
    g.kind = cast( ubyte, SCOPEK_GLOBAL )
    g.parent = SCOPE_NONE
    g.owner = SYMBOL_NONE
    g.firstSym = SYMBOL_NONE
    g.lastSym = SYMBOL_NONE
    g.count = 0
    this.scopes.Push( g )

    this.usePos = USEPOS_LATEST
    this.aliasPos = 0
    this.undefs = 0
    this.shadows = 0
    this.Rehash( SYMTAB_INITIAL_SLOTS )
end constructor

sub SymbolTable.Attach( byval it as Interner ptr )
    this.names = it
end sub

function SymbolTable.Count( ) as long
    return this.symbols.Count - 1
end function

function SymbolTable.ScopeCount( ) as long
    return this.scopes.Count - 1
end function

function SymbolTable.SymbolAt( byval id as SymbolId ) as Symbol ptr
    if id = SYMBOL_NONE then return 0
    if cast( long, id ) >= this.symbols.Count then return 0
    return @this.symbols[cast( long, id )]
end function

function SymbolTable.ScopeAt( byval id as ScopeId ) as SymScope ptr
    if id = SCOPE_NONE then return 0
    if cast( long, id ) >= this.scopes.Count then return 0
    return @this.scopes[cast( long, id )]
end function

'' --------------------------------------------------------------------- lookup
'' One open-addressed table keyed by (scope, name) rather than a hash per scope:
'' a scope is usually tiny, and thousands of tiny tables cost more than one big one.

private function ScopeNameHash _
    ( byval scope_ as ScopeId, byval nm as InternId ) as ulong

    dim as ulong h = &h811C9DC5
    h xor= cast( ulong, scope_ )
    h *= &h01000193
    h xor= cast( ulong, nm )
    h *= &h01000193
    return h
end function

sub SymbolTable.Rehash( byval newSlots as long )
    dim as SymSlotVec fresh
    fresh.Reserve( newSlots )
    for i as long = 0 to newSlots - 1
        fresh.Push( 0 )
    next

    dim as long newMask = newSlots - 1
    for i as long = 1 to this.symbols.Count - 1
        dim as Symbol ptr s = @this.symbols[i]
        '' Only the FIRST of an overload chain is indexed; the rest hang off it. And
        '' only the NEWEST generation of a name: an older one hangs off that.
        if (s->flags and (SYMF_OVERLOAD or SYMF_SUPERSEDED)) <> 0 then continue for
        dim as long slot = cast( long, ScopeNameHash( s->parent, s->name ) ) and newMask
        while fresh[slot] <> 0
            slot = (slot + 1) and newMask
        wend
        fresh[slot] = cast( ulong, i )
    next

    swap this.slots, fresh
    this.mask = newMask
end sub

'' UDT and TYPEDEF are the type-name class. ENUM is deliberately NOT: measured, once
'' 'enum E' exists a bare E is an enum reference and fbc asks for a period, so an enum
'' name does NOT coexist with a value of the same name.
function IsTypeNameKind( byval k as SymbolKind ) as boolean
    return (k = SYM_UDT) orelse (k = SYM_TYPEDEF)
end function

function SymbolTable.SlotFor _
    ( byval scope_ as ScopeId, byval nm as InternId ) as long

    dim as long slot = cast( long, ScopeNameHash( scope_, nm ) ) and this.mask
    while this.slots[slot] <> 0
        dim as Symbol ptr s = @this.symbols[cast( long, this.slots[slot] )]
        if (s->parent = scope_) andalso (s->name = nm) then return slot
        slot = (slot + 1) and this.mask
    wend
    return slot
end function

function SymbolTable.LookupLocal _
    ( byval scope_ as ScopeId, byval nm as InternId ) as SymbolId

    if scope_ = SCOPE_NONE then return SYMBOL_NONE
    dim as long slot = this.SlotFor( scope_, nm )
    dim as SymbolId head = cast( SymbolId, this.slots[slot] )
    if head = SYMBOL_NONE then return head
    if this.aliasPairSym.Count > 0 then
        if this.AliasHidden( head ) then return SYMBOL_NONE
    end if
    if (this.undefs = 0) andalso (this.shadows = 0) then return head
    return this.LiveGen( head )
end function

function SymbolTable.AliasHidden( byval sid as SymbolId ) as boolean
    dim as ulong at = this.usePos
    if at = USEPOS_LATEST then at = this.aliasPos
    if (at = 0) orelse (at >= cast( ulong, this.nodeModFile.Count )) then return false
    dim as ulong f = this.nodeModFile[at]
    if f = 0 then return false
    dim as boolean isAlias = false
    for k as long = 0 to this.aliasPairSym.Count - 1
        if this.aliasPairSym[k] <> cast( ulong, sid ) then continue for
        isAlias = true
        if this.aliasPairFile[k] = f then return false
    next
    return isAlias
end function

'' THE GENERATION OF A NAME VISIBLE FROM 'usePos' -- see UndefSym. Newest first: a
'' symbol an '#undef' replaced hangs off its successor through 'olderGen', and each is
'' visible from where it was born up to the '#undef' that removed it.
function SymbolTable.LiveGen( byval id as SymbolId ) as SymbolId
    dim as long guard = 0
    while (id <> SYMBOL_NONE) andalso (guard < 4096)
        guard += 1
        dim as Symbol ptr s = @this.symbols[cast( long, id )]
        dim as boolean born = (s->bornAt <= this.usePos)
        dim as boolean alive = (s->diedAt = 0) orelse (this.usePos < s->diedAt)
        if born andalso alive then return id
        id = s->olderGen
    wend
    return SYMBOL_NONE
end function

'' A name inside a NAMESPACE, following that namespace's OWN usings.
''
'' LookupLocal is a single hash probe and never sees a using; the walking Lookup follows
'' the ENCLOSING-SCOPE chain and never descends into a named namespace. So
''
''     namespace n3 : using n1.n2 : end namespace
''     r = n3.v2
''
'' found nothing -- and the same gap took a leading '.name' under a file-scope using and
'' every later component of a qualified type path.
''
'' DEPTH-LIMITED rather than visited-set: a using chain can be CYCLIC
'' (namespace/using_rec.bas is), and a bound is enough because the answer at depth n is
'' the answer at depth n+1 for anything a program can write.
'' A NAME A MODULE'S INTERFACE DOES NOT CALL 'public' (ADR 0017; RFC-0002 §3) is there for
'' the module's own generic bodies, which find it by the ordinary scope walk from inside
'' the module's namespace. Reached THROUGH the namespace -- 'http.Send_', or unqualified
'' through 'using http' -- it is not found, and the unit's undeclared-name report says why
'' (TKO0860, from hiddenHits).
function SymbolTable.IsImportNs( byval sid as SymbolId ) as boolean
    for each x as ulong in this.importNs
        if x = cast( ulong, sid ) then return true
    next
    return false
end function

function SymbolTable.PublicOnly( byval got as SymbolId ) as SymbolId
    if got = SYMBOL_NONE then return got
    if this.privileged then return got
    dim as ulong f = this.symbols[cast( long, got )].flags
    if (f and (SYMF_IMPORTED or SYMF_PUBLIC)) <> SYMF_IMPORTED then return got
    '' A NAMESPACE has no word of its own: its members each say whether they are public.
    if this.symbols[cast( long, got )].kind = cast( ubyte, SYM_NAMESPACE ) then return got
    this.hiddenHits.Push( cast( ulong, got ) )
    return SYMBOL_NONE
end function

'' THE MODULE WHOSE HIDDEN NAME THIS IS, when a lookup through a module's namespace found
'' it and would not return it (SymbolTable.PublicOnly): its chain, as written in source.
'' "" when no lookup did.
function SymbolTable.HiddenModuleOf( byval nm as InternId ) as string
    for each h as ulong in this.hiddenHits
        dim as Symbol ptr s = this.SymbolAt( cast( SymbolId, h ) )
        if s = 0 then continue for
        if s->name <> nm then continue for
        '' Up to the module's namespace.
        dim as ScopeId cur = s->parent
        while cur <> SCOPE_NONE
            dim as SymScope ptr sc = this.ScopeAt( cur )
            if sc = 0 then exit while
            for k as long = 0 to this.importNs.Count - 1
                if this.importNs[k] = cast( ulong, sc->owner ) then
                    return lcase( this.importChains[k] )
                end if
            next
            cur = sc->parent
        wend
    next
    return ""
end function

function SymbolTable.LookupInNamespace _
    ( byval nsScope as ScopeId, byval nm as InternId, _
      byval depth as long ) as SymbolId

    if nsScope = SCOPE_NONE then return SYMBOL_NONE
    dim as SymbolId got = this.LookupLocal( nsScope, nm )
    if got <> SYMBOL_NONE then return this.PublicOnly( got )
    if depth >= 8 then return SYMBOL_NONE
    for i as long = 0 to this.usingAt.Count - 1
        if this.usingAt[i] <> cast( ulong, nsScope ) then continue for
        got = this.LookupInNamespace( cast( ScopeId, this.usingInner[i] ), nm, depth + 1 )
        if got <> SYMBOL_NONE then return got
    next
    return SYMBOL_NONE
end function

'' The same, WANTING A TYPE NAME (or wanting not to be one). LookupTyped's using loop
'' probed the used namespace ONCE and stopped, so a using that leads through a second
'' using found nothing:
''
''     namespace foo : type t1 : as long v : end type : end namespace
''     namespace bar : using foo : ... : end namespace
''     using bar
''     foobar( type<t1>( -123 ) )
''
'' fbc accepts that and prints -123; tiko-lang could not see t1 at all, so the type
'' literal was untyped and the argument declined. LookupInNamespace already follows
'' the chain for VALUES and this is the same walk, asking the type question.
''
'' DEPTH-LIMITED for the same reason: a using chain can be cyclic.
function SymbolTable.LookupInNamespaceTyped _
    ( byval nsScope as ScopeId, byval nm as InternId, byval wantType as boolean, _
      byval depth as long ) as SymbolId

    if nsScope = SCOPE_NONE then return SYMBOL_NONE
    dim as SymbolId got = this.LookupLocalTyped( nsScope, nm, wantType )
    if got <> SYMBOL_NONE then
        dim as Symbol ptr g = @this.symbols[cast( long, got )]
        if IsTypeNameKind( cast( SymbolKind, g->kind ) ) = wantType then return this.PublicOnly( got )
    end if
    if depth >= 8 then return SYMBOL_NONE
    for i as long = 0 to this.usingAt.Count - 1
        if this.usingAt[i] <> cast( ulong, nsScope ) then continue for
        got = this.LookupInNamespaceTyped( _
            cast( ScopeId, this.usingInner[i] ), nm, wantType, depth + 1 )
        if got <> SYMBOL_NONE then return got
    next
    return SYMBOL_NONE
end function

'' A name reachable only through a USING in effect at 'scope_'.
''
'' The scope's own usings and every enclosing scope's, and NOT the scopes' own
'' declarations -- which is exactly what a leading '.name' needs, because it must not
'' see an ordinary local. Measured: fbc accepts
''
''     sub s( ) : using n1 : r = .v1 : end sub
''
'' and resolves it to n1.v1, so a using written INSIDE a procedure counts. The file-scope
'' probe alone missed every one of those.
function SymbolTable.LookupThroughUsings _
    ( byval scope_ as ScopeId, byval nm as InternId ) as SymbolId

    dim as ScopeId s = scope_
    dim as long guard = 0
    while (s <> SCOPE_NONE) andalso (guard < 1024)
        guard += 1
        for i as long = 0 to this.usingAt.Count - 1
            if this.usingAt[i] <> cast( ulong, s ) then continue for
            dim as SymbolId got = _
                this.LookupInNamespace( cast( ScopeId, this.usingInner[i] ), nm )
            if got <> SYMBOL_NONE then return got
        next
        dim as SymScope ptr sc = this.ScopeAt( s )
        if sc = 0 then exit while
        s = sc->parent
    wend
    return SYMBOL_NONE
end function

function SymbolTable.LookupLocalTyped _
    ( byval scope_ as ScopeId, byval nm as InternId, _
      byval wantType as boolean ) as SymbolId

    dim as SymbolId head = this.LookupLocal( scope_, nm )
    if head = SYMBOL_NONE then return SYMBOL_NONE
    dim as Symbol ptr h = @this.symbols[cast( long, head )]
    if IsTypeNameKind( cast( SymbolKind, h->kind ) ) = wantType then return head
    dim as SymbolId alt = h->altClass
    dim as boolean byPos = (this.undefs > 0) orelse (this.shadows > 0)
    if (alt <> SYMBOL_NONE) andalso byPos then alt = this.LiveGen( alt )
    if alt = SYMBOL_NONE then return head
    return alt
end function

'' A DECLARATION ON THE SCOPE CHAIN BEATS EVERY 'using' -- fbc's rule, measured on fbc-modern
'' 1.20, 2026-10-02: under a 'using N' in a sub, a 'const C' at module level is what 'C'
'' means, and N.C only when nothing on the chain declares one, whatever scope the using is
'' written in. tiko took the using first wherever it was nearer (T58). The usings are only
'' asked when the chain has nothing -- or has only a declaration BELOW the use, which fbc,
'' reading top to bottom, has not met yet (declAt; never in an order-free module).
private function DeclaredAbove_( byref t as SymbolTable, byval id as SymbolId ) as boolean
    if t.usePos = USEPOS_LATEST then return true
    if t.modFileCount > 0 then return true
    dim as ulong at = t.symbols[cast( long, id )].declAt
    return (at = 0) orelse (at <= t.usePos)
end function

function SymbolTable.LookupTyped _
    ( byval scope_ as ScopeId, byval nm as InternId, _
      byval wantType as boolean ) as SymbolId

    dim as SymbolId decl = SYMBOL_NONE
    dim as ScopeId sc = scope_
    dim as long guard = 0
    while (sc <> SCOPE_NONE) andalso (guard < 256)
        guard += 1
        dim as SymbolId got = this.LookupLocalTyped( sc, nm, wantType )
        if got <> SYMBOL_NONE then
            dim as Symbol ptr g = @this.symbols[cast( long, got )]
            if IsTypeNameKind( cast( SymbolKind, g->kind ) ) = wantType then
                decl = got
                exit while
            end if
        end if
        dim as SymScope ptr s_ = this.ScopeAt( sc )
        if s_ = 0 then exit while
        sc = s_->parent
    wend
    if decl <> SYMBOL_NONE then
        if (this.usingAt.Count = 0) orelse DeclaredAbove_( this, decl ) then return decl
    end if

    '' 'using ns' MAKES ITS TYPE NAMES VISIBLE TOO, innermost using first. Lookup( ) walked
    '' the using scopes and this did not, so 'using ns1 : dim b as B' found nothing and the
    '' variable's slot lowered to void.
    sc = scope_
    guard = 0
    while (sc <> SCOPE_NONE) andalso (guard < 256)
        guard += 1
        for i as long = 0 to this.usingAt.Count - 1
            if this.usingAt[i] <> cast( ulong, sc ) then continue for
            '' ...AND THROUGH THAT NAMESPACE'S OWN USINGS. See
            '' LookupInNamespaceTyped: a single probe missed every transitive one.
            dim as SymbolId got = this.LookupInNamespaceTyped( _
                cast( ScopeId, this.usingInner[i] ), nm, wantType, 0 )
            if got <> SYMBOL_NONE then return got
        next
        dim as SymScope ptr s_ = this.ScopeAt( sc )
        if s_ = 0 then exit while
        sc = s_->parent
    wend
    if decl <> SYMBOL_NONE then return decl
    return this.Lookup( scope_, nm )
end function

function SymbolTable.Lookup _
    ( byval scope_ as ScopeId, byval nm as InternId ) as SymbolId

    '' The declarations on the chain, innermost first...
    dim as SymbolId decl = SYMBOL_NONE
    dim as ScopeId s = scope_
    dim as long guard = 0
    while s <> SCOPE_NONE
        guard += 1
        if guard > 1024 then exit while          '' a cycle would be a table bug
        decl = this.LookupLocal( s, nm )
        if decl <> SYMBOL_NONE then exit while
        dim as SymScope ptr sc = this.ScopeAt( s )
        if sc = 0 then exit while
        s = sc->parent
    wend
    if decl <> SYMBOL_NONE then
        if (this.usingAt.Count = 0) orelse DeclaredAbove_( this, decl ) then return decl
    end if

    '' ...then 'using ns', which makes the namespace's names visible UNQUALIFIED from where
    '' it stands, innermost first. Two usings that both supply the name are TKO0919, checked
    '' after Resolve (declshape.bas).
    s = scope_
    guard = 0
    while s <> SCOPE_NONE
        guard += 1
        if guard > 1024 then exit while
        for i as long = 0 to this.usingAt.Count - 1
            if this.usingAt[i] <> cast( ulong, s ) then continue for
            dim as SymbolId got = this.PublicOnly( this.LookupLocal( cast( ScopeId, this.usingInner[i] ), nm ) )
            if got <> SYMBOL_NONE then return got
        next
        dim as SymScope ptr sc = this.ScopeAt( s )
        if sc = 0 then exit while
        s = sc->parent
    wend
    return decl
end function

'' A LOCAL THAT SHADOWS AN OUTER NAME, born at its own declaration. LiveGen already
'' answers SYMBOL_NONE for a symbol a lookup is above, and a local has no 'olderGen'
'' to fall back to, so the walking Lookup carries on into the enclosing scope on its
'' own -- which is the whole of the behaviour wanted.
sub SymbolTable.ShadowFrom _
    ( byval id as SymbolId, byval at as ulong )

    if id = SYMBOL_NONE then return
    if at = 0 then return                    '' 0 already means 'from the start'
    dim as Symbol ptr s = @this.symbols[cast( long, id )]
    if s->bornAt <> 0 then return            '' an '#undef' generation owns it
    s->bornAt = at
    this.shadows += 1
end sub

sub SymbolTable.AddUsing _
    ( byval scope_ as ScopeId, byval nsScope as ScopeId )
    if (scope_ = SCOPE_NONE) orelse (nsScope = SCOPE_NONE) then return
    for i as long = 0 to this.usingAt.Count - 1
        if (this.usingAt[i] = cast( ulong, scope_ )) andalso _
           (this.usingInner[i] = cast( ulong, nsScope )) then return
    next
    this.usingAt.Push( cast( ulong, scope_ ) )
    this.usingInner.Push( cast( ulong, nsScope ) )
end sub

'' '#undef name' OF A DECLARED SYMBOL. fbc keeps macros and symbols in one table and
'' '#undef' deletes the first entry its lookup finds. Measured on fbc-modern:
''
''     declare foo alias "fooA"( integer ) : #undef foo : declare foo alias "fooB"( string )
''         a call after the '#undef' calls fooB; one written BEFORE it still calls fooA
''     an OVERLOADED foo: one '#undef' removes the FIRST overload, a second the next
''     a local x over a global x: '#undef x' in the sub, and 'print x' prints the global
''     '#undef g' inside a sub removes the MODULE-LEVEL g for the rest of the file
''     a TYPE and a VARIABLE of one name: the one declared LATER goes first
''
'' Nothing is deleted. Uses are bound after Collect, so the symbol stays and is dead from
'' 'at' on: a lookup made from before 'at' still finds it, and a later declaration of the
'' name starts a new generation in DeclareSym. crt/string.bi's '#undef strstr' over
'' shlwapi's StrStr is the real-world case -- two overloads, and every call ambiguous.
sub SymbolTable.UndefSym _
    ( byval scope_ as ScopeId, byval nm as InternId, byval at as ulong )

    if nm = INTERN_NONE then return
    dim as ulong savePos = this.usePos
    this.usePos = USEPOS_LATEST
    dim as ScopeId sc = scope_
    dim as SymbolId head = SYMBOL_NONE
    dim as long guard = 0
    while (sc <> SCOPE_NONE) andalso (guard < 1024)
        guard += 1
        head = this.LookupLocal( sc, nm )
        if head <> SYMBOL_NONE then exit while
        dim as SymScope ptr s_ = this.ScopeAt( sc )
        if s_ = 0 then exit while
        sc = s_->parent
    wend
    dim as SymbolId alt = SYMBOL_NONE
    if head <> SYMBOL_NONE then
        alt = this.symbols[cast( long, head )].altClass
        if alt <> SYMBOL_NONE then alt = this.LiveGen( alt )
    end if
    this.usePos = savePos
    if head = SYMBOL_NONE then return
    this.undefs += 1

    if alt > head then
        this.symbols[cast( long, alt )].diedAt = at
        return
    end if

    '' THE HEAD. Its next live overload of the same class becomes the head from 'at' on
    '' -- or its partner of the other class, if it has none. The chain itself is left
    '' alone, so a use before 'at' still sees every overload.
    dim as Symbol ptr h = @this.symbols[cast( long, head )]
    h->diedAt = at
    dim as boolean headIsType = IsTypeNameKind( cast( SymbolKind, h->kind ) )
    dim as SymbolId nx = h->nextOverload
    guard = 0
    while (nx <> SYMBOL_NONE) andalso (guard < 4096)
        guard += 1
        dim as Symbol ptr o = @this.symbols[cast( long, nx )]
        dim as boolean sameClass = (IsTypeNameKind( cast( SymbolKind, o->kind ) ) = headIsType)
        if sameClass andalso (o->diedAt = 0) then exit while
        nx = o->nextOverload
    wend
    if nx = SYMBOL_NONE then nx = alt
    if nx = SYMBOL_NONE then return
    dim as Symbol ptr ns = @this.symbols[cast( long, nx )]
    ns->flags and= not cast( ulong, SYMF_OVERLOAD )
    ns->olderGen = head
    ns->bornAt = at
    if nx <> alt then
        ns->altClass = alt
        if alt <> SYMBOL_NONE then this.symbols[cast( long, alt )].altClass = nx
    end if
    h->flags or= SYMF_SUPERSEDED
    this.slots[this.SlotFor( sc, nm )] = cast( ulong, nx )
end sub

'' -------------------------------------------------------------- construction

function SymbolTable.OpenScope _
    ( byval k as ScopeKind, byval parent as ScopeId, _
      byval owner as SymbolId ) as ScopeId

    dim as SymScope sc
    sc.kind = cast( ubyte, k )
    sc.parent = parent
    sc.owner = owner
    sc.firstSym = SYMBOL_NONE
    sc.lastSym = SYMBOL_NONE
    sc.count = 0
    this.scopes.Push( sc )
    return cast( ScopeId, this.scopes.Count - 1 )
end function

function SymbolTable.DeclareSym _
    ( byval scope_ as ScopeId, byval nm as InternId, byval k as SymbolKind, _
      byval loc as SourceLoc, byref duplicate as boolean ) as SymbolId

    duplicate = false
    if scope_ = SCOPE_NONE then return SYMBOL_NONE

    dim as long slot = this.SlotFor( scope_, nm )
    dim as SymbolId existing = cast( SymbolId, this.slots[slot] )

    '' AFTER AN '#undef' -- see UndefSym. Judged at the END of what has been collected,
    '' never from a use position: a declaration is always the newest thing so far.
    dim as SymbolId genOlder = SYMBOL_NONE     '' the dead slot head this one replaces
    dim as SymbolId altOlder = SYMBOL_NONE     '' the dead partner this one may replace
    dim as ulong genBorn = 0
    if (existing <> SYMBOL_NONE) andalso (this.undefs > 0) then
        dim as ulong savePos = this.usePos
        this.usePos = USEPOS_LATEST
        dim as Symbol ptr g = @this.symbols[cast( long, existing )]
        if this.LiveGen( existing ) = SYMBOL_NONE then
            genOlder = existing
            genBorn = g->diedAt
            if g->altClass <> SYMBOL_NONE then
                dim as ulong ad = this.symbols[cast( long, g->altClass )].diedAt
                if ad > genBorn then genBorn = ad
            end if
            existing = SYMBOL_NONE
        elseif g->altClass <> SYMBOL_NONE then
            if this.LiveGen( g->altClass ) = SYMBOL_NONE then
                altOlder = g->altClass
                genBorn = this.symbols[cast( long, altOlder )].diedAt
            end if
        end if
        this.usePos = savePos
    end if

    dim as SymbolId chainTo = SYMBOL_NONE
    if existing <> SYMBOL_NONE then
        dim as Symbol ptr e = @this.symbols[cast( long, existing )]

        '' ONCE THE PAIR IS FORMED, judge against the member of THIS class. The slot
        '' keeps whichever came first, so a third declaration arriving at a name that
        '' already holds a type AND a value was compared against the head -- the wrong
        '' class -- and refused as a duplicate.
        ''
        '' 'type WNDPROC as function( ... )' in win/winuser.bi, a 'declare function
        '' WndProc' and then its DEFINITION is that shape, and FreeBASIC folds case so
        '' all three are one name. fbc compiles it -- measured, the program prints from
        '' the direct call and through the pointer both -- while tiko refused the
        '' definition, which is what 231 of AfxNova's examples reported first.
        ''
        '' Only when no '#undef' generation is in play: those paths below choose
        '' between the head and its partner on their own terms.
        dim as boolean pairFormed = (altOlder = SYMBOL_NONE) andalso _
                                    (genOlder = SYMBOL_NONE)
        if pairFormed andalso (e->altClass <> SYMBOL_NONE) then
            dim as boolean headIsOther = _
                (IsTypeNameKind( cast( SymbolKind, e->kind ) ) <> IsTypeNameKind( k ))
            if headIsOther then
                dim as SymbolId partner = e->altClass
                dim as Symbol ptr pe = @this.symbols[cast( long, partner )]
                dim as boolean partnerIsMine = _
                    (IsTypeNameKind( cast( SymbolKind, pe->kind ) ) = IsTypeNameKind( k ))
                if partnerIsMine then
                    existing = partner
                    e = pe
                end if
            end if
        end if

        dim as boolean bothProcs = (e->kind = cast( ubyte, SYM_PROC )) andalso _
                                   (k = SYM_PROC)
        '' A TYPE NAME and a VALUE name may share a spelling. The pair is chained
        '' through altClass; the slot keeps whichever came first, so a caller that
        '' knows which class it wants walks the pair rather than the table.
        dim as boolean split = (IsTypeNameKind( cast( SymbolKind, e->kind ) ) <> _
                                IsTypeNameKind( k ))
        '' AN ENUM MEMBER YIELDS THE UNQUALIFIED NAME TO ANYTHING ELSE, in either
        '' declaration order, and stays reachable as 'E.K'. Measured on fbc, and the
        '' member never wins:
        ''
        ''     enum E : K = 9 : end enum : dim shared K as long = 7
        ''         K -> 7    E.K -> 9        and the same with the DIM written first
        ''     enum E : K = 9 : end enum : const K = 1
        ''         K -> 1    E.K -> 9
        ''     enum E : K = 9 : end enum : sub K( ) ... end sub      accepted
        ''     the member alone                     K -> 9
        ''
        '' Collect already implements the enum-LAST half -- N_ENUM_ITEM declines to
        '' publish unqualified when the name is taken -- and this is the other order,
        '' which reported 'already declared in this scope' for a program fbc compiles.
        '' Overwriting the slot is safe because the member has its OWN copy in the
        '' enum's scope: the enclosing binding is the unqualified convenience alone.
        dim as boolean enumYields = (e->kind = cast( ubyte, SYM_ENUMCONST )) andalso _
                                    (k <> SYM_ENUMCONST)
        if enumYields then
            existing = SYMBOL_NONE
        elseif split andalso ((e->altClass = SYMBOL_NONE) orelse (altOlder <> SYMBOL_NONE)) then
            chainTo = existing
        elseif bothProcs = false then
            duplicate = true
            return existing
        end if
    end if

    dim as Symbol s
    s.kind = cast( ubyte, k )
    s.flags = 0
    s.name = nm
    s.parent = scope_
    s.type_ = TYPE_NONE
    s.loc = loc
    s.nextOverload = SYMBOL_NONE
    s.nextInScope = SYMBOL_NONE
    s.inner = SCOPE_NONE
    s.payload = 0
    s.altClass = SYMBOL_NONE
    this.symbols.Push( s )
    dim as SymbolId id = cast( SymbolId, this.symbols.Count - 1 )
    if chainTo <> SYMBOL_NONE then
        '' Linked BOTH ways, so either end of the pair finds the other however the
        '' lookup arrived.
        this.symbols[cast( long, id )].altClass = chainTo
        this.symbols[cast( long, chainTo )].altClass = id
    end if

    if (chainTo <> SYMBOL_NONE) andalso (altOlder <> SYMBOL_NONE) then
        '' A NEW PARTNER FOR A LIVE HEAD whose old one was '#undef'ed. NOT chained onto
        '' the head's overload list, which still holds the old partner: seen from a use
        '' before the '#undef', this one would look like another overload of it.
        this.symbols[cast( long, id )].flags or= SYMF_OVERLOAD
        this.symbols[cast( long, id )].olderGen = altOlder
        this.symbols[cast( long, id )].bornAt = genBorn
    elseif existing <> SYMBOL_NONE then
        '' Chain onto the end of the overload list; the head stays indexed.
        this.symbols[cast( long, id )].flags or= SYMF_OVERLOAD
        dim as SymbolId cur = existing
        dim as long guard = 0
        while this.symbols[cast( long, cur )].nextOverload <> SYMBOL_NONE
            cur = this.symbols[cast( long, cur )].nextOverload
            guard += 1
            if guard > 4096 then exit while
        wend
        this.symbols[cast( long, cur )].nextOverload = id
    elseif genOlder <> SYMBOL_NONE then
        '' A NEW GENERATION: every earlier symbol of this name here was '#undef'ed. It
        '' takes the slot, and the old head stays reachable through it.
        this.symbols[cast( long, genOlder )].flags or= SYMF_SUPERSEDED
        this.symbols[cast( long, id )].olderGen = genOlder
        this.symbols[cast( long, id )].bornAt = genBorn
        this.slots[slot] = cast( ulong, id )
    else
        this.slots[slot] = cast( ulong, id )
        this.occupied += 1
    end if

    '' Declaration order is observable -- destruction runs in reverse of it.
    dim as SymScope ptr sc = @this.scopes[cast( long, scope_ )]
    if sc->firstSym = SYMBOL_NONE then
        sc->firstSym = id
    else
        this.symbols[cast( long, sc->lastSym )].nextInScope = id
    end if
    sc->lastSym = id
    sc->count += 1

    if this.occupied * SYMTAB_LOAD_DEN > (this.mask + 1) * SYMTAB_LOAD_NUM then
        this.Rehash( (this.mask + 1) * 2 )
    end if

    return id
end function

'' Make an EXISTING symbol reachable under ANOTHER name's overload chain.
''
'' An instantiated generic global operator is declared under its STRUCTURAL KEY -- '+<6>'
'' -- so that two uses of the same instantiation reach one function and the module
'' carries one definition of it. Overload resolution looks the operator up under its own
'' spelling, '+', and found only the uninstantiated generic there.
''
'' Idempotent, because the instantiation cache returns the same id for every later use
'' and chaining it twice would make the list circular.
sub SymbolTable.ChainOverload _
    ( byval scope_ as ScopeId, byval nm as InternId, byval id as SymbolId )

    if id = SYMBOL_NONE then return
    dim as SymbolId head = this.LookupLocal( scope_, nm )
    if head = SYMBOL_NONE then return
    if head = id then return
    dim as SymbolId cur = head
    dim as long guard = 0
    do
        if cur = id then return
        if this.symbols[cast( long, cur )].nextOverload = SYMBOL_NONE then exit do
        cur = this.symbols[cast( long, cur )].nextOverload
        guard += 1
        if guard > 4096 then return
    loop
    this.symbols[cast( long, cur )].nextOverload = id
    this.symbols[cast( long, id )].flags or= SYMF_OVERLOAD
end sub

'' The synthetic UDT a tuple desugars into. See symbol.bi for why it is shared.
''
'' Measured: fbc's own name for the type of '(1, 2)' is FBTUPLE2Iu7INTEGERu7INTEGERE and
'' its layout is that of the equivalent hand-written TYPE, field for field -- so the
'' fields are named '_1'.._N and nothing else about it is special. The KEY is built from
'' the element type ids rather than from their spellings, so two tuples written apart
'' with the same element types are ONE type and assignable to each other.
function TupleUdtFor _
    ( byref syms as SymbolTable, byref types as TypeContext, _
      byref names as Interner, byref elemTypes as FB.Array( of ulong ), _
      byval at as SourceLoc ) as TypeId

    if elemTypes.Count = 0 then return TYPE_NONE

    dim as string key = "$tup"
    for i as long = 0 to elemTypes.Count - 1
        if cast( TypeId, elemTypes[i] ) = TYPE_NONE then return TYPE_NONE
        key += ":" & str( cast( long, elemTypes[i] ) )
    next

    dim as InternId tnm = names.Fold( names.GetString( key ) )
    dim as SymbolId prev = syms.LookupLocalTyped( SCOPE_GLOBAL, tnm, true )
    dim as Symbol ptr ps = syms.SymbolAt( prev )
    if ps <> 0 then return ps->type_

    dim as boolean dup = false
    dim as SymbolId tsid = syms.DeclareSym( SCOPE_GLOBAL, tnm, SYM_UDT, at, dup )
    dim as Symbol ptr ts = syms.SymbolAt( tsid )
    if ts = 0 then return TYPE_NONE
    dim as ScopeId tin = syms.OpenScope( SCOPEK_TYPE, SCOPE_GLOBAL, tsid )
    ts->inner = tin
    ts->type_ = types.NamedType( TK_UDT, tnm, cast( ulong, SCOPE_GLOBAL ) )
    for i as long = 0 to elemTypes.Count - 1
        dim as InternId fnm = names.Fold( names.GetString( "_" & str( i + 1 ) ) )
        dim as boolean fdup = false
        dim as SymbolId fsid = syms.DeclareSym( tin, fnm, SYM_FIELD, at, fdup )
        dim as Symbol ptr fs = syms.SymbolAt( fsid )
        if fs <> 0 then fs->type_ = cast( TypeId, elemTypes[i] )
    next
    return ts->type_
end function

end namespace