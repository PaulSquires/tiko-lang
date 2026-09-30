'' A REDIM's rank judges only the uses BELOW it -- fbc accepts the first three.
sub f( a() as integer )
	redim a(0 to 0)
	print a(0, 0)                               '' fine: a parameter's rank is not known
end sub
dim b() as integer
print b(0, 0)                                   '' fine: nothing recorded above the use
redim b(0 to 0)
dim d() as integer
redim d(0 to 0)
print d(0, 0)                                   '' 36: the rank recorded above
