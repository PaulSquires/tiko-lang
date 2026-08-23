'' 'a &= b' AND 'a += b' OVER A STRING ARE THE SAME STATEMENT, and both are an append.
'' Measured: fbc emits 'fb_StrConcatAssign( &S, -1ll, src, len, 0 )' for either
'' spelling. '&=' used to lower to fb_StrAssign -- an ASSIGNMENT -- which emitted code,
'' verified, and counted as fully lowered while being wrong every time.
dim as string s = "a", t = "q"
s &= "b"
s += "c"
s &= t
s += t

'' A FIXED WIDE STRING with a wide source is one call as well:
''     fb_WstrConcatAssign( W, 10ll, W2 )
dim as wstring * 10 w, w2
w &= w2
w += w2
