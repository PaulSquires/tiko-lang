'' A module that asks for a library, compiled on its own with -c. objinfo-winhttp.o beside
'' it is this file built by fbc-modern: 'fbc64 -gen llvm -c objinfo-lib.bas -o
'' objinfo-winhttp.o', which names winhttp only in its '.fbctinf' section.
#inclib "winhttp"
declare function WinHttpCheckPlatform stdcall alias "WinHttpCheckPlatform" ( ) as long
function ObjInfoPlatform( ) as long
    return WinHttpCheckPlatform( )
end function
