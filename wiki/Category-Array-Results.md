[Home](Home) › [All Categories](Categories) › **Array Results**

# Array Results

```freebasic
function foo( ) as integer( )
    return { 10, 20, 30 }
end function

var i = foo( )
print i( 1 )                 ' 20
```

A function may return a **dynamic array**. Write the result type as `T( )`. No `#include`, no runtime support -- it is a language feature, and **not a tiko container**: what comes back is an ordinary dynamic array, indexed with `i( 1 )`, measured with `ubound( i )`, passed to `a( ) as integer` parameters and erased at the end of its scope like any other.

## What 'return' Takes

```freebasic
function squares( byval n as int32 ) as int32( )
    dim r( ) as int32
    redim r( 0 to n - 1 )
    for k as int32 = 0 to n - 1 : r( k ) = k * k : next
    return r                          ' a local array: MOVED out
end function

function names( ) as string( )
    return { "alpha", "beta" }        ' a flat brace list, any element type
end function

function again( ) as int32( )
    return squares( 4 )               ' a call that returns an array
end function

function table( ) as int32( )
    dim as int32 t( 100 )             ' fixed bounds are fine too
    for k as int32 = 0 to 100 : t( k ) = k * 2 : next
    return t                          ' MOVED out, like any local array
end function
```

- **A brace list** -- the array is sized to the list and filled. Nested lists are an error (TKO0839).
- **A local array of this function** -- moved, not copied. The local is left empty, so its scope-exit erase frees nothing. A local declared with **fixed bounds**, `dim t( 100 )`, is moved too: because the function returns it, its elements are allocated on the heap at the `dim` instead of in the function's frame, with the same bounds, so the return hands over the descriptor and copies no element.
- **A call that returns an array** -- moved through.

`function = { 1, 2 }` takes the same three; a second `function =` replaces the first. A body that returns nothing returns an empty array (`ubound` is `-1`).

A **parameter**, a `shared` or `static` array or a field would have to be *copied*, which is not supported yet: TKO0840 (TKO0838 when written `this.items`). Move-only is deliberate -- moving one of those out would leave its owner holding freed memory.

## At The Call Site

```freebasic
var i = foo( )                 ' the variable IS the array
var j( ) = foo( )              ' the same, with the parentheses written
dim as integer m( )
m = foo( )                     ' the old elements are erased, the new ones moved in
show( foo( ) )                 ' into a by-descriptor parameter; erased with the statement
var d = Doubled( foo( ) )      ' one array result straight into another call
for each e as integer in foo( ) : print e : next
foo( )                         ' an unused result is erased at the end of the statement
```

A result is always **owned by the caller**, so none of these copies or leaks. Two calls never share a buffer.

## Refused

| Written | Why |
| --- | --- |
| `as integer( 3 )`, `as integer( any )` | only an empty `( )` means an array (TKO0836) |
| `as function( ) as integer( )` | a procedure type cannot return an array (TKO0837) |
| `return 5`, `return r` over a different element type | not something an array result can be built from (TKO0838) |
| `var b = foo` | write the parentheses (TKO0841) |
| `dim x as integer = foo( )`, `return foo( )` from an `integer` function, `TakesInt( foo( ) )` | an array converts to nothing else (TKO0842) |
| `dim a( ) as integer = foo( )` | TKO0612. Use `var a = foo( )` or `var a( ) = foo( )` |
| `var a( ) = 5`, `var a( ) = b` | `var a( )` takes only an array result (TKO0612) |
| `return t` over a `static` local, or one written with an initialiser | only a plain local can be moved out (TKO0838) |
| `declare ... as integer( )` defined `as integer` | the result must agree with its declaration (TKO0793) |
| `foo( )( 1 )` | not a procedure pointer (TKO0772). Assign the result to a variable first |

## Not Yet

Array results of properties and operators are untested. A brace list of UDTs builds each element once, in place -- a type with a constructor and destructor sees one of each per element.
