'' WCHR -- the wide twin of CHR, variadic like it, and what happens when its result is
'' appended to a USTRING.
dim as long code_ = 34
dim as wstring * 8 w
w = wchr( code_ )
w = wchr( code_, code_ )

dim as ustring cur
cur &= wchr( code_ )
dim as ustring x = wchr( code_ )
print w, cur, x

'' ...and WSTR of a narrow CONCATENATION, which has no address: fbc builds it into a
'' temporary descriptor and converts that.
dim as string s2 = "ab"
dim as wstring * 16 w2
w2 = wstr( "asd" + chr( 65 ) )
w2 = wstr( s2 + "x" )
print w2
