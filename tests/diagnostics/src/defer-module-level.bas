'' 'defer' directly at module level, and directly in a namespace -- fbc's error 348 on
'' lines 7 and 9 (fbc-modern 1.20). A block at module level and a procedure take one.
print "a"
scope
    defer print "block"
end scope
defer print "module"
namespace N
    defer print "namespace"
end namespace
if 1 then
    defer print "if"
end if
sub S( )
    defer print "proc"
end sub
