'' A string argument to a type constructor is evaluated once.
type Holder
    as ustring m_text
    declare constructor( )
    declare constructor( byref textValue as ustring )
end type
constructor Holder( )
end constructor
constructor Holder( byref textValue as ustring )
    this.m_text = textValue
end constructor
type HolderV
    as ustring m_text
    declare constructor( byval textValue as ustring )
end type
constructor HolderV( byval textValue as ustring )
    this.m_text = textValue
end constructor
function FromNarrow( ) as ustring
    return "row1"
end function
sub ByrefArg( )
    dim as Holder h = Holder( FromNarrow( ) )
end sub
sub ByvalArg( )
    dim as HolderV h = HolderV( FromNarrow( ) )
end sub
ByrefArg( )
ByvalArg( )
