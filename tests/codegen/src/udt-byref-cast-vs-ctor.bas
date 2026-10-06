'' beside TU( byref as TV ): only a byref TU parameter takes the cast
type _TV as TV
type TU
	dim as integer I
	declare constructor()
	declare constructor( byref u as TU )
	declare constructor( byref v as _TV )
	declare operator let( byref u as TU )
	declare operator let( byref v as _TV )
	declare destructor()
end type
type TV
	dim as integer I
	declare operator cast() byref as TU
end type
dim shared as TU u0
dim shared as TV v
constructor TU() : i = 1 : end constructor
constructor TU( byref u as TU ) : i = u.i : print "ctor<-TU"; : end constructor
constructor TU( byref q as TV ) : i = q.i : print "ctor<-TV"; : end constructor
operator TU.let( byref u as TU ) : i = u.i : print "let<-TU"; : end operator
operator TU.let( byref q as TV ) : i = q.i : print "let<-TV"; : end operator
destructor TU() : print "dtor"; : end destructor
operator TV.cast() byref as TU : print "cast"; : return u0 : end operator
sub s1( byval u as TU ) : end sub
sub s2( byref u as TU ) : end sub
print "A:"; : s1( v ) : print
print "B:"; : s2( v ) : print
print "C:"; : scope : dim as TU a = v : end scope : print
print "D:"; : scope : dim as TU a : a = v : end scope : print
