'' A DEREFERENCED WIDE STRING FOR 'operator let( byref w as wstring )' IS PASSED BY ITS
'' ADDRESS. fbc-modern prints, and tiko's build of this now prints too:
''
''    c:hello | l:hello | l:hello | l:call | z:zed | z:zed
''
'' 'd2 = *pw' loaded the first UTF-16 unit and passed it where the signature wants a
'' pointer, and clang refused the module. AfxNova's CRegExp.GetErrorInfo writes
'' 'dwsMsg = *pBuffer' over DWSTRING's operator let, and PsCalendar reached it.
type DW
    s as string
    declare constructor( )
    declare constructor( byref w as wstring )
    declare operator let( byref w as wstring )
end type
constructor DW( )
end constructor
constructor DW( byref w as wstring )
    s = "c:" & w
end constructor
operator DW.let( byref w as wstring )
    s = "l:" & w
end operator
type DZ
    s as string
    declare operator let( byref z as zstring )
end type
operator DZ.let( byref z as zstring )
    s = "z:" & z
end operator
dim wbuf as wstring * 16 = "hello"
dim pw as wstring ptr = @wbuf
dim zbuf as zstring * 16 = "zed"
dim pz as zstring ptr = @zbuf
dim d1 as DW = *pw
print d1.s
dim d2 as DW
d2 = *pw
print d2.s
d2 = wbuf
print d2.s
d2 = wstr( "call" )
print d2.s
dim vz as DZ
vz = *pz
print vz.s
vz = zbuf
print vz.s
