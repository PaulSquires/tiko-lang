'' 'const as ulongint u = 1' -- the TYPE-FIRST form. DIM has always had it; CONST did
'' not, so 'as' was read as the constant's NAME and everything after it discarded: no
'' type, no value, no 'u', and NO DIAGNOSTIC.
''
'' It surfaced only on the SECOND such declaration, as a redeclaration of 'as' -- and it
'' was the largest single line-shape in the largest remaining bucket, twenty files.
''
'' Measured: fbc accepts a comma list too, with the type shared across it exactly as
'' DIM shares one.

const as ulongint u = 1
const as ubyte a = 1, b = 2
const v as ulongint = 2
const w = 3

print u, a, b, v, w
