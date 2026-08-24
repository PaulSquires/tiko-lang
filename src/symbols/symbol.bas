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
        '' Only the FIRST of an overload chain is indexed; the rest hang off it.
        if s->flags and SYMF_OVERLOAD then continue for
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
    return cast( SymbolId, this.slots[slot] )
end function

function SymbolTable.LookupLocalTyped _
    ( byval scope_ as ScopeId, byval nm as InternId, _
      byval wantType as boolean ) as SymbolId

    dim as SymbolId head = this.LookupLocal( scope_, nm )
    if head = SYMBOL_NONE then return SYMBOL_NONE
    dim as Symbol ptr h = @this.symbols[cast( long, head )]
    if IsTypeNameKind( cast( SymbolKind, h->kind ) ) = wantType then return head
    if h->altClass = SYMBOL_NONE then return head
    return h->altClass
end function

function SymbolTable.LookupTyped _
    ( byval scope_ as ScopeId, byval nm as InternId, _
      byval wantType as boolean ) as SymbolId

    dim as ScopeId sc = scope_
    dim as long guard = 0
    while (sc <> SCOPE_NONE) andalso (guard < 256)
        guard += 1
        dim as SymbolId got = this.LookupLocalTyped( sc, nm, wantType )
        if got <> SYMBOL_NONE then
            dim as Symbol ptr g = @this.symbols[cast( long, got )]
            if IsTypeNameKind( cast( SymbolKind, g->kind ) ) = wantType then return got
        end if

        '' 'using ns' MAKES ITS TYPE NAMES VISIBLE TOO. Lookup( ) walks the using
        '' scopes and this did not, so 'using ns1 : dim b as B' found nothing and the
        '' variable's slot lowered to void -- while 'ns1.B' and an unqualified VALUE
        '' from the same namespace both worked. Searched after the scope's own names
        '' and before its parent's, which is the order Lookup( ) already uses.
        for i as long = 0 to this.usingAt.Count - 1
            if this.usingAt[i] <> cast( ulong, sc ) then continue for
            got = this.LookupLocalTyped( cast( ScopeId, this.usingInner[i] ), nm, wantType )
            if got <> SYMBOL_NONE then
                dim as Symbol ptr gu = @this.symbols[cast( long, got )]
                if IsTypeNameKind( cast( SymbolKind, gu->kind ) ) = wantType then return got
            end if
        next

        dim as SymScope ptr s_ = this.ScopeAt( sc )
        if s_ = 0 then exit while
        sc = s_->parent
    wend
    return this.Lookup( scope_, nm )
end function

function SymbolTable.Lookup _
    ( byval scope_ as ScopeId, byval nm as InternId ) as SymbolId

    dim as ScopeId s = scope_
    dim as long guard = 0
    while s <> SCOPE_NONE
        guard += 1
        if guard > 1024 then exit while          '' a cycle would be a table bug
        dim as SymbolId got = this.LookupLocal( s, nm )
        if got <> SYMBOL_NONE then return got

        '' 'using ns' makes the namespace's names visible UNQUALIFIED from here on.
        '' Searched AFTER the scope's own names and BEFORE its parent's, which is the
        '' order that makes a local declaration win over an import and an import win
        '' over an outer name.
        for i as long = 0 to this.usingAt.Count - 1
            if this.usingAt[i] <> cast( ulong, s ) then continue for
            got = this.LookupLocal( cast( ScopeId, this.usingInner[i] ), nm )
            if got <> SYMBOL_NONE then return got
        next

        dim as SymScope ptr sc = this.ScopeAt( s )
        if sc = 0 then exit while
        s = sc->parent
    wend
    return SYMBOL_NONE
end function

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

    dim as SymbolId chainTo = SYMBOL_NONE
    if existing <> SYMBOL_NONE then
        dim as Symbol ptr e = @this.symbols[cast( long, existing )]
        dim as boolean bothProcs = (e->kind = cast( ubyte, SYM_PROC )) andalso _
                                   (k = SYM_PROC)
        '' A TYPE NAME and a VALUE name may share a spelling. The pair is chained
        '' through altClass; the slot keeps whichever came first, so a caller that
        '' knows which class it wants walks the pair rather than the table.
        dim as boolean split = (IsTypeNameKind( cast( SymbolKind, e->kind ) ) <> _
                                IsTypeNameKind( k ))
        if split andalso (e->altClass = SYMBOL_NONE) then
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

    if existing <> SYMBOL_NONE then
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

end namespace