dim shared as byte gb(15)
type TB
    as long a
end type
type TD extends TB
    as long c
end type
type UU
    as long v
    declare operator cast( ) as ubyte ptr
end type
operator UU.cast( ) as ubyte ptr : return cast( ubyte ptr, @gb(0) ) : end operator
type US
    as long v
    declare operator cast( ) as ushort ptr
end type
operator US.cast( ) as ushort ptr : return cast( ushort ptr, @gb(0) ) : end operator
type UH
    as long v
    declare operator cast( ) as short ptr
end type
operator UH.cast( ) as short ptr : return cast( short ptr, @gb(0) ) : end operator
type UD
    as long v
    declare operator cast( ) as TD ptr
end type
operator UD.cast( ) as TD ptr : return cast( TD ptr, cast( any ptr, @gb(0) ) ) : end operator
type UAZ
    as long v
    declare operator cast( ) as zstring ptr
    declare operator cast( ) as any ptr
end type
operator UAZ.cast( ) as zstring ptr : return cast( zstring ptr, @gb(0) ) : end operator
operator UAZ.cast( ) as any ptr : return @gb(0) : end operator
type UZB
    as long v
    declare operator cast( ) as zstring ptr
    declare operator cast( ) as ubyte ptr
end type
operator UZB.cast( ) as zstring ptr : return cast( zstring ptr, @gb(0) ) : end operator
operator UZB.cast( ) as ubyte ptr : return cast( ubyte ptr, @gb(0) ) : end operator

sub sb( byval p as byte ptr ) : end sub
sub su( byval p as ubyte ptr ) : end sub
sub stb( byval p as TB ptr ) : end sub
function oz overload( byval p as zstring ptr ) as long : return 1 : end function
function oz overload( byval a as long, byval b as long ) as long : return 2 : end function
function ow overload( byval p as wstring ptr ) as long : return 1 : end function
function ow overload( byval a as long, byval b as long ) as long : return 2 : end function

dim as UU u
dim as US s
dim as UH h
dim as UD d
dim as UAZ az
dim as UZB zb
'' accepted beside the refusals: a single procedure takes them
sb( u )
'' refused: first in the parameter's row, in an overload set (fbc 99)
print oz( u )
print ow( s )
'' refused: another size, and derived to base (fbc 58)
sb( h )
stb( d )
'' refused: two casts at the best score (fbc 98)
su( az )
sb( zb )
'' an exact pointee scores the same const or not: two overloads, one each (fbc 98)
type UBC
    as long v
    declare operator cast( ) as byte ptr
    declare operator cast( ) as const zstring ptr
end type
operator UBC.cast( ) as byte ptr : return @gb(0) : end operator
operator UBC.cast( ) as const zstring ptr : return cast( const zstring ptr, @gb(0) ) : end operator
function tc overload( byval p as zstring ptr ) as long : return 1 : end function
function tc overload( byval p as byte ptr ) as long : return 2 : end function
dim as UBC bc
print tc( bc )
'' a 'string' parameter fed by a 'zstring ptr' cast: the bottom tier, tied (98), and alone (58)
type UZL
    as long v
    declare operator cast( ) as zstring ptr
    declare operator cast( ) as long ptr
end type
operator UZL.cast( ) as zstring ptr : return cast( zstring ptr, @gb(0) ) : end operator
operator UZL.cast( ) as long ptr : return cast( long ptr, @gb(0) ) : end operator
function ts overload( byval p as byte ptr ) as long : return 1 : end function
function ts overload( byref s as string ) as long : return 2 : end function
function tt overload( byref s as string ) as long : return 1 : end function
function tt overload( byval a as long, byval b as long ) as long : return 2 : end function
dim as UZL zl
print ts( zl )
print tt( zl )
'' an assignment that drops the picked cast's pointee 'const' (fbc 181); the initialiser takes it
type UCB
    as long v
    declare operator cast( ) as const byte ptr
end type
operator UCB.cast( ) as const byte ptr : return @gb(0) : end operator
dim as UCB cb
dim as zstring ptr pz = cb
pz = cb
'' one 'zstring ptr' cast, overloads taking 'byte ptr' and 'byref as string': both bottom tier (98)
type UZ1
    as long v
    declare operator cast( ) as zstring ptr
end type
operator UZ1.cast( ) as zstring ptr : return cast( zstring ptr, @gb(0) ) : end operator
dim as UZ1 z1
print ts( z1 )
