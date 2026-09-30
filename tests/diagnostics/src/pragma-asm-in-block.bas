'' '#pragma reserve (asm)' inside a block -- fbc's error 96 on the refused line.
#pragma reserve (asm) top1
scope
    #pragma reserve (asm) inner1
end scope
scope
    #pragma reserve inner2
end scope
