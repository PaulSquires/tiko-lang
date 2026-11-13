'' Asks Windows how DPI-aware this process is: 0 unaware, 1 system, 2 per monitor. With the
'' default manifest the answer is 2; a program's own manifest that says nothing about DPI gives 0.
declare function GetThreadDpiAwarenessContext lib "user32" alias "GetThreadDpiAwarenessContext" ( ) as any ptr
declare function GetAwarenessFromDpiAwarenessContext lib "user32" alias "GetAwarenessFromDpiAwarenessContext" ( byval ctx as any ptr ) as long
print "awareness"; GetAwarenessFromDpiAwarenessContext( GetThreadDpiAwarenessContext( ) )
