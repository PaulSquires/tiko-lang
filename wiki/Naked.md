[Home](Home) › [Procedures](Category-Procedures) › **Naked**

# Naked

Write functions without prolog/epilog code

## Syntax

```freebasic
{Sub | Function} identifier Naked [calling_convention] ( param_list ) [[ ByRef ] As data_type]
asm_statements
End {Sub | Function}
```

## Parameters

- `identifier`
- `calling_convention`
- `asm_statements`
- `param_list`
- `data_type`

## Description

`Naked` allows the programmer to write procedures without the compiler generating any prolog/epilog code.  
 This is useful when writing small, fast functions in [`Asm`](Asm) without any unnecessary overhead (so, no register preservation for such [`Asm`](Asm) blocks).

## Remarks

### Platform Differences

- The default calling convention depends on the target platform, thus it is best to specify the expected calling convention explicitly when using `Naked`.

### Differences from QB

- New to FreeBASIC

### See also

- [`Asm`](Asm)
- [`Function`](procedures-Function)
- [`Sub`](Sub)
- [`cdecl`](Cdecl)
- [`pascal`](Pascal)
- [`stdcall`](Stdcall)

## Examples

```freebasic
'' Naked cdecl function (32-bit)

Function subtract_c Naked cdecl _   '' parameters pushed onto call stack in reverse order of declaration

    ( _

        ByVal a As Long, _

        ByVal b As Long _        '' parameter pushed onto stack in first

    ) As Long

    Asm

        mov eax, dword Ptr [esp+4]  '' eax = a

        Sub eax, dword Ptr [esp+8]  '' eax -= b

        ret                         '' return result in eax

    End Asm

End Function

Print subtract_c( 5, 1 ) '' 5 - 1

''---------------------------------------------------------------------------------------------------------------------

'' Naked stdcall function (32-bit)

Function subtract_s Naked stdcall _ '' parameters pushed onto call stack in reverse order of declaration

                         _          '' called procedure responsible for removing parameters from stack

                         _          ''   (appending constant to RET instruction specifying number of bytes to release)

    ( _

        ByVal a As Long, _

        ByVal b As Long _        '' parameter pushed onto stack in first

    ) As Long

    Asm

        mov eax, dword Ptr [esp+4]  '' eax = a

        Sub eax, dword Ptr [esp+8]  '' eax -= b

        ret 8                       '' return result in eax and 8 bytes (2 integers) to release

    End Asm

End Function

Print subtract_s( 5, 1 ) '' 5 - 1

''---------------------------------------------------------------------------------------------------------------------

'' Naked pascal function (32-bit)

Function subtract_p Naked pascal _  '' parameters pushed onto call stack in same order as declaration

                         _          '' called procedure responsible for removing parameters from stack

                         _          ''   (appending constant to RET instruction specifying number of bytes to release)

    ( _

        ByVal a As Long, _       '' parameter pushed onto stack in first

        ByVal b As Long _

    ) As Long

    Asm

        mov eax, dword Ptr [esp+8]  '' eax = a

        Sub eax, dword Ptr [esp+4]  '' eax -= b

        ret 8                       '' return result in eax and 8 bytes (2 longs) to release

    End Asm

End Function

Print subtract_p( 5, 1 ) '' 5 - 1
```

```freebasic
'' Naked cdecl function (32-bit)

'' plus ecx register preserved in asm block by creating user stack

Function subtract_cp Naked cdecl _      '' parameters pushed onto call stack in reverse order of declaration

    ( _

        ByVal a As Long, _

        ByVal b As Long _            '' parameter pushed onto stack in first

    ) As Long

    Asm

        push ebp                        '' push ebp onto stack   => esp -= 4

        mov ebp, esp                    '' ebp = esp

                                        ''    => create user stack 4 bytes above call stack

        push ecx                        '' push ecx onto user stack   => esp -= 4

        mov eax, dword Ptr [(ebp+4)+4]  '' eax = a   (supplementary offset of +4 bytes only due to 'push ebp')

        mov ecx, dword Ptr [(ebp+8)+4]  '' ecx = b   (supplementary offset of +4 bytes only due to 'push ebp')

        Sub eax, ecx                    '' eax -= ecx

        pop ecx                         '' pop ecx from user stack   => esp += 4

        mov esp, ebp                    '' esp = ebp

        pop ebp                         '' pop ebp from stack   => esp += 4

                                        ''    => discard user stack

        ret                             '' return result in eax

    End Asm

End Function

Print subtract_cp( 5, 1 ) '' 5 - 1
```

---

**Category:** [Procedures](Category-Procedures)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
