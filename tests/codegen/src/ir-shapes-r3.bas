' Invalid IR and a clang crash (fbc-examples round 3: r3ir01-04).

' r3ir01: a global operator with a byval parameter of a type that has a copy constructor and a
' destructor -- a copy for the operator, destroyed after it.
dim shared as integer nc, nd
type D
    as long v
    declare constructor()
    declare constructor(byval x as long)
    declare constructor(byref r as D)
    declare destructor()
end type
constructor D()
    nc += 1
end constructor
constructor D(byval x as long)
    v = x : nc += 1
end constructor
constructor D(byref r as D)
    v = r.v : nc += 1
end constructor
destructor D()
    nd += 1
end destructor
operator - (byref l as D, byval r as D) as long
    return l.v - r.v
end operator
scope
    dim as D a = D(9), b = D(2)
    print a - b; nc; nd
end scope
print nc; nd

' r3ir02: a method on the by-value result of 'operator []'.
type LV
    as string s
    as integer n
    declare function toInt() as integer
end type
function LV.toInt() as integer
    return n + len(s)
end function
type LSTT
    as LV items(2)
    declare operator [](byval i as uinteger) as LV
end type
operator LSTT.[](byval i as uinteger) as LV
    return items(i)
end operator
dim as LSTT lst
lst.items(1).n = 5 : lst.items(1).s = "ab"
print lst[1].toInt()

' r3ir03: an indexed property setter with a byval string index -- the callee's copy.
type AA
    as integer v(3)
    declare property Item(byval k as string) as integer
    declare property Item(byval k as string, byval x as integer)
end type
property AA.Item(byval k as string) as integer
    return v(len(k))
end property
property AA.Item(byval k as string, byval x as integer)
    v(len(k)) = x : k = "zz"
end property
dim as AA aa_
dim as string key = "abc"
aa_.Item(key) = 7
print aa_.Item(key); " "; key

' r3ir04: copying a POD larger than 64 KB, and a type holding one through its implicit let.
type Pos
    board(0 to 127) as ubyte
    hist(0 to 9999) as longint
    side as integer
end type
type Game
    as Pos p
    as string title
end type
function search(byref p as Pos) as integer
    static work as Pos
    work = p
    dim as Pos lcopy
    lcopy = p
    return work.side + work.board(5) + lcopy.hist(9999)
end function
dim shared as Pos g
g.side = 3 : g.board(5) = 4 : g.hist(9999) = 10
print search(g)
dim as Game g1, g2
g1.p.side = 6 : g1.title = "match"
g2 = g1
print g2.p.side; " "; g2.title
