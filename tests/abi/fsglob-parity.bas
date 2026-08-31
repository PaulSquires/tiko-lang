'' fsglob-parity.bas -- pattern matching and the error-message table.
''
'' NEEDS-GEN-LLVM
''
'' BOTH GRAMMARS ARE RUN ON THIS HOST. `gram` is a parameter, not an #ifdef, so
'' the Windows rules (case-insensitive, no escape character, backslash is a
'' separator) and the POSIX rules (case-sensitive, backslash escapes) are both
'' exercised wherever this runs. A version that quietly used the native grammar
'' would pass on one platform and be untested on the other.
''
'' THE HOSTILE PATTERN IS THE POINT OF THE LAST BLOCK. "a*a*a*a*a*a*b" against a
'' long string of a's has no match, and a RECURSIVE matcher takes exponential
'' time on it -- the failure mode is a HANG, not a wrong answer, so a test that
'' only checked outputs would never reach the end to compare them.
''
'' WHAT HAS A PLAUSIBLE WRONG ANSWER:
''   - "*" does not cross a separator; "**" is the only token that does
''   - "**" matches ZERO components, so a/**/c matches a/c -- the single most
''     common glob bug
''   - a MALFORMED class is a LITERAL: "[abc" matches those four characters
''   - "[]]" is a literal "]", and "[a-]" is 'a' or '-'
''   - an absolute pattern does not match a relative path
''   - the empty string is ONE EMPTY COMPONENT, so "*" matches it and "a/*" does
''     not
''   - WildcardAt ignores a "[" that does not open a well-formed class, or the
''     walk root would be dragged up to its parent

extern "rtlib"
	declare function pMatch alias "fb_UStrFsMatchPattern" ( byval s as any ptr, byval p as any ptr, byval g as long ) as long
	declare function pWildAt alias "fb_UStrFsPatternWildcardAt" ( byval p as any ptr, byval g as long ) as integer
	declare function pIsRec alias "fb_UStrFsPatternIsRecursive" ( byval p as any ptr, byval g as long ) as long
	declare function pErrMsg alias "fb_UStrFsErrorMessage" ( byval code_ as long ) as any ptr
end extern

const POSIX = 0
const WIN32_ = 1

const TKORT_USLOTS = 8
dim shared as ustring upool( 0 to TKORT_USLOTS - 1 )
dim shared as integer uslot
function U( byref s as string ) as any ptr
	uslot = (uslot + 1) mod TKORT_USLOTS
	upool(uslot) = s
	return @upool(uslot)
end function

function S( byval d as any ptr ) as string
	dim as ustring ptr ud = d
	if( ud = 0 ) then return "<null>"
	return str( *ud )
end function

sub M( byref subject as string, byref pat as string )
	print "  '"; subject; "' ~ '"; pat; "'  posix="; pMatch( U(subject), U(pat), POSIX ); _
	      " win32="; pMatch( U(subject), U(pat), WIN32_ )
end sub

print "-- literals and the single-character wildcard"
M( "abc", "abc" )
M( "abc", "abd" )
M( "abc", "a?c" )
M( "abc", "a?" )
M( "ABC", "abc" )
M( "abc", "ABC" )

print "-- star does not cross a separator"
M( "a/b", "a/b" )
M( "a/b", "*" )
M( "a/b", "*/*" )
M( "a/b/c", "a/*/c" )
M( "a/b/c", "a/*" )

print "-- backslash is a separator on win32 and an escape on posix"
M( "a\b", "a\b" )
M( "a\b", "*\*" )
M( "a\b", "a/b" )
M( "a*b", "a\*b" )

print "-- doublestar spans components, INCLUDING ZERO"
M( "a/c", "a/**/c" )
M( "a/b/c", "a/**/c" )
M( "a/b/x/c", "a/**/c" )
M( "a", "**" )
M( "a/b/c", "**" )
M( "a/b/c", "a/**" )
M( "x/y", "a/**" )

print "-- doublestar INSIDE a component is just a star"
M( "axxb", "a**b" )
M( "a/b", "a**b" )

print "-- character classes"
M( "abc", "[ab]bc" )
M( "abc", "[!ab]bc" )
M( "cbc", "[!ab]bc" )
M( "a-c", "a[a-]c" )
M( "aac", "a[a-]c" )
M( "a]c", "a[]]c" )
M( "abc", "a[b-d]c" )
M( "aBc", "a[b-d]c" )
M( "a[bc", "a[bc" )
M( "abc", "a[bc" )

print "-- absolute vs relative, and the empty string"
M( "/a/b", "/a/*" )
M( "a/b", "/a/*" )
M( "/a/b", "a/*" )
M( "", "*" )
M( "", "" )
M( "", "a/*" )
M( "a", "" )

print "-- the hostile pattern must TERMINATE"
dim as string many = string( 40, "a" )
M( many, "a*a*a*a*a*a*b" )
M( many & "b", "a*a*a*a*a*a*b" )
print "  terminated"

print "-- WildcardAt"
print "  'a/b/c'      posix="; pWildAt( U("a/b/c"), POSIX ); " win32="; pWildAt( U("a/b/c"), WIN32_ )
print "  'a/b/*.bas'  posix="; pWildAt( U("a/b/*.bas"), POSIX ); " win32="; pWildAt( U("a/b/*.bas"), WIN32_ )
print "  'a/?/c'      posix="; pWildAt( U("a/?/c"), POSIX ); " win32="; pWildAt( U("a/?/c"), WIN32_ )
print "  'a/[bc]/d'   posix="; pWildAt( U("a/[bc]/d"), POSIX ); " win32="; pWildAt( U("a/[bc]/d"), WIN32_ )
print "  'a/[bc/d'    posix="; pWildAt( U("a/[bc/d"), POSIX ); " win32="; pWildAt( U("a/[bc/d"), WIN32_ )
print "  'a\*b'       posix="; pWildAt( U("a\*b"), POSIX ); " win32="; pWildAt( U("a\*b"), WIN32_ )
print "  ''           posix="; pWildAt( U(""), POSIX ); " win32="; pWildAt( U(""), WIN32_ )

print "-- IsRecursive"
print "  'a/**/b'  posix="; pIsRec( U("a/**/b"), POSIX ); " win32="; pIsRec( U("a/**/b"), WIN32_ )
print "  'a/*/b'   posix="; pIsRec( U("a/*/b"), POSIX ); " win32="; pIsRec( U("a/*/b"), WIN32_ )
print "  'a**b'    posix="; pIsRec( U("a**b"), POSIX ); " win32="; pIsRec( U("a**b"), WIN32_ )
print "  '**'      posix="; pIsRec( U("**"), POSIX ); " win32="; pIsRec( U("**"), WIN32_ )
print "  'a\**\b'  posix="; pIsRec( U("a\**\b"), POSIX ); " win32="; pIsRec( U("a\**\b"), WIN32_ )
print "  ''        posix="; pIsRec( U(""), POSIX ); " win32="; pIsRec( U(""), WIN32_ )

print "-- the error message table"
for i as integer = -2 to 18
	print "  "; i; " = '"; S( pErrMsg( i ) ); "'"
next

print "done"
