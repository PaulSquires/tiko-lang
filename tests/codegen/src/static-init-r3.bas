' Initialisers that stopped on TKO0994 (fbc-examples round 3: r3ice01, 02, 03, 08, 09), and a field
' initialised from a function call that silently took the call's arguments as constructor arguments.

' r3ice01: '@' over adjacent literals in a static table and a static pointer.
dim shared as zstring ptr g(...) = {0, @"ab" "cd", @"x"}
static shared as zstring ptr f1 = @"All (*.*)" "!"
' r3ice02: '@wstr( ... )' in a static.
static shared as wstring ptr w1 = @wstr("xy")
dim as string w1n = *w1
print *g(1); *g(2); ubound(g); " "; *f1; " "; w1n

' r3ice03: '@' over str( ) of a string constant, as an initialiser and as an argument.
const UP = str("User:Pw")
const FS = "v=%d"
sub show(byval p as const zstring ptr)
    print *p
end sub
dim as zstring ptr up_ = @UP
show(up_)
show(@str(FS))

' r3ice08: a shared UDT initialised from a FUNCTION returning it -- copied, then the temporary destroyed.
type Q
    as long v
    declare constructor()
    declare constructor(byval x as long)
    declare constructor(byref r as Q)
    declare destructor()
end type
dim shared as integer nc, nd
constructor Q()
    nc += 1
end constructor
constructor Q(byval x as long)
    v = x : nc += 1
end constructor
constructor Q(byref r as Q)
    v = r.v : nc += 1 : print "copy"
end constructor
destructor Q()
    nd += 1
end destructor
function mk(byval k as long) as Q
    return Q(k * 3)
end function
dim shared as Q q1 = mk(5)
dim shared as Q q2 = mk(7)
print q1.v; q2.v; nc; nd
type SQ
    as string s
    as long n
end type
function mkq9(byval k as long) as SQ
    dim as SQ r
    r.s = "v" & k : r.n = k
    return r
end function
dim shared as SQ gsv = mkq9(9)
print gsv.s; gsv.n
' ...and a FIELD initialised from one: it was Q( 5 ), the call's argument.
type HF
    as Q f = mk(5)
end type
dim as HF hfv
print hfv.f.v

' r3ice09: a string constant of 17 '&' terms.
const T = _
    "l01|" & chr(10) & "l02|" & chr(10) & "l03|" & chr(10) & "l04|" & chr(10) & _
    "l05|" & chr(10) & "l06|" & chr(10) & "l07|" & chr(10) & "l08|" & chr(10) & "last"
dim as string rest = T & chr(10)
print len(rest)
