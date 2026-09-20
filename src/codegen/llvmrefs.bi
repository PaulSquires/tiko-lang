'' llvmrefs.bi -- which functions the module actually names.
''
'' ONE QUESTION, ASKED ONCE PER MODULE: is this function referred to anywhere in it?
'' The emitter needs it for exactly one rule -- fbc does not emit an unreferenced
'' PRIVATE procedure, and emitting one makes a link fail that fbc links (llvmemit.bas,
'' and the measurement is in ReferencedFunctions's own header).
''
'' Nothing here touches the emitter's output or its private helpers, which is why it is
'' a file of its own rather than more of llvmemit.bas.

#ifndef __TKO_LLVMREFS_BI__
#define __TKO_LLVMREFS_BI__

#include once "mir/mir.bi"
#include once "support/irtext.bi"

namespace Tko.Codegen

    '' One entry per m.functions, 1 when the module names that function and 0 when
    '' nothing in it does.
    declare function ReferencedFunctions _
        ( byref m as Tko.Mir.MirModule ) as FB.Array( of ubyte )

    '' The 'declare' lines a vtable slot needs when the module defines no such
    '' function; 'outSoFar' is what has been written, so nothing is declared twice.
    declare function DeclareUnknownVtableSlots _
        ( byref m as Tko.Mir.MirModule, byref names as Tko.Interner, _
          byref outSoFar as IrText ) as string

end namespace

#endif
