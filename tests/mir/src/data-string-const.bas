'' A STRING CONSTANT IN A DATA BLOCK, narrow and wide, and an ADDRESS datum.
'' Measured, fbc's descriptor for the three below:
''
''   { (int16)3, (void*)"abc" }, { (int16)-32765, (void*)L"123" },
''   { (int16)-2, (void*)"foo" }, { (int16)-1, (void*)0ull }
''
'' -- 3 is the length, -32765 is 3 with bit 15 set for a WIDE datum, and -2 says the
'' NODE is an ADDRESS rather than text.
const S  = "abc"
const V1 = wstr( "123" )

dim ns as string
dim ws as wstring * 32
dim ps as zstring ptr

data S, V1, @"foo"
read ns
read ws
'' A POINTER target reads as an unsigned word: fbc emits fb_DataReadULongint.
read ps
print ns, ws, *ps
