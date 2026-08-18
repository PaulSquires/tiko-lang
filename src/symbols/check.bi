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
    end type

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
