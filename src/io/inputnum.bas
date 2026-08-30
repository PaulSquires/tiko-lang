'' input.bas -- the numeric INPUT converters: eleven entry points over nine fbc
'' members.
''
'' Each asks fb_FileInputNextToken for the next token and converts it. The
'' TOKENISER stays fbc's -- it knows about delimiters, quoting and the device --
'' so this module is the CONVERSION, which is where the rules live.
''
'' ================================================== LENGTH PICKS THE PARSER
''
'' Not the destination type: the LENGTH OF THE TOKEN decides which parser runs.
''
''     len <= 9    fb_hStr2Int         FB_INPUT_MAXINTLEN
''     len <= 18   fb_hStr2Longint     FB_INPUT_MAXLONGLEN
''     longer      strtod / strtof, unless it starts with '&'
''
'' The 9 and the 18 are "the most digits that can SAFELY be parsed as" each type
'' -- deliberately conservative, since 10 digits often fit an int. A token one
'' digit over takes the wider path and gets the same answer more slowly.
''
'' THE '&' CHECK IS WHY A LONG RADIX LITERAL STILL WORKS. "&B" plus 64 binary
'' digits is 66 characters, far past both limits, and strtod would parse it as 0.
'' Testing the first character routes it back to the integer parser --
'' FB_INPUT_MAXNUMERICLEN is sized for exactly that token: 2 + 64 + 1.
''
'' AND A FLOATING-POINT TOKEN IS ROUNDED, NOT TRUNCATED, on its way to an
'' integer: rint, not a cast. INPUT of "2.7" into an INTEGER gives 3.

#include once "inc/descriptors.bi"
#include once "crt/math.bi"
#include once "crt/stdlib.bi"

const FB_RTERROR_OK = 0
const FB_INPUT_MAXINTLEN  = 9
const FB_INPUT_MAXLONGLEN = 18
const FB_INPUT_MAXNUMERICLEN = (2 + 64) + 1

extern "rtlib"
	declare function tkrt_ErrorSetNum alias "fb_ErrorSetNum" ( byval e as long ) as long
	declare function tkrt_Str2Int alias "fb_hStr2Int" _
		( byval s as zstring ptr, byval length as integer ) as long
	declare function tkrt_Str2UInt alias "fb_hStr2UInt" _
		( byval s as zstring ptr, byval length as integer ) as ulong
	declare function tkrt_Str2Longint alias "fb_hStr2Longint" _
		( byval s as zstring ptr, byval length as integer ) as longint
	declare function tkrt_Str2ULongint alias "fb_hStr2ULongint" _
		( byval s as zstring ptr, byval length as integer ) as ulongint
	declare function tkrt_Str2Double alias "fb_hStr2Double" _
		( byval s as zstring ptr, byval length as integer ) as double
	declare function tkrt_Str2Bool alias "fb_hStr2Bool" _
		( byval s as zstring ptr, byval length as integer ) as long
end extern

extern "c"   '' NON-FBCALL: the tokeniser stays fbc's.
	declare function tkrt_NextToken alias "fb_FileInputNextToken" _
		( byval buffer as zstring ptr, byval maxlen as long, byval isstring as long, _
		  byval isfp as long ptr ) as integer
end extern

#macro INPUT_SIGNED( dst, ty )
	scope
		dim as zstring * (FB_INPUT_MAXNUMERICLEN + 1) buffer
		dim as long isfp = any
		dim as integer length = tkrt_NextToken( @buffer, FB_INPUT_MAXNUMERICLEN, 0, @isfp )
		if( isfp = 0 ) then
			*dst = cast( ty, tkrt_Str2Int( @buffer, length ) )
		else
			*dst = cast( ty, rint( tkrt_Str2Double( @buffer, length ) ) )
		end if
	end scope
	return tkrt_ErrorSetNum( FB_RTERROR_OK )
#endmacro

