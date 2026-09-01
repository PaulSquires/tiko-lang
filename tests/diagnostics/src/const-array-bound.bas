'' 'const N = lbound( a )' NEEDS A BOUND THAT IS KNOWN NOW -- fbc error 11. A FIXED array's
'' bounds fold; a DYNAMIC one's do not, a BYDESC parameter's arrive at run time, and a
'' VARIABLE dimension argument means fbc cannot tell WHICH bound is being asked for even
'' when it knows them all. A plain DIM is not a const and takes any of them.
dim fixed_(0 to 3) as integer
dim twoD(0 to 3, 1 to 5) as integer
dim dyn() as integer
dim i as integer

const OK1 = lbound( fixed_ )
const OK2 = ubound( fixed_ )
const OK3 = ubound( twoD, 2 )
dim plain as integer = lbound( dyn )

const BAD1 = lbound( dyn )
const BAD2 = ubound( twoD, i )
