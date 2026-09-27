'' The root: 'app/util' is the current package (RFC-0007 §3, source 2), 'mylib/core' and
'' 'other/core' its manifest's dependencies (source 3). Two modules named core, in two
'' packages, linked into one program.
#import "app/util"
#import "mylib/core" as mcore
#import "other/core" as ocore
print util.Flag( )
print mcore.Level( )
print ocore.Level( )
#ifndef APP_FLAG
print "main: no APP_FLAG"
#endif
