'' Three shapes from quirk/zwstr-deref.bas, which declined all four of its statements.

'' 1. A WIDE SOURCE INTO A 'string * N'. Only 'zstring * N' was accepted, so this fell
''    to the narrow path, found no narrow source and declined. Its length is the
''    SIGN-BIT-TAGGED one and its last argument is -1, not 0 -- 'string * N' is the one
''    narrow kind that pads. fbc:
''      fb_WstrAssignToA( (void*)F$0, -9223372036854775777ll, (uint16*)PW$0, -1 )
dim as wstring * 32 w0 = "123"
dim as wstring ptr pw = @w0
dim as zstring ptr pz = cptr( zstring ptr, @"1x" )
dim as string * 31 f
f = *pw
dim as string * 9 g = *pw

'' 2. A BARE zstring/wstring SUBSCRIPTED. '*pz' is a TK_BUILTIN, so neither the
''    var-length branch nor the array branch typed it and '(*pz)[0]' had no type at all;
''    a SELECT CASE over one had nothing to switch on. fbc: UBYTE and USHORT.
select case( (*pz)[0] )
case asc( "1" ) : print "ok z"
end select
select case( (*pw)[0] )
case asc( "1" ) : print "ok w"
end select

'' 3. WSPACE was the one wide string intrinsic left untyped, and an untyped TERM makes
''    the whole concat it is in look narrow -- so the comparison took the narrow branch
''    and declined, while 'w + whex(255)' beside it lowered. fbc: 'WSTRING * 1'.
dim as string s = "123" + space(28)
dim as boolean b = ( s = wstr( "123" ) + wspace(28) )
print b
