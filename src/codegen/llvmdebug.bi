'' llvmdebug.bi -- '-g': the debug metadata that gives an object a line table, and --
'' when the driver hands over the frontend -- its variables and their types.
''
'' DWARF on every target (docs/plan/10 section 6; CodeView is deferred). One
'' DICompileUnit per module, one DISubprogram per defined procedure, and a DILocation
'' on every instruction of it -- EVERY one, because LLVM's verifier refuses a call
'' without a location inside a function that has a subprogram.
''
'' VARIABLES: a DILocalVariable and a '#dbg_declare' for each user local and parameter
'' (its alloca is its home for the whole procedure), a DIGlobalVariableExpression for
'' each variable global. TYPES are described as the storage really is -- a STRING is
'' the FBSTRING descriptor, a dynamic array its FBARRAY -- so a debugger shows the
'' descriptor, which is imperfect and honest. Measured on LLVM 21's lldb, Windows and
'' a PE with '-debug:dwarf', against clang's own output for the same shapes: locals,
'' parameters, globals, structs, enums, arrays, 'char*' and 'wchar_t[]' as text.
''
'' Not yet: lexical blocks (MIR keeps no block scopes, so a variable belongs to its
'' procedure), columns, and optimised code.
''
'' The emitter asks for strings and writes them where they belong; nothing here touches
'' its output, so this file needs none of its private helpers.

#ifndef __TKO_LLVMDEBUG_BI__
#define __TKO_LLVMDEBUG_BI__

#include once "tko.bi"
#include once "source/manager.bi"
#include once "types/type.bi"
#include once "types/udtlayout.bi"
#include once "symbols/symbol.bi"

namespace Tko.Codegen

    '' WHAT THE VARIABLES AND TYPES ARE DESCRIBED FROM. The emitter proper sees MIR
    '' only; this is the frontend state the driver still holds when it calls EmitLlvm.
    '' Without it (a null pointer) '-g' is line tables only, as it always was.
    type DebugFrontend
        as Tko.TypeContext ptr types
        as Tko.SymbolTable ptr syms
        as Tko.UdtLayouts ptr  udts
        as Tko.Interner ptr    names
    end type

    type DebugInfo
        as Tko.SourceManager ptr sm
        as DebugFrontend ptr fe
        as long     nextId          '' the next metadata number
        as string   nodes           '' every '!N = ...' line so far
        as long     cuId
        as long     typeId          '' the one subroutine type every subprogram shares
        as long     mainFileId
        '' FileId + 1 -> the DIFile's metadata number, 0 while it has none.
        as containers.Array( of long ) fileMeta
        as long     curSp           '' the subprogram being emitted, -1 outside one
        as long     curFile         '' ...and its DIFile
        as long     locLine         '' the line the last DILocation was made for
        as long     locId
        as long     argNo           '' parameters declared so far in this subprogram
        '' TypeId -> its DI type node, 0 while it has none. -1 is "cannot be described".
        as containers.Array( of long ) typeMeta
        '' A procedure's SUBPROGRAM NUMBER, reserved before the procedure is emitted:
        '' a static local is a GLOBAL, globals are emitted first, and its scope is the
        '' procedure it lives in.
        as containers.Array( of ulong ) spSym
        as containers.Array( of long )  spId
        as containers.Array( of ubyte ) spDone      '' ...and whether its text has been written
        as string   globals         '' ', !N' for each DIGlobalVariableExpression
        as long     intType         '' 'integer', for the descriptors' counts
    end type

    declare sub DbgBegin _
        ( byref d as DebugInfo, byval sm as Tko.SourceManager ptr, byref mainPath as string, _
          byval fe as DebugFrontend ptr = 0 )

    '' Opens a subprogram and answers its metadata number. 'fileKey' is FileId + 1, and
    '' 0 means the module's own file. 'procSym' names it by its source spelling; 0 for
    '' main and the module constructors, which keep their link names.
    declare function DbgSubprogram _
        ( byref d as DebugInfo, byref linkName as string, byval fileKey as ulong, _
          byval lineNo as long, byval procSym as ulong = 0 ) as long

    '' ', !dbg !N' for an instruction on this line, or nothing outside a subprogram.
    declare function DbgLocSuffix( byref d as DebugInfo, byval lineNo as long ) as string

    '' The '#dbg_declare' line for a slot, or "" when it is not a user variable. 'sym'
    '' and 'frontType' are MirLocal's; 'slotIsPtr' says the slot holds a POINTER to a
    '' value of that type (a UDT or string passed by value, which MIR passes by address).
    declare function DbgDeclare _
        ( byref d as DebugInfo, byval sym as ulong, byval frontType as Tko.TypeId, _
          byval slotIsPtr as boolean, byref slotName as string ) as string

    '' ', !dbg !N' for a variable global's definition, or "".
    declare function DbgGlobal _
        ( byref d as DebugInfo, byval sym as ulong, byref linkName as string, _
          byval isLocal as boolean ) as string

    '' The module-level half: the compile unit list, the flags, and every node.
    declare function DbgFinish( byref d as DebugInfo ) as string

end namespace

#endif
