'' A macro whose own body names it -- fbc's error 89 on the refused line (fbc stops at its
'' first; '#define A A+1' is pp/expansion-recursive-1's). A macro reached again through its
'' ARGUMENT is an ordinary nested call.
#define f(x) f(x)
#define g(x) x
print g(g(g(2)))                                    '' fine
f(1)                                                '' 89
