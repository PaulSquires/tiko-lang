'' type.bas -- see type.bi

#include once "types/type.bi"
#include once "support/text.bi"

namespace Tko

'' ------------------------------------------------------------ builtin metadata

type BuiltinInfo
    as zstring ptr name
    as long        bits          '' 0 = target-dependent
    as boolean     signed_
    as ubyte       class_
end type

dim shared as BuiltinInfo builtinTb( 0 to TY_BUILTIN_COUNT - 1 )
dim shared as boolean builtinReady = false

private sub InitBuiltins( )
    if builtinReady then return
    for i as long = 0 to TY_BUILTIN_COUNT - 1
        builtinTb(i).name = @"?"
        builtinTb(i).bits = 0
        builtinTb(i).signed_ = false
        builtinTb(i).class_ = cast( ubyte, TC_VOID )
    next
    #macro BUILTIN( b_id, b_name, b_bits, b_signed, b_class )
        builtinTb(b_id).name = @b_name
        builtinTb(b_id).bits = b_bits
        builtinTb(b_id).signed_ = b_signed
        builtinTb(b_id).class_ = cast( ubyte, b_class )
    #endmacro
    TKO_BUILTIN_LIST( BUILTIN )
    #undef BUILTIN
    builtinReady = true
end sub

function BuiltinName( byval b as BuiltinType ) as string
    InitBuiltins( )
    dim as boolean bad = (b < 0) orelse (b >= TY_BUILTIN_COUNT)
    if bad then return "?"
    return *builtinTb(b).name
end function

function BuiltinClass( byval b as BuiltinType ) as TypeClass
    InitBuiltins( )
    dim as boolean bad = (b < 0) orelse (b >= TY_BUILTIN_COUNT)
    if bad then return TC_VOID
    return cast( TypeClass, builtinTb(b).class_ )
end function

'' The x86-64 facts, MEASURED against fbc rather than assumed
'' (tests/types/layout.test regenerates and compares them):
''
''     byte/ubyte/boolean  1     integer/uinteger  8     string   24, align 8
''     short/ushort        2     longint/ulongint  8     ustring  24, align 8
''     long/ulong/single   4     double            8     pointers 8
'' THE DEFAULT TARGET, which on Windows is the MICROSOFT ABI and not the MinGW one.
''
'' It was TARGET_WIN64, and that made 'tiko test.bas' the one invocation that could
'' not use graphics. libtkogfx IS tiko's graphics library -- fbc's libfbgfx is not a
'' substitute and is not reached for -- and lib/gfx builds it for win64-msvc alone,
'' the ABI it was written against. So the default target was the target with no
'' graphics archive, and a SCREEN program answered 'undefined reference to
'' fb_GfxScreen' unless the user knew to pass -target win64-msvc.
''
'' NOTHING ELSE ABOUT THE TWO DIFFERS. Same machine, same calling convention, same
'' type layout, same object format -- x86-64 Windows is one ABI and the CRT is what
'' changes. What follows the triple is the link line.
''
'' AND IT NEEDS NOTHING BEHIND IT. Measured 2026-09-06: a program built for
'' win64-msvc against lib/win64-msvc alone -- no fbc directory, and fbc has no MSVC
'' target to supply one -- linked and ran. tiko-rt's MSVC archive carries no MinGW
'' imports (build/abidelta.sh; gatemsvc.sh at 3,922,073 assertions), where win64
'' still needs fbc's libfb behind it for fb_AtomicCasLong. The default is now the
'' target that stands on its own and has the graphics library.
''
'' '-target win64' still selects the MinGW ABI, and the toolchain still ships
'' lib/win64 and lib/win64-fb for it.
function HostTarget( ) as TargetId
    #ifdef __FB_WIN32__
        return TARGET_WIN64_MSVC
    #else
        return TARGET_LINUX_X86_64
    #endif
end function

function TargetName( byval t as TargetId ) as string
    select case t
    case TARGET_LINUX_X86_64    : return "linux-x86_64"
    case TARGET_WIN64_MSVC      : return "win64-msvc"
    end select
    return "win64"
end function

function TargetFromName( byval nm as string, byref ok as boolean ) as TargetId
    ok = true
    dim as string s = Text.LowerAscii( nm )
    if s = "win64" then return TARGET_WIN64
    if s = "win64-msvc" then return TARGET_WIN64_MSVC
    if s = "linux-x86_64" then return TARGET_LINUX_X86_64
    ok = false
    return HostTarget( )
end function

