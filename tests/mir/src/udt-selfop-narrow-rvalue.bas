'' '+=' AND '&=' ONTO A UDT WITH A NARROW RVALUE. AfxNova's DWSTRING is the case: tracks writes
'' 'error_message += "- Missing Ticker Symbol." & vbcrlf' and AfxNova's CTextStream
'' 'dws += ": File not found"', and every one was DROPPED -- the value has no address for the
'' 'byref as string' parameter, and a concatenation has no type to score. A string VARIABLE,
'' a wide value and a number already lowered.
''
'' Measured, fbc-modern copies each rvalue into a temporary and calls the string member:
''
''     fb_StrAssign( &TMP, -1, "lit", 4, 0 );  _ZN2DSpLER8FBSTRING( &D, &TMP );  fb_StrDelete( &TMP )
''
'' and prints '[lit', '[a2', '["', '[   ]', '[&amp', '[sp', '[W', '[1.5', 'field!' and 'global'.
'' DS copies DWSTRING's overload set: a wstring pointer, a byref string, a longint and a double.
type DS
    as wstring * 64 w
    declare operator += ( byval p as wstring ptr )
    declare operator += ( byref s as string )
    declare operator += ( byval n as longint )
    declare operator += ( byval n as double )
    declare operator &= ( byref s as string )
end type
operator DS.+= ( byval p as wstring ptr )
    this.w &= *p
end operator
operator DS.+= ( byref s as string )
    this.w &= s
end operator
operator DS.+= ( byval n as longint )
    this.w &= str( n )
end operator
operator DS.+= ( byval n as double )
    this.w &= str( n )
end operator
operator DS.&= ( byref s as string )
    this.w &= "&" & s
end operator

type Holder
    as DS msg
end type

dim shared as DS g_text

sub Shapes( )
    dim as DS d
    dim as string sp = "sp"
    dim as long i = 2
    dim as wstring * 8 wz = "W"

    d.w = "[" : d += "lit"                          '' a literal
    print d.w
    d.w = "[" : d += "a" & str( i )                 '' a concatenation, no Check type
    print d.w
    d.w = "[" : d += chr( 34 )                      '' an intrinsic's result
    print d.w
    d.w = "[" : d += space( 3 ) & "]"
    print d.w
    d.w = "[" : d &= "amp"                          '' '&='
    print d.w
    d.w = "[" : d += sp                             '' controls: already lowered
    print d.w
    d.w = "[" : d += @wz
    print d.w
    d.w = "[" : d += 1.5
    print d.w

    dim as Holder h
    h.msg += "field" & "!"                          '' a field destination
    print h.msg.w
    g_text += "glo" & "bal"                         '' a shared destination
    print g_text.w
end sub

Shapes( )
