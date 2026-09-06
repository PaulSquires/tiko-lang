'' abtest.bi -- the A/B harness, split so the B side can run without gfxlib2.
''
'' ORIGINAL WORK. Part of libtkogfx (LGPL-2.1-or-later with the static-linking
'' exception).
''
'' WHY THIS EXISTS
''
'' The original abtests ran both sides in one process: ask gfxlib2 to draw a
'' case, draw it ourselves, compare digests. That is the cheapest possible
'' harness and it stays the default. But it cannot compare against MSVC.
'' gfxlib2 ships as a MinGW archive (libfbgfx.a); an MSVC-ABI binary cannot
'' link it, and no shim bridges the two CRTs. So a single process can host the
'' A side or the B side under MSVC, never both.
''
'' The fix is to separate them in TIME rather than in space. gfxlib2's answers
'' are constants, so they are recorded once, under MinGW, into tools/golden/,
'' and the MSVC build compares against the recording. Three roles, selected at
'' compile time:
''
''   (default)     A and B in one process, compared live.       -- unchanged
''   -d ABTEST_EMIT   A only; print each case's digest.         -- MinGW only
''   -d ABTEST_SUT    B only; compare against tools/golden/.    -- any ABI
''
'' A recording can go stale silently, which would turn the MSVC gate into a
'' tautology. It cannot here: abtest.sh's MinGW EMIT pass rewrites the file and
'' fails if the checked-in bytes disagree, so a gfxlib2 change is caught on the
'' one configuration that can still see gfxlib2.
''
'' The digest is deliberately pitch-independent -- it reads w pixels per row and
'' never the padding -- which is what makes a recording from one process
'' comparable to a buffer allocated by another.
''
'' THE ONE RULE A SPLIT TEST MUST OBEY
''
'' The sequence of Case_ calls must not depend on anything the A side produced.
'' A recording is positional, so a test that skips a case when gfxlib2 returns
'' something unexpected would record a shorter sequence than the SUT runs, and
'' every later case would be compared against the wrong recording. Branch on the
'' B side or on the case data -- never on a gfxlib2 answer -- and let a
'' disagreement be reported by Case_ rather than steer around it.
''
'' Violating it is not silent: Case_ carries the case name alongside the digest
'' and reports RECORDING OUT OF STEP the moment the two sequences diverge.

#ifndef __ABTEST_BI__
#define __ABTEST_BI__

#if defined( ABTEST_EMIT ) and defined( ABTEST_SUT )
#error "abtest.bi: ABTEST_EMIT and ABTEST_SUT are exclusive"
#endif

'' The B side never touches gfxlib2, so the roles that include it are exactly
'' the roles that are allowed to name it.
#ifndef ABTEST_SUT
#define ABTEST_HAS_GFXLIB2
#endif

'' REF( e ) -- an expression only the reference can evaluate.
''
'' Most A sides are one gfxlib2 call whose result is handed straight to a
'' comparison. Wrapping it lets the call site stay one line in all three roles:
'' the reference evaluates it, the subject evaluates nothing and Case_ ignores
'' the zero, because under ABTEST_SUT the A argument is not what is compared.
''
'' A top-level comma inside e -- REF( color( fg, bg ) ) -- is two arguments to
'' the macro and fbc says so. Assign into a variable inside an #ifdef block
'' there instead; there is no quiet failure mode.
#ifdef ABTEST_HAS_GFXLIB2
#define REF( e ) (e)
#else
#define REF( e ) 0
#endif

namespace Abtest

'' Sixteen characters, the same width as a digest, and not valid hex -- so a
'' recording line is unambiguously one or the other on sight.
const INTEROP_MARK = "reference-only--"

'' FNV-1a over the visible w*h pixels, row by row, so row padding never
'' contributes. Two buffers with different pitches still compare equal if the
'' pixels are the same, which is what we actually care about.
private function Digest overload ( byval pixels as any ptr, byval w as long, _
        byval h as long, byval pitch as long ) as ulongint
    dim as ulongint acc = 14695981039346656037ull
    for y as long = 0 to h - 1
        dim as ulong ptr row = cptr( ulong ptr, cptr( ubyte ptr, pixels ) + y * pitch )
        for x as long = 0 to w - 1
            acc = (acc xor row[x]) * 1099511628211ull
        next
    next
    return acc
