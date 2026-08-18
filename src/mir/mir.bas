'' mir.bas -- MIR construction and the opcode metadata tables.

#include once "mir/mir.bi"

namespace Fbx.Mir

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
    FBX_MIR_LIST( OP )
    #undef OP
    end select
    return "?"
end function

function OpArity( byval o as MirOp ) as long
    select case o
    #define OP( o_id, o_name, o_args, o_res ) case o_id : return o_args
    FBX_MIR_LIST( OP )
    #undef OP
    end select
    return 0
end function

function OpHasResult( byval o as MirOp ) as boolean
    select case o
    #define OP( o_id, o_name, o_args, o_res ) case o_id : return o_res
    FBX_MIR_LIST( OP )
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
    ( byval t as Fbx.TypeId, byref types as Fbx.TypeContext ) as MirType

    if t = Fbx.TYPE_NONE then return MT_VOID

    select case types.Kind( t )
    case Fbx.TK_POINTER, Fbx.TK_REFERENCE, Fbx.TK_PROC
        return MT_PTR
    case Fbx.TK_UDT, Fbx.TK_ENUM
        '' An ENUM is its underlying integer; a UDT is opaque.
        if types.Kind( t ) = Fbx.TK_ENUM then return MT_I32
        return MT_AGG
    case Fbx.TK_BUILTIN
        select case types.BuiltinOf( t )
        case Fbx.TY_VOID     : return MT_VOID
        case Fbx.TY_BYTE, Fbx.TY_UBYTE, Fbx.TY_BOOLEAN : return MT_I8
        case Fbx.TY_SHORT, Fbx.TY_USHORT : return MT_I16
        case Fbx.TY_LONG, Fbx.TY_ULONG   : return MT_I32
        case Fbx.TY_INTEGER, Fbx.TY_UINTEGER, Fbx.TY_LONGINT, Fbx.TY_ULONGINT
            '' INTEGER is pointer-sized, so its width comes from the target rather
            '' than from a constant.
            if types.target.pointerBits = 32 then return MT_I32
            return MT_I64
        case Fbx.TY_SINGLE   : return MT_F32
        case Fbx.TY_DOUBLE   : return MT_F64
        case Fbx.TY_ANY      : return MT_VOID
        end select
    end select
    return MT_VOID
end function

end namespace
