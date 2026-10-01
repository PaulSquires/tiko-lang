'' udtcastu.bas -- WHETHER A UDT'S STRING CONVERSION IS A USTRING (T50).
''
'' Included from check.bas below intrinsics.bas, whose UdtStringCastType_ it asks, and
'' declared above overload.bas, whose ConcatHasUString_ calls it: a concatenation with
'' such a term is a USTRING argument -- measured, fbc's 'ucase( "q" & v )' over
'' 'operator cast( ) as ustring' is fb_UStrUcase -- where Check typed it STRING and the
'' UTF-16 result went out as narrow bytes, "Q(4," for "Q(4, 6)".

function UdtCastsToUStr_( byref c as Ctx, byval t as Tko.TypeId ) as boolean
    dim as Tko.TypeId st = UdtStringCastType_( c, t )
    if st = Tko.TYPE_NONE then return false
    return (c.types->BuiltinOf( st ) = Tko.TY_USTRING)
end function
