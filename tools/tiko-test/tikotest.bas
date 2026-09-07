'' tikotest.bas -- the tiko-lang test runner.
''
''     bin/tiko-test [suite...] [--accept] [--filter <pat>] [--tiko-lang <path>] [-v]
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
''     '' EXPECT-MAX-DIAG: 3        at most N ': error TKO' lines -- the recovery gate
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
'' Output is deterministic: tests run in sorted path order regardless of anything.

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
end type

type Options
    as Array( of string ) suites
    as string filter
    as string tikoPath
    as boolean accept
    as boolean verbose
end type

'' ---------------------------------------------------------------- small helpers

function Trim_( byval s as string ) as string
    return trim( s, any !" \t\r\n" )
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
function NormalizeEol( byval s as string ) as string
    dim as string outp = ""
    dim as long n = len( s )
    for i as long = 0 to n - 1
        if s[i] <> 13 then outp += chr( s[i] )
    next
    return outp
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
function NormalizeSkipSites( byval s as string ) as string
    dim as string outp = ""
    dim as long n = len( s )
    dim as long i = 0
    while i < n
        '' '.bas:' followed by digits is the only shape this touches.
        if (i + 4 < n) andalso (s[i] = 46) then            '' '.'
            if mid( s, i + 1, 5 ) = ".bas:" then
                dim as long j = i + 5
                dim as long d = 0
                while (j < n) andalso (s[j] >= 48) andalso (s[j] <= 57)
                    j += 1
                    d += 1
                wend
                if d > 0 then
                    outp += ".bas:LINE"
                    i = j
                    continue while
                end if
            end if
        end if
        outp += chr( s[i] )
        i += 1
    wend

    '' The separator pass, line by line.
    dim as string r = ""
    dim as long st = 1
    while st <= len( outp )
        dim as long nl = instr( st, outp, chr( 10 ) )
        dim as string ln
        if nl = 0 then
            ln = mid( outp, st ) : st = len( outp ) + 1
        else
            ln = mid( outp, st, nl - st + 1 ) : st = nl + 1
        end if
        if instr( ln, "skip-site " ) > 0 then
            for k as long = 0 to len( ln ) - 1
                if ln[k] = 92 then ln[k] = asc( "/" )
            next
        end if
        r += ln
    wend
    return r
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
        elseif StartsWith( ln, "EXPECT-FILE:" ) then
            tc.expectFile.Push( Trim_( mid( ln, 13 ) ) )
        elseif StartsWith( ln, "ENV:" ) then
            tc.env.Push( Trim_( mid( ln, 5 ) ) )
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
    ( byval tikoPath as string, byval args as string, byref outText as string ) as long

    dim as string tmp = "build/.tikotest.out"
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

declare function CheckOne_ _
    ( byref tc as TestCase, byref opts as Options, byval tgt as string, _
      byval rc as long, byref outText as string, byref why as string ) as boolean

function RunOne _
    ( byref tc as TestCase, byref opts as Options, byref why as string ) as boolean

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

    '' The variable is set for this run and cleared straight after, so a test that
    '' needs an environment cannot leak it into the next one. Order matters: tiko-lang reads
    '' it at startup, so it must be in place before the shell( ) and gone before the
    '' following test builds its own command.
    for each e_ as string in tc.env
        setenviron e_
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
        '' NAMED, ALWAYS. See the TARGETS note at the top of this file.
        rc = RunTko( opts.tikoPath, "-target " & tgt & " " & args, outText )
        if CheckOne_( tc, opts, tgt, rc, outText, why ) = false then
            if tc.targets.Count > 1 then why = "[" & tgt & "] " & why
            for each e2 as string in tc.env
                dim as long eq2 = instr( e2, "=" )
                if eq2 > 0 then setenviron left( e2, eq2 )
            next
            return false
        end if
    next

    for each e_ as string in tc.env
        dim as long eq = instr( e_, "=" )
        if eq > 0 then setenviron left( e_, eq )
    next

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

'' ------------------------------------------------------------------------ main

dim as Options opts
opts.tikoPath = "bin/tiko.exe"
#ifndef __FB_WIN32__
    opts.tikoPath = "bin/tiko"
#endif
opts.accept = false
opts.verbose = false
opts.filter = ""

dim as long argi = 1
while len( command( argi ) ) > 0
    dim as string a = command( argi )
    select case a
    case "--accept" : opts.accept = true
    case "-v"       : opts.verbose = true
    case "--filter" : argi += 1 : opts.filter = command( argi )
    case "--tiko-lang"    : argi += 1 : opts.tikoPath = command( argi )
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

dim as Array( of string ) files
for each suite as string in opts.suites
    CollectTests( suite, files )
next
Sort( files )

dim as long passed = 0, failed = 0, skipped = 0
dim as Array( of Failure ) failures

for each path as string in files
    if len( opts.filter ) > 0 then
        if instr( path, opts.filter ) = 0 then continue for
    end if

    dim as TestCase tc
    if ParseTest( path, tc ) = false then
        skipped += 1
        continue for
    end if

    if tc.kind = "skip" then
        skipped += 1
        if opts.verbose then print "SKIP " & path
        continue for
    end if

    dim as string why = ""
    if RunOne( tc, opts, why ) then
        passed += 1
        if opts.verbose then print "PASS " & path
    else
        failed += 1
        dim as Failure f
        f.test = path
        f.why = why
        failures.Push( f )
        print "FAIL " & path & ": " & why
    end if
next

print
print "tiko-test " & RUNNER_VERSION & ": " & passed & " passed, " & _
      failed & " failed, " & skipped & " skipped"

if failed > 0 then end 1
end 0