end function

private function Digest overload ( byval bytes as any ptr, byval n as integer ) as ulongint
    dim as ubyte ptr b = bytes
    dim as ulongint acc = 14695981039346656037ull
    for i as integer = 0 to n - 1
        acc = (acc xor b[i]) * 1099511628211ull
    next
    return acc
end function

private function Digest overload ( byref s as const string ) as ulongint
    dim as ulongint acc = 14695981039346656037ull
    for i as integer = 0 to len( s ) - 1
        acc = (acc xor s[i]) * 1099511628211ull
    next
    return acc
end function

type State
    as string   tname         '' the abtest's own name, e.g. "abtest-line"
    as string   passline      '' what PASS means here, in this test's own words
    as long     ran
    as long     failures
    as long     skipped       '' reference-only cases the subject could not run
    as string   report
    as string   emitted       '' EMIT: the recording being built
    as string   golden(any)   '' SUT: one "hex<tab>case" line per case
    as long     ngolden
end type

dim shared as State st

'' The recording lives beside the sources rather than in the build tree: it is
'' checked in, reviewed like code, and its diff is the record of every raster
'' change libtkogfx has ever made.
private function GoldenPath( byval nm as string ) as string
    return exepath( ) + "/golden/" + nm + ".txt"
end function

'' Named separately from GoldenPath because the exe is built into a temp dir by
'' abtest.sh, so exepath() is wrong there; abtest.sh passes the real one.
private function ResolvePath( byval nm as string ) as string
    dim as string env = environ( "ABTEST_GOLDEN" )
    if len( env ) > 0 then return env + "/" + nm + ".txt"
    return GoldenPath( nm )
end function

sub Begin( byval nm as string, byval passline as string = "every case is identical" )
    st.tname = nm
    st.passline = passline
    st.ran = 0
    st.failures = 0

