'' A TEMPORARY BUILT ON ONE PATH OF A SHORT-CIRCUIT OR AN IIF IS RELEASED ON THAT PATH. fbc's C
'' for 'if left( w, 1 ) <> "[" andalso right( w, 1 ) <> "]"' deletes right( )'s temporary
'' inside the right-hand branch and left( )'s after the join. tiko deleted both after the
'' join, so when the right side did not run -- the second call below -- fb_WstrDelete freed
'' whatever that stack slot still held: the first call's pointer, already freed. The output
'' was right and the process died on exit with 0xC0000374. Every call made alone was clean.
''
'' fbc prints: a |c | 3 / plain / 2 / [ |] | 3 / 0 and exits 0.
sub T1( byref w as const wstring )
	print left( w, 1 ); "|"; right( w, 1 ); "|"; len( w )
	if left( w, 1 ) <> "[" andalso right( w, 1 ) <> "]" then print "plain"
	dim as long k = iif( left( w, 1 ) = "a", len( right( w, 2 ) ), 0 )
	print k
end sub
T1( "abc" )
T1( wstr( "[x]" ) )
