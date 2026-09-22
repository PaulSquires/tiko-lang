'' A USTRING CHAIN COMPARES AS A USTRING. Check types every '&' STRING.
dim as ustring u = "U"
dim as string s = "Uy"

dim as boolean eq = (u & "y" = "Uy")
dim as boolean gt = (u & "y" > "Ua")
dim as boolean rv = ("Uy" = u & "y")
dim as boolean ns = (u & "y" = s)

select case u & "y"
case "Ux", "Uy" : print "hit"
case else : print "miss"
end select
