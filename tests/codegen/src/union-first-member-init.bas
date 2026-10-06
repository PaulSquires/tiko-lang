union U1
	c(0 to 9) as ubyte
	f as string * 10
end union
union U2
	f as string * 10
	c(0 to 9) as ubyte
end union
dim x5 as U1
print x5.c(0), x5.c(9)
dim x6 as U2
print x6.c(0), x6.c(9)
