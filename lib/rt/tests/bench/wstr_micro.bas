'' wstr_micro.bas -- the benchmark RFC-0004 section 3.3 predicted would fail.
''
'' The trim family is built out of the `static __inline__` helpers in
'' fb_unicode.h -- 21 of the 38 in the whole runtime. C inlines them; fbc has no
'' inliner, so tiko-rt expresses them as #macro (src/inc/wstr.ti). If that
'' mitigation does not work, it should show here more than anywhere else.
''
'' The loops are deliberately trim-heavy and allocate a result every pass, which
'' is what the real entry points do.

const N = 100000

dim as double t0
dim as wstring * 128 padded, clean_, wide_
dim as integer guard = 0

padded = wstr("          the quick brown fox          ")
clean_ = wstr("the quick brown fox")
wide_  = wstr("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa")

t0 = timer
for i as integer = 1 to N
    guard += len( trim( padded ) )
next
print "wtrim_padded "; timer - t0

t0 = timer
for i as integer = 1 to N
    guard += len( trim( clean_ ) )
next
print "wtrim_nothing "; timer - t0

t0 = timer
for i as integer = 1 to N
    guard += len( ltrim( padded ) )
next
print "wltrim "; timer - t0

t0 = timer
for i as integer = 1 to N
    guard += len( rtrim( padded ) )
next
print "wrtrim "; timer - t0

t0 = timer
for i as integer = 1 to N
    guard += len( wide_ )
next
print "wlen "; timer - t0

'' Compare EQUAL strings, not strings that differ at position 0.
''
'' The first version compared `clean_` against `padded`, which differ in the
'' first character. tiko-rt returned at once and came out 25x "faster" -- an
'' early exit, not a faster compare, and precisely the kind of number this
'' project has already thrown away three times. Equal strings are the honest
'' worst case: both implementations must read every character.
dim as wstring * 128 same1, same2
same1 = wstr("the quick brown fox jumps over the lazy dog")
same2 = wstr("the quick brown fox jumps over the lazy dog")
t0 = timer
for i as integer = 1 to N
    if( same1 = same2 ) then guard += 1
next
print "wcompare_equal "; timer - t0

if guard < 0 then print "impossible"
