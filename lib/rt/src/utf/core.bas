'' core.bas -- the three UTF-8 decode tables and the ASCII->UTF-8 encoder.
'' Four symbols over one fbc member, three of them DATA.
''
'' THE TABLES ARE PART OF THE ABI, not an implementation detail. fbc's
'' utf_convto_char.o and utf_convfrom_wchar.o reference them by name through a
'' .refptr, so owning utf_core.o means owning all four symbols or those
'' members stop linking. The build guard checks the text symbols; the data ones
'' only show up as a link failure, which is why they are called out here.
''
'' __fb_utf8_trailingTb IS INDEXED BY THE LEAD BYTE and gives the number of
'' CONTINUATION bytes, not the total length. Rows 0x80-0xBF are 0 -- a stray
'' continuation byte decodes as a one-byte sequence rather than being rejected,
'' which is what makes the decoder total rather than fallible.
''
'' THE TABLES LAND IN .data, NOT .rdata. fbc declares them const and nm reports
'' them as 'R'; FreeBASIC has no way to place a shared variable in read-only
'' data -- `dim shared ... as const` still emits 'D', measured, not assumed.
'' Names, sizes and contents are identical and nothing links or behaves
'' differently, but this is NOT byte-identical placement and should not be
'' reported as such. build/symbols.sh accepts either section deliberately.
''
'' __fb_utf8_offsetsTb UNDOES the accumulated lead-byte bits. The decoder adds
'' every byte raw and shifts, so the marker bits ride along in the total and
'' this table subtracts them back out in one step.

#include once "inc/descriptors.bi"

'' The C-visible names. A C-visible global needs the EXTERN declaration inside
'' an EXTERN "C" block AND a matching DIM SHARED outside it; `dim shared ...
'' alias` on its own is not valid FreeBASIC.
''
'' EACH TABLE IS WRAPPED IN A ONE-MEMBER TYPE. FreeBASIC will not let an
'' EXTERN declaration carry array bounds ("default types or suffixes are only
'' valid in -lang fblite"), and an EXTERN scalar followed by a DIM SHARED array
'' is "wrong number of dimensions". A struct whose only member is the array has
'' exactly the array's layout, so C sees the same bytes at the same symbol.
type TKORT_UTF8_BMARK
	as ubyte v( 0 to 6 )
end type
type TKORT_UTF8_TRAILING
	as byte v( 0 to 255 )
end type
type TKORT_UTF8_OFFSETS
	as ulong v( 0 to 5 )
end type

extern "c"   '' NON-FBCALL: three tables and one plain helper, no FBCALL anywhere.
	extern __fb_utf8_bmarkTb alias "__fb_utf8_bmarkTb" as TKORT_UTF8_BMARK
	extern __fb_utf8_trailingTb alias "__fb_utf8_trailingTb" as TKORT_UTF8_TRAILING
	extern __fb_utf8_offsetsTb alias "__fb_utf8_offsetsTb" as TKORT_UTF8_OFFSETS
end extern

dim shared __fb_utf8_bmarkTb as TKORT_UTF8_BMARK = type<TKORT_UTF8_BMARK>( _
	{ &h00, &h00, &hC0, &hE0, &hF0, &hF8, &hFC } )

dim shared __fb_utf8_offsetsTb as TKORT_UTF8_OFFSETS = type<TKORT_UTF8_OFFSETS>( _
	{ &h00000000, &h00003080, &h000E2080, &h03C82080, &hFA082080, &h82082080 } )

'' 0x00-0x7F: 0 (ASCII).  0x80-0xBF: 0 (a bare continuation byte).
'' 0xC0-0xDF: 1.  0xE0-0xEF: 2.  0xF0-0xF7: 3.  0xF8-0xFB: 4.  0xFC-0xFF: 5.
dim shared __fb_utf8_trailingTb as TKORT_UTF8_TRAILING = type<TKORT_UTF8_TRAILING>( _
{ _
	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, _
	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, _
	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, _
	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, _
	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, _
	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, _
	1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1, 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1, _
	2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2, 3,3,3,3,3,3,3,3,4,4,4,4,5,5,5,5 _
} )

const UTF8_BYTEMASK = &hBF
const UTF8_BYTEMARK = &h80

extern "c"   '' NON-FBCALL: fb_file.h declares it plain.

'' ASCII -> UTF-8, one or two bytes per character, NEVER more: the input is
'' bytes, so 0x80-0xFF each become a two-byte sequence and nothing longer can
'' arise. That is why fb_CharToUTF sizes its buffer at chars * 2.
''
'' EMBEDDED NULs ARE CONVERTED, NOT TERMINATORS. The count comes from `chars`,
'' so a NUL in the middle is emitted as a one-byte 0 and the loop continues.
sub tkort_CharToUTF8 alias "fb_hCharToUTF8" _
	( byval src as ubyte ptr, byval chars as integer, _
	  byval dst as ubyte ptr, byval total_bytes as integer ptr )

	dim as ulong c = any

	*total_bytes = 0
	while( chars > 0 )
		c = *src : src += 1
		if( c < &h80 ) then
			*dst = c : dst += 1
			*total_bytes += 1
		else
			*dst = &hC0 or (c shr 6) : dst += 1
			*dst = (c or UTF8_BYTEMARK) and UTF8_BYTEMASK : dst += 1
			*total_bytes += 2
		end if
		chars -= 1
	wend
end sub

end extern
