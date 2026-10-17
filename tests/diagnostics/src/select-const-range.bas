'' Under 'SELECT CASE AS CONST' a case value is converted to the subject's type to index
'' the table, and one the subject cannot hold is fbc's warning 25, "Overflow in constant
'' conversion" -- per value, and per bound of a range. The value is read in ITS OWN type:
'' fbc types '&hFFFFFFFFFFFFFFFF' INTEGER (-1) and a negation INTEGER. A plain SELECT, an
'' enum subject and a value that fits say nothing. Every line is fbc-modern 1.20's.
dim shared as ubyte ub
dim shared as byte sb
dim shared as long sl
dim shared as ulong ul
dim shared as ulongint uli
dim shared as integer sint
dim shared as boolean bo
dim shared as short sshort
enum Colour : Red = 1 : end enum
dim shared as Colour co

'' -- warned -------------------------------------------------------------------
select case as const ub : case 300 : end select
select case as const ub : case -1 : end select
select case as const ub : case 250 to 300 : end select
select case as const sb : case 127, 128, 129 : end select
select case as const sl : case 2147483648 : end select
select case as const ul : case -1 : end select
select case as const uli : case -1 : end select
select case as const sint : case 18446744073709551615ull : end select
select case as const bo : case 1 : end select
select case as const sshort : case 40000 : end select

'' -- quiet --------------------------------------------------------------------
select case ub : case 300 : end select
select case as const ub : case 0 to 255 : end select
select case as const sint : case &hFFFFFFFFFFFFFFFF : end select
select case as const sl : case -2147483648 : end select
select case as const bo : case -1, 0 : end select
select case as const co : case 5000000000 : end select
select case as const ul : case 4294967295 : end select
