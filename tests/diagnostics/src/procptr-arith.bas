'' A PROCEDURE POINTER IS NOT AN ADDRESS TO DO ARITHMETIC ON, and it does not DEREFERENCE
'' either -- fbc calls both error 20, "Type mismatch". Measured:
''
''     p + 1              error 20        p as sub ptr
''     @sub1 - @sub2      error 20
''     p += 1             error 20
''     *p = 1             error 20
''     dim as integer i = *p             error 20
''
'' A pointer to DATA does all three; what makes a procedure pointer different is that
'' there is no element size to scale by and nothing at the far end to read.
''
'' A COMPARISON IS NOT ARITHMETIC. Testing a callback against null is how one is used.
declare sub s1( )
declare sub s2( )

sub s1( )
end sub

sub s2( )
end sub

dim shared as sub( ) p
dim shared as integer ptr ip
dim shared as integer n

'' -- refused ------------------------------------------------------------------
sub refused( )
    print cast( integer, p + 1 )
    print cast( integer, @s1 - @s2 )
end sub

'' -- accepted -----------------------------------------------------------------
sub accepted( )
    if p = 0 then n = 1
    if p <> 0 then n = 2
    p = @s1
    print cast( integer, ip + 1 )
    print *ip
end sub
