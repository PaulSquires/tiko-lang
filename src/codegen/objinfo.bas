'' objinfo.bas -- the '.fbctinf' section, written and read. See objinfo.bi.

#include once "codegen/objinfo.bi"

namespace Tko.Codegen

'' Every byte that is not plainly printable is escaped, as CString in llvmemit.bas does.
private function IrBytes_( byref b as string ) as string
    dim as string r = "c"""
    for i as long = 0 to len( b ) - 1
        dim as long ch = b[i]
        dim as boolean plain = (ch >= 32) andalso (ch <= 126)
        if (ch = 34) orelse (ch = 92) then plain = false
        if plain then
            r += chr( ch )
        else
            r += "\" & hex( ch, 2 )
        end if
    next
    return r & """"
end function

private sub AddEntries_( byref blob as string, byval flag as string, byref v as StrVec )
    for i as long = 0 to v.Count - 1
        blob += flag & chr( 0 ) & v[i] & chr( 0 )
    next
end sub

'' fbc's shape: an internal constant in the section, kept alive by llvm.compiler.used so
'' the optimiser does not drop a global nothing references.
function ObjInfoIr _
    ( byref libs as StrVec, byref pragmaLibs as StrVec, _
      byref libPaths as StrVec, byref pragmaLibPaths as StrVec, _
      byval threadSafe as boolean ) as string

    dim as string blob
    AddEntries_( blob, "-l", libs )
    AddEntries_( blob, "-l", pragmaLibs )
    AddEntries_( blob, "-p", libPaths )
    AddEntries_( blob, "-p", pragmaLibPaths )
    if threadSafe then blob += "-mt" & chr( 0 )
    if len( blob ) = 0 then return ""
    return chr( 10 ) & "@__fbctinf = internal constant [" & str( len( blob ) ) & " x i8] " & _
           IrBytes_( blob ) & ", section "".fbctinf""" & chr( 10 ) & _
           "@llvm.compiler.used = appending global [1 x ptr] [ptr @__fbctinf], " & _
           "section ""llvm.metadata""" & chr( 10 )
end function

private function U16_( byref b as string, byval at_ as longint ) as longint
    if (at_ < 0) orelse (at_ + 2 > len( b )) then return 0
    return b[at_] or (clngint( b[at_ + 1] ) shl 8)
end function

private function U32_( byref b as string, byval at_ as longint ) as longint
    if (at_ < 0) orelse (at_ + 4 > len( b )) then return 0
    return b[at_] or (clngint( b[at_ + 1] ) shl 8) or _
           (clngint( b[at_ + 2] ) shl 16) or (clngint( b[at_ + 3] ) shl 24)
end function

private function SliceOf_( byref b as string, byval off as longint, byval n as longint ) as string
    if (off < 0) orelse (n <= 0) orelse (off + n > len( b )) then return ""
    return mid( b, off + 1, n )
end function

'' The section's bytes in an x86-64 ELF64 or COFF object, or "" when it has none. The two
'' formats tiko targets; anything else answers "" rather than guessing.
private function SectionBytes_( byref b as string ) as string
    dim as longint sz = len( b )
    if sz < 64 then return ""
    if (b[0] = &h7F) andalso (b[1] = &h45) andalso (b[2] = &h4C) andalso (b[3] = &h46) then
        if b[4] <> 2 then return ""
        dim as longint shoff = U32_( b, &h28 ) or (U32_( b, &h2C ) shl 32)
        dim as longint shnum = U16_( b, &h3C )
        dim as longint strndx = U16_( b, &h3E )
        if (U16_( b, &h3A ) <> 64) orelse (strndx >= shnum) then return ""
        dim as longint names_ = U32_( b, shoff + strndx * 64 + &h18 )
        for i as longint = 1 to shnum - 1
            dim as longint h = shoff + i * 64
            dim as longint nm = names_ + U32_( b, h )
            if (nm + 9 <= sz) andalso (mid( b, nm + 1, 8 ) = ".fbctinf") andalso (b[nm + 8] = 0) then
                return SliceOf_( b, U32_( b, h + &h18 ), U32_( b, h + &h20 ) )
            end if
        next
        return ""
    end if
    if U16_( b, 0 ) <> &h8664 then return ""
    if U16_( b, 16 ) <> 0 then return ""
    for i as longint = 0 to U16_( b, 2 ) - 1
        dim as longint h = 20 + i * 40
        if mid( b, h + 1, 8 ) = ".fbctinf" then
            return SliceOf_( b, U32_( b, h + 20 ), U32_( b, h + 16 ) )
        end if
    next
    return ""
end function

sub ReadObjInfo _
    ( byref path as string, byref libs as StrVec, _
      byref libPaths as StrVec, byref threadSafe as boolean )

    dim as long fh = freefile
    if open( path for binary access read as #fh ) <> 0 then return
    dim as string b
    if lof( fh ) > 0 then
        b = space( lof( fh ) )
        get #fh, , b
    end if
    close #fh

    '' A first byte of &h10 is the pre-0.25 format, which nothing tiko links can carry.
    dim as string s = SectionBytes_( b )
    if (len( s ) = 0) orelse (s[0] = &h10) then return
    dim as string pending
    dim as longint at_ = 1
    while at_ <= len( s )
        dim as longint z = instr( at_, s, chr( 0 ) )
        if z = 0 then z = len( s ) + 1
        dim as string w = mid( s, at_, z - at_ )
        at_ = z + 1
        if pending = "-l" then
            if len( w ) > 0 then libs.Push( w )
            pending = ""
        elseif pending = "-p" then
            if len( w ) > 0 then libPaths.Push( w )
            pending = ""
        elseif (w = "-l") orelse (w = "-p") then
            pending = w
        elseif w = "-mt" then
            threadSafe = true
        end if
    wend
end sub

end namespace
