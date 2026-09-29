'' A '#define' in a SUB dies with the SUB, whatever the SUB declares after it: 'dim cb as
'' sub( )' names a procedure type and opens no block (macro-scope-procptr.test).
sub a( )
    #define M 1
    dim cb as sub( )
    print M
end sub
sub b( )
    #define M 2
    print M
end sub
a( )
b( )
#ifdef M
print "M leaked"
#else
print "M scoped"
#endif
