'' A merely-defaulted constructor builds a DIM'd array but not a REDIM'd one.
type U
	as integer i
	declare constructor( byval as integer = 0 )
end type
constructor U( byval v as integer = 0 )
end constructor
type V
	as integer i
	declare constructor( byval as integer )
end type
constructor V( byval v as integer )
end constructor
dim as U a(0 to 1)                              '' fine
dim as U c()                                    '' fine
extern as V g1                                  '' fine: constructed where defined
redim as U b(0 to 1)                            '' 173
