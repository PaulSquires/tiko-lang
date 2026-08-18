' TEST_MODE : COMPILE_AND_RUN_OK

'' INPUT converts the typed text at runtime, so it needs the same QB rule
'' as VAL and READ: "&hffff" is a 16bit signed INTEGER, i.e. -1.
''
'' Console INPUT and INPUT # share the fb_Input*() entry points, so driving
'' it from a file tests the same code the prompt would run.

#define ASSERT(e) if (e) = 0 then fb_Assert(__FILE__, __LINE__, __FUNCTION__, #e)

	dim i as integer        '' 16bit in -lang qb
	dim l as long           '' 32bit
	dim s as single
	dim d as double

	open "input-radix.tmp" for output as #1
	print #1, "&hffff"
	print #1, "&hffff"
	print #1, "&hffff"
	print #1, "&hffff"
	print #1, "&hffff&"
	print #1, "&hffffffff"
	print #1, "&h10000"
	print #1, "&o177777"
	print #1, "&b1111111111111111"
	print #1, "65535"
	print #1, "123.5"
	close #1

	open "input-radix.tmp" for input as #1

	'' the reported case: every destination must see -1
	input #1, i : assert( i = -1 )
	input #1, l : assert( l = -1 )
	input #1, s : assert( s = -1 )
	input #1, d : assert( d = -1 )

	'' the '&' (LONG) suffix widens it instead
	input #1, l : assert( l = 65535 )

	'' 32bit values
	input #1, l : assert( l = -1 )
	input #1, l : assert( l = 65536 )

	'' octal and binary follow the same rule
	input #1, l : assert( l = -1 )
	input #1, l : assert( l = -1 )

	'' decimal is untouched
	input #1, l : assert( l = 65535 )
	input #1, d : assert( d = 123.5 )

	close #1

	kill "input-radix.tmp"
