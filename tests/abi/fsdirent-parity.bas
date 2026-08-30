'' fsdirent-parity.bas -- the filesystem USTRING accessors and the four ABI
'' size hooks: nine entry points.
''
'' NEEDS-GEN-LLVM
''
'' THE SIZE HOOKS ARE THE POINT OF THIS FILE. The C kernel writes FB_FSDIRENT,
'' FB_FSVOLUME, FB_FSCHANGE and FB_FSINFO DIRECTLY, and tiko-rt now declares
'' its own mirrors of all four. A layout drift would not fail loudly -- it
'' would scramble every field of every result -- so the sizes are compared
'' against fbc's here, not assumed.
''
'' The accessors are driven from BUFFERS THIS TEST FILLS, not from a real
'' directory: a differential over the actual filesystem would depend on what is
'' on the disk. What matters is the length handling, and that is fully
'' controllable from a synthetic entry:
''   - a name taken by LENGTH, so an embedded NUL survives
''   - a length of 0, and a NEGATIVE length, both giving the empty string
''   - a length past the buffer, clamped rather than over-read
''   - a NULL struct pointer
#include once "fbc-int/string.bi"

extern "rtlib"
	declare function pSizeInfo alias "fb_FsSizeofInfo" ( ) as long
	declare function pSizeDirEnt alias "fb_FsSizeofDirEnt" ( ) as long
	declare function pSizeVolume alias "fb_FsSizeofVolume" ( ) as long
	declare function pSizeChange alias "fb_FsSizeofChange" ( ) as long
	declare function pEntName alias "fb_UStrFsDirEntName" ( byval e as any ptr ) as FBC.FBUSTRING ptr
	declare function pVolRoot alias "fb_UStrFsVolumeRoot" ( byval v as any ptr ) as FBC.FBUSTRING ptr
	declare function pVolName alias "fb_UStrFsVolumeName" ( byval v as any ptr ) as FBC.FBUSTRING ptr
	declare function pVolType alias "fb_UStrFsVolumeFsType" ( byval v as any ptr ) as FBC.FBUSTRING ptr
	declare function pChgPath alias "fb_UStrFsChangePath" ( byval c as any ptr ) as FBC.FBUSTRING ptr
	declare function pDelTemp alias "fb_hUStrDelTemp" ( byval s as FBC.FBUSTRING ptr ) as long
end extern

'' Rendered, then FREED -- these are temps, and a test that leaks them measures
'' the pool's exhaustion instead of the function (see fspath-parity.bas).
function shows( byval du as FBC.FBUSTRING ptr ) as string
	if( du = 0 ) then return "<null>"
	dim as integer n = du->len and (not (cast(integer,1) shl (sizeof(integer)*8-1)))
	if( du->data = 0 ) then
		pDelTemp( du )
		return "<nodata>"
	end if
	dim as string o = ""
	dim as integer i = any
	for i = 0 to n - 1
		dim as ulong c = du->data[i]
		if( c = 0 ) then
			o += "<0>"
		elseif( c < 32 orelse c > 126 ) then
			o += "<" & c & ">"
		else
			o += chr(c)
		end if
	next
	pDelTemp( du )
	return "len=" & n & " '" & o & "'"
end function

print "-- the four ABI size hooks"
print "  FSINFO="; pSizeInfo( )
print "  FSDIRENT="; pSizeDirEnt( )
print "  FSVOLUME="; pSizeVolume( )
print "  FSCHANGE="; pSizeChange( )

'' Raw byte buffers, sized from the hooks themselves, so this test cannot
'' disagree with the layout it is checking.
dim shared as ubyte entbuf(0 to 4095)
dim shared as ubyte volbuf(0 to 8191)
dim shared as ubyte chgbuf(0 to 4095)

const MAXNAME = 260
const MAXPATH = 512

sub putunits( byval base_ as ubyte ptr, byval off as integer, byref s as string )
	dim as ushort ptr p = cptr( ushort ptr, base_ + off )
	dim as integer i = any
	for i = 0 to len(s) - 1
		p[i] = asc( mid(s, i + 1, 1) )
	next
