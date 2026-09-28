'' tikotest.bas -- the tiko-lang test runner.
''
''     bin/tiko-test [suite...] [--accept] [--filter <pat>] [--tiko-lang <path>]
''                   [-j N] [-v]
''
'' A test is a file under tests/ whose first lines carry directives in comments:
''
''     '' TEST: cli                 kind of test (see below)
''     '' ARGS: --dump-source %s    argument vector; %s is this file's path
''     '' EXPECT-EXIT: 0            required exit code
''     '' GOLDEN: expected/foo.out  golden output, relative to the test's directory
''     '' EXPECT-OUT: some text     required substring of the output (repeatable)
''     '' EXPECT-OUT[win64]: ...    required only when running for that target
''     '' EXPECT-NOT: other text    forbidden substring (repeatable)
''     '' EXPECT-FILE: path        the run must CREATE this file (repeatable)
''     '' EXPECT-NO-FILE: path     the run must NOT create it (repeatable)
''     '' EXPECT-FILE-HAS: p :: s  the file must exist and contain those bytes
''     '' EXPECT-FILE-NOT-HAS: p :: s   ...and must NOT contain them
''                              in both, \t \n \r and \\ in s are TAB, LF, CR, backslash
''     '' EXPECT-MAX-DIAG: 3        at most N ': error TKO' lines -- the recovery gate
''     '' RUN: path                 after a build for one of the HOST's targets, run the
''                              program the build made; it must exit 0. Skipped, not
''                              failed, for any other target. The file is deleted first
''     '' EXPECT-RUN-OUT: text      required substring of the program's output
''                              (repeatable), IN ORDER: each must appear after the
''                              previous one's match, so an initialisation order can be
''                              asserted and not only a set of lines
''
'' STEPS, for what one build cannot show -- a cache that must hit on the second build, and
'' miss after an edit. They run in the order written, BEFORE the ARGS build, which is the
'' last one and the one the EXPECT lines above judge:
''
''     '' CLEAN: dir               empty the directory: remove it and all in it, make it again
''     '' COPY: src => dst         copy a file, or a directory tree
''     '' WRITE: path :: text      write the file; \t \n \r \\ in text as in FILE-HAS
''     '' STEP: args               run tiko-lang with these, as ARGS is; it must exit 0
''     '' STEP-OUT: text           required substring of that STEP's output (repeatable)
''     '' STEP-NOT: text           forbidden substring of it (repeatable)
''
'' TARGETS. Every run names a target explicitly: what tiko-lang emits depends on
'' the TARGET, not on the host, and leaving it implicit made every golden say
'' whatever the machine that generated it happened to default to. 104 tests
'' failed on Linux for that reason alone. The default is win64.
''
'' A directory may widen it with a TARGETS file -- one line, space-separated:
''
''     tests/mir/TARGETS      win64 linux-x86_64
''
'' Every test in that directory then runs once per target. The GOLDEN is shared
'' unless a per-target one sits beside it: 'expected/foo.out' serves both, and
'' 'expected/foo.linux-x86_64.out' overrides it for that target when the two
'' genuinely differ. 310 of the 370 MIR tests emit identical IR for both, so a
'' file per target per test would have been 310 duplicates.
''
'' Kinds:
''     cli     run tiko-lang with ARGS and check exit code, golden and substrings
''     skip    parsed and reported as skipped -- a placeholder for a later phase
''
'' --accept rewrites GOLDEN files. It is the only sanctioned way to update them, and
'' the resulting diff is reviewed like code (docs/plan/13 section 3).
''
'' Output is deterministic: every result is REPORTED in sorted path order regardless
'' of anything -- including the order the runs finished in.
''
'' -j N RUNS N TESTS AT A TIME. The suite is 596 processes of about 75ms each and the
'' host has more than one core; serially that is 45 seconds of mostly-idle waiting.
'' The default is one worker per processor.
''
'' NOT EVERY TEST IS SAFE TO RUN BESIDE ANOTHER, and the ones that are not are the
'' whole reason this is a partition rather than a flag:
''
''   - ENV sets a PROCESS-GLOBAL variable and clears it again, so two tests doing that
''     at once see each other's.
''   - EXPECT-FILE deletes a path, runs, and asks whether it came back. Another test
''     writing that path in between answers the question wrongly, in either direction.
''   - Anything that EMITS rather than dumps writes files named after its source, and
''     a driver test's build leaves objects and an executable behind.
''   - RUN starts the program a test just built. Its output file is per-worker, but the
''     program is not: two tests building and running one path would race on it.
''
'' Those run serially after the rest, and --accept forces the whole suite serial: it
'' WRITES the goldens, and a golden shared by two tests would race.
''
'' The temp file the output is captured through is per-worker for the same reason --
'' one fixed name was a race that fails by handing a test ANOTHER test's output.

#include once "fb/array.bi"
#include once "fb/filesystem.bi"
#include once "fb/sort.bi"

using FB

const RUNNER_VERSION as string = "0.1.0"

