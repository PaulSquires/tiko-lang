'' A WIDE SELECT SUBJECT'S TEMPORARIES DIE ON EVERY WAY OUT OF THE SELECT.
function f( byval k as long ) as long
    select case "a" & wstr( k )
    case "a1" : return 1
    case "a2", "a3" : return 2
    end select
    return 0
end function

dim as long i = 1

'' A scalar wstr( ) in a chain is a temporary of its own.
print "a" & wstr( i )

for j as long = 1 to 3
    select case "b" & wstr( j )
    case "b1" : exit for
    end select
next
print f( i )
