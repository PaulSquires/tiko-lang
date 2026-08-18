'' engine.bas -- see engine.bi

#include once "diag/engine.bi"
#include once "diag/render.bi"
#include once "support/platform.bi"

namespace Fbx

const POLICY_DEFAULT as long = -1
const POLICY_IGNORE  as long = -2

'' Diagnostics go to STDERR. FreeBASIC's 'print #0' is the console, i.e. stdout --
'' which silently sent every diagnostic down the same pipe as --dump-tokens output.
'' 'open err' is the only way to reach stderr, so the handle is opened once, lazily.
dim shared as long stderrHandle = 0



constructor DiagnosticEngine( )
    this.sources = 0
    this.errors = 0
    this.warnings = 0
    this.suppressedCount = 0
    this.maxErrors = DIAG_DEFAULT_MAX_ERRORS
    this.warningsAsErrors = false
    this.capReported = false
    this.colorMode = COLOR_AUTO
    this.outputFormat = DIAGFMT_FBC

    InitDiagTable( )
    this.policy.Reserve( DIAG_COUNT )
    for i as long = 0 to DIAG_COUNT - 1
        this.policy.Push( POLICY_DEFAULT )
    next
end constructor

sub DiagnosticEngine.Attach( byval src as SourceManager ptr )
    this.sources = src
end sub

'' --------------------------------------------------------------------- policy

sub DiagnosticEngine.Ignore( byval id as DiagId )
    dim as boolean bad = (id <= DIAG_NONE) orelse (id >= DIAG_COUNT)
    if bad then return
    this.policy[id] = POLICY_IGNORE
end sub

sub DiagnosticEngine.Promote( byval id as DiagId, byval s as Severity )
    dim as boolean bad = (id <= DIAG_NONE) orelse (id >= DIAG_COUNT)
    if bad then return
    this.policy[id] = cast( long, s )
end sub

sub DiagnosticEngine.SetWarningsAsErrors( byval v as boolean )
    this.warningsAsErrors = v
end sub

sub DiagnosticEngine.SetMaxErrors( byval n as long )
    if n < 1 then n = 1
    this.maxErrors = n
end sub

sub DiagnosticEngine.SetColorMode( byval newMode as DiagColorMode )
    this.colorMode = newMode
end sub

sub DiagnosticEngine.SetFormat( byval f as DiagOutputFormat )
    this.outputFormat = f
end sub

function DiagnosticEngine.UseColor( ) as boolean
    select case this.colorMode
    case COLOR_ALWAYS : return true
    case COLOR_NEVER  : return false
    case else         : return Fbx.Platform.IsTerminal( Fbx.Platform.STREAM_ERR )
    end select
end function

function DiagnosticEngine.EffectiveSeverity( byval id as DiagId ) as Severity
    dim as Severity base_ = DiagInfoOf( id )->defaultSev
    dim as boolean inRange = (id > DIAG_NONE) andalso (id < DIAG_COUNT)
    if inRange then
        dim as long p = this.policy[id]
        if p >= 0 then base_ = cast( Severity, p )
    end if
    dim as boolean escalate = this.warningsAsErrors andalso (base_ = SEV_WARNING)
    if escalate then return SEV_ERROR
    return base_
end function

'' ------------------------------------------------------------------ reporting

sub DiagnosticEngine.Push _
    ( byval id as DiagId, byval rng as SourceRange, byval hasLoc as boolean, _
      byval a0 as string, byval a1 as string, byval a2 as string )

    dim as boolean inRange = (id > DIAG_NONE) andalso (id < DIAG_COUNT)
    if inRange = false then return

    if this.policy[id] = POLICY_IGNORE then
        this.suppressedCount += 1
        return
    end if

    dim as Severity sev = this.EffectiveSeverity( id )

    if sev = SEV_ERROR then
        if this.errors >= this.maxErrors then
            this.errors += 1
            if this.capReported = false then
                this.capReported = true
                dim as Diagnostic cap
                cap.id = FBX0990
                cap.sev = SEV_ERROR
                cap.range = PointRange( LOC_NONE )
                cap.text = *DiagInfoOf( FBX0990 )->format
                cap.hasLocation = false
                this.pending.Push( cap )
            end if
            return
        end if
        this.errors += 1
    elseif sev = SEV_WARNING then
        this.warnings += 1
    end if

    dim as Diagnostic d
    d.id = id
    d.sev = sev
    d.range = rng
    d.text = FormatDiag( *DiagInfoOf( id )->format, a0, a1, a2 )
    d.hasLocation = hasLoc
    this.pending.Push( d )
end sub

sub DiagnosticEngine.Report _
    ( byval id as DiagId, byval rng as SourceRange, _
      byval a0 as string = "", byval a1 as string = "", byval a2 as string = "" )

    this.Push( id, rng, (rng.first <> LOC_NONE), a0, a1, a2 )
end sub

sub DiagnosticEngine.ReportGlobal _
    ( byval id as DiagId, byval a0 as string = "", _
      byval a1 as string = "", byval a2 as string = "" )

    this.Push( id, PointRange( LOC_NONE ), false, a0, a1, a2 )
end sub

sub DiagnosticEngine.AddNote _
    ( byval id as DiagId, byval rng as SourceRange, _
      byval a0 as string = "", byval a1 as string = "", byval a2 as string = "" )

    if this.pending.IsEmpty( ) then return

    dim as DiagNote n
    n.id = id
    n.range = rng
    n.text = FormatDiag( *DiagInfoOf( id )->format, a0, a1, a2 )
    this.pending[this.pending.Count - 1].notes.Push( n )
end sub

'' -------------------------------------------------------------------- output

sub DiagnosticEngine.Flush( )
    if this.pending.IsEmpty( ) then return

    dim as boolean colour = this.UseColor( )
    if colour then Fbx.Platform.EnableAnsi( )

    '' Rendered in report order. Determinism is a project requirement, so this
    '' must never become "sorted by location" or "grouped by file".
    if stderrHandle = 0 then
        dim as long fh = freefile
        open err for output as #fh
        stderrHandle = fh
    end if
    dim as long h = stderrHandle

    for each d as Diagnostic in this.pending
        dim as string rendered = Fbx.Render.Diagnostic_( d, *this.sources, this.outputFormat, colour )
        if h > 0 then
            print #h, rendered;
        else
            print rendered;                 '' stderr unavailable: better stdout than nothing
        end if
    next

    this.pending.Clear( )
end sub

function DiagnosticEngine.ErrorCount( ) as long
    return this.errors
end function

function DiagnosticEngine.WarningCount( ) as long
    return this.warnings
end function

function DiagnosticEngine.HasErrors( ) as boolean
    return (this.errors > 0)
end function

end namespace
