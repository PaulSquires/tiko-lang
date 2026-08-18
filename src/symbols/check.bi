'' check.bi -- expression typing and operand legality.
''
'' The promotion rules here were MEASURED, not derived from the manual: every one of
'' the 3,920 (lhs, op, rhs) combinations in tests/types/expected/fbc-promotion.txt was
'' put to fbc as '#print typeof( a op b )', which fbc answers at compile time. That is
'' the frontend's own answer rather than something inferred from generated code.
''
'' What the table says, and none of it is what a C programmer would guess:
''
''   - Integers promote to INTEGER, which is POINTER-SIZED (64-bit here), not to the
''     32-bit LONG that C's integer promotions would give. 'ubyte + ubyte' is INTEGER.
''   - The result is UINTEGER only when an operand is itself 64-bit unsigned
''     (uinteger or ulongint). 'ulong + ulong' is INTEGER, because signed 64 holds
''     every unsigned 32 value.
''   - '/' is ALWAYS floating point -- 'long / long' is DOUBLE. Integer division is
''     the separate '\' operator.
''   - '^' is ALWAYS DOUBLE, even for 'single ^ single'.
''   - Comparisons yield INTEGER, not BOOLEAN. '=' and '<>' yield BOOLEAN only when
''     BOTH operands are already boolean.
''   - Arithmetic on BOOLEAN is rejected outright: 'boolean + boolean' is an error,
''     while 'boolean and long' is fine and yields INTEGER.

#ifndef __FBX_CHECK_BI__
#define __FBX_CHECK_BI__

#include once "fbx.bi"
#include once "ast/nodes.bi"
#include once "symbols/symbol.bi"
#include once "symbols/resolve.bi"
#include once "types/type.bi"
#include once "diag/engine.bi"

namespace Fbx.Check

    type Stats
        as long typed          '' expressions given a type
        as long untyped        '' reached, but no type could be determined
        as long badOperands    '' operand combinations fbc would reject
        as long callsResolved  '' calls bound to one overload
        as long callsAmbiguous '' calls with no single best candidate
    end type

    '' What one argument costs to pass to one parameter. Lower is better; CONV_NONE
    '' means the conversion does not exist and the candidate is not viable.
    ''
    '' The ordering was FITTED to tests/types/expected/fbc-overload.txt rather than
    '' derived: fbc's own ranking is not published, so the honest description is that
    '' this model reproduces every one of the 1,274 measured choices, not that it is
    '' the algorithm fbc runs.
    '' The tiers are separated by more than any within-tier distance can make up, so
    '' the ORDER is absolute: staying in the class beats changing it, widening beats
    '' narrowing, and only then does width distance decide. Each of those was forced
    '' by a measured row that a gentler separation got wrong.
    const CONV_EXACT    as long = 0
    const CONV_WIDEN    as long = 100      '' same class, no loss
    const CONV_NARROW   as long = 1000     '' same class, lossy -- always dearer than
                                           '' any widening, however far
    const CONV_CLASS    as long = 5000     '' integer <-> float
    const CONV_BOOL     as long = 20000    '' anything <-> boolean
    const CONV_NONE     as long = 999999

    declare function ConversionCost _
        ( byval from_ as Fbx.TypeId, byval to_ as Fbx.TypeId, _
          byref types as Fbx.TypeContext ) as long

    '' Whether 'target = source' is allowed, and whether fbc warns about it.
    '' Assignment legality is a DIFFERENT question from binary promotion and does not
    '' follow from it: every numeric-to-numeric assignment is accepted, narrowing and
    '' all, without so much as a warning -- while 'long + string' and 'long = string'
    '' are both refused.
    enum AssignKind
        ASSIGN_OK = 0
        ASSIGN_WARN         '' allowed, but fbc warns -- pointer <-> pointer-sized int
        ASSIGN_REJECT
    end enum

    declare function AssignableTo _
        ( byval src as Fbx.TypeId, byval dst as Fbx.TypeId, _
          byref types as Fbx.TypeContext ) as AssignKind

    '' The type of 'lhs op rhs', or TYPE_NONE if the combination is not allowed.
    declare function BinaryResult _
        ( byval op as Fbx.TokenKind, byval lhs as Fbx.TypeId, byval rhs as Fbx.TypeId, _
          byref types as Fbx.TypeContext ) as Fbx.TypeId

    declare function Run _
        ( byref ast as Fbx.AstArena, byval root as Fbx.NodeId, _
          byref syms as Fbx.SymbolTable, byref types as Fbx.TypeContext, _
          byref names as Fbx.Interner, byref diags as Fbx.DiagnosticEngine, _
          byref info as Fbx.SemanticInfo, byref st as Stats ) as long

    '' One line per PRINT argument: the source line, and the type computed for it.
    '' That shape exists so tools/gen/check-promo.sh can put fbx's answer next to
    '' fbc's for the same 3,920 combinations.
    declare function Dump _
        ( byref ast as Fbx.AstArena, byref src as Fbx.SourceManager, _
          byref types as Fbx.TypeContext, byref info as Fbx.SemanticInfo, _
          byref st as Stats ) as string

end namespace

#endif
