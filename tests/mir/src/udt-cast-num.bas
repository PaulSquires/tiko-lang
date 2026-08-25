type UDT
    dim as integer I
    declare constructor( )
    declare constructor( byval i as integer )
    declare operator cast( ) as integer
    declare destructor( )
end type
constructor UDT( )
end constructor
constructor UDT( byval i as integer )
    this.I = i
end constructor
operator UDT.cast( ) as integer
    return this.I
end operator
destructor UDT( )
end destructor
dim as UDT u
u.I = 1
dim as boolean r1 = (u <> 0)
dim as boolean r2 = (u = 1)
dim as integer n = u + 1
print r1, r2, n
