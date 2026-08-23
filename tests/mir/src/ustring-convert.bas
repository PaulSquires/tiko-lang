'' USTRING CONVERSION -- the surface that was ENTIRELY MISSING and silently wrong.
''
'' A ustring never converts by copying: it TRANSCODES, and the entry point depends on
'' the flavours of BOTH sides. The flavour used to come from the DESTINATION alone and
'' every term was pushed as if it shared it, so 'u = q' over a narrow string called
'' fb_UStrAssign and put UTF-8 bytes in a UTF-16 descriptor. It lowered, it verified,
'' and it was wrong every time.
''
'' Every line below was read out of what fbc emits, one statement at a time:
''
''   u = q              fb_UStrAssignFromA( u, -1, q, -1, 0, 0 )
''   dim as ustring = q fb_UStrAssignFromA( ..., -1 )   the flag is the declaration
''   u = p              fb_WstrToUStr( p ) then fb_UStrAssign
''   s = u              fb_UStrAssignToA( s, -1, u, -1, 0, 0 )
''   u = q + q          fb_StrConcat into a temporary, then ONE fb_UStrAssignFromA
''   u = u + q          fb_UStrConcatUA( t, u, q ) then fb_UStrAssign
''   u = q + u          fb_UStrConcatAU( t, q, u ) then fb_UStrAssign
''   v = q + u + r      ConcatAU( t1, q, u ) then ConcatUA( t2, t1, r )
''   v = q + r + u      StrConcat( t1, q, r ) then ConcatAU( t2, t1, u )
''   v = "lit" + q + u  the literal folds NARROW first -- a neutral term takes the
''                      accumulator's flavour, not the destination's
''   if u = q           fb_StrToUStr( q, -1 ) and only then fb_UStrCompare
''   if u = p           fb_WstrToUStr( p ) and only then fb_UStrCompare
''
'' so the chain is a LEFT-TO-RIGHT FOLD with a fresh temporary per step, and the entry
'' point names which side is the ustring: UA when the accumulator is, AU when the term
'' is, plain UStrConcat when both are and fb_StrConcat when neither is.
sub t( byref p as const wstring, byref q as const string, byref r as const string, _
       byref z as const zstring )
    dim as ustring u, v
    dim as string s

    u = q
    u = z
    u = p
    s = u

    u = q + q
    u = u + q
    u = q + u
    u &= q
    v = q + u + r
    v = q + r + u
    v = u + q + r
    v = "lit" + q + u
    v = p + u
    v = u + p
    s = q + u + r

    dim as ustring d1 = q
    dim as ustring d2 = q + q
    dim as ustring d3 = p
    dim as string  d4 = u

    if u = q then print 1
    if u = p then print 2
    if u < q then print 3
    if u = "lit" then print 4
    if s = u then print 5

    print u, v, s, d1, d2, d3, d4
end sub

'' ONE MEASURED SHAPE IS REFUSED rather than approximated: a chain with a NARROW term,
'' a WIDE one and a ustring folds the narrow prefix into a WIDE temporary first --
'' 'fb_WstrConcatAW' then 'fb_WstrToUStr' -- which is the wide path's business. It
'' declines, so this file keeps it out rather than asserting a wrong answer.
