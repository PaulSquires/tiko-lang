'' THE DEFINITION OF AN EXTERN LINKS BY THE NAME THE DECLARATION REFERENCES.
''
'' 'extern e' then 'dim e = 5' is ONE object written twice. The reference went out as
'' 'E$' -- the name tests/mir/extern-variable pins -- and the storage went out as 'e',
'' the ordinary module spelling, so the two never met: a second module reading 'e'
'' stopped at 'lld-link: error: undefined symbol: E$', and in a single module it
'' merely worked by accident, because nothing else named the storage.
''
'' Measured on fbc's own object file, all four of these are ONE symbol, defined:
''
''     extern e     : dim e = 5              D E$
''     extern se    : dim shared se = 6      D SE$
''     extern a alias "zz" : dim a = 7       D zz
''     extern "C" ce : dim ce = 8            D ce
''
'' -- 'D', external, where a plain 'dim shared' is fbc's 'static int32 X$' and 'd'.
'' ALIAS travels with it: the alias names the link symbol, and the definition is what
'' the linker resolves against, so writing the folded name there loses it.
extern e as long
dim e as long = 5

extern se as long
dim shared se as long = 6

extern a alias "zz" as long
dim a as long = 7

extern "C"
	extern ce as long
end extern
dim ce as long = 8

print e, se, a, ce
