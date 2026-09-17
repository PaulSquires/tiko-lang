'' A PROCEDURE TYPE WHOSE RESULT NAMES A TYPEDEF DECLARED LATER IN THE UNIT.
''
'' win/windef.bi writes
''
''     line 113   type LRESULT as LONG_PTR
''     line 129   #include once "basetsd.bi"      '' where LONG_PTR is declared
''
'' so every 'function( ... ) as LRESULT' pointer in windows.bi is built before its own
'' result type exists. ResolveTypeRef returned TYPE_NONE for the result and the
'' procedure type was interned with NO result at all -- indistinguishable, downstream,
'' from a SUB. Every call through such a pointer lowered as
''
''     call.ind void %8(%7)
''
'' which yields no value, so the assignment around it was dropped and the variable kept
'' whatever the stack held. Silently: "0 statements not lowered".
''
'' AfxNova's Scintilla_DirectFunction is exactly that shape, and
''
''     dim as any ptr pDoc = cast( any ptr, SciMsg( pSci(0), SCI_GETDOCPOINTER, 0, 0 ) )
''     if pDoc then SciMsg( pSci(1), SCI_SETDOCPOINTER, 0, cast( LPARAM, pDoc ) )
''
'' handed Scintilla an UNINITIALISED pointer. SetDocPointer takes the non-null branch,
'' stores it and calls AddRef through its vtable -- 'movq (%rbx+0x18), %rax' at
'' Scintilla64.dll+0x4CDEB -- and tiko-editor died at 0xC0000005 inside the DLL.
''
'' THE REPAIR IS IN PLACE, on the type. By the time the name becomes known a variable
'' is already bound to this very TypeId, so re-deriving the type would mend a copy
'' nobody holds.
type MyRes  as MyBase          '' forward: MyBase does not exist yet
type MyBase as longint

type F_fwd   as function cdecl( byval p as any ptr ) as MyRes
'' The same thing written in the ordinary order -- it always worked, so a test
'' carrying only this one would pass on the broken compiler.
type F_plain as function cdecl( byval p as any ptr ) as MyBase

function Echo cdecl( byval p as any ptr ) as longint
    return &h00007FF9ABCD1234
end function

dim shared a as F_fwd, b as F_plain
a = cast( F_fwd, @Echo )
b = cast( F_plain, @Echo )

'' A VARIABLE of the forward-declared typedef was always right; only the procedure
'' type's RESULT was not.
dim as MyRes v = &h00007FF9ABCD1234
print "variable  = &h"; hex( v ); " sizeof="; sizeof( MyRes )
dim as longint r1 = a( 0 )
print "forward   = &h"; hex( r1 )
dim as longint r2 = b( 0 )
print "ordinary  = &h"; hex( r2 )
