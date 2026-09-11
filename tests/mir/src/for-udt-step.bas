#lang "fb"
type foo
    as integer x
    declare constructor( )
    declare constructor( byval rhs as integer )
    declare constructor( byref rhs as foo )
    declare operator let( byval rhs as integer )
    declare operator let( byref rhs as foo )
    declare operator for( )
    declare operator for( byref stp as foo )
    declare operator step( )
    declare operator step( byref stp as foo )
    declare operator next( byref end_cond as foo ) as integer
    declare operator next( byref end_cond as foo, byref stp as foo ) as integer
private:
    as integer is_up
end type
constructor foo( ) : this.x = 0 : end constructor
constructor foo( byval rhs as integer ) : this.x = rhs : end constructor
constructor foo( byref rhs as foo ) : this.x = rhs.x : end constructor
operator foo.let( byval rhs as integer ) : this.x = rhs : end operator
operator foo.let( byref rhs as foo ) : this.x = rhs.x : end operator
operator foo.for( ) : end operator
operator foo.for( byref stp as foo )
    this.is_up = iif( stp.x < 0, 0, 1 )
end operator
operator foo.step( ) : this.x += 1 : end operator
operator foo.step( byref stp as foo ) : this.x += stp.x : end operator
operator foo.next( byref end_cond as foo ) as integer
    return this.x <= end_cond.x
end operator
operator foo.next( byref end_cond as foo, byref stp as foo ) as integer
    if this.is_up <> 0 then return this.x <= end_cond.x
    return this.x >= end_cond.x
end operator

dim as foo stp = 1
dim as foo bar
for bar = 0 to 4
    print bar.x;
next
print
for cnt as foo = 0 to 4 step stp
    print cnt.x;
next
print
dim as foo down = -1
for cnt as foo = 4 to 0 step down
    print cnt.x;
next
print
