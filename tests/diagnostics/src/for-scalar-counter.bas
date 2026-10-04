'' A FOR counter must be a plain variable -- each of the first four is fbc's 52 or 14.
type T : x as integer : end type
dim t as T
dim arr( 3 ) as integer
dim as integer ptr p = new integer
for t.x = 1 to 3 : next
for arr( 1 ) = 5 to 7 : next
for *p = 1 to 2 : next
sub s( byref k as integer )
    for k = 1 to 3 : next
end sub
'' ...and what fbc takes: a byval parameter, a shared variable, a static, a plain one.
dim shared g as integer
sub s2( byval v as integer )
    static as integer st
    for v = 1 to 2 : next
    for g = 1 to 2 : next
    for st = 1 to 2 : next
end sub
dim as integer i
for i = 1 to 2 : next
for j as integer = 1 to 2 : next
