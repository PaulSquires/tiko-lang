'' Links greet.dll beside it, which has no import library beside it under a name
'' '#foreignlib' tries: tiko makes one from the DLL's export table. See the .test.
#foreignlib GREET dynamic "greet"
declare function GreetAdd cdecl lib GREET alias "greet_add" ( byval a as long, byval b as long ) as long
print GreetAdd( 2, 3 )
