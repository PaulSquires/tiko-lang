'' A runtime procedure's name in a unit that DECLARES A GENERIC -- Resolve walks such a unit
'' twice, and the first walk's report was taken as made (fbc-modern 1.20: error 4, line 6).
type Box( of T )
    v as T
end type
sub Run( )
end sub
