'' OPEN's SIX DEVICE FORMS. All six were declining, and one of them was worse than that.
''
'' THE DEVICE WORD IS AN ORDINARY IDENTIFIER, and only the SYMBOL TABLE tells it from a
'' filename. Measured on fbc, both ways round:
''
''     open cons for output as #1            fb_FileOpenCons
''     dim as string cons = "t.txt"
''     open cons for output as #1            fb_FileOpen -- cons is the FILENAME
''
'' ...so the parser cannot decide it: it runs before Resolve and has no table. The
'' decision is made in LOWERING instead, which is the stage that can ask whether the
'' name bound to anything. A variable named 'pipe' also makes the operand form a syntax
'' error in fbc -- 'Expected AS, found "echo hi"' -- so the two readings never overlap.
''
'' ERR IS THE EXCEPTION AND IS RESERVED: 'dim as string err' is fbc error 4, so
'' 'open err' is always fb_FileOpenErr. That one was not a decline. tiko's prelude
'' declares 'err' as an alias for fb_ErrorGetNum, so the name BOUND, and
'' 'open err for output' lowered to fb_FileOpen taking THE ERROR NUMBER'S RETURN VALUE
'' AS THE FILENAME DESCRIPTOR. It verified. It did not decline. It was a miscompile
'' sitting inside a group everything else in was honestly counted.
''
'' ALL SIX TAKE THE ENCODING FORM'S SEVEN ARGUMENTS with a NULL encoding, and the three
'' with no operand pass an EMPTY string descriptor rather than a null pointer:
''
''     open cons for output as #1          fb_FileOpenCons( ""desc,        3u,0,0, 1,0, NULL )
''     open pipe "echo hi" for input as #4 fb_FileOpenPipe( "echo hi"desc, 2u,0,0, 4,0, NULL )
open cons for output as #1
open err for output as #2
open scrn for output as #3
open pipe "echo hi" for input as #4
open lpt "LPT1:" for output as #5
open com "COM1:9600" for binary as #6

'' ...and the same words as VARIABLES are filenames, which is the half that keeps the
'' rule honest. Without this the six above would pass with a lowering that simply
'' matched on the spelling.
scope
	dim as string cons = "zzt.txt"
	dim as string scrn = "zzu.txt"
	open cons for output as #7
	open scrn for output as #8
end scope
