'' A PASCAL PROCEDURE TAKES ITS PARAMETERS IN REVERSE, on x86-64 too -- fbc-modern 1.20
'' -gen llvm defines each of these with the source's parameters backwards, 'this' among
'' them, and the hidden result pointer still first. A call through a pascal procedure
'' TYPE reverses as well; one through a cdecl pointer does not, which is why fbc prints
'' 123 and 321 on the last line. tiko wrote all of them in cdecl order and printed 123 twice.
type Big
    as long a(0 to 7)
end type
type T
    as long v
    declare function M pascal ( byval a as long, byval b as long ) as long
end type
function T.M pascal ( byval a as long, byval b as long ) as long
    return v + a * 10 + b
end function
function RB pascal ( byval a as long, byval b as long ) as Big
    dim as Big r : r.a(0) = a : r.a(1) = b : return r
end function
function P pascal ( byval a as long, byval b as double, byval c as longint ) as double
    return a * 100 + b * 10 + c
end function
dim as function pascal ( byval a as long, byval b as double, byval c as longint ) as double fp = @P
dim as function cdecl ( byval a as long, byval b as double, byval c as longint ) as double fc = @P
print fp( 1, 2, 3 ), fc( 1, 2, 3 )
