'' A COMPARISON COMPARES IN THE PROMOTED OPERAND TYPE. It is neither operand's own type
'' and not the comparison's result type either -- that is always INTEGER, and says
'' nothing about how the two were compared. fbc promotes both sides the way it would for
'' arithmetic and compares there; tiko took the signedness from the LEFT operand and the
'' width from the wider of the two. Measured, fbc's C:
''
''     (int64)UL$0 < -1ll              ul < -1      0, and tiko printed -1
''     (int64)UB$0 > (int64)L$0        ub > l      -1, and tiko printed 0
''     (uint64)I$0 < UI$0              i < ui       0, and tiko printed -1
''     (int64)UL$0 == (int64)L$0       ul = l       0, and tiko printed -1
''
'' -- the last one is WIDTH rather than sign: a ULONG of 4294967295 and a LONG of -1 are
'' the same 32 bits and different 64-bit numbers, so equality promotes too.
''
'' SELECT CASE is the same comparison written another way, and had the same defect: its
'' test used the SUBJECT's width and signedness for every case value.
''
'' The IR below should show the promotion -- zext for an unsigned operand, sext for a
'' signed one -- and then icmp.s* where fbc's cast is '(int64)' and icmp.u* where it is
'' '(uint64)'.
dim shared as ulong ul = 10
dim shared as ubyte ub = 200
dim shared as long l = -10
dim shared as integer i = -8
dim shared as uinteger ui = 3
dim shared as ushort us = 65535
dim shared as short sh = -1

print (ul < -1)
print (ub > l)
print (i < ui)
print (ul = l)
print (us = sh)
print (ub >= l)
print (ui > i)

select case ul
case is < -1 : print "lt"
case else : print "ge"
end select

select case ub
case is > l : print "gt"
case else : print "le"
end select

select case i
case is < ui : print "lt"
case else : print "ge"
end select

select case ul
case l : print "eq"
case else : print "ne"
end select

select case ub
case 0 to l : print "in"
case else : print "out"
end select
