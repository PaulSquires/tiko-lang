'' A COMPARISON COMPARES IN THE PROMOTED OPERAND TYPE, built to an executable: mixed
'' signedness and mixed widths, written out and as SELECT CASE tests. tiko took the
'' signedness from the LEFT operand and the width from the wider operand, so a ULONG
'' against a negative INTEGER compared unsigned, and a ULONG against a LONG of the same
'' 32 bits compared equal. See tests/mir/src/compare-promoted-type.bas for fbc's C.
''
'' fbc prints, one per line:
''     a 0  b-1  c 0  d 0  e 0  f 0  g-1  h 0  i-1  j-1  k-1  l-1
''     mge  ngt  oge  pne  qout  req
''
'' build/goldenrun.sh runs this beside fbc.
dim as ulong ul = 10
dim as ubyte ub = 200
dim as long l = -10
dim as integer i = -8
dim as uinteger ui = 3
dim as ushort us = 65535
dim as short sh = -1
dim as ulong ulmax = 4294967295
dim as byte by = -1
dim as ulongint big = 18446744073709551615ull

print "a"; (ul < -1)
print "b"; (ub > l)
print "c"; (i < ui)
print "d"; (ulmax = l)
print "e"; (us = sh)
print "f"; (ub = by)
print "g"; (ub >= l)
print "h"; (ui > i)
print "i"; (l < ul)
print "j"; (big > i)
print "k"; (ulmax <> l)
print "l"; (sh <= us)

print "m";
select case ul
case is < -1 : print "lt"
case else : print "ge"
end select

print "n";
select case ub
case is > l : print "gt"
case else : print "le"
end select

print "o";
select case i
case is < ui : print "lt"
case else : print "ge"
end select

print "p";
select case ulmax
case l : print "eq"
case else : print "ne"
end select

print "q";
select case ub
case 0 to l : print "in"
case else : print "out"
end select

print "r";
select case i
case -8 : print "eq"
case else : print "ne"
end select
