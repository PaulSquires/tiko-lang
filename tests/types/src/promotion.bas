'' The promotion answers that are NOT what a C programmer would guess. Each was
'' measured from fbc; the full 3,920-row differential is tools/gen/check-promo.sh.
dim as long a = 6
dim as double d = 2.5
dim as single f = 1.5
dim as ubyte u = 3
dim as string s = "x"
dim as boolean b = true
dim as ulongint q = 5
dim as ulong w = 4

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

'' EVERY VALUE IS NON-ZERO ON PURPOSE, and the initialisers must stay on the lines
'' they are on: the .test asserts a TYPE per LINE NUMBER, so inserting a line above
'' moves the answers out from under it.
''
'' Left at their default zero, 'a \ a' is integer division by zero and 'a / a' is
'' 0.0 / 0.0. Measured, fbc CRASHES on the first of those too -- rc 127, and under
'' '-exx' runtime error 11, "floating point error" signal -- whenever the divisor is
'' one the optimiser cannot see. What made fbc print ' 1' here instead was gcc folding
'' 'A / A' at compile time, which it may do because the program's behaviour is
'' undefined; tiko traps at -O0 and folds the same way at -O2. So the two compilers
'' never disagreed about FreeBASIC, only about what to do with a program that has no
'' defined answer -- and a promotion test has no business asking one. The zeros also
'' printed '-1.#IND' against tiko's '1.#QNAN', a NaN-spelling difference that says
'' nothing about promotion either.
