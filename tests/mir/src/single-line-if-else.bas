'' 'if (e) then else stmt' -- AN EMPTY THEN-BRANCH, which is legal FreeBASIC and which
'' the corpus writes: optimizations/self_compare.bas defines its whole assertion macro
'' as 'if (e) then else CU_FAIL( ... )'.
''
'' Asked for a statement, the parser found ELSE and reported "expected a statement" --
'' and taking the empty branch alone is not enough, because the ELSE is then left for
'' the enclosing statement loop, which reports the same thing one token later. The two
'' halves are inseparable.
dim as long e = 0
dim as long f = 1

if (e) then else print "empty-then taken"
if (f) then else print "not printed"
