type M1
    as long q
    declare operator cast( ) as long
end type
operator M1.cast( ) as long : print "[l]"; : return 3 : end operator
dim shared as M1 mv
dim as long arr( 1 ) = { mv, mv } : print arr( 0 ) + arr( 1 )
dim as double ard( 1 ) = { mv, 2 } : print ard( 0 ); ard( 1 )
dim as long ptr pl = new long( mv ) : print *pl
delete pl
dim as double ptr pd = new double( mv ) : print *pd
delete pd