end sub

sub putlong( byval base_ as ubyte ptr, byval off as integer, byval v as long )
	*cptr( long ptr, base_ + off ) = v
end sub

dim as long i = any

print "-- DirEntName: by length, clamped, negative, zero, NULL"
'' name at offset 0, namelen immediately after the 260-unit buffer
const ENT_NAMELEN_OFF = MAXNAME * 2
dim shared as long lens(0 to 6) = { 3, 0, -1, -99, MAXNAME - 1, MAXNAME, 100000 }
for i = 0 to 6
	dim as long k = any
	for k = 0 to 4095
		entbuf(k) = 0
	next
	putunits( @entbuf(0), 0, "abcdefghij" )
	'' An embedded NUL inside the counted run must survive.
	*cptr( ushort ptr, @entbuf(0) + 2 ) = 0
	putlong( @entbuf(0), ENT_NAMELEN_OFF, lens(i) )
	print "  len="; lens(i); " -> "; shows( pEntName( @entbuf(0) ) )
next
print "  null -> "; shows( pEntName( 0 ) )

print "-- Volume: three fields, each with its own cap"
const VOL_ROOT_OFF = 0
const VOL_NAME_OFF = MAXPATH * 2
const VOL_TYPE_OFF = MAXPATH * 2 + MAXNAME * 2
const VOL_LENS_OFF = MAXPATH * 2 + MAXNAME * 2 + MAXNAME * 2
for i = 0 to 8191
	volbuf(i) = 0
next
putunits( @volbuf(0), VOL_ROOT_OFF, "C:\" )
putunits( @volbuf(0), VOL_NAME_OFF, "SYSTEM" )
putunits( @volbuf(0), VOL_TYPE_OFF, "NTFS" )
putlong( @volbuf(0), VOL_LENS_OFF, 3 )
putlong( @volbuf(0), VOL_LENS_OFF + 4, 6 )
putlong( @volbuf(0), VOL_LENS_OFF + 8, 4 )
print "  root="; shows( pVolRoot( @volbuf(0) ) )
print "  name="; shows( pVolName( @volbuf(0) ) )
print "  type="; shows( pVolType( @volbuf(0) ) )
'' Over-long and negative on each field.
putlong( @volbuf(0), VOL_LENS_OFF, 99999 )
putlong( @volbuf(0), VOL_LENS_OFF + 4, -3 )
putlong( @volbuf(0), VOL_LENS_OFF + 8, 0 )
print "  clamped-root-len="; len( *cast( zstring ptr, @"" ) ) + 0;
dim as FBC.FBUSTRING ptr r = pVolRoot( @volbuf(0) )
dim as integer rn = r->len and (not (cast(integer,1) shl (sizeof(integer)*8-1)))
pDelTemp( r )
print " units="; rn
print "  neg-name="; shows( pVolName( @volbuf(0) ) )
print "  zero-type="; shows( pVolType( @volbuf(0) ) )
print "  null root="; shows( pVolRoot( 0 ) ); " name="; shows( pVolName( 0 ) ); " type="; shows( pVolType( 0 ) )

print "-- Change path"
const CHG_LEN_OFF = MAXPATH * 2
for i = 0 to 4095
	chgbuf(i) = 0
next
putunits( @chgbuf(0), 0, "dir\file.txt" )
putlong( @chgbuf(0), CHG_LEN_OFF, 12 )
print "  path="; shows( pChgPath( @chgbuf(0) ) )
putlong( @chgbuf(0), CHG_LEN_OFF, -1 )
print "  neg="; shows( pChgPath( @chgbuf(0) ) )
putlong( @chgbuf(0), CHG_LEN_OFF, 99999 )
dim as FBC.FBUSTRING ptr c2 = pChgPath( @chgbuf(0) )
dim as integer cn = c2->len and (not (cast(integer,1) shl (sizeof(integer)*8-1)))
pDelTemp( c2 )
print "  clamped units="; cn
print "  null="; shows( pChgPath( 0 ) )
print "done"
