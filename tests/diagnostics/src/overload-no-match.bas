'' NO MATCHING OVERLOADED FUNCTION -- fbc error 99. Reported only for a genuine OVERLOAD
'' SET, and only when every argument is a BUILTIN or a POINTER.
''
'' A SINGLE-CANDIDATE call that scores unviable is far more likely to be a conversion this
'' compiler does not model yet than a program fbc refuses, and blaming the user for the
'' compiler's gap is the one thing worse than the silent decline it replaces.
''
'' A UDT ARGUMENT BRINGS user conversions, overloaded operators and GENERIC INSTANTIATION
'' with it, none of which the scoring models completely -- fb/comptr.bi's
'' 'IidOf( byval tag as FB.IidTag( of iface ) )' is one, and reporting on it refused
'' eleven com/*.bas files fbc accepts. A POINTER to a UDT is fine: the pointee is not
'' converted.
declare sub f overload( byval as byte ptr )
declare sub f overload( byval as short ptr )

declare sub g overload( byval as long )
declare sub g overload( byval as double )

dim shared as integer ptr ip
dim shared as byte ptr bp
dim shared as long n

'' -- refused ------------------------------------------------------------------
sub refused( )
    f( ip )
end sub

'' -- accepted -----------------------------------------------------------------
sub accepted( )
    f( bp )
    g( n )
end sub
