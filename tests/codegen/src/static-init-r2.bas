' Static and shared initialisers that stopped on TKO0994 (fbc-examples round 2, r2ice01/02/04/05/08),
' and the unsigned 32-bit constant that was sign-extended into a 64-bit one.
type G
    as long a, b
end type
dim shared g1 as const G = (1, 2)
dim a(0 to 1) as const G => {(3, 4), (5, 6)}
dim shared sa(0 to 1) as const G = {(7, 8), (9, 10)}

type CD
    as sub() f
    as zstring ptr nm
    as long k
end type
sub hello()
    print "hello"
end sub
dim shared cd1 as CD = (procptr(hello), @"cd1", 11)

sub statics()
    static z as zstring ptr = @"fbs"
    static n as long = any
    static text as zstring * 11 = any
    static cd2 as CD = (procptr(hello), @"cd2", 12)
    text = "abc"
    print *z; " "; text; " "; *cd2.nm; cd2.k
    cd2.f()
end sub

dim shared as ulong blanco = rgb(255, 255, 255)
const C = rgb(1, 2, 3)
dim shared as integer k = C
dim shared as integer ku = &hFF010203ul
dim shared as longint q = culng(-1)
type T64
    as integer i
end type
dim shared as T64 t64 = (&hFF010203ul)

print g1.a; g1.b; a(1).a; a(1).b; sa(0).b; sa(1).a
print *cd1.nm; cd1.k
cd1.f()
statics()
print hex(blanco); " "; hex(k); " "; hex(ku); " "; hex(q); " "; hex(t64.i); " "; hex(rgba(1, 2, 3, 4)); " "; hex(rgb(300, 2, 3))
