'' A WIDE TEMPORARY MADE BY AN 'elseif' CONDITION IS RELEASED ON THAT ARM'S PATH.
''
'' The temporaries a condition makes were left on the statement's list, and LowerStmt
'' releases that list at the END of the statement -- which, for an IF, is the JOIN
'' BLOCK, the one block every arm reaches. An elseif's condition is evaluated only when
'' the arms before it failed, so the join then freed a temporary that path never made:
''
''     if.else7:   %31 = fb_WstrLeft( .. )   store @$tmp6, %31
''     if.then6:   store @okind, 1           br if.join5
''     if.join5:   %38 = load @$tmp6         fb_WstrDelete( %38 )
''
'' -- uninitialised on the first pass and an ALREADY-FREED pointer on every one after
'' it. Over an AfxNova DWSTRING that corrupted the heap within a dozen iterations, and
'' tiko-editor died at 0xC0000374 classifying the first line of its own settings file:
''
''     if len(wl) = 0 then ... elseif left(wl,1) = "'" then ... elseif left(wl,1) = "["
''
'' The UDT mark was already taken per-condition; the string and wide ones were not.
''
'' Measured, fbc destroys the condition's temporary immediately after the compare that
'' used it, inside the arm, never at the join.
type WU
    as wstring * 32 w
    declare constructor( )
    declare constructor( byref s as const wstring )
    declare destructor( )
    declare operator cast( ) byref as const wstring
end type
constructor WU( ) : w = "" : end constructor
constructor WU( byref s as const wstring ) : w = s : end constructor
destructor WU( ) : end destructor
operator WU.cast( ) byref as const wstring : return w : end operator

dim as WU wl = wstr( "a match" )
dim as long oKind

'' THE FIRST ARM MATCHES, so the second condition never runs and its temporary is never
'' made. Two hundred passes, because a double free shows up as corruption rather than
'' as a wrong answer -- one pass would print the right number either way.
for i as long = 1 to 200
    if left( wl, 1 ) = wstr( "a" ) then
        oKind = 1
    elseif left( wl, 2 ) = wstr( "b2" ) then
        oKind = 2
    end if
next
print "kind="; oKind
