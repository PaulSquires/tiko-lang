'' FBC HAS NO HIDE SET. tiko-lang painted every macro blue for the whole of its own
'' expansion, the way C does, and that is not FreeBASIC. Measured:
''
''     #define f(x) x     print f(f(f(f(1))))    fbc prints 1; this DECLINED
''     M( A, M( B, C ))   fbc gives 123;         this gave 1, and left 'm ( 2 , 3 )'
''                                               in the stream -- a WRONG VALUE, emitted
''     __FB_ARG_COUNT__(LIST3)                   fbc 3, this 2
''     __FB_ARG_EXTRACT__(0,LIST3)               fbc 9, this '9, 4' -- two tokens
''
'' A macro reached again through its own ARGUMENT is an ordinary nested invocation; only
'' TRUE self-recursion is refused, and fbc calls that error 89.
#define f(x) x
print f(f(f(f(1))))

#define M(A,B) __FB_JOIN__(A,B)
#define A 1
#define B 2
#define C 3
print M( A, M( B, C ))
print M( M( A, B ), C )

#define CONCAT_INT(x, y...) x, y
#define CONCAT(x, y...) CONCAT_INT(x, y)
#define LIST1 9
#define LIST2 CONCAT(LIST1, 4)
#define LIST3 CONCAT(LIST2, 7)
print __FB_ARG_COUNT__(LIST3)
print __FB_ARG_EXTRACT__(0, LIST3)
print __FB_ARG_EXTRACT__(2, LIST3)

'' '#pragma once' WAS A NO-OP -- recognised and then skipped -- so a header guarded that
'' way was re-read every time and one that includes ITSELF recursed until the frame cap.
dim shared as integer ppSelfCounter = 0
#include "tests/mir/src/inc/pp-selfinc.bi"
#include "tests/mir/src/inc/pp-selfinc.bi"
print ppSelfCounter
