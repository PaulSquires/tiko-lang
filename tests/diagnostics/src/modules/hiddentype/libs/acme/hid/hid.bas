#module "hid"
type Secret
    v as long
end type
enum Shade
    LIGHT
end enum
public type Open_
    v as long
end type
public type Holder
    pub as Secret
    declare function Peek( ) as Secret ptr
private:
    hidden as Secret
end type
function Holder.Peek( ) as Secret ptr
    return @pub
end function
public function Make( ) as Secret
    return type( 7 )
end function
public sub Take( byval s as Secret ptr )
end sub
public function Fine( byval o as Open_ ) as long
    return o.v
end function
public dim shared current as Shade
public type Alias_ as Secret
function Internal( ) as Secret
    return type( 1 )
end function
public function Gen( of T )( byval x as T ) as T
    return x
end function
