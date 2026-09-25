'' '#foreignlib ... "system:winmm"' names a LIBRARY, which the linker looks up itself --
'' not a file called 'winmm'. timeGetTime is winmm's and nothing else links winmm.
#foreignlib WM dynamic "system:winmm"
declare function timeGetTime stdcall lib WM alias "timeGetTime" ( ) as ulong
print iif( timeGetTime( ) > 0, "ok", "zero" )
