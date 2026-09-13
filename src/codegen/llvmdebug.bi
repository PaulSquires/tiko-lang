'' llvmdebug.bi -- '-g': the debug metadata that gives an object a line table.
''
'' LINE TABLES ONLY, in DWARF on every target (docs/plan/10 section 6; CodeView is
'' deferred). One DICompileUnit per module, one DISubprogram per defined procedure, and a
'' DILocation on every instruction of it -- EVERY one, because LLVM's verifier refuses
'' a call without a location inside a function that has a subprogram. Variables and
'' types are not described yet.
''
'' The emitter asks for strings and writes them where they belong; nothing here touches
'' its output, so this file needs none of its private helpers.

#ifndef __TKO_LLVMDEBUG_BI__
#define __TKO_LLVMDEBUG_BI__

#include once "tko.bi"
#include once "source/manager.bi"

namespace Tko.Codegen

    type DebugInfo
        as Tko.SourceManager ptr sm
        as long     nextId          '' the next metadata number
        as string   nodes           '' every '!N = ...' line so far
        as long     cuId
        as long     typeId          '' the one subroutine type every subprogram shares
        as long     mainFileId
        '' FileId + 1 -> the DIFile's metadata number, 0 while it has none.
        as FB.Array( of long ) fileMeta
        as long     curSp           '' the subprogram being emitted, -1 outside one
        as long     locLine         '' the line the last DILocation was made for
        as long     locId
    end type

    declare sub DbgBegin _
        ( byref d as DebugInfo, byval sm as Tko.SourceManager ptr, byref mainPath as string )

    '' Opens a subprogram and answers its metadata number. 'fileKey' is FileId + 1, and
    '' 0 means the module's own file.
    declare function DbgSubprogram _
        ( byref d as DebugInfo, byref linkName as string, byval fileKey as ulong, _
          byval lineNo as long ) as long

    '' ', !dbg !N' for an instruction on this line, or nothing outside a subprogram.
    declare function DbgLocSuffix( byref d as DebugInfo, byval lineNo as long ) as string

    '' The module-level half: the compile unit list, the flags, and every node.
    declare function DbgFinish( byref d as DebugInfo ) as string

end namespace

#endif
