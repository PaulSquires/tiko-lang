'' A ustring array initialised from an ALL-NARROW concatenation: folded narrow, transcoded once.
dim as string bs = "bytes"
dim as ustring a( 0 to 2 ) = { bs & "!", "x", bs & bs }
print "A:" & a( 0 ) & "|" & a( 1 ) & "|" & a( 2 ) & "|" & len( a( 2 ) )
