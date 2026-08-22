'' BYREF ARGUMENTS THAT HAVE NO ADDRESS, and the two markers that decide which is
'' which. Every value here was measured out of the C fbc generates.

'' AN OMITTED OUTPUT IS A DEFAULTED BYREF PARAMETER, nothing more exotic. fbc
'' materialises a temporary holding the default and passes ITS address, so each
'' family's "sentinel" is only the value its own declaration carries: SCREENINFO's
'' outputs start at 0, SCREENCONTROL's at &h80000000, and GETJOYSTICK's axes at 0.0f.
dim as long a, b, r
screeninfo a
screeninfo a, b
r = getmouse( a, b )
r = imageinfo( 0, a )

'' GETJOYSTICK's buttons parameter is FreeBASIC 'integer' -- 64-bit here, 32 on win32 --
'' and fbc REJECTS a 'long' there with error 58 rather than converting it.
dim as integer btns
r = getjoystick( 0, btns )

'' A CALL WITH FEWER ARGUMENTS THAN PARAMETERS IS STILL A TYPED CALL. Viability used to
'' need exact arity, so this bound to nothing and the ASSIGNMENT declined -- while the
'' same call as a statement lowered, because nothing asked its type.
r = screenres( 320, 200 )

'' A byref parameter given a value that has no address of its own.
declare sub takesref( byref x as long )
takesref( 5 )

'' A byref UDT parameter defaulted from a UDT rvalue: the temporary is an AGGREGATE and
'' the store is the aggregate store, not a scalar one.
type Pt
    i as long
end type
declare sub takesudt( byref p as Pt = type<Pt>( 7 ) )
takesudt( )

'' A BYREF WSTRING IS A uint16* AND A BYREF ZSTRING A char* -- the DATA, never a
'' descriptor. A narrow STRING argument to a zstring parameter is the pointer LOADED
'' out of its descriptor, which is what fbc's '*(char**)&S' says.
declare sub takesw( byref w as wstring )
declare sub takesz( byref z as zstring )
dim as string s
dim as zstring * 8 zs
takesw( wstr( "a" ) )
takesw( "lit" )
takesz( "lit" )
takesz( zs )
takesz( s )

'' 'f( byval x )' OVERRIDES the byref parameter for one argument: the value goes where
'' the address would have. 'byref' is NOT a call-site marker -- fbc's error 1.
declare sub takesany( byref p as any )
dim as long i
takesany( byval @i )
takesany( i )

'' A CONSTANT passed to 'byref as any' is passed BY VALUE, with no temporary at all --
'' measured, and the only argument shape fbc singles out this way.
takesany( 0 )
