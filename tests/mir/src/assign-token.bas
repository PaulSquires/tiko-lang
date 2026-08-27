'' '=>' IS AN EXACT SYNONYM FOR '=' wherever an assignment is written, and 'byval' is an
'' EXPRESSION PREFIX and not only an argument marker.
''
'' Measured: fbc takes 'i => 5' as 'i = 5', and the same in a FOR initialiser, a default
'' parameter value and the OPEN ... LEN clause. The COMPOUND arrows were already handled,
'' both the fused 'i +=> 5' and the word-spelled 'i and=> 1'; the plain one lexes as its
'' own token and matched nothing, so 'i => 5' was read as the expression 'i' followed by
'' a paren-less call. A compound spelled with a SPACE -- 'i + => 5' -- read the same way.
''
'' 'byval x' says the VALUE is wanted where an address would otherwise be taken, and the
'' one place that matters outside a call is a BYREF RESULT: 'function = byval pi' stores
'' the pointer's value rather than its address, measured as 'fb$result$1 = PI$1' with no
'' '&' anywhere. It was recognised only in the ARGUMENT parser, so everywhere else the
'' word lexed as a bare identifier and THE OPERAND WAS SILENTLY DROPPED -- the tree held
'' 'byval' with 'pi' nowhere in it.
dim shared as integer gi = 7

function refI( ) byref as integer
    dim as integer ptr pi = @gi
    function = byval pi
end function

function refJ( ) byref as integer
    dim as integer ptr pj = @gi
    return byval pj
end function

sub takesDefault( byval n as integer => 456 )
    print n
end sub

sub s1( )
    dim as integer i
    i => 5
    print i
    i + => 5
    print i
    i and=> 12
    print i

    dim as integer t = 0
    dim as integer j
    for j => 1 to 3
        t += j
    next j
    print t

    takesDefault( )
    print refI( ), refJ( )
end sub

s1( )
