'' EIGHT LEVELS OF POINTER IS THE LIMIT -- fbc error 274, "Too many levels of pointer
'' indirection" -- and it counts THROUGH TYPEDEFS, so a chain of aliases that each add a
'' few reaches the limit exactly as one long spelling does. Measured at the boundary.
'' Accepted: eight levels, written directly or reached through an alias.
dim eight as integer ptr ptr ptr ptr ptr ptr ptr ptr
type fourDeep as integer ptr ptr ptr ptr
dim alsoEight as fourDeep ptr ptr ptr ptr
'' Refused: the ninth level, however it is spelled.
dim nine as integer ptr ptr ptr ptr ptr ptr ptr ptr ptr
