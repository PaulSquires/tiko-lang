type Obj
    as long tag
    declare property Nm( byval key as wstring ptr, byval v as long )
    declare property Nm( byval key as wstring ptr ) as long
    declare property Zp( byval key as zstring ptr, byval v as long )
end type
property Obj.Nm( byval key as wstring ptr, byval v as long ) : dim as string t = *key : print "N set ["; t; "]"; len( *key ); v : end property
property Obj.Nm( byval key as wstring ptr ) as long : dim as string t = *key : print "N get ["; t; "]"; len( *key ) : return 0 : end property
property Obj.Zp( byval key as zstring ptr, byval v as long ) : print "Z ["; *key; "]"; v : end property
dim as Obj o
dim as string s = "abcd"
dim as wstring * 10 w = "xyz"
dim as string * 6 f = "fix"
o.Nm( "Pattern" ) = 1
o.Nm( s ) = 2
o.Nm( w ) = 3
o.Nm( "lit" & s ) = 4
dim as long r = o.Nm( "Pattern" )
o.Zp( "Pattern" ) = 5
o.Zp( s ) = 6
o.Zp( "lit" & s ) = 7
o.Zp( f ) = 8
