'' A FIXED-LENGTH STRING FIELD IS ONE LEAF OF A STATIC AGGREGATE IMAGE, not N character
'' ones. 'e as zstring * 5' is spelled as an ARRAY of the character builtin, so the
'' element walk turned it into five leaves while the initialiser writes ONE value for it,
'' and the whole fold declined. Measured, fbc emits the field as a string in the image:
''
''   static struct $2U1 X$0 =
''     { (uint8)18u, (uint16)4386u, "1122", { (uint8)17u, (uint8)34u, (uint8)51u } };
''
'' -- eleven bytes at field = 1: 12 | 22 11 | 31 31 32 32 00 | 11 22 33. A 'string * N'
'' pads with SPACES where the others pad with zeros, which is the rule the array-of-fixed-
'' strings fold already follows.
type U1 field = 1
	a as ubyte
	b as ushort
	e as zstring * 5
	f(0 to 2) as ubyte
end type
static x as U1 = ( &h12u, &h1122u, "1122", { &h11u, &h22u, &h33u } )
print x.a, x.b, x.e, x.f(1)

'' NOT 'string * N'. Measured: fbc REFUSES a UDT holding one in any initialiser --
'' 'static y as U2 = ( 7, "ab" )' is error 7 and the brace form is error 63 -- so it
'' is left declining rather than accepted here.
