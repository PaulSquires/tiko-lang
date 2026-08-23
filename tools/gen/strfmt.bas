'' strfmt.bas -- print tiko-lang's float rendering for every row of a str truth file.
''
''     strfmt <truth-file>
''
'' Driven by tools/gen/check-str.py. Rows are keyed by BIT PATTERN, not by a decimal
'' literal, so this program never depends on a literal parser -- its own or fbc's --
'' and a row means exactly "given these 64 bits, tiko-lang writes this text".
''
'' Compiled against src/support/fbstr.bas directly rather than going through bin/tiko.exe:
'' the formatter has no command-line surface yet, and a gate that can only run once the
'' driver exposes one is a gate that does not run.

#include once "support/fbstr.bi"

dim as string truthPath = command( 1 )
if len( truthPath ) = 0 then
    print "strfmt: usage: strfmt <truth-file>"
    end 2
end if

dim as long fh = freefile
if open( truthPath for input as #fh ) <> 0 then
    print "strfmt: cannot open " + truthPath
    end 3
end if

dim as string ln
while eof( fh ) = 0
    line input #fh, ln
    if len( ln ) > 0 then
        dim as long t1 = instr( ln, chr(9) )
        dim as long t2 = instr( t1 + 1, ln, chr(9) )
        if (t1 > 0) andalso (t2 > 0) then
            dim as string kind = left( ln, t1 - 1 )
            dim as string bits = mid( ln, t1 + 1, t2 - t1 - 1 )
            dim as ulongint q = valulng( "&h" + bits )
            dim as string got
            if kind = "d" then
                got = Tko.Text.StrOfDouble( *cptr( double ptr, @q ) )
            else
                dim as ulong w = cast( ulong, q )
                got = Tko.Text.StrOfSingle( *cptr( single ptr, @w ) )
            end if
            print kind + chr(9) + bits + chr(9) + got
        end if
    end if
wend

close #fh
