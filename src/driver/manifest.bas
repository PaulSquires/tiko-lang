'' manifest.bas -- a package's tiko.toml (ADR 0017; RFC-0007 §2).
''
'' A TOML SUBSET, read line by line: '#' comments, '[table]' and '[a.b.c]' headers, bare and
'' quoted keys, basic strings with \\ \" \n \t \uXXXX, literal strings, integers, booleans,
'' inline tables and single-line arrays of strings. Anything else -- a multi-line string, a
'' float, a date, an array of tables -- is TKO0144 with the line, and so is a key or table
'' the manifest does not have. What is read:
''
''     [package]                  name (required); version, description, license, authors,
''                                repository accepted and unused (v2's)
''     [dependencies]             x = { path = "..." }, or a [dependencies.x] table
''     [defines]                  NAME = "value": the package's modules see NAME
''     [dependencies.x.defines]   the root's say over dependency x's defines

#import "std/containers"
#import "std/fs"
#include once "driver/manifest.bi"
#include once "driver/modresolve.bi"
#include once "support/diskcache.bi"
#include once "support/text.bi"

namespace Tko.Modules

function HasManifest( byref dir_ as string ) as boolean
    return fs.IsFile( JoinPath( dir_, "tiko.toml" ) )
end function

type TomlCursor_
    as string  s
    as long    p             '' 1-based
    as string  err_
end type

private sub Ws_( byref c as TomlCursor_ )
    while c.p <= len( c.s )
        dim as ubyte ch = c.s[c.p - 1]
        if (ch <> 32) andalso (ch <> 9) then exit while
        c.p += 1
    wend
end sub

private function AtEnd_( byref c as TomlCursor_ ) as boolean
    Ws_( c )
    if c.p > len( c.s ) then return true
    return c.s[c.p - 1] = asc( "#" )
end function

'' A key: bare [A-Za-z0-9_-]+, or a quoted string.
private function Key_( byref c as TomlCursor_, byref k as string ) as boolean
    Ws_( c )
    if c.p > len( c.s ) then return false
    dim as ubyte ch = c.s[c.p - 1]
    if (ch = 34) orelse (ch = 39) then
        dim as long q = instr( c.p + 1, c.s, chr( ch ) )
        if q = 0 then
            c.err_ = "unterminated quoted key"
            return false
        end if
        k = mid( c.s, c.p + 1, q - c.p - 1 )
        c.p = q + 1
        return true
    end if
    dim as long st = c.p
    while c.p <= len( c.s )
        ch = c.s[c.p - 1]
        dim as boolean ok = ((ch >= 48) andalso (ch <= 57)) orelse ((ch >= 65) andalso (ch <= 90)) orelse _
                            ((ch >= 97) andalso (ch <= 122)) orelse (ch = 95) orelse (ch = 45)
        if ok = false then exit while
        c.p += 1
    wend
    if c.p = st then
        c.err_ = "expected a key"
        return false
    end if
    k = mid( c.s, st, c.p - st )
    return true
end function

'' A value, as its text: a string's contents, an integer or a boolean spelled as written.
'' kind: "s" string, "i" integer, "b" boolean, "t" inline table (text between the braces),
'' "a" array (the strings, chr(10)-separated).
private function Value_( byref c as TomlCursor_, byref v as string, byref kind as string ) as boolean
    Ws_( c )
    if c.p > len( c.s ) then
        c.err_ = "expected a value"
        return false
    end if
    dim as ubyte ch = c.s[c.p - 1]
    if ch = 34 then
        if mid( c.s, c.p, 3 ) = chr( 34, 34, 34 ) then
            c.err_ = "multi-line strings are not in the subset tiko reads"
            return false
        end if
        v = ""
        c.p += 1
        while c.p <= len( c.s )
            ch = c.s[c.p - 1]
            if ch = 34 then
                c.p += 1
                kind = "s"
                return true
            end if
            if ch = 92 then
                c.p += 1
                if c.p > len( c.s ) then exit while
                dim as ubyte e = c.s[c.p - 1]
                select case e
                case 92 : v &= chr( 92 )
                case 34 : v &= chr( 34 )
                case asc( "n" ) : v &= chr( 10 )
                case asc( "t" ) : v &= chr( 9 )
                case asc( "u" )
                    dim as long cp = valint( "&h" & mid( c.s, c.p + 1, 4 ) )
                    if cp < 128 then v &= chr( cp ) else v &= "?"
                    c.p += 4
                case else
                    c.err_ = "unknown escape in a string"
                    return false
                end select
                c.p += 1
                continue while
            end if
            v &= chr( ch )
            c.p += 1
        wend
        c.err_ = "unterminated string"
        return false
    end if
    if ch = 39 then
        dim as long q = instr( c.p + 1, c.s, "'" )
        if q = 0 then
            c.err_ = "unterminated string"
            return false
        end if
        v = mid( c.s, c.p + 1, q - c.p - 1 )
        c.p = q + 1
        kind = "s"
        return true
    end if
    if ch = asc( "{" ) then
        dim as long q = instr( c.p, c.s, "}" )
        if q = 0 then
            c.err_ = "unterminated inline table"
            return false
        end if
        v = mid( c.s, c.p + 1, q - c.p - 1 )
        c.p = q + 1
        kind = "t"
        return true
    end if
    if ch = asc( "[" ) then
        dim as TomlCursor_ a
        a.s = mid( c.s, c.p + 1 )
        a.p = 1
        v = ""
        dim as long n = 0
        do
            Ws_( a )
            if a.p > len( a.s ) then
                c.err_ = "unterminated array (arrays are single-line)"
                return false
            end if
            if a.s[a.p - 1] = asc( "]" ) then exit do
            dim as string one_, k2
            if Value_( a, one_, k2 ) = false then
                c.err_ = a.err_
                return false
            end if
            if k2 <> "s" then
                c.err_ = "only arrays of strings are in the subset tiko reads"
                return false
            end if
            v &= iif( n > 0, chr( 10 ), "" ) & one_
            n += 1
            Ws_( a )
            if (a.p <= len( a.s )) andalso (a.s[a.p - 1] = asc( "," )) then a.p += 1
        loop
        c.p += a.p
        kind = "a"
        return true
    end if
    dim as long st = c.p
    while c.p <= len( c.s )
        ch = c.s[c.p - 1]
        if (ch = 32) orelse (ch = 9) orelse (ch = asc( "," )) orelse (ch = asc( "}" )) orelse (ch = asc( "#" )) then exit while
        c.p += 1
    wend
    v = mid( c.s, st, c.p - st )
    if (v = "true") orelse (v = "false") then
        kind = "b"
        return true
    end if
    dim as boolean digits = (len( v ) > 0)
    for i as long = 0 to len( v ) - 1
        dim as ubyte d = v[i]
        dim as boolean ok = ((d >= 48) andalso (d <= 57)) orelse ((i = 0) andalso ((d = 43) orelse (d = 45))) orelse (d = 95)
        if ok = false then digits = false
    next
    if digits then
        kind = "i"
        return true
    end if
    c.err_ = "'" & v & "' is not a value tiko reads (floats and dates are not in the subset)"
    return false
end function

'' { path = "../x" }: the path, or "" with the reason in err_.
private function InlinePath_( byref inner as string, byref err_ as string ) as string
    dim as TomlCursor_ c
    c.s = inner
    c.p = 1
    dim as string path_ = ""
    do
        Ws_( c )
        if c.p > len( c.s ) then exit do
        dim as string k, v, kind
        if Key_( c, k ) = false then
            err_ = c.err_
            return ""
        end if
        Ws_( c )
        if (c.p > len( c.s )) orelse (c.s[c.p - 1] <> asc( "=" )) then
            err_ = "expected '=' after '" & k & "'"
            return ""
        end if
        c.p += 1
        if Value_( c, v, kind ) = false then
            err_ = c.err_
            return ""
        end if
        if k = "path" then
            if kind <> "s" then
                err_ = "a dependency's path is a string"
                return ""
            end if
            path_ = v
        elseif k <> "version" then
            err_ = "a dependency takes 'path' in v1, not '" & k & "'"
            return ""
        end if
        Ws_( c )
        if (c.p <= len( c.s )) andalso (c.s[c.p - 1] = asc( "," )) then c.p += 1
    loop
    if len( path_ ) = 0 then err_ = "a dependency needs 'path' in v1"
    return path_
end function

function LoadManifest _
    ( byref ctx as Tko.CompilerContext, byref dir_ as string, byref m as Manifest ) as boolean

    dim as string file_ = JoinPath( dir_, "tiko.toml" )
    dim as string text_
    if Tko.DiskCache.ReadAll( file_, text_ ) = false then return false
    m.dir_ = NormPath( dir_ )
    m.name = ""
    dim as string table_ = ""
    dim as long lineNo = 0
    dim as long p = 1
    dim as boolean ok = true
    while p <= len( text_ )
        dim as long e = instr( p, text_, chr( 10 ) )
        if e = 0 then e = len( text_ ) + 1
        dim as string ln = mid( text_, p, e - p )
        p = e + 1
        lineNo += 1
        if right( ln, 1 ) = chr( 13 ) then ln = left( ln, len( ln ) - 1 )
        dim as TomlCursor_ c
        c.s = ln
        c.p = 1
        if AtEnd_( c ) then continue while
        dim as string why = ""
        if c.s[c.p - 1] = asc( "[" ) then
            if mid( c.s, c.p, 2 ) = "[[" then
                why = "arrays of tables are not in the subset tiko reads"
            else
                dim as long q = instr( c.p, c.s, "]" )
                if q = 0 then
                    why = "unterminated table header"
                else
                    table_ = Tko.Text.LowerAscii( trim( mid( c.s, c.p + 1, q - c.p - 1 ) ) )
                    c.p = q + 1
                    if AtEnd_( c ) = false then why = "text after a table header"
                    dim as boolean known = (table_ = "package") orelse (table_ = "dependencies") orelse (table_ = "defines")
                    if known = false then
                        dim as boolean depT = (left( table_, 13 ) = "dependencies.")
                        if depT = false then why = "unknown table [" & table_ & "]"
                    end if
                end if
            end if
        else
            dim as string k, v, kind
            if Key_( c, k ) = false then
                why = c.err_
            else
                Ws_( c )
                if (c.p > len( c.s )) orelse (c.s[c.p - 1] <> asc( "=" )) then
                    why = "expected '=' after '" & k & "'"
                else
                    c.p += 1
                    if Value_( c, v, kind ) = false then
                        why = c.err_
                    elseif AtEnd_( c ) = false then
                        why = "text after the value of '" & k & "'"
                    end if
                end if
            end if
            if len( why ) = 0 then
                select case table_
                case "package"
                    select case k
                    case "name"
                        if kind <> "s" then why = "[package] name is a string" else m.name = Tko.Text.LowerAscii( v )
                    case "version", "description", "license", "authors", "repository"
                    case else
                        why = "unknown key '" & k & "' in [package]"
                    end select
                case "dependencies"
                    if kind <> "t" then
                        why = "a dependency is an inline table: " & k & " = { path = ""..."" }"
                    else
                        dim as string pth = InlinePath_( v, why )
                        if len( why ) = 0 then
                            m.depNames.Push( Tko.Text.LowerAscii( k ) )
                            m.depPaths.Push( JoinPath( m.dir_, pth ) )
                        end if
                    end if
                case "defines"
                    if kind <> "s" then why = "a define's value is a string" else m.defines.Push( k & "=" & v )
                case else
                    '' [dependencies.x] or [dependencies.x.defines]
                    dim as string rest = mid( table_, 14 )
                    dim as long dt = instr( rest, "." )
                    if dt = 0 then
                        if k <> "path" then
                            why = "a dependency takes 'path' in v1, not '" & k & "'"
                        elseif kind <> "s" then
                            why = "a dependency's path is a string"
                        else
                            m.depNames.Push( rest )
                            m.depPaths.Push( JoinPath( m.dir_, v ) )
                        end if
                    elseif mid( rest, dt + 1 ) = "defines" then
                        if kind <> "s" then
                            why = "a define's value is a string"
                        else
                            m.ddDep.Push( left( rest, dt - 1 ) )
                            m.ddDefine.Push( k & "=" & v )
                        end if
                    else
                        why = "unknown table [" & table_ & "]"
                    end if
                end select
                if len( table_ ) = 0 then why = "'" & k & "' is outside any table"
            end if
        end if
        if len( why ) > 0 then
            ctx.diags.ReportGlobal( Tko.TKO0144, file_ & "(" & lineNo & "): " & why )
            ok = false
        end if
    wend
    if ok andalso (len( m.name ) = 0) then
        ctx.diags.ReportGlobal( Tko.TKO0144, file_ & ": [package] name is required" )
        ok = false
    end if
    return ok
end function

end namespace
