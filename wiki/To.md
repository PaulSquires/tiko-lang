[Home](Home) › [Miscellaneous Keywords](Category-Miscellaneous-Keywords) › **To**

# To

Statement modifier to specify a range.

## Syntax

```freebasic
For iterator intial_value To ending_value
statement(s).
Next [ iterator ]
Select Case case_comparison_value
Case lower_bound To upper_bound
statement(s).
End Select
Dim variable_identifier( lower_bound To upper_bound ) As type_specifier
```

## Description

The `To` keyword is used to define a certain numerical range. This keyword is valid only if used with [`For ... Next`](For-Next), [`Case`](Case) and [`Dim`](Dim) statements.

 In the first syntax, the `To` keyword defines the initial and ending values of the iterator in a [`For`](For) statement.

 In the second syntax, the `To` keyword defines lower and upper bounds for [`Case`](Case) comparisons.

 In the third syntax, the `To` keyword defines the array bounds in a [`Dim`](Dim) statement

 For more information, see [`For...Next`](For-Next), [`Dim`](Dim) and [`Select Case`](procedures-Select-Case).

## Remarks

### Differences from QB

- none

### See also

- [`For...Next`](For-Next)
- [`Dim`](Dim)
- [`Select Case`](procedures-Select-Case)

## Examples

```freebasic
'' this program uses bound variables along with the TO keyword to create an array, store random

'' temperatures inside the array, and to determine output based upon the value of the temperatures

Randomize Timer

'' define minimum and maximum number of temperatures we will create

Const minimum_temp_count As Integer = 1

Const maximum_temp_count As Integer = 10

'' define the range of temperatures zones in which bacteria breed rapidly (in degrees)

Const min_low_danger As Integer = 40

Const max_low_danger As Integer = 69

Const min_medium_danger As Integer = 70

Const max_medium_danger As Integer = 99

Const min_high_danger As Integer = 100

Const max_high_danger As Integer = 130

'' define array to hold temperatures using our min/max temp count bounds

Dim As Integer array( minimum_temp_count To maximum_temp_count )

'' declare a for loop that iterates from minimum to maximum temp count

Dim As Integer it

For it = minimum_temp_count To maximum_temp_count

   array( it ) = Int( Rnd( 1 ) * 200 ) + 1

   '' display a message based on temperature using our min/max danger zone bounds

   Select Case array( it )

      Case min_low_danger To max_low_danger

         Color 11

         Print "Temperature" ; it ; " is in the low danger zone at" ; array( it ) ; " degrees!"

      Case min_medium_danger To max_medium_danger

         Color 14

         Print "Temperature" ; it ; " is in the medium danger zone at" ; array( it ) ; " degrees!"

      Case min_high_danger To max_high_danger

         Color 12

         Print "Temperature" ; it ; " is in the high danger zone at" ; array( it ) ; " degrees!"

      Case Else

         Color 3

         Print "Temperature" ; it ; " is safe at" ; array( it ) ; " degrees."

   End Select

Next it

Sleep
```

---

**Category:** [Miscellaneous Keywords](Category-Miscellaneous-Keywords)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
