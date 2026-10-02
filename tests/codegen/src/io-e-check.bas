'' T68: under -e a failing I/O statement raises its runtime error, as fbc's does -- here
'' each reaching a module-level handler in turn. (A local handler is io-e-local-run's.)
on error goto closed
close #7
print "not reached"
end
closed:
dim as long c1 = err
print "close:"; c1
on error goto opened
dim as long f = freefile
open "tests/codegen/src/no-such-file.txt" for input as #f
print "not reached"
end
opened:
dim as long c2 = err
print "open:"; c2
