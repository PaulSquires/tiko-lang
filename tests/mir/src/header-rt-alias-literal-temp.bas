'' A LITERAL FOR A 'byref as const string' PARAMETER OF A HEADER-DECLARED RUNTIME PROCEDURE
'' is a real temporary, deleted after the call -- not a pool descriptor.
''
'' fbc hands a pool descriptor (fb_StrAllocTempDescZEx) only to its OWN runtime
'' procedures, which release it. A header's declaration is an ordinary procedure to fbc
'' whatever its alias says. Measured, for fb/string.bi's 'IsNumeric( "42" )':
''
''     fb_StrAssign( (void*)&TMP$113$0, -1ll, (void*)"42", 3ll, 0 );
''     boolean vr$3 = fb_StrIsNumeric( (FBSTRING*)&TMP$113$0 );
''     fb_StrDelete( (FBSTRING*)&TMP$113$0 );
''
'' tiko decided by the ALIAS alone and passed the pool descriptor, which the callee never
'' released: one slot per call, and after 255 of them every temporary string in the
'' program came back empty. fbstr_pad's leak test failed, and each later test with it.
''
'' fbc prints, one per line:
''     20000   ok
extern "C"
declare function IsNum alias "fb_StrIsNumeric" ( byref s as const string ) as boolean
end extern

dim as long hits = 0
for i as long = 1 to 20000
    if IsNum( "42" ) then hits += 1
next
print hits
'' A pool that had run dry would give an empty string here.
dim as string t = "o" & "k"
print t
