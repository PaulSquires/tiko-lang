dim as ushort u = 65534
select case u
case 4294967290ul to 4294967295ul
	print "a match"
case else
	print "a nomatch"
end select
select case u
case is = 4294967294ul
	print "b match"
case else
	print "b nomatch"
end select
dim as ubyte b = 254
select case b
case 510u
	print "c match"
case else
	print "c nomatch"
end select
select case b
case 510ll
	print "d match"
case else
	print "d nomatch"
end select
dim as ulong k = 4294967294ul
select case u
case k
	print "e match"
case else
	print "e nomatch"
end select
dim as short s = -2
select case s
case 65534ul
	print "f match"
case else
	print "f nomatch"
end select
