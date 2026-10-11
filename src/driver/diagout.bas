'' diagout.bas -- see diagout.bi

#import "std/containers"
#include once "driver/diagout.bi"
#include once "diag/machine.bi"
#include once "build/events.bi"
#include once "driver/modresolve.bi"

namespace Tko.DiagOut

function Start( byref ctx as Tko.CompilerContext ) as boolean
    if len( ctx.options.diagFile ) = 0 then return true

    '' CREATED NOW, EMPTY. A path that cannot be written is then a command-line error the
    '' user sees before anything is compiled, not a silent loss at the end; and a run that
    '' dies before Finish leaves an empty file rather than the last run's records, which
    '' an editor would otherwise show as this build's.
    '' NEVER ONE OF THE INPUTS: opening it for output truncates it, and the source was
    '' gone before a byte of it was read (audit F-65).
    dim as string dfAbs = Tko.Modules.AbsPath( ctx.options.diagFile )
    for k as long = 0 to ctx.options.inputs.Count - 1
        dim as string inAbs = Tko.Modules.AbsPath( ctx.options.inputs[k] )
        #ifdef __FB_WIN32__
            dim as boolean same = (lcase( inAbs ) = lcase( dfAbs ))
        #else
            dim as boolean same = (inAbs = dfAbs)
        #endif
        if same then
            ctx.diags.ReportGlobal( Tko.TKO0954, ctx.options.diagFile )
            ctx.options.diagFile = ""
            return false
        end if
    next
    dim as long fh = freefile
    '' Spelled as its own statement: the function form of OPEN inside an IF condition
    '' confuses the parser (see BuildFromIr).
    dim as long orc = open( ctx.options.diagFile for output as #fh )
    if orc <> 0 then
        ctx.diags.ReportGlobal( Tko.TKO0117, ctx.options.diagFile )
        ctx.options.diagFile = ""
        return false
    end if
    close #fh

    ctx.diags.EnableMachine( )
    return true
end function

function Finish( byref ctx as Tko.CompilerContext, byval rc as long ) as long
    ctx.diags.Flush( )
    Tko.Build.OnFinish( ctx.build, ctx.diags.ErrorCount( ), ctx.diags.WarningCount( ), rc )
    if len( ctx.options.diagFile ) = 0 then return rc

    '' ONE WRITE, and the trailing ';' matters: each record already ends in LF, and a
    '' PRINT per record would add the host's line ending after every one of them.
    dim as string body = Tko.Machine.Header( ) & ctx.diags.MachineText( ) & _
        Tko.Machine.EndRecord( ctx.diags.ErrorCount( ), ctx.diags.WarningCount( ), rc )

    '' Nowhere is left to report a failure here -- Start proved the path writable, and
    '' the console already has every diagnostic -- so a failed write is dropped.
    dim as long fh = freefile
    dim as long orc = open( ctx.options.diagFile for output as #fh )
    if orc <> 0 then return rc
    print #fh, body;
    close #fh
    return rc
end function

end namespace
