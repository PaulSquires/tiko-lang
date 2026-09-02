'' 'let( a, b ) = x' UNPACKS INTO ITS TARGETS, and each must be a variable. MEASURED:
'' 'let( 0 ) = x' is fbc error 24 and 'let( K ) = x' over a constant is error 119;
'' variables are the ordinary targets.
type T
    as integer i, j
end type
dim as T x
dim as integer a, b
const K = 0
let( a, b ) = x
let( a ) = x

let( 0 ) = x
let( K ) = x
let( a, 1 ) = x
