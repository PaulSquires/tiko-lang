'' T32: 'new T( a, b )' over a type with no constructor fills its fields in order, as
'' 'dim as T x = ( a, b )' does -- a short list, a record-typed field, placement new.
type Point
    x as long
    y as long
end type
type Line2
    a as Point
    w as long
end type
dim as Point ptr p0 = new Point( 3, 4 )
print p0->x; p0->y
delete p0
dim as Point ptr p1 = new Point( 7 )
print p1->x; p1->y
delete p1
dim as Line2 ptr l1 = new Line2( type<Point>( 1, 2 ), 9 )
print l1->a.x; l1->a.y; l1->w
delete l1
dim as ubyte buf( 0 to 15 )
for i as long = 0 to 15 : buf( i ) = 255 : next
dim as Point ptr pp = new( @buf( 0 ) ) Point( 5, 6 )
print pp->x; pp->y
dim as Point ptr pq = new( @buf( 8 ) ) Point( 8 )
print pq->x; pq->y
