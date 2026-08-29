'' A USTRING SOURCE INTO A WIDE DESTINATION IS ONE RUNTIME CALL, and it had no emit site
'' at all -- RTL_USTR_TO_W has been in the table since it was written and nothing used
'' it. The fixed-length form did not even decline: it fell to the generic scalar path,
'' found a non-void type, and STORED THE 24-BYTE USTRING DESCRIPTOR into a 16-byte
'' wstring buffer -- wrong bytes and an eight-byte overrun, verifier clean, 0 statements
'' not lowered.
''
'' Measured, and the LENGTH is the destination's element count plainly, not the
'' sign-tagged form the narrow fixed strings use:
''
''     w  = s   over a 'wstring * 8'   fb_UStrAssignToW( W$0, 8ll, &S$0, -1ll )
''     *wp = s  over a 'wstring ptr'   fb_UStrAssignToW( WP$0, 0ll, &S$0, -1ll )
''
'' and run, both print hi.
dim as ustring s = "hi"
dim as wstring * 8 w
w = s
print w

dim as wstring * 8 w2
dim as wstring ptr wp = @w2
*wp = s
print *wp
