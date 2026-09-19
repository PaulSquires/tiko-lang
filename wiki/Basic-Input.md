[Home](Home) › [Tutorials](Category-Tutorials) › **Basic Input**

# Basic Input

Get Information into your Program.

 Input is the life of any program. If you can't get something into your program, how are you going to get anything out of it? What you will find here is the basics of how to get information into your FreeBASIC program.

 Here's a very basic program that will ask for your name:

```freebasic
'Create a place to put the user's name

Dim As String strMyName

' Ask for the user's name and store it in the string 'strMyName'

Input "What is your name? ", strMyName

' Wait half a second

Sleep 500

' Show them their name

Print

Print "I now know your name is "; strMyName

Print

' Wait until someone presses a button before you exit

Print "Press any button to exit"

Sleep
```

 INPUT is the easiest way to get information from someone. They just type in some text and press Enter when they are done.

 What if you you only want one keystroke? The easiest way is to use the [GetKey](Getkey) method. [GetKey](Getkey) gives you the [ASCII](Table-of-Ascii-Characters) value of a key that was pressed.

```freebasic
' Ask the user for input

Print "Press your favorite key:"

' Set a place to keep the ASCII value of the key

Dim As Integer strKeyPress

' Keep going until a key is pressed

Do

    strKeyPress = GetKey

Loop Until strKeyPress <> 0

' Show the key the user pressed

Print

Print "Your favorite key is: "; Chr(strKeyPress)

' Wait until someone presses a button before you exit

Print

Print "Press any button to exit"

Sleep
```

 For more information check out the [User Input](User-Input-Runtime-Library) Section.

 *Last Reviewed by Sancho3 on February 06, 2018*

---

**Category:** [Tutorials](Category-Tutorials)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
