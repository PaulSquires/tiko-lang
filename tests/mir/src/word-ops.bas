'' THE WORD-SPELLED COMPOUND ASSIGNMENTS. Each is TWO TOKENS -- the operator is a
'' keyword and the '=' is its own -- where '+=' is one, so nothing recognised them and
'' 't1 and= t2' parsed as the expression 't1' followed by a paren-less call to
'' something named 'and'.
dim as integer t1 = 1, t2 = 0
t1 and= t2
t1 or= t2
t1 xor= t2
t1 shl= 1
t1 shr= 1
t1 mod= t2
t1 eqv= t2
t1 imp= t2

'' IMP AND EQV ARE TWO INSTRUCTIONS EACH, which is why they have no entry in the
'' operator table: measured, 'a imp b' is '~A | B' and 'a eqv b' is '~(A ^ B)'. Neither
'' lowered at all, in expression form or compound.
dim as integer a = 1, b = 2, c2
c2 = a imp b
c2 = a eqv b
