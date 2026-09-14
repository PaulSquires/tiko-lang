'' A byval UDT with a destructor, and a byval string, passed through a procedure pointer.
type Txt
    as ustring s
    as long n
end type
type ParseFn as function( byval h as any ptr, byval t as Txt, byval out_ as long ptr ) as boolean
type StrFn as function( byval h as any ptr, byval t as string, byval out_ as long ptr ) as boolean
type Ctl
    as any ptr hWin
    as ParseFn parseCb
    as StrFn   strCb
end type
function MyParse( byval h as any ptr, byval t as Txt, byval out_ as long ptr ) as boolean
    *out_ = len( t.s ) + t.n
    return true
end function
function MyStr( byval h as any ptr, byval t as string, byval out_ as long ptr ) as boolean
    *out_ = len( t )
    return true
end function
dim as Ctl c
c.parseCb = @MyParse
c.strCb = @MyStr
dim as Txt x
x.s = "2026-09-14" : x.n = 5
dim as string y = "2026-09-14"
dim as long r1, r2
dim as boolean ok1 = c.parseCb( c.hWin, x, @r1 )
dim as boolean ok2 = c.strCb( c.hWin, y, @r2 )
print ok1; r1; ok2; r2
