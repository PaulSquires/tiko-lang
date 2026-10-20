' A SHARED integer initialised from a float constant. fbc folds it half to even:
' 'static int64 A$ = 2ll' for 2.5. Every one declined (TKO0994).
dim shared as integer a = 2.5, b = 3.5, c = -2.5, d = 255.0
dim shared as long f = cast(long, 1.0 * 255.f)
dim shared as ulong g = cast(ulong, 0.5 * 255.f)
dim shared as short h = 1e3
print a; b; c; d; f; g; h
