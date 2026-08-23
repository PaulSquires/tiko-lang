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

'' A FIXED 'ustring * N' DESTINATION, whose tag is N MINUS ONE where 'string * N' uses
'' N. Measured, both on win64:
''
''     dim as string  * 8 s   ->  fb_StrInit ( S, &h8000000000000008, ... )
''     dim as ustring * 8 u   ->  fb_UStrInit( U, &h8000000000000007, ... )
''
'' so its capacity is N-1 usable characters, exactly as 'zstring * N' is, and the fixed
'' NARROW string is the odd one out. Nothing about the two spellings says which, and
'' getting it wrong writes one character past the end.
''
'' Before this was modelled the whole declaration emitted NOTHING -- no initialisation
'' at all -- and reported "0 statements not lowered" while doing it. A silent skip is
'' invisible to the decline count by construction.
'' KNOWN DIFFERENCE: fbc uses fb_UStrInit for the DECLARATION and fb_UStrAssign for a
'' later store; the fixed path here uses Assign for both. They are equivalent for a
'' FIXED string -- there is no descriptor to release -- and this predates the ustring
'' work: the narrow 'string * N' path does the same.
dim as ustring * 16 uf = "FreeBasic"
uf = "d"
'' A FIXED USTRING AS A SOURCE TERM passes its address and its tagged length, exactly
'' as the fixed narrow flavour does, and only where the destination is UTF-16 -- narrow
'' bytes and UTF-16 ones are not a length apart. It was not a term at all until this,
'' so the whole initialiser was DROPPED: no call, no store, and nothing declined.
dim as ustring fromFixed = uf
print fromFixed

'' A CONCATENATION AS AN RVALUE goes through fb_UStrConcat into a temporary -- the form
'' that is not being assigned into anything. Measured: fbc emits it only where the
'' result is a genuine rvalue; assigning into a ustring is optimised into
'' assign-then-concat-assign, which is the chain above.
''
'' ANY TERM BEING A USTRING MAKES THE WHOLE CHAIN UTF-16. A literal on its own says
'' nothing, and Check types 'a & b' as a plain string whatever its operands are -- so
'' the chain's own type said NARROW and 'len( a & b )' over two ustrings measured a
'' UTF-16 temporary with fb_StrLen. The terms are asked one at a time instead.
declare sub UTake( byref x as const ustring )
UTake( a & b )
dim as long catLen = len( a & b )
print catLen