#macro INPUT_UNSIGNED( dst, ty )
	scope
		dim as zstring * (FB_INPUT_MAXNUMERICLEN + 1) buffer
		dim as long isfp = any
		dim as integer length = tkrt_NextToken( @buffer, FB_INPUT_MAXNUMERICLEN, 0, @isfp )
		if( isfp = 0 ) then
			*dst = cast( ty, tkrt_Str2UInt( @buffer, length ) )
		else
			*dst = cast( ty, rint( tkrt_Str2Double( @buffer, length ) ) )
		end if
	end scope
	return tkrt_ErrorSetNum( FB_RTERROR_OK )
#endmacro

#macro INPUT_FP( dst, ty, strtofn )
	scope
		dim as zstring * (FB_INPUT_MAXNUMERICLEN + 1) buffer
		dim as long isfp = any
		dim as integer length = tkrt_NextToken( @buffer, FB_INPUT_MAXNUMERICLEN, 0, @isfp )
		if( isfp = 0 ) then
			if( length <= FB_INPUT_MAXINTLEN ) then
				*dst = cast( ty, tkrt_Str2Int( @buffer, length ) )
			elseif( length <= FB_INPUT_MAXLONGLEN ) then
				*dst = cast( ty, tkrt_Str2Longint( @buffer, length ) )
			else
				if( buffer[0] = asc( "&" ) ) then
					*dst = cast( ty, tkrt_Str2Longint( @buffer, length ) )
				else
					*dst = cast( ty, strtofn( @buffer, 0 ) )
				end if
			end if
		else
			*dst = cast( ty, strtofn( @buffer, 0 ) )
		end if
	end scope
	return tkrt_ErrorSetNum( FB_RTERROR_OK )
#endmacro

extern "rtlib"

function tkort_InputByte alias "fb_InputByte" ( byval dst as byte ptr ) as long
	INPUT_SIGNED( dst, byte )
end function

function tkort_InputShort alias "fb_InputShort" ( byval dst as short ptr ) as long
	INPUT_SIGNED( dst, short )
end function

function tkort_InputInt alias "fb_InputInt" ( byval dst as long ptr ) as long
	INPUT_SIGNED( dst, long )
end function

function tkort_InputUbyte alias "fb_InputUbyte" ( byval dst as ubyte ptr ) as long
	INPUT_UNSIGNED( dst, ubyte )
end function

function tkort_InputUshort alias "fb_InputUshort" ( byval dst as ushort ptr ) as long
	INPUT_UNSIGNED( dst, ushort )
end function

function tkort_InputUint alias "fb_InputUint" ( byval dst as ulong ptr ) as long
	INPUT_UNSIGNED( dst, ulong )
end function

function tkort_InputSingle alias "fb_InputSingle" ( byval dst as single ptr ) as long
	INPUT_FP( dst, single, strtof )
end function

function tkort_InputDouble alias "fb_InputDouble" ( byval dst as double ptr ) as long
	INPUT_FP( dst, double, strtod )
end function

'' THE 64-BIT FORMS TAKE THE LENGTH BRANCH: a short token goes to the 32-bit
'' parser and only a long one to the 64-bit parser.
function tkort_InputLongint alias "fb_InputLongint" ( byval dst as longint ptr ) as long
	dim as zstring * (FB_INPUT_MAXNUMERICLEN + 1) buffer
	dim as long isfp = any
	dim as integer length = tkrt_NextToken( @buffer, FB_INPUT_MAXNUMERICLEN, 0, @isfp )
	if( isfp = 0 ) then
		if( length <= FB_INPUT_MAXINTLEN ) then
			*dst = tkrt_Str2Int( @buffer, length )
		else
			*dst = tkrt_Str2Longint( @buffer, length )
		end if
	else
		*dst = cast( longint, rint( tkrt_Str2Double( @buffer, length ) ) )
	end if
	return tkrt_ErrorSetNum( FB_RTERROR_OK )
end function

