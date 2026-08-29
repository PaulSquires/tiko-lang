'' '@S' OVER A STRING CONSTANT. 'const s = "abc"' emits no variable -- it folds -- so
'' there was no address to take and 'dim as byte ptr p = @s' declined. Measured, fbc
'' hands back the LITERAL'S OWN STORAGE: 'P$0 = (int8*)"abc"', the same global the
'' '@"abc"' spelling already used.
const s = "abc"
dim as byte ptr p = @s
dim as zstring ptr z = @s
print *z, p[0]