'' ALWAYS TRUE since 2026-09-04, and kept as a function on purpose: it is a
'' target FACT, and the callers that ask for it are asking a question that ARM64
'' will not change the answer to but a future 32-bit target would. Deleting it
'' would scatter the assumption instead of naming it.
function TargetIs64( byval t as TargetId ) as boolean
    return true
end function

function TargetIsWindows( byval t as TargetId ) as boolean
    return t <> TARGET_LINUX_X86_64
end function

'' MEASURED PER TARGET rather than derived from the pointer width. That mattered
'' most for win32, where two of the numbers did not follow from it -- the FBSTRING
'' descriptor was 12 bytes but aligned to 4, while maxAlign stayed 8 -- and win32
'' is gone (D14). The discipline stays: cvaList is still 4 bytes on Windows and a
'' 24-byte SysV register-save record on Linux, which no pointer width predicts.
function TargetLayoutFor( byval t as TargetId ) as TargetLayout
    dim as TargetLayout r
    r.maxAlign = 8
    select case t
    case TARGET_LINUX_X86_64
        r.pointerBits = 64
        r.wcharBytes = 4
        r.stringBytes = 24
        r.stringAlign = 8
        '' The SysV register-save record, not a pointer: 24 bytes, 8-aligned.
        r.cvaListBytes = 24
        r.cvaListAlign = 8
        r.isWindows = false
    case else                   '' TARGET_WIN64
        r.pointerBits = 64
        r.wcharBytes = 2
        r.stringBytes = 24      '' FBSTRING: data ptr + len + size
        r.stringAlign = 8
        r.cvaListBytes = 8
        r.cvaListAlign = 8
        r.isWindows = true
    end select
    return r
end function

function DefaultTargetLayout( ) as TargetLayout
    return TargetLayoutFor( HostTarget( ) )
end function

'' ------------------------------------------------------------------- lifetime

constructor TypeContext( )
    InitBuiltins( )
    this.names = 0
    this.target = DefaultTargetLayout( )

    '' Slot 0 is TYPE_NONE; the builtins then occupy 1..TY_BUILTIN_COUNT-1 in enum
    '' order, so Builtin( b ) is an identity map and dumps are stable.
    dim as TypeInfo z
    z.kind = cast( ubyte, TK_ERROR )
    this.types.Push( z )

    for b as long = 1 to TY_BUILTIN_COUNT - 1
        dim as TypeInfo bi
        bi.kind = cast( ubyte, TK_BUILTIN )
        bi.builtin = cast( ubyte, b )
        bi.flags = TF_COMPLETE
        bi.inner = TYPE_NONE
        bi.dims = 0
        this.Push_( bi )
    next
end constructor

sub TypeContext.Attach( byval it as Interner ptr, byref tgt as TargetLayout )
    this.names = it
    this.target = tgt
end sub

function TypeContext.Count( ) as long
    return this.types.Count - 1
end function

'' ------------------------------------------------------------------ interning

const TYPEINDEX_INITIAL_SLOTS as long = 1024

constructor TypeIndex( )
    '' TypeId 0 is TYPE_NONE and is never filed; its slot keeps 'chain' and 'hashes'
    '' indexed by TypeId.
    this.chain.Push( 0 )
    this.hashes.Push( 0 )
    this.Rehash( TYPEINDEX_INITIAL_SLOTS )
end constructor

sub TypeIndex.Link_( byval id as long )
    dim as long b = cast( long, this.hashes[id] and cast( ulong, this.mask ) )
    if this.buckets[b] = 0 then
        this.buckets[b] = cast( ulong, id )
    else
        this.chain[cast( long, this.lasts[b] )] = cast( ulong, id )
    end if
    this.lasts[b] = cast( ulong, id )
end sub

sub TypeIndex.Rehash( byval slots as long )
    this.buckets.Clear( )
    this.lasts.Clear( )
    this.buckets.Reserve( slots )
    this.lasts.Reserve( slots )
    for b as long = 0 to slots - 1
        this.buckets.Push( 0 )
        this.lasts.Push( 0 )
    next
    this.mask = slots - 1
    '' RE-LINKED IN ASCENDING ORDER, so every chain stays sorted by TypeId.
    for id as long = 1 to this.chain.Count - 1
        this.chain[id] = 0
        this.Link_( id )
    next
end sub

sub TypeIndex.Add( byval id as TypeId, byval h as ulong )
    this.chain.Push( 0 )
    this.hashes.Push( h )
    this.Link_( cast( long, id ) )
    '' Grow at an average chain length of one.
    if this.chain.Count - 1 > this.mask + 1 then this.Rehash( (this.mask + 1) * 2 )
end sub

