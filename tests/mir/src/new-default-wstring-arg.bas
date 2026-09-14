'' 'new T' OVER A CONSTRUCTOR WITH A 'byref as const wstring = ""' DEFAULT. The NEW path
'' fills defaults in PushCtorArgs_, not in EmitStructorCall, and passed the NARROW literal:
'' tracks creates every window with 'new CWindow', so each got a garbage class name and all
'' but the first failed to register. Measured, fbc-modern prints 0.
type T
    as wstring * 260 name_
    declare constructor( byref w as const wstring = "" )
end type
constructor T( byref w as const wstring = "" )
    this.name_ = w
end constructor
dim as T ptr p = new T
print len( p->name_ )
delete p
