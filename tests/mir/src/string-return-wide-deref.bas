'' 'RETURN *wideptr' OUT OF A STRING FUNCTION. DWSTRING's own OEM property ends 'RETURN *m_pBuffer',
'' and the statement was dropped: the string RETURN tried a narrow assignment only. 'function = *p'
'' and 'property = *p' already converted. Measured, fbc initialises the result from the wide
'' characters -- 'fb_WstrAssignToA_Init( &fb$result, -1ll, P, 0ll )' -- and prints '[wide]' three
'' times. So does tiko.
type Q
    as wstring ptr m_p
    declare property Narrow( ) as string
end type
property Q.Narrow( ) as string
    return *m_p
end property

function Free_( byval p as wstring ptr ) as string
    return *p
end function

function Early_( byval p as wstring ptr, byval n as long ) as string
    if n > 0 then return *p
    return "none"
end function

dim as wstring * 8 wz = "wide"
dim as Q qq
qq.m_p = @wz
print "[" & qq.Narrow & "]"
print "[" & Free_( @wz ) & "]"
print "[" & Early_( @wz, 1 ) & "]"
