sub modr(byref s as string)
  s = s & "X"
end sub
sub modr2(byref s as string, byval k as integer)
  s = s & "Y"
end sub
function modf(byref s as string) as integer
  s = s & "F"
  return 0
end function
dim as string g = "g"
modr(g)
print g
dim as string a(1)
a(1) = "q"
modr a(1)
print a(1)
modr(a(1))
print a(1)
modr2(a(1), 0)
print a(1)
modf(a(1))
print a(1)
dim as integer r = modf(a(1))
print a(1)
dim as string ptr p = @a(1)
modr(*p)
print a(1)
modr(p[0])
print a(1)