function TypeIndex.Lookup( byval h as ulong ) as TypeId
    return cast( TypeId, this.buckets[cast( long, h and cast( ulong, this.mask ) )] )
end function

function TypeIndex.After( byval id as TypeId ) as TypeId
    return cast( TypeId, this.chain[cast( long, id )] )
end function

'' One index key: up to four fields, FNV-1a over their bytes -- the interner's hash.
'' A signed field goes in as its bit pattern, so every caller casts it the same way.
private function TypeKey_ _
    ( byval a as ulong, byval b as ulong, byval c as ulong, byval d as ulong ) as ulong

    dim as ulong k(0 to 3) = { a, b, c, d }
    return HashBytes( cast( const ubyte ptr, @k(0) ), 16 )
end function

function TypeContext.Push_( byref n as TypeInfo ) as TypeId
    this.types.Push( n )
    dim as TypeId id = cast( TypeId, this.types.Count - 1 )
    this.byShape.Add( id, TypeKey_( n.kind, n.inner, n.flags, cast( ulong, n.dims ) ) )
    this.byArray.Add( id, TypeKey_( n.kind, n.inner, cast( ulong, n.dims ), _
                                    cast( ulong, n.elems ) ) )
    this.byBuiltin.Add( id, TypeKey_( n.kind, n.builtin, n.flags, 0 ) )
    this.byName.Add( id, TypeKey_( n.kind, n.name, n.declScope, 0 ) )
    this.byProc.Add( id, TypeKey_( n.kind, n.inner, cast( ulong, n.count ), _
                                   n.flags and TF_VARIADIC ) )
    return id
end function

function TypeContext.Find _
    ( byval wantKind as TypeKind, byval innerT as TypeId, byval fl as ushort, _
      byval rank as long ) as TypeId

    dim as ulong h = TypeKey_( cast( ulong, wantKind ), innerT, fl, cast( ulong, rank ) )
    dim as TypeId i = this.byShape.Lookup( h )
    while i <> TYPE_NONE
        dim as TypeInfo ptr t = @this.types[cast( long, i )]
        dim as boolean same = (t->kind = cast( ubyte, wantKind )) andalso _
                              (t->inner = innerT) andalso _
                              (t->flags = fl) andalso (t->dims = rank)
        if same then return i
        i = this.byShape.After( i )
    wend

    dim as TypeInfo n
    n.kind = cast( ubyte, wantKind )
    n.builtin = 0
    n.flags = fl
    n.inner = innerT
    n.dims = rank
    return this.Push_( n )
end function

function TypeContext.Builtin( byval b as BuiltinType ) as TypeId
    dim as boolean bad = (b <= TY_NONE) orelse (b >= TY_BUILTIN_COUNT)
    if bad then return TYPE_NONE
    return cast( TypeId, b )
end function

function TypeContext.Pointer_( byval pointee as TypeId ) as TypeId
    return this.Find( TK_POINTER, pointee, TF_COMPLETE, 0 )
end function

function TypeContext.Reference( byval referent as TypeId ) as TypeId
    return this.Find( TK_REFERENCE, referent, TF_COMPLETE, 0 )
end function

'' A DYNAMIC array: no bounds, no element count, and its storage is a DESCRIPTOR
'' rather than the elements themselves.
''
'' 'dims' encodes both facts at once. It is NEGATIVE for a dynamic array, and its
'' magnitude is rank + 1, so:
''
''     dim a( )            rank 0, unspecified   dims = -1    8 dimtb slots
''     dim a( any )        rank 1                dims = -2    1 dimtb slot
''     dim a( any, any )   rank 2                dims = -3    2 dimtb slots
''
'' -1 keeps its existing meaning -- every 'dims < 1' test already read it as dynamic --
'' and the rest are new. Rank 0 is genuinely unspecified rather than zero-dimensional;
'' fbc gives that descriptor the full eight slots because it does not know either.
function TypeContext.DynArrayOf _
    ( byval elem as TypeId, byval rank as long ) as TypeId

    return this.ArrayOf( elem, -(rank + 1), 0, 0 )
end function

'' Whether a type is a dynamic array, and how many dimensions it was written with
'' (0 when the declaration left it open).
function TypeContext.IsDynArray( byval t as TypeId ) as boolean
    if t = TYPE_NONE then return false
    if this.Kind( t ) <> TK_ARRAY then return false
    return (this.types[cast( long, t )].dims < 0)
end function

function TypeContext.DynRank( byval t as TypeId ) as long
    if this.IsDynArray( t ) = false then return 0
    return (-this.types[cast( long, t )].dims) - 1
end function

