'' '\uXXXX' IS A CODE UNIT, NOT SIX CHARACTERS OF SPELLING. Measured by RUNNING fbc's
'' own output: the three lengths below are 2, 3 and 3.
dim as wstring * 16 a = !"\u0041\u0042"
dim as wstring * 16 b = !"\u3041\u3043\u3045"
dim as wstring * 16 c = !"A\tB"
print len( a ), len( b ), len( c )
