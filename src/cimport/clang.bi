'' clang.bi -- libclang, declared by hand and loaded at first use.
''
'' THE C IMPORTER'S ONLY VIEW OF CLANG. Everything #cinclude learns about a header comes
'' through these entry points, so this file is the contract with LLVM and nothing else in
'' src/cimport names a libclang type.
''
'' DECLARED BY HAND, FROM LLVM'S OWN HEADERS -- not generated, and not taken from any other
'' binding. tiko's own source may not use #cinclude (docs/plan/README.md, the self-hosting
'' whitelist: it would put libclang into tiko's BUILD), so the declarations are written out
'' the way src/support/platform.bas writes out its handful of Win32 calls. Every signature
'' below was read from the headers an LLVM install ships, clang-c/Index.h and its siblings
'' CXString.h, CXFile.h, CXDiagnostic.h and CXSourceLocation.h; the line cited is Index.h's
'' in LLVM 21.1.0 unless another file is named.
''
'' NEVER LINKED. libclang is found and opened with DyLibLoad the first time a header is
'' imported (clang.bas), so tiko builds and runs on a machine with no libclang at all, and
'' only #cinclude and -cimport ask for it.
''
'' SIX STRUCTURES CROSS BY VALUE, and they are the reason this file has a test of its own:
'' CXCursor (32 bytes), CXType (24), CXSourceLocation (24), CXSourceRange (24) and CXToken
'' (24) travel in memory on SysV and through a pointer to a copy on win64, and CXString (16)
'' comes back in two registers on SysV and through a hidden pointer on win64. Before 2026-09-21 tiko passed
'' every one of them wrongly through a procedure pointer -- see PtrCallSigIndex_ in
'' src/mir/lowersig.bas and tests/mir/procptr-byval-agg.test. ClangLoad checks the sizes
'' before it trusts a single call.

#pragma once

namespace Tko.CImport

'' ---------------------------------------------------------------- by-value structures

'' CXString.h:37. The text is reached through clang_getCString and must be released with
'' clang_disposeString; 'private_flags' says who owns it and is never read here.
type CXString
    as any ptr data
    as ulong private_flags
end type

'' Index.h:2337. 'kind' is a CXCursorKind.
type CXCursor
    as long kind
    as long xdata
    data(0 to 2) as any ptr
end type

'' Index.h:3090. 'kind' is a CXTypeKind.
type CXType
    as long kind
    data(0 to 1) as any ptr
end type

'' CXSourceLocation.h:44 and :55.
type CXSourceLocation
    ptr_data(0 to 1) as any ptr
    as ulong int_data
end type
type CXSourceRange
    ptr_data(0 to 1) as any ptr
    as ulong begin_int_data
    as ulong end_int_data
end type

'' Index.h:5025. 'int_data(0)' holds the CXTokenKind; the rest is libclang's.
type CXToken
    int_data(0 to 3) as ulong
    as any ptr ptr_data
end type

'' Index.h:106. 'Length' is C's 'unsigned long', which is the ONE field here whose width
'' is the host's: 4 bytes on Windows (LLP64) and 8 on Linux (LP64). Both give the struct
'' 24 bytes, so a size check alone would pass the wrong declaration -- ClangLoad checks
'' the field's width as well. It is the HOST that matters, not the target being imported
'' for: libclang runs in this process.
type CXUnsavedFile
    as zstring ptr Filename
    as zstring ptr Contents
#ifdef __FB_WIN32__
    as ulong Length
#else
    as ulongint Length
#endif
end type

'' The layout ClangLoad insists on before trusting a call.
const CX_STRING_BYTES   = 16
const CX_CURSOR_BYTES   = 32
const CX_TYPE_BYTES     = 24
const CX_LOCATION_BYTES = 24
const CX_RANGE_BYTES    = 24
const CX_UNSAVED_BYTES  = 24
const CX_TOKEN_BYTES    = 24

'' ---------------------------------------------------------------- enumerations
''
'' Only the values this importer reads, each with the line that defines it. C enums are
'' 'int', so every one is a LONG.

'' CXCursorKind.
const CXCursor_StructDecl          = 2      '' Index.h:1199
const CXCursor_UnionDecl           = 3      '' :1201
const CXCursor_EnumDecl            = 5      '' :1205
const CXCursor_FieldDecl           = 6      '' :1210
const CXCursor_EnumConstantDecl    = 7      '' :1212
const CXCursor_FunctionDecl        = 8      '' :1214
const CXCursor_VarDecl             = 9      '' :1216
const CXCursor_ParmDecl            = 10     '' :1218
const CXCursor_TypedefDecl         = 20     '' :1238
const CXCursor_TranslationUnit     = 350    '' :2229
const CXCursor_MacroDefinition     = 501    '' :2284
const CXCursor_InclusionDirective  = 503    '' :2287

