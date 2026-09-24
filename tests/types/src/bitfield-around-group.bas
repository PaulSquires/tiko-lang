'' A BITFIELD RUN AND AN ANONYMOUS GROUP BESIDE IT DO NOT OVERLAP.
''
'' After a nested union or type, the bit cursor stayed where the group BEGAN, so a
'' bitfield after it sat on top of it: winnt.h's IMPORT_OBJECT_HEADER put 'Type : 2 as
'' WORD' at byte 16, inside the union of Ordinal and Hint, where fbc puts it at 18 -- and
'' writing Type overwrote Ordinal. And a run open BEFORE a group was not closed, so
'' 'x : 3 as ulong' then a union put the union at byte 1 where fbc has 4. tiko-lang's C
'' importer found the first, comparing its layout with clang's. fbc prints what this file
'' prints, byte for byte -- goldenrun executes it.
type A1
	x : 3 as ulong
	union
		u1 as ubyte
		u2 as ubyte
	end union
	y as ubyte
end type
type A2
	p as ubyte
	union
		u1 as ushort
		u2 as ushort
	end union
	q : 2 as ubyte
	r : 3 as ubyte
	s as ubyte
end type
type A3
	x : 3 as ushort
	union
		type
			t1 as ubyte
			t2 as ubyte
		end type
		w as ushort
	end union
	z : 4 as ushort
end type
type A4 field = 1
	a as ubyte
	union
		b as ulong
		c as ushort
	end union
	d : 5 as ulong
end type
#macro show( T, f )
	scope
		dim v as T
		print #T; " "; #f; sizeof( T ); offsetof( T, f )
	end scope
#endmacro
show( A1, u1 ) : show( A1, y )
show( A2, u1 ) : show( A2, s )
show( A3, t1 ) : show( A3, t2 )
show( A4, b )
dim a2 as A2 : a2.q = 3 : a2.r = 7
dim pp as ubyte ptr = cptr( ubyte ptr, @a2 )
for i as long = 0 to sizeof( A2 ) - 1 : print pp[i]; : next : print
dim a3 as A3 : a3.z = 15
pp = cptr( ubyte ptr, @a3 )
for i as long = 0 to sizeof( A3 ) - 1 : print pp[i]; : next : print
dim a4 as A4 : a4.d = 31
pp = cptr( ubyte ptr, @a4 )
for i as long = 0 to sizeof( A4 ) - 1 : print pp[i]; : next : print
type IOH field = 4
	Sig1 as ushort
	Sig2 as ushort
	Version as ushort
	Machine as ushort
	TimeDateStamp as ulong
	SizeOfData as ulong
	union
		Ordinal as ushort
		Hint as ushort
	end union
	Type_ : 2 as ushort
	NameType : 3 as ushort
	Reserved : 11 as ushort
end type
dim h as IOH
h.Ordinal = 0 : h.Type_ = 3 : h.NameType = 5
print sizeof( IOH ), h.Ordinal
pp = cptr( ubyte ptr, @h )
for i as long = 16 to 19 : print pp[i]; : next : print
