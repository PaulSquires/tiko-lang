'' A CONCATENATION AS A DECLARATION'S INITIALISER. fb_StrInit takes ONE source, so a
'' chain cannot go through it: the descriptor is zeroed to a valid empty string and the
'' chain is then built into it the ordinary way, assign followed by concat-assign.
''
'' It was routed through the DECLARATION NODE, which is not an expression and has no
'' address, so it produced nothing -- and the caller discarded the false it came back
'' with, which is what made 'dim as string a = b + c' emit the zeroed descriptor and
'' DROP THE INITIALISER with nothing declined. Through the SLOT instead.
dim as string b = "1"
dim as string c = "2"
dim as zstring * 8 z = "3"

dim as string a0 = b + c
dim as string a1 = z + z
dim as string a2 = b + c + z
dim as string a3 = b + "lit"
print a0; a1; a2; a3

'' The assignment form was already right and stays the shape fbc emits: one fb_StrAssign
'' then one fb_StrConcatAssign per further term, with no temporary at all.
dim as string r
r = b + c
print r
