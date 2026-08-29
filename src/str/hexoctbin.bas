'' hexoctbin.bas -- HEX, OCT and BIN for STRING: thirty entry points over nine
'' fbc members.
''
'' ONLY THREE OF THE THIRTY ARE REAL. fb_HEXEx_l, fb_OCTEx_l and fb_BINEx_l do
'' the work; the other twenty-seven are forwards that exist so the compiler can
'' pick an overload by argument type. Reproducing that shape rather than
'' collapsing it matters for one reason only -- the SYMBOLS have to exist, with
'' fbc's exact names and, on win32, fbc's exact @N decoration.
''
'' THE POINTER FORMS ARE WIDTH-DEPENDENT: fb_HEX_p forwards to the 64-bit
'' routine on a 64-bit host and the 32-bit one elsewhere, so ANY PTR prints its
'' natural width rather than a padded one.

#include once "inc/descriptors.bi"
#include once "inc/ctx.bi"

extern "rtlib"
	declare function tkrt_AllocTemp alias "fb_hStrAllocTemp" _
		( byval s as FBSTRING ptr, byval length as integer ) as FBSTRING ptr
end extern

#define RDX( n )   hs_##n
#define RDX_UNIT   ubyte
#include once "inc/radix-core.bi"

'' The one real routine per radix. Everything else forwards here.
private function hRadix _
	( byval num as ulongint, byval digits as long, _
	  byval shift as long, byval mask as ulongint, byval ishex as long ) as FBSTRING ptr

	if( digits <= 0 ) then digits = hs_hDigits( num, shift )

	dim as FBSTRING ptr s = tkrt_AllocTemp( 0, digits )
	if( s = 0 ) then return TKORT_NULLSTR()

	hs_hFill( cptr( ubyte ptr, s->data ), num, digits, shift, mask, ishex )

	s->data[digits] = 0
	return s

end function

extern "rtlib"

'' ------------------------------------------------------------------- HEX

function tkort_HEXEx_l alias "fb_HEXEx_l" _
	( byval num as ulongint, byval digits as long ) as FBSTRING ptr
	return hRadix( num, digits, 4, 15, 1 )
end function

function tkort_HEX_l alias "fb_HEX_l" ( byval num as ulongint ) as FBSTRING ptr
	return tkort_HEXEx_l( num, 0 )
end function

function tkort_HEXEx_b alias "fb_HEXEx_b" _
	( byval num as ubyte, byval digits as long ) as FBSTRING ptr
	return tkort_HEXEx_l( num, digits )
end function
function tkort_HEXEx_s alias "fb_HEXEx_s" _
	( byval num as ushort, byval digits as long ) as FBSTRING ptr
	return tkort_HEXEx_l( num, digits )
end function
function tkort_HEXEx_i alias "fb_HEXEx_i" _
	( byval num as ulong, byval digits as long ) as FBSTRING ptr
	return tkort_HEXEx_l( num, digits )
end function
function tkort_HEX_b alias "fb_HEX_b" ( byval num as ubyte ) as FBSTRING ptr
	return tkort_HEXEx_l( num, 0 )
end function
function tkort_HEX_s alias "fb_HEX_s" ( byval num as ushort ) as FBSTRING ptr
	return tkort_HEXEx_l( num, 0 )
end function
function tkort_HEX_i alias "fb_HEX_i" ( byval num as ulong ) as FBSTRING ptr
	return tkort_HEXEx_l( num, 0 )
end function

'' ------------------------------------------------------------------- OCT

function tkort_OCTEx_l alias "fb_OCTEx_l" _
	( byval num as ulongint, byval digits as long ) as FBSTRING ptr
	return hRadix( num, digits, 3, 7, 0 )
end function

function tkort_OCT_l alias "fb_OCT_l" ( byval num as ulongint ) as FBSTRING ptr
	return tkort_OCTEx_l( num, 0 )
end function

function tkort_OCTEx_b alias "fb_OCTEx_b" _
	( byval num as ubyte, byval digits as long ) as FBSTRING ptr
	return tkort_OCTEx_l( num, digits )
end function
function tkort_OCTEx_s alias "fb_OCTEx_s" _
	( byval num as ushort, byval digits as long ) as FBSTRING ptr
	return tkort_OCTEx_l( num, digits )
end function
function tkort_OCTEx_i alias "fb_OCTEx_i" _
	( byval num as ulong, byval digits as long ) as FBSTRING ptr
	return tkort_OCTEx_l( num, digits )
end function
function tkort_OCT_b alias "fb_OCT_b" ( byval num as ubyte ) as FBSTRING ptr
	return tkort_OCTEx_l( num, 0 )
