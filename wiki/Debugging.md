[Home](Home) › **Debugging**

# Debugging

Compile with [`-g`](Compiler-Option-G) and tiko writes DWARF debug information into the program: line tables, every procedure, its parameters and locals, `shared` variables, and their types -- a `type`'s fields, a `string`'s or `ustring`'s text. Any DWARF debugger reads it. **lldb** comes with LLVM, which tiko already needs; **gdb** works as well.

```
tiko -g prog.tiko
```

`-edebuginfo` writes the same debug information without the rest of `-g` (asserts, `__FB_DEBUG__`).

## A session in lldb

The program:

```freebasic
type Point
    as long x, y
end type

dim shared as long counter = 7

function Area( byval w as long, byval h as long ) as long
    dim as long a = w * h
    dim as Point p
    p.x = w : p.y = h
    dim as ustring label = "box"
    dim as string s = "hello"
    dim as double ratio = w / h
    counter += 1
    return a
end function

print Area( 6, 4 )
```

Start lldb on the executable, set a breakpoint by file and line, and run:

```
lldb prog.exe
(lldb) breakpoint set --file prog.tiko --line 14
(lldb) run
* thread #1, stop reason = breakpoint 1.1
    frame #0: prog.exe`Area(w=6, h=4) at prog.tiko:14
-> 14  	    counter += 1
```

`frame variable` lists the parameters and locals, with their types:

```
(lldb) frame variable
(long) w = 6
(long) h = 4
(long) a = 24
(Point) p = {
  x = 6
  y = 4
}
(ustring) label = (data = u"box", len = 3, size = 16)
(string) s = (data = "hello", len = 5, size = 32)
(double) ratio = 1.5
```

`print` evaluates one name, a `shared` variable included, and `bt` shows the call stack in source terms:

```
(lldb) print counter
(long) 7
(lldb) bt
  * frame #0: prog.exe`Area(w=6, h=4) at prog.tiko:14
    frame #1: prog.exe`main at prog.tiko:18
```

The commands used most:

| lldb | gdb | |
| --- | --- | --- |
| `b prog.tiko:14` | `break prog.tiko:14` | breakpoint at a line |
| `b Area` | `break Area` | breakpoint at a procedure |
| `run` | `run` | start the program |
| `next` | `next` | the next line, stepping over calls |
| `step` | `step` | the next line, stepping into calls |
| `finish` | `finish` | run until the current procedure returns |
| `continue` | `continue` | run to the next breakpoint |
| `frame variable` | `info locals` | the locals |
| `print p` | `print p` | one variable |
| `bt` | `bt` | the call stack |

## Names

A procedure, a variable and a type are named as they are written in the source, and the debugger matches names **case-sensitively**: with `function Area` declared, `b Area` sets a breakpoint and `b area` finds nothing.

A `string` or `ustring` shows as its three parts: `data`, the text; `len`, its length in characters; and `size`, the bytes allocated.

An instantiation of a generic type is named by an internal number rather than by its type arguments: `Box( of long )` appears as `box<6>`, and its method's frame as `box<6>.SetV`. Its fields, parameters and locals show with their types as usual.

## See also

- [Compiler Option: -g](Compiler-Option-G)
- [Compiler Error Messages](Compiler-Error-Messages)
- [`Assert`](Assert)
