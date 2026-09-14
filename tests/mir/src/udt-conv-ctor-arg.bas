'' A UDT ARGUMENT FOR A PARAMETER OF ANOTHER UDT TYPE RUNS THE PARAMETER TYPE'S CONVERTING
'' CONSTRUCTOR into a temporary -- byref and byval alike -- and a temporary with a destructor
'' dies with its statement's temporaries. fbc prints, and tiko's build of this now prints too:
''
''    take 107
''    takev 107
''    dd 1
''    dtor
''    after
''
'' tiko passed the BS object's own bytes where a DW belongs, and printed 100 twice.
type BS
    v as integer
end type
type DW
    n as integer
    declare constructor( )
    declare constructor( byref b as BS )
end type
constructor DW( )
    n = 0
end constructor
constructor DW( byref b as BS )
    n = 7 + b.v
end constructor
type DD
    n as integer
    declare constructor( byref b as BS )
    declare destructor( )
end type
constructor DD( byref b as BS )
    n = 1
end constructor
destructor DD( )
    print "dtor"
end destructor
sub TakeDW( byref d as DW )
    print "take"; d.n
end sub
sub TakeDWv( byval d as DW )
    print "takev"; d.n
end sub
sub TakeDD( byref d as DD )
    print "dd"; d.n
end sub
dim b as BS
b.v = 100
TakeDW( b )
TakeDWv( b )
TakeDD( b )
print "after"
