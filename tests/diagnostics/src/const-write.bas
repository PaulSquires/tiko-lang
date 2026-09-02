'' NOTHING CONST MAY BE WRITTEN -- fbc error 119 (and 24 for a cast) -- reached through a
'' dereference, a cast, SWAP, LET( ), MID( )= or a graphics target. Every line was measured
'' against fbc: the refused ones write const storage and the accepted ones do not.
'' A CONSTANT'S TYPE must also be one a value can be folded into, which is fbc's other 24.
type U
    d as integer
end type
type WithConstField
    n as const integer = 69
end type
dim i as integer
dim ptrToConst as const integer ptr = @i
dim constPtr as integer const ptr = @i
dim as const integer ca = 1, cb = 2
dim as integer va = 3, vb = 4
dim as const string cs = "x"
dim as string vs = "y"
dim as const any ptr constImage
dim as any ptr image
dim wcf as WithConstField
'' Refused: the pointee is const.
*ptrToConst = 1
cast( const integer, i ) = 1
*cptr( const integer ptr, ptrToConst ) = 123
'' Accepted: a CONST POINTER whose pointee is writable.
*constPtr = 1
'' Refused: swap writes both sides.
swap ca, cb
swap va, cb
'' Accepted.
swap va, vb
'' Refused: let( ) unpacks into its targets.
dim as U u
let( ca ) = u
'' Accepted.
let( va ) = u
'' Refused: mid( ) writes its first argument.
mid( cs, 1, 1 ) = "h"
'' Accepted -- a const INDEX is only read.
mid( vs, ca, 1 ) = "h"
'' Refused: a graphics target is written.
line constImage, (0, 0)-(1, 1), 0
'' Accepted.
line image, (0, 0)-(1, 1), 0
'' Refused: the address of a const field yields a pointer to const.
dim pcf as const integer ptr = @wcf.n
*pcf = 0
'' A constant's own type: refused for 'any', a fixed string and a UDT.
const k1 as integer = 1
const k2 as string = "a"
const k3 as integer ptr = 0
const k4 as any = 1
const k5 as string * 20 = "abc"
const k6 as zstring * 20 = "abc"
const k7 as U = type<U>( 0 )
