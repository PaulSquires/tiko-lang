'' T28: 'for each' BY VALUE over an array of records -- inferred and written type, fixed and
'' dynamic arrays, a record holding an array -- and writing to the loop variable leaves the
'' array alone. Output identical to fbc-modern's.
type Point
    x as long
    y as long
end type
type Big
    a(0 to 4) as double
    tag as long
end type
dim as Point pts( 1 to 3 )
for i as long = 1 to 3 : pts( i ).x = i : pts( i ).y = i * 10 : next
for each p in pts
    print p.x; p.y;
    p.x = 99
next
print
print pts( 1 ).x
dim as Point dyn( )
redim dyn( 0 to 1 )
dyn( 0 ).y = 5 : dyn( 1 ).y = 6
for each q as Point in dyn
    print q.y;
next
print
dim as Big bs( 0 to 1 )
bs( 1 ).a( 4 ) = 2.5 : bs( 1 ).tag = 7
for each b as Big in bs
    print b.a( 4 ); b.tag;
next
print