'' CXChildVisitResult, Index.h:3977-3987 (implicit values).
const CXChildVisit_Break    = 0
const CXChildVisit_Continue = 1
const CXChildVisit_Recurse  = 2

'' CXTranslationUnit_Flags.
const CXTranslationUnit_DetailedPreprocessingRecord = &h01    '' Index.h:696
const CXTranslationUnit_Incomplete                  = &h02    '' :709
const CXTranslationUnit_SkipFunctionBodies          = &h40    '' :761
const CXTranslationUnit_KeepGoing                   = &h200   '' :787

'' ---------------------------------------------------------------- callbacks

'' Index.h:4002. BOTH CURSORS ARRIVE BY VALUE -- the callee side of the ABI question.
type CXCursorVisitor as function cdecl _
    ( byval cursor as CXCursor, byval parent as CXCursor, byval client as any ptr ) as long

'' Index.h:6739. The field arrives by value; the result is a CXVisitorResult (:6081).
type CXFieldVisitor as function cdecl ( byval cursor as CXCursor, byval client as any ptr ) as long
const CXVisit_Continue = 1

'' Index.h, CXInclusionVisitor: the included file, the stack that led to it, and its depth.
type CXInclusionVisitor as sub cdecl _
    ( byval included as any ptr, byval stack as CXSourceLocation ptr, _
      byval depth as ulong, byval client as any ptr )

