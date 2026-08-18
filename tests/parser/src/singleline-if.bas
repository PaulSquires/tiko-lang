'' A single-line IF in every position it can hold, including the one that used to
'' destroy the enclosing block: the last statement before its terminator.
sub G( )
    dim as long b
    if b = 0 then print 1
end sub

sub H( )
    dim as long b
    while b
        if b = 0 then print 1
    wend
    if b = 1 then b = 2 : end if
    if b = 2 then print 1 else print 2
end sub

if 0 then print 1
