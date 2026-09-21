'' 'name :' IS A LABEL ONLY WHEN 'name' IS NOT A PROCEDURE -- fbc's parser-label.bas
'' checks for a procedure of that name before it makes a label. tiko made one of every
'' 'name :', and SLEEP, KILL, BEEP and the rest are predeclared procedures rather than
'' reserved words, so 'Sleep : End 0' -- how the FreeBASIC help's PUT example ends --
'' was a label named sleep and an END: the program closed without waiting.
''
'' Every name in fbc's keyword and RTL tables was put through 'name : print 1' in both
'' compilers; STICK and STRIG are the only two fbc makes labels of in -lang fb (they
'' are QB-only), and tiko agrees. SYSTEM is one of the 37 runtime procedures tiko
'' declares nowhere. And inside a member body a METHOD'S bare name is 'this.name'.
type T
    declare sub a( )
    declare sub b( )
end type
sub T.b( )
end sub
sub T.a( )
    b : print "a call to this.b"
end sub
sub foo( )
end sub
foo : print "a call to foo, then a print"
sleep : end 0
beep : print "a call to beep"
system : print "a call to system"
stick : print "a label, as in fbc -lang fb"
here: print "a label"
