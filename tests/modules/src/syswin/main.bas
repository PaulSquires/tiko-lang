'' sys/windows (ADR 0017 §19): the facade over windows.bi, beside the header included directly.
'' The program defines no UNICODE, so its own names are the ANSI ones; the facade's are W.
#import "sys/windows" as win
#include once "windows.bi"

'' One RECT: the facade's is the header's.
dim as win.RECT r = ( 1, 2, 30, 40 )
dim as RECT classic = r
print classic.right & " " & sizeof( TCHAR ) & " " & sizeof( win.TCHAR ) & " " & (sizeof( win.LPTSTR ) = sizeof( any ptr ))

'' W whatever UNICODE says: a function, a struct, a function-like macro, and IDC_ARROW, whose
'' MAKEINTRESOURCE is the W one, not the program's.
dim as function( byval as HWND, byval as LPCWSTR, byval as LPCWSTR, byval as UINT ) as long mb = @win.MessageBox
dim as WNDCLASSEXW wc
dim as win.WNDCLASSEX ptr pwc = @wc
dim as LPCWSTR arrow = win.IDC_ARROW, atom_ = win.MAKEINTATOM( 5 )
print (mb = @MessageBoxW) & " " & cuint( arrow ) & " " & cuint( atom_ ) & " " & len( win.SE_DEBUG_NAME ) & " " & (win.SE_DEBUG_NAME = wstr( "SeDebugPrivilege" ))

'' A constant, an anonymous enum's member, FreeBASIC's own LOWORD, a renamed keyword.
print win.WM_PAINT & " " & win.SecurityImpersonation & " " & win.LOWORD( &h12345678 ) & " " & win.HIWORD( &h12345678 )
win.Sleep_( 0 )

'' Linked and called: CreateWindow is the header's macro, W.
dim as win.HWND h = win.CreateWindow( wstr( "STATIC" ), win.SE_DEBUG_NAME, 0, 0, 0, 10, 10, 0, 0, win.GetModuleHandle( 0 ), 0 )
print (h <> 0) & " " & win.GetWindowTextLength( h ) & " " & (win.DestroyWindow( h ) <> 0)
