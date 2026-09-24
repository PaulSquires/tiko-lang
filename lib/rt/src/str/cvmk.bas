'' cvmk.bas -- CVI/CVL/CVS/CVD/CVSHORT/CVLONGINT and their MK twins: twelve
'' entry points, one fbc member.
''
'' These reinterpret a string's BYTES as a number and back. Nothing is parsed and
'' nothing is formatted -- MKI( 65 ) is a four- or eight-byte string of raw bytes,
'' not "65".
''
'' ============================================ THE CV/MK PAIR IS NOT A ROUND TRIP
''
'' fb_CVI reads sizeof( int ) -- FOUR bytes -- and returns an int.
'' fb_MKI writes sizeof( ssize_t ) -- EIGHT bytes on a 64-bit target.
''
'' So on win64 and linux-x86_64, CVI( MKI( x ) ) reads only the low half of what
'' MKI wrote. That is fbc's, it is visible to any program that pairs them, and it
'' is reproduced exactly. Making the two agree would be the obvious fix and would
'' put tiko-rt out of step with fbc on every 64-bit program that uses them.
''
'' fb_CVL is the same function as fb_CVI -- both read sizeof( int ) -- while
'' fb_MKL takes an int and writes four. So the L pair DOES round-trip and the I
'' pair does not, on the same target, for the same widths.
''
'' A SHORT STRING IS NOT AN ERROR. hCV leaves the destination at its initial zero
'' when the string holds fewer bytes than the type needs, so CVD( "ab" ) is 0.0
'' rather than garbage or a fault -- and the operand is still released.

#include once "inc/descriptors.bi"
#include once "inc/ctx.bi"
#include once "inc/sysbind.bi"

extern "rtlib"
	declare function tkrt_AllocTemp alias "fb_hStrAllocTemp" _
		( byval s as FBSTRING ptr, byval length as integer ) as FBSTRING ptr
	declare function tkrt_DelTemp alias "fb_hStrDelTemp" ( byval s as FBSTRING ptr ) as long
end extern

'' Copy `length` bytes out of the string, if it has that many, then RELEASE IT.
'' The release happens whether or not the copy did -- CVD( a + b ) hands in a
'' temporary either way.
private sub hCV( byval s as FBSTRING ptr, byval length as integer, byval num as any ptr )

	if( s = 0 ) then exit sub

	if( s->data <> 0 ) then
		if( FB_STRSIZE( s ) >= length ) then
			memcpy( num, s->data, length )
		end if
	end if

	tkrt_DelTemp( s )

end sub

private function hMK( byval length as integer, byval num as any ptr ) as FBSTRING ptr

	dim as FBSTRING ptr dst = tkrt_AllocTemp( 0, length )
	if( dst = 0 ) then return TKORT_NULLSTR()

	memcpy( dst->data, num, length )
	dst->data[length] = 0
	return dst

end function

extern "rtlib"

'' ------------------------------------------------------------------- CV

function tkort_CVSHORT alias "fb_CVSHORT" ( byval s as FBSTRING ptr ) as short
	dim as short num = 0
	hCV( s, sizeof( short ), @num )
	return num
end function

'' FOUR bytes, not pointer-width -- see the header.
function tkort_CVI alias "fb_CVI" ( byval s as FBSTRING ptr ) as long
	dim as long num = 0
	hCV( s, sizeof( long ), @num )
	return num
end function

'' Identical to fb_CVI, deliberately: fbc gives both the same body.
function tkort_CVL alias "fb_CVL" ( byval s as FBSTRING ptr ) as long
	dim as long num = 0
	hCV( s, sizeof( long ), @num )
	return num
end function

function tkort_CVLONGINT alias "fb_CVLONGINT" ( byval s as FBSTRING ptr ) as longint
	dim as longint num = 0
	hCV( s, sizeof( longint ), @num )
	return num
end function

function tkort_CVS alias "fb_CVS" ( byval s as FBSTRING ptr ) as single
	dim as single num = 0.0
	hCV( s, sizeof( single ), @num )
	return num
end function

function tkort_CVD alias "fb_CVD" ( byval s as FBSTRING ptr ) as double
	dim as double num = 0.0
	hCV( s, sizeof( double ), @num )
	return num
end function

'' ------------------------------------------------------------------- MK

function tkort_MKSHORT alias "fb_MKSHORT" ( byval num as short ) as FBSTRING ptr
	dim as short v = num
	return hMK( sizeof( short ), @v )
end function

'' POINTER-WIDTH, not four -- the half of the asymmetry the header describes.
function tkort_MKI alias "fb_MKI" ( byval num as integer ) as FBSTRING ptr
	dim as integer v = num
	return hMK( sizeof( integer ), @v )
end function

function tkort_MKL alias "fb_MKL" ( byval num as long ) as FBSTRING ptr
	dim as long v = num
	return hMK( sizeof( long ), @v )
end function

function tkort_MKLONGINT alias "fb_MKLONGINT" ( byval num as longint ) as FBSTRING ptr
	dim as longint v = num
	return hMK( sizeof( longint ), @v )
end function

function tkort_MKS alias "fb_MKS" ( byval num as single ) as FBSTRING ptr
	dim as single v = num
	return hMK( sizeof( single ), @v )
end function

function tkort_MKD alias "fb_MKD" ( byval num as double ) as FBSTRING ptr
	dim as double v = num
	return hMK( sizeof( double ), @v )
end function

end extern
