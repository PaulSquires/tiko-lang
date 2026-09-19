[Home](Home) › [User Defined Types](Category-User-Defined-Types) › **Base (Initializer)**

# Base (Initializer)

Specifies an initializer for the base UDT in derived Udt constructors

## Syntax

```freebasic
Base ( constructor-parameters... )
or:
Base ( UDT-initializers... )
```

## Description

The `Base` initializer can be used at the top of constructors of derived UDTs. It allows to specify an explicit constructor call or UDT initializers to be used to initialize the base object. It will replace the implicit default initialization, and must appear above any other statements in the constructor it is used in.

 Note: Unlike "`Base( )`", a "`Base (Member Access).Constructor( )`" statement does not replace the implicit default initialization done by the constructor of a derived UDT, and can usually not be used legally, because it would result in two constructor calls for the base object (for an inheritance structure extending the built-in [`Object`](Object) type, this second base constructor call may also corrupt the vtable pointer to point to the base-type vtable instead of to the type vtable).

## Remarks

### Dialect Differences

- Methods are only supported in the *[-lang fb](Compiler-Option-Lang)* dialect, hence `Base` has no function in other dialects.

### Differences from QB

- New to FreeBASIC

### See also

- [`Base (Member Access)`](Base-Member-Access)
- [`This`](This)
- [`Type`](Type-Udt)
- [`Extends`](Extends)
- [`Extends Zstring`](Extends-Zstring)
- [`Extends Wstring`](Extends-Wstring)
- [`Option Base`](Option-Base)

## Examples

```freebasic
Type SimpleParent

    As Integer a, b, c

End Type

Type Child Extends SimpleParent

    Declare Constructor( )

End Type

Constructor Child( )

    '' Simple UDT initializer

    Base( 1, 2, 3 )

End Constructor
```

```freebasic
Type ComplexParent

    As Integer i

    Declare Constructor( ByVal As Integer = 0 )

End Type

Constructor ComplexParent( ByVal i As Integer = 0 )

    this.i = i

End Constructor

Type Child Extends ComplexParent

    Declare Constructor( )

    Declare Constructor( ByRef As Child )

End Type

Constructor Child( )

    '' Base UDT constructor call

    Base( 1 )

End Constructor

Constructor Child( ByRef rhs As Child )

    '' Base UDT constructor call

    Base( rhs.i )

End Constructor
```

---

**Category:** [User Defined Types](Category-User-Defined-Types)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
