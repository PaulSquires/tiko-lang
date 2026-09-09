'' A LABEL AFTER 'EXIT SUB' IS STILL A LABEL. 'exit sub' and 'return' end their block and
'' leave no cursor -- correctly, since nothing falls into what follows -- and every later
'' statement was then dropped in silence, the label included. So this lowered to the
'' first print and a ret: 'tail:' and everything after it produced no code and no
'' diagnostic, while fbc compiles the same source and lets a GOTO reach the label.
''
'' It is not a dead-code curiosity: 'exit sub' before the handler's label is how an error
'' handler is written, so the whole handler disappeared.
''
'' Measured against fbc, which prints 'one two done'.
sub viaExitSub( byval jump as integer )
    if jump then goto tail
    print "one"
    exit sub
    tail:
    print "two"
end sub

'' RETURN IS THE SAME STATEMENT for this purpose, and had the same hole.
sub viaReturn( byval jump as integer )
    if jump then goto tail2
    print "three"
    return
    tail2:
    print "four"
end sub

viaExitSub( 0 )
viaExitSub( 1 )
viaReturn( 0 )
viaReturn( 1 )
print "done"
