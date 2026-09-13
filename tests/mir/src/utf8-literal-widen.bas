'' A NARROW LITERAL IN A UTF-8 SOURCE IS WIDENED BY CHARACTER, NOT BY BYTE. fbc-modern decodes
'' it as UTF-8 at every CHAR->WCHAR fold; tiko made one unit of every byte, so 'Ω日' was 5
'' units where fbc has 2, and fbsqlite's test_unicode built 5000 where it asked for 2000.
'' An ESCAPE's bytes stay one unit each ('!"\206\169"' is 2), as fbc-modern keeps
'' them. fbc prints: 2 2 2 2 2 2 2 3 2, then 5 4 5 3 4.
''
'' AND A NARROW NEEDLE FOR A USTRING INSTR IS CONVERTED. fbc passes 'instr( u, "cd" )' a
'' UTF-16 literal; tiko handed fb_UStrInstr the narrow descriptor and every narrow needle,
'' ASCII or not, answered 0.
dim as wstring * 10 e1 = !"\206\169"
print len( e1 )
dim as ustring e2 = !"Ω\n"
print len( e2 )
dim as ustring e3 = "Ω" "日"
print len( e3 )
const K = "Ω日"
dim as ustring e4 = K
print len( e4 )
dim as ustring e5 = "😀"
print len( e5 )
dim as wstring * 10 e6 = "😀"
print len( e6 )
dim as string e7 = "Ω"
print len( e7 )
dim as ustring e8 = "x"
e8 &= "日" & "Ω"
print len( e8 )
print len( wstr( "Ω日" ) )
dim as ustring u = "abΩ日cd"
dim as string nar = "cd"
print instr( u, "cd" )
print instr( u, "日" )
print instr( u, nar )
print instrrev( u, "Ω" )
print instr( 2, u, "日" )
