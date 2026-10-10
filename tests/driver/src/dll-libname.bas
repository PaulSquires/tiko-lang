'' 'lib "user32.dll"': the import library drops the suffix on every COFF target.
declare function GetDesktopWindow lib "user32.dll" alias "GetDesktopWindow" ( ) as any ptr
print GetDesktopWindow( ) <> 0
