'' AN OPERATOR DECLARED AND DEFINED SEPARATELY is ONE operator, not two candidates --
'' which is how every header writes them.
type TS
    as longint t
    declare constructor( byval v as longint )
end type

constructor TS( byval v as longint )
    this.t = v
end constructor

type DT
    as longint ticks
    declare constructor( byval v as longint )
end type

constructor DT( byval v as longint )
    this.ticks = v
end constructor

declare operator + ( byref a as DT, byref b as TS ) as DT
declare operator - ( byref a as DT, byref b as TS ) as DT
declare operator - ( byref a as DT, byref b as DT ) as TS

private operator + ( byref a as DT, byref b as TS ) as DT
    return DT( a.ticks + b.t )
end operator

private operator - ( byref a as DT, byref b as TS ) as DT
    return DT( a.ticks - b.t )
end operator

private operator - ( byref a as DT, byref b as DT ) as TS
    return TS( a.ticks - b.ticks )
end operator

dim as DT d = DT( 100 )
dim as TS s = TS( 5 )

'' ...and PARENTHESES are transparent to the address of the result.
dim as DT g = ( d + s ) - s
dim as DT h = d + s - s
dim as longint k = ( ( d + s ) - s ).ticks

print g.ticks, h.ticks, k
