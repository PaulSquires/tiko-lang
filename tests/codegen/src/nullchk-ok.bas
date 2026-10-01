type P
    x as long
    y as long
end type
dim as P v = ( 3, 4 )
dim as P ptr pp = @v
pp->y += 1
print pp->x; pp->y
dim as long arr(0 to 3) = { 1, 2, 3, 4 }
dim as long ptr q = @arr(0)
q[2] = 9
print q[1]; q[2]
dim as zstring ptr z = 0
print "ok"
type M
    x as long
    declare sub show( )
end type
sub M.show( )
    print x; this.x
end sub
dim as M w
w.x = 7
w.show( )
dim as M ptr mp = @w
mp->show( )
print "end"
