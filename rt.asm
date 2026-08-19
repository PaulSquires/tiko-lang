	.intel_syntax noprefix

.section .text
.balign 16

.globl _main
_main:
push ebp
mov ebp, esp
and esp, 0xFFFFFFF0
sub esp, 12
mov dword ptr [ebp-4], 0
call ___main
push 0
push dword ptr [ebp+12]
push dword ptr [ebp+8]
call _fb_Init@12
.L_0002:
push 0
push -1
push offset _B
push -1
push offset _A
call _fb_StrAssign@20
push 1
push offset _A
push 0
call _fb_PrintString@12
.L_0003:
push 0
call _fb_End@4
mov eax, dword ptr [ebp-4]
mov esp, ebp
pop ebp
ret

.section .bss
.balign 4
	.lcomm	_A,12
.balign 4
	.lcomm	_B,12
