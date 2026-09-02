'' A DEFINITION AGREES WITH ITS EXTERN, and WHAT A BYREF VARIABLE MAY BE BOUND TO.
'' Every line below was measured against fbc: the refused ones are its errors 37, 36,
'' 54, 87 (extern) and 24, 11 (byref); the accepted ones compile.
extern a1(0 to 1) as integer
dim a1(0 to 1) as integer
extern a2(0 to 1) as integer
dim a2(0 to 0) as integer
extern a3(0 to 1) as integer
dim a3(-1 to ...) as integer = { 1, 2 }
extern a4(0 to 1) as integer
dim a4(0 to ...) as integer = { 1, 2 }
extern a5(0 to 1, 0 to 1) as integer
dim a5(0 to 1) as integer
extern a6(0 to 1) as integer
redim a6(0 to 1) as integer
extern s1 as string
dim s1 as string = "foo"
extern s2 as string
var s2 = "foo"
extern s3 as string
dim s3 as string
type UDT
    i as integer
    declare constructor( )
end type
constructor UDT( )
end constructor
function f( ) as integer
    function = 0
end function
dim i as integer
dim g as integer
dim byref r1 as integer = i
dim byref r2 as const integer = i
dim byref r3 as double = i
dim byref r4 as long = i
dim z as zstring * 8
dim byref r5 as zstring = z
dim s as string
dim byref r6 as zstring = s
dim byref r7 as string = "abc"
dim byref r8 as zstring = "abc"
var byref r9 = type<UDT>( )
var byref r10 = UDT( )
var byref r11 = "abc"
static byref r12 as integer = g
dim shared sh as integer
static byref r13 as integer = sh
