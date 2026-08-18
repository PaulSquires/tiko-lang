'' type.bas -- see type.bi

#include once "types/type.bi"

namespace Fbx

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
    FBX_BUILTIN_LIST( BUILTIN )
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
function DefaultTargetLayout( ) as TargetLayout
    dim as TargetLayout t
    t.pointerBits = 64
    #ifdef __FB_WIN32__
        t.wcharBytes = 2
    #else
        t.wcharBytes = 4
    #endif
    t.stringBytes = 24          '' FBSTRING: data ptr + len + size
    t.stringAlign = 8
    t.maxAlign = 8
    return t
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

function TypeContext.ArrayOf( byval elem as TypeId, byval rank as long ) as TypeId
    return this.Find( TK_ARRAY, elem, TF_COMPLETE, rank )
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

    return this.Find( cast( TypeKind, src->kind ), src->inner, want, src->dims )
end function

'' -------------------------------------------------------------------- queries

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

    case TK_ARRAY
        '' A fixed array's total size needs its bounds, which live on the
        '' declaration rather than the type; the element layout is what is known here.
        r = this.Layout( this.Inner( t ) )

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
        dim as long d = this.types[cast( long, t )].dims
        dim as string dims = ""
        if d > 0 then
            for i as long = 2 to d
                dims += ","
            next
        end if
        return prefix & this.Name( this.Inner( t ) ) & "(" & dims & ")"
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

namespace Fbx

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
