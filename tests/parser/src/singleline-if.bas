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

'' A single-line IF nested inside a BLOCK if. The 'end if' closes the outer one --
'' taking it for the inner one leaves the block open, which then eats the enclosing
'' 'end function'.
function K( byval a as long, byval b as long ) as long
    dim as long q = a \ b
    if ( a mod b ) <> 0 then
        dim as boolean negA = ( a < 0 )
        dim as boolean negB = ( b < 0 )
        if negA <> negB then q -= 1
    end if
    return q
end function

sub L( )
    print 1
end sub
