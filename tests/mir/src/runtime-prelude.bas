'' The runtime procedures fbc PREDECLARES in the global scope. They are in no header
'' and they are NOT reserved words -- measured: 'dim as long kill' is fbc error 4,
'' DUPLICATED DEFINITION, not a syntax error.
''
'' Every omitted argument's value was measured from what fbc emits, and not one of them
'' is guessable. They are the point of this test.
dim as long r
dim as string s

'' A BYREF STRING PARAMETER TAKES A DESCRIPTOR, and a literal has none: fbc builds one
'' with fb_StrAllocTempDescZEx and passes THAT. Passing the literal's bytes handed the
'' callee eight of them to read as a pointer.
kill "x.txt"
mkdir "d"

'' SLEEP with no argument is fb_Sleep( -1 ) -- and the two-argument form is a DIFFERENT
'' entry point, which is why only the one-argument shape is declared here.
sleep
sleep 100

'' CLS with no argument is fb_Cls( -65536 ), which is &hFFFF0000 read as signed.
cls

'' LOCATE takes FIVE parameters, not three. Row and column default to 0 because FB rows
'' are 1-based; the cursor defaults to -1, which is distinct from the legal 0 = hide.
locate
locate 5
locate 5, 10, 1

'' RANDOMIZE's seed is a DOUBLE and defaults to -1.0.
randomize
randomize 42

'' A BARE FUNCTION NAME IN VALUE POSITION IS A CALL. 'd = timer' is how FreeBASIC
'' spells a no-argument call, and taking the ADDRESS instead stored a function pointer
'' in a double -- which verifies, because a pointer is a well-typed value.
dim as double d = timer
s = curdir

'' COMMAND defaults to -1, and 0 is a legal distinct value: the program name.
s = command
s = command( 0 )

'' The graphics entry points that are ORDINARY CALLS. The statements with their own
'' coordinate syntax -- LINE, PSET, CIRCLE, PAINT, GET, PUT -- are not among them.
''
'' SCREENRES's pages default to 1 and its depth to 8. SCREENCOPY and FLIP are the SAME
'' runtime call. SETMOUSE's sentinels are inconsistent and that is measured: an omitted
'' y is &h80000000 while an omitted cursor or clip is -1.
screenres 640, 480, 32
dim as any ptr im
imagedestroy im
flip
screenlock
screenunlock
r = multikey( 1 )
windowtitle "hi"
