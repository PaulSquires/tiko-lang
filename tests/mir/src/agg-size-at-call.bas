'' AN AGGREGATE'S SIZE HAS TO REACH THE CALL SITE, in three places that had no way to
'' find it -- and every one rendered '[0 x i8]', which LLVM matches against the value's
'' own definition and refuses.
''
''   1  the result of an 'operator []' that returns BYREF. The address is the call's
''      result, a temp with no slot to measure, so 'load [0 x i8]' came out of it.
''   2  an aggregate ARGUMENT of an INDIRECT call -- a virtual method, where the
''      callee is a vtable slot and there is no signature to ask.
''   3  an aggregate RETURN of an indirect call, for the same reason. Lowering writes
''      the size into the instruction now, because nothing downstream can recover it.
''
'' fb/tuiwidget.bi is all three: a focus ring indexes an Array( of TuiRect ) through
'' 'operator []' and hands the result to a virtual Render.
type R16
	as integer a, b
end type

type Holder
	as R16 items( 0 to 3 )
	declare operator [] ( byval i as long ) byref as R16
end type

operator Holder.[] ( byval i as long ) byref as R16
	return items( i )
end operator

type Sink extends object
	declare abstract sub Take( byval r as R16 )
	declare abstract function Make( ) as R16
end type

type RealSink extends Sink
	as integer seen
	declare sub Take( byval r as R16 )
	declare function Make( ) as R16
end type

sub RealSink.Take( byval r as R16 )
	this.seen = r.a + r.b
end sub

function RealSink.Make( ) as R16
	dim as R16 r
	r.a = 5 : r.b = 6
	return r
end function

dim as Holder h
h.items( 2 ).a = 1 : h.items( 2 ).b = 2

dim as RealSink rs
dim as Sink ptr s = @rs

'' (1) and (2): an indexed aggregate through a virtual call
s->Take( h[ 2 ] )
print rs.seen

'' (3): an aggregate returned from a virtual call
dim as R16 got = s->Make( )
print got.a; got.b