end function
function tkort_OCT_s alias "fb_OCT_s" ( byval num as ushort ) as FBSTRING ptr
	return tkort_OCTEx_l( num, 0 )
end function
function tkort_OCT_i alias "fb_OCT_i" ( byval num as ulong ) as FBSTRING ptr
	return tkort_OCTEx_l( num, 0 )
end function

'' ------------------------------------------------------------------- BIN

function tkort_BINEx_l alias "fb_BINEx_l" _
	( byval num as ulongint, byval digits as long ) as FBSTRING ptr
	return hRadix( num, digits, 1, 1, 0 )
end function

function tkort_BIN_l alias "fb_BIN_l" ( byval num as ulongint ) as FBSTRING ptr
	return tkort_BINEx_l( num, 0 )
end function

function tkort_BINEx_b alias "fb_BINEx_b" _
	( byval num as ubyte, byval digits as long ) as FBSTRING ptr
	return tkort_BINEx_l( num, digits )
end function
function tkort_BINEx_s alias "fb_BINEx_s" _
	( byval num as ushort, byval digits as long ) as FBSTRING ptr
	return tkort_BINEx_l( num, digits )
end function
function tkort_BINEx_i alias "fb_BINEx_i" _
	( byval num as ulong, byval digits as long ) as FBSTRING ptr
	return tkort_BINEx_l( num, digits )
end function
function tkort_BIN_b alias "fb_BIN_b" ( byval num as ubyte ) as FBSTRING ptr
	return tkort_BINEx_l( num, 0 )
end function
function tkort_BIN_s alias "fb_BIN_s" ( byval num as ushort ) as FBSTRING ptr
	return tkort_BINEx_l( num, 0 )
end function
function tkort_BIN_i alias "fb_BIN_i" ( byval num as ulong ) as FBSTRING ptr
	return tkort_BINEx_l( num, 0 )
end function

'' ------------------------------------------------------- the pointer forms

function tkort_HEX_p alias "fb_HEX_p" ( byval p as any ptr ) as FBSTRING ptr
	'' Branch on sizeof, not #ifdef: the dead half still compiles -- and it has to,
	'' because the 64-bit arm is what failed on WIN32. `cast( ulongint, p )` on a
	'' 32-bit pointer is error 20; the cast has to go through pointer width
	'' first. The arm is unreachable there, but it is still compiled.
	if( sizeof( any ptr ) = 8 ) then
		return tkort_HEXEx_l( cast( ulongint, cast( uinteger, p ) ), 0 )
	else
		return tkort_HEXEx_i( cast( ulong, cast( uinteger, p ) ), 0 )
	end if
end function

function tkort_HEXEx_p alias "fb_HEXEx_p" _
	( byval p as any ptr, byval digits as long ) as FBSTRING ptr
	if( sizeof( any ptr ) = 8 ) then
		return tkort_HEXEx_l( cast( ulongint, cast( uinteger, p ) ), digits )
	else
		return tkort_HEXEx_i( cast( ulong, cast( uinteger, p ) ), digits )
	end if
end function

function tkort_OCT_p alias "fb_OCT_p" ( byval p as any ptr ) as FBSTRING ptr
	if( sizeof( any ptr ) = 8 ) then
		return tkort_OCTEx_l( cast( ulongint, cast( uinteger, p ) ), 0 )
	else
		return tkort_OCTEx_i( cast( ulong, cast( uinteger, p ) ), 0 )
	end if
end function

function tkort_OCTEx_p alias "fb_OCTEx_p" _
	( byval p as any ptr, byval digits as long ) as FBSTRING ptr
	if( sizeof( any ptr ) = 8 ) then
		return tkort_OCTEx_l( cast( ulongint, cast( uinteger, p ) ), digits )
	else
		return tkort_OCTEx_i( cast( ulong, cast( uinteger, p ) ), digits )
	end if
end function

function tkort_BIN_p alias "fb_BIN_p" ( byval p as any ptr ) as FBSTRING ptr
	if( sizeof( any ptr ) = 8 ) then
		return tkort_BINEx_l( cast( ulongint, cast( uinteger, p ) ), 0 )
	else
		return tkort_BINEx_i( cast( ulong, cast( uinteger, p ) ), 0 )
	end if
end function

function tkort_BINEx_p alias "fb_BINEx_p" _
	( byval p as any ptr, byval digits as long ) as FBSTRING ptr
	if( sizeof( any ptr ) = 8 ) then
		return tkort_BINEx_l( cast( ulongint, cast( uinteger, p ) ), digits )
	else
		return tkort_BINEx_i( cast( ulong, cast( uinteger, p ) ), digits )
	end if
end function

end extern
