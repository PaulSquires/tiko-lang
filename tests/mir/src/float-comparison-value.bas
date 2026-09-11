'' A COMPARISON'S RESULT IS AN INTEGER, whatever the expression around it wants.
''
'' The binary lowering typed the instruction from the EXPRESSION, so a comparison in a
'' double context typed the compare itself as a float and the emitter wrote
''
''     %t51 = zext i1 %t51.c to double
''
'' which is not a cast LLVM has, so the module was refused. The conversion to the wanted
'' type belongs AFTER the negation -- fbc writes '-(A < B)' and converts that -- so -1
'' and 0 become -1.0 and 0.0.
dim as double a = 123.0, b = 123.0, c = 7.0
dim as double r1 = ( a = b )
dim as double r2 = ( a = c )
dim as double r3 = ( a < c )
print r1; r2; r3
dim as single s1 = ( a = b )
print s1
print -( a = b ); ( a <> c )
