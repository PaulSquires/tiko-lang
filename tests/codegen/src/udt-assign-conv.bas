'' u = v, function = v and return v over TV -> TU: the source's cast, a temporary from TU's converting
'' constructor, or the default constructor then the let ladder -- in fbc's order
type _TV as TV
type TU
	dim as integer i
	declare constructor()
	declare constructor( byref u as TU )
	declare constructor( byref v as _TV )
	declare operator let( byref u as TU )
end type
type TV
	dim as integer i
	declare operator cast() as TU
end type
type TU2
	dim as integer i
	declare constructor()
	declare operator let( byref u as TU2 )
	declare operator let( byref v as _TV )
end type
dim shared as TU u0
dim shared as TV v
constructor TU() : i = 1 : print "ctor() "; : end constructor
constructor TU( byref u as TU ) : i = u.i : print "ctor<-TU "; : end constructor
constructor TU( byref q as TV ) : i = q.i : print "ctor<-TV "; : end constructor
operator TU.let( byref u as TU ) : i = u.i : print "let<-TU "; : end operator
operator TV.cast() as TU : print "cast "; : return u0 : end operator
constructor TU2() : i = 2 : print "ctor2() "; : end constructor
operator TU2.let( byref u as TU2 ) : i = u.i : print "let2<-TU2 "; : end operator
operator TU2.let( byref q as TV ) : i = q.i : print "let2<-TV "; : end operator
function f1() as TU
	function = v
end function
function f2() as TU2
	return v
end function
print "|";
scope
	dim u as TU
	print "assign: ";
	u = v
	print
end scope
print "fn=: "; : f1() : print
print "return: "; : f2() : print
