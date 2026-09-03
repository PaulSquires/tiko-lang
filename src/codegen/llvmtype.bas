'' llvmtype.bas -- see the header for why each of these is what it is.

#include once "codegen/llvmtype.bi"

namespace Tko.Codegen

using Tko.Mir

function AggType( byval sizeBytes as long ) as string
    '' A ZERO-BYTE aggregate is still a type LLVM must be able to name. '[0 x i8]' is
    '' legal and is what an empty UDT is; refusing it here would decline a program
    '' fbc accepts.
    dim as long n = sizeBytes
    if n < 0 then n = 0
    return "[" & str( n ) & " x i8]"
end function

function LlvmType _
    ( byval t as MirType, byval aggSize as long ) as string

    select case t
    case MT_VOID : return "void"
    case MT_I8   : return "i8"
    case MT_I16  : return "i16"
    case MT_I32  : return "i32"
    case MT_I64  : return "i64"
    case MT_F32  : return "float"
    case MT_F64  : return "double"
    '' OPAQUE. Typed pointers were removed in LLVM 17 and are not accepted by the
    '' clang 18 minimum this backend targets, so there is only one pointer type and
    '' nothing to derive it from.
    case MT_PTR  : return "ptr"
    case MT_AGG  : return AggType( aggSize )
    end select
    return "void"
end function

function LlvmFloatConst _
    ( byval v as double, byval isSingle as boolean ) as string

    dim as double d = v
    '' A SINGLE is ROUNDED THROUGH 'single' FIRST. LLVM requires the hex form of a
    '' 'float' constant to be a double that is exactly representable as a float; the
    '' bits of the original double are not, and it rejects them. Rounding here is the
    '' same rounding the target does.
    if isSingle then d = cast( double, cast( single, v ) )
    dim as ulongint bits = 0
    '' The BIT PATTERN, not a reinterpretation of the number: memcpy through a pointer
    '' is the one spelling that cannot be optimised into a conversion.
    dim as any ptr src = @d
    dim as any ptr dst = @bits
    for i as long = 0 to 7
        cast( ubyte ptr, dst )[i] = cast( ubyte ptr, src )[i]
    next
    dim as string h = hex( bits, 16 )
    return "0x" & h
end function

end namespace
