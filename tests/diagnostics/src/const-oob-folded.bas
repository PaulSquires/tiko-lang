'' TKO0960 over subscripts that FOLD rather than read as literals: a CONST name, an expression,
'' a procedure's own CONST. fbc-modern 1.20 -exx: error 92 on lines 7, 8 and 13, nothing on 9.
'' Reported by the sweeps since 2026-10-24 (symbols/constsubscript.tiko); lowering, which
'' reported it before, saw only a literal.
const N = 5
dim as integer a(1 to 3)
print a(N)
print a(1 + 3)
print a(N - 3)
sub s()
    const M = 9
    dim as integer q(0 to 1)
    print q(M)
end sub
