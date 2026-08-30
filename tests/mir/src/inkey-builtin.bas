'' INKEY was missing from the prelude outright, so 's = inkey' declined -- and an
'' interactive loop is written 's = inkey: while s = "": s = inkey: wend', which is
'' three statements in one line of interactive/input.bas.
''
'' Measured: 'FBSTRING* fb_Inkey( void )', no parameter, the same shape as DATE and
'' TIME beside it.
dim s as string

s = inkey
print s

dim t as string = inkey
print t
