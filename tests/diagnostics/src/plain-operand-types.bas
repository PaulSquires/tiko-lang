'' Operands no builtin operator takes -- each line is fbc error 20, 28 or 24, measured.
dim as string s = "x"
dim as integer i = 3
dim as double d = 1.5
dim as boolean b = true
dim as integer ptr pi = @i
dim as any ptr pa = pi
print s + 1
print 1 + s
print b + 1
print b * b
print pi + 1.5
print pi - d
print -b
print *i
print @5
'' ...and what fbc takes: a pointer is an INTEGER under andalso/orelse.
print pi andalso 1
print pa orelse b
print pi + 1, pi - pi, *pi, -d, not b, s & i