function TypeContext.ArrayOf _
    ( byval elem as TypeId, byval rank as long, byval elems as long, _
      byval bounds as FB.Array( of longint ) ptr ) as TypeId

    '' The element COUNT is part of the identity: 'long a(0 to 3)' and
    '' 'long a(0 to 7)' are different types with different sizes, and Find( ) alone
    '' compares only the rank.
    ''
    '' So are the BOUNDS: 'a(0 to 3)' and 'a(1 to 4)' have the same rank, the same
    '' element count and the same size, but different lbound biases, so indexing them
    '' produces different addresses. Sharing one type between them would fold the wrong
    '' bias into every subscript of one of the two.
    dim as ulong h = TypeKey_( TK_ARRAY, elem, cast( ulong, rank ), cast( ulong, elems ) )
    dim as TypeId i = this.byArray.Lookup( h )
    while i <> TYPE_NONE
        dim as TypeInfo ptr t = @this.types[cast( long, i )]
        if (t->kind = cast( ubyte, TK_ARRAY )) andalso (t->inner = elem) andalso _
           (t->dims = rank) andalso (t->elems = elems) then
            dim as boolean same = true
            if bounds = 0 then
                if t->count <> 0 then same = false
            else
                if t->count <> bounds->Count then
                    same = false
                else
                    for j as long = 0 to t->count - 1
                        if this.boundPool[t->first + j] <> (*bounds)[j] then same = false
                    next
                end if
            end if
            if same then return i
        end if
        i = this.byArray.After( i )
    wend
    dim as TypeInfo n
    n.kind = cast( ubyte, TK_ARRAY )
    n.flags = TF_COMPLETE
    n.inner = elem
    n.dims = rank
    n.elems = elems
    n.first = this.boundPool.Count
    n.count = 0
    if bounds <> 0 then
        for j as long = 0 to bounds->Count - 1
            this.boundPool.Push( (*bounds)[j] )
        next
        n.count = bounds->Count
    end if
    return this.Push_( n )
end function

function TypeContext.ArrayBound _
    ( byval t as TypeId, byval dim_ as long, byval hi as boolean, _
      byref known as boolean ) as longint

    known = false
    if t = TYPE_NONE then return 0
    dim as TypeInfo ptr ti = @this.types[cast( long, t )]
    if ti->kind <> cast( ubyte, TK_ARRAY ) then return 0
    dim as long idx = dim_ * 2
    if hi then idx += 1
    if (idx < 0) orelse (idx >= ti->count) then return 0
    known = true
    return this.boundPool[ti->first + idx]
end function

'' 'const T' is the same type with a flag, so const-ness never changes identity of
'' anything else about it.
function TypeContext.Qualify( byval t as TypeId, byval fl as ushort ) as TypeId
    if t = TYPE_NONE then return t
    dim as TypeInfo ptr src = @this.types[cast( long, t )]
    dim as ushort want = src->flags or fl
    if want = src->flags then return t

    if src->kind = cast( ubyte, TK_BUILTIN ) then
        dim as TypeId i = this.byBuiltin.Lookup( TypeKey_( src->kind, src->builtin, want, 0 ) )
        while i <> TYPE_NONE
            dim as TypeInfo ptr c = @this.types[cast( long, i )]
            dim as boolean same = (c->kind = src->kind) andalso _
                                  (c->builtin = src->builtin) andalso (c->flags = want)
            if same then return i
            i = this.byBuiltin.After( i )
        wend
        dim as TypeInfo n = *src
        n.flags = want
        return this.Push_( n )
    end if

    '' A UDT, AN ENUM AND A FORWARD ARE IDENTIFIED BY NAME, and Find compares kind,
    '' inner, flags and rank -- none of which tells two UDTs apart. So qualifying or
    '' unqualifying one returned whichever UDT happened to sit first in the table, or
    '' MANUFACTURED A NAMELESS ONE when none matched.
    ''
    '' Nothing said so. The caller got a type back, asked it for a field, found none,
    '' and declined -- so 'byref x as const T' made every 'x.n' through it untyped
    '' while the identical line without the const worked. That is the signature of
    '' every copy constructor in the corpus.
    select case cast( TypeKind, src->kind )
    case TK_UDT, TK_ENUM, TK_FORWARD
        dim as InternId nm = src->name
        dim as TypeId i = this.byName.Lookup( TypeKey_( src->kind, nm, src->declScope, 0 ) )
        while i <> TYPE_NONE
            dim as TypeInfo ptr c2 = @this.types[cast( long, i )]
            dim as TypeId here = i
            i = this.byName.After( i )
            if c2->kind <> src->kind then continue while
            if c2->name <> nm then continue while
            '' ...AND THE SCOPE IT WAS DECLARED IN, which is part of a named type's
            '' IDENTITY -- NamedType already says so, and this re-find did not.
            '' Two SIBLING NAMESPACES each declaring a 'T1' is all it takes: adding or
            '' stripping a const scanned the table from the front and answered with
            '' whichever T1 was declared FIRST, so 'const B.T1 ptr' became 'const A.T1
            '' ptr' and no argument of type 'B.T1 ptr' matched it. Six calls in
            '' overload/arg-upcasting.bas resolved to nothing, and moving namespace A
            '' below B made them work -- a pure declaration-order dependence.
            if c2->declScope <> src->declScope then continue while
            if c2->flags = want then return here
        wend
        dim as TypeInfo n2 = *src
        n2.flags = want
        return this.Push_( n2 )
    end select

    return this.Find( cast( TypeKind, src->kind ), src->inner, want, src->dims )
