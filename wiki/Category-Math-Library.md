[Home](Home) › [All Categories](Categories) › **Math Library**

# Math Library

```freebasic
#import "std/numeric"
#import "std/money"

using numeric, money
```

The built-in numeric surface is ABS SGN SQR SIN COS TAN ASIN ACOS ATN ATAN2 EXP LOG INT FIX FRAC RND RANDOMIZE and the operators. No MIN, no MAX, no ROUND, no pi, no way to ask whether a DOUBLE is NaN, no money type, no complex numbers, no vectors, no statistics, and no way to tell a failed parse from a legitimate zero.

These modules add those. Everything is a library behind an #import -- std/numeric, and std/money for the money types. NOTHING BECOMES A KEYWORD and nothing existing changes.

## WHY IT EXISTS -- four things the language gets wrong today

All four verified by compiling them, not asserted.

```freebasic
dim as int64 b = 3, e = 38
print b ^ e             ' 1350851717672992000  -- exact answer ends 089
```

'^' ALWAYS YIELDS DOUBLE.  There is no integer exponentiation: a ^ b converts to floating point, calls pow, converts back.  Above 2^53 the result is wrong even when operands and true result all fit in a LONGINT.  Constant folding CONCEALS it -- a literal '2 ^ 62' is exact -- so it appears only once the operands become variables.        ->  IPow( 3LL, 38LL )

```freebasic
print -7 mod 3          ' -1
```

'MOD' TRUNCATES.  Every wrapping index, hash bucket and day-of-week computation wants 2.              ->  FloorMod( -7, 3 )

```freebasic
print val( "abc" )      ' 0
print val( "0" )        ' 0
```

'VAL' CANNOT FAIL.  Garbage and a legitimate zero are the same answer, and val("12abc") is 12 -- a prefix parse with the tail silently discarded.

```freebasic
                              ->  TryParseDouble( s )

print str( 0.1 + 0.2 )              ' 0.3
print val( str( 0.1+0.2 ) ) = 0.1+0.2   ' FALSE
```

'STR' DOES NOT ROUND-TRIP.  The value that comes back is not the value that went in.  str(1.0/3.0) happens to survive, so the failure is DATA-DEPENDENT and shows up later, in a file already on disk.

```freebasic
->  ToString( d )
```

None of these four are fixed in place.  '^', 'MOD', 'VAL', 'STR', 'RND' and 'RANDOMIZE' are left exactly as they are, in every dialect.  Each defect gets a correct neighbour under a different name.

## Nothing Becomes A Keyword

```freebasic
dim as int32 min = 1, max = 2, round = 3, clamp = 4      ' still compiles
```

Those four are the most obvious names here and all four are legal identifiers in tiko.  Plenty of code uses them as variable names, so everything belongs to the module and 'using numeric' is your decision.  Your own local shadows the library cleanly and the qualified name still works:

```freebasic
#import "std/numeric"
using numeric
dim as float64 e = 2.0
print e, numeric.E              ' 2    2.718281828459045
```

Because these modules add no keyword and no grammar, they cannot change any existing diagnostic.

========================== std/numeric: math.tiko ==========================

CONSTANTS

```freebasic
PI TAU E SQRT2 LN2 LN10 DEG2RAD RAD2DEG
EPSILON_DOUBLE MAX_DOUBLE MIN_POSITIVE_DOUBLE
EPSILON_SINGLE MAX_SINGLE MIN_POSITIVE_SINGLE
```

The non-finite values are FUNCTIONS, not constants -- 'const as double N = 0.0/0.0' is a compile-time division by zero and does not compile:

```freebasic
NaN( )  Infinity( )  NegInfinity( )
NaNF( ) InfinityF( ) NegInfinityF( )
MinSubnormalDouble( )  MinSubnormalSingle( )
```

Integer bounds are NOT duplicated here; fblimits.bi already supplies FB.MIN_VALUE_LONGINT and friends. The module includes it for its own use, but an import does not pass it on -- #include it yourself.

CLASSIFICATION

```freebasic
IsNaN( x )      IsInfinite( x )   IsFinite( x )
IsNormal( x )   IsSubnormal( x )  IsNegative( x )
Classify( x ) -> FP_NAN FP_INFINITE FP_ZERO FP_SUBNORMAL FP_NORMAL
```

SINGLE and DOUBLE.  These read the exponent and mantissa FIELDS rather than comparing.  'x <> x' is a correct NaN test only while the compiler may not assume finiteness; under -fpmode fast it is not.

ONE OF THESE READS WRONG AT FIRST GLANCE:

```freebasic
IsNegative( -0.0 )      ' TRUE
-0.0 < 0.0              ' false
-0.0 = 0.0              ' true
```

IsNegative is a SIGN-BIT query.  The two zeros are equal as numbers and distinguishable as bit patterns, and this is what tells them apart.

SELECTION

```freebasic
Min( a, b )   Max( a, b )   Clamp( v, lo, hi )
Lerp( a, b, t )             Sign( x ) as LONG
```

Every integer type plus SINGLE and DOUBLE (Lerp is floating point only).

NaN PROPAGATES: Min( NaN( ), 1.0 ) is NaN.  C's fmin returns the non-NaN operand; that is a defensible choice and it is not this one, because silently discarding a NaN turns a detectable error into an undetectable wrong answer.

Clamp with lo > hi RETURNS HI.  Deterministic rather than right, because there is no right answer.  A NaN v falls through and comes back unchanged.

Sign returns LONG always -- that is the difference from SGN, whose result is the argument's own type and so cannot index an array or drive a SELECT CASE. Sign( NaN( ) ) is 0.

