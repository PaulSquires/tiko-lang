'' A SINGLE-LINE IF's ELSE BRANCH, in both of its shapes.
''
'' 'if c then a else b' DROPPED THE ELSE ENTIRELY, silently: the AST held one
'' N_IF_BRANCH and nothing else -- no else block, no diagnostic -- and the statement
'' counted as fully lowered while fbc ran the other arm.
''
'' The cause was not where it looked. The then-branch is parsed with Statement( ), the
'' statement layer ends by calling EndOfStatement, and THAT WALKS TO THE LINE'S END AND
'' DISCARDS WHATEVER IT PASSES -- so 'else b' was thrown away before control came back,
'' and testing for ELSE afterwards did nothing at all. A single flag, saved and
'' restored around the then-branch, tells EndOfStatement to stop short of an ELSE.
'' Saved and restored rather than set and cleared, because 'if a then if b then x else
'' y' nests one of these inside another and the ELSE binds to the INNER if -- measured.
''
'' 'if (e) then else stmt' -- AN EMPTY THEN-BRANCH -- is legal FreeBASIC and the corpus
'' writes it: optimizations/self_compare.bas defines its whole assertion macro that
'' way. It failed LOUDLY, with 'expected a statement', and it needs the same else
'' handling: taking the empty branch alone leaves the ELSE for the enclosing statement
'' loop, which reports the same thing one token later.
dim as long e = 0
dim as long f = 1

if (e) then else print "empty-then taken"
if (f) then else print "not printed"

if e then print "then-arm" else print "else-arm"
if f then print "then-arm 2" else print "else-arm 2"

'' NESTED: the else belongs to the INNER if
dim as long a = 1, b = 0
if a then if b then print "inner-then" else print "inner-else"
print "after"
