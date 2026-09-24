'' '-g' VARIABLES AND TYPES: one of each family. The values each one holds in a debugger
'' were measured with LLVM 21's lldb against the same program built by fbc -- see
'' tests/codegen/debug-vars.test.
enum Colour
   Red = 1
   Green = 2
   Blue = 4
end enum
type Node
   Value as long
   NextNode as Node ptr
end type
type Flags
   A : 3 as long
   B : 5 as long
end type
type Animal
   Legs as long
end type
type Dog extends Animal
   Barks as boolean
end type
union Pun
   L as long
   B(0 to 3) as ubyte
end union
dim shared ShCount as long = 42
'' A STATIC IN A PROCEDURE THAT IS NEVER EMITTED: unreferenced and private, so dropped,
'' while its static is still a global scoped to it.
private sub NeverCalled( )
   static Hidden as long
   Hidden += 1
end sub
dim shared ShName as string
sub Show( byref ByRefArg as long, byval ByValStr as string, byval N as Node, ByRefUdt as Node )
   static CallCount as long
   CallCount += 1
   print ByRefArg; ByValStr; N.Value; ByRefUdt.Value; CallCount
end sub
dim MyLong as long = -7
dim MyUByte as ubyte = 200
dim MyDouble as double = 3.25
dim MySingle as single = 1.5
dim MyBool as boolean = true
dim MyInt as integer = 123456789012
dim MyStr as string = "Hello"
dim MyZ as zstring * 8 = "zed"
dim MyW as wstring * 8 = "wide"
dim MyFix as string * 5 = "ab"
dim MyU as ustring = "uni"
dim MyCol as Colour = Green
dim Arr(1 to 3) as long = { 10, 20, 30 }
dim Grid(0 to 1, 0 to 2) as short = { { 1, 2, 3 }, { 4, 5, 6 } }
dim Dyn() as long
redim Dyn(2 to 4)
Dyn(3) = 33
dim First as Node, Second as Node
First.Value = 1 : Second.Value = 2 : First.NextNode = @Second
dim PNode as Node ptr = @First
dim Bits as Flags
Bits.A = 5 : Bits.B = 17
dim Rex as Dog
Rex.Legs = 4 : Rex.Barks = true
dim P as Pun
P.L = &h04030201
dim FnPtr as sub( byref as long, byval as string, byval as Node, byref as Node ) = @Show
ShName = "shared"
Show( MyLong, MyStr, First, Second )
print MyUByte; MyDouble; MySingle; MyBool; MyInt; MyZ; MyW; MyFix; MyU; MyCol; Arr(2); Grid(1,2); Dyn(3); PNode->NextNode->Value; Bits.A; Bits.B; Rex.Legs; P.B(2); ShCount; ShName
