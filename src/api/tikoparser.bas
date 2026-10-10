'' tikoparser.bas -- tikoParser.dll's entry points: tiko's front end, for an editor.
''
'' The contract is api/tikoparser.bi. This file only TRANSLATES: a host's call becomes the
'' command line a scan is ('--dump-scan', '-i' per include path, '-d' per define, the
'' file), Driver.Run fills a Tko.Scan.ScanResult instead of printing it, and the result is
'' flattened into the records and UTF-16 string pool the contract promises.
''
'' NOTHING IS KEPT BETWEEN CALLS. Each scan builds its own CompilerContext inside Run and
'' the context's destructor frees everything, so there is no global state to reset, no
'' session to leak, and nothing that lint rule 2 (no 'dim shared') has to excuse.

#import "std/containers"
#include once "api/tikoparser.bi"
#include once "driver/driver.bi"
#include once "driver/scan.bi"
#include once "support/text.bi"

type U16Vec_ as containers.Array( of ushort )

'' A host's UTF-16 string as the UTF-8 tiko reads.
private function Utf16ToUtf8_( byval w as wstring ptr ) as string
    dim as string o = ""
    if w = 0 then return o
    dim as ushort ptr p = cast( ushort ptr, w )
    dim as long i = 0
    while p[i] <> 0
        dim as ulong c = p[i]
        i += 1
        dim as boolean hiSur = (c >= &hD800) andalso (c <= &hDBFF)
        if hiSur then
            dim as ulong lo = p[i]
            if (lo >= &hDC00) andalso (lo <= &hDFFF) then
                c = &h10000 + ((c - &hD800) shl 10) + (lo - &hDC00)
                i += 1
            end if
        end if
        if c < &h80 then
            o &= chr( c )
        elseif c < &h800 then
            o &= chr( &hC0 or (c shr 6), &h80 or (c and &h3F) )
        elseif c < &h10000 then
            o &= chr( &hE0 or (c shr 12), &h80 or ((c shr 6) and &h3F), &h80 or (c and &h3F) )
        else
            o &= chr( &hF0 or (c shr 18), &h80 or ((c shr 12) and &h3F), _
                      &h80 or ((c shr 6) and &h3F), &h80 or (c and &h3F) )
        end if
    wend
    return o
end function

'' Appends a UTF-8 string to the UTF-16 pool, NUL-terminated; returns its offset. A byte
'' that does not begin a valid sequence is taken as the Latin-1 character it would be.
private function PoolAdd_( byref pool as U16Vec_, byref s as string ) as long
    dim as long at = pool.Count
    dim as long n = len( s )
    dim as long i = 0
    while i < n
        dim as ulong b = s[i]
        dim as ulong c = b
        dim as long more = 0
        if (b and &hE0) = &hC0 then
            c = b and &h1F : more = 1
        elseif (b and &hF0) = &hE0 then
            c = b and &h0F : more = 2
        elseif (b and &hF8) = &hF0 then
            c = b and &h07 : more = 3
        end if
        dim as boolean ok = (i + more) < n
        if ok andalso (more > 0) then
            for k as long = 1 to more
                if (s[i + k] and &hC0) <> &h80 then ok = false
            next
        end if
        if (more > 0) andalso ok then
            for k as long = 1 to more
                c = (c shl 6) or (s[i + k] and &h3F)
            next
            i += more + 1
        else
            c = b
            i += 1
        end if
        if c >= &h10000 then
            c -= &h10000
            pool.Push( cast( ushort, &hD800 + (c shr 10) ) )
            pool.Push( cast( ushort, &hDC00 + (c and &h3FF) ) )
        else
            pool.Push( cast( ushort, c ) )
        end if
    wend
    pool.Push( 0 )
    return at
end function

