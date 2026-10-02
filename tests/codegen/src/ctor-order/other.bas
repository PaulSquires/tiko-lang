type Loud
    v as long
    declare constructor( )
    declare destructor( )
end type
constructor Loud( )
    print "other: global constructed"
end constructor
destructor Loud( )
    print "other: global destroyed"
end destructor
dim shared g as Loud
print "other: top-level code"
private sub Init( ) constructor
    print "other: constructor sub"
end sub
private sub Fini( ) destructor
    print "other: destructor sub"
end sub
