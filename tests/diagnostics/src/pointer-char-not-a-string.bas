'' THE OTHER HALF OF THE POINTER-CHARACTER RULE: what fbc REFUSES beside what it takes.
'' Each of the three below is fbc error 24, "Invalid data types", measured; the deref
'' and index forms over a POINTER are accepted and live in tests/mir/pointer-char-init.
dim as zstring * 8 z = "Abc"
dim as string s = "c"
dim as ulong d = z          '' a 'zstring * 8' VARIABLE is not a character
dim as ulong e = s          '' nor is a STRING
dim as ulong f = "97"       '' nor is a literal -- not even a numeric-looking one
