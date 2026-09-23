'' INSTR OVER A USTRING, the forms that were missing. Three causes, each measured:
''
''   instr( 2, uf, "2" )        a 'ustring * N' as the TEXT of the three-argument form: Check
''                              counted only 'string * N' in that slot, so the call was
''                              untyped and the statement declined
''   instr( 2, u, any "ab" )    the 'any' form over a ustring: fbc calls fb_UStrInstrAny,
''                              and tiko declined, believing there was none
''   instr( 1, u & "x", "x" )   a CONCATENATION with a ustring term, typed STRING by Check:
''                              it went to the NARROW fb_StrInstr over UTF-16 and gave 0
''
'' fbc prints: 2 3 7 5 4 / 3 2
dim as ustring u = "12a2b2"
dim as ustring un = "2"
dim as ustring * 10 uf = "12a2b2"
dim as long k = 3
print instr( 2, uf, "2" ); instr( 2, u, any "ab" ); instr( 1, u & "x", "x" ); instrrev( u, any "ab", 5 ); instr( k, uf, un )
print instrrev( uf, "a", 5 ); instr( 2, u & "x2", "2" )
