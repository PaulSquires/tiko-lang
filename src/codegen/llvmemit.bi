'' llvmemit.bi -- MIR to textual LLVM IR.
''
'' docs/plan/10 section 4. This is the ONLY file in tiko-lang that knows LLVM exists;
'' everything above it stops at MIR, which is what decision D1 bought and what makes a
'' second backend a new file rather than a rewrite.
''
'' It is a straight-line translator and deliberately dull: one MIR instruction in, one
'' or two LLVM instructions out, no analysis, no reordering, no cleverness. Anything
'' that needs a decision was made before here -- ABI shapes by the ABI pass, layout by
'' the frontend -- so that a bug in the emitted IR is a bug in one visible line.
''
'' WHAT IT WILL NOT DO IS SAY SO. An opcode it cannot emit stops the emission with a
'' message naming it, rather than writing something plausible: wrong IR compiles and
'' runs, which is the one failure mode worth spending a whole file's discipline on.

#ifndef __TKO_LLVMEMIT_BI__
#define __TKO_LLVMEMIT_BI__

#include once "tko.bi"
#include once "mir/mir.bi"
#include once "codegen/target.bi"

namespace Tko.Codegen

    type EmitResult
        as boolean ok
        as string  text        '' the module, when ok
        '' The FIRST thing that could not be emitted, named. Not a list: the first one
        '' is the one to fix, and the rest are usually the same cause counted again.
        as string  ice
    end type

    declare function EmitLlvm _
        ( byref m as Tko.Mir.MirModule, byref names as Tko.Interner, _
          byref target as TargetDescription ) as EmitResult

end namespace

#endif