private function Marshal_( byref r as Tko.Scan.ScanResult ) as TKP_RESULT ptr
    dim as TKP_RESULT ptr res = callocate( sizeof( TKP_RESULT ) )
    res->version = TKP_VERSION
    dim as U16Vec_ pool

    res->fileCount = r.files.Count
    if res->fileCount > 0 then
        res->fileOffsets = callocate( res->fileCount * sizeof( long ) )
        for i as long = 0 to res->fileCount - 1
            '' Backslashes, as Windows spells a path: an '#include "a/b.bi"' reaches here with
            '' its slash, and the editor compares names as plain strings.
            dim as string fn = Tko.Text.UpperAscii( r.files[i] )
            #ifdef __FB_WIN32__
            for k as long = 0 to len( fn ) - 1
                if fn[k] = asc( "/" ) then fn[k] = asc( "\" )
            next
            #endif
            res->fileOffsets[i] = PoolAdd_( pool, fn )
        next
    end if

    res->symbolCount = r.syms.Count
    if res->symbolCount > 0 then
        res->symbols = callocate( res->symbolCount * sizeof( TKP_SYMBOL ) )
        for i as long = 0 to res->symbolCount - 1
            dim as Tko.Scan.ScanSym ptr s = @r.syms[i]
            dim as TKP_SYMBOL ptr d = @res->symbols[i]
            d->kind = s->kind
            d->flags = s->flags
            d->nameOffset = PoolAdd_( pool, s->name )
            d->typeOffset = -1
            if len( s->typeText ) > 0 then d->typeOffset = PoolAdd_( pool, s->typeText )
            d->parentIndex = s->parent
            d->fileIndex = s->file
            d->lineNum = s->line
            d->colNum = s->col
            d->bodyLine = s->bodyLine
            d->bodyEndLine = s->bodyEndLine
            d->readCount = s->reads
            d->writeCount = s->writes
            d->refFileIndex = s->refFile
            d->refLine = iif( s->refFile >= 0, s->refLine, 0 )
        next
    end if

    res->diagCount = r.diags.Count
    if res->diagCount > 0 then
        res->diags = callocate( res->diagCount * sizeof( TKP_DIAG ) )
        for i as long = 0 to res->diagCount - 1
            res->diags[i].errNum = r.diags[i].code
            res->diags[i].fileIndex = r.diags[i].file
            res->diags[i].lineNum = r.diags[i].line
            res->diags[i].textOffset = PoolAdd_( pool, r.diags[i].text )
        next
    end if

    res->poolChars = pool.Count
    res->stringPool = callocate( (pool.Count + 1) * sizeof( ushort ) )
    if pool.Count > 0 then memcpy( res->stringPool, @pool[0], pool.Count * sizeof( ushort ) )
    return res
end function

type ScanJob_
    as Tko.StrVec ptr args
    as Tko.Scan.ScanResult ptr r
end type

private sub ScanOnBigStack_( byval p as any ptr )
    dim as ScanJob_ ptr j = p
    Tko.Driver.Run( *j->args, 0, j->r )
end sub

private function DoScan_ _
    ( byref file as string, byval hasText as boolean, byref text as string, _
      byval options as TKP_OPTIONS ptr, byval ppResult as TKP_RESULT ptr ptr ) as long

    dim as Tko.StrVec args
    args.Push( "--dump-scan" )
    if options <> 0 then
        for i as long = 0 to options->includeCount - 1
            if options->includePaths = 0 then exit for
            if options->includePaths[i] = 0 then continue for
            args.Push( "-i" )
            args.Push( Utf16ToUtf8_( options->includePaths[i] ) )
        next
        '' THE PACKAGE TREE: in a DLL, tiko's own fallback -- beside the executable -- is the
        '' editor's folder, where no pkg/ is.
        if options->pkgDir <> 0 then
            if len( *options->pkgDir ) > 0 then
                args.Push( "--pkg-dir" )
                args.Push( Utf16ToUtf8_( options->pkgDir ) )
            end if
        end if
        for i as long = 0 to options->defineCount - 1
            if options->defines = 0 then exit for
            if options->defines[i] = 0 then continue for
            args.Push( "-d" )
            args.Push( Utf16ToUtf8_( options->defines[i] ) )
        next
    end if
    args.Push( file )

    dim as Tko.Scan.ScanResult r
    r.hasRootText = hasText
    r.rootText = text
    '' ON A 64 MB STACK OF ITS OWN, not the editor's: the scan recurses over the tree, and
    '' 250 nested IFs overflowed the host thread's stack and killed the EDITOR (F-53).
    dim as ScanJob_ job
    job.args = @args
    job.r = @r
    dim as any ptr th = threadcreate( @ScanOnBigStack_, @job, 64 * 1024 * 1024 )
    if th = 0 then
        Tko.Driver.Run( args, 0, @r )
    else
        threadwait( th )
    end if
    *ppResult = Marshal_( r )
    return TKP_OK
end function

function tikoparser_version alias "TIKOPARSER_VERSION" ( ) as long export
    return TKP_VERSION
end function

function tikoparser_scan alias "TIKOPARSER_SCAN" _
    ( byval wszFile as wstring ptr, byval options as TKP_OPTIONS ptr, _
      byval ppResult as TKP_RESULT ptr ptr ) as long export

    if ppResult = 0 then return TKP_E_BADARGS
    *ppResult = 0
    if options <> 0 then
        if options->version <> TKP_VERSION then return TKP_E_VERSION
    end if
    dim as string f = Utf16ToUtf8_( wszFile )
    if len( f ) = 0 then return TKP_E_BADARGS
    return DoScan_( f, false, "", options, ppResult )
end function

function tikoparser_scan_text alias "TIKOPARSER_SCAN_TEXT" _
    ( byval pszText as zstring ptr, byval wszName as wstring ptr, _
      byval options as TKP_OPTIONS ptr, byval ppResult as TKP_RESULT ptr ptr ) as long export

    if ppResult = 0 then return TKP_E_BADARGS
    *ppResult = 0
    if pszText = 0 then return TKP_E_BADARGS
    if options <> 0 then
        if options->version <> TKP_VERSION then return TKP_E_VERSION
    end if
    dim as string f = Utf16ToUtf8_( wszName )
    if len( f ) = 0 then f = "unnamed.tiko"
    dim as string text = *pszText
    return DoScan_( f, true, text, options, ppResult )
end function

sub tikoparser_free alias "TIKOPARSER_FREE" ( byval pResult as TKP_RESULT ptr ) export
    if pResult = 0 then return
    if pResult->symbols then deallocate( pResult->symbols )
    if pResult->fileOffsets then deallocate( pResult->fileOffsets )
    if pResult->diags then deallocate( pResult->diags )
    if pResult->stringPool then deallocate( pResult->stringPool )
    deallocate( pResult )
end sub
