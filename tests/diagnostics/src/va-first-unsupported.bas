' fbc's 286 for all three on a 64-bit target.
sub f cdecl (byval n as integer, ...)
    dim as any ptr ap = va_first()
    print va_arg(ap, integer)
    ap = va_next(ap, integer)
end sub
