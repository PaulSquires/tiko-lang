type M1
    as long q
    declare operator cast( ) as long
end type
operator M1.cast( ) as long : print "[l]"; : return 3 : end operator
dim shared as M1 mv
dim as long v = 5 : poke long, @v, mv : print v
print bit( 8, mv ); bitset( 0, mv ); bitreset( 15, mv )
