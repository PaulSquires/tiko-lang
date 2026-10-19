[Home](Home) › [Error Handling Functions](Category-Error-Handling-Functions) › **Err**

# Err

Returns the number of the last runtime error, or sets it without jumping.

## Description

The `Err()` function returns the FreeBASIC run-time error number (a 32 bit [`Long`](Long)) which can be set by the built-in statements and functions, or by the program through `Err = number` or [`Error`](Error). Unlike [`Error`](Error), `Err = number` sets the error number without invoking an error handler.

 See Runtime Error Codes for a listing of the predefined runtime error numbers and their associated meaning. The program may use additional custom error numbers.

 `Err` can always be used, even if QB-like error handling is not enabled.

 Note: Care should be taken when calling an internal function (such as [`Print`](Print)) after an error occurred, because it will reset the error value with its own error status. To preserve the `Err` value, it is a good idea to store it in a variable as soon as the error handler is entered.

 Remark: Some procedures used in their function version return directly the error code (a 32 bit [`Long`](Long)).  
 That is the case for: [`BLoad`](Bload), [`BSave`](Bsave), [`Close`](Close), [`FileCopy`](Filecopy), [`GetJoystick`](Getjoystick), [`GetMouse`](Getmouse), [`ImageInfo`](Imageinfo), [`Kill`](Kill), [`Open`](Open), [`Open Com`](Open-Com), [`Open Cons`](Open-Cons), [`Open Err`](Open-Err), [`Open Lpt`](Open-Lpt), [`Open Pipe`](Open-Pipe), [`Open Scrn`](Open-Scrn), [`ScreenRes`](Screenres), [`ScreenSync`](Screensync), [`SetDate`](Setdate), [`SetMouse`](Setmouse), [`SetTime`](Settime).

## Remarks

### Usage

```freebasic
result = Err( )

or

Err = number
```

### Differences from QB

- Error numbers are not the same as in QB.

### See also

- [`On Error`](On-Error)
- [`Error`](Error)
- [Error Handling](Error-Handling)

## Examples

An example using QBasic style error handling (compile with -ex option)

```freebasic
'' compile with -ex

on error goto error_handler

error 150

end

error_handler:

  dim as int32 n = err( )

  print "Error #"; n

  end 1
```

 An example using inline error handling (note: [`Open`](Open) can also return its own error status when called as a function)

```freebasic
'' compile without -e switch

Dim filename As String

Do

    Line Input "Input filename: ", filename

    If filename = "" Then End

    Open filename For Input As #1

Loop Until Err() = 0

Print Using "File '&' opened successfully"; filename

Close #1
```

---

**Category:** [Error Handling Functions](Category-Error-Handling-Functions)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
