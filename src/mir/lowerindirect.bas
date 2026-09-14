'' lowerindirect.bas -- which parameters travel as a POINTER rather than as a value.
''
'' Split out of lowerimpl.bas at the 1500-line lint cap. That file synthesises the
'' structors a type did not write; these four answer an ABI question about a
'' parameter, and the only thing they share with it is the size test.

#include once "mir/lowerctx.bi"

namespace Tko.Mir



'' IS A BYVAL PARAMETER OF THIS TYPE PASSED INDIRECTLY, with the caller building the
'' copy?
''
'' Measured, and it is not 'every UDT'. fbc passes a TRIVIAL structure by value as a
'' struct and a NON-TRIVIAL one as a pointer to a caller-built temporary:
''
''     type P : as long a, b : end type            void TAKEP( struct $1P );
''     type C1 : declare constructor( ) : end type void T2 ( struct $2C1 );
''     type D1 : declare destructor( )  : end type void T1 ( struct $2D1* );
''     type S1 : as string s            : end type void T3 ( struct $2S1* );
''     type V1 extends object           : end type void T4 ( struct $2V1* );
''
'' -- so a DEFAULT constructor alone does not move it, and a destructor or a copy
'' constructor, written or synthesised, does. That is the same distinction C++ draws
'' and it is what the caller's temporary exists for: the callee's parameter IS that
'' temporary, and the caller destroys it after the call returns.
function ByvalUdtIndirect_( byref c as Ctx, byval t as Tko.TypeId ) as boolean
    if t = Tko.TYPE_NONE then return false
    if c.types->Kind( t ) <> Tko.TK_UDT then return false
    if TypeNeedsDtor_( c, t ) then return true
    if NeedsLetBody_( c, t ) then return true
    '' A WRITTEN copy constructor, by SHAPE: the one-argument constructor whose
    '' parameter is this same type. Any other one-argument constructor is a conversion
    '' and says nothing about how the type is passed.
    return (CopyCtorOf_( c, t ) <> Tko.SYMBOL_NONE)
end function

'' A BYVAL VAR-LENGTH STRING PARAMETER IS INDIRECT TOO, and for the same reason: the
'' callee gets a descriptor of its OWN, built by the caller.
''
'' Measured -- 'void TAKEBYVALSTRING( FBSTRING* )', and around the call
''
''     memset( &TMP$4$0, 0, 24 );
''     fb_StrAssign( &TMP$4$0, -1, &V$0, -1, 0 );
''     TAKEBYVALSTRING( &TMP$4$0 );
''     fb_StrDelete( &TMP$4$0 );
''
'' -- so the argument is COPIED. Passing the descriptor by value, which is what this
'' did, gave the callee a second owner of the caller's buffer: a callee that appends
'' to its parameter reallocated it and left the caller's descriptor dangling, and the
'' caller then deleted the freed pointer. It lowered and it verified.
function ByvalStrIndirect_( byref c as Ctx, byval t as Tko.TypeId ) as boolean
    return IsStringType( c, t )
end function

'' The same question about a PARAMETER, which needs the passing mode as well as the
'' type: a BYREF parameter is already a pointer and is not this.
''
'' THROUGH A PROCEDURE POINTER THE SIGNATURE ANSWERS, not the callee: the call has no
'' procedure symbol to read a parameter off, so both of these said no, and a byval UDT with
'' a destructor or a byval string went BY VALUE where the procedure reads a pointer to its
'' copy. fbc prints the text; tiko crashed. PsDatePicker's parse callback takes a byval
'' DWSTRING, which is how ApexWealth reaches it. A byref parameter's type there is a
'' reference, and is not this.
private function SigParamType_( byref c as Ctx, byval sigT as Tko.TypeId, byval idx as long ) as Tko.TypeId
    if c.types->Kind( sigT ) <> Tko.TK_PROC then return Tko.TYPE_NONE
    if (idx < 0) orelse (idx >= c.types->ProcParamCount( sigT )) then return Tko.TYPE_NONE
    dim as Tko.TypeId pt = c.types->ProcParam( sigT, idx )
    if c.types->Kind( pt ) = Tko.TK_REFERENCE then return Tko.TYPE_NONE
    return pt
end function

function ParamIsIndirectUdt_ _
    ( byref c as Ctx, byval callee as Tko.SymbolId, byval idx as long, _
      byval sigT as Tko.TypeId = Tko.TYPE_NONE ) as boolean

    if sigT <> Tko.TYPE_NONE then return ByvalUdtIndirect_( c, SigParamType_( c, sigT, idx ) )
    if ParamIsByref( c, callee, idx ) then return false
    if ParamIsArray( c, callee, idx ) then return false
    return ByvalUdtIndirect_( c, ParamTypeAt( c, callee, idx ) )
end function

function ParamIsIndirectStr_ _
    ( byref c as Ctx, byval callee as Tko.SymbolId, byval idx as long, _
      byval sigT as Tko.TypeId = Tko.TYPE_NONE ) as boolean

    if sigT <> Tko.TYPE_NONE then return ByvalStrIndirect_( c, SigParamType_( c, sigT, idx ) )
    if ParamIsByref( c, callee, idx ) then return false
    if ParamIsArray( c, callee, idx ) then return false
    return ByvalStrIndirect_( c, ParamTypeAt( c, callee, idx ) )
end function

end namespace
