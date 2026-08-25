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
function HostTarget( ) as TargetId
    #ifdef __FB_WIN32__
        return TARGET_WIN64
    #else
        return TARGET_LINUX_X86_64
    #endif
end function

function TargetName( byval t as TargetId ) as string
    select case t
    case TARGET_WIN32           : return "win32"
    case TARGET_LINUX_X86_64    : return "linux-x86_64"
    end select
    return "win64"
end function

function TargetFromName( byval nm as string, byref ok as boolean ) as TargetId
    ok = true
    dim as string s = Text.LowerAscii( nm )
    if s = "win64" then return TARGET_WIN64
    if s = "win32" then return TARGET_WIN32
    if s = "linux-x86_64" then return TARGET_LINUX_X86_64
    ok = false
    return HostTarget( )
end function

function TargetIs64( byval t as TargetId ) as boolean
    return t <> TARGET_WIN32
end function

function TargetIsWindows( byval t as TargetId ) as boolean
    return t <> TARGET_LINUX_X86_64
end function

'' Measured, per target, rather than derived from the pointer width -- because two of
'' these numbers do not follow from it. The FBSTRING descriptor is 12 bytes on win32
'' and 24 on win64, but its ALIGNMENT is 4 there and 8 here; and maxAlign stays 8 on
'' win32, where an 8-byte field still aligns to 8. 'type W { byte; string }' is 16
'' bytes with the string at offset 4 on win32, which is what pins both.
function TargetLayoutFor( byval t as TargetId ) as TargetLayout
    dim as TargetLayout r
    r.maxAlign = 8
    select case t
    case TARGET_WIN32
        r.pointerBits = 32
        r.wcharBytes = 2
        r.stringBytes = 12
        r.stringAlign = 4
        r.cvaListBytes = 4
        r.cvaListAlign = 4
        r.isWindows = true
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
        this.types.Push( bi )
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

function TypeContext.Find _
    ( byval wantKind as TypeKind, byval innerT as TypeId, byval fl as ushort, _
      byval rank as long ) as TypeId

    for i as long = 1 to this.types.Count - 1
        dim as TypeInfo ptr t = @this.types[i]
        dim as boolean same = (t->kind = cast( ubyte, wantKind )) andalso _
                              (t->inner = innerT) andalso _
                              (t->flags = fl) andalso (t->dims = rank)
        if same then return cast( TypeId, i )
    next

    dim as TypeInfo n
    n.kind = cast( ubyte, wantKind )
    n.builtin = 0
    n.flags = fl
    n.inner = innerT
    n.dims = rank
    this.types.Push( n )
    return cast( TypeId, this.types.Count - 1 )
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
    for i as long = 1 to this.types.Count - 1
        dim as TypeInfo ptr t = @this.types[i]
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
            if same then return cast( TypeId, i )
        end if
    next
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
    this.types.Push( n )
    return cast( TypeId, this.types.Count - 1 )
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
        for i as long = 1 to this.types.Count - 1
            dim as TypeInfo ptr c = @this.types[i]
            dim as boolean same = (c->kind = src->kind) andalso _
                                  (c->builtin = src->builtin) andalso (c->flags = want)
            if same then return cast( TypeId, i )
        next
        dim as TypeInfo n = *src
        n.flags = want
        this.types.Push( n )
        return cast( TypeId, this.types.Count - 1 )
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
        for i as long = 1 to this.types.Count - 1
            dim as TypeInfo ptr c2 = @this.types[i]
            if c2->kind <> src->kind then continue for
            if c2->name <> nm then continue for
            if c2->flags = want then return cast( TypeId, i )
        next
        dim as TypeInfo n2 = *src
        n2.flags = want
        this.types.Push( n2 )
        return cast( TypeId, this.types.Count - 1 )
    end select

    return this.Find( cast( TypeKind, src->kind ), src->inner, want, src->dims )
end function

'' -------------------------------------------------------------------- queries

