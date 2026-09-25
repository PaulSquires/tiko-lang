'' Tuple comparisons fbc refuses with error 20 (fbc-modern 1.20, its errors/tuple-errors.bas):
'' ordering on lines 9 and 10, '=' and '<>' between different tuple types on 11 and 12, the
'' literal '(1, 2)' -- which is (integer, integer) -- on 13 (fbc's 7 here, 20 as 'print a =
'' (1, 2)'), and a scalar on 14. Lines 16 and 17, one tuple type on both sides, are accepted.
dim as (long, long) a = (1, 2), b = (1, 2)
dim as (double, double) d
dim as boolean r

r = (a < b)
r = (a >= b)
r = (a = d)
r = (a <> d)
r = (a = (1, 2))
r = (a = 5)

r = (a = b)
r = (a <> b)
