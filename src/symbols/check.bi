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

    '' The POINTER tiers, measured in tests/types/expected/fbc-ptr.txt.
    ''
    '' An exact pointer type wins, 'any ptr' comes next, then a pointer whose POINTEE
    '' is the same width and class ('ulong ptr' for a LONG PTR argument, 'wstring ptr'
    '' for a SHORT PTR one), then everything else. That last tier is the one fbc warns
    '' about -- warning 3, 'Passing different pointer types' -- and warning 3 is also
    '' what makes a candidate unviable once the procedure is overloaded, which is the
    '' whole reason ConversionCost has to be told which question it is answering.
    const CONV_PTR_ANY   as long = 200
    const CONV_PTR_NEAR  as long = 250
    const CONV_PTR_OTHER as long = 400

    '' A string converts to a pointer of its OWN string kind more cheaply than to
    '' 'string' itself, and to the other kind more dearly: a literal (which is
    '' ZSTRING * n) offered 'zstring ptr' and 'string' takes the pointer, while a
    '' STRING variable offered the same pair takes string.
    const CONV_STRPTR_SAME  as long = 50
    const CONV_STRPTR_OTHER as long = 150

    '' pointer <-> a pointer-sized integer. Dearer than the BOOLEAN tier because it
    '' loses to it: an INTEGER argument offered 'any ptr' and 'boolean' takes boolean,
    '' and a pointer argument offered 'any ptr' and 'integer' takes any ptr. Staying
    '' in the class wins on both sides.
    const CONV_PTR_CLASS as long = 50000

    '' 'overloaded' says whether more than one candidate is in play, because fbc asks
    '' two DIFFERENT questions and the answers differ. Called on its own, a procedure
    '' taking 'byte ptr' accepts a SHORT PTR argument with warning 3; add any second
    '' overload -- even a plainly unviable 'double' one -- and the same call is
    '' refused outright. Measured, not inferred: tests/types/expected/fbc-ptr.txt.
    declare function ConversionCost _
        ( byval from_ as Fbx.TypeId, byval to_ as Fbx.TypeId, _
          byref types as Fbx.TypeContext, _
          byval overloaded as boolean = false ) as long

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

    '' A folded constant. 'known' is false for anything this pass cannot evaluate --
    '' which is not an error, only an absence.
    type ConstVal
        as boolean  known
        as longint  value
    end type

    '' Fold an expression to an integer constant, matching fbc bit for bit. The
    '' source manager is needed for LEN and ASC, whose argument is a string literal
    '' recorded as a span rather than as text.
    declare function ConstOf _
        ( byref ast as Fbx.AstArena, byval id as Fbx.NodeId, _
          byref src as Fbx.SourceManager, byref names as Fbx.Interner ) as ConstVal

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
          byref types as Fbx.TypeContext, byref names as Fbx.Interner, _
          byref info as Fbx.SemanticInfo, byref st as Stats ) as string

end namespace

#endif
