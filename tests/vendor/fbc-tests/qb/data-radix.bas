' TEST_MODE : COMPILE_AND_RUN_OK

'' In -lang qb the parser stores DATA items as raw TEXT and READ converts
'' them at runtime, so READ has to apply the same QB rule as VAL: "&hffff"
'' is a 16bit signed INTEGER, i.e. -1, unless a '&' suffix widens it.

#define ASSERT(e) if (e) = 0 then fb_Assert(__FILE__, __LINE__, __FUNCTION__, #e)

	dim i as integer        '' 16bit in -lang qb
	dim l as long           '' 32bit
	dim s as single
	dim d as double

	'' the reported case: every destination must see -1
	read i : assert( i = -1 )
	read l : assert( l = -1 )
	read s : assert( s = -1 )
	read d : assert( d = -1 )
	data &hffff, &hffff, &hffff, &hffff

	'' the '&' (LONG) suffix widens it instead
	read l : assert( l = 65535 )
	read d : assert( d = 65535 )
	data &hffff&, &o177777&

	'' 32bit values
	read l : assert( l = -1 )
	read d : assert( d = -1 )
	data &hffffffff, &hffffffff

	read l : assert( l = 65536 )
	read l : assert( l = 2147483647 )
	read l : assert( l = (-2147483647 - 1) )
	data &h10000, &h7fffffff, &h80000000

	'' octal and binary follow the same rule
	read l : assert( l = -1 )
	read l : assert( l = -1 )
	read l : assert( l = -1 )
	data &o177777, &b1111111111111111, &177777

	'' positive values that fit are unchanged
	read i : assert( i = 32767 )
	read l : assert( l = 32767 )
	read s : assert( s = -32768 )
	data &h7fff, &h7fff, &h8000

	'' decimal DATA is untouched
	read l : assert( l = 65535 )
	read d : assert( d = 123.5 )
	read l : assert( l = -1 )
	data 65535, 123.5, -1
