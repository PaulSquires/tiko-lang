'' A BARE PARENTHESISED FIELD LIST AS AN ARRAY ELEMENT is the ELEMENT'S own fields, and
'' has to be built with the ELEMENT'S type. Left to the ordinary expression path it went
'' to the tuple path, which infers a synthetic UDT from the VALUES: over an mt of
'' sixteen bytes -- two bytes at 0 and 1, an integer at 8 -- that built a TWENTY-FOUR
'' byte temporary with i64 fields at 0, 8 and 16 and stored the whole of it into the
'' element, writing eight bytes past its end and into the next one. It verified, it
'' declined nothing, and every field but the first held the wrong value. fbc prints
'' ' 7  8  9' and ' 1  2  3'.
type mt
	as byte a
	as byte b
	as integer c
end type

dim arr(1) as mt => { ( 7, 8, 9 ), ( 1, 2, 3 ) }
print arr(0).a, arr(0).b, arr(0).c
print arr(1).a, arr(1).b, arr(1).c

'' A NESTED ARRAY MEMBER inside the element, which is what the corpus writes.
type nt
	as integer a
	as short c(0 to 2)
end type

dim ar2(1) as nt => { ( 1, { 3, 4, 5 } ) }
print ar2(0).a, ar2(0).c(0), ar2(0).c(1), ar2(0).c(2)