'' NOTE THE SIGNED PARSER ON THE SHORT PATH, even though the destination is
'' unsigned: fbc routes a short token through fb_hStr2Int and then casts, so
'' "-1" read into a ULONGINT becomes 18446744073709551615 rather than 0. The
'' long path uses the unsigned parser, so the two disagree on a negative token
'' purely by its LENGTH.
function tkort_InputUlongint alias "fb_InputUlongint" ( byval dst as ulongint ptr ) as long
	dim as zstring * (FB_INPUT_MAXNUMERICLEN + 1) buffer
	dim as long isfp = any
	dim as integer length = tkrt_NextToken( @buffer, FB_INPUT_MAXNUMERICLEN, 0, @isfp )
	if( isfp = 0 ) then
		if( length <= FB_INPUT_MAXINTLEN ) then
			*dst = cast( ulongint, cast( longint, tkrt_Str2Int( @buffer, length ) ) )
		else
			*dst = tkrt_Str2ULongint( @buffer, length )
		end if
	else
		*dst = cast( ulongint, rint( tkrt_Str2Double( @buffer, length ) ) )
	end if
	return tkrt_ErrorSetNum( FB_RTERROR_OK )
end function

'' No floating-point branch: the bool parser handles every token itself.
function tkort_InputBool alias "fb_InputBool" ( byval dst as byte ptr ) as long
	dim as zstring * (FB_INPUT_MAXNUMERICLEN + 1) buffer
	dim as long isfp = any
	dim as integer length = tkrt_NextToken( @buffer, FB_INPUT_MAXNUMERICLEN, 0, @isfp )
	*dst = cast( byte, tkrt_Str2Bool( @buffer, length ) )
	return tkrt_ErrorSetNum( FB_RTERROR_OK )
end function

end extern

'' ============================================================ THE QB DIALECT
''
'' Six more, identical in shape to the ones above and differing in ONE THING:
'' every parser is the QB variant. fbc's own header says why -- "&H/&O/&B
'' misreading as VAL and READ" -- so typing &hffff at an INPUT prompt gives what
'' QB gave.
''
'' THAT MEANS THE SIGN-BIT RULE APPLIES HERE TOO: a prefixed literal that fits a
'' QB INTEGER **is** one, so INPUT of &hFFFF into an INTEGER yields -1 where the
'' non-QB form yields 65535. Same token, same destination, different entry point.
''
'' Note the floating-point arm uses fb_hStr2DoubleQB rather than strtod for the
'' INTEGER destinations, but the SINGLE and DOUBLE destinations still fall
'' through to strtof/strtod on the long path -- the QB parsers only cover the
'' integral and radix cases.

extern "rtlib"
	declare function tkrt_Str2IntQB alias "fb_hStr2IntQB" _
		( byval s as zstring ptr, byval length as integer ) as long
	declare function tkrt_Str2UIntQB alias "fb_hStr2UIntQB" _
		( byval s as zstring ptr, byval length as integer ) as ulong
	declare function tkrt_Str2LongintQB alias "fb_hStr2LongintQB" _
		( byval s as zstring ptr, byval length as integer ) as longint
	declare function tkrt_Str2ULongintQB alias "fb_hStr2ULongintQB" _
		( byval s as zstring ptr, byval length as integer ) as ulongint
	declare function tkrt_Str2DoubleQB alias "fb_hStr2DoubleQB" _
		( byval s as zstring ptr, byval length as integer ) as double
end extern

extern "rtlib"

function tkort_InputIntQB alias "fb_InputIntQB" ( byval dst as long ptr ) as long
	dim as zstring * (FB_INPUT_MAXNUMERICLEN + 1) buffer
	dim as long isfp = any
	dim as integer length = tkrt_NextToken( @buffer, FB_INPUT_MAXNUMERICLEN, 0, @isfp )
	if( isfp = 0 ) then
		*dst = tkrt_Str2IntQB( @buffer, length )
	else
		*dst = cast( long, rint( tkrt_Str2DoubleQB( @buffer, length ) ) )
	end if
	return tkrt_ErrorSetNum( FB_RTERROR_OK )
