'' A FIELD INITIALISER THAT IS A BARE VALUE, NOT A CONSTRUCTOR CALL, over a UDT field
'' with a converting constructor. AfxNova's DWSTRING is exactly this, and tracks
'' declares 'TwsHost as DWSTRING = "127.0.0.1"': the value was DROPPED -- the field got
'' its default constructor and nothing else -- so the host was empty, connect( ) went
'' to INADDR_NONE, and tracks could not reach TWS. No diagnostic; one more statement
'' not lowered.
''
'' Measured with fbc -gen gcc -r: the synthesised constructor builds a temporary
'' FBSTRING, calls the (byref as string, cp = 0) constructor ON THE FIELD, and deletes
'' the temporary. The field's DEFAULT constructor is NOT called first -- nDefault below
'' counts that.
dim shared as long nDefault

type W
    as wstring * 64 s
    declare constructor( )
    declare constructor( byref a as string, byval cp as ulong = 0 )
    declare constructor( byref w as const wstring )
end type
constructor W( )
    nDefault += 1
    this.s = "default"
end constructor
constructor W( byref a as string, byval cp as ulong = 0 )
    this.s = "s:" & a & ":" & cp
end constructor
constructor W( byref w as const wstring )
    this.s = "w:" & w
end constructor

type Cfg
    as W plain
    port as long = 7496
    host as W = "127.0.0.1"
end type

dim shared g as Cfg
print "shared ["; g.plain.s; "] "; g.port; " ["; g.host.s; "]"

scope
    dim as Cfg l
    print "local ["; l.host.s; "]"
end scope

dim as Cfg ptr p = new Cfg
print "new ["; p->host.s; "]"
delete p

print "default constructors:"; nDefault