end function

'' -------------------------------------------------------------------- queries

function TypeContext.NamedType _
    ( byval k as TypeKind, byval nm as InternId, _
      byval declScope as ulong = 0, byval rawNm as InternId = 0 ) as TypeId

    if nm = 0 then return TYPE_NONE
    dim as TypeId i = this.byName.Lookup( TypeKey_( cast( ulong, k ), nm, declScope, 0 ) )
    while i <> TYPE_NONE
        dim as TypeInfo ptr t = @this.types[cast( long, i )]
        if (t->kind = cast( ubyte, k )) andalso (t->name = nm) andalso _
           (t->declScope = declScope) then
            '' A LATER SIGHTING MAY BE THE ONE THAT KNOWS THE SPELLING: the type is
            '' created by whatever names it first, which can be a forward reference.
            if (rawNm <> 0) andalso (t->rawName = 0) then t->rawName = rawNm
            return i
        end if
        i = this.byName.After( i )
    wend
    dim as TypeInfo n
    n.kind = cast( ubyte, k )
    n.flags = TF_COMPLETE
    n.name = nm
    n.rawName = rawNm
    n.declScope = declScope
    return this.Push_( n )
end function

function TypeContext.Unqualify( byval t as TypeId ) as TypeId
    if t = TYPE_NONE then return t
    dim as TypeInfo ptr src = @this.types[cast( long, t )]
    dim as ushort want = src->flags and (not TF_CONST)
    if want = src->flags then return t

    if src->kind = cast( ubyte, TK_BUILTIN ) then
        dim as TypeId i = this.byBuiltin.Lookup( TypeKey_( src->kind, src->builtin, want, 0 ) )
        while i <> TYPE_NONE
            dim as TypeInfo ptr c = @this.types[cast( long, i )]
            dim as boolean same = (c->kind = src->kind) andalso _
                                  (c->builtin = src->builtin) andalso (c->flags = want)
            if same then return i
            i = this.byBuiltin.After( i )
        wend
        dim as TypeInfo n = *src
        n.flags = want
        return this.Push_( n )
    end if
    '' A UDT, AN ENUM AND A FORWARD ARE IDENTIFIED BY NAME, and Find compares kind,
    '' inner, flags and rank -- none of which tells two UDTs apart. So qualifying or
    '' unqualifying one returned whichever UDT happened to sit first in the table, or
    '' MANUFACTURED A NAMELESS ONE when none matched.
    ''
    '' Nothing said so. The caller got a type back, asked it for a field, found none,
    '' and declined -- so 'byref x as const T' made every 'x.n' through it untyped
    '' while the identical line without the const worked. That is the signature of
    '' every copy constructor in the corpus.
    select case cast( TypeKind, src->kind )
    case TK_UDT, TK_ENUM, TK_FORWARD
        dim as InternId nm = src->name
        dim as TypeId i = this.byName.Lookup( TypeKey_( src->kind, nm, src->declScope, 0 ) )
        while i <> TYPE_NONE
            dim as TypeInfo ptr c2 = @this.types[cast( long, i )]
            dim as TypeId here = i
            i = this.byName.After( i )
            if c2->kind <> src->kind then continue while
            if c2->name <> nm then continue while
            '' ...AND THE SCOPE IT WAS DECLARED IN, which is part of a named type's
            '' IDENTITY -- NamedType already says so, and this re-find did not.
            '' Two SIBLING NAMESPACES each declaring a 'T1' is all it takes: adding or
            '' stripping a const scanned the table from the front and answered with
            '' whichever T1 was declared FIRST, so 'const B.T1 ptr' became 'const A.T1
            '' ptr' and no argument of type 'B.T1 ptr' matched it. Six calls in
            '' overload/arg-upcasting.bas resolved to nothing, and moving namespace A
            '' below B made them work -- a pure declaration-order dependence.
            if c2->declScope <> src->declScope then continue while
            if c2->flags = want then return here
        wend
        dim as TypeInfo n2 = *src
        n2.flags = want
        return this.Push_( n2 )
    end select

    return this.Find( cast( TypeKind, src->kind ), src->inner, want, src->dims )
