'' A 'ustring * N' IS A USTRING to asc, the val family, trim, ltrim, rtrim, ucase, lcase,
'' left, right, mid, instr and instrrev -- a field and a local alike. Each was a false
'' TKO0626, "'asc' takes a string" (HANDOFF 9f), and behind the diagnostic every one of
'' them declined in lowering: a fixed ustring has no descriptor to ask for. Measured, fbc
'' passes the BUFFER AND TAGGED LENGTH where a length tag is taken --
''
''   fb_UStrAsc( LF$0, &h8000000000000005, 1 )     fb_UStrTrim( LF$0, <tag> )
''   fb_VAL( fb_UStrToStr( LF$0, <tag> ) )         fb_UStrInstr( 1, LF$0, <tag>, ... )
''
'' and copies into a temporary for left and right, which take a descriptor:
'' 'fb_UStrAssign( &TMP, -1, LF$0, <tag>, 0 ); fb_UStrLeftD( &TMP, 3 )'.
''
'' fbc prints: 49 65 32 67 / 12 34 34 / [34Cd][ 34CD][12ab][ 34][Ab][34] / 2 4
type R
    dim as ustring * 6 f
end type
dim as R r
r.f = "12Ab"
dim as ustring * 6 lf = " 34Cd"
print asc( r.f ); asc( r.f, 3 ); asc( lf ); asc( lf, 4 )
print val( r.f ); valint( lf ); vallng( lf )
print "["; trim( lf ); "]["; ucase( lf ); "]["; lcase( r.f ); "]["; left( lf, 3 ); "]["; right( r.f, 2 ); "]["; mid( lf, 2, 2 ); "]"
print instr( lf, "3" ); instrrev( lf, "C" )
