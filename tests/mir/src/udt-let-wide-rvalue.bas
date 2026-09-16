'' A WIDE RIGHT SIDE FOR A UDT WHOSE ONLY ASSIGNMENT TAKES A STRING IS CONVERTED, NOT DROPPED.
'' 'd = left( w, 2 )' over 'operator let( byref s as string )': fbc converts the wide result to
'' narrow and calls the operator. tiko found no let taking WSTRING and declined the statement,
'' leaving d unchanged. AfxNova's DWSTRING path helpers assign exactly this.
''
'' fbc prints: let wide: xy / let narrow: p
namespace AX
	type BSS_ as BSS
	type DWS
		as wstring * 32 buf
		declare constructor( byref s as string = "" )
		declare constructor( byref b as BSS_ )
		declare operator let( byref s as string )
	end type
	type BSS
		as wstring * 32 buf
		declare constructor( byref s as string = "" )
	end type
	constructor BSS( byref s as string = "" )
		buf = s
	end constructor
	constructor DWS( byref s as string = "" )
		buf = s
	end constructor
	constructor DWS( byref b as BSS_ )
		buf = b.buf
	end constructor
	operator DWS.let( byref s as string )
		buf = s
	end operator
	private operator len overload ( byref d as DWS ) as ulong
		return ..len( d.buf )
	end operator
	private operator len ( byref b as BSS ) as ulong
		return 200
	end operator
end namespace
using AX
dim as DWS d = DWS( "ab\" )
dim as wstring * 8 w = "xyz"
d = left( w, 2 )
print "let wide: "; d.buf
dim as string s = "pqr"
d = left( s, 1 )
print "let narrow: "; d.buf
