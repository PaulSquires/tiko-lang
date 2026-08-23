'' mir.bas -- MIR construction and the opcode metadata tables.

#include once "mir/mir.bi"

namespace Tko.Mir

constructor MirModule( )
end constructor

destructor MirModule( )
    for i as long = 0 to this.functions.Count - 1
        if this.functions[i] <> 0 then delete this.functions[i]
    next
end destructor

function MirModule.AddFunction _
    ( byval nm as InternId, byval retTy as MirType ) as MirFunction ptr

    dim as MirFunction ptr f = new MirFunction
    f->name = nm
    f->retTy = cast( ubyte, retTy )
    f->nextTemp = 1
    this.functions.Push( f )
    return f
end function

'' A WIDE string literal.
''
'' Measured: fbc folds 'wstr( "abc" )' at COMPILE TIME into L"abc" and emits no call
'' at all -- not fb_StrToWstr on the literal's bytes. Kept separate from the narrow
'' pool because a narrow and a wide literal of the same text are different objects.
'' A DATA block. Never shared: two identical blocks are still two blocks, because
'' the chain threads through their terminators and sharing one would make it a cycle.
function MirModule.AddDataBlock( byref names as Interner ) as long
    dim as MirGlobal g
    g.isData = true
    g.dataFirst = this.dataTypes.Count
    g.dataCount = 0
    g.name = names.GetString( "$data" & str( this.globals.Count ) )
    this.globals.Push( g )
    return this.globals.Count - 1
end function

sub MirModule.PushDataEntry _
    ( byval g as long, byval ty as long, byval ref as long )

    if (g < 0) orelse (g >= this.globals.Count) then return
    this.dataTypes.Push( ty )
    this.dataRefs.Push( ref )
    this.globals[g].dataCount += 1
end sub

function MirModule.AddWideStringLiteral _
    ( byref text as string, byref names as Interner ) as long

    for i as long = 0 to this.globals.Count - 1
        if this.globals[i].isString andalso this.globals[i].isWide andalso _
           (this.globals[i].bytes = text) then
            return i
        end if
    next
    dim as MirGlobal g
    g.bytes = text
    g.isString = true
    g.isWide = true
    g.name = names.GetString( "$wstr" & str( this.globals.Count ) )
    this.globals.Push( g )
    return this.globals.Count - 1
end function

function MirModule.AddStringLiteral _
    ( byref text as string, byref names as Interner ) as long

    for i as long = 0 to this.globals.Count - 1
        if this.globals[i].isString andalso (this.globals[i].isWide = false) andalso _
           (this.globals[i].bytes = text) then
            return i
        end if
    next
    dim as MirGlobal g
    g.bytes = text
    g.isString = true
    g.name = names.GetString( "$str" & str( this.globals.Count ) )
    this.globals.Push( g )
    return this.globals.Count - 1
end function

function MirModule.AddPtrTable( byval nm as InternId ) as long
    '' By NAME, so a type's table is found again rather than built twice: the base's
    '' RTTI is referenced by every type below it in the chain.
    for i as long = 0 to this.globals.Count - 1
        if this.globals[i].isPtrTable andalso (this.globals[i].name = nm) then return i
    next
    dim as MirGlobal g
    g.name = nm
    g.isPtrTable = true
    g.ptrFirst = this.ptrKinds.Count
    g.ptrCount = 0
    this.globals.Push( g )
    return this.globals.Count - 1
end function

'' The three entry kinds. Each APPENDS, so a table has to be filled before the next one
'' is opened -- the pool is shared and the runs are contiguous.
sub MirModule.PushPtrNull( byval g as long )
    this.ptrKinds.Push( 0 )
    this.ptrRefs.Push( 0 )
    this.globals[g].ptrCount += 1
end sub

sub MirModule.PushPtrGlobal( byval g as long, byval which as long )
    this.ptrKinds.Push( 1 )
    this.ptrRefs.Push( cast( ulong, which ) )
    this.globals[g].ptrCount += 1
end sub

sub MirModule.PushPtrFunc( byval g as long, byval nm as InternId )
    this.ptrKinds.Push( 2 )
    this.ptrRefs.Push( cast( ulong, nm ) )
    this.globals[g].ptrCount += 1
end sub

