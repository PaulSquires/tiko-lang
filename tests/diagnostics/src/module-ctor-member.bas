'' A MEMBER AS A MODULE CONSTRUCTOR OR DESTRUCTOR -- fbc's error 17 on lines 16 and 18 (a
'' method, with a THIS), 205 on 20 and 206 on 22 (not public) (fbc-modern 1.20). tiko
'' accepted each. Lines 24 to 29, a public static member and a plain procedure, are fbc's.
type UDT
    i as integer
    declare sub m1( )
    declare sub m2( )
private:
    declare static sub p1( )
protected:
    declare static sub p2( )
public:
    declare static sub ok1( )
    declare static sub ok2( )
end type
sub UDT.m1( ) constructor
end sub
sub UDT.m2( ) destructor
end sub
sub UDT.p1( ) constructor
end sub
sub UDT.p2( ) destructor
end sub
sub UDT.ok1( ) constructor
end sub
sub UDT.ok2( ) destructor
end sub
private sub plain( ) constructor
end sub
print "end"
