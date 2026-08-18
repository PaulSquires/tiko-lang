'' DIM SHARED: module storage, not a frame slot.

dim shared as long Counter = 5
dim shared as string Name_

sub Bump( )
    Counter = Counter + 1
    Name_ = Name_ + "!"
end sub

sub Reset_( )
    Counter = 0
end sub

Bump( )
Reset_( )
