type Point
    as long x, y
end type
dim shared as long total
function Add( byval a as long, byval b as long ) as long
    dim as long sum = a + b
    Add = sum
end function
declare sub Show2( byval v as long )
sub Show( byref p as Point )
    total = p.x + p.y
    Show2 p.x
end sub
dim as Point pt
dim as long ptr q
Show pt