end function

function tkort_InputUintQB alias "fb_InputUintQB" ( byval dst as ulong ptr ) as long
	dim as zstring * (FB_INPUT_MAXNUMERICLEN + 1) buffer
	dim as long isfp = any
	dim as integer length = tkrt_NextToken( @buffer, FB_INPUT_MAXNUMERICLEN, 0, @isfp )
	if( isfp = 0 ) then
		*dst = tkrt_Str2UIntQB( @buffer, length )
	else
		*dst = cast( ulong, rint( tkrt_Str2DoubleQB( @buffer, length ) ) )
	end if
	return tkrt_ErrorSetNum( FB_RTERROR_OK )
end function

function tkort_InputLongintQB alias "fb_InputLongintQB" ( byval dst as longint ptr ) as long
	dim as zstring * (FB_INPUT_MAXNUMERICLEN + 1) buffer
	dim as long isfp = any
	dim as integer length = tkrt_NextToken( @buffer, FB_INPUT_MAXNUMERICLEN, 0, @isfp )
	if( isfp = 0 ) then
		if( length <= FB_INPUT_MAXINTLEN ) then
			*dst = tkrt_Str2IntQB( @buffer, length )
		else
			*dst = tkrt_Str2LongintQB( @buffer, length )
		end if
	else
		*dst = cast( longint, rint( tkrt_Str2DoubleQB( @buffer, length ) ) )
	end if
	return tkrt_ErrorSetNum( FB_RTERROR_OK )
end function

function tkort_InputUlongintQB alias "fb_InputUlongintQB" ( byval dst as ulongint ptr ) as long
	dim as zstring * (FB_INPUT_MAXNUMERICLEN + 1) buffer
	dim as long isfp = any
	dim as integer length = tkrt_NextToken( @buffer, FB_INPUT_MAXNUMERICLEN, 0, @isfp )
	if( isfp = 0 ) then
		if( length <= FB_INPUT_MAXINTLEN ) then
			*dst = cast( ulongint, cast( longint, tkrt_Str2IntQB( @buffer, length ) ) )
		else
			*dst = tkrt_Str2ULongintQB( @buffer, length )
		end if
	else
		*dst = cast( ulongint, rint( tkrt_Str2DoubleQB( @buffer, length ) ) )
	end if
	return tkrt_ErrorSetNum( FB_RTERROR_OK )
end function

'' The QB parsers cover the integral and radix cases; the long non-radix path
'' still reaches strtof / strtod.
#macro INPUT_FP_QB( dst, ty, strtofn )
	scope
		dim as zstring * (FB_INPUT_MAXNUMERICLEN + 1) buffer
		dim as long isfp = any
		dim as integer length = tkrt_NextToken( @buffer, FB_INPUT_MAXNUMERICLEN, 0, @isfp )
		if( isfp = 0 ) then
			if( length <= FB_INPUT_MAXINTLEN ) then
				*dst = cast( ty, tkrt_Str2IntQB( @buffer, length ) )
			elseif( length <= FB_INPUT_MAXLONGLEN ) then
				*dst = cast( ty, tkrt_Str2LongintQB( @buffer, length ) )
			else
				if( buffer[0] = asc( "&" ) ) then
					*dst = cast( ty, tkrt_Str2LongintQB( @buffer, length ) )
				else
					*dst = cast( ty, strtofn( @buffer, 0 ) )
				end if
			end if
		else
			*dst = cast( ty, strtofn( @buffer, 0 ) )
		end if
	end scope
	return tkrt_ErrorSetNum( FB_RTERROR_OK )
#endmacro

function tkort_InputSingleQB alias "fb_InputSingleQB" ( byval dst as single ptr ) as long
	INPUT_FP_QB( dst, single, strtof )
end function

function tkort_InputDoubleQB alias "fb_InputDoubleQB" ( byval dst as double ptr ) as long
	INPUT_FP_QB( dst, double, strtod )
end function

end extern
