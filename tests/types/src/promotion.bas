'' The promotion answers that are NOT what a C programmer would guess. Each was
'' measured from fbc; the full 3,920-row differential is tools/gen/check-promo.sh.
dim as long a
dim as double d
dim as single f
dim as ubyte u
dim as string s
dim as boolean b
dim as ulongint q
dim as ulong w

print u + u          '' integer -- promotes to POINTER-SIZED, not to long
print a \ a          '' integer
print a / a          '' double  -- '/' is always floating point
print f / f          '' single  -- only when BOTH sides are
print a / f          '' double  -- unlike '+', a single here does not win
print a ^ a          '' double  -- always
print a = a          '' integer -- comparisons are not boolean
print b = b          '' boolean -- unless both sides already are
print w + w          '' integer -- unsigned 32 fits in signed 64
print q + a          '' uinteger -- 64-bit unsigned forces it
print s + s          '' string
print b and a        '' integer
print -u             '' integer
print a andalso a     '' integer  -- never uinteger, unlike AND
print q andalso q     '' integer  -- even here
print b andalso b     '' boolean
print a & a           '' string   -- '&' is always a string
print s & d           '' string
