[Home](Home) › [Tutorials](Category-Tutorials) › **gsl, The GNU Scientific Library**

# gsl, The GNU Scientific Library

Provides a wide range of mathematical routines such as random number generators, special functions and least-squares fitting.

 Website: https://www.gnu.org/software/gsl/, Windows port: http://gnuwin32.sourceforge.net/packages/gsl.htm  
 Platforms supported: Win32, Linux  
 Headers to include: gsl/\*.bi  
 Header version: 1.6  
 Examples: in examples/math/GSL/

Example

```freebasic
'' Elementary math example

#include "gsl/gsl_math.bi"

'' Raise the value of 3.141 to the fourth power

? "3.141 ^ 4 = "; gsl_pow_4(3.141)

?

'' Find the hypotenuse of a right triangle with sides 3 and 4

? "The hypotenuse of a right triangle with sides of length 3 and 4 is"; gsl_hypot(3,4)

?

Sleep
```

```freebasic
'' Matrix example

#include "gsl/gsl_matrix.bi"

'' gsl uses the c-style row major order, unlike VB or Fortran

? "A 3x3 matrix"

Dim As gsl_matrix Ptr m = gsl_matrix_alloc(3, 3)

For i As Integer = 0 To 2

    For j As Integer = 0 To 2

        gsl_matrix_set (m, i, j, 0.23 + 100*i + j)

    Next

Next

For i As Integer = 0 To 2

    For j As Integer = 0 To 2

        Print "m(";i;",";j;") = "; gsl_matrix_get (m, i, j)

    Next

Next

?

gsl_matrix_transpose(m)

? "And its transpose"

For i As Integer = 0 To 2

    For j As Integer = 0 To 2

        Print "m(";i;",";j;") = "; gsl_matrix_get (m, i, j)

    Next

Next

Sleep
```

---

**Category:** [Tutorials](Category-Tutorials)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
