'' A procedure with a required parameter named WITHOUT PARENTHESES -- fbc's error 1,
'' "Argument count mismatch", on lines 22 to 28 (fbc-modern 1.20). Lines 30 to 35 are
'' accepted: a defaulted parameter, a statement call that passes the argument, the
'' overload that needs none, and the name addressed rather than read.
function F( byval x as long ) as long
    return x * 2
end function
function G( byval x as long = 5 ) as long
    return x * 3
end function
sub S( byval x as long, byval y as long = 1 )
    print x; y
end sub
function H overload ( byval x as long ) as long
    return 1
end function
function H( ) as long
    return 2
end function
dim as long y

print F
y = F + 1
if F then print "t"
S
print eof
print lof
print loc

print G
S 5
print H
dim as function( byval as long ) as long pf = @F
print procptr( F ) <> 0
print pf( 4 )
