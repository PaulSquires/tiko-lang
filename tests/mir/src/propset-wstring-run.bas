' A 'byref as wstring' PROPERTY SETTER, given each kind of string value.
type TT
    m_name as wstring * 32
    declare property Name (byref w as wstring)
    declare property CName (byref w as const wstring)
end type
property TT.Name (byref w as wstring)
    m_name = w
end property
property TT.CName (byref w as const wstring)
    m_name = w
end property

sub Show (byref t as TT)
    print len( t.m_name ) & " " & asc( t.m_name, 1 ) & " " & asc( t.m_name, len( t.m_name ) )
end sub

dim t as TT
dim w as wstring * 32 = "Arial"
t.Name = w
Show( t )
dim u as ustring = "Segoe UI"
t.Name = u
Show( t )
t.Name = "Lit"
Show( t )
dim s as string = "Courier"
t.Name = s
Show( t )
t.Name = u & "!"
Show( t )
t.CName = "Const"
Show( t )
