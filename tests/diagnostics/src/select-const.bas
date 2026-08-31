'' 'SELECT CASE AS CONST' builds a JUMP TABLE, so it refuses four things a plain SELECT
'' accepts. Measured, one probe each against fbc:
''
''     case is > 5            error 9    refused at the 'is'
''     case y                 error 11   "Expected constant"
''     case 1 to 0            error 323  start greater than end
''     case 0 to 8192         error 69   "Range too large"
''
'' THE SPAN IS ACROSS THE WHOLE STATEMENT. 'case 0 to 100' then 'case 11000 to 11100'
'' is 202 values and fbc still refuses it, at the SECOND case: what it measures is
'' max - min + 1 over every case so far, and the limit is 8192. Bisected:
''
''     case 0 to 8191                     8192 values   accepted
''     case 0 to 8192                     8193          error 69
''     case 1 to 8192                     8192          accepted
''     case 0 / case 8192                 span 8193     error 69
''     case -4000 to 0 / case 1 to 4192   span 8193     error 69
''
'' AND 'no cases at all' is refused on a PLAIN select too -- fbc error 34.
const K = 40

dim shared as long x

'' -- refused ------------------------------------------------------------------
select case as const x
case 1 to 0
end select

select case as const x
case 0 to 8192
end select

select case as const x
case 0 to 100
case 11000 to 11100
end select

select case as const x
case is > 5
end select

select case x
end select

select case as const x
case x
end select

'' -- accepted -----------------------------------------------------------------
select case as const x
case 1 to 8192
end select

select case as const x
case -4000 to 0
case 1 to 4191
end select

select case as const x
case K, K + 1, 5 to 9
case else
end select

select case as const x
case else
end select

select case x
case is > 5
case 1 to 0
end select
