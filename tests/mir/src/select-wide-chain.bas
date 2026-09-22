'' A WIDE CHAIN AS A SELECT CASE SUBJECT. Check types '&' STRING.
dim as wstring * 10 w = "q"

select case w & "y"
case "qx", "qy" : print "hit"
case is > "qa" : print "gt"
case else : print "miss"
end select

select case right( "00" & wstr( 7 ), 2 )
case "07" : print "seven"
end select
