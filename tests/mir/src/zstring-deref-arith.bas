'' A BARE ZSTRING OR WSTRING -- what dereferencing a pointer to one gives -- DECAYS TO
'' ITS FIRST CHARACTER against a number. Untyped, the concat fallback won and
'' 'print *p + 0' came out as fb_StrConcat and printed "abc0" where fbc prints 97. It
'' verified and declined nothing. Measured, all of it:
''
''     *p + 0    INTEGER      *p + 1.5  DOUBLE     *p & "x"  STRING
''     *pw + 0   INTEGER      not *p    INTEGER    - *p      INTEGER
''     s + 0     error 20     z + 0     error 20   *p + *p   error 20
''
'' -- so a var-length string and a 'zstring * N' do NOT decay, and neither does a pair
'' of bare ones. fbc writes '(int64)*P$0', the first character, ZERO-extended, and run
'' over "abc" prints 97, 194, 1, 98.5, -98, -97.
dim s as string = "abc"
dim p as zstring ptr = strptr( s )
print *p + 0
print *p * 2
print *p and 15
print *p + 1.5
print not *p
print - *p

'' The wide half, whose character is a USHORT.
dim w as wstring * 4 = "abc"
dim pw as wstring ptr = @w
print *pw + 0
print not *pw

'' ...and '&' is a CONCATENATION either way.
print *p & "x"

'' A COMPARISON AGAINST A NUMBER decays too -- fbc writes '(int64)(uint8)*P$0 >= 65ll',
'' a NUMERIC comparison and not a string one. Against a string it stays fb_StrCompare.
print (*p >= 65); (*p >= 98); (*p = 97)
print (*p = "abc")
dim as long b = not (((*p >= asc("A")) and (*p <= asc("Z"))) or _
                     ((*p >= asc("0")) and (*p <= asc("9"))))
print b
