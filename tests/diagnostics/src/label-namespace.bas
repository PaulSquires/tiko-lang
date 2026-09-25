'' A LABEL IS IN A NAMESPACE OF ITS OWN -- fbc-modern 1.20, 2026-09-25. Every label below
'' shares its name with something else, and fbc compiles lines 1 to 28, which print now 1
'' k 3 5 7 4. Lines 31 and 38 are error 4: a second label of one name in one procedure,
'' the second in another block of it, since labels are procedure-wide. tiko refused lines
'' 9, 23 and 27; in 'shadow' the labels took 'kk = 5' and 'print cc', which were left out
'' of the program; and it accepted line 38.
sub local_( )
    dim zz as long
    zz : print "now"
    zz = 1
    print zz
end sub
dim shared kk as long
const cc = 3
sub shadow( )
kk:
    print "k"
    kk = 5
cc:
    print cc
end sub
sub param_( byval prm as long )
prm:
    print prm
end sub
dim mm as long = 4
mm:
local_( ) : shadow( ) : print kk : param_( 7 ) : print mm
sub dupl( )
dup:
dup:
end sub
sub twoblocks( )
    scope
ee:
    end scope
    scope
ee:
    end scope
end sub
