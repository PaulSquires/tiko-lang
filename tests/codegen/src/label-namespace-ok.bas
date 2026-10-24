'' label-namespace-ok.bas -- label-namespace.bas's lines 7 to 28, the half fbc compiles: a label
'' shares its name with a local, a shared variable, a constant and a parameter, and hides none.
'' fbc-modern 1.20 prints now / 1 / k / 3 / 5 / 7 / 4 (measured 2026-10-24). Its own file since
'' lowering stopped running after an error (LATER-PLAN D step 2): the other half's two TKO0600s
'' kept this half from being lowered at all.
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
