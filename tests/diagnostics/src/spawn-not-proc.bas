'' T76: 'spawn' of something that is not a procedure -- a lambda in a variable -- is
'' fbc's error 357. tiko said the declared variable was not declared.
#include once "fb/scheduler.bi"
var greet = sub( ) : print 1 : end sub
spawn greet( )
