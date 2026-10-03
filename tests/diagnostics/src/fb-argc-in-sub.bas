'' T80: inside a procedure __FB_ARGC__ is not declared -- fbc's error 42 -- because it
'' is main's parameter, not a global.
sub Show( )
    print __FB_ARGC__
end sub
Show( )
