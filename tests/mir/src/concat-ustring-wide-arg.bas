'' A concatenation with a ustring term, passed to a byref ustring parameter, is a ustring chain.
sub TakeMsg( byref msg as ustring )
    print "["; msg; "]"
end sub
dim as ustring wanted = "VFV"
dim as long examined = 2
TakeMsg( "exactly " & wchr( 34 ) & wanted & wchr( 34 ) & " (" & str( examined ) & " near)" )
