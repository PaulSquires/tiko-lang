'' A shared or static reference bound to what has no fixed address -- fbc's error 11 on the
'' refused lines.
type UDT
    i as integer
end type
redim shared as integer dynarr(10)
dim shared as integer fixarr(10), k, x
dim shared as UDT u
dim shared as integer ptr p
const K5 = 5
dim shared byref as integer r1 = dynarr(5)     '' 11
dim shared byref as integer r2 = fixarr(k)     '' 11
dim shared byref as integer r3 = u.i           '' 11
dim shared byref as integer r4 = *p            '' 11
dim shared byref as integer r5 = fixarr(5)     '' fine
dim shared byref as integer r6 = fixarr(K5)    '' fine
dim shared byref as integer r7 = x             '' fine
dim shared byref as UDT r8 = u                 '' fine
