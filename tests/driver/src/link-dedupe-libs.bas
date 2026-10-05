'' Each library named again, in another spelling, and through a declare's 'lib'.
#inclib "shlwapi"
#inclib "comctl32"
#inclib "shlwapi"
#inclib "SHLWAPI"
declare function PathIsRelativeA lib "shlwapi" alias "PathIsRelativeA" ( byval p as const zstring ptr ) as long
declare sub InitCommonControls lib "comctl32.dll" alias "InitCommonControls" ( )
print "ok "; PathIsRelativeA( "a" ) <> 0
