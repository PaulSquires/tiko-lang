dim shared months( 0 to 2 ) as ustring = { "Jan", "Feb", "Mar" }
dim shared u as ustring = "Jan"
function F( byval m as long ) as ustring
    static names( 0 to 2 ) as ustring = { "Jan", "Feb", "Mar" }
    static w as ustring = "Feb"
    return names( m ) & w
end function
namespace n
    dim v as ustring = "Mar"
end namespace
dim lst( 0 to 1 ) as ustring = { "ok", "ok" }
print F( 1 ); months( 0 ); u; n.v; lst( 0 )
