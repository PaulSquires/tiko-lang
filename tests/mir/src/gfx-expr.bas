'' The graphics constructs that are KEYWORDS rather than declared procedures, so they
'' cannot live in the runtime prelude with the rest of the graphics surface. None of
'' the three was typed or lowered at all.

'' THE DEPTH DEFAULTS TO THE LITERAL 8 FOR EVERY MODE -- verified across modes 12, 13,
'' 18 and 21, where a per-mode table would be the obvious guess.
screen 13
screen 13, 8, 2, 1, 60

'' AN OMITTED COLOUR IS THE SAME TWO-PART ANSWER THE DRAWING STATEMENTS GIVE: 0 in the
'' colour slot plus a flag bit, here &h80000000 in the FIFTH argument.
dim as any ptr a = imagecreate( 16, 16 )
dim as any ptr b = imagecreate( 16, 16, 7 )
dim as any ptr d = imagecreate( 16, 16, 7, 32 )

'' THE ONE-ARGUMENT FORM IS THE SAME FUNCTION: the axis selector goes in x and y
'' carries the sentinel -8388607.0f. And the TARGET, written LAST in BASIC, is FIRST
'' in the call.
dim as ulong c
c = point( 1, 2 )
c = point( 0 )
c = point( 1, 2, a )

'' 'PALETTE GET USING array' IS A FOURTH FORM, not a GET with a stray word, and EVERY
'' palette that writes back has a 64-BIT TWIN chosen by the width it writes into -- an
'' 'integer' array takes the 64 form on win64 and the 32 form on win32.
dim q(0 to 255) as long
dim r(0 to 255) as longint
dim pp as ulong ptr
palette get using q
palette get using r
palette using r
'' A POINTER ARGUMENT IS ITS VALUE, everything else its ADDRESS: taking the address of
'' the pointer VARIABLE would hand the runtime a pointer to a pointer.
palette get using pp
dim as long v
palette get 1, v
