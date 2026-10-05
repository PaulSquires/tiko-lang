dim s as string = "aZ5" + chr(250)
dim p as zstring ptr = strptr( s )
while *p
    select case as const *p
    case asc("A") to asc("Z") : print "U";
    case asc("0") to asc("9") : print "D";
    case 250 : print "X";
    case else : print "E";
    end select
    p += 1
wend
print
dim as ubyte ptr bp = strptr( s )
select case as const *bp
case 97 : print "a!"
case else : print "else"
end select
