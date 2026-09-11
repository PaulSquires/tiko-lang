'' AN 'extern X as T' NAMES A VARIABLE DEFINED IN ANOTHER MODULE.
''
'' IsSharedVar tested SYMF_SHARED alone, so an EXTERN became a FRAME SLOT: a zeroed
'' local, with no reference to the real symbol emitted anywhere. 'extern
'' CLSID_ShellLink as const GUID' therefore handed CoCreateInstance the address of
'' uninitialised stack and it answered REGDB_E_CLASSNOTREG -- silently, and with the
'' link succeeding, because nothing external was ever referenced.
''
'' AND THE NAME IT LINKS BY IS NOT THE FOLDED ONE. Measured on fbc's own object file:
''
''     extern MyThing as long                    undefined MYTHING$
''     extern "C" : extern MyThing2 as long      undefined MyThing2
''
'' -- uppercased with a '$' outside a foreign block, and the source spelling, case and
'' all, inside one. win/shobjidl.bi declares every CLSID and IID the second way.
''
'' Nothing here is DEFINED, so the file is compiled to IR only -- linking it would want
'' the other module. What is asserted is the shape: module storage, external, and the
'' two spellings.
extern PlainThing as long

extern "C"
	extern CThing as long
end extern

extern "Windows"
	extern WThing as long
end extern

sub Use_( )
	print PlainThing, CThing, WThing
end sub
