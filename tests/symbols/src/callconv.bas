sub Def( byval x as long ) : end sub
sub Cd cdecl ( byval x as long ) : end sub
sub St stdcall ( byval x as long ) : end sub
sub Pa pascal ( byval x as long ) : end sub
declare sub Inh cdecl ( byval x as long )
sub Inh( byval x as long ) : end sub
extern "C"
    declare sub EC( byval x as long )
end extern
extern "Windows"
    declare sub EW( byval x as long )
end extern
