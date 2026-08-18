'' Constant folding, on the answers that are not what you would assume.
print 10 \ 3 * 3      '' 1   -- '\' binds LOOSER than '*', so this is 10 \ 9
print -7 \ 2          '' -3  -- truncates toward zero
print -7 mod 2        '' -1  -- MOD takes the sign of the DIVIDEND
print 7 mod -2        '' 1
print -1 shr 1        '' -1  -- SHR on a signed value is ARITHMETIC
print 1 shl 32        '' 4294967296 -- shifts are done at 64 bits
print not 0           '' -1  -- bitwise complement
print 5 = 5           '' -1  -- a true comparison is -1, never 1
print -2 ^ 2          '' -4  -- unary minus binds looser than '^'
print cint(2.5)       '' 2   -- HALF TO EVEN
print cint(3.5)       '' 4
print int(-2.5)       '' -3  -- floor
print fix(-2.5)       '' -2  -- truncate
print clng(1e10)      '' -2147483648 -- out of range gives the indefinite value
print len("hello")    '' 5
print asc("A")        '' 65
print iif(0, 10, 20)  '' 20
