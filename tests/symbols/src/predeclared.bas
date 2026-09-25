'' The names FreeBASIC predeclares, and the ones the language declares implicitly.
type Widget
    as long size
    declare sub Resize( )
end type

sub Widget.Resize( )
    print this.size
end sub

sub RunIt( )    '' not 'Run': fbc predeclares that, and redefining it is its error 4
    for i as integer = 0 to 3
        print i
    next
    dim as boolean flag = true
    if flag = false then print __FUNCTION__
end sub
