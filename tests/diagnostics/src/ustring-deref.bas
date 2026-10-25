'' '*u' over a ustring -- DWSTRING's buffer operator in the old code -- is no dereference:
'' TKO0950 at line 6. A wstring ptr is (line 7).
sub Takes( byval p as wstring ptr )
end sub
dim as ustring u = wspace( 8 )
Takes( *u )
dim as wstring ptr wp = strptr( u )
print len( *wp )
