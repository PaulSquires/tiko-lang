'' AN 'extern "Windows" lib "name"' BLOCK LINKS ITS LIBRARY. The parser read the clause,
'' checked it was not empty, and dropped the name, so a declaration inside the block
'' reached the link with nothing asking for its import library. AfxNova's AfxGdiPlus.bi
'' names gdiplus this way and nowhere else, and PsCalendar stopped on nineteen undefined
'' Gdip* symbols. fbc-modern prints -1.
extern "Windows" lib "dwmapi.dll"
    declare function DwmIsCompositionEnabled( byval pfEnabled as long ptr ) as long
end extern
dim as long e
print DwmIsCompositionEnabled( @e ) = 0
