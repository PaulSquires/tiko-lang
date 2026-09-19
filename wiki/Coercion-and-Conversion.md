[Home](Home) › [Tutorials](Category-Tutorials) › **Coercion and Conversion**

# Coercion and Conversion

Transfer the data of a given type variable to a variable of another type requires conversion.

Coercion of Numeric Data Types in Expressions and Arguments

For the integer types, the rule depends on the following ranking:

in 32bit:

byte < ubyte < short < ushort < long < integer < ulong < uinteger < longint < ulongint

in 64bit:

byte < ubyte < short < ushort < long < ulong < longint < integer < ulongint < uinteger

First, in accordance to the above ranking, all arguments smaller than Integer are converted to Integer.  
 Then, if arguments have different size, the smaller argument is converted to match the bigger one. Next, if arguments have different signedness, the signed argument is converted to unsigned to match the other one.  
 Finally, the (U)Integer types replace:

in 32bit:

the (U)Long types

in 64bit:

the (U)Longint types

On the other hand, if one of the arguments is a Single or a Double, both arguments are converted and/or promoted to Double.

Conversion of Numeric Data Types

A type conversion will occur implicitly when an expression or variable is assigned, passed as a parameter to a procedure, or returned as a result from a procedure. Conversions may also be explicit when using CAST or one of the built-in conversion functions (among standard functions).

 *Integer To Integer, any combination of Signed and Unsigned*

*Integer to Single or Double*

*Double to Single*

*Double or Single to Integer*

Conversions using User Data Type constructors and operators

For conversion between built-in types (among standard types like between numeric types as above or between string types), the compiler knows what to do without the need for instructions from user.  
 This is called the implicit internal conversion (or coercion).

 When one of the two types is at least a UDT (User Defined Type), the user has to code some UDT procedures to define how do the conversion.  
 Then, the conversion execution can be explicit if the user specifies what UDT procedure must be used, or implicit if the user leaves the choice to compiler.

 In the world of UDTs, conversions can be controlled by means of three member procedures:

For a construction with implicit initialization ('Dim As UDT u = v'), the compiler searches by priority:

(a matched let operator (for u type from v type) is not searched by compiler on a construction with implicit initialization)

For an implicit copy-construction ('Byval As u_type') when passing a v type parameter, the compiler searches by priority:

(a matched let operator (for u type from v type) is not searched by compiler on a construction with implicit initialization)

For an implicit reference-passing ('Byref As u_type') when passing a v type parameter, the compiler searches by priority:

(a matched let operator (for u type from v type) is not searched by compiler on an implicit reference-passing)

For an implicit assignment ('u = v'), or an implicit return from function by assigning ('Function = v') with function returning u type, the compiler searches by priority:

For an implicit return from function by exiting immediately ('Return v') with function returning u type, the compiler searches by priority:

If an explicit copy-constructor (u type) exists:

Else (an explicit copy-constructor (u type) does not exist):

special type (\*) : pointer or string, or UDT if there is no explicit copy-constructor / explicit copy-assignment operator for u type

 **Note:**
 Only the member procedures directly impacted in the conversion process itself are cited above:
 **-** the copy-constructor (u type) and the copy-let operator (u type) are not cited when only their implicit definition is sufficient and not their explicit definition,
 **-** the default constructor (u type) is not cited whereas an implicit version, otherwise explicit version if another explicit constructor (u type) is defined, is always required in the 'Function = v' case, but not for the conversion process itself.

Example

Very simple syntaxic example highlighting the conversion capabilities by using Cast operator (explicit and implicit), Constructor (explicit and implicit) and Let operator (implicit):

```freebasic
Type UDT

  Dim As Integer I

  Declare Operator Cast () As Integer

  Declare Constructor (ByVal I0 As Integer)

  Declare Operator Let (ByVal I0 As Integer)

End Type

Operator UDT.Cast () As Integer

  Return This.I

End Operator

Constructor UDT (ByVal I0 As Integer)

  This.I = I0

End Constructor

Operator UDT.Let (ByVal I0 As Integer)

  This.I = I0

End Operator

Dim As Integer J = 12

Dim As UDT u1 = UDT(J)  '' construction with explicit initialization using the defined "Constructor(Byval As Integer)" operator

Print u1.I

Dim As UDT u2 = J       '' construction with implicit initialization by compiler using the defined "Constructor(Byval As Integer)" operator

Print u2.I

Print

u1.I = 34

J = Cast(Integer, u1)  '' explicit assignment using the defined "Cast() As Integer" operator

Print J

Dim As Integer K

K = u1                 '' implicit assignment by compiler using the defined "Cast() As Integer" operator

Print K

Print

J = 56

u1 = J                 '' implicit assignment by compiler using the defined "Let(Byval As Integer)" operator

Print u1.I

Print

Sleep
```

See also

- [Standard Data Types](Standard-Data-Types)
- [Variable Types](Standard-Data-Type-Limits)
- [Casting and Conversion Functions](Converting-Data-Types)
- [User Defined Types](user-defined-types-User-Defined-Types)

---

**Category:** [Tutorials](Category-Tutorials)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
