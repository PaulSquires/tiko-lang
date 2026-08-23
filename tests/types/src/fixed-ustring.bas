'' 'ustring * N' IS N UTF-16 UNITS, not N descriptors.
''
'' Measured: fbc gives 'type Cell : as ustring * 4 text : end type' a sizeof of 8, and
'' tiko-lang gave it 96 -- an array of four 24-byte USTRING DESCRIPTORS. Every object
'' holding one was twelve times too big, every field after it sat at the wrong offset,
'' and it lowered and verified. The same shape 'string * N' was fixed for.
''
'' TWO BYTES ON EVERY TARGET. A ustring is UTF-16 code units everywhere, unlike a
'' wstring whose unit is 2 bytes on Windows and 4 on Linux, so the size cannot come
'' from wcharBytes.
type Cell
    as ustring * 4 text
end type

type Mixed
    as long        before_
    as ustring * 2 u
    as long        after_
end type

dim c as Cell
dim m as Mixed
print len( c.text ), m.before_, m.after_
