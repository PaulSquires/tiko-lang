'' ppforeignlib.bas -- resolving a '#foreignlib' spec to a library file.
''
'' Included from directive.bas, above PpInclude. Split out at the 1500-line lint cap.

'' '#foreignlib' (fbc-modern RFC-0005). The rules below are fbc's, read from
'' fbForeignLibResolve and then checked against its own error tests:
''
''     #foreignlib ID (STATIC|DYNAMIC) "spec" (, "spec")*
''
' A spec of "system:name" is handed to the linker as a bare name and resolved no
'' further. Anything else is a BASE NAME made absolute against the directory of the
'' source that wrote it, then probed -- most specific variant first:
''
''     stem_<os>_<arch>   stem_<os>   stem_<arch>   stem
''
'' with the extensions the kind and target allow. An axis with no tag drops the
'' variants that would need it rather than inventing a spelling.
private function ForeignLibOsTag_( byref e as PpEngine ) as string
    if e.cfg->targetIsWindows then return "windows"
    return "linux"
end function

'' x86-64 IS THE ONLY ARCHITECTURE (D14), so this is not a choice today. It stays a
'' function because the variant list is built around an axis that CAN be empty, and
'' an ARM64 target would fill this in rather than rewrite the loop.
private function ForeignLibArchTag_( byref e as PpEngine ) as string
    if e.cfg->targetIs64 then return "x86_64"
    return "x86"
end function

'' STATIC prefers an archive, DYNAMIC an import library. Windows gets '.lib' in
'' both: it is the MSVC spelling of each.
private sub ForeignLibExts_ _
    ( byref e as PpEngine, byval isStatic as boolean, byref outp as StrVec )
    if isStatic then
        outp.Push( ".a" )
        if e.cfg->targetIsWindows then outp.Push( ".lib" )
    else
        if e.cfg->targetIsWindows then
            outp.Push( ".dll.a" )
            outp.Push( ".lib" )
            outp.Push( ".dll" )
        else
            outp.Push( ".so" )
        end if
    end if
end sub

'' One spec to a file on disk, or "" if nothing matched. 'tried' collects every
'' candidate so the diagnostic can list them -- fbc's does, and a probe that fails
'' silently on four variants times three extensions is a bad afternoon.
private function ForeignLibResolve_ _
    ( byref e as PpEngine, byval at as SourceLoc, byref spec as string, _
      byval isStatic as boolean, byref tried as string ) as string

    tried = ""

    '' 'system:name' resolves nothing -- the linker is expected to know it.
    if lcase( left( spec, 7 ) ) = "system:" then
        return mid( spec, 8 )
    end if

    '' SOURCE-RELATIVE, not relative to the working directory: a binding written in
    '' a header must find the library sitting beside that header whoever includes it.
    dim as string base_ = spec
    for i as long = 1 to len( base_ )
        if mid( base_, i, 1 ) = "\" then mid( base_, i, 1 ) = "/"
    next
    dim as boolean absolute_ = false
    if instr( base_, ":" ) > 0 then absolute_ = true
    if left( base_, 1 ) = "/" then absolute_ = true
    if absolute_ = false then
        '' The PHYSICAL file, unlike '#include' above: '#foreignlib' is tiko's own
        '' (RFC-0005) and probes for binaries that ship beside the real source, where
        '' a '#line' name is a fiction about text rather than a place on disk.
        dim as DecodedLoc d = e.src->Decode( at )
        dim as string here = e.src->PathOf( d.file )
        dim as string dir_ = ""
        for i as long = len( here ) to 1 step -1
            dim as ubyte c = here[i - 1]
            if (c = 47) orelse (c = 92) then
                dir_ = left( here, i )
                exit for
            end if
        next
        base_ = dir_ & base_
    end if

    dim as string dirPart = ""
    dim as string stem = base_
    for i as long = len( base_ ) to 1 step -1
        dim as ubyte c = base_[i - 1]
        if (c = 47) orelse (c = 92) then
            dirPart = left( base_, i )
            stem = mid( base_, i + 1 )
            exit for
        end if
    next
    if len( stem ) = 0 then return ""

    dim as string os_ = ForeignLibOsTag_( e )
    dim as string arch = ForeignLibArchTag_( e )

    dim as StrVec variants
    if (len( os_ ) > 0) andalso (len( arch ) > 0) then variants.Push( stem & "_" & os_ & "_" & arch )
    if len( os_ ) > 0 then variants.Push( stem & "_" & os_ )
    if len( arch ) > 0 then variants.Push( stem & "_" & arch )
    variants.Push( stem )

    dim as StrVec exts
    ForeignLibExts_( e, isStatic, exts )

    for v as long = 0 to variants.Count - 1
        for x as long = 0 to exts.Count - 1
            dim as string cand = dirPart & variants[v] & exts[x]
            dim as long fh = freefile
            if open( cand for input as #fh ) = 0 then
                close #fh
                return cand
            end if
            tried += "    " & cand & chr( 10 )
        next
    next
    return ""
end function
