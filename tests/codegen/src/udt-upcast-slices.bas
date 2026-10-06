'' placement new and a UDT array initialiser over a DERIVED value take its base part; an
'' unnamed plain-data element is zero
type t1 : as integer i : end type
type t2 extends t1 : as integer j : end type
type t3 extends t2 : as integer k : end type
type t4 extends t3 : as integer l : end type
sub s()
	dim junk(0 to 7) as integer
	for i as integer = 0 to 7 : junk(i) = 99 : next
end sub
sub t()
	dim as t4 x4 = (1, 2, 3, 4)
	dim as t2 u21(0 to 1) = { x4 }
	print u21(0).i, u21(0).j, u21(1).i, u21(1).j
	dim as any ptr p1 = callocate(sizeof(t4))
	dim as t4 ptr p14 = cptr(t4 ptr, new(p1) t2(x4))
	print p14->i, p14->j, p14->k, p14->l
	deallocate( p1 )
end sub
s() : t()