end function

'' A procedure type: the return type in 'inner', the parameter types in the pool.
function TypeContext.ProcType _
    ( byval ret as TypeId, byref params as TypeIdVec2, _
      byval variadic as boolean = false ) as TypeId

    '' THE ELLIPSIS IS PART OF THE KEY. Two procedure types with the same parameters
    '' and a different tail are different types; sharing the cache entry made them one.

    dim as ulong vflag = 0
    if variadic then vflag = TF_VARIADIC
    dim as TypeId i = this.byProc.Lookup( _
        TypeKey_( TK_PROC, ret, cast( ulong, params.Count ), vflag ) )
    while i <> TYPE_NONE
        dim as TypeInfo ptr t = @this.types[cast( long, i )]
        dim as TypeId here = i
        i = this.byProc.After( i )
        if t->kind <> cast( ubyte, TK_PROC ) then continue while
        if t->inner <> ret then continue while
        if t->count <> params.Count then continue while
        dim as boolean tv = ((t->flags and TF_VARIADIC) <> 0)
        if tv <> variadic then continue while
        dim as boolean same = true
        for j as long = 0 to t->count - 1
            if this.pool[t->first + j] <> params[j] then
                same = false
                exit for
            end if
        next
        if same then return here
    wend

    dim as TypeInfo n
    n.kind = cast( ubyte, TK_PROC )
    n.flags = TF_COMPLETE
    if variadic then n.flags or= TF_VARIADIC
    n.inner = ret
    n.first = this.pool.Count
    n.count = params.Count
    for k as long = 0 to params.Count - 1
        this.pool.Push( params[k] )
    next
    return this.Push_( n )
end function

function TypeContext.DeclScopeOf( byval t as TypeId ) as ulong
    if (t = TYPE_NONE) orelse (cast( long, t ) >= this.types.Count) then return 0
    return this.types[cast( long, t )].declScope
end function

function TypeContext.Packing( byval t as TypeId ) as long
    if (t = TYPE_NONE) orelse (cast( long, t ) >= this.types.Count) then return 0
    return this.types[cast( long, t )].packing
end function

'' See the header. ONLY a procedure type, and ONLY while its result is still unset:
'' the type is INTERNED, so overwriting a result that was deliberately chosen would
'' silently re-point every other holder of the same TypeId.
sub TypeContext.SetProcResult( byval t as TypeId, byval ret as TypeId )
    if (t = TYPE_NONE) orelse (cast( long, t ) >= this.types.Count) then return
    if ret = TYPE_NONE then return
    if this.types[cast( long, t )].kind <> cast( ubyte, TK_PROC ) then return
    if this.types[cast( long, t )].inner <> TYPE_NONE then return
    this.types[cast( long, t )].inner = ret
end sub

sub TypeContext.SetPacking( byval t as TypeId, byval n as long )
    if (t = TYPE_NONE) orelse (cast( long, t ) >= this.types.Count) then return
    this.types[cast( long, t )].packing = n
end sub

function TypeContext.ElemCount( byval t as TypeId ) as long
    if (t = TYPE_NONE) orelse (cast( long, t ) >= this.types.Count) then return 0
    return this.types[cast( long, t )].elems
end function

'' A PROCEDURE TYPE'S PARAMETERS -- how many, and the i'th. They live in the shared
'' pool at 'first', which is where ProcType put them; 'elems' is an ARRAY's count and
'' says nothing about a proc.
function TypeContext.ProcParamCount( byval t as TypeId ) as long
    if this.Kind( t ) <> TK_PROC then return 0
    return this.types[cast( long, t )].count
end function

function TypeContext.ProcParam( byval t as TypeId, byval i as long ) as TypeId
    if this.Kind( t ) <> TK_PROC then return TYPE_NONE
    dim as TypeInfo ptr ti = @this.types[cast( long, t )]
    if (i < 0) orelse (i >= ti->count) then return TYPE_NONE
    return cast( TypeId, this.pool[ti->first + i] )
end function

function TypeContext.NameOf( byval t as TypeId ) as InternId
    if (t = TYPE_NONE) orelse (cast( long, t ) >= this.types.Count) then return 0
    return this.types[cast( long, t )].name