function TypeContext.NamedType _
    ( byval k as TypeKind, byval nm as InternId, _
      byval declScope as ulong = 0 ) as TypeId

    if nm = 0 then return TYPE_NONE
    for i as long = 1 to this.types.Count - 1
        dim as TypeInfo ptr t = @this.types[i]
        if (t->kind = cast( ubyte, k )) andalso (t->name = nm) andalso _
           (t->declScope = declScope) then
            return cast( TypeId, i )
        end if
    next
    dim as TypeInfo n
    n.kind = cast( ubyte, k )
    n.flags = TF_COMPLETE
    n.name = nm
    n.declScope = declScope
    this.types.Push( n )
    return cast( TypeId, this.types.Count - 1 )
end function

function TypeContext.Unqualify( byval t as TypeId ) as TypeId
    if t = TYPE_NONE then return t
    dim as TypeInfo ptr src = @this.types[cast( long, t )]
    dim as ushort want = src->flags and (not TF_CONST)
    if want = src->flags then return t

    if src->kind = cast( ubyte, TK_BUILTIN ) then
        for i as long = 1 to this.types.Count - 1
            dim as TypeInfo ptr c = @this.types[i]
            dim as boolean same = (c->kind = src->kind) andalso _
                                  (c->builtin = src->builtin) andalso (c->flags = want)
            if same then return cast( TypeId, i )
        next
        dim as TypeInfo n = *src
        n.flags = want
        this.types.Push( n )
        return cast( TypeId, this.types.Count - 1 )
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
        for i as long = 1 to this.types.Count - 1
            dim as TypeInfo ptr c2 = @this.types[i]
            if c2->kind <> src->kind then continue for
            if c2->name <> nm then continue for
            if c2->flags = want then return cast( TypeId, i )
        next
        dim as TypeInfo n2 = *src
        n2.flags = want
        this.types.Push( n2 )
        return cast( TypeId, this.types.Count - 1 )
    end select

    return this.Find( cast( TypeKind, src->kind ), src->inner, want, src->dims )
end function

'' A procedure type: the return type in 'inner', the parameter types in the pool.
function TypeContext.ProcType _
    ( byval ret as TypeId, byref params as TypeIdVec2 ) as TypeId

    for i as long = 1 to this.types.Count - 1
        dim as TypeInfo ptr t = @this.types[i]
        if t->kind <> cast( ubyte, TK_PROC ) then continue for
        if t->inner <> ret then continue for
        if t->count <> params.Count then continue for
        dim as boolean same = true
        for j as long = 0 to t->count - 1
            if this.pool[t->first + j] <> params[j] then
                same = false
                exit for
            end if
        next
        if same then return cast( TypeId, i )
    next

    dim as TypeInfo n
    n.kind = cast( ubyte, TK_PROC )
    n.flags = TF_COMPLETE
    n.inner = ret
    n.first = this.pool.Count
    n.count = params.Count
    for i as long = 0 to params.Count - 1
        this.pool.Push( params[i] )
    next
    this.types.Push( n )
    return cast( TypeId, this.types.Count - 1 )
end function

function TypeContext.DeclScopeOf( byval t as TypeId ) as ulong
    if (t = TYPE_NONE) orelse (cast( long, t ) >= this.types.Count) then return 0
    return this.types[cast( long, t )].declScope
end function

function TypeContext.Packing( byval t as TypeId ) as long
    if (t = TYPE_NONE) orelse (cast( long, t ) >= this.types.Count) then return 0
    return this.types[cast( long, t )].packing
end function

sub TypeContext.SetPacking( byval t as TypeId, byval n as long )
    if (t = TYPE_NONE) orelse (cast( long, t ) >= this.types.Count) then return
    this.types[cast( long, t )].packing = n
end sub

function TypeContext.ElemCount( byval t as TypeId ) as long
    if (t = TYPE_NONE) orelse (cast( long, t ) >= this.types.Count) then return 0
    return this.types[cast( long, t )].elems
end function

function TypeContext.NameOf( byval t as TypeId ) as InternId
    if (t = TYPE_NONE) orelse (cast( long, t ) >= this.types.Count) then return 0
    return this.types[cast( long, t )].name
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
