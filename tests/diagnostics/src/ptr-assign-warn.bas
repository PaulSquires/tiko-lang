'' fbc's WARNING 4, "Suspicious pointer assignment" -- TKO0830. fbc-modern 1.20 warns on
'' exactly the lines marked W below and on no other (measured 2026-09-25); tiko warned on
'' none. See symbols/ptrwarn.bas for the rule.
type B
    as long x
end type
type Dv extends B
    as long y
end type
type O
    as long z
end type
enum E : e1 : end enum
function F1 cdecl ( byval a as long ) as long : return a : end function
function F2 stdcall ( byval a as long ) as long : return a : end function
function F3 ( byval a as double ) as long : return a : end function
function F4 ( byref a as long ) as long : return a : end function
function F5 ( byval a as long ) as integer : return a : end function
function F7 ( byval a as ulong ) as long : return a : end function
function P1 pascal ( byval a as long ) as long : return a : end function
dim as double d
dim as long l
dim as integer ip
dim as long ptr lp
dim as double ptr dp
dim as any ptr ap
dim as byte ptr bp
dim as ubyte ptr ubp
dim as zstring ptr zp
dim as B ptr pb
dim as Dv ptr pd
dim as O ptr po
dim as long ptr ptr lpp
dim as longint ptr qp
dim as integer ptr iptr
dim as single ptr fp
dim as E ptr ep
dim as string ptr strp
dim as zstring * 8 z8
dim as function cdecl ( byval a as long ) as long pc
lp = @d            ' W
lp = dp            ' W
lp = ap
ap = dp
lp = 0
lp = cint( 0 )
lp = 5             ' W
lp = ip            ' W
bp = ubp
zp = ubp
pb = pd
po = pb            ' W
lpp = lp           ' W
lp = lpp           ' W
qp = iptr
iptr = lp          ' W
fp = lp            ' W
ep = lp            ' W
strp = zp          ' W
zp = @z8
zp = @"lit"
pc = @F1
pc = @F2
pc = @F3           ' W
pc = @F4           ' W
pc = @F5           ' W
pc = @F7
pc = @P1           ' W
pc = ap
dim as long ptr ilp = @d   ' W
function R1( ) as long ptr
    static as double sd
    return @sd     ' W
end function
