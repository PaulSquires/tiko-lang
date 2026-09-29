'' 'typeof( x )' AS A USER PROCEDURE'S ARGUMENT OR IN PARENTHESES -- fbc's error 1 on lines
'' 16, 17 and 18, and 9 on 19 to 22 (fbc-modern 1.20). tiko let 'typeof' through every call
'' argument and every parenthesis, and dropped each statement in silence. Lines 23 to 25,
'' 'peek', 'poke' and 'sizeof' over a type, are fbc's and accepted. See TypeofArgCallee in
'' parser/intrinsics.bas.
sub F( byval s as string )
    print "F " & s
end sub
function G( byval n as long ) as long
    return n
end function
dim as long x = 3
dim as long ptr px = @x
dim as string s
dim as long y
F( typeof( x ) )
y = G( typeof( x ) )
F typeof( x )
s = (typeof( x ))
x = (typeof( x ))
F( (typeof( x )) )
print (typeof( x ))
print peek( typeof( x ), px )
poke typeof( x ), px, 5
print x, sizeof( typeof( x ) )
