'' 'on n goto l1, l2, l3' -- the COMPUTED GOTO, which was not lowered at all.
''
'' Measured semantics, and the two facts that matter are both in the range test fbc
'' emits:
''
''   TMP = (uint64)I$0;
''   if( (TMP - 1ull) > 2ull ) goto label$5;   <- past the list: FALL THROUGH
''   goto *tmp$7[TMP - 1ull];
''
'' -- the list is ONE-BASED, so 1 is subtracted from the selector, and the test is
'' UNSIGNED, which is what makes a selector of 0 -- or any negative one -- fall through
'' on that single comparison rather than needing two.
''
'' THE DISPATCH ITSELF IS A CHAIN HERE, not a jump table. fbc uses GCC's computed goto
'' over a static array of label addresses; MIR has BR and CONDBR and nothing else, so
'' the same choice is made with one equality test per label. Semantically identical --
'' the range test still runs first, so the chain is entered only for a selector that
'' names a label -- and O(N) where fbc is O(1). The corpus's longest list is three.
''
'' 'on n GOSUB' is a separate statement, since it pushes a return address, and is NOT
'' lowered: it declines rather than jumping without one. The parser was recording both
'' spellings identically, so it could not have told them apart.
'' THE GOLDEN USED TO RECORD THIS PROGRAM PRINTING NOTHING FOR 1, 2 AND 3, and a comment
'' here explained it away. It said the "blocks repaired" line was the unreachable block a
'' jump leaves behind and "well-formed IR either way" -- true of the repair, and wrong
'' about the cause. The label blocks were EMPTY: each 'l1: print "one" : exit sub' put
'' its print nowhere, because a label following a terminator was never lowered at all
'' (LowerStmt returned on a dead cursor before reaching it). The computed goto dispatched
'' correctly into blocks that did nothing.
''
'' So this test passed while the statement it tests was broken, and the golden was the
'' evidence. It now prints what fbc prints:
''
''     fell through / one / two / three / fell through / fell through
declare sub pick( byval n as long )

pick( 0 )
pick( 1 )
pick( 2 )
pick( 3 )
pick( 4 )
pick( -1 )
end

sub pick( byval n as long )
    on n goto l1, l2, l3
    print "fell through"
    exit sub
    l1: print "one" : exit sub
    l2: print "two" : exit sub
    l3: print "three" : exit sub
end sub
