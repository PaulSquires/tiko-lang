'' main.bas -- fbx entry point.
''
'' Deliberately trivial: collect the argument vector and hand it to the driver. Every
'' decision, including how to fail, belongs to Driver.Run so that the whole compiler is
'' reachable in-process from the test runner and from a fuzz harness.

#include once "driver/driver.bi"

using Fbx

dim as StrVec args

dim as long i = 1
while len( command( i ) ) > 0
    args.Push( command( i ) )
    i += 1
wend

end Driver.Run( args )
