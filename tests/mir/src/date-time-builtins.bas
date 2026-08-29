'' DATE AND TIME. Both were in the runtime table with NO CALLER AT ALL, so every use of
'' either declined -- as an argument, in a DIM and in a PRINT alike -- while 'curdir',
'' 'command', 'exepath' and 'timer' beside them lowered. fbcunit's own run_tests writes
'' 'print_output( date() & " " & time() )', which is why the harness source itself was
'' one of the declining corpus files.
''
'' Measured: 'FBSTRING* fb_Date( void )' and 'FBSTRING* fb_Time( void )', both with no
'' parameter -- which is why they belong beside CURDIR and not beside COMMAND, whose
'' own parameter defaults to -1.
private sub p1( byref s as const string = "" )
    print "[" & s & "]"
end sub

p1( date( ) & " " & time( ) )
p1( date( ) )
p1( time( ) )

dim d as string = date( )
dim t as string = time( )
p1( d & " " & t )
print date( ) & " " & time( )

'' The bare spellings, which is how BASIC usually writes them.
dim d2 as string = date
dim t2 as string = time
print d2, t2
