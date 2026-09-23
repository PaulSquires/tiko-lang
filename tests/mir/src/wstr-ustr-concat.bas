'' A CONCATENATION WITH A USTRING IN IT, INTO A WSTRING, KEEPS THE USTRING.
''
'' 'dim wsz2 as wstring * 260 = dv & " " & ustr & " literal " & wsz' printed without its
'' ustr: the fixed-wstring assignment split the chain into an assign and a concat-assign,
'' found no concat-assign for the USTRING term and dropped it -- and a plain 'w = "x" & u'
'' and every 'w &= u' dropped the whole statement. The chain is one ustring value, and
'' fbc assigns it with one fb_UStrAssignToW; '&=' reads the destination into a ustring,
'' appends and assigns back. fbc prints what this file prints, byte for byte -- each
'' form at module level and inside a SUB; goldenrun executes it.
dim as ustring u = "U"
dim as wstring * 64 w1 = "x" & u
dim as wstring * 64 w2 = "a" & " " & u & " b " & w1
dim as wstring * 64 w3
w3 = "y" & u
dim as wstring * 64 w4 = "c"
w4 &= u
w4 &= "d" & u
dim as wstring * 64 buf
dim as wstring ptr wp = @buf
*wp = "p" & u & "q"
dim as ustring e
dim as wstring * 64 w5 = "e" & e & "f"
print w1 = "xU", w2 = "a U b xU", w3 = "yU", w4 = "cUdU", buf = "pUq", w5 = "ef"
sub inproc( byref u as ustring )
    dim as wstring * 64 w = "[" & u & "]"
    w &= u
    print w = "[U]U"
end sub
inproc( u )
