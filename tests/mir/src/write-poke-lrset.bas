'' WRITE, POKE, LSET and RSET -- four statements that are each one runtime call or one
'' store, with the shape measured from fbc rather than assumed from the keyword.

sub P( )
    dim as string s1 = "a", s2 = "b"
    dim as zstring * 8 z
    dim as wstring * 8 w, w2
    dim as long l : dim as double dd : dim as byte b
    dim as integer q

    '' WRITE is one-to-one with PRINT minus SPC, TAB and USING. Its ONLY separator is
    '' ',' -- fbc rejects 'write s;' with error 3 -- so the only masks it can produce
    '' are 2 for 'a comma follows' and 1 for end of statement. A trailing comma keeps
    '' the 2 and emits no newline.
    write l, s1, dd, b
    write #1, l, s1
    write
    write l,

    '' POKE is a typed STORE THROUGH AN ADDRESS, not a call, and the two-argument form
    '' is UBYTE. The type argument arrives as an N_IDENT, not a type reference: the
    '' intrinsic argument parser reads every argument as an expression and 'byte' is a
    '' keyword that parses as a name.
    ''
    '' The destination has to be a pointer VALUE. 'store @p, v' means 'into the slot p'
    '' in this IR, so '@p' had to be materialised or an i8 went into an i64 slot.
    poke byte, @q, 5
    poke integer, @q, 7
    poke @q, 3

    '' LSET/RSET pad or truncate INTO a destination that already has storage. A ZSTRING
    '' destination has no descriptor, so it borrows a temporary one. Its payload is ONE
    '' child -- an N_BINARY '=' -- not two.
    lset s1 = s2
    rset s1 = s2
    lset z = s2
    lset w = w2
    rset w = w2
end sub
