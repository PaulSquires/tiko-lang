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
