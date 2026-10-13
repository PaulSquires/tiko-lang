'' The DLL foreignlib-bare-dll.test links through '#foreignlib' with no import library.
function GreetAdd cdecl alias "greet_add" ( byval a as long, byval b as long ) as long export
    return a + b
end function
