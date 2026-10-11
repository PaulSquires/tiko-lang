'' build-lock's program: it holds the lock a 'tiko build' of build/.blk/app.exe takes -- an
'' exclusive open of '<artefact>.build.lock', as src/build/lock.bas makes one -- and runs
'' that build meanwhile. The build must refuse (TKO0166) and exit 1. The compiler is the
'' tree's bin/tiko.exe, run from the repository root, as the test runner runs it.
open "build/.blk/app.exe.build.lock" for binary lock read write as #1
dim as long rc = shell( "bin" & chr( 92 ) & "tiko.exe build -target win64-msvc " & _
    "tests/driver/src/build-b1/other.tiko -o build/.blk/app.exe" )
print "rc="; rc
close #1