function MirModule.AddVarGlobal _
    ( byval nm as InternId, byval ty as MirType, byval ft as Tko.TypeId, _
      byval sizeBytes as long ) as long

    for i as long = 0 to this.globals.Count - 1
        if this.globals[i].isVar andalso (this.globals[i].name = nm) then return i
    next
    dim as MirGlobal g
    g.name = nm
    g.isVar = true
    g.ty = cast( ubyte, ty )
    g.frontendType = ft
    g.size = sizeBytes
    this.globals.Push( g )
    return this.globals.Count - 1
end function

'' ------------------------------------------------------------------ metadata

function TypeName( byval t as MirType ) as string
    select case t
    case MT_VOID : return "void"
    case MT_I8   : return "i8"
    case MT_I16  : return "i16"
    case MT_I32  : return "i32"
    case MT_I64  : return "i64"
    case MT_F32  : return "f32"
    case MT_F64  : return "f64"
    case MT_PTR  : return "ptr"
    case MT_AGG  : return "agg"
    end select
    return "?"
end function

function OpName( byval o as MirOp ) as string
    select case o
    #define OP( o_id, o_name, o_args, o_res ) case o_id : return o_name
    TKO_MIR_LIST( OP )
    #undef OP
    end select
    return "?"
end function

function OpArity( byval o as MirOp ) as long
    select case o
    #define OP( o_id, o_name, o_args, o_res ) case o_id : return o_args
    TKO_MIR_LIST( OP )
    #undef OP
    end select
    return 0
end function

function OpHasResult( byval o as MirOp ) as boolean
    select case o
    #define OP( o_id, o_name, o_args, o_res ) case o_id : return o_res
    TKO_MIR_LIST( OP )
    #undef OP
    end select
    return false
end function

'' ------------------------------------------------------------------- lowering

'' The MIR type of a frontend type. Note what collapses here: BOOLEAN becomes i8,
'' every pointer becomes MT_PTR whatever it points at, and STRING is NOT handled --
'' it is a 24-byte descriptor whose lowering needs the runtime, which this slice of
'' phase 6 does not have.
function LowerType _
    ( byval t as Tko.TypeId, byref types as Tko.TypeContext ) as MirType

    if t = Tko.TYPE_NONE then return MT_VOID

    select case types.Kind( t )
    case Tko.TK_POINTER, Tko.TK_REFERENCE, Tko.TK_PROC
        return MT_PTR
    case Tko.TK_ARRAY
        '' A fixed array is storage, addressed by arithmetic rather than loaded whole,
        '' so it is an aggregate however small it is. Falling through to the element's
        '' type would reserve ONE element -- four bytes where forty were needed.
        return MT_AGG
    case Tko.TK_UDT, Tko.TK_ENUM
        '' An ENUM is its underlying integer; a UDT is opaque.
        if types.Kind( t ) = Tko.TK_ENUM then return MT_I32
        return MT_AGG
    case Tko.TK_BUILTIN
        select case types.BuiltinOf( t )
        case Tko.TY_VOID     : return MT_VOID
        case Tko.TY_BYTE, Tko.TY_UBYTE, Tko.TY_BOOLEAN : return MT_I8
        case Tko.TY_SHORT, Tko.TY_USHORT : return MT_I16
        case Tko.TY_LONG, Tko.TY_ULONG   : return MT_I32
        case Tko.TY_INTEGER, Tko.TY_UINTEGER, Tko.TY_LONGINT, Tko.TY_ULONGINT
            '' INTEGER is pointer-sized, so its width comes from the target rather
            '' than from a constant.
            if types.target.pointerBits = 32 then return MT_I32
            return MT_I64
        case Tko.TY_STRING, Tko.TY_USTRING
            '' A var-length string is a DESCRIPTOR -- 24 bytes on x86-64 -- not a
            '' pointer. Lowering it as MT_PTR would reserve 8 bytes and corrupt the
            '' neighbouring slot the moment the runtime wrote to it.
            return MT_AGG
        case Tko.TY_SINGLE   : return MT_F32
        case Tko.TY_DOUBLE   : return MT_F64
        '' AN AGGREGATE ON EVERY TARGET, even where it is pointer-sized. On Windows a
        '' cva_list is one pointer and MT_PTR would fit, but on Linux it is 24 bytes --
        '' and the four cva_* opcodes all take its ADDRESS, so nothing ever loads it
        '' whole. One shape everywhere means the lowering has no target case in it.
        case Tko.TY_CVA_LIST : return MT_AGG
        case Tko.TY_ANY      : return MT_VOID
        end select
    end select
    return MT_VOID
end function

end namespace
