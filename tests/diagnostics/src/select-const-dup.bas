'' 'SELECT CASE AS CONST' gives every value one slot in its table, so a value named twice
'' is fbc's error 4, "Duplicated definition", at the case that repeats it -- and a float
'' subject is fbc's error 24 at the SELECT. Measured, one probe each, against fbc-modern.
dim shared as long x
dim shared as double d

'' -- refused ------------------------------------------------------------------
select case as const x
case 1, 1
end select

select case as const x
case 1
case 1
end select

select case as const x
case 2 to 4
case 3
end select

select case as const x
case 2 to 4, 4 to 6
end select

select case as const d
case 1
end select

'' -- accepted -----------------------------------------------------------------
select case as const x
case 2 to 4, 5 to 6
case 7
end select

select case x
case 1
case 1
end select
