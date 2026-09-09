'' Source for tests/pp/macro-bare-lookahead.test -- four shapes in which a
'' function-like macro NAME is the LAST token of its expansion frame.

'' 1. no '(' anywhere after it: not an invocation, and 'aaa' must survive.
#define fn( x ) x
#define tailfn fn
tailfn aaa

'' 2. the '(' is in the ENCLOSING frame, so this IS an invocation -- the lookahead
''    has to see across the frame boundary to find it.
#define takes( x ) 100 + x
#define tail2 takes
tail2 ( 777 ) bbb

'' 3. parens-optional '?': a bare invocation, taking 'ccc' as its argument.
#macro opt?( a )
a
#endmacro
#define tailopt opt
tailopt ccc

'' 4. the self-recursive body from the original report. 'letter' is hidden inside its
''    own expansion, so it is emitted as a plain identifier -- and 'ddd' stays.
#define letter( seq ) #seq + letter
dim s as string = letter (o) ddd
