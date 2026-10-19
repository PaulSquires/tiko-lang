[Home](Home) › [User Input (Runtime Library)](Category-User-Input-Runtime-Library) › **Input**

# Input

Reads values the user types, up to Enter, after an optional prompt.

## Syntax

```freebasic
Input [;] ["prompt" ,|; ] variable_list
```

## Parameters

- `prompt`
- `variable_list`

## Description

Reads a list values from the keyboard up until the first carriage return. Numerical values are converted from their string representation into the corresponding types in the variable list. Characters are echoed to the screen as they are typed.

 If there is more than one value in the input list, then the input line will be split up by scanning for delimiters - commas (`,`) after strings, or commas and whitespace after numbers. Surrounding whitespace will be trimmed from string values. If an input string has a comma in it, it must be wrapped in quotes (`"..."`) to prevent it being split up.  
 For inputting to a single string without delimiting, [`Line Input`](procedures-Line-Input) should be used instead.

 The `prompt` - if any - is written to the screen at the current cursor location, and characters read are echoed to the screen immediately following the prompt. If no prompt is specified, characters are echoed at the current cursor location.

 The optional leading semicolon (`;`) after `Input` is similar to the optional trailing semicolon in a [`Print`](Print) statement: the cursor will remain on the same line after all of the characters have been echoed, otherwise, the cursor will move to the beginning of the next line.

 If more values are read than are listed in the variable list, extra values will be ignored; if fewer values are read (i.e. the user presses enter before inputting all values), the remaining variables will be initialized (numeric variables to zero (`0`), and string variables to the empty string (`"``"`)).

 Numeric values are converted using methods similar to the procedures [`Val`](Val) and [`ValLng`](Vallng), using the most appropriate function for the number format, converting as many numeric characters as possible.

 `Input` has a limited edit capacity: it allows to use the left and right cursor keys to navigate the text, and to erase or insert characters. If a better user interface is needed, a custom input routine should be used.

## Remarks

### Differences from QB

- If the user inputs the wrong number of values, or if it expects a number for a value and gets a string that is not a valid number, then QBASIC issues the message "Redo from start", and does not continue further until it receives a valid input.
  QB does not treat space as a delimiter when inputting a number from the console.

### See also

- [`Input #`](Input)
- [`Input()`](Input-2)
- [`Line Input`](procedures-Line-Input)

## Examples

**Example #1**

```freebasic
Dim user_name As String, user_age As Integer

Input "Enter your name and age, separated by a comma: ", user_name, user_age

Print "Your name is " & user_name & ", and you are " & user_age & " years old."
```

 **Example #2**

```freebasic
Dim As Double a, b

Dim As String yn

Do

    Input   "Please enter a number: ", a

    Input ; "And another: ", b

    Print , "Thank you"

    Sleep 500

    Print

    Print "The total is "; a + b

    Print

    Do

        Input "Would you like to enter some more numbers"; yn

        yn = LCase(yn)

    Loop Until yn = "y" Or yn = "n"

Loop While LCase(yn) = "y"
```

---

**Category:** [User Input (Runtime Library)](Category-User-Input-Runtime-Library)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