Lerp is 'a + t\*(b-a)': monotonic, and NOT exact at t = 1 (may miss b by one ulp).  The exact-at-endpoints form is not monotonic; both cannot be had at once, and C++20's std::lerp chooses the other one and pays a branch.

Min and Max are FUNCTIONS, so both arguments are evaluated.

ROUNDING

```freebasic
Round( x )                 half away from zero:  2.5 -> 3,  -2.5 -> -3
RoundHalfEven( x )         banker's:             2.5 -> 2,  -2.5 -> -2
Round( x, digits )         0..17 decimal places
RoundHalfEven( x, digits )
Floor( x )  Ceil( x )  Truncate( x )
```

Floor and Ceil exist even though INT is floor: INT is floor and FIX is truncation, but the NAMES do not say so and code often uses INT believing it truncates.

RoundHalfEven is what financial code wants -- half-up drifts upward across a ledger.  It is implemented rather than delegated to C's rint, because rint honours the CURRENT rounding mode and would stop being deterministic the moment fenv.tiko's rounding control is used.

THE DIGITS FORM SCALES, AND THE SCALING IS VISIBLE:

```freebasic
Round( 2.675, 2 )       ' 2.68, not 2.67
```

The double nearest 2.675 is 2.67499999999999982..., so an exact decimal round gives 2.67 -- but 2.675\*100 rounds UP to exactly 267.5, so the tie rule fires. Inherent to any scale-and-round implementation.  For money, use [Finance](Category-Finance).

Outside 0..17 the result is NaN; returning the input would hide the mistake.

THE LIBM SURFACE

```freebasic
Cbrt Hypot Exp2 Expm1 Log2 Log10 Log1p LogB Pow
Sinh Cosh Tanh Asinh Acosh Atanh
Fma CopySign NextAfter ScaleB Frexp Modf Ulp
DegToRad RadToDeg
```

Real overload sets: a SINGLE argument takes the SINGLE path and calls the 'f' variant, it does not widen.  That is the specific defect that makes crt/math.bi unusable in practice -- 'sqrt' there takes a DOUBLE, so every single-precision call widens and narrows silently, twice.

Hypot does not overflow for a representable result:

```freebasic
Hypot( 1e200, 1e200 )               ' finite
sqr( 1e200*1e200 + 1e200*1e200 )    ' +inf
```

Log1p and Expm1 are the accurate-near-zero pair:

```freebasic
log( 1.0 + 1e-17 )      ' 0.0 -- the 1.0 swallowed it
Log1p( 1e-17 )          ' 1e-17
```

Pow is NOT a replacement for '^'; it is the double-to-double operation under a name.  Integer exponentiation is IPow.

======================== std/numeric: mathint.tiko ========================

DIVISION AND MODULO -- three conventions, all named

```freebasic
FloorDiv / FloorMod     sign follows the DIVISOR:  FloorMod(-7,3) = 2
EuclidDiv / EuclidMod    always non-negative:      EuclidMod(-7,-3) = 2
DivMod( a, b )           returns a TUPLE

var (q, r) = DivMod( total, perPage )
```

None of them is spelled 'Mod', so none can be confused with the operator. DivMod is where the tuple feature earns its keep: one idiv produces both.

Tuple identity is STRUCTURAL, so DivMod on LONG and on LONGINT return different types and neither converts to the other.

EXPONENTIATION, ROOTS, NUMBER THEORY

```freebasic
IPow( base, exp )        EXACT -- IPow( 3LL, 38LL ) = 1350851717672992089
IPowChecked( base, exp ) Optional
ISqrt( n )               exact floor of the true root
GCD( a, b )  LCM( a, b )
```

ISqrt is exact over the whole domain, which int( sqr( n ) ) is not: the DOUBLE conversion loses bits above 2^53 and the result can land one below the floor.

CHECKED, SATURATING AND WRAPPING

```freebasic
AddChecked SubChecked MulChecked DivChecked NegChecked AbsChecked
IPowChecked                        -> Optional( of T ), empty on overflow

AddSaturating SubSaturating MulSaturating NegSaturating AbsSaturating
AddWrapping SubWrapping MulWrapping NegWrapping
```

Every integer type.  AbsChecked is not redundant:

```freebasic
abs( MIN_VALUE_LONGINT )        ' MIN_VALUE_LONGINT itself -- NEGATIVE
```

That is the classic overflow bug and it is silent today.

THE LIMITATION, STATED PLAINLY: these protect the call sites you thought about.  Overflow bugs live at the call sites nobody thought about, which is why Rust traps by default in debug builds and Swift traps always.  A global '-checked' mode is declined on cost; this does not pretend to be it.

The wrapping family is exactly what the operators already do.  It exists so that DELIBERATE wrapping -- a hash mix, a checksum, a ring index -- can be spelled as deliberate.

BITS

```freebasic
PopCount LeadingZeros TrailingZeros BitWidth Parity
RotateLeft RotateRight ByteSwap BitReverse IsPow2 NextPow2
```

UBYTE / USHORT / ULONG / ULONGINT, with signed overloads that REINTERPRET. Width comes from the operand's own type: LeadingZeros of a UBYTE counts within 8 bits.

```freebasic
LeadingZeros( 0 )   returns the operand's FULL WIDTH
RotateLeft( x, 64 ) on a ULONGINT is x, not undefined
```

Both are decisions, not descriptions: the x86 instructions are undefined at zero without BMI, and the C rotate idiom is undefined at n = 0.

