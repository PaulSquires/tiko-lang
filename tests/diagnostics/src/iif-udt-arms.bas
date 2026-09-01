'' AN IIF ARM THAT IS A UDT MUST MEET THE SAME UDT -- fbc error 24. Two different types, a
'' type and an integer, a type and a pointer, and even a base and its DERIVED are refused;
'' two arms of the identical plain type are accepted.
type Plain
    i as integer
end type

type Other
    i as integer
end type

type Parent_ extends object
    i as integer
end type

type Derived extends Parent_
end type

dim as integer cond
dim a as Plain, b as Plain
dim o as Other
dim bs as Parent_, dv as Derived
dim pp_ as Plain ptr

a = iif( cond, a, b )

a = iif( cond, a, o )
a = iif( cond, a, 1 )
a = iif( cond, a, pp_ )
bs = iif( cond, bs, dv )