type TestCase
    as string path            '' the test file
    as string dir_            '' its directory
    as string kind
    as string args
    as long   expectExit
    as boolean haveExpectExit
    as string golden          '' relative to dir_, or "" for none
    as FB.Array( of string ) targets   '' from <dir>TARGETS, else just win64
    as long   maxDiag
    as boolean haveMaxDiag
    as Array( of string ) expectOut
    as Array( of string ) expectNot
    as Array( of string ) env      '' NAME=value, set for this test's run only
    '' FILES THE RUN IS EXPECTED TO PRODUCE, or to leave alone. Paths are
    '' relative to the working directory, like ARGS.
    as Array( of string ) expectFile
    as Array( of string ) expectNoFile
    '' ...and BYTES a produced file must contain, as 'path :: text'. An archive's
    '' member names are in the file and in nothing tiko prints, so -lib's naming was
    '' verifiable only by running 'ar t' by hand.
    as Array( of string ) expectFileHas
    '' ...and bytes it must NOT contain. A record format is asserted by what is absent as
    '' much as by what is there: no raw TAB inside a field, no CR, no record twice.
    as Array( of string ) expectFileNotHas
    '' THE PROGRAM THE BUILD MADE, run afterwards on the host's own targets. Everything
    '' above asserts what the COMPILER did; nothing asserted what the program did, so
    '' "links and prints a then b" was checked by hand and recorded in commit messages.
    as string runExe
    as Array( of string ) expectRunOut
    '' THE STEPS, in order, each 'KIND' TAB 'rest': CLEAN, COPY, WRITE, STEP, STEP-OUT,
    '' STEP-NOT. See the header.
    as Array( of string ) steps
end type

type Options
    as Array( of string ) suites
    as string filter
    as string tikoPath
    as boolean accept
    as boolean verbose
    '' HOW MANY TESTS RUN AT ONCE. 0 means one per processor; 1 is serial, which is
    '' what --accept forces and what -j 1 asks for when a failure needs isolating.
    as long jobs
end type

'' ---------------------------------------------------------------- small helpers

function Trim_( byval s as string ) as string
    return trim( s, any !" \t\r\n" )
end function

'' \t \n \r and \\ in an EXPECT-FILE-(NOT-)HAS text, so a test can name a TAB or a
'' line ending -- the bytes a record format is made of -- in a directive that is itself
'' one line. Any other backslash is kept as it is: a Windows path needs no escaping.
function Unescape_( byval s as string ) as string
    dim as string outp = ""
    dim as long i = 0
    dim as long n = len( s )
    while i < n
        dim as boolean esc = (s[i] = 92) andalso (i + 1 < n)
        if esc then
            select case s[i + 1]
            case asc( "t" ) : outp += chr( 9 )
            case asc( "n" ) : outp += chr( 10 )
            case asc( "r" ) : outp += chr( 13 )
            case 92         : outp += chr( 92 )
            case else
                esc = false
            end select
        end if
        if esc then
            i += 2
        else
            outp += chr( s[i] )
            i += 1
        end if
    wend
    return outp
end function

function StartsWith( byval s as string, byval prefix as string ) as boolean
    if len( s ) < len( prefix ) then return false
    return (left( s, len( prefix ) ) = prefix)
end function

function ReadTextFile( byval path as string ) as string
    dim as FsResultUStr r = ReadAllText( path )
    if r.IsOk( ) = false then return ""
    return r.Value( )
end function

sub WriteTextFile( byval path as string, byval content as string )
    WriteAllText( path, content )
end sub

'' Normalise line endings so a golden written on one platform matches on the other.
''
'' WRITTEN IN PLACE, NOT APPENDED. 'outp += chr( s[i] )' a byte at a time cost 80 of the
'' 92 seconds escape-literal-dwstring-arg took, over its 1.1 MB of --dump-ir -- more than
'' half the whole suite.
function NormalizeEol( byval s as string ) as string
    if instr( s, chr( 13 ) ) = 0 then return s
    dim as long n = len( s )
    dim as string outp = space( n )
    dim as long w = 0
    for i as long = 0 to n - 1
        if s[i] <> 13 then outp[w] = s[i] : w += 1
    next
    return left( outp, w )
end function

'' Normalise a 'skip-site <file>:<line>' to 'skip-site <file>:LINE'.
''
'' Those lines name a source position INSIDE THE COMPILER, so every golden that
'' contains one breaks whenever the file above it grows by a line. That cost four
'' unrelated commits before anyone counted it. What the golden is actually asserting is
'' WHICH FILE gave up and HOW OFTEN -- the line number is a navigation aid in a sweep,
'' not a fact worth pinning.
''
'' ...AND ITS PATH SEPARATOR. The same line prints 'src\mir\lowerctl.bas' on
'' Windows and 'src/mir/lowerctl.bas' on Linux, which is where 43 of the 104
'' Linux failures came from -- nothing to do with the TARGET, only with the host
'' that ran the compiler. Narrowed to lines carrying 'skip-site ' so an escape
'' test's own backslashes are left alone.
''
'' Applied to both sides, so a golden written before this still matches.
''
'' WRITTEN IN PLACE, NOT APPENDED, as NormalizeEol is: it runs on both sides of every golden.
function NormalizeSkipSites( byval s as string ) as string
    if (instr( s, ".bas:" ) = 0) andalso (instr( s, "skip-site " ) = 0) then return s
    dim as long n = len( s )
    '' '.bas:' and one digit is 6 bytes and becomes 9, so the text grows by at most half.
    dim as string outp = space( n + n \ 2 + 16 )
    dim as long w = 0
    dim as long i = 0
    while i < n
        '' '.bas:' followed by digits is the only shape this touches.
        if (i + 4 < n) andalso (s[i] = 46) then            '' '.'
            if (s[i + 1] = 98) andalso (s[i + 2] = 97) andalso (s[i + 3] = 115) andalso (s[i + 4] = 58) then
                dim as long j = i + 5
                dim as long d = 0
                while (j < n) andalso (s[j] >= 48) andalso (s[j] <= 57)
                    j += 1
                    d += 1
                wend
                if d > 0 then
                    mid( outp, w + 1, 9 ) = ".bas:LINE"
                    w += 9
                    i = j
                    continue while
                end if
            end if
        end if
        outp[w] = s[i]
        w += 1
        i += 1
    wend
    outp = left( outp, w )

    '' The separator pass: each line holding 'skip-site ', in place.
    dim as long at = instr( outp, "skip-site " )
    while at > 0
        dim as long ls = instrrev( outp, chr( 10 ), at )     '' 0 when it is the first line
        dim as long le = instr( at, outp, chr( 10 ) )
        if le = 0 then le = len( outp ) + 1
        for k as long = ls to le - 2
            if outp[k] = 92 then outp[k] = asc( "/" )
        next
        if le > len( outp ) then exit while
        at = instr( le, outp, "skip-site " )
    wend
    return outp
