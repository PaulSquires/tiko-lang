'' THE CONVENTIONS THAT COINCIDE ON THIS TARGET ARE NOT A MISMATCH, and this is the half
'' a test of the diagnostic alone would not catch: comparing the convention flags
'' directly refuses this, and fbc COMPILES it on win64 -- one ABI, the keywords accepted
'' and ignored. virtual/incompatible-override-6.bas is exactly this shape, and is marked
'' COMPILE_ONLY_FAIL in the corpus because 32-bit is where it fails.
type A extends object
    declare virtual destructor cdecl( )
end type

type B extends A
    declare destructor stdcall( )
end type

'' ...and an override repeating the base's own convention is fine everywhere.
type C extends object
    declare virtual destructor pascal( )
end type

type D extends C
    declare destructor pascal( )
end type
