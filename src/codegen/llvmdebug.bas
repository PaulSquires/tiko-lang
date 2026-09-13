'' llvmdebug.bas -- see the header.

#include once "codegen/llvmdebug.bi"

namespace Tko.Codegen

'' A METADATA STRING. Printable ASCII is itself; the quote, the backslash and every other
'' byte are '\XX'. A Windows path is nothing but backslashes, and one written raw is an
'' escape LLVM reads as two hex digits.
private function MetaStr_( byref s as string ) as string
    dim as string r = chr( 34 )
    for i as long = 0 to len( s ) - 1
        dim as ubyte ch = s[i]
        if (ch < 32) orelse (ch > 126) orelse (ch = 34) orelse (ch = 92) then
            r += chr( 92 ) & hex( ch, 2 )
        else
            r += chr( ch )
        end if
    next
    return r & chr( 34 )
end function

private function NewNode_( byref d as DebugInfo, byref body as string ) as long
    dim as long id = d.nextId
    d.nextId += 1
    d.nodes += "!" & str( id ) & " = " & body & chr( 10 )
    return id
end function

'' DIFile wants the name and the directory apart; both separators are split on, since a
'' path from the command line may use either on Windows.
private function FileNode_( byref d as DebugInfo, byref path as string ) as long
    dim as long cut_ = 0
    for i as long = len( path ) to 1 step -1
        dim as string ch = mid( path, i, 1 )
        if (ch = "/") orelse (ch = chr( 92 )) then
            cut_ = i
            exit for
        end if
    next
    dim as string dir_ = left( path, iif( cut_ > 1, cut_ - 1, cut_ ) )
    dim as string fname = mid( path, cut_ + 1 )
    return NewNode_( d, "!DIFile(filename: " & MetaStr_( fname ) & _
                        ", directory: " & MetaStr_( dir_ ) & ")" )
end function

sub DbgBegin _
    ( byref d as DebugInfo, byval sm as Tko.SourceManager ptr, byref mainPath as string )

    d.sm = sm
    d.nextId = 0
    d.nodes = ""
    d.fileMeta.Clear( )
    d.curSp = -1
    d.mainFileId = FileNode_( d, mainPath )
    '' C99, because FreeBASIC has no DWARF language code and a debugger then evaluates
    '' expressions the way it would for the C that fbc's own gcc backend emits.
    d.cuId = NewNode_( d, "distinct !DICompileUnit(language: DW_LANG_C99, file: !" & _
                          str( d.mainFileId ) & ", producer: ""tiko-lang"", " & _
                          "isOptimized: false, runtimeVersion: 0, " & _
                          "emissionKind: LineTablesOnly)" )
    d.typeId = NewNode_( d, "!DISubroutineType(types: !{null})" )
end sub

function DbgSubprogram _
    ( byref d as DebugInfo, byref linkName as string, byval fileKey as ulong, _
      byval lineNo as long ) as long

    dim as long fm = d.mainFileId
    if (fileKey > 0) andalso (d.sm <> 0) then
        while d.fileMeta.Count <= cast( long, fileKey )
            d.fileMeta.Push( 0 )
        wend
        if d.fileMeta[fileKey] = 0 then
            d.fileMeta[fileKey] = FileNode_( d, d.sm->PathOf( fileKey - 1 ) )
        end if
        fm = d.fileMeta[fileKey]
    end if
    dim as long ln = lineNo
    if ln < 0 then ln = 0
    d.curSp = NewNode_( d, "distinct !DISubprogram(name: " & MetaStr_( linkName ) & _
                           ", linkageName: " & MetaStr_( linkName ) & _
                           ", scope: !" & str( fm ) & ", file: !" & str( fm ) & _
                           ", line: " & str( ln ) & ", type: !" & str( d.typeId ) & _
                           ", scopeLine: " & str( ln ) & _
                           ", spFlags: DISPFlagDefinition, unit: !" & str( d.cuId ) & ")" )
    d.locLine = -1
    d.locId = 0
    return d.curSp
end function

'' ONE NODE PER RUN OF A LINE, not per instruction: consecutive instructions share the
'' statement they came from, and a revisited line simply gets another node, which LLVM
'' accepts.
function DbgLocSuffix( byref d as DebugInfo, byval lineNo as long ) as string
    if d.curSp < 0 then return ""
    dim as long ln = lineNo
    if ln < 0 then ln = 0
    if ln <> d.locLine then
        d.locId = NewNode_( d, "!DILocation(line: " & str( ln ) & ", scope: !" & _
                               str( d.curSp ) & ")" )
        d.locLine = ln
    end if
    return ", !dbg !" & str( d.locId )
end function

function DbgFinish( byref d as DebugInfo ) as string
    dim as long fv = NewNode_( d, "!{i32 2, !""Debug Info Version"", i32 3}" )
    dim as long dv = NewNode_( d, "!{i32 7, !""Dwarf Version"", i32 4}" )
    return chr( 10 ) & "!llvm.dbg.cu = !{!" & str( d.cuId ) & "}" & chr( 10 ) & _
           "!llvm.module.flags = !{!" & str( fv ) & ", !" & str( dv ) & "}" & chr( 10 ) & _
           d.nodes
end function

end namespace
