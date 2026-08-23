'' CONCATENATION AND COMPARISON OVER A FIXED-LENGTH STRING. 'zstring * N' is an ARRAY
'' of TY_ZSTRING rather than a builtin of its own -- and so are 'wstring * N',
'' 'string * N' and 'ustring * N' -- so every one of them fell out at BinaryResult's
'' builtin-only guard and had no type at all.
''
'' Measured with fbc, and the flavour of the RESULT is the part a guess gets wrong:
''
''     z + z        STRING       fb_StrConcat
''     f + f        STRING
''     z + "x"      STRING
''     w + w        WSTRING      fb_WstrConcat
''     *pw + *pw    WSTRING
''     z = z        INTEGER      every comparison, whatever the flavour
''
'' WSTR is measured too: 'WSTRING * 1' for every argument fbc accepts except a fixed
'' wstring, which keeps its own length. Untyped, it made every chain containing one
'' look entirely narrow.
dim as zstring * 8 z = "12"
dim as wstring * 8 w = wstr( "12" )
dim as string * 8 f = "12"
dim as string s = "12"
dim as wstring ptr pw = @w
dim as long i = 5

dim as string r0 = z + z
dim as string r1 = f + f
dim as string r2 = z + "x"
dim as string r3 = z + s

print w + w
print *pw + *pw
print w + wstr( "x" )
print wstr( i ) + w

'' Every comparison is an INTEGER whatever flavour it was handed.
if z = z then print "z"
if f = f then print "f"
if w = w then print "w"

'' The shape the corpus writes: a fixed-string concatenation as a SELECT CASE subject.
select case z + z
case "1212" : print "sel-z"
end select
select case w + w
case wstr( "1212" ) : print "sel-w"
end select
