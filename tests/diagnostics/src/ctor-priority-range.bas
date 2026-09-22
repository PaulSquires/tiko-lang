'' A MODULE STRUCTOR'S PRIORITY IS 101 TO 65535 -- fbc's error 189, "Invalid priority
'' attribute", outside it. Measured: 101, 65535 and '&h100' are accepted; 100, 0 and
'' 65536 are refused. The number was swallowed with the other trailing words, so a bad
'' one said nothing and a good one did nothing.

sub lowest( ) constructor 101
end sub
sub highest( ) constructor 65535
end sub
sub hexed( ) destructor &h100
end sub

sub tooLow( ) constructor 100
end sub
sub tooHigh( ) destructor 65536
end sub
sub zero( ) constructor 0
end sub
