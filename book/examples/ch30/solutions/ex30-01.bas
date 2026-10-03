'' gosub.bas without GOSUB: the subroutine becomes a SUB, and the
'' variable it changed is passed to it.
sub AddOne( byref total as long )
    total += 1
end sub

dim as long total = 0
AddOne( total )
AddOne( total )
print total
