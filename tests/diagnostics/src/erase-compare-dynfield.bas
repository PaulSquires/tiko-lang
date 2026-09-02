'' THREE RULES MEASURED AGAINST FBC.
''   'erase x' over an array of a type with structors reconstructs every element, and fbc
''   only does that through plain ones: a default constructor whose parameter is merely
''   defaulted is error 176, one with a calling convention 174, a destructor with one 175.
''   A UDT compared with anything needs an 'operator =': 'print (t = e1)' over a type
''   that declares none is error 20, and so are two values of one plain type.
''   A dynamic array FIELD writes its rank: 'array(any)' is the form, 'array()' is error 9.
type Plain
    i as integer
end type
type Cmp
    i as integer
    declare operator cast( ) as integer
end type
operator Cmp.cast( ) as integer
    operator = i
end operator
type DefCtor
    i as integer
    declare constructor( byval n as integer = 0 )
end type
constructor DefCtor( byval n as integer )
end constructor
type OkField
    arr(any) as integer
end type
enum E_
    e1
end enum
dim t as Plain, cm as Cmp
dim okArr(0 to 0) as Plain
erase okArr
print (cm = 1)

print (t = e1)
print (t = t)
dim badArr(0 to 0) as DefCtor = { DefCtor( 1 ) }
erase badArr
type BadField
    arr() as integer
end type