The PORTABLE implementation is the contract.  Per-backend intrinsics would be an optimisation underneath a defined result, never the definition.

NO 'INTEGER' / 'UINTEGER' OVERLOADS.  INTEGER is the same width as LONGINT on win64, so they add nothing.

THE MONEY TYPES LIVE IN THEIR OWN CATEGORY.  `std/money`'s Currency and
Decimal are documented under [Finance](Category-Finance) -- exact
fixed-point money in eight bytes, and the 128-bit .NET decimal.  They are part
of the same library and ship in the same tree; they are filed separately
because money is a subject of its own, not a corner of arithmetic.


======================= std/numeric: mathtext.tiko =======================

PARSING -- strict by default

```freebasic
TryParseDouble( s [, flags] )   TryParseSingle( s [, flags] )
TryParseLongInt( s [, base] )   TryParseULongInt( s )
TryParseLong( s )               TryParseULong( s )
```

All return Optional.  The WHOLE string must be consumed:

```freebasic
"42"        -> 42          "  42"    -> empty
"42abc"     -> empty       "1,234"   -> empty
"1e"        -> empty       ""        -> empty
"nan"/"inf" -> the value   "1.#INF"  -> the value
```

tiko's own PRINT spellings parse, so a program can read back what it wrote. Leniency is opted INTO, never out of:

```freebasic
PARSE_TRIM  PARSE_ALLOW_TRAILING  PARSE_NO_SPECIAL
```

Integer overflow is DETECTED, not clamped -- strtoll saturates and sets errno, which is the same "cannot fail" shape being replaced.

FORMATTING

```freebasic
ToString( v )               shortest string that reads back EXACTLY
ToString( v, fmt )          controlled
ToString( int64 )

ToString( 0.1 + 0.2 )       ' 0.30000000000000004
str( 0.1 + 0.2 )            ' 0.3
```

Seventeen characters where STR gives three, and it is the correct answer: the two values differ and a format that prints them the same is lying.

```freebasic
type NumFormat
    style        NUM_SHORTEST NUM_FIXED NUM_SCIENTIFIC NUM_GENERAL NUM_PERCENT
    digits       -1 = natural
    grouping     thousands separators
    decimalSep   default "."
    groupSep     default ","
    prefix suffix plusSign
end type

ToString( 1234567.891, f )      ' 1,234,567.89
```

NOT a format-string mini-language: FORMAT already has a picture syntax and a second incompatible one is worse than none.  LOCALE IS EXPLICIT OR ABSENT -- an implicitly locale-dependent number format is how a program writes a CSV its own importer cannot read on another machine.

======================== std/numeric: random.tiko ========================

```freebasic
dim r as Rng = RngSeeded( 12345 )
print r.NextInt( 1, 6 )                  ' inclusive both ends, UNBIASED
print r.NextDouble( )                    ' [0, 1)
```

RND and RANDOMIZE are untouched.  fbprng.bi already offers five algorithms behind 'RANDOMIZE seed, algorithm'. Three things are missing and the first is structural.

RND IS ONE GLOBAL STREAM.  Two subsystems that both want reproducible randomness cannot have it; a test cannot seed its own generator without disturbing the program's.

THERE IS NO UNBIASED INTEGER RANGE.  'int( rnd \* n )' is the usual idiom and it is biased.  Nobody notices, which is what makes it worth fixing.

THERE ARE NO DISTRIBUTIONS AND NO SHUFFLE.

xoshiro256\*\*, four 64-bit words, so an Rng lives in a UDT without a pointer. AN Rng IS A VALUE: copying it forks the stream, which is what makes a reproducible sub-simulation possible.  There is no default global Rng.

```freebasic
NextULongInt NextULong NextDouble NextDoubleRange NextSingle
NextInt( lo, hi )        INCLUSIVE both ends, matching tiko's TO
NextBoolean NextBooleanP( p )
NextNormal NextNormalP( mean, sd ) NextExponential( lambda )
NextPoisson( lambda )
Shuffle( r, a( ) )   Choice( r, a( ) )
CryptoBytes( ptr, n )  CryptoULongInt( )  RngFromEntropy( )
```

NextInt is unbiased by Lemire's multiply-and-reject: one multiply, no division in the common case.  NextDouble is \[0,1) with 53 bits of entropy; 1.0 is never returned.

Shuffle is Fisher-Yates DESCENDING with an inclusive bound -- the form that produces every permutation with equal probability.  The other forms are subtly wrong and are what a hand-rolled shuffle usually is.

CryptoBytes IS A SEPARATE SURFACE AND NOT AN Rng.  No seed, no reproducibility, no state.  One type with two contradictory contracts would invite exactly the mistake this separation prevents.  RngFromEntropy( ) is the bridge.

======================== std/numeric: stats.tiko ========================

```freebasic
Sum( a( ) )         compensated -- Neumaier
NaiveSum( a( ) )    the fast one, named so you meant it
Mean Variance VariancePopulation StdDev StdDevPopulation
Median Percentile MinOf MaxOf Range Covariance Correlation
Count
```

DOUBLE, SINGLE, LONG and LONGINT arrays, any lbound.

WHY SUMMATION IS THE INTERESTING PART: naive summation accumulates rounding error at each step, and over a million values the result can be wrong in the fourth significant digit -- invisibly, because the answer stays plausible.

```freebasic
a( 0 ) = 1e16, then 100000 ones
Sum      -> 10000000000100000     exact
NaiveSum -> 10000000000000000     off by 100000
```

Sum accumulates in DOUBLE regardless of element type: the sum of a million SINGLEs is not a single-precision quantity.

