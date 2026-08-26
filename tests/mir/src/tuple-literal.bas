'' A TUPLE LITERAL AS A VALUE -- '(1, 2)' on the right of a destructure, and the
'' assignment form of destructuring beside it.
''
'' The synthetic UDT a tuple desugars into is keyed by its ELEMENT TYPES, and Resolve --
'' which builds the one a written tuple TYPE needs -- has no expression types to key it
'' by. So a bare literal had NO TYPE, the destructure found no elements, and the
'' statement declined; the same statement with a CALL on the right worked, because a
'' call has a result type. tuple/destructure.bas is half literals.
''
'' Measured from what fbc emits, which is the same temporary either way:
''
''     *(int64*)&TMP$4 = 3ll;
''     *(int64*)((uint8*)&TMP$4 + 8ll) = 4ll;
''     TMP$5 = &TMP$4;
''     A = (int32)*(int64*)TMP$5;
''     B = (int32)*(int64*)((uint8*)TMP$5 + 8ll);
''
'' -- built field by field, then read back through its address. Note the elements of
'' '(3, 4)' are INTEGER, not the destination's LONG, and each is converted on the way
'' out; that is what the temporary is for.
''
'' The swap is the reason every element is read before any is written. Run under fbc
'' this program prints
''
''      1 2
''      3 4
''      4 3
''     yx

dim as long a, b
let (a, b) = (1, 2)
print a; b

'' The ASSIGNMENT form -- no 'let'.
(a, b) = (3, 4)
print a; b

(a, b) = (b, a)
print a; b

dim as string s1 = "x", s2 = "y"
(s1, s2) = (s2, s1)
print s1; s2
