'' USTRING -- the UTF-16 string flavour, which has its OWN descriptor and its own
'' runtime entry points.
''
'' It shares every SHAPE with the narrow family, and that symmetry is exactly why it
'' was a miscompile: IsStringType says yes to both, so every narrow path claimed it.
'' 'dim as ustring v = "x"' lowered to fb_StrInit with a NARROW literal -- a UTF-16
'' descriptor holding narrow bytes -- and fb_StrDelete was called on an FBUSTRING. It
'' compiled, it verified, and it counted as lowered.
''
'' THE LENGTH ARGUMENT IS TAGGED, and the tag is not guessable. Measured:
''   var-length     -1
''   literal        &h8000000000000000 or <character count>, the NUL NOT counted --
''                  unlike the narrow family, where fb_StrInit is passed len+1
''   'ustring * N'  &h8000000000000000 or (N-1), so capacity is N-1 as 'zstring * N' is
'' and the trailing int32 is -1 for a FIXED destination and 0 for a var-length one.
dim as ustring a = "x"
dim as ustring b

'' fb_UStrAssign, from another ustring and from a literal.
b = a
b = "y"

'' A CONCATENATION is assign-then-concat-assign, the same chain the narrow family uses.
b = a & "y"
b &= "z"

'' fb_UStrLen counts CODE UNITS; fb_StrLen would read the same 24 bytes as a narrow
'' descriptor.
dim as long n = len( a )

'' fb_UStrCompare, with the literal on the other side following the ustring's flavour.
dim as long c = 0
if a = "x" then c = 1

'' fb_PrintUStr, not fb_PrintString -- which would print the UTF-16 bytes as narrow.
print a, b, n, c
