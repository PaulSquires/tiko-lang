'' 'declare ... lib "dwmapi.dll"' LINKS dwmapi ON THE MSVC TARGET. fbc passes
'' '-ldwmapi.dll' and MinGW ld finds libdwmapi.dll.a; lld-link was asked for
'' 'dwmapi.dll.lib', which does not exist -- the import library is dwmapi.lib. AfxNova's
'' AfxDwmApi.bi and its propsys bindings write the '.dll' 182 times between them, and
'' PsCalendar's link stopped on it. fbc-modern prints -1.
declare function DwmIsCompositionEnabled lib "dwmapi.dll" alias "DwmIsCompositionEnabled" _
    ( byval pfEnabled as long ptr ) as long
dim as long e
print DwmIsCompositionEnabled( @e ) = 0
