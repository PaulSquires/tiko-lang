'' AN IDENTICAL REDEFINITION IS ACCEPTED, and only an identical one.
''
'' Measured: '#define A 1' twice is fine and '#define B 1' then '#define B 2' is fbc's
'' error 4. tiko compared the LITERAL POOL INDEX, and a string literal is stored as a
'' RAW SPAN -- file, offset, length -- so the same text written twice is two pool
'' entries with two indices and every such redefinition counted as DIFFERENT.
''
'' win/shobjidl.bi writes the same '#define STR_AVOID_DRIVE_RESTRICTION_POLICY
'' wstr("Avoid Drive Restriction Policy")' on two consecutive lines, so the whole header
'' was unusable.
#define N 1
#define N 1
#define S "a b"
#define S "a b"
#define W wstr("x y")
#define W wstr("x y")
#define F 1.5
#define F 1.5

print N; S; F
