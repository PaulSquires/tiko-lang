'' PCOPY was only in the procptr table, so the statement lowered to nothing and the
'' program ran without it -- no diagnostic, the page simply never copied. Both
'' arguments default to -1, which is fbc's rtl-console entry for it:
''
''   pcopy             fb_PageCopy( -1, -1 )
''   pcopy 1           fb_PageCopy( 1, -1 )
''   pcopy 0, 1        fb_PageCopy( 0, 1 )
screenres 32, 24, 32, 2
pcopy
pcopy 1
pcopy 0, 1
dim as long r = pcopy( 1, 0 )