end function

function TypeContext.BaseOf( byval t as TypeId ) as TypeId
    if t = TYPE_NONE then return TYPE_NONE
    if cast( long, t ) >= this.types.Count then return TYPE_NONE
    return this.types[cast( long, t )].baseType
end function

sub TypeContext.SetBase( byval t as TypeId, byval b as TypeId )
    if t = TYPE_NONE then return
    if cast( long, t ) >= this.types.Count then return
    this.types[cast( long, t )].baseType = b
end sub

'' How many 'extends' links separate a derived type from one of its bases. 0 when they
'' are the same type, -1 when 'to_' is not on 'from_'s chain at all.
''
'' Single inheritance, so there is one chain and no ambiguity; the depth cap is a cycle
'' guard, not a language limit.
function TypeContext.BaseDistance _
    ( byval from_ as TypeId, byval to_ as TypeId ) as long

    if (from_ = TYPE_NONE) orelse (to_ = TYPE_NONE) then return -1
    dim as TypeId a = this.Unqualify( from_ )
    dim as TypeId b = this.Unqualify( to_ )
    if a = b then return 0
    for d as long = 1 to 31
        a = this.Unqualify( this.BaseOf( a ) )
        if a = TYPE_NONE then return -1
        if a = b then return d
    next
    return -1
end function

function TypeContext.Kind( byval t as TypeId ) as TypeKind
    if t = TYPE_NONE then return TK_ERROR
    if cast( long, t ) >= this.types.Count then return TK_ERROR
    return cast( TypeKind, this.types[cast( long, t )].kind )
end function

function TypeContext.BuiltinOf( byval t as TypeId ) as BuiltinType
    if this.Kind( t ) <> TK_BUILTIN then return TY_NONE
    return cast( BuiltinType, this.types[cast( long, t )].builtin )
end function

function TypeContext.Inner( byval t as TypeId ) as TypeId
    if t = TYPE_NONE then return TYPE_NONE
    if cast( long, t ) >= this.types.Count then return TYPE_NONE
    return this.types[cast( long, t )].inner
end function

function TypeContext.IsConst( byval t as TypeId ) as boolean
    if t = TYPE_NONE then return false
    if cast( long, t ) >= this.types.Count then return false
    return ((this.types[cast( long, t )].flags and TF_CONST) <> 0)
end function

function TypeContext.IsVariadic( byval t as TypeId ) as boolean
    if t = TYPE_NONE then return false
    if cast( long, t ) >= this.types.Count then return false
    return ((this.types[cast( long, t )].flags and TF_VARIADIC) <> 0)
end function

'' --------------------------------------------------------------------- layout

function TypeContext.Layout( byval t as TypeId ) as TypeLayout
    dim as TypeLayout r
    r.size = 0
    r.align = 1
    if t = TYPE_NONE then return r

    dim as long ptrBytes = this.target.pointerBits \ 8

    select case this.Kind( t )
    case TK_POINTER, TK_REFERENCE, TK_PROC
        r.size = ptrBytes
        r.align = ptrBytes

    case TK_BUILTIN
        dim as BuiltinType b = this.BuiltinOf( t )
        '' THE FIXED-USTRING ELEMENT IS TWO BYTES, not the 24-byte descriptor its class
        '' otherwise means. Asked before the class, because the class is what puts it in
        '' the ustring family for conversions and that part is right.
        if b = TY_FIXUSTR then
            r.size = 2
            r.align = 2
            return r
        end if
        select case BuiltinClass( b )
        case TC_INTPTR
            r.size = ptrBytes
            r.align = ptrBytes
        case TC_STRING, TC_USTRING
            r.size = this.target.stringBytes
            r.align = this.target.stringAlign
        case TC_ZSTRING
            r.size = 1
            r.align = 1
        case TC_WSTRING
            r.size = this.target.wcharBytes
            r.align = this.target.wcharBytes
        case TC_CVA
            r.size = this.target.cvaListBytes
            r.align = this.target.cvaListAlign
        case TC_ANY, TC_VOID
            r.size = 0
            r.align = 1
        case else
            InitBuiltins( )
            r.size = builtinTb(b).bits \ 8
            r.align = r.size
            if r.align > this.target.maxAlign then r.align = this.target.maxAlign
            if r.align < 1 then r.align = 1
        end select

    '' AN ENUM IS INTEGER-WIDE, which is 8 bytes on win64 and 4 on win32. Measured:
    '' 'sizeof( E )' is 8, and 'type S : a as E : b as long : end type' is 16 with b
    '' at offset 8; on win32 the same struct is 8.
    ''
    '' It fell to the default below and came out size ZERO, so an enum variable
    '' reserved nothing, every field after one in a structure sat at the wrong offset,
    '' and the structure itself was the wrong size -- 4 where fbc has 16 for the pair
    '' above, with BOTH fields at offset 0.
    case TK_ENUM
        r.size = ptrBytes
        r.align = ptrBytes
        if r.align > this.target.maxAlign then r.align = this.target.maxAlign

    case TK_ARRAY
        '' A fixed array is elemSize * elemCount, aligned as its ELEMENT. The count is
        '' on the type now: it is part of the type's identity, because two arrays of
        '' different lengths are different types with different sizes.
        r = this.Layout( this.Inner( t ) )
        dim as long n = this.types[cast( long, t )].elems
        if n > 0 then r.size *= n

    case else
        r.size = 0
        r.align = 1
    end select

    return r
