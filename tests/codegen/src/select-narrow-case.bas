dim as short s = -2
select case s
case 65534
	print "a match"
case else
	print "a nomatch"
end select
dim as long l = 0
select case l
case 4294967296
	print "b match"
case else
	print "b nomatch"
end select
select case l
case is < 4294967296
	print "c lt"
case else
	print "c ge"
end select
dim as byte b = 1
select case b
case 257 to 300
	print "d in"
case else
	print "d out"
end select
