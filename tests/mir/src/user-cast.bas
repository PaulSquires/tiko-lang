'' A UDT CONVERTED IMPLICITLY BY 'operator cast', and the parser bug that hid it.
''
'' 'trim( u )' over a UDT is not an error and not a decline: fbc calls the conversion
'' operator and passes what it gives back. Measured, for a byref-zstring operator:
''
''     char* vr$4 = _ZN1UcvcEv( &UV$1 );
''     FBSTRING* vr$5 = fb_StrAllocTempDescZ( (char*)vr$4 );
''     FBSTRING* vr$6 = fb_TRIM( (FBSTRING*)vr$5 );
''     fb_StrAssign( (void*)&R$1, -1ll, (void*)vr$6, -1ll, 0 );
''
'' A BYREF ZSTRING RESULT IS A BARE char*, not a descriptor, so it borrows a temporary
'' one from the NO-LENGTH entry point -- and in an assignment it passes LENGTH 0, not -1
'' and not the destination's count. All three shapes below are what fbc emits, call for
'' call, down to the mangled name.
''
'' WHAT ACTUALLY BROKE THIS: 'function F( ) BYREF as T' put the BYREF between the
'' parameter list and the AS, so the parser's Accept( AS ) failed on it and the trailing-
'' modifier loop ate the whole return type. EVERY byref-returning function in the corpus
'' reached Collect with NO RESULT TYPE AT ALL -- most of fb/result.bi and fb/optional.bi,
'' and every conversion operator declared that way. Nothing said so: an untyped result is
'' not a diagnostic.
''
'' The WIDE half is below. A byref wstring result is a bare uint16*, which is exactly
'' what every wide entry point already wants, so unlike the narrow case there is no
'' descriptor to borrow. It is hooked into WideOperand_ rather than into each call site,
'' because everything wide comes through that one function.
''
'' ONE DIVERGENCE, and it is fbc's OVERLOAD RESOLUTION rather than lowering: for
'' 'trim( wv )' fbc picks the NARROW trim and converts around it --
'' fb_WstrAssignToA into a temporary, fb_TRIM, fb_WstrAssignFromA back -- where fbx
'' calls fb_WstrTrim on the converted pointer directly. Same value, three calls fewer.
''
'' Implicit user conversion to a NUMBER is the same idea at a different set of call
'' sites and is still missing.

type U
    s as zstring * 50
    declare operator cast( ) byref as zstring
end type
operator U.cast( ) byref as zstring
    return this.s
end operator
sub P( )
    dim as U uv
    dim as string r
    dim as zstring * 50 z
    r = trim( uv )
    r = uv
    z = uv
end sub

type W
    s as wstring * 50
    declare operator cast( ) byref as wstring
end type

operator W.cast( ) byref as wstring
    return this.s
end operator

sub Q( )
    dim as W wv
    dim as wstring * 50 z
    dim as string r
    z = trim( wv )     '' fb_WstrTrim on the converted pointer
    z = wv             '' fb_WstrAssign( Z, 50, vr )
    r = wv             '' fb_WstrAssignToA( &R, -1, vr, 0 )
end sub
