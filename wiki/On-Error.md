[Home](Home) › [Error Handling Functions](Category-Error-Handling-Functions) › **On Error**

# On Error

Sets a label to jump to when a runtime error happens; On Error Goto 0 turns it off.

## Syntax

```freebasic
On [Local] Error Goto label
```

## Parameters

- `label`

## Description

**On Error** triggers a jump to an error handler when an error occurs. Such errors can be triggered by built-in statements such as [`Open`](Open), or when the [`Error`](Error) statement is used.

 Note: The error checking for built-in statements is only enabled if the program is compiled with one of the *[-e](Compiler-Option-E)*, *[-ex](Compiler-Option-Ex)* or *[-exx](Compiler-Option-Exx)* options. **On Error** remains working with [`Error`](Error) even when none of these options are used.

 [`On Local Error`](Local) can be used to specify a local error handler inside a procedure. This allows for specialized per-procedure error handling and will override the global error handler, if any.  
 Without [`Local`](Local), the handler must be in the main part of the module.  
 Remark: Presently, the [`Local`](Local) clause is ignored by the compiler.

 `On Error Goto 0` deactivates the current error handler.

## Remarks

### Differences from QB

- QB has no LOCAL clause and requires the label to be in the main part of the module.

### See also

- [`Error`](Error)
- [`Local`](Local)
- [`Err`](Err)
- [`Error Handling`](Error-Handling)

## Examples

```freebasic
on error goto errorhandler

error 24 '' simulate an error

print "this message will not be seen"

errorhandler:

dim as int32 n = err

print "Error #"; n; "!"

end
```

```freebasic
'' compile with: tiko onerror.tiko -ex

function hFileExists( byref filename as string ) as boolean

    dim as long f = freefile

    on local error goto exitfunction

    open filename for input as #f

    close #f

    return true

exitfunction:

    return false

end function

print "File exists: "; hFileExists( command( 1 ) )

on error goto errhandler

error 1234

print "not seen: an error handler cannot return here"

end 0

errhandler:

print "error number: " + str( err ) + " at line: " + str( erl )

end 1
```

---

**Category:** [Error Handling Functions](Category-Error-Handling-Functions)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
