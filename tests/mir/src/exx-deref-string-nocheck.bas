'' -exx: A DEREF WHOSE POINTEE IS A STRING IS NOT CHECKED FOR NULL.
''
'' fbc checks where the generated code LOADS OR STORES through the pointer. A
'' 'zstring ptr' or 'wstring ptr' deref mostly does neither -- the pointer itself is
'' what the runtime entry point is given. Measured, one probe, '-exx -r':
''
''     n = len( *pw )   fb_WstrLen( PW$0 )                  not checked
''     w = *pw          fb_WstrAssign( W$0, 8, PW$0 )       not checked
''     s = *pz          fb_StrAssign( &S$0, -1, PZ$0, 0 )   not checked
''     n = len( *pz )   fb_StrLen( PZ$0, 0 )                not checked
''     takesW( *pw )    the ADDRESS is the argument         not checked
''
'' tiko checked every one of them, so AfxNova's
''
''     function DWSTRING.Add( byval pwszStr as wstring ptr ) as boolean
''         return this.AppendBuffer( pwszStr, len( *pwszStr ) )
''
'' aborted with runtime error 7 on the NULL that 'mid( s, len( s ) + 1 )' hands back by
'' design. Both runtimes return NULL there -- measured side by side, fb_WstrMid, same
'' answer -- so only the check differed, and tiko-editor could not be built with -exx at
'' all. That is the one tool that finds a wild write.
sub takesW( byref ww as wstring ) : end sub

dim as wstring * 16 wbuf = "wide"
dim as zstring * 16 zbuf = "narrow"
dim as wstring ptr pw = @wbuf
dim as zstring ptr pz = @zbuf
dim as long n
dim as string s
dim as wstring * 16 w

n = len( *pw )
w = *pw
s = *pz
n += len( *pz )
takesW( *pw )
print n; " ["; s; "] ["; w; "]"
