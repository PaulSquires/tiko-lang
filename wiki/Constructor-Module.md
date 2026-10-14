[Home](Home) › [Procedures](Category-Procedures) › **Constructor (Module)**

# Constructor (Module)

Specifies execution of a procedure before module-level code

## Syntax

```freebasic
[Public | Private] Sub procedure_name [Alias "external_identifier"] [()] Constructor [priority]
{ procedure body }
End Sub
```

## Description

The `Constructor` keyword is used in [`Sub`](Sub) definitions (forbidden at declaration line level) to force execution of the procedure prior to that of module-level code. Procedures defined as constructors may be used the same way as ordinary procedures, that is, they may be called from within module-level code, as well as other procedures.

 The procedure must have an empty parameter list. A compile-time error will be generated if the `Constructor` keyword is used in a Sub definition having one or more parameters. In a set of overloaded procedures, only one (1) constructor may be defined because of the ambiguity of having multiple Subs which take no arguments.

 In a single module, depending on the build and run-time environment of the target system:

The `priority` attribute, an integer between 101 and 65535, can be used to force constructors to be executed in a certain order, relative to other constructors also having `priority` attribute. The value of `priority` has no specific meaning, only the relationship of the number with other constructor priorities. 101 is the highest priority and is executed first, relative to other constructors also having `priority` attribute.

 A module may define multiple constructor procedures, and multiple modules may define additional constructors provided no two [`Public`](Public) constructors share the same *procedure_name*.

 When linking with modules that also define constructors, the order of execution is not guaranteed at link-time unless the `priority` attribute is used. Therefore, special care should be taken when using constructors that may call on a secondary module also defining a constructor. In such a case it is advisable to use a single constructor that explicitly calls initialization procedures in those modules.

 Public static member procedures (a [`Sub`](Sub-Member) having an empty parameter list), of user defined [`Type`](Type-Udt) can be defined as a module constructor, by adding the `Constructor` keyword used in the sub procedure definition.

 Initialization of static simple numeric type variables, that have a value that can be determined at compile time (for example, default zero, constants, pointers to static objects, pointers to functions, etc), are initialized before any code is executed. These values are part of the executable image and have an initial value when the executable is loaded in to memory. Trivial static globals where no code is needed to initialize, are guaranteed to be initialized and can be reliably used in all code, including global static object constructors and module constructors.

 The module constructor feature exposes a low-level link-time feature of the build and run-time environment. Accessing global static objects having constructors from module constructors should be avoided due to variations in execution order on different build systems.

 **Warning for 64-bit compiler only:** See the Identifier Rules page for the choice of user procedure identifier names (and specially the 'Platform Differences' paragraph).

## Remarks

### Differences from QB

- New to FreeBASIC

### See also

- [Constructor (Class)](Constructor)
- [Destructor (Module)](Destructor-Module)
- [Sub](Sub)

## Examples

```freebasic
'' ConDesExample.bas : An example program that defines two sets of

'' constructors and destructors. Demonstrates when and in what order

'' they are called when linking a single module.

Sub Constructor1() Constructor

    Print "Constructor1() called"

End Sub

Sub Destructor1() Destructor

    Print "Destructor1() called"

End Sub

Sub Constructor2() Constructor

    Print "Constructor2() called"

End Sub

Sub Destructor2() Destructor

    Print "Destructor2() called"

End Sub

    '' ----------------------

    Print "module-level code"

    End 0

    '' ----------------------
```

 **Output:**

```freebasic
Constructor2() called
Constructor1() called
module-level code
Destructor1() called
Destructor2() called
```

---

**Category:** [Procedures](Category-Procedures)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
