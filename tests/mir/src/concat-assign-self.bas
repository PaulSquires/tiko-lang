'' A STRING APPENDED TO ITSELF is a concatenation into a temporary and one assign, never an
'' in-place fb_StrConcatAssign: that reallocs the target and then copies from the source
'' pointer read before the realloc -- a freed block. Measured, fbc 1.10.1 emits
'' 'vr = fb_StrConcat( &TMP, &S, -1, &S, -1 )' and 'fb_StrAssign( &S, -1, vr, -1, 0 )' for
'' every row below (a byref and a deref target as well); the ustring rows are its twin.

type T
	as string s
	as ustring u
end type

sub viaref( byref r as string )
	r &= r
end sub

dim as string s = "ab"
s &= s
s += s
dim as T x
x.s &= x.s
x.u &= x.u
dim as string ptr p = @s
*p &= *p
dim as ustring u = "ab"
u &= u
u += u
viaref( s )
