'' '##_' AT THE END OF A MACRO BODY LINE IS A LINE JOIN, and what it joins is the NEXT
'' end of line -- wherever that comes from. Three shapes, all measured against fbc's
'' own '-pp' output:
''
''   mid-body      '1 + ##_' then '2' on the next body line
''                 -> 'dim q as long = 1 + 2', and the line after it is UNTOUCHED. So
''                    exactly one EOL goes, not every EOL after the join
''
''   end of body   'dim r as long = 3 + ##_' as the last body line
''                 -> the EOL that goes is the INVOCATION's, so the rule cannot be
''                    "drop a body EOL"
''
''   the array     '#define ENT(x) x, ##_' between a BEGIN and an END macro
''                 -> one statement, which is what pp/token-pasting.bas is built on
''
'' Neither half does it alone: '##' at end of line without the '_' is fbc error 9 and
'' the '#' survives into the output, and '_' alone does not continue across a macro
'' boundary.
#macro MIDJOIN( )
dim as long q = 1 + ##_
2
dim as long qq = 7
#endmacro

#macro ENDJOIN( )
dim as long r = 3 + ##_
#endmacro

#macro BEGARRAY( )
dim as long arr(0 to ...) = { ##_
#endmacro
#macro ENDARRAY( )
99 }
#endmacro
#define ENT( x ) x, ##_

MIDJOIN( )
ENDJOIN( )
4

BEGARRAY( )
ENT( 11 )
ENT( 22 )
ENDARRAY( )

print q, qq, r, arr(0), arr(1), arr(2)
