'' abi.bi -- the platform ABI, as a MIR-to-MIR pass.
''
'' docs/plan/10 section 3, and the Brief: "create explicit ABI-lowering code; do not
'' scatter ABI rules throughout the compiler". This is that one place. It runs after
'' lowering and before emission, and it rewrites signatures and call sites so that the
'' emitted IR contains NO IMPLICIT ABI BEHAVIOUR -- every aggregate is already a
'' pointer or an integer of the right width by the time the emitter sees it, and the
'' emitter does no ABI reasoning of its own.
''
'' That split is what makes the ABI testable on its own: '--dump-ir' after this pass
'' shows exactly what will be passed and in what form, without reading a line of LLVM.
''
'' THE RULE IS MEASURED, not transcribed -- docs/internals/phase-7-win64-abi.md. On
'' win64 an aggregate is passed and returned in a register if and only if its size is
'' 1, 2, 4 or 8, coerced to the INTEGER of that size; everything else is indirect. There
'' is no floating-point coercion for aggregates in either direction, which is why this
'' file has no float case: docs/plan/10 lists the 8-byte float struct returning in RAX
'' as a special trap, and the measurement says it is not special at all.

#ifndef __TKO_ABI_BI__
#define __TKO_ABI_BI__

#include once "tko.bi"
#include once "mir/mir.bi"
#include once "codegen/target.bi"

namespace Tko.Codegen

    '' How one aggregate travels. Scalars never reach the classifier.
    enum AbiClassKind
        '' In a register, as the integer of the aggregate's own size.
        ABIC_DIRECT_INT = 0
        '' In memory: the CALLER allocates a copy and passes its address. For a return
        '' the caller allocates the destination and passes it as a hidden first
        '' argument -- LLVM's 'sret'.
        ABIC_INDIRECT
    end enum

    '' The only question the classifier asks is how many bytes. See the header comment.
    declare function ClassifyAggregate _
        ( byval sizeBytes as long, byref target as TargetDescription ) as AbiClassKind

    '' The MIR type an aggregate of this size is coerced to, for ABIC_DIRECT_INT.
    declare function DirectIntType( byval sizeBytes as long ) as Tko.Mir.MirType

    type AbiStats
        as long functionsRewritten
        as long callsRewritten
        as long sretReturns
        as long coercedReturns
        as long indirectParams
        as long coercedParams
        '' Something the pass could not model. It is COUNTED rather than guessed at:
        '' a half-applied ABI is a miscompile, and the emitter's own ICE is a better
        '' failure than a call whose two halves disagree.
        as long declined
    end type

    declare sub LowerModule _
        ( byref m as Tko.Mir.MirModule, byref names as Tko.Interner, _
          byref target as TargetDescription, byref st as AbiStats )

end namespace

#endif
