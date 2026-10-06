'' printing a comparison of a UDT (through its string cast) with a string
type A
	i as integer
	declare operator cast( ) as string
	declare operator cast( ) as integer
end type
operator A.cast( ) as string : operator = "B" : end operator
operator A.cast( ) as integer : operator = 11 : end operator
dim x as A
dim b as boolean = (x = "B")
print b
print (x = "B")
if x = "B" then print "yes"
print x = "B", -(x = "C")
