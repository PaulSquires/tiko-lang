'' A CAST FOLLOWED BY A CONVERSION IS ONE FLAT SCORE. Measured on fbc-modern: N casting to
'' long and to double, 'j( n )' over j( integer ) and j( single ) is error 98 (line 14) --
'' 'long' into 'integer' is no better than 'double' into 'single'.
type N
    as long q
    declare operator cast( ) as long
    declare operator cast( ) as double
end type
operator N.cast( ) as long : return 3 : end operator
operator N.cast( ) as double : return 3.5 : end operator
sub j overload ( byval v as integer ) : end sub
sub j overload ( byval v as single ) : end sub
dim as N nv
j( nv )