end function

'' ------------------------------------------------------------------- discovery

sub CollectTests( byval root as string, byref found as Array( of string ) )
    '' The walk iterator yields a DirEntryResult, NOT a DirEntry. Binding it as
    '' 'for each e as DirEntry' compiles and then segfaults, so the element type is
    '' left inferred and unwrapped explicitly.
    for each entry in WalkDir( root )
        if entry.IsOk( ) = false then continue for
        dim as string sp = entry.Value( ).Path( )
        if lcase( right( sp, 5 ) ) = ".test" then found.Push( sp )
    next
end sub

'' ------------------------------------------------------------------- directives

function ParseTest( byval path as string, byref tc as TestCase ) as boolean
    dim as string text = ReadTextFile( path )
    if len( text ) = 0 then return false

    tc.path = path
    tc.kind = ""
    tc.args = ""
    tc.expectExit = 0
    tc.haveExpectExit = false
    tc.golden = ""
    tc.maxDiag = 0
    tc.haveMaxDiag = false
    tc.env.Clear( )
    tc.runExe = ""

    dim as long slash = 0
    for i as long = len( path ) to 1 step -1
        dim as ubyte c = path[i - 1]
        dim as boolean isSep = (c = asc( "/" )) orelse (c = asc( "\" ))
        if isSep then
            slash = i
            exit for
        end if
    next
    tc.dir_ = left( path, slash )

    dim as string acc = NormalizeEol( text )
    dim as long start = 1
    while start <= len( acc )
        dim as long nl = instr( start, acc, chr( 10 ) )
        dim as string ln
        if nl = 0 then
            ln = mid( acc, start )
            start = len( acc ) + 1
        else
            ln = mid( acc, start, nl - start )
            start = nl + 1
        end if

        ln = Trim_( ln )
        if StartsWith( ln, "''" ) = false then continue while
        ln = Trim_( mid( ln, 3 ) )

        if StartsWith( ln, "TEST:" ) then
            tc.kind = Trim_( mid( ln, 6 ) )
        elseif StartsWith( ln, "ARGS:" ) then
            tc.args = Trim_( mid( ln, 6 ) )
        elseif StartsWith( ln, "EXPECT-EXIT:" ) then
            tc.expectExit = valint( Trim_( mid( ln, 13 ) ) )
            tc.haveExpectExit = true
        elseif StartsWith( ln, "GOLDEN:" ) then
            tc.golden = Trim_( mid( ln, 8 ) )
        elseif StartsWith( ln, "EXPECT-OUT[" ) then
            '' A TARGET-QUALIFIED SUBSTRING. Some assertions are about a byte image
            '' whose width IS the target -- 'w size 16 = bytes 61 00 62 00 ...' is
            '' wstring * 8 on win64 and half the characters of it on linux-x86_64.
            '' Qualifying the line beats dropping the test to one target, which
            '' would have taken the wide-layout coverage off Linux exactly where it
            '' is most worth having. Stored as '<target>' & tab & '<text>'.
            dim as long rb = instr( ln, "]:" )
            if rb > 0 then
                tc.expectOut.Push( mid( ln, 12, rb - 12 ) & chr( 9 ) & _
                                   Trim_( mid( ln, rb + 2 ) ) )
            end if
        elseif StartsWith( ln, "EXPECT-OUT:" ) then
            tc.expectOut.Push( chr( 9 ) & Trim_( mid( ln, 12 ) ) )
        elseif StartsWith( ln, "EXPECT-MAX-DIAG:" ) then
            tc.maxDiag = valint( Trim_( mid( ln, 17 ) ) )
            tc.haveMaxDiag = true
        elseif StartsWith( ln, "EXPECT-NOT:" ) then
            tc.expectNot.Push( Trim_( mid( ln, 12 ) ) )
        elseif StartsWith( ln, "EXPECT-NO-FILE:" ) then
            tc.expectNoFile.Push( Trim_( mid( ln, 16 ) ) )
        elseif StartsWith( ln, "EXPECT-FILE-NOT-HAS:" ) then
            tc.expectFileNotHas.Push( Trim_( mid( ln, 21 ) ) )
        elseif StartsWith( ln, "EXPECT-FILE-HAS:" ) then
            tc.expectFileHas.Push( Trim_( mid( ln, 17 ) ) )
        elseif StartsWith( ln, "EXPECT-FILE:" ) then
            tc.expectFile.Push( Trim_( mid( ln, 13 ) ) )
        elseif StartsWith( ln, "ENV:" ) then
            tc.env.Push( Trim_( mid( ln, 5 ) ) )
        elseif StartsWith( ln, "RUN:" ) then
            tc.runExe = Trim_( mid( ln, 5 ) )
        elseif StartsWith( ln, "EXPECT-RUN-OUT:" ) then
            tc.expectRunOut.Push( Trim_( mid( ln, 16 ) ) )
        elseif StartsWith( ln, "CLEAN:" ) then
            tc.steps.Push( "CLEAN" & chr( 9 ) & Trim_( mid( ln, 7 ) ) )
        elseif StartsWith( ln, "COPY:" ) then
            tc.steps.Push( "COPY" & chr( 9 ) & Trim_( mid( ln, 6 ) ) )
        elseif StartsWith( ln, "WRITE:" ) then
            tc.steps.Push( "WRITE" & chr( 9 ) & Trim_( mid( ln, 7 ) ) )
        elseif StartsWith( ln, "STEP-OUT:" ) then
            tc.steps.Push( "STEP-OUT" & chr( 9 ) & Trim_( mid( ln, 10 ) ) )
        elseif StartsWith( ln, "STEP-NOT:" ) then
            tc.steps.Push( "STEP-NOT" & chr( 9 ) & Trim_( mid( ln, 10 ) ) )
        elseif StartsWith( ln, "STEP:" ) then
            tc.steps.Push( "STEP" & chr( 9 ) & Trim_( mid( ln, 6 ) ) )
        end if
    wend

    '' THE DIRECTORY'S TARGETS, not the test's. Naming them per test would have
    '' meant the same line in all 370 files under tests/mir, and a new test there
    '' would silently get only one of them by forgetting it.
    dim as string tf = ReadTextFile( tc.dir_ & "TARGETS" )
    tf = Trim_( NormalizeEol( tf ) )
    dim as long tnl = instr( tf, chr( 10 ) )
    if tnl > 0 then tf = Trim_( left( tf, tnl - 1 ) )
    if len( tf ) > 0 then
        dim as long tp = 1
        while tp <= len( tf )
            dim as long sp = instr( tp, tf, " " )
            dim as string one_
            if sp = 0 then
                one_ = Trim_( mid( tf, tp ) ) : tp = len( tf ) + 1
            else
                one_ = Trim_( mid( tf, tp, sp - tp ) ) : tp = sp + 1
            end if
            if len( one_ ) > 0 then tc.targets.Push( one_ )
        wend
    end if
    if tc.targets.Count = 0 then tc.targets.Push( "win64" )

    return (len( tc.kind ) > 0)
end function

'' --------------------------------------------------------------------- running

'' Runs tiko-lang and captures stdout+stderr together. This uses a shell redirection,
'' which the COMPILER itself is forbidden to do (docs/plan/14 section 7) -- the
'' prohibition is about untrusted input reaching a command line, and here every
'' component comes from a checked-in test file.
'' cmd.exe strips the outer quotes when a quoted command is combined with
'' redirection, so paths are converted to the native separator and quoted only when
'' they actually contain a space.
function NativePath( byval p as string ) as string
    dim as string r = p
    #ifdef __FB_WIN32__
        for i as long = 0 to len( r ) - 1
            if r[i] = asc( "/" ) then r[i] = asc( "\\" )
        next
    #endif
    if instr( r, " " ) > 0 then return """" & r & """"
    return r
end function

function RunTko _
    ( byval tikoPath as string, byval args as string, byref outText as string, _
      byval slotId as long ) as long

    '' ONE TEMP FILE PER WORKER. A single fixed name is a race the moment two tests
    '' run at once, and it fails by handing one test ANOTHER'S OUTPUT -- a golden
    '' mismatch naming a test that is not the one that broke.
    dim as string tmp = "build/.tikotest." & slotId & ".out"
    '' --color=never goes FIRST: appended last, a trailing value-taking option in
    '' the test's own ARGS would swallow it as its value.
    dim as string cmd = NativePath( tikoPath ) & " --color=never " & args & _
                        " > " & NativePath( tmp ) & " 2>&1"
    dim as long rc = shell( cmd )
    outText = NormalizeEol( ReadTextFile( tmp ) )
    Kill( tmp )
    return rc
end function

type Failure
    as string test
    as string why
end type

'' DOES THIS FILE EXIST. An open-for-input probe rather than a length test: a
'' zero-byte golden is a legitimate expectation and must not read as absent.
function FileExists_( byval p as string ) as boolean
    dim as long f = freefile
    if open( p for input as #f ) <> 0 then return false
    close #f
    return true
end function

'' THE GOLDEN FOR ONE TARGET: 'expected/foo.out' with '.<target>' inserted before
'' the extension. Returns "" when there is no such file, which means the base golden
'' serves this target too -- the common case, and what keeps 310 of the MIR tests to
'' one file apiece.
function TargetGolden_ _
    ( byval dir_ as string, byval golden as string, byval tgt as string ) as string
    dim as long dot = 0
    for i as long = len( golden ) - 1 to 0 step -1
        if golden[i] = asc( "." ) then dot = i + 1 : exit for
        if golden[i] = asc( "/" ) then exit for
    next
    dim as string cand
    if dot = 0 then
        cand = golden & "." & tgt
    else
        cand = left( golden, dot - 1 ) & "." & tgt & mid( golden, dot )
    end if
    if FileExists_( dir_ & cand ) then return cand
    return ""
end function

'' CAN THIS HOST RUN WHAT A BUILD FOR tgt PRODUCES? Both Windows targets' programs run on
'' Windows (win64 links MinGW's CRT, win64-msvc the UCRT; both are PE executables), and
'' linux-x86_64's on Linux. Anything else would need an emulator, and is skipped.
function IsHostTarget_( byval tgt as string ) as boolean
    #ifdef __FB_WIN32__
        return (tgt = "win64") orelse (tgt = "win64-msvc")
    #else
        return (tgt = "linux-x86_64")
    #endif
end function

'' THE TARGET A RUN ACTUALLY BUILT FOR: the LAST '-target' on its command line, since a
'' later one wins (tests/driver's tests name win64-msvc in ARGS over the runner's win64).
'' Deciding whether to RUN from the runner's own target would start a linux-x86_64
'' program on Windows the day a test named that target in ARGS.
function BuiltTarget_( byval tgt as string, byval args as string ) as string
    dim as string t = tgt
    dim as long at = instr( args, "-target " )
    while at > 0
        dim as long st = at + 8
        while (st <= len( args )) andalso (mid( args, st, 1 ) = " ")
            st += 1
        wend
        dim as long en = instr( st, args, " " )
        if en = 0 then en = len( args ) + 1
        t = mid( args, st, en - st )
        at = instr( en, args, "-target " )
    wend
    return t
end function

'' RUN THE PROGRAM A TEST BUILT, and check what it did: exit 0, and every EXPECT-RUN-OUT
'' in order. Captured through a per-worker file like RunTko's, for the same reason.
function CheckRun_ _
    ( byref tc as TestCase, byref why as string, byval slotId as long ) as boolean

    if FileExists_( tc.runExe ) = false then
        why = "RUN: no program at " & tc.runExe
        return false
    end if
    dim as string tmp = "build/.tikotest." & slotId & ".run"
    dim as long rc = shell( NativePath( tc.runExe ) & " > " & NativePath( tmp ) & " 2>&1" )
    dim as string outp = NormalizeEol( ReadTextFile( tmp ) )
    Kill( tmp )
    if rc <> 0 then
        why = "RUN: " & tc.runExe & " exited " & rc & ", expected 0"
        return false
    end if
    dim as long from_ = 1
    for each want as string in tc.expectRunOut
        dim as long at = instr( from_, outp, want )
        if at = 0 then
            why = "RUN: output does not contain, after the previous match: " & want
            return false
        end if
        from_ = at + len( want )
    next
    return true
end function

declare function CheckOne_ _
    ( byref tc as TestCase, byref opts as Options, byval tgt as string, _
      byval rc as long, byref outText as string, byref why as string ) as boolean

'' THE STEPS, in order (see the header). False, with why, at the first that fails.
function RunSteps_ _
    ( byref tc as TestCase, byref opts as Options, byval tgt as string, _
      byref why as string, byval slotId as long ) as boolean

    dim as string outText = ""
    dim as long n = 0
    for each st as string in tc.steps
        dim as long tb = instr( st, chr( 9 ) )
        dim as string kind = left( st, tb - 1 )
        dim as string rest = mid( st, tb + 1 )
        select case kind
        case "CLEAN"
            '' EMPTY, not absent: tiko writes into an -o directory, it does not make one.
            if FB.IsDir( rest ) then FB.RemoveDirAll( rest )
            if FB.IsDir( rest ) then
                why = "CLEAN: could not remove " & rest
                return false
            end if
            FB.CreateDirAll( rest )
        case "COPY"
            dim as long ar = instr( rest, "=>" )
            if ar = 0 then
                why = "COPY: no '=>' in " & rest
                return false
            end if
            dim as string src = Trim_( left( rest, ar - 1 ) )
            dim as string dst = Trim_( mid( rest, ar + 2 ) )
            if FB.IsDir( src ) then
                FB.CreateDirAll( dst )
                FB.CopyDir( src, dst )
            else
                FB.CopyFile( src, dst, true )
            end if
            if FileExists_( dst ) = false andalso FB.IsDir( dst ) = false then
                why = "COPY: nothing at " & dst
                return false
            end if
        case "WRITE"
            dim as long sp = instr( rest, "::" )
            if sp = 0 then
                why = "WRITE: no '::' in " & rest
                return false
            end if
            WriteTextFile( Trim_( left( rest, sp - 1 ) ), Unescape_( Trim_( mid( rest, sp + 2 ) ) ) )
        case "STEP"
            n += 1
            dim as long rc = RunTko( opts.tikoPath, "-target " & tgt & " " & rest, outText, slotId )
            if rc <> 0 then
                why = "STEP " & n & " exited " & rc & ", expected 0:" & chr( 10 ) & outText
                return false
            end if
        case "STEP-OUT"
            if instr( outText, rest ) = 0 then
                why = "STEP " & n & " output does not contain: " & rest & chr( 10 ) & outText
                return false
            end if
        case "STEP-NOT"
            if instr( outText, rest ) > 0 then
                why = "STEP " & n & " output contains: " & rest & chr( 10 ) & outText
                return false
            end if
        end select
    next
    return true
end function

'' SET AN ENVIRONMENT VARIABLE FROM A STRING THAT OUTLIVES THE PROCESS. fbc's setenviron
'' is putenv on Linux, and putenv KEEPS THE POINTER: handed a loop copy or a 'left( e, eq )'
'' temporary, the environment entry pointed at freed memory, and a test's ENV was not in
'' force for its first target -- tests/cimport's two no-libclang tests found a libclang
'' there and exited 0. On Windows _putenv copies, which is why only Linux saw it. Kept
'' strings are a few bytes per ENV line; they are never freed.
private sub SetEnv_( byref kv as string )
    static as string keep( any )
    dim as long n = ubound( keep ) + 1
    redim preserve keep( n )
    keep( n ) = kv
    setenviron keep( n )
end sub

'' PUT BACK WHAT A TEST'S ENV REPLACED -- 'NAME=value' each, as captured before it was set.
'' Clearing it instead lost a value the whole run depends on: TKO_MODCACHE, set below for
'' every test, was gone after the first test that named its own.
private sub RestoreEnv_( byref prev as Array( of string ) )
    for each p as string in prev
        SetEnv_( p )
    next
end sub

function RunOne _
    ( byref tc as TestCase, byref opts as Options, byref why as string, _
      byval slotId as long ) as boolean

    why = ""

    if tc.kind = "skip" then return true

    if tc.kind <> "cli" then
        why = "unknown TEST kind '" & tc.kind & "'"
        return false
    end if

    dim as string args = tc.args
    dim as long at = instr( args, "%s" )
    while at > 0
        args = left( args, at - 1 ) & tc.path & mid( args, at + 2 )
        at = instr( args, "%s" )
    wend

    '' The variable is set for this run and put back straight after, so a test that
    '' needs an environment cannot leak it into the next one. Order matters: tiko-lang reads
    '' it at startup, so it must be in place before the shell( ) and restored before the
    '' following test builds its own command.
    dim as Array( of string ) prevEnv
    for each e_ as string in tc.env
        dim as long eq0 = instr( e_, "=" )
        if eq0 > 0 then prevEnv.Push( left( e_, eq0 ) & environ( left( e_, eq0 - 1 ) ) )
        SetEnv_( e_ )
    next

    dim as string outText = ""
    dim as long rc = 0
    for ti as long = 0 to tc.targets.Count - 1
        dim as string tgt = tc.targets[ti]
        '' EVERY NAMED FILE IS REMOVED FIRST. Without this a test asserting that
        '' a build produced something would pass on the artefact left by the
        '' PREVIOUS run -- including a run of an older compiler that could still
        '' do it. An assertion about output that survives the thing being tested
        '' is worse than no assertion.
        for each f_ as string in tc.expectFile
            kill( f_ )
        next
        for each f2 as string in tc.expectNoFile
            kill( f2 )
        next
        '' ...AND THE FILES WHOSE CONTENT IS ASSERTED, for the same reason: an archive
        '' left by a previous run already contains the member names this is about to
        '' look for, so without this the check would pass without the compiler having
        '' produced anything at all.
        for each f3 as string in tc.expectFileHas
            dim as long s3 = instr( f3, "::" )
            if s3 > 0 then kill( Trim_( left( f3, s3 - 1 ) ) )
        next
        for each f4 as string in tc.expectFileNotHas
            dim as long s4 = instr( f4, "::" )
            if s4 > 0 then kill( Trim_( left( f4, s4 - 1 ) ) )
        next
        '' ...AND THE PROGRAM A RUN WILL START: a stale one from an older compiler would
        '' otherwise be run, and pass, whatever this build did.
        if len( tc.runExe ) > 0 then kill( tc.runExe )
        dim as boolean ok_ = RunSteps_( tc, opts, tgt, why, slotId )
        '' NAMED, ALWAYS. See the TARGETS note at the top of this file.
        if ok_ then
            rc = RunTko( opts.tikoPath, "-target " & tgt & " " & args, outText, slotId )
            ok_ = CheckOne_( tc, opts, tgt, rc, outText, why )
        end if
        '' HOISTED, each term a boolean of its own: warning 38 otherwise.
        dim as boolean wantRun = (len( tc.runExe ) > 0)
        dim as boolean onHost = IsHostTarget_( BuiltTarget_( tgt, args ) )
        if ok_ andalso wantRun andalso onHost then
            ok_ = CheckRun_( tc, why, slotId )
        end if
        if ok_ = false then
            if tc.targets.Count > 1 then why = "[" & tgt & "] " & why
            RestoreEnv_( prevEnv )
            return false
        end if
    next

    RestoreEnv_( prevEnv )

    return true
end function

'' EVERY CHECK FOR ONE TARGET'S RUN. Split out of RunOne so the same rules apply
'' to each target rather than to whichever one happened to run last.
function CheckOne_ _
    ( byref tc as TestCase, byref opts as Options, byval tgt as string, _
      byval rc as long, byref outText as string, byref why as string ) as boolean

    if tc.haveExpectExit andalso (rc <> tc.expectExit) then
        why = "exit code " & rc & ", expected " & tc.expectExit
        return false
    end if

    for each want as string in tc.expectOut
        dim as long tab_ = instr( want, chr( 9 ) )
        dim as string forTgt = left( want, tab_ - 1 )
        dim as string text_ = mid( want, tab_ + 1 )
        if (len( forTgt ) > 0) andalso (forTgt <> tgt) then continue for
        if instr( outText, text_ ) = 0 then
            why = "output does not contain: " & text_
            return false
        end if
    next

    for each bad as string in tc.expectNot
        if instr( outText, bad ) > 0 then
            why = "output unexpectedly contains: " & bad
            return false
        end if
    next

    '' WHAT THE RUN PUT ON DISK. The only assertion available for a build whose
    '' result is a FILE rather than text: -dll writes a .dll and an import
    '' library, -lib writes an archive, and a default build names its own output.
    '' None of that is visible in tiko's stdout, so it went unasserted -- three
    '' features verified by hand and recorded only in commit messages.
    for each want_ as string in tc.expectFile
        if FileExists_( want_ ) = false then
            why = "did not create: " & want_
            return false
        end if
    next

    for each none_ as string in tc.expectNoFile
        if FileExists_( none_ ) then
            why = "unexpectedly created: " & none_
            return false
        end if
    next

    '' 'path :: text' -- the file must exist and contain those bytes. Read whole and
    '' searched as bytes, not as lines: an archive is binary, and its member names sit
    '' in fixed-width headers with no newline anywhere near them.
    for each has_ as string in tc.expectFileHas
        dim as long sep = instr( has_, "::" )
        if sep = 0 then
            why = "malformed EXPECT-FILE-HAS (want 'path :: text'): " & has_
            return false
        end if
        dim as string hpath = Trim_( left( has_, sep - 1 ) )
        '' Unescaped AFTER the trim, so an escaped TAB at either end survives it.
        dim as string hwant = Unescape_( Trim_( mid( has_, sep + 2 ) ) )
        if FileExists_( hpath ) = false then
            why = "did not create: " & hpath
            return false
        end if
        dim as long hf = freefile
        if open( hpath for binary access read as #hf ) <> 0 then
            why = "cannot read: " & hpath
            return false
        end if
        dim as string blob = space( lof( hf ) )
        if len( blob ) > 0 then get #hf, 1, blob
        close #hf
        if instr( blob, hwant ) = 0 then
            why = hpath & " does not contain: " & hwant
            return false
        end if
    next

    '' 'path :: text' -- the file must exist and must NOT contain those bytes. It has
    '' to exist: a mistyped path would otherwise pass by containing nothing.
    for each not_ as string in tc.expectFileNotHas
        dim as long nsep = instr( not_, "::" )
        if nsep = 0 then
            why = "malformed EXPECT-FILE-NOT-HAS (want 'path :: text'): " & not_
            return false
        end if
        dim as string npath = Trim_( left( not_, nsep - 1 ) )
        dim as string nwant = Unescape_( Trim_( mid( not_, nsep + 2 ) ) )
        if FileExists_( npath ) = false then
            why = "did not create: " & npath
            return false
        end if
        dim as long nf = freefile
        if open( npath for binary access read as #nf ) <> 0 then
            why = "cannot read: " & npath
            return false
        end if
        dim as string nblob = space( lof( nf ) )
        if len( nblob ) > 0 then get #nf, 1, nblob
        close #nf
        if instr( nblob, nwant ) > 0 then
            why = npath & " contains: " & nwant
            return false
        end if
    next

    if tc.haveMaxDiag then
        '' The plan's recovery criterion: a broken file yields a few useful messages,
        '' not a cascade (docs/plan/04 section 8).
        dim as long count = 0
        dim as long at = instr( outText, ": error TKO" )
        while at > 0
            count += 1
            at = instr( at + 1, outText, ": error TKO" )
        wend
        if count > tc.maxDiag then
            why = "produced " & count & " diagnostics, at most " & tc.maxDiag & " allowed"
            return false
        end if
    end if

    if len( tc.golden ) > 0 then
        '' A PER-TARGET GOLDEN IF ONE EXISTS, the shared one otherwise. On --accept
        '' the per-target file is written only when it is already there: creating one
        '' for every target would turn 310 shared goldens into 620.
        dim as string rel = tc.golden
        dim as string tg = TargetGolden_( tc.dir_, tc.golden, tgt )
        if len( tg ) > 0 then rel = tg
        dim as string gpath = tc.dir_ & rel
        if opts.accept then
            WriteTextFile( gpath, outText )
        else
            dim as string want = NormalizeEol( ReadTextFile( gpath ) )
            if NormalizeSkipSites( want ) <> NormalizeSkipSites( outText ) then
                why = "golden mismatch against " & gpath
                return false
            end if
        end if
    end if

    return true
end function

'' ------------------------------------------------------------- running in parallel

'' ONE TEST AND WHAT BECAME OF IT. The result is stored rather than printed, because
'' a worker finishes whenever it finishes and the report is owed in path order.
type Job
    as string path
    as TestCase ptr tc
    as long state          '' 0 pending, 1 passed, 2 failed
    as string why
end type

'' IS THIS TEST SAFE TO RUN BESIDE ANOTHER? See the note at the top of this file for
'' why each of these disqualifies a test. The last is deliberately a WHITELIST of
'' read-only modes rather than a blacklist of emitting ones: a mode added later is
'' then serial until someone says otherwise, which is the safe direction to be wrong.
function IsParallelSafe_( byref tc as TestCase ) as boolean
    if tc.env.IsEmpty( ) = false then return false
    if tc.expectFileNotHas.IsEmpty( ) = false then return false
    if tc.expectFileHas.IsEmpty( ) = false then return false
    if tc.expectFile.IsEmpty( ) = false then return false
    if tc.expectNoFile.IsEmpty( ) = false then return false
    if len( tc.runExe ) > 0 then return false
    if tc.steps.IsEmpty( ) = false then return false
    if instr( tc.args, "--dump" ) > 0 then return true
    if instr( tc.args, "--parse-only" ) > 0 then return true
    if instr( tc.args, "--pp-only" ) > 0 then return true
    return false
end function

type Pool
    as any ptr mtx
    as long nextIdx
    as long nJobs
    as Array( of Job ) ptr jobs
    as Options ptr opts
end type

type WorkerArg
    as Pool ptr pool
    as long slotId
end type

'' A WORKER TAKES THE NEXT INDEX AND RUNS IT. Work-stealing off one counter rather
'' than a fixed slice each: the tests are not equal in cost -- a driver test is worth
'' hundreds of lexer tests -- so a static split ends with one worker still going and
'' the rest idle.
sub Worker_ cdecl( byval ud as any ptr )
    dim as WorkerArg ptr w = ud
    dim as Pool ptr pl = w->pool
    do
        MutexLock( pl->mtx )
        dim as long idx = pl->nextIdx
        pl->nextIdx += 1
        MutexUnlock( pl->mtx )
        if idx >= pl->nJobs then exit do
        dim as string why = ""
        if RunOne( *(*pl->jobs)[idx].tc, *pl->opts, why, w->slotId ) then
            (*pl->jobs)[idx].state = 1
        else
            (*pl->jobs)[idx].state = 2
            (*pl->jobs)[idx].why = why
        end if
    loop
end sub

'' RUN THESE JOBS, n AT A TIME. One worker is not a degenerate pool but the plain
'' loop: no thread is created, so a serial run stays exactly what it was and neither
'' --accept nor a single-test filter depends on the threading working.
sub RunPool_ _
    ( byref jobs as Array( of Job ), byref opts as Options, byval nWorkers as long )

    if jobs.IsEmpty( ) then return

    if nWorkers <= 1 then
        for i as long = 0 to jobs.Count - 1
            dim as string why = ""
            if RunOne( *jobs[i].tc, opts, why, 0 ) then
                jobs[i].state = 1
            else
                jobs[i].state = 2
                jobs[i].why = why
            end if
        next
        return
    end if

    if nWorkers > jobs.Count then nWorkers = jobs.Count

    dim as Pool pl
    pl.mtx = MutexCreate( )
    pl.nextIdx = 0
    pl.nJobs = jobs.Count
    pl.jobs = @jobs
    pl.opts = @opts

    dim as WorkerArg wargs( 0 to nWorkers - 1 )
    dim as any ptr handles( 0 to nWorkers - 1 )
    for i as long = 0 to nWorkers - 1
        wargs( i ).pool = @pl
        wargs( i ).slotId = i
        handles( i ) = ThreadCreate( @Worker_, @wargs( i ) )
    next
    for i as long = 0 to nWorkers - 1
        if handles( i ) <> 0 then ThreadWait( handles( i ) )
    next

    MutexDestroy( pl.mtx )
end sub

'' HOW MANY WORKERS, when -j did not say. NUMBER_OF_PROCESSORS is set on Windows and
'' is not on Linux, where 4 is a floor that helps and cannot oversubscribe badly.
function DefaultJobs_( ) as long
    dim as string n = environ( "NUMBER_OF_PROCESSORS" )
    if len( n ) > 0 then
        dim as long v = valint( n )
        if v >= 1 then return v
    end if
    return 4
end function

'' ------------------------------------------------------------------------ main

dim as Options opts
opts.tikoPath = "bin/tiko.exe"
#ifndef __FB_WIN32__
    opts.tikoPath = "bin/tiko"
#endif
opts.accept = false
opts.verbose = false
opts.filter = ""
opts.jobs = 0

dim as long argi = 1
while len( command( argi ) ) > 0
    dim as string a = command( argi )
    select case a
    case "--accept" : opts.accept = true
    case "-v"       : opts.verbose = true
    case "--filter" : argi += 1 : opts.filter = command( argi )
    case "--tiko-lang"    : argi += 1 : opts.tikoPath = command( argi )
    case "-j"       : argi += 1 : opts.jobs = valint( command( argi ) )
    case else
        if StartsWith( a, "-" ) then
            print "tiko-test: unknown option '" & a & "'"
            end 2
        end if
        opts.suites.Push( a )
    end select
    argi += 1
wend

if opts.suites.IsEmpty( ) then opts.suites.Push( "tests" )

'' THE MODULE CACHE THE SUITE BUILDS INTO, unless the caller named one. tiko's own default
'' is the user's cache directory, one pool for every project, which a gate must not fill.
if len( environ( "TKO_MODCACHE" ) ) = 0 then SetEnv_( "TKO_MODCACHE=build/.modcache" )

dim as long nWorkers = opts.jobs
if nWorkers <= 0 then nWorkers = DefaultJobs_( )
'' --accept WRITES the goldens. See the note at the top of this file.
if opts.accept then nWorkers = 1

dim as Array( of string ) files
for each suite as string in opts.suites
    CollectTests( suite, files )
next
Sort( files )

'' EVERY TEST IS PARSED FIRST, and the ones that cannot be are counted here rather
'' than inside a worker: a parse failure is a property of the file, not of the run.
dim as long skipped = 0
dim as Array( of Job ) parJobs
dim as Array( of Job ) serJobs

for each path as string in files
    if len( opts.filter ) > 0 then
        if instr( path, opts.filter ) = 0 then continue for
    end if

    dim as TestCase ptr tc = new TestCase
    if ParseTest( path, *tc ) = false then
        skipped += 1
        delete tc
        continue for
    end if
    if tc->kind = "skip" then
        skipped += 1
        if opts.verbose then print "SKIP " & path
        delete tc
        continue for
    end if

    dim as Job j
    j.path = path
    j.tc = tc
    j.state = 0
    if (nWorkers > 1) andalso IsParallelSafe_( *tc ) then
        parJobs.Push( j )
    else
        serJobs.Push( j )
    end if
next

RunPool_( parJobs, opts, nWorkers )
'' THE UNSAFE ONES, ALONE. Not merely single-threaded: nothing else may be running.
RunPool_( serJobs, opts, 1 )

'' ------------------------------------------------------- the report, in path order
''
'' The two partitions are each already in path order, so this is a MERGE of two sorted
'' lists rather than a search: the alternative -- looking each path up in both -- is
'' quadratic, and at 596 tests that is 350k string compares to print 596 lines.

dim as long passed = 0, failed = 0
dim as Array( of Failure ) failures
dim as long pi = 0, si = 0

while (pi < parJobs.Count) orelse (si < serJobs.Count)
    dim as boolean takePar = false
    if si >= serJobs.Count then
        takePar = true
    elseif pi < parJobs.Count then
        takePar = (parJobs[pi].path <= serJobs[si].path)
    end if

    dim as string path_ = ""
    dim as long state = 0
    dim as string why = ""
    if takePar then
        path_ = parJobs[pi].path : state = parJobs[pi].state : why = parJobs[pi].why
        pi += 1
    else
        path_ = serJobs[si].path : state = serJobs[si].state : why = serJobs[si].why
        si += 1
    end if

    if state = 1 then
        passed += 1
        if opts.verbose then print "PASS " & path_
    else
        failed += 1
        dim as Failure f
        f.test = path_
        f.why = why
        failures.Push( f )
        print "FAIL " & path_ & ": " & why
    end if
wend

print
print "tiko-test " & RUNNER_VERSION & ": " & passed & " passed, " & _
      failed & " failed, " & skipped & " skipped"

if failed > 0 then end 1
end 0
