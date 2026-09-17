'' A PROCEDURE TYPE'S PARAMETER THAT NAMED A TYPEDEF DECLARED LATER had NO type, so an
'' argument for it had no destination to be converted to and took DEFAULT ARGUMENT
'' PROMOTION instead -- the rule for an argument past the named parameters. A SINGLE
'' went out widened to DOUBLE in an SSE register while the callee read the integer one.
''
'' win/windef.bi writes 'type LPARAM as LONG_PTR' and 'type LRESULT as LONG_PTR' ahead
'' of the include that declares LONG_PTR, so every 'function( ..., byval as LPARAM ) as
'' LRESULT' pointer in windows.bi was built that way -- AfxNova's
'' Scintilla_DirectFunction among them. That is fault thirteen in tiko-editor:
'' 'SciMsg( pSci, SCI_SETMARGINWIDTHN, 1, 16 * rxRatio )' set the margin from whatever
'' was left in the integer register, 1.79 billion pixels wide, and the editor pane
'' showed nothing at all while the document sat correctly loaded behind it.
''
'' The RESULT half of the same defect was fixed already; this is the parameters. They
'' are mended in the interned type in place, because a variable is bound to that very
'' TypeId by the time the name is known.
''
'' THE GOLDEN IS THE ASSERTION: 'fptosi' where the broken compiler wrote 'fpext', and
'' 'nearbyint' before it because FB rounds where C truncates. tests/mir does not run
'' what it builds, and at run time the difference is 28 against a stale register.

type MID_ as BASE_
type BASE_ as longint

type PT_ as function cdecl ( byval l as MID_ ) as longint

function Sink_ cdecl ( byval l as longint ) as longint
    return l
end function

dim shared gp as PT_

sub Wire_( )
    dim as any ptr raw = @Sink_
    gp = cast( PT_, raw )
end sub

sub Fire_( )
    dim rx as single = 1
    dim as single ptr prx = @rx
    *prx = 1.75
    print gp( 16 * rx )
end sub

Wire_( )
Fire_( )
