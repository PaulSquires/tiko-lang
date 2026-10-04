'' Accept-invalid shapes fbc refuses (audit F-57) -- each its own error, none a cascade.
dim as integer i = 2
select case i
case else : print "e1"
case else : print "e2"
end select
for i = 1
next
select case i
case is + 5 : print 1
end select
sub s( ) junk
end sub
print "after"
