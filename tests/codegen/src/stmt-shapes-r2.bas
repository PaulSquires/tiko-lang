' Statements that stopped on TKO0994 (fbc-examples round 2, r2ice03/06/07/09).

' r2ice03: a field typed through a pointer typedef to a typedef declared LATER.
type LPHANDLE as HANDLE ptr
type HANDLE as any ptr
type HT
    as LPHANDLE ph
end type
dim as HT m
dim as HANDLE h(1)
h(1) = cast(HANDLE, 42)
m.ph = @h(0)
print cint(m.ph[1]); cint(*(m.ph + 1)); sizeof(m.ph)

' r2ice06: an array field named like the constant that sizes it, beside a field initialiser.
const bias = 3
type NT
    as single bias(bias)
    as long n = 2
end type
dim as NT tt
print ubound(tt.bias); tt.n; sizeof(NT)

' r2ice07: PUT of a value, not a variable.
dim as integer f = freefile, x = 1234
open "stmtshapesr2.tmp" for binary as #f
put #f, , clng(x)
put #f, , x * 2
dim as long rl
dim as integer ri
get #f, 1, rl
get #f, , ri
print lof(f); rl; ri
close #f
kill "stmtshapesr2.tmp"

' r2ice09: DEALLOCATE of a WITH member, written without parentheses.
type W
    as ubyte ptr p
end type
dim as W s
with s
    .p = allocate(4)
    deallocate .p
    .p = 0
end with
print s.p = 0