'' ---------------------------------------------------------------- entry points
''
'' ONE LIST, TWO USES: it declares ClangApi's fields and it drives ClangLoad, so an entry
'' point cannot be declared and then left unloaded. FN is a function, SB a sub. The C name
'' is written out rather than stringised from the field name, as TKO_RTL_LIST does.
''
'' Opaque handles -- CXIndex, CXTranslationUnit, CXDiagnostic, CXEvalResult, CXFile,
'' CXClientData -- are ANY PTR. 'unsigned' is ULONG, 'long long' LONGINT, 'int' and every
'' enum LONG.
#macro TKO_CLANG_LIST( FN, SB )
    '' ---- the library and its strings
    FN( getClangVersion, "clang_getClangVersion", (), CXString )
    FN( getCString, "clang_getCString", ( byval s as CXString ), zstring ptr )
    SB( disposeString, "clang_disposeString", ( byval s as CXString ) )
    '' ---- index and translation unit
    FN( createIndex, "clang_createIndex", ( byval excludeFromPch as long, byval displayDiagnostics as long ), any ptr )
    SB( disposeIndex, "clang_disposeIndex", ( byval idx as any ptr ) )
    FN( parseTranslationUnit, "clang_parseTranslationUnit", ( byval idx as any ptr, byval sourceFilename as zstring ptr, byval args as zstring ptr ptr, byval numArgs as long, byval unsaved as CXUnsavedFile ptr, byval numUnsaved as ulong, byval options as ulong ), any ptr )
    SB( disposeTranslationUnit, "clang_disposeTranslationUnit", ( byval tu as any ptr ) )
    FN( getTranslationUnitCursor, "clang_getTranslationUnitCursor", ( byval tu as any ptr ), CXCursor )
    '' ---- cursors
    FN( getCursorSpelling, "clang_getCursorSpelling", ( byval c as CXCursor ), CXString )
    FN( getCursorKind, "clang_getCursorKind", ( byval c as CXCursor ), long )
    FN( getCursorUSR, "clang_getCursorUSR", ( byval c as CXCursor ), CXString )
    FN( getCursorType, "clang_getCursorType", ( byval c as CXCursor ), CXType )
    FN( visitChildren, "clang_visitChildren", ( byval parent as CXCursor, byval visitor as CXCursorVisitor, byval client as any ptr ), ulong )
    FN( Type_visitFields, "clang_Type_visitFields", ( byval t as CXType, byval visitor as CXFieldVisitor, byval client as any ptr ), ulong )  '' :6761
    FN( isCursorDefinition, "clang_isCursorDefinition", ( byval c as CXCursor ), ulong )
    FN( getCursorSemanticParent, "clang_getCursorSemanticParent", ( byval c as CXCursor ), CXCursor )
    FN( getCursorLocation, "clang_getCursorLocation", ( byval c as CXCursor ), CXSourceLocation )
    FN( getCursorExtent, "clang_getCursorExtent", ( byval c as CXCursor ), CXSourceRange )
    '' ---- tokens: Index.h:5047, :5055, :5085, :5124
    FN( getTokenKind, "clang_getTokenKind", ( byval t as CXToken ), long )
    FN( getTokenSpelling, "clang_getTokenSpelling", ( byval tu as any ptr, byval t as CXToken ), CXString )
    SB( tokenize, "clang_tokenize", ( byval tu as any ptr, byval r as CXSourceRange, byval toks as CXToken ptr ptr, byval n as ulong ptr ) )
    SB( disposeTokens, "clang_disposeTokens", ( byval tu as any ptr, byval toks as CXToken ptr, byval n as ulong ) )
    FN( getRangeStart, "clang_getRangeStart", ( byval r as CXSourceRange ), CXSourceLocation )
    FN( getRangeEnd, "clang_getRangeEnd", ( byval r as CXSourceRange ), CXSourceLocation )
    SB( getExpansionLocation, "clang_getExpansionLocation", ( byval loc as CXSourceLocation, byval file as any ptr ptr, byval line_ as ulong ptr, byval column as ulong ptr, byval offset as ulong ptr ) )
    '' ---- types
    FN( getTypeSpelling, "clang_getTypeSpelling", ( byval t as CXType ), CXString )
    FN( Type_getSizeOf, "clang_Type_getSizeOf", ( byval t as CXType ), longint )
    FN( Type_getAlignOf, "clang_Type_getAlignOf", ( byval t as CXType ), longint )
    FN( Type_getOffsetOf, "clang_Type_getOffsetOf", ( byval t as CXType, byval field as zstring ptr ), longint )
    FN( Cursor_getOffsetOfField, "clang_Cursor_getOffsetOfField", ( byval c as CXCursor ), longint )
    FN( getPointeeType, "clang_getPointeeType", ( byval t as CXType ), CXType )
    FN( Type_getNamedType, "clang_Type_getNamedType", ( byval t as CXType ), CXType )
    FN( getCanonicalType, "clang_getCanonicalType", ( byval t as CXType ), CXType )
    FN( getTypeDeclaration, "clang_getTypeDeclaration", ( byval t as CXType ), CXCursor )
    FN( getTypedefDeclUnderlyingType, "clang_getTypedefDeclUnderlyingType", ( byval c as CXCursor ), CXType )
    FN( getTypedefName, "clang_getTypedefName", ( byval t as CXType ), CXString )
    FN( isConstQualifiedType, "clang_isConstQualifiedType", ( byval t as CXType ), ulong )
    FN( getElementType, "clang_getElementType", ( byval t as CXType ), CXType )
    FN( getNumElements, "clang_getNumElements", ( byval t as CXType ), longint )
    '' ---- records and enums
    FN( Cursor_isBitField, "clang_Cursor_isBitField", ( byval c as CXCursor ), ulong )
    FN( getFieldDeclBitWidth, "clang_getFieldDeclBitWidth", ( byval c as CXCursor ), long )
    FN( Cursor_isAnonymous, "clang_Cursor_isAnonymous", ( byval c as CXCursor ), ulong )
    FN( Cursor_isAnonymousRecordDecl, "clang_Cursor_isAnonymousRecordDecl", ( byval c as CXCursor ), ulong )
    FN( getEnumDeclIntegerType, "clang_getEnumDeclIntegerType", ( byval c as CXCursor ), CXType )
    FN( getEnumConstantDeclValue, "clang_getEnumConstantDeclValue", ( byval c as CXCursor ), longint )
    FN( getEnumConstantDeclUnsignedValue, "clang_getEnumConstantDeclUnsignedValue", ( byval c as CXCursor ), ulongint )
    '' ---- functions
    FN( getResultType, "clang_getResultType", ( byval t as CXType ), CXType )
    FN( getCursorResultType, "clang_getCursorResultType", ( byval c as CXCursor ), CXType )
    FN( getNumArgTypes, "clang_getNumArgTypes", ( byval t as CXType ), long )
    FN( getArgType, "clang_getArgType", ( byval t as CXType, byval i as ulong ), CXType )
    FN( isFunctionTypeVariadic, "clang_isFunctionTypeVariadic", ( byval t as CXType ), ulong )
    FN( getFunctionTypeCallingConv, "clang_getFunctionTypeCallingConv", ( byval t as CXType ), long )
    FN( Cursor_getNumArguments, "clang_Cursor_getNumArguments", ( byval c as CXCursor ), long )
    FN( Cursor_getArgument, "clang_Cursor_getArgument", ( byval c as CXCursor, byval i as ulong ), CXCursor )
    FN( Cursor_isFunctionInlined, "clang_Cursor_isFunctionInlined", ( byval c as CXCursor ), ulong )
    FN( Cursor_isVariadic, "clang_Cursor_isVariadic", ( byval c as CXCursor ), ulong )
    FN( Cursor_getStorageClass, "clang_Cursor_getStorageClass", ( byval c as CXCursor ), long )
    '' ---- macros and evaluation
    FN( Cursor_isMacroFunctionLike, "clang_Cursor_isMacroFunctionLike", ( byval c as CXCursor ), ulong )
    FN( Cursor_isMacroBuiltin, "clang_Cursor_isMacroBuiltin", ( byval c as CXCursor ), ulong )
    FN( Cursor_Evaluate, "clang_Cursor_Evaluate", ( byval c as CXCursor ), any ptr )
    FN( EvalResult_getKind, "clang_EvalResult_getKind", ( byval e as any ptr ), long )
    FN( EvalResult_getAsLongLong, "clang_EvalResult_getAsLongLong", ( byval e as any ptr ), longint )
    FN( EvalResult_isUnsignedInt, "clang_EvalResult_isUnsignedInt", ( byval e as any ptr ), ulong )
    FN( EvalResult_getAsDouble, "clang_EvalResult_getAsDouble", ( byval e as any ptr ), double )
    FN( EvalResult_getAsStr, "clang_EvalResult_getAsStr", ( byval e as any ptr ), zstring ptr )
    SB( EvalResult_dispose, "clang_EvalResult_dispose", ( byval e as any ptr ) )
    '' ---- diagnostics (CXDiagnostic.h)
    FN( getNumDiagnostics, "clang_getNumDiagnostics", ( byval tu as any ptr ), ulong )
    FN( getDiagnostic, "clang_getDiagnostic", ( byval tu as any ptr, byval i as ulong ), any ptr )
    FN( getDiagnosticSeverity, "clang_getDiagnosticSeverity", ( byval d as any ptr ), long )
    FN( formatDiagnostic, "clang_formatDiagnostic", ( byval d as any ptr, byval options as ulong ), CXString )
    SB( disposeDiagnostic, "clang_disposeDiagnostic", ( byval d as any ptr ) )
    FN( getDiagnosticLocation, "clang_getDiagnosticLocation", ( byval d as any ptr ), CXSourceLocation )
    '' ---- files (CXFile.h) and inclusions
    SB( getInclusions, "clang_getInclusions", ( byval tu as any ptr, byval visitor as CXInclusionVisitor, byval client as any ptr ) )
    FN( getFileName, "clang_getFileName", ( byval f as any ptr ), CXString )
