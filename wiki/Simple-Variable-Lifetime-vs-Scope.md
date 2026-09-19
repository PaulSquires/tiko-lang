[Home](Home) › [Tutorials](Category-Tutorials) › **Simple Variable Lifetime vs Scope**

# Simple Variable Lifetime vs Scope

**Lifetime** of **Simple Variable**, created from declaration keyword for static memory allocation, relative to its **Scopes**.

 **Preamble:**

- The Lifetime of a variable is the time period in which the variable has valid memory (the Scope referring to the program part where its name is visible). The value of a variable may change during its lifetime, but it retains some consistent value.
  The simple variables considered are the predefined variables including the raw pointers, and the fixed-length strings/arrays, but excluding the variable-length strings/arrays. Instances of simple UDT (without any dynamic data allocated) are also considered.  
  The declaration keywords for static memory allocation are: 'Dim', 'Static', 'Var'.

For such variables allocated in static way as defined above, the lifetime generally matches the surrounding scope, otherwise it can be greater than this one.

Declaration syntax for a lifetime matching the surrounding scope

For such variables declared anywhere, as follows (or similar syntax):

`(1)	Dim Shared As datatype [Ptr] variablename ...`

`or`

`(2)	Var Shared variablename = expression`

`(equivalent to: 'Dim Shared As TypeOf((expression)) = expression')`

or

`(3)	{Dim|Static} Shared As datatype [Ptr] variablename ...`

`or`

`(4)	[Static] Var Shared variablename = expression`

`(equivalent to: '{Dim|Static} Shared As TypeOf((expression)) = expression')`

`or`

`(5)	Common [Shared] As datatype [Ptr] variablename`

they always have a lifetime matching their surrounding scope (global scope, or scope block, or compound statement block, or procedure scope).

 With `(1)` or `(2)` syntax, the local variable is always allocated on the program stack at the time of its declarations, and is automatically deallocated when going out its scope.  
 With `(3)` or `(4)` or `(5)` syntax, the global variable is always allocated in the .BSS or .DATA section of the executable (its scopes and lifetimes begins at program creation and ends with program termination).

Declaration syntax for a lifetime that may be greater than the surrounding scope

For such variables declared anywhere, as follows (or similar syntax):

`Static Shared As datatype [Ptr] variablename ...`  
 `Static Var Shared variablename = expression`

they always have a lifetime equal to the program duration, so greater than their surrounding scope if there are declared in any local scope block (matching their surrounding scope if there are declared in the global scope).

 The static variable is always allocated in the .BSS or .DATA section of the executable (its lifetimes begins at program creation and ends with program termination).

 Interest of declaring such static variables in a compound instruction block or in a procedure scope:

**-** As for 'Dim', the 'Static' keyword is used in a compound statement block or in a procedure scope to declare variables whose scope stops at the end of the compound statement block or the procedure.
 **-** However, unlike 'Dim', the lifetime differs because the variables declared with the 'Static' keyword retain their value between the successive loops of the compound instruction block or the successive calls to the procedure.
 **-** In summary, a declared static variable has a local scope, but its lifetime is comparable to that of a global scope variable.
 **-** So, static variables with the same name can be declared in several different compound statement blocks and in different procedure scopes. Each of these variables therefore remains independent and retains its own value in its own local scope.

Example

Lifetime's comparison between different variables declared in a local scope:  
 local variable vs static variable, both declared in a procedure scope

```freebasic
Dim Shared As ZString Ptr pzl ' global variable to memorize the local Zstring address

Dim Shared As ZString Ptr pzs ' global variable to memorize the static Zstring address

Declare Sub prntSubString (ByVal p As ZString Ptr, ByVal size As Integer)

Sub s ()                                          ' beginning of procedure scope

    Dim As ZString * 15 zl = "local variable"     ' declare/initialize a local Zstring

    pzl = @zl                                     ' memorize the local Zstring address

    Static As ZString * 16 zs = "static variable" ' declare/initialize a static Zstring

    pzs = @zs                                     ' memorize the static Zstring address

    Print "     From inside the procedure scope:"

    prntSubString(pzl, 14)                        ' display address/content of the local zstring

    prntSubString(pzs, 15)                        ' display address/content of the static zstring

End Sub                                           ' end of procedure scope

Print "Lifetimes comparison between local/static variables declared in a local scope:"

s() ' call the procedure

Print "     From outside the procedure scope:"

prntSubString(pzl, 14) ' display address/content of the local zstring after going out its scope

prntSubString(pzs, 15) ' display address/content of the static zstring after going out its scope

Sleep

Sub prntSubString (ByVal p As ZString Ptr, ByVal size As Integer)

    Print , "&h" & Hex(p, SizeOf(Any Ptr) * 2),

    Print """";

    For I As Integer = 0 To size - 1

        Dim As UByte u = (*p)[I]

        If u < Asc(" ") Then

            Print " ";

        Else

            Print Chr(u);

        End If

    Next I

    Print """"

End Sub
```

 Output example:

```freebasic
Lifetimes comparison between local/static variables declared in a local scope:
	 From inside the procedure scope:
			  &h0019FE74    "local variable"
			  &h00407004    "static variable"
	 From outside the procedure scope:
			  &h0019FE74    " p@ Çp@ ¿■  Y "
			  &h00407004    "static variable"
```

See also

- [`Dim`](Dim), [`Static`](procedures-Static), [`Var`](Var)
- [Storage Classes](Storage-Classes)
- [Variable Scope](Variable-Scope)
- [Dynamic Object and Data Lifetime](Dynamic-Object-and-Data-Lifetime)

---

**Category:** [Tutorials](Category-Tutorials)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
