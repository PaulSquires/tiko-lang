'' Imports acme/twice, and names its '#cmdline' AFTER a statement: the header pre-scan
'' does not see it, so the module is built before the unit's own pass restarts.
#import "acme/twice"
dim as long n = 21
#cmdline "-s console"
print twice.Times2( n )
