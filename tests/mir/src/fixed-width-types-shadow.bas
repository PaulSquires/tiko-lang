'' A PROGRAM'S OWN DECLARATION OF A FIXED-WIDTH NAME WINS over the prelude's typedef,
'' because existing code already owns these names: win/basetsd.bi writes 'type INT32
'' as long', jpeglib.bi 'type INT32 as clong', and fbc's own tests name variables i32.
'' fbc knows none of the ten names, so each line here is plain FreeBASIC to it, and
'' fbc-modern prints:
''
''      4 8 5 7 2
type INT32 as long                      '' identical to the prelude's: restated
type uint8 as integer                   '' different: the program's wins
dim shared float32 as long = 5          '' not a type at all: the variable wins
function uint16( byval x as long ) as long
    return x + 1
end function
sub Local_( )
    dim int16 as long = 2               '' a local of the same name
    print int16
end sub
print sizeof( INT32 ); sizeof( uint8 ); float32; uint16( 6 );
Local_( )
