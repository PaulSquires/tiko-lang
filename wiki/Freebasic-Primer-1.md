[Home](Home) › [Tutorials](Category-Tutorials) › **FreeBASIC Primer #1**

# FreeBASIC Primer #1

This primer is intended for beginning beginners, for those who are just starting to learn how to program and using FreeBASIC do to it.

Learning the language

Learning a programming language means learning the words to write it and knowing what they mean when they are written. We don't need to learn them all at once. But learning a few important words that do something will help us get started. Here we are just going to concentrate on these keywords:

- [`Dim`](Dim)
- [`Print`](Print)
- [`Input`](procedures-Input)
- [`For...Next`](For-Next)
- [`If...Then`](If-Then)
- [`Do...Loop`](Do-Loop)

Hello World!

No beginners reference is complete without this example.

 `Print "Hello World!"`  
 The text between the pair of double quotes is a literal string. The [`Print`](Print) statement is used to output text to the display. If you can edit, compile, and execute this example, you are on your way.

 **Note:** A program terminates immediately after executing the last line of code. User can add a [`Sleep`](Sleep) statement to induce a pause until pressing any key to complete instruction (see last example for usage).

Using a Variable to Store Data

Sometimes in a program we will want to store some information somewhere, in memory, and then use it later. To store something in memory we use a variable. All variables in FreeBASIC are of some specific type, like a number or a string. We use the [`Dim`](Dim) statement to declare a variable name and specify what type of information we want to store in it.

```freebasic
Dim text As String

text = "Hello World!"

Print text
```

 We are using [`Dim`](Dim) to let the compiler know that we want to use a variable named `text` in our program and that we will be putting [`String`](String) data in it. We then assign (copy) `"Hello World!"` in to the variable. Finally, we use [`Print`](Print) to output it to the display.

Using a Variable in an Expression

An *expression* is a generic term for describing a part of the source code that can be evaluated. After an expression is evaluated, we can then do something with it, like assign (copy) it to a variable.

```freebasic
Dim As String a, b, text

a = "Hello"

b = "World"

text = a + " " + b + "!"

Print text
```

 We are assigning the variables `a` and `b` with some data. We are then using the variables `a` and `b` in an expression which is then assigned to `text`. Finally, we output the result to the display.

Getting Input from the User

Often, we have no idea what data is needed for a program unless the user gives it to us. We can't put it in our source code since we won't know what it is until the user runs the program and tells us what it is.

```freebasic
Dim answer As String

Input "Type something and press enter:", answer

Print "You typed: '"; answer; "'"
```

 Here the [`Input`](procedures-Input) statement will first, output some information to the display, and then wait for the user to give the program some data. In this example, we just output back to the display, exactly what the user typed in.

Doing Some Math

Variables and expressions are not just limited to strings. Most early languages didn't handle strings very well if at all. Writing mathematical expressions is similar to how they might be written with pencil and paper.

```freebasic
Dim As Integer a, b, c

a = 5

b = 7

c = a + b

Print "a = "; a

Print "b = "; b

Print "a + b = "; c
```

 We are assigning values to the variables `a`, `b` and `c`. We are using [`Integer`](Integer) for the variables' data type. An integer can be positive or negative, but not have any fractions.

Doing Some Math with Input

This is similar to the previous example, except we will let the user choose the numbers we are going to add together.

```freebasic
Dim As Integer a, b, r

Input "Enter a number:", a

Input "Enter another number:", b

r = a + b

Print "The sum of the numbers is "; r
```

 [`Dim`](Dim) lets the compiler know which variable names we want to use and that they are going to hold [`Integer`](Integer) data. We are using [`Input`](procedures-Input) to get the numbers from the user, and [`Print`](Print) to display the results.

Doing More Math with Input

Numeric variables are not limited to just integers. We can also use [`Single`](Single) or [`Double`](Double) precision data types which can represent fractions. In this example we will take some input from the user to convert a weight in pounds to kilograms.

```freebasic
Dim As Single lb, kg

Input "Enter a weight in pounds:", lb

kg = lb * 0.454

Print lb; " lb. is equal to "; kg; " kg"
```

Repeating Statements

Using [`For...Next`](For-Next) statement we can tell the program to do something repeatedly a set number of times. For example lets say we wanted to add up all the numbers from 1 to 100.

```freebasic
Dim total As Integer

Dim number As Integer

total = 0

For number = 1 To 100

  total = total + number

Next

Print "The sum of number from 1 to 100 is "; total
```

Making a Decision

A program can choose which statements to execute using a conditional statement like [`If...Then`](If-Then). We can use the value of a variable or the result of an expression to decide if we should, or should not, execute one or more statements.

```freebasic
Dim number As Integer

Input "Enter a number : ", number

Print "Your number is ";

If number < 0 Then

  Print "negative"

ElseIf number > 0 Then

  Print "positive"

Else

  Print "zero"

End If
```

 After getting a number from the user, we are going to output a word ( positive, negative, or zero ) based on which condition matches the statement.

Repeating Statements (Again)

Here we will use another looping structure [`Do...Loop`](Do-Loop) to repeat some statements. How will the program know to stop repeating the statements? We will use [`If...Then`](If-Then) to make the decision when to get out of the loop.

```freebasic
Dim As Single   total, count, number   ' multi variable declaration (same type)

Dim As String   text

Print "This program will calculate the sum and average for a"

Print "list of numbers. Enter an empty value to see results."

Print

Do

  Input "Enter a number: ", text       ' get user input

  If text = "" Then Exit Do            ' if empty -> quit Do/Loop

  count += 1                           ' increment count by: 1

  total += Val(text)                   ' add and assign new value

Loop

Print

Print "You entered:    "; count; "  number(s)"

Print "The sum is:     "; total

If count > 0 Then Print "The average is: "; total / count

Print

Print "Any keypress ends program. ";

Sleep
```

See also

- [`Dim`](Dim)
- [`Print`](Print)
- [`?`](Print)
- [`Input`](procedures-Input)
- [`For...Next`](For-Next)
- [`If...Then`](If-Then)
- [`Do...Loop`](Do-Loop)

---

**Category:** [Tutorials](Category-Tutorials)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
