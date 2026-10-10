'' '#ifdef' / 'defined( )' OF A NAME DECLARED ONLY IN A NAMESPACE is true where that
'' namespace is in scope -- itself, one nested in it, after a 'using' -- and false at
'' the top level. Measured with fbc, all five lines below. tiko said defined everywhere:
'' fb/fsinfo.bi's 'FB.Stat' made crt/win32/wchar.bi's '#ifndef stat' false, its
'' 'type _stat' was skipped, and 'byval as _stat ptr' failed (TKO0808) -- the Widget
'' guard below is that shape.
namespace NS
    declare function Widget( ) as long
end namespace
#ifdef widget
#print A: widget at the top level
#endif
#ifndef widget
type widget
    as long x
end type
#endif
dim as widget w
namespace NS
#ifdef widget
#print B: widget inside NS
#endif
end namespace
namespace NS.Inner
#if defined( widget )
#print C: widget inside NS.Inner
#endif
end namespace
using NS
#ifdef widget
#print D: widget after using NS
#endif
print w.x
