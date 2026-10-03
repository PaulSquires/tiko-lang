'' T73: a lambda capture that names no variable is reported at the capture, as
'' fbc's error 354 is -- whether or not the body uses another name.
dim as long total = 0
var add = sub[ byref totl ]( byval n as long )
    total += n
end sub
var show = sub[ byval missing ]( )
    print 1
end sub
var fine = sub[ byref total ]( )
    total += 1
end sub
fine( )
