'' FILE GET AND PUT -- the BINARY forms. Measured:
''
''     put #f, 1, b      fb_FilePutLarge( F$0, 1ll, (void*)&B$0, 1ull )
''     get #f, , b       the position is 0 when it is elided
''
'' THE NAME ITSELF DIFFERS BY TARGET, which nothing else in the runtime inventory does:
'' win64 calls fb_FileGetLarge with a 64-bit position and count, win32 calls fb_FileGet
'' with 32-bit ones. Every other entry has one name and only its DECORATION varies.
''
'' A STRING OPERAND TAKES A DIFFERENT ENTRY POINT, fb_FileGetStrLarge, whose last
'' argument is a signed length rather than a byte count. It declines, which is the
'' honest answer for a shape whose argument means something else.
dim as long f = freefile
dim as byte b
dim as long l
type Rec
    as long a
    as long b
end type
dim as Rec rc

put #f, 1, b
put #f, 1, l
put #f, 1, rc
get #f, 1, b
get #f, 1, l
get #f, 1, rc

'' An ELIDED position is 0.
get #f, , b
put #f, , b

'' THE EXPRESSION FORM, which is how the corpus writes nearly all of them: the call
'' answers the ERROR CODE, so 'get( ... )' appears as an initialiser, on the right of
'' an assignment and inside a condition. The parser builds the same node either way.
dim as long r0 = get( #f, 1, b )
r0 = get( #f, 2, b )
r0 = put( #f, 3, b )
if get( #f, 4, b ) = 0 then print "read"
