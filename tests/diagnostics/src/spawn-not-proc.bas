'' T76: 'spawn' of something that is not a procedure -- a lambda in a variable -- is
'' fbc's error 357. tiko said the declared variable was not declared.
#import "std/tasks"
var greet = sub( ) : print 1 : end sub
spawn greet( )
