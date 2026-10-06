'' '#if typeof( procptr( T.member [, signature] ) )' -- fbc's text, compared with a procedure-type
'' typedef; and procptr's own overload picks: by result for casts, the FIRST declared with no signature
type T
	n as integer
	declare constructor()
	declare constructor( byval x as integer )
	declare destructor()
	declare sub proc()
	declare sub proc( byref x as const T )
	declare sub proc( byval x as integer )
	declare function func( byval x as integer ) as integer
	declare operator cast() as single
	declare operator cast() as integer
	declare operator cast() as string
end type
constructor T() : end constructor
constructor T( byval x as integer ) : end constructor
destructor T() : end destructor
sub T.proc() : print "proc()" : end sub
sub T.proc( byref x as const T ) : print "proc(T)" : end sub
sub T.proc( byval x as integer ) : print "proc(i)" : end sub
function T.func( byval x as integer ) as integer : return x * 2 : end function
operator T.cast() as single : return 1.5 : end operator
operator T.cast() as integer : return 7 : end operator
operator T.cast() as string : return "s" : end operator
type tfp_ctor as sub cdecl( byref as T )
type tfp_ctor_i as sub cdecl( byref as T, byval as integer )
type tfp_proc_T as sub( byref as T, byref as const T )
type tff as function( byref as T, byval as integer ) as integer
#if typeof( tfp_ctor ) = typeof( procptr( T.constructor ) )
print "ctor ok"
#endif
#if typeof( tfp_ctor_i ) = typeof( procptr( T.constructor, sub( byval as integer ) ) )
print "ctor(i) ok"
#endif
#if typeof( tfp_ctor ) = typeof( procptr( T.destructor ) )
print "dtor ok"
#endif
#if typeof( tfp_proc_T ) = typeof( procptr( T.proc, sub( byref as const T ) ) )
print "proc(T) ok"
#endif
#if typeof( tff ) = typeof( procptr( T.func, function( byval as integer ) as integer ) )
print "func ok"
#endif
#if typeof( tfp_proc_T ) = typeof( procptr( T.proc, sub( byval as integer ) ) )
print "wrong"
#else
print "proc(i) differs ok"
#endif
dim a as T
var f1 = procptr( T.cast, function() as single )
var f2 = procptr( T.cast, function() as integer )
var f3 = procptr( T.cast, function() as string )
print f1( a ), f2( a ), f3( a )
var p0 = procptr( T.proc )
p0( a )
print (p0 = procptr( T.proc, sub() ))
