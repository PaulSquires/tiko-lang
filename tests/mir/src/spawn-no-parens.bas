'' 'spawn Hello' WITH NO PARENTHESES is a call of no arguments -- fbc-modern compiles and runs
'' it. It was left undesugared and lowering declined it: TKO0994.
#import "std/tasks"
sub Hello( )
    print "hello"
end sub
spawn Hello
