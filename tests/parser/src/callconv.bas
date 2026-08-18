'' A calling convention and an ALIAS sit BETWEEN the name and the parameter list.
declare sub Plain( byval a as long )
sub Plain( byval a as long )
    print a
end sub

sub WithConv cdecl( byval cbe as long )
    print cbe
end sub

private sub WithAlias stdcall alias "wa"( byval n as long )
    print n
end sub
