'' main.bas -- tiko-lang entry point.
''
'' Deliberately trivial: collect the argument vector and hand it to the driver. Every
'' decision, including how to fail, belongs to Driver.Run so that the whole compiler is
'' reachable in-process from the test runner and from a fuzz harness.

#include once "driver/driver.bi"

using Tko

dim as StrVec args

dim as long i = 1
while len( command( i ) ) > 0
    args.Push( command( i ) )
    i += 1
wend

'' THE COMPILER RUNS ON A 64 MB STACK. Every stage recurses over the tree, and on the 2 MB
'' main stack 200 nested IFs, a 3,000-term '+' chain or 1,000 nested parentheses crashed
'' with 0xC0000005 and no diagnostic (F-46); fbc takes 25,000 terms. A thread is the one
'' portable way to choose the size -- Linux gives the main thread whatever ulimit says.
'' Should the thread not start, the compile runs here as it always did.
type RunJob_
    as StrVec ptr args
    as long rc
end type

private sub RunOnBigStack_( byval p as any ptr )
    dim as RunJob_ ptr j = p
    j->rc = Driver.Run( *j->args )
end sub

dim as RunJob_ job
job.args = @args
dim as any ptr th = threadcreate( @RunOnBigStack_, @job, 64 * 1024 * 1024 )
if th = 0 then end Driver.Run( args )
threadwait( th )
end job.rc
