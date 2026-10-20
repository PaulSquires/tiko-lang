' A property SETTER whose value parameter is BYREF scalar, given an rvalue, a variable,
' a literal and a variable of another type.
type Stk
    declare property push(byref i as integer)
    declare property pushd(byref d as double)
    as integer last
    as double lastd
end type
property Stk.push(byref i as integer)
    last = i
end property
property Stk.pushd(byref d as double)
    lastd = d
end property
dim as Stk s
dim as integer m = 5
dim as long l = 9
s.push = m - 1 : print s.last;
s.push = m : print s.last;
s.push = 7 : print s.last;
s.push = l : print s.last;
s.pushd = m / 2 : print s.lastd
