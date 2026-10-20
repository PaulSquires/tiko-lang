' PsApp finding F8: winuser.bi declares the per-monitor DPI messages (winuser.h values).
#include once "windows.bi"
print hex( WM_DPICHANGED ); " "; hex( WM_DPICHANGED_BEFOREPARENT ); " "; _
      hex( WM_DPICHANGED_AFTERPARENT ); " "; hex( WM_GETDPISCALEDSIZE )
