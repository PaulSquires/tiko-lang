'' INPUT INTO A BOOLEAN READS THE WORD, not a byte. fbc has fb_InputBool for it, which
'' parses "true" the way fb_VALBOOL does; sharing the UBYTE row read a NUMBER, so a file
'' holding "true" gave 0. The same mistake cbool over a string made, in the I/O table.
sub FromConsole()
    dim as boolean b
    dim as ubyte u
    input b
    input u
    print b; u
end sub

sub FromFile()
    dim as boolean b
    open "t.txt" for input as #1
    input #1, b
    close #1
    print b
end sub
