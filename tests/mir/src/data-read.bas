'' DATA / READ / RESTORE.
''
'' The descriptor is { int16 TYPE; ptr NODE }, packed to 10 bytes on win64 and 6 on
'' win32, with NODE deliberately MISALIGNED at offset 2.
''
'' TYPE IS NOT A DATATYPE. It is the CHARACTER LENGTH of the datum -- 5 for "three",
'' 7 for "-0.0015" -- and -1 marks the terminator, whose NODE is the next block or
'' null. Every item is constant-folded and re-rendered as decimal TEXT, so 'data &hFF'
'' and 'data "255"' are byte-identical.
''
'' The float rendering must be fbc's own STR() digit for digit; see check-str.

data 1, 2, "three"

lbl:
data 4, -1.5e-3, +0.0, &hFF, 1+2

dim as integer a
dim as string s
dim as double dd
dim as byte b
dim as wstring * 8 w

read a, s
read dd, b, w

'' A bare restore targets the head of the chain; 'restore lbl' the first DATA at or
'' after the label. A forward reference is legal, which is why the blocks are
'' collected before any statement is lowered.
restore
restore lbl
