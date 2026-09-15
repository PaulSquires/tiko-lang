'' 'sizeof' OF A COMPILE-TIME STRING is its bytes and the NUL. Nothing folded it: the operand
'' parses as an expression rather than a type, so 'sizeof( "ab" )' read the literal's STRING type
'' (24), and in a fixed length it had no value at all -- wininet.bi's INTERNET_MAX_URL_LENGTH is
'' '(32 + sizeof( "://" )) + 2048', and 'wstring * INTERNET_MAX_URL_LENGTH + 1' silently became
'' ONE character in fifteen AfxNova AfxUrl* functions.
''
'' The fixed lengths are measured through ZSTRING, one byte a character on every target; a wstring
'' character is 2 bytes on Windows and 4 on Linux. The wstring buffer is still declared, and its
'' length printed: at one character it could hold nothing.
''
'' Measured, fbc-modern prints 6, 24, 3, 1, 4, 4, 2085, 3 and 5; so does tiko.
const CS = "hello"
const K = sizeof( "://" )
#define M ((32 + sizeof( "://" )) + 2048)

dim as string sv = "abc"
print sizeof( CS )
print sizeof( sv )                  '' a string VARIABLE keeps its descriptor's size
print sizeof( "ab" )
print sizeof( "" )
print K
dim z1 as zstring * (sizeof( "://" ))
print sizeof( z1 )
dim z2 as zstring * M + 1
print sizeof( z2 )
dim w2 as wstring * M + 1
w2 = "abc"
print len( w2 )
#assert sizeof( "ab" ) = 3
enum E
    EV = sizeof( "abcd" )
end enum
print EV
