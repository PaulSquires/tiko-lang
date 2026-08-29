'' A CONCATENATION IS WIDE WHEN ITS TERMS ARE. It is an N_BINARY with no type of its
'' own, so the comparison's wide test said no to it and these took the NARROW branch,
'' where the wide operand then declined and the whole comparison went with it. It
'' worked only when the OTHER side was directly wide, which is why some corpus lines
'' lowered and their neighbours did not. fbc: fb_WstrConcat then fb_WstrCompare.
dim as wstring * 8 w = "n="
dim as boolean b1 = ( (w & w) = "n=n=" )
dim as boolean b2 = ( (w & 42) = "n=42" )
dim as boolean b3 = ( (w & w) = (w & w) )
dim as boolean b4 = ( "n=n=" = (w & w) )
dim as boolean b5 = ( (w & w) <> "q" )
print b1; b2; b3; b4; b5

'' A CHAIN CARRYING ALL THREE WIDTHS. The refusal that stood in the ustring fold said a
'' narrow-plus-wide prefix folds into a wide temporary first -- true of 's & w & u', and
'' not of 'w & u & s', where fbc emits fb_WstrToUStr, fb_UStrConcat, fb_UStrConcatUA:
'' the left-to-right fold, term for term. Six orderings were turned away to describe one.
dim as ustring u = "u"
dim as string s = "s"
dim as ustring r1 = w & u & s
dim as ustring r2 = s & w & u
print r1
print r2