#endmacro

'' ---------------------------------------------------------------- the loaded library

type ClangApi
    '' Filled by ClangLoad. 'tried' makes a failure sticky: one missing libclang is one
    '' diagnostic per run, not one per #cinclude.
    as any ptr handle
    as boolean tried
    as boolean ok
    as string why              '' why it is not usable, for the diagnostic
    as string libPath          '' what was opened
    as string version          '' clang_getClangVersion's text
    as long major

    #define FN( n, cname, params, ret ) n as function cdecl params as ret
    #define SB( n, cname, params ) n as sub cdecl params
    TKO_CLANG_LIST( FN, SB )
    #undef FN
    #undef SB
end type

'' The lowest libclang this importer accepts. The API above is unchanged since well before
'' 16; the floor is where the by-value evaluation results and the macro queries it relies
'' on are known to behave -- and it is the floor tiko's LLVM backend already sets.
const CLANG_MIN_MAJOR = 16

'' Open libclang, resolve every entry point, check the layouts and the version. The first
'' call does the work and later calls return its answer. 'clangExe' is the clang tiko's
'' toolchain found (codegen/toolchain.bas FindTools), because libclang is looked for beside
'' it. False with api.why set when it cannot be used.
declare function ClangLoad( byref api as ClangApi, byref clangExe as string ) as boolean

'' A CXString's text as an FB string, and the CXString released. Every CXString this
'' importer receives goes through here, so none leaks and none is read after disposal.
declare function ClangText( byref api as ClangApi, byval s as CXString ) as string

'' clang's own header directory for this libclang -- see clang.bas. "" when not found.
declare function ClangResourceDir( byref api as ClangApi ) as string

end namespace
