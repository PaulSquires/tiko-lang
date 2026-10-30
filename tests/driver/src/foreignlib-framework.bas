'' A macOS framework spec beside a system library: the framework is for Mach-O links only, so
'' a Windows link takes winmm and nothing else, and the program runs.
#foreignlib TKOFW static "framework:Cocoa", "system:winmm"
declare function timeGetTime lib "winmm" alias "timeGetTime" ( ) as ulong
print iif( timeGetTime( ) <> 0, "ok", "ok" )
