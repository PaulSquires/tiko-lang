'' BASIC's result assignment, lowered. Measured from fbc's own C:
''
''     int64 F( int64 N$1 ) {
''         int64 fb$result$1;
''         __builtin_memset( &fb$result$1, 0, 8ll );
''         fb$result$1 = 7ll;
''         return fb$result$1;
''     }
''
'' Zero-initialised and returned unconditionally, so a function that assigns nothing
'' returns zero rather than whatever the stack held. Both spellings reach it -- the
'' keyword form and the procedure's own name.
''
'' G returns a STRING, whose result goes through a hidden pointer tiko-lang does not model.
'' It DECLINES ('amb result-noslot'), which is the honest answer: storing into an
'' invented slot would compile and be wrong.

function A( ) as integer
	A = 3
end function
function B( ) as double
	function = 1.5
end function
function C( ) as integer
	function = 4
	return
end function
function D( ) as integer
	return 5
end function
sub E( )
end sub
function G( ) as string
	function = "s"
end function
print A( ), B( ), C( ), D( ), G( )