Variance is WELFORD, not 'E\[x^2\] - E\[x\]^2'.  The textbook form subtracts two large nearly-equal numbers and can return a NEGATIVE variance for data with a large mean and small spread.  The SAMPLE form (n-1) is the default, because almost every array is a sample; the population form is available under a name that says which it is.

Median and Percentile DO NOT SORT IN PLACE -- they copy.  Asking a question does not modify your data.  Percentile is the R type-7 / NumPy definition; nine definitions exist and disagree.

Mean of an empty sequence is NaN, not zero -- zero is a legitimate mean.

STREAMING

```freebasic
dim acc as RunningStats
acc.Add( x )
acc.Mean( ) acc.Variance( ) acc.StdDev( ) acc.MinValue( ) acc.MaxValue( )
acc.Merge( other )   acc.Reset( )   acc.Count( )
```

Constant space, one pass, Welford internally.  Merge combines two accumulators exactly (Chan's formula), so a fan-out across threads reduces without re-reading the data.

======================= std/numeric: vector.tiko =======================

```freebasic
dim as Vec3 a = Vec3f_( 1, 2, 3 )
print Dot( a, b ), Length( a )
dim as Mat4 mvp = proj * view * model
dim as Vec3 p = TransformPoint( mvp, v )

Vec2f Vec3f Vec4f Mat4f Quatf               ' and the ...d doubles
Vec2 Vec3 Vec4 Mat4 Quat                    ' aliases for the SINGLE forms
```

CONCRETE TYPES, because 'Vec( of T, N )' is not expressible: generics take TYPE parameters only and there is no way to bind one to the value 3.

TWO CONVENTIONS, STATED BECAUSE HALF OF ALL MATRIX BUGS ARE THESE:

COLUMN-MAJOR STORAGE, COLUMN-VECTOR CONVENTION.  'm \* v' transforms v and 'proj \* view \* model' applies model FIRST, matching OpenGL and GLSL.

TransformPoint AND TransformVector ARE SEPARATE.  A point translates; a direction does not.

```freebasic
Dot Cross Mul Length LengthSquared Distance DistanceSquared
Normalize Lerp Reflect Angle
Mat4fIdentity Translation Scaling RotationX/Y/Z Perspective Orthographic
Transpose Determinant TryInverse( m, out ) TransformPoint TransformVector
QuatfFromAxisAngle Conjugate Rotate ToMatrix Slerp
```

NO '\*' BETWEEN TWO VECTORS: it would have to mean the dot product or the component-wise product, both are wanted, and neither is obviously the default. Dot( a, b ) and Mul( a, b ) say which.

NORMALIZE OF A ZERO VECTOR RETURNS ZERO, not NaN.  That is the case that actually occurs -- a zero-length normal from a degenerate triangle -- and propagating NaN through a render loop turns one bad triangle into a blank frame.

LengthSquared is the one to use for comparisons: 'Length(a) < Length(b)' costs two square roots for a question that needs none.

SLERP TAKES THE SHORT PATH: q and -q are the same rotation, and without negating one operand it takes the long way round three-quarters of the time.

COMPLEX NUMBERS ARE NOT HERE any more -- they moved to their own file, complex.tiko, below.  They were generated from the same macro text as Vec/Mat/Quat on the grounds that they are the same kind of small operator-overloaded value type; that was true of the arithmetic and false of everything else, and a program that wants Dot should not pay for twelve inverse hyperbolic functions.

====================== std/numeric: complex.tiko ======================

```freebasic
dim as Complex z = CSet( 3, 4 )
print CAbs( z )                 ' 5
print CToString( z * z )        ' -7+24i
dim as Complex w = CExp( z )

Complex                         ' one type, 16 bytes, DOUBLE only

CSet CPolar  CZero COne CImaginaryOne CNaN CInfinity
CReal CImag CSetReal CSetImag CSwap
CIsNaN CIsInfinite CIsFinite CIsReal CIsZero
CAbs CNorm CArg CLogAbs CConj CNegate CReciprocal CSgn
CExp CLog CLog10 CSqrt CPow CNthRoot
CSin CCos CTan CSec CCsc CCot          CAsin CAcos CAtan CAsec CAcsc CAcot
CSinh CCosh CTanh CSech CCsch CCoth    CAsinh CAcosh CAtanh CAsech CAcsch CAcoth
CToString CToStringPolar

= <> + - * / ^    each in all three arrangements: Complex with Complex,
                  float64 with Complex, Complex with float64
```

EVERY FUNCTION CARRIES A 'C' PREFIX.  Exp, Log, Sqr, Sin, Cos, Tan, Abs, Atn and Str are intrinsics, and when this library was headers in namespace FB, a function of one of those names SHADOWED the intrinsic for every later header -- measured, it broke what is now random.tiko -- after which the intrinsic could not be called back.  The names stayed when the headers became std/numeric.  Given that the transcendentals must be prefixed, the prefix is applied UNIFORMLY: a mixed scheme would need the reader to know which of 'Sin' and 'Real' is an intrinsic in order to guess the spelling.  The TYPE is 'Complex', unprefixed.

'CStr' is a keyword, so AfxNova's CStr( z ) is CToString( z ) -- which also names what it is: the round-tripping form, not STR.

DOUBLE ONLY, and no macro.  Both source libraries are double-only, and with one element type the bodies are written once, plainly, and are greppable by name.

BREADTH FROM AfxNova, NUMERICS FROM .NET, both MIT.  AfxComplex.inc supplies the sec/csc/cot families, all twelve inverses, the hyperbolics, CNthRoot and CLogAbs.  System.Numerics.Complex supplies Smith division, the scaled Abs, Asin_Internal, the stabilised Tan and the predicate set.  NEITHER IS FOLLOWED WHERE IT IS BEATEN.

TWO THINGS THE OLD VECTOR HEADER USED TO GET WRONG, and both are fixed:

'/' WAS THE NAIVE ( ac + bd ) / ( c^2 + d^2 ).  Its denominator overflows once |d| passes about 1.3e154, so ( 1e200 + 1e200i ) / ( 1e200 + 1e200i ) came back NaN instead of 1.  Smith's formula divides through by the larger component first and has no range restriction.  All THREE division overloads get it; AfxNova leaves its two mixed ones naive.

CSqrt WAS THE POLAR FORM, FromPolar( sqr(|z|), Arg(z)/2 ).  That is .NET Framework 4.7's, which .NET Core 3.0 replaced because it loses most of its significant digits near the negative real axis, where Arg is the difference of two nearly-equal quantities.  AfxNova ships the same superseded code, so the replacement here beats BOTH sources.

NINE AXIS FAST PATHS, EACH PUT THERE BY A MEASURED FAILURE.  A differential run against Python's cmath -- that is, against C99 -- over 3,030 (function, operand) pairs found eight defects, seven of them inherited and one in the platform:

- CSqrt( -4 - 0i ) returned +2i.  Both sources test 'imaginary == 0' and hand back the positive root for both sides of their own cut.
- CAsin and CAcos are NaN at exactly +-1: Asin_Internal divides by zero there, so .NET's own Asin( 1 ) is NaN rather than PI/2.
- .NET tests 'imaginary < 0' where it has to test the SIGN BIT.  A negative zero is not less than zero, so .NET's Asin( 2 - 0i ) has a POSITIVE imaginary part where C99 gives a negative one.
- CAtanh beyond +-1 cannot be reached through CAtan: forming '1 + iz' adds +0.0 to -0.0, IEEE gives +0.0, and the bit that decides the side of the cut is gone before the logarithm sees it.
- CAtan of a small pure imaginary cancels: atan( 1e-8 i ) came out 9.999999994736e-9 for an answer that is 1e-8.
- mingw-w64's asinh( +0.0 ) returns -0.0.  asinh is odd and owes the sign back; that one is the platform's, not .NET's.

After the nine, 3,030 of 3,030 comparisons agree, signed zeros included, except 22 CReciprocal results that differ only in the sign of an exactly-zero component -- C99 Annex G does not specify those and the magnitudes are equal.

NO ORDERING OPERATORS: '<' on complex numbers has no meaning.  AfxNova's CSgn returned a LONG by comparing real parts and then imaginary ones, which is such an ordering under another name; CSgn here returns z/|z|, the unit vector in z's direction, and CZero( ) for zero.  Porting code gets a compile error rather than a silently different number.

THE SPECIAL VALUES ARE FUNCTIONS, not constants: 'const as Complex N' cannot be initialised from 0.0/0.0, which is a compile-time division by zero.  Same decision, same reason, as NaN( ) in math.tiko.

CIsNaN IS NOT 'either part is NaN'.  One infinite part and one NaN is INFINITE, because the infinity already answers every question anyone asks of the number.

TWO THINGS DELIBERATELY NOT DONE, stated rather than left to be discovered:

- NO INFINITY RECOVERY ON '\*'.  C99's __muldc3 rescues ( inf + 0i ) \* ( 2 + 0i ) from NaN with a branch on every multiply; .NET does not, and neither does this.  Pinned by a test so that adding it later is a deliberate act.
- CPow( 0, w ) IS 0 FOR EVERY w, and CPow( 0, 0 ) is 1.  Those are .NET's answers and the last two are wrong -- 0 to a negative power is infinite.  Kept for source compatibility with both sources, and pinned.

The vendored test suites have no suite for this header, so there is no tiko result to report for it.

========================= std/numeric: fenv.tiko =========================

```freebasic
scope
    dim r as ScopedRounding = ScopedRounding( ROUND_TOWARD_NEGATIVE )
    ' ... directed-rounding computation ...
end scope                          ' restored on EVERY exit path

GetRoundingMode( )  SetRoundingMode( m )
ROUND_TO_NEAREST ROUND_TOWARD_NEGATIVE ROUND_TOWARD_POSITIVE ROUND_TOWARD_ZERO

ClearFpExceptions( )  ClearFpException( e )
TestFpException( e )  RaiseFpException( e )
FP_INVALID FP_DIVBYZERO FP_OVERFLOW FP_UNDERFLOW FP_INEXACT FP_ALL_EXCEPT
```

ScopedRounding is a CONSTRUCTOR, not a factory: a factory returning by value builds a temporary, copies it, and then DESTROYS the temporary -- restoring the mode before the guarded region runs.

THE HAZARD, STATED RATHER THAN HIDDEN.  The optimiser may move floating-point operations across a call, and moving one across a rounding-mode change silently produces the wrong answer.  C solves this with '#pragma STDC FENV_ACCESS'.

The rounding mode is per-thread on every supported platform.

The constants above are THE LIBRARY'S OWN, and are deliberately not the C library's. The C FE\_\* values are not a property of the platform: MSVC, and mingw-w64 since v8, define them in terms of the CRT's abstract \_RC\_\* / \_SW\_\* codes, while glibc, the BSDs, djgpp and mingw-w64 v7 use the x87 control- and status-word encoding directly.  Which family applies is decided by the C runtime the program finally links against -- mingw-w64 changed sides between v7 and v8 without the target changing -- and the compiler cannot know that at compile time, so no '#ifdef' on target can be right.  fenv.tiko therefore DETECTS the family at startup, by offering the CRT the x87 spelling of FE_DOWNWARD and seeing whether it is accepted, and translates.  Getting this wrong is silent, not loud: the two families overlap numerically without agreeing, so x87 FP_DIVBYZERO (&h04) reads as FP_OVERFLOW to a \_SW\_\* CRT and fetestexcept cheerfully answers about the wrong flag.

## EXACT vs BOUNDED -- what is reproducible

Two classes with two different guarantees, and the difference matters if you ship the same program for more than one target.

EXACT     Identical results everywhere.  All integer arithmetic, all of

```freebasic
money.Currency, all of money.Decimal, rounding, classification,
Min/Max/Clamp/Sign, the bit family, RNG streams, and vector/matrix
arithmetic.
```

BOUNDED   Accurate to a stated ulp bound; the PLATFORM libm is the

```freebasic
dependency.  Every transcendental, Sqr, Hypot, Slerp, everything
in Complex beyond the four operators, StdDev's final root, and
decimal->binary parsing.
```

The second class cannot be the first without shipping correctly-rounded implementations of every transcendental -- a multi-year project that no mainstream language ships by default.  glibc, MSVCRT and mingw-w64 do not agree to the last bit and are not required to.

So a financial total is reproducible across your builds and a Sin is not, and this library says which is which instead of implying both.

## Known Limits

All measured.

- FOUR DECIMAL PLACES on Currency, fixed.  The central limitation of the
  eight-byte money type, and the reason `Decimal` exists beside it -- see
  [Finance](Category-Finance).

- Accuracy of the libm surface is the platform's; results are NOT identical

```freebasic
across targets.  Rounding, classification and all integer/Currency work
ARE.
```

- Round( x, digits ) decides the tie on the SCALED value, so

```freebasic
Round( 2.675, 2 ) is 2.68 where an exact decimal round gives 2.67.
```

- Shortest-round-trip formatting is a LOOP (format, parse back, retry at

```freebasic
higher precision), not Ryu.  Same result, up to 17 snprintf/strtod pairs
per call.
```

- Decimal->binary conversion on parse is strtod's.  The VALIDATION is this

```freebasic
library's and is strict; the last bit is the platform's.
```

- Statistics take plain arrays, not the iterator protocol.

- Checked arithmetic is opt-in per call site.  It does not catch what you

```freebasic
did not audit.
```

- LONG DOUBLE is not covered; crt/longdouble.bi declares the 'l' variants as

```freebasic
DOUBLE on this target.
```

- Nothing folds at compile time: Round( 2.5 ) on a literal is a run-time

```freebasic
call, because constant folding covers operators, not user functions.
```

- Every routine has MODULE-PRIVATE linkage, so each module including a

```freebasic
header gets its own copy.  Costs size, not correctness -- the same trade
generic instantiations already make in this tree.
```

## Tests

tests/vendor/fbc-tests/math/ -- fbcunit suites for these headers, vendored in tiko-lang.

core.bas      constants, classification (EXHAUSTIVE over all 2^32 SINGLE bit

```freebasic
patterns, plus the population of each class as a checkable
property of IEEE 754), selection, rounding at every tie, the
two bugs in int(x+0.5) pinned, the libm identities
```

integer.bas   all three modulo conventions over every sign combination,

```freebasic
DivMod, IPow against an independent reference with 3^38 and
7^22 pinned, ISqrt by its defining property, checked
arithmetic at BOTH boundaries of EVERY integer type
```

bits.bas      EXHAUSTIVE over the whole USHORT and UBYTE domains against

```freebasic
naive bit-at-a-time references, the zero and full-width cases,
rotation round trips
```

currency.bas  round-trip over the corpus, strict parse rejects, a+b-b = a

```freebasic
bitwise, division ties, Invalid propagation through every
operator, Apportion summing exactly to the total, the
accumulate-vs-round-each-line case
```

text.bas      the four defects demonstrated against VAL and STR, strict

```freebasic
parse table, round-trip over a large stratified SINGLE sample
and a curated DOUBLE set, shortest-form checks, integer
overflow detection, NumFormat
```

random.bas    identical streams from identical seeds, chi-squared

```freebasic
uniformity, unbiased range, NextDouble never 1.0,
distributions against analytic mean and variance, and ALL 24
permutations of 4 elements observed with equal frequency
```

stats.bas     compensation demonstrated by asserting NaiveSum FAILS the same

```freebasic
test, Welford beating the textbook formula on data chosen to
make it return a negative variance, non-mutation, Merge
```

vector.bas    identities only -- |normalize(v)|=1, cross orthogonal,

```freebasic
M*M-inverse=I, Det(AB)=Det(A)Det(B), q*conj(q)=1, slerp
endpoints, exp(log(z))=z
```

fenv.bas      each mode observably changes a result, ScopedRounding restores

```freebasic
on fallthrough / EXIT / RETURN / nested scopes, each exception
flag raised by what must raise it
```

Precision note, and it decides five assertions across two suites: code evaluated on the x87 with the precision control at 64-bit mantissa keeps an intermediate that is never stored in 80 bits.  C99 permits this (FLT_EVAL_METHOD = 2).

This bites the tests that demonstrate a DEFECT rather than a result.  Each is the counter-example half of a pair -- the naive form getting it wrong, beside the library getting it right -- and each was written assuming the intermediate had been rounded to double.  In 80 bits the naive form quietly gets the RIGHT answer and stops demonstrating anything:

int( justunder + 0.5 )       unstored 0,          stored 1 sqr( big\*big + big\*big )     unstored 1.41e200,   stored inf log( 1.0 + 1e-17 )           unstored 1e-17,      stored 0 (3LL ^ 38LL) as longint      unstored ...089,     stored ...000

so rounding_beats_the_idiom\_ and libm_surface\_ in core.bas, and ipow_exact\_ in integer.bas, store the intermediate first.  The store is load-bearing and is asserted in its own right, so a future compiler that keeps 80 bits fails at the cause rather than confusingly downstream.

NOT VERIFIED, stated rather than implied:

- No differential test against OleAut32 VarCy\* or .NET decimal was run for

```freebasic
Currency; it is owed.
```

## API reference

One page per entry, 197 in all:

[AbsChecked](Modern-Math-AbsChecked) · [AbsSaturating](Modern-Math-AbsSaturating) · [Add](Modern-Math-Add) · [AddChecked](Modern-Math-AddChecked) · [AddSaturating](Modern-Math-AddSaturating) · [AddWrapping](Modern-Math-AddWrapping) · [Angle](Modern-Math-Angle) · [BitReverse](Modern-Math-BitReverse) · [BitWidth](Modern-Math-BitWidth) · [ByteSwap](Modern-Math-ByteSwap) · [CAbs](Modern-Math-CAbs) · [CAcos](Modern-Math-CAcos) · [CAcosh](Modern-Math-CAcosh) · [CAcot](Modern-Math-CAcot) · [CAcoth](Modern-Math-CAcoth) · [CAcsc](Modern-Math-CAcsc) · [CAcsch](Modern-Math-CAcsch) · [CArg](Modern-Math-CArg) · [CAsec](Modern-Math-CAsec) · [CAsech](Modern-Math-CAsech) · [CAsin](Modern-Math-CAsin) · [CAsinh](Modern-Math-CAsinh) · [CAtan](Modern-Math-CAtan) · [CAtanh](Modern-Math-CAtanh) · [CConj](Modern-Math-CConj) · [CCos](Modern-Math-CCos) · [CCosh](Modern-Math-CCosh) · [CCot](Modern-Math-CCot) · [CCoth](Modern-Math-CCoth) · [CCsc](Modern-Math-CCsc) · [CCsch](Modern-Math-CCsch) · [Ceil](Modern-Math-Ceil) · [CExp](Modern-Math-CExp) · [Choice](Modern-Math-Choice) · [CImag](Modern-Math-CImag) · [CImaginaryOne](Modern-Math-CImaginaryOne) · [CInfinity](Modern-Math-CInfinity) · [CIsFinite](Modern-Math-CIsFinite) · [CIsInfinite](Modern-Math-CIsInfinite) · [CIsNaN](Modern-Math-CIsNaN) · [CIsReal](Modern-Math-CIsReal) · [CIsZero](Modern-Math-CIsZero) · [Clamp](Modern-Math-Clamp) · [Classify](Modern-Math-Classify) · [ClearFpException](Modern-Math-ClearFpException) · [ClearFpExceptions](Modern-Math-ClearFpExceptions) · [CLog](Modern-Math-CLog) · [CLog10](Modern-Math-CLog10) · [CLogAbs](Modern-Math-CLogAbs) · [CNaN](Modern-Math-CNaN) · [CNegate](Modern-Math-CNegate) · [CNorm](Modern-Math-CNorm) · [CNthRoot](Modern-Math-CNthRoot) · [Complex](Modern-Math-Complex) · [Complex operators](Modern-Math-Complex-Operators) · [COne](Modern-Math-COne) · [Conjugate](Modern-Math-Conjugate) · [Correlation](Modern-Math-Correlation) · [Count](Modern-Math-Count) · [Covariance](Modern-Math-Covariance) · [CPolar](Modern-Math-CPolar) · [CPow](Modern-Math-CPow) · [CReal](Modern-Math-CReal) · [CReciprocal](Modern-Math-CReciprocal) · [Cross](Modern-Math-Cross) · [CryptoBytes](Modern-Math-CryptoBytes) · [CryptoULongInt](Modern-Math-CryptoULongInt) · [CSec](Modern-Math-CSec) · [CSech](Modern-Math-CSech) · [CSet](Modern-Math-CSet) · [CSetImag](Modern-Math-CSetImag) · [CSetReal](Modern-Math-CSetReal) · [CSgn](Modern-Math-CSgn) · [CSin](Modern-Math-CSin) · [CSinh](Modern-Math-CSinh) · [CSqrt](Modern-Math-CSqrt) · [CSwap](Modern-Math-CSwap) · [CTan](Modern-Math-CTan) · [CTanh](Modern-Math-CTanh) · [CToString](Modern-Math-CToString) · [CToStringPolar](Modern-Math-CToStringPolar) · [CurrentLocaleFormat](Modern-Math-CurrentLocaleFormat) · [CZero](Modern-Math-CZero) · [DegToRad](Modern-Math-DegToRad) · [Determinant](Modern-Math-Determinant) · [Distance](Modern-Math-Distance) · [DistanceSquared](Modern-Math-DistanceSquared) · [DivChecked](Modern-Math-DivChecked) · [DivMod](Modern-Math-DivMod) · [Dot](Modern-Math-Dot) · [EuclidDiv](Modern-Math-EuclidDiv) · [EuclidMod](Modern-Math-EuclidMod) · [Floor](Modern-Math-Floor) · [FloorDiv](Modern-Math-FloorDiv) · [FloorMod](Modern-Math-FloorMod) · [Fma](Modern-Math-Fma) · [Frexp](Modern-Math-Frexp) · [GCD](Modern-Math-GCD) · [GetRoundingMode](Modern-Math-GetRoundingMode) · [Hypot](Modern-Math-Hypot) · [Infinity](Modern-Math-Infinity) · [InfinityF](Modern-Math-InfinityF) · [IPow](Modern-Math-IPow) · [IPowChecked](Modern-Math-IPowChecked) · [IsFinite](Modern-Math-IsFinite) · [IsInfinite](Modern-Math-IsInfinite) · [IsNaN](Modern-Math-IsNaN) · [IsNegative](Modern-Math-IsNegative) · [IsNormal](Modern-Math-IsNormal) · [IsPow2](Modern-Math-IsPow2) · [ISqrt](Modern-Math-ISqrt) · [IsSubnormal](Modern-Math-IsSubnormal) · [LCM](Modern-Math-LCM) · [LeadingZeros](Modern-Math-LeadingZeros) · [Length](Modern-Math-Length) · [LengthSquared](Modern-Math-LengthSquared) · [Lerp](Modern-Math-Lerp) · [Max](Modern-Math-Max) · [MaxOf](Modern-Math-MaxOf) · [MaxValue](Modern-Math-MaxValue) · [Mean](Modern-Math-Mean) · [Median](Modern-Math-Median) · [Merge](Modern-Math-Merge) · [Min](Modern-Math-Min) · [MinOf](Modern-Math-MinOf) · [MinSubnormalDouble](Modern-Math-MinSubnormalDouble) · [MinSubnormalSingle](Modern-Math-MinSubnormalSingle) · [MinValue](Modern-Math-MinValue) · [Modf](Modern-Math-Modf) · [Mul](Modern-Math-Mul) · [MulChecked](Modern-Math-MulChecked) · [MulSaturating](Modern-Math-MulSaturating) · [MulWrapping](Modern-Math-MulWrapping) · [NaiveSum](Modern-Math-NaiveSum) · [NaN](Modern-Math-NaN) · [NaNF](Modern-Math-NaNF) · [NegChecked](Modern-Math-NegChecked) · [NegInfinity](Modern-Math-NegInfinity) · [NegInfinityF](Modern-Math-NegInfinityF) · [NegSaturating](Modern-Math-NegSaturating) · [NegWrapping](Modern-Math-NegWrapping) · [NextBoolean](Modern-Math-NextBoolean) · [NextBooleanP](Modern-Math-NextBooleanP) · [NextDouble](Modern-Math-NextDouble) · [NextDoubleRange](Modern-Math-NextDoubleRange) · [NextExponential](Modern-Math-NextExponential) · [NextInt](Modern-Math-NextInt) · [NextNormal](Modern-Math-NextNormal) · [NextNormalP](Modern-Math-NextNormalP) · [NextPoisson](Modern-Math-NextPoisson) · [NextPow2](Modern-Math-NextPow2) · [NextSingle](Modern-Math-NextSingle) · [NextULong](Modern-Math-NextULong) · [NextULongInt](Modern-Math-NextULongInt) · [Normalize](Modern-Math-Normalize) · [Parity](Modern-Math-Parity) · [Percentile](Modern-Math-Percentile) · [PopCount](Modern-Math-PopCount) · [RadToDeg](Modern-Math-RadToDeg) · [RaiseFpException](Modern-Math-RaiseFpException) · [Range](Modern-Math-Range) · [Reflect](Modern-Math-Reflect) · [Reset](Modern-Math-Reset) · [RngFromEntropy](Modern-Math-RngFromEntropy) · [RngSeeded](Modern-Math-RngSeeded) · [Rotate](Modern-Math-Rotate) · [Round](Modern-Math-Round) · [RoundHalfEven](Modern-Math-RoundHalfEven) · [ScaleB](Modern-Math-ScaleB) · [SetRoundingMode](Modern-Math-SetRoundingMode) · [Shuffle](Modern-Math-Shuffle) · [Sign](Modern-Math-Sign) · [Slerp](Modern-Math-Slerp) · [StdDev](Modern-Math-StdDev) · [StdDevPopulation](Modern-Math-StdDevPopulation) · [SubChecked](Modern-Math-SubChecked) · [SubSaturating](Modern-Math-SubSaturating) · [SubWrapping](Modern-Math-SubWrapping) · [Sum](Modern-Math-Sum) · [TestFpException](Modern-Math-TestFpException) · [ToMatrix](Modern-Math-ToMatrix) · [ToString](Modern-Math-ToString) · [TrailingZeros](Modern-Math-TrailingZeros) · [TransformPoint](Modern-Math-TransformPoint) · [TransformVector](Modern-Math-TransformVector) · [Transpose](Modern-Math-Transpose) · [Truncate](Modern-Math-Truncate) · [TryInverse](Modern-Math-TryInverse) · [TryParseDouble](Modern-Math-TryParseDouble) · [TryParseLong](Modern-Math-TryParseLong) · [TryParseLongInt](Modern-Math-TryParseLongInt) · [TryParseSingle](Modern-Math-TryParseSingle) · [TryParseULong](Modern-Math-TryParseULong) · [TryParseULongInt](Modern-Math-TryParseULongInt) · [Ulp](Modern-Math-Ulp) · [Variance](Modern-Math-Variance) · [VariancePopulation](Modern-Math-VariancePopulation)

---



---

[Home](Home) · [Keyword Index](Keyword-Index)
