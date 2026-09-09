'' THE FORMS THAT DO NOT RESERVE THE NAME FOR THE LANGUAGE. Measured, all four
'' spellings against fbc:
''
''     #pragma reserve foo              then 'dim as integer foo'   error 4
''     #pragma reserve( asm ) foo       then the same              accepted
''     #pragma reserve( extern ) foo    then the same              accepted
''     #pragma reserve( asm, extern ) f then the same              accepted
''
'' '( asm )' and '( extern )' reserve the name for the ASSEMBLER and the LINKER; fbc
'' still lets the source declare it. Refusing these would turn one rule into three.
#pragma reserve( asm ) a
#pragma reserve( extern ) b
#pragma reserve( asm, extern ) c

dim as integer a
dim as integer b
dim as integer c

'' ...and a reserved name nothing declares is not an error either.
#pragma reserve neverdeclared

print a + b + c
