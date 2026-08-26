'' 'wstr( fs )' OVER A 'string * N', which produced nothing and took the enclosing
'' statement with it.
''
'' A 'string * N' IS NOT A CHAR ARRAY THE WAY A ZSTRING IS: it is SPACE-PADDED and
'' carries no terminator, so its N bytes cannot be handed to fb_StrToWstr as a C string.
'' Measured, fbc copies it into a var-length temporary first and converts THAT:
''
''   fb_StrAssign( &TMP$2$0, -1ll, (void*)FS$0, -9223372036854775798ll, 0 );
''   vr$6 = fb_StrToWstr( (char*)*(char**)&TMP$2$0 );
''
'' -- the second argument being the TAGGED length of the fixed string, which is what
'' tells the runtime to stop at N bytes and trim the padding. StrSwapKind_ hands that
'' length back ALREADY ENCODED, and it is a 64-bit constant, so it goes through
'' PushStrLen_: tagging it twice, or pushing it as a ulong, both produce a plain 10 and
'' the runtime then reads past the end of a shorter string.
''
'' fbc emits a third call after those two, copying the temporary BACK into the fixed
'' string, which is its general byref-temp protocol; nothing here writes the temporary,
'' so it is a no-op and is not reproduced.
dim fs as string * 10 = "abc"
dim as zstring * 7 fz = "de"
dim as string s = "fg"

print wstr( fs )
print wstr( fz )
print wstr( s )

'' ...and in an expression that consumes it. 'len( wstr( x ) )' declined for EVERY
'' flavour, not just this one: the wide branch of LEN asked for an ADDRESS, and a wide
'' EXPRESSION has none. WideOperand_ is what builds one, and is what every other wide
'' site already uses.
print len( wstr( fz ) )
