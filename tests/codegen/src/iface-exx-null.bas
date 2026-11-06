'' -exx: a call through a null interface reference is runtime error 7 (§8.8).
interface IA
    sub M( )
end interface
dim as IA a
print "before"
a.M( )
print "after"
