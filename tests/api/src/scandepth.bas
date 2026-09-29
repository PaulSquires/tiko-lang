'' Forms that NAME a procedure, or declare one, and open no block (scan-macro-depth.test).
type T extends object
    declare const function Get_( ) as long
    declare static sub Make( )
    declare virtual function Size( ) as long
    cb as sub( byval x as long )
end type
type Fn as function( byval x as long ) as long
dim shared p as sub( )
declare function Maker( ) as function( ) as long
#define AFTER_FORMS 1
sub Real( )
    #define INSIDE_REAL 2
    print INSIDE_REAL
end sub
private function Priv( ) as long
    return AFTER_FORMS
end function
#define AFTER_REAL 3
