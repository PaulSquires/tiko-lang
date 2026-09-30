'' A string literal arm meets a UDT that extends zstring, through a base or not.
type UB extends zstring
	s as zstring * 20
end type
type U extends UB
	declare operator cast() byref as const zstring
end type
operator U.cast() byref as const zstring
	return this.s
end operator
dim u1 as U
dim c as integer = 1
dim a as zstring * 50 = iif( c, u1, "there" )   '' fine
dim s as string = "str"
dim b as zstring * 50 = iif( c, u1, s )         '' refused: a STRING variable
