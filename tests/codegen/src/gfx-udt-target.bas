#include "fbgfx.bi"
open cons for output as #9
screenres 64, 64, 32, , FB.GFX_NULL
dim shared as integer na, ni, nf
type U1
	p as any ptr
	declare operator cast( ) as any ptr
	declare operator cast( ) as FB.IMAGE ptr
end type
operator U1.cast( ) as any ptr : na += 1 : operator = p : end operator
operator U1.cast( ) as FB.IMAGE ptr : nf += 1 : operator = p : end operator
type U2
	p as any ptr
	declare operator cast( ) as integer
	declare operator cast( ) as any ptr
end type
operator U2.cast( ) as any ptr : na += 1 : operator = p : end operator
operator U2.cast( ) as integer : ni += 1 : operator = 0 : end operator
type U3
	p as any ptr
	declare operator cast( ) as FB.IMAGE ptr
end type
operator U3.cast( ) as FB.IMAGE ptr : nf += 1 : operator = p : end operator
dim x1 as U1 : x1.p = imagecreate( 8, 8, rgb(255,0,0) )
dim x2 as U2 : x2.p = imagecreate( 8, 8, rgb(255,0,0) )
dim x3 as U3 : x3.p = imagecreate( 8, 8, rgb(255,0,0) )
line x1, (0, 0) - (7, 7), rgb(0,0,255), bf
print #9, na, ni, nf, hex( point( 3, 3, x1.p ) )
line x2, (0, 0) - (7, 7), rgb(0,255,0), bf
print #9, na, ni, nf, hex( point( 3, 3, x2.p ) )
line x3, (0, 0) - (7, 7), rgb(1,2,3), bf
print #9, na, ni, nf, hex( point( 3, 3, x3.p ) )
