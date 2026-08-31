'' A POINTER TO A DERIVED UDT MAY ONLY BE CAST ALONG ITS OWN CHAIN. fbc has three errors
'' for it -- 300 casting FROM an incompatible pointer, 302 casting TO one, 303 casting to
'' an unrelated UDT pointer -- and one rule underneath. Measured:
''
''     Child ptr -> integer ptr        error 302    Child extends Parent
''     Child ptr -> Unrelated ptr      error 303
''     integer ptr -> Child ptr        error 300
''     Child ptr -> Parent ptr         OK           and back again
''     GChild ptr -> Parent ptr        OK           two links up
''     Child ptr -> any ptr            OK           either side
''     Plain ptr -> integer ptr        OK           Plain extends nothing
''
'' -- so it turns on ONE SIDE BEING DERIVED, not on either being a UDT, and 'any ptr' is
'' the escape hatch it always is.
type Parent
    as integer i
end type

type Child extends Parent
end type

type GChild extends Child
end type

type Plain
    as integer i
end type

type Unrelated
    as integer i
end type

dim shared as Child ptr     c
dim shared as GChild ptr    g
dim shared as Parent ptr    p
dim shared as Plain ptr     pl
dim shared as integer ptr   ip
dim shared as any ptr       ap

'' -- refused ------------------------------------------------------------------
sub refused( )
    print cptr( integer ptr, c )
    print cptr( Unrelated ptr, c )
    print cptr( Child ptr, ip )
    print cptr( Plain ptr, g )
end sub

'' -- accepted -----------------------------------------------------------------
sub accepted( )
    print cptr( Parent ptr, c )
    print cptr( Child ptr, p )
    print cptr( Parent ptr, g )
    print cptr( any ptr, c )
    print cptr( Child ptr, ap )
    print cptr( integer ptr, pl )
end sub