#ifdef ABTEST_SUT
    dim as string path = ResolvePath( nm )
    dim as long f = freefile
    if open( path for input as #f ) <> 0 then
        print nm; ": FAIL -- no recording at "; path
        print nm; ": run tools/abtest.sh --record under MinGW first"
        end 2
    end if
    redim st.golden( 0 to 255 )
    do until eof( f )
        dim as string ln
        line input #f, ln
        if len( ln ) = 0 then continue do
        if left( ln, 1 ) = "#" then continue do
        if st.ngolden > ubound( st.golden ) then
            redim preserve st.golden( 0 to ubound( st.golden ) * 2 + 1 )
        end if
        st.golden( st.ngolden ) = ln
        st.ngolden += 1
    loop
    close #f
#endif
end sub

'' One case. In EMIT the b argument is ignored and a is recorded; in SUT the a
'' argument is ignored and b is checked against the recording; in the default
'' role the two are compared directly. Every role therefore calls this with the
'' same arguments, and a case that is skipped in one role is skipped in all.
sub Case_ ( byval cname as string, byval a as ulongint, byval b as ulongint, _
        byval detail as string = "" )
    dim as long i = st.ran
    st.ran += 1

#if defined( ABTEST_EMIT )
    st.emitted += hex( a, 16 ) + chr( 9 ) + cname + chr( 10 )

#elseif defined( ABTEST_SUT )
    if i >= st.ngolden then
        st.report += "  NO RECORDING for " + cname + chr( 10 )
        st.failures += 1
        exit sub
    end if
    dim as string ln = st.golden( i )
    dim as ulongint want = cast( ulongint, valulng( "&h" + left( ln, 16 ) ) )
    dim as string wname = mid( ln, 18 )
    if wname <> cname then
        st.report += "  RECORDING OUT OF STEP at case" + str( i ) + _
                     ": recorded """ + wname + """, ran """ + cname + """" + chr( 10 )
        st.failures += 1
        exit sub
    end if
    if want <> b then
        st.report += "  MISMATCH " + cname + _
                     "  gfxlib2=" + hex( want, 16 ) + "  tko=" + hex( b, 16 ) + _
                     iif( len( detail ) > 0, "  " + detail, "" ) + chr( 10 )
        st.failures += 1
    end if

#else
    if a <> b then
        st.report += "  MISMATCH " + cname + _
                     "  gfxlib2=" + hex( a, 16 ) + "  tko=" + hex( b, 16 ) + _
                     iif( len( detail ) > 0, "  " + detail, "" ) + chr( 10 )
        st.failures += 1
    end if
#endif
end sub

'' A case only the reference can run.
''
'' Not everything reduces to "observe gfxlib2, observe ourselves, compare". A
'' few checks feed OUR output into gfxlib2 -- their decoder eating our stream,
'' their PUT reading our image -- and no recording can stand in for that,
'' because the reference has to be present to consume something that does not
'' exist until run time.
''
'' Such a case still occupies a position in the recording, so the sequence stays
'' aligned and every case after it is compared against the right line. The
'' subject skips it and says so; it is reported as a skip, never as a pass.
sub Interop_ ( byval cname as string, byval a as ulongint, byval b as ulongint, _
        byval detail as string = "" )
    dim as long i = st.ran
    st.ran += 1

#if defined( ABTEST_SUT )
    if i >= st.ngolden then
        st.report += "  NO RECORDING for " + cname + chr( 10 )
        st.failures += 1
        exit sub
    end if
    dim as string ln = st.golden( i )
    if left( ln, 16 ) <> INTEROP_MARK then
        st.report += "  RECORDING OUT OF STEP at case" + str( i ) + _
                     ": """ + cname + """ is reference-only here but was recorded as a digest" + chr( 10 )
        st.failures += 1
        exit sub
    end if
    if mid( ln, 18 ) <> cname then
        st.report += "  RECORDING OUT OF STEP at case" + str( i ) + _
                     ": recorded """ + mid( ln, 18 ) + """, ran """ + cname + """" + chr( 10 )
        st.failures += 1
        exit sub
    end if
    st.skipped += 1
#else
    if a <> b then
        st.report += "  MISMATCH " + cname + _
                     "  gfxlib2=" + hex( a, 16 ) + "  tko=" + hex( b, 16 ) + _
                     iif( len( detail ) > 0, "  " + detail, "" ) + chr( 10 )
        st.failures += 1
    end if
#ifdef ABTEST_EMIT
    st.emitted += INTEROP_MARK + chr( 9 ) + cname + chr( 10 )
#endif
#endif
end sub

'' A case that failed before it could produce a digest -- imagecreate returned
'' NULL, a file would not open. Counted, never recorded, and fatal in every
'' role, so a recording can never contain a hole.
sub Fail_ ( byval cname as string, byval why as string )
    st.ran += 1
    st.failures += 1
    st.report += "  " + cname + ": " + why + chr( 10 )
end sub

'' Ends the process. Nothing may print before this in a role that writes a
'' recording, because the recording goes to stdout and abtest.sh captures it
'' whole.
sub Finish_ ( )
#ifdef ABTEST_EMIT
    if st.failures > 0 then
        print st.report;
        print st.tname; ": CANNOT RECORD -- "; st.failures; " case(s) failed on the gfxlib2 side"
        end 1
    end if
    print st.emitted;
    end 0
#else
    dim as string against = "gfxlib2"
#ifdef ABTEST_SUT
    against = "the gfxlib2 recording"
#endif
    print st.tname; " -- "; st.ran; " cases against "; against
    if st.skipped > 0 then
        print st.tname; ": "; st.skipped; " reference-only case(s) SKIPPED -- gfxlib2 has to be present to run them"
    end if
    if st.failures = 0 then
        print st.tname; ": PASS -- "; st.passline
        end 0
    else
        print st.report;
        print st.tname; ": FAIL -- "; st.failures; " of"; st.ran; " cases differ"
        end 1
    end if
#endif
end sub

end namespace

#endif
