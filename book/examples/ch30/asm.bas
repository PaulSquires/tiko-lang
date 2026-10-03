'' Inline assembly: fbc compiles it; tiko does not.
function Twice( byval n as long ) as long
    asm
        mov eax, [n]
        add eax, eax
        mov [function], eax
    end asm
end function
print Twice( 21 )