end function

'' User-facing spelling: 'Box( of long )', not an internal key. Diagnostic quality
'' depends on this, so it lives in the type system rather than in the renderer.
function TypeContext.Name( byval t as TypeId ) as string
    if t = TYPE_NONE then return "<none>"

    dim as string prefix = ""
    if this.IsConst( t ) then prefix = "const "

    select case this.Kind( t )
    case TK_BUILTIN
        return prefix & BuiltinName( this.BuiltinOf( t ) )
    case TK_POINTER
        return prefix & this.Name( this.Inner( t ) ) & " ptr"
    case TK_REFERENCE
        return prefix & "byref " & this.Name( this.Inner( t ) )
    case TK_ARRAY
        '' A fixed-length string is an array of the string element -- see
        '' Check.FixedStringElem -- so it must SPELL like one, or every diagnostic
        '' about a 'zstring * 8' calls it 'zstring()' and reads like an array bug.
        dim as TypeId el = this.Inner( t )
        if this.Kind( el ) = TK_BUILTIN then
            select case this.BuiltinOf( el )
            case TY_ZSTRING, TY_WSTRING, TY_USTRING
                return prefix & BuiltinName( this.BuiltinOf( el ) ) & " * " & _
                       this.types[cast( long, t )].elems
            end select
        end if
        dim as long d = this.types[cast( long, t )].dims
        dim as string dims = ""
        if d > 0 then
            for i as long = 2 to d
                dims += ","
            next
        end if
        return prefix & this.Name( this.Inner( t ) ) & "(" & dims & ")"
    case TK_PROC
        '' 'sub( as long )' / 'function( as double ) as long'. A procedure type reads as
        '' its own declaration, which is what a diagnostic about one needs to say.
        dim as long pn = this.types[cast( long, t )].count
        dim as string ps = ""
        for i as long = 0 to pn - 1
            if i > 0 then ps += ", "
            ps += "as " & this.Name( cast( TypeId, this.pool[this.types[cast( long, t )].first + i] ) )
        next
        dim as TypeId rt = this.Inner( t )
        dim as boolean isSub = (this.Kind( rt ) = TK_BUILTIN)
        if isSub then isSub = (this.BuiltinOf( rt ) = TY_VOID)
        if isSub then return prefix & "sub( " & ps & " )"
        return prefix & "function( " & ps & " ) as " & this.Name( rt )
    case TK_UDT, TK_ENUM, TK_TYPEDEF, TK_FORWARD
        dim as InternId nm = this.types[cast( long, t )].name
        if (this.names <> 0) andalso (nm <> INTERN_NONE) then
            return prefix & this.names->Spelling( nm )
        end if
        return prefix & "<udt>"
    case else
        return prefix & "<error-type>"
    end select
end function

end namespace

namespace Tko

function DumpTypes( byref tc as TypeContext ) as string
    dim as string outp = ""
    outp += "target: pointer=" & tc.target.pointerBits & " bits, wchar=" & _
            tc.target.wcharBytes & " bytes, string=" & tc.target.stringBytes & _
            " bytes align " & tc.target.stringAlign & chr( 10 )
    outp += "types: " & tc.Count( ) & chr( 10 )

    for i as long = 1 to tc.Count( )
        dim as TypeId t = cast( TypeId, i )
        dim as TypeLayout ly = tc.Layout( t )
        dim as string nm = tc.Name( t )
        while len( nm ) < 22
            nm += " "
        wend
        outp += right( "    " & str( i ), 4 ) & " " & nm & _
                " size=" & right( "   " & str( ly.size ), 3 ) & _
                " align=" & right( "  " & str( ly.align ), 2 ) & chr( 10 )
    next
    return outp
end function

end namespace
