[Home](Home) › [Using the FreeBASIC compiler](Category-Using-the-FreeBASIC-compiler) › **Compiler Option: -w**

# Compiler Option: -w

Set minimum warning level.

Syntax

`-w level | all | none | param | Escape | pedantic | Next | funcptr | constness | suffix | Error | upcast`

Parameters

`level`

Warning messages only with a level equal or greater to this value will be output.

`all`

Equivalent to specifying a `level` of zero (`0`).

`none`

Suppresses all warnings.

`param`

Warn when procedure parameters aren't specified with either [`ByVal`](Byval) or [`ByRef`](Byref-Parameters).

`Escape`

Warn when string literals contain any number of escape characters (`\`).

`pedantic`

Equivalent to specifying the `param` and `Escape` arguments, plus length checking of parameters passed [`ByVal`](Byval) and of any [`CPtr`](Cptr) converting to pointer only, plus warning on useless suffixes in '-lang fb'.

`Next`

Warn when [`Next`](Next) is followed by an identifier.

`funcptr`

Warn on mismatched procedure pointers, including conversions in [`Cast`](Cast) and [`CPtr`](Cptr) expressions. Implies '-w all'. Experimental. Behaviour may change in future versions.

`constness`

Warn when [`Const (Qualifier)`](Const-Qualifier) is discarded in an assignment. Implies '-w funcptr' and '-w all'. Behaviour may change in future versions.

`suffix`

Warn on useless suffixes in '-lang fb'.

`Error`

Report warnings as errors. Warnings cause the error count to increase, warning messages are displayed as "error warning...", compilation / assembly / linking aborts, and the compiler exits with an error code.

`upcast`

Warn when up-casting discards initializers.

Description

The `-w` compiler option determines which compiler warnings, if any, are output. Each possible warning is associated with a warning level, starting from zero (`0`) and increasing with the potential problems that may occur.

 The `param`, `Escape`, `pedantic`, `Next`, `funcptr`, `constness`, `suffix`, `Error`, and `upcast` arguments provide additional warnings not ordinarily output, even by default.

 The default, if the `-w` option is not specified, is as if `-w 1` was used. The `-w` option can be specified multiple times. Warning messages having a level of `0` are not shown by default.

 `-w none`, or a significantly high `level` value will have the effect of suppressing all warning messages.

 The compiler does not issue warning or error if the warning name itself is not valid. For example `-w flarg`, is not a recognized name for a warning. The compiler silently ignores this to allow command lines with warnings added in new versions of the compiler to also be used with older versions of the compiler without complaint.

Version


See also

- [Using the Command Line](Quick-Start#compile-a-program)

---

**Category:** [Using the FreeBASIC compiler](Category-Using-the-FreeBASIC-compiler)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
