'' INSTR OVER A USTRING WITH A WIDE OPERAND converts the wide side, as fbc does:
''
''     vr$4 = fb_WstrToUStr( (uint16*)TMP$5$0 );
''     vr$6 = fb_UStrInstr( 1ll, (void*)&U$0, -1ll, (void*)vr$4, -1ll );
''
'' It was DECLINED outright -- 'if isU andalso isWide then return false' -- so a statement
'' using it vanished ('print instr( u, wchr( c ) )' printed nothing, 'dim as long k =
'' instr( ... )' left k at 0), and inside a RETURN the value was dropped from under the
'' return itself, leaving 'ret void' in a function returning BOOLEAN. clang refused that
'' in fbx's CMaskedEdit.CheckChar -- 'RETURN INSTR(m_strValid, WCHR(chChar)) <> 0' -- and
'' every MaskedEdit example failed to build. A narrow needle was right all along.
''
'' fbc prints, one per line:
''      2    2    2    2    truefalse    4    3    0
dim as ustring u = "abcb"
dim as ushort ch = asc( "b" )
dim as wstring * 4 w = "b"

print instr( u, wchr( ch ) )
print instr( u, w )
print instr( u, "b" )
dim as long k = instr( u, wchr( ch ) )
print k

function Has( byref s as ustring, byval c as ushort ) as boolean
    return instr( s, wchr( c ) ) <> 0
end function
print Has( u, ch ); Has( u, asc( "z" ) )

'' INSTRREV takes the same pair, and a START with it.
print instrrev( u, wchr( ch ) )
print instr( 3, u, w ) - 1
print instr( u, wchr( asc( "q" ) ) )
