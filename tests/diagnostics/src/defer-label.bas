'' 'defer :' FIRST ON A LINE, with no procedure named defer, is the label 'defer:', and
'' the print runs at once: fbc-modern 1.20 compiles this and prints "now" then "later".
'' tiko deferred the print across the ':' and printed them the other way round.
sub u( )
    defer : print "now"
    print "later"
    if 0 then goto defer
end sub
u( )
