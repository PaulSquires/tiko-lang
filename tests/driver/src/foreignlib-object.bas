'' A module compiled with '-c' carries its '#foreignlib' libraries in '.fbctinf', as
'' fbc writes them: a file as '-l', ':name' and its absolute directory as '-p'; a
'' 'system:' name as a plain '-l'.
#foreignlib PROBE static "../../pp/src/vendor/probe"
#foreignlib WM dynamic "system:winmm"
declare function timeGetTime stdcall lib WM alias "timeGetTime" ( ) as ulong
function ticks( ) as ulong
    return timeGetTime( )
end function
