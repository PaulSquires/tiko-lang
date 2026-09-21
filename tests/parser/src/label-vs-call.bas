'' 'name :' IS A LABEL ONLY WHEN 'name' IS NOT A PROCEDURE -- fbc's parser-label.bas
'' checks for a procedure of that name before it makes a label. tiko made one of every
'' 'name :', and SLEEP, KILL, BEEP and the rest are predeclared procedures rather than
'' reserved words, so 'Sleep : End 0' -- how the FreeBASIC help's PUT example ends --
'' was a label named sleep and an END: the program closed without waiting.
sub foo( )
end sub
foo : print "a call to foo, then a print"
sleep : end 0
beep : print "a call to beep"
here: print "a label"
