[Home](Home) › [Tutorials](Category-Tutorials) › **Passing Arguments to Procedures**

# Passing Arguments to Procedures

Passing information to procedures.

Declaring parameters

Procedures can get passed information in the form of variables and objects when they are called. In the context of a procedure call, these variables and objects are called arguments. These arguments are then represented as so-called parameters inside the procedure body. Parameters can be used just like any other variable or object.

 To specify that a procedure should get passed arguments when called, declare the procedure with a parameter list. A parameter list is a list of one or more names and types that the procedure will use when referring to the arguments that are passed to it. Parameter lists are surrounded by parenthesis.

```freebasic
Sub Procedure (s As String, n As Integer)

    Print "The parameters have the values: " & s & " and " & n

End Sub

Procedure "abc", 123
```

 will produce the following output:

```freebasic
The parameters have the values: abc and 123
```

There are two ways to pass arguments to procedures: by value and by reference. By default, arguments are passed by value unless otherwise specified.

Passing arguments by value

Arguments that are passed by value are not actually passed to procedures; a copy of the argument is made and passed instead. This allows the procedure to modify the copy, and the original variable or object remains unchanged.

 When passing objects to procedures by value, the copy is made by calling the copy constructor of the [`Type`](Type-Udt) or [`Class`](Class).

 To specify that an argument should be passed by value, precede the parameter name in the procedure declaration with the [`ByVal`](Byval) keyword:

```freebasic
Sub Procedure (ByVal param As Integer)

    param *= 2

    Print "The parameter 'param' = " & param

End Sub

Dim arg As Integer = 10

Print "The variable 'arg' before the call = " & arg

Procedure(arg)

Print "The variable 'arg' after the call = " & arg
```

 will produce the following output:

```freebasic
The variable 'arg' before the call = 10
The parameter 'param' = 20
The variable 'arg' after the call = 10
```

Notice how parenthesis surround the arguments - in this case only one, `arg` - in the procedure call. These parenthesis are optional, but are a common convention to signify a procedure call.

Passing arguments by reference

Unlike arguments that are passed by value, arguments that are passed to procedures by reference really do get passed; no copy is made. This allows the procedure to modify the original variable or object that was passed to it.

 A reference is like an alias for a variable or object. Whenever you refer to a reference, you're referring to the actual variable or object that it aliases. In other words, you can think of a reference parameter of a procedure as the argument that is passed to it; any changes made to the reference parameter are actually changes to the argument it represents.

 To specify that an argument should be passed by reference, precede the parameter name in the procedure declaration with the [`ByRef`](Byref-Parameters) keyword:

```freebasic
Sub Procedure (ByRef param As Integer)

    param *= 2

    Print "The parameter 'param' = " & param

End Sub

Dim arg As Integer = 10

Print "The variable 'arg' before the call = " & arg

Procedure(arg)

Print "The variable 'arg' after the call = " & arg
```

 will produce the following output:

```freebasic
The variable 'arg' before the call = 10
The parameter 'param' = 20
The variable 'arg' after the call = 20
```

Manually passing pointers to by-reference parameters

By specifying the `Byval` keyword in front of an argument to a [`ByRef`](Byref-Parameters) parameter, an address (usually stored in a pointer) can be passed directly as-is, forcing the `Byref` parameter to reference the same memory location which the address pointed to.

```freebasic
Sub f( ByRef i As Integer )

    i = 456

End Sub

Dim i As Integer = 123

Dim pi As Integer Ptr = @i

Print i

f( ByVal pi )

Print i
```

See also

- [Procedures Overview](Procedures-Overview)
- [Returning Values](Returning-Values)
- [`Declare`](Declare)
- [`Sub`](Sub)
- [`Function`](procedures-Function)
- [`ByVal`](Byval)
- [`ByRef`](Byref-Parameters)
- [`... (Ellipsis)`](Ellipsis)

---

**Category:** [Tutorials](Category-Tutorials)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
