'' A tuple TYPE's own declaration errors -- fbc's 367 on line 5, 368 on 6, and 369 on 7, 8
'' and 9 (fbc-modern 1.20, from its errors/tuple-errors.bas). Only the first problem in a
'' list is reported: line 9 is 369 alone. Lines 11 to 13 are accepted.
dim as long pad
type OneElem as (long)
type DupName as (x as long, X as long)
type AnyElem as (any, long)
type FixStr as (zstring * 4, long)
type TwoBad as (any, x as long, x as long)

type AnyPtr as (any ptr, long)
type Named as (x as long, y as string)
type Str as (string, zstring ptr)
