'' 'DELETE' THROUGH A BASE POINTER DISPATCHES A VIRTUAL DESTRUCTOR.
''
'' Measured, fbc emits
''
''     (*(tmp$4*)*(void***)P$0)( P$0 );  free( (void*)P$0 );
''
'' and prints 'DB'. tiko called the base's destructor by name and printed 'B': every
'' derived destructor was skipped, so fb/tuiwidget.bi's containers -- which own their
'' children as 'TuiWidget ptr' -- leaked all of them.
''
'' A NON-virtual destructor is still called directly, as fbc calls it.

type Shape extends object
	declare virtual destructor( )
end type
destructor Shape( )
	print "B";
end destructor

type Square extends Shape
	declare destructor( ) override
end type
destructor Square( )
	print "D";
end destructor

type Plain
	as long n
	declare destructor( )
end type
destructor Plain( )
	print "P";
end destructor

dim as Shape ptr p = new Square
delete p

dim as Plain ptr q = new Plain
delete q
print
