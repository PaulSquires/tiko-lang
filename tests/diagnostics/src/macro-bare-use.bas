namespace NS
	enum Lvl
		LOWEST = 10
	end enum
end namespace
#define LOWEST( m ) print "macro:"; m
#define ZZ( m ) print m
type T
	as long ZZ
end type
using NS
dim as long a = LOWEST
select case a
case LOWEST
end select
print str( LOWEST )
dim as long b = ZZ
dim as T t
t.ZZ = 3
print NS.LOWEST
LOWEST( "called" )
ZZ( "called" )
