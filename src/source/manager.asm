	.file	"manager.c"
	.intel_syntax noprefix
	.text
	.def	_ZN13ArrayIteratorIhE7ISVALIDEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN13ArrayIteratorIhE7ISVALIDEv
_ZN13ArrayIteratorIhE7ISVALIDEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	BYTE PTR -9[rbp], 0
.L2:
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	QWORD PTR -8[rbp], rax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR -8[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	edx, eax
	setl	al
	mov	BYTE PTR -9[rbp], al
	nop
.L3:
	movzx	eax, BYTE PTR -9[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN13ArrayIteratorIhE5VALUEEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN13ArrayIteratorIhE5VALUEEv
_ZN13ArrayIteratorIhE5VALUEEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR -16[rbp], 0
.L6:
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	QWORD PTR -8[rbp], rax
	mov	rax, QWORD PTR -8[rbp]
	mov	rdx, QWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	eax, DWORD PTR [rax]
	cdqe
	add	rax, rdx
	mov	QWORD PTR -16[rbp], rax
	nop
.L7:
	mov	rax, QWORD PTR -16[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN13ArrayIteratorIhE8MOVENEXTEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN13ArrayIteratorIhE8MOVENEXTEv
_ZN13ArrayIteratorIhE8MOVENEXTEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
.L10:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	add	edx, 1
	mov	DWORD PTR [rax], edx
	nop
	pop	rbp
	ret
.L11:
	.seh_endproc
	.def	_ZN5ArrayIhE5COUNTEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIhE5COUNTEv
_ZN5ArrayIhE5COUNTEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR -4[rbp], 0
.L13:
	mov	rax, QWORD PTR 16[rbp]
	mov	eax, DWORD PTR 72[rax]
	mov	DWORD PTR -4[rbp], eax
	nop
.L14:
	mov	eax, DWORD PTR -4[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIhE8CAPACITYEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIhE8CAPACITYEv
_ZN5ArrayIhE8CAPACITYEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 64
	.seh_stackalloc	64
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR -20[rbp], 0
.L17:
	mov	edx, 1
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayUBound
	mov	QWORD PTR -8[rbp], rax
	mov	edx, 1
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayLBound
	mov	QWORD PTR -16[rbp], rax
	mov	rax, QWORD PTR -8[rbp]
	mov	edx, eax
	mov	rax, QWORD PTR -16[rbp]
	sub	edx, eax
	mov	eax, edx
	add	eax, 1
	mov	DWORD PTR -20[rbp], eax
	nop
.L18:
	mov	eax, DWORD PTR -20[rbp]
	add	rsp, 64
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIhE7ISEMPTYEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIhE7ISEMPTYEv
_ZN5ArrayIhE7ISEMPTYEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	BYTE PTR -1[rbp], 0
.L21:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	sete	al
	mov	BYTE PTR -1[rbp], al
	nop
.L22:
	movzx	eax, BYTE PTR -1[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIhE7RESERVEEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIhE7RESERVEEi
_ZN5ArrayIhE7RESERVEEi:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 80
	.seh_stackalloc	80
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
.L25:
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIhE8CAPACITYEv
	mov	DWORD PTR -8[rbp], eax
	mov	eax, DWORD PTR 24[rbp]
	cmp	eax, DWORD PTR -8[rbp]
	jle	.L38
	nop
.L27:
.L29:
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIhE8CAPACITYEv
	mov	DWORD PTR -12[rbp], eax
	mov	eax, DWORD PTR -12[rbp]
	mov	DWORD PTR -4[rbp], eax
	cmp	DWORD PTR -4[rbp], 7
	jg	.L39
	mov	DWORD PTR -4[rbp], 8
	jmp	.L36
.L31:
.L32:
.L39:
	nop
.L33:
.L36:
	mov	eax, DWORD PTR -4[rbp]
	cmp	eax, DWORD PTR 24[rbp]
	jge	.L40
	mov	eax, DWORD PTR -4[rbp]
	cdqe
	add	rax, rax
	mov	DWORD PTR -4[rbp], eax
	jmp	.L36
.L40:
	nop
.L35:
	mov	eax, DWORD PTR -4[rbp]
	cdqe
	sub	rax, 1
	mov	QWORD PTR 48[rsp], rax
	mov	QWORD PTR 40[rsp], 0
	mov	QWORD PTR 32[rsp], 1
	mov	r9d, 0
	mov	r8d, -1
	mov	edx, 1
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayRedimPresvEx
	jmp	.L41
.L38:
	nop
.L28:
.L41:
	nop
	add	rsp, 80
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIhE6SHRINKEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIhE6SHRINKEv
_ZN5ArrayIhE6SHRINKEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 80
	.seh_stackalloc	80
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
.L43:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	jne	.L52
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayErase
	jmp	.L46
.L45:
.L52:
	nop
.L47:
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIhE8CAPACITYEv
	mov	DWORD PTR -4[rbp], eax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR -4[rbp], eax
	je	.L53
	nop
.L49:
.L50:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cdqe
	sub	rax, 1
	mov	QWORD PTR 48[rsp], rax
	mov	QWORD PTR 40[rsp], 0
	mov	QWORD PTR 32[rsp], 1
	mov	r9d, 0
	mov	r8d, -1
	mov	edx, 1
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayRedimPresvEx
	jmp	.L54
.L53:
	nop
.L46:
.L54:
	nop
	add	rsp, 80
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIhEixEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIhEixEi
_ZN5ArrayIhEixEi:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
	mov	QWORD PTR -8[rbp], 0
.L56:
	mov	rax, QWORD PTR 16[rbp]
	mov	rdx, QWORD PTR [rax]
	mov	eax, DWORD PTR 24[rbp]
	cdqe
	add	rax, rdx
	mov	QWORD PTR -8[rbp], rax
	nop
.L57:
	mov	rax, QWORD PTR -8[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIhE2ATEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIhE2ATEi
_ZN5ArrayIhE2ATEi:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
	mov	QWORD PTR -8[rbp], 0
.L60:
	mov	rax, QWORD PTR 16[rbp]
	mov	rdx, QWORD PTR [rax]
	mov	eax, DWORD PTR 24[rbp]
	cdqe
	add	rax, rdx
	mov	QWORD PTR -8[rbp], rax
	nop
.L61:
	mov	rax, QWORD PTR -8[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIhE4PUSHERh;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIhE4PUSHERh
_ZN5ArrayIhE4PUSHERh:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
.L64:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	add	eax, 1
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIhE7RESERVEEi
	mov	rax, QWORD PTR 16[rbp]
	mov	rdx, QWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cdqe
	add	rdx, rax
	mov	rax, QWORD PTR 24[rbp]
	movzx	eax, BYTE PTR [rax]
	mov	BYTE PTR [rdx], al
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	add	edx, 1
	mov	DWORD PTR [rax], edx
	nop
	add	rsp, 32
	pop	rbp
	ret
.L65:
	.seh_endproc
	.def	_ZN5ArrayIhE3POPEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIhE3POPEv
_ZN5ArrayIhE3POPEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	BYTE PTR -1[rbp], 0
.L67:
	mov	BYTE PTR -2[rbp], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	jne	.L74
	movzx	eax, BYTE PTR -2[rbp]
	mov	BYTE PTR -1[rbp], al
	jmp	.L70
.L69:
.L74:
	nop
.L71:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	sub	edx, 1
	mov	DWORD PTR [rax], edx
	mov	rax, QWORD PTR 16[rbp]
	mov	rdx, QWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cdqe
	add	rax, rdx
	movzx	eax, BYTE PTR [rax]
	mov	BYTE PTR -2[rbp], al
	movzx	eax, BYTE PTR -2[rbp]
	mov	BYTE PTR -1[rbp], al
	nop
.L70:
	movzx	eax, BYTE PTR -1[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIhE6INSERTEiRh;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIhE6INSERTEiRh
_ZN5ArrayIhE6INSERTEiRh:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 64
	.seh_stackalloc	64
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
	mov	QWORD PTR 32[rbp], r8
.L76:
	cmp	DWORD PTR 24[rbp], 0
	js	.L90
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR 24[rbp], eax
	setg	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -8[rbp], rax
	jmp	.L79
.L90:
	nop
.L78:
	mov	QWORD PTR -8[rbp], -1
.L79:
	cmp	QWORD PTR -8[rbp], 0
	jne	.L91
	nop
.L81:
.L83:
	mov	rax, QWORD PTR 32[rbp]
	movzx	eax, BYTE PTR [rax]
	mov	BYTE PTR -13[rbp], al
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	add	eax, 1
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIhE7RESERVEEi
	mov	rax, QWORD PTR 16[rbp]
	mov	eax, DWORD PTR 72[rax]
	mov	DWORD PTR -12[rbp], eax
	mov	eax, DWORD PTR 24[rbp]
	add	eax, 1
	mov	DWORD PTR -20[rbp], eax
	jmp	.L84
.L92:
	nop
.L85:
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR -12[rbp]
	movsx	rdx, edx
	sub	rdx, 1
	lea	rcx, [rax+rdx]
	mov	rax, QWORD PTR 16[rbp]
	mov	rdx, QWORD PTR [rax]
	mov	eax, DWORD PTR -12[rbp]
	cdqe
	add	rdx, rax
	movzx	eax, BYTE PTR [rcx]
	mov	BYTE PTR [rdx], al
.L86:
	sub	DWORD PTR -12[rbp], 1
.L84:
	mov	eax, DWORD PTR -12[rbp]
	cmp	eax, DWORD PTR -20[rbp]
	jge	.L92
	nop
.L87:
	mov	rax, QWORD PTR 16[rbp]
	mov	rdx, QWORD PTR [rax]
	mov	eax, DWORD PTR 24[rbp]
	cdqe
	add	rdx, rax
	movzx	eax, BYTE PTR -13[rbp]
	mov	BYTE PTR [rdx], al
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	add	edx, 1
	mov	DWORD PTR [rax], edx
	jmp	.L93
.L91:
	nop
.L82:
.L93:
	nop
	add	rsp, 64
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIhE6REMOVEEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIhE6REMOVEEi
_ZN5ArrayIhE6REMOVEEi:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
.L95:
	cmp	DWORD PTR 24[rbp], 0
	js	.L109
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR 24[rbp], eax
	setge	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -8[rbp], rax
	jmp	.L98
.L109:
	nop
.L97:
	mov	QWORD PTR -8[rbp], -1
.L98:
	cmp	QWORD PTR -8[rbp], 0
	jne	.L110
	nop
.L100:
.L102:
	mov	eax, DWORD PTR 24[rbp]
	mov	DWORD PTR -12[rbp], eax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	sub	eax, 2
	mov	DWORD PTR -16[rbp], eax
	jmp	.L103
.L111:
	nop
.L104:
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR -12[rbp]
	movsx	rdx, edx
	add	rdx, 1
	lea	rcx, [rax+rdx]
	mov	rax, QWORD PTR 16[rbp]
	mov	rdx, QWORD PTR [rax]
	mov	eax, DWORD PTR -12[rbp]
	cdqe
	add	rdx, rax
	movzx	eax, BYTE PTR [rcx]
	mov	BYTE PTR [rdx], al
.L105:
	add	DWORD PTR -12[rbp], 1
.L103:
	mov	eax, DWORD PTR -12[rbp]
	cmp	eax, DWORD PTR -16[rbp]
	jle	.L111
	nop
.L106:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	sub	edx, 1
	mov	DWORD PTR [rax], edx
	jmp	.L112
.L110:
	nop
.L101:
.L112:
	nop
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIhE10REMOVESWAPEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIhE10REMOVESWAPEi
_ZN5ArrayIhE10REMOVESWAPEi:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
.L114:
	cmp	DWORD PTR 24[rbp], 0
	js	.L126
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR 24[rbp], eax
	setge	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -8[rbp], rax
	jmp	.L117
.L126:
	nop
.L116:
	mov	QWORD PTR -8[rbp], -1
.L117:
	cmp	QWORD PTR -8[rbp], 0
	jne	.L127
	nop
.L119:
.L121:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	sub	edx, 1
	mov	DWORD PTR [rax], edx
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR 24[rbp], eax
	je	.L128
	mov	rax, QWORD PTR 16[rbp]
	mov	rdx, QWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cdqe
	lea	rcx, [rdx+rax]
	mov	rax, QWORD PTR 16[rbp]
	mov	rdx, QWORD PTR [rax]
	mov	eax, DWORD PTR 24[rbp]
	cdqe
	add	rdx, rax
	movzx	eax, BYTE PTR [rcx]
	mov	BYTE PTR [rdx], al
	jmp	.L129
.L120:
.L123:
.L127:
	nop
	jmp	.L129
.L128:
	nop
.L124:
.L129:
	nop
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIhE5CLEAREv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIhE5CLEAREv
_ZN5ArrayIhE5CLEAREv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
.L131:
	mov	BYTE PTR -9[rbp], 0
	mov	DWORD PTR -4[rbp], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	sub	eax, 1
	mov	DWORD PTR -8[rbp], eax
	jmp	.L132
.L138:
	nop
.L133:
	mov	rax, QWORD PTR 16[rbp]
	mov	rdx, QWORD PTR [rax]
	mov	eax, DWORD PTR -4[rbp]
	cdqe
	add	rdx, rax
	movzx	eax, BYTE PTR -9[rbp]
	mov	BYTE PTR [rdx], al
.L134:
	add	DWORD PTR -4[rbp], 1
.L132:
	mov	eax, DWORD PTR -4[rbp]
	cmp	eax, DWORD PTR -8[rbp]
	jle	.L138
	nop
.L135:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	DWORD PTR [rax], 0
	nop
	add	rsp, 16
	pop	rbp
	ret
.L136:
	.seh_endproc
	.def	_ZN5ArrayIhE11GETITERATOREv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIhE11GETITERATOREv
_ZN5ArrayIhE11GETITERATOREv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
	lea	rax, -16[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
.L140:
	lea	rax, -32[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	lea	rax, -32[rbp]
	mov	rdx, QWORD PTR 24[rbp]
	mov	QWORD PTR [rax], rdx
	lea	rax, -32[rbp]
	add	rax, 8
	mov	DWORD PTR [rax], 0
	mov	rax, QWORD PTR -32[rbp]
	mov	rdx, QWORD PTR -24[rbp]
	mov	QWORD PTR -16[rbp], rax
	mov	QWORD PTR -8[rbp], rdx
	nop
.L141:
	mov	rcx, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR -16[rbp]
	mov	rdx, QWORD PTR -8[rbp]
	mov	QWORD PTR [rcx], rax
	mov	QWORD PTR 8[rcx], rdx
	mov	rax, QWORD PTR 16[rbp]
	add	rsp, 32
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN13ArrayIteratorI8FBSTRINGE7ISVALIDEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN13ArrayIteratorI8FBSTRINGE7ISVALIDEv
_ZN13ArrayIteratorI8FBSTRINGE7ISVALIDEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	BYTE PTR -9[rbp], 0
.L144:
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	QWORD PTR -8[rbp], rax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR -8[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	edx, eax
	setl	al
	mov	BYTE PTR -9[rbp], al
	nop
.L145:
	movzx	eax, BYTE PTR -9[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN13ArrayIteratorI8FBSTRINGE5VALUEEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN13ArrayIteratorI8FBSTRINGE5VALUEEv
_ZN13ArrayIteratorI8FBSTRINGE5VALUEEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR -16[rbp], 0
.L148:
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	QWORD PTR -8[rbp], rax
	mov	rax, QWORD PTR -8[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	eax, DWORD PTR [rax]
	movsx	rdx, eax
	mov	rax, rdx
	add	rax, rax
	add	rax, rdx
	sal	rax, 3
	add	rax, rcx
	mov	QWORD PTR -16[rbp], rax
	nop
.L149:
	mov	rax, QWORD PTR -16[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN13ArrayIteratorI8FBSTRINGE8MOVENEXTEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN13ArrayIteratorI8FBSTRINGE8MOVENEXTEv
_ZN13ArrayIteratorI8FBSTRINGE8MOVENEXTEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
.L152:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	add	edx, 1
	mov	DWORD PTR [rax], edx
	nop
	pop	rbp
	ret
.L153:
	.seh_endproc
	.def	_ZN5ArrayI8FBSTRINGE5COUNTEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayI8FBSTRINGE5COUNTEv
_ZN5ArrayI8FBSTRINGE5COUNTEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR -4[rbp], 0
.L155:
	mov	rax, QWORD PTR 16[rbp]
	mov	eax, DWORD PTR 72[rax]
	mov	DWORD PTR -4[rbp], eax
	nop
.L156:
	mov	eax, DWORD PTR -4[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayI8FBSTRINGE8CAPACITYEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayI8FBSTRINGE8CAPACITYEv
_ZN5ArrayI8FBSTRINGE8CAPACITYEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 64
	.seh_stackalloc	64
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR -20[rbp], 0
.L159:
	mov	edx, 1
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayUBound
	mov	QWORD PTR -8[rbp], rax
	mov	edx, 1
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayLBound
	mov	QWORD PTR -16[rbp], rax
	mov	rax, QWORD PTR -8[rbp]
	mov	edx, eax
	mov	rax, QWORD PTR -16[rbp]
	sub	edx, eax
	mov	eax, edx
	add	eax, 1
	mov	DWORD PTR -20[rbp], eax
	nop
.L160:
	mov	eax, DWORD PTR -20[rbp]
	add	rsp, 64
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayI8FBSTRINGE7ISEMPTYEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayI8FBSTRINGE7ISEMPTYEv
_ZN5ArrayI8FBSTRINGE7ISEMPTYEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	BYTE PTR -1[rbp], 0
.L163:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	sete	al
	mov	BYTE PTR -1[rbp], al
	nop
.L164:
	movzx	eax, BYTE PTR -1[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayI8FBSTRINGE7RESERVEEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayI8FBSTRINGE7RESERVEEi
_ZN5ArrayI8FBSTRINGE7RESERVEEi:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 80
	.seh_stackalloc	80
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
.L167:
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayI8FBSTRINGE8CAPACITYEv
	mov	DWORD PTR -8[rbp], eax
	mov	eax, DWORD PTR 24[rbp]
	cmp	eax, DWORD PTR -8[rbp]
	jle	.L180
	nop
.L169:
.L171:
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayI8FBSTRINGE8CAPACITYEv
	mov	DWORD PTR -12[rbp], eax
	mov	eax, DWORD PTR -12[rbp]
	mov	DWORD PTR -4[rbp], eax
	cmp	DWORD PTR -4[rbp], 7
	jg	.L181
	mov	DWORD PTR -4[rbp], 8
	jmp	.L178
.L173:
.L174:
.L181:
	nop
.L175:
.L178:
	mov	eax, DWORD PTR -4[rbp]
	cmp	eax, DWORD PTR 24[rbp]
	jge	.L182
	mov	eax, DWORD PTR -4[rbp]
	cdqe
	add	rax, rax
	mov	DWORD PTR -4[rbp], eax
	jmp	.L178
.L182:
	nop
.L177:
	mov	eax, DWORD PTR -4[rbp]
	cdqe
	sub	rax, 1
	mov	QWORD PTR 48[rsp], rax
	mov	QWORD PTR 40[rsp], 0
	mov	QWORD PTR 32[rsp], 1
	mov	r9d, -1
	mov	r8d, -1
	mov	edx, 24
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayRedimPresvEx
	jmp	.L183
.L180:
	nop
.L170:
.L183:
	nop
	add	rsp, 80
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayI8FBSTRINGE6SHRINKEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayI8FBSTRINGE6SHRINKEv
_ZN5ArrayI8FBSTRINGE6SHRINKEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 80
	.seh_stackalloc	80
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
.L185:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	jne	.L194
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayStrErase
	jmp	.L188
.L187:
.L194:
	nop
.L189:
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayI8FBSTRINGE8CAPACITYEv
	mov	DWORD PTR -4[rbp], eax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR -4[rbp], eax
	je	.L195
	nop
.L191:
.L192:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cdqe
	sub	rax, 1
	mov	QWORD PTR 48[rsp], rax
	mov	QWORD PTR 40[rsp], 0
	mov	QWORD PTR 32[rsp], 1
	mov	r9d, -1
	mov	r8d, -1
	mov	edx, 24
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayRedimPresvEx
	jmp	.L196
.L195:
	nop
.L188:
.L196:
	nop
	add	rsp, 80
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayI8FBSTRINGEixEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayI8FBSTRINGEixEi
_ZN5ArrayI8FBSTRINGEixEi:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
	mov	QWORD PTR -8[rbp], 0
.L198:
	mov	rax, QWORD PTR 16[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	eax, DWORD PTR 24[rbp]
	movsx	rdx, eax
	mov	rax, rdx
	add	rax, rax
	add	rax, rdx
	sal	rax, 3
	add	rax, rcx
	mov	QWORD PTR -8[rbp], rax
	nop
.L199:
	mov	rax, QWORD PTR -8[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayI8FBSTRINGE2ATEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayI8FBSTRINGE2ATEi
_ZN5ArrayI8FBSTRINGE2ATEi:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
	mov	QWORD PTR -8[rbp], 0
.L202:
	mov	rax, QWORD PTR 16[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	eax, DWORD PTR 24[rbp]
	movsx	rdx, eax
	mov	rax, rdx
	add	rax, rax
	add	rax, rdx
	sal	rax, 3
	add	rax, rcx
	mov	QWORD PTR -8[rbp], rax
	nop
.L203:
	mov	rax, QWORD PTR -8[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayI8FBSTRINGE4PUSHERS0_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayI8FBSTRINGE4PUSHERS0_
_ZN5ArrayI8FBSTRINGE4PUSHERS0_:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 48
	.seh_stackalloc	48
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
.L206:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	add	eax, 1
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayI8FBSTRINGE7RESERVEEi
	mov	rax, QWORD PTR 16[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	movsx	rdx, eax
	mov	rax, rdx
	add	rax, rax
	add	rax, rdx
	sal	rax, 3
	add	rax, rcx
	mov	rdx, QWORD PTR 24[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrAssign
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	add	edx, 1
	mov	DWORD PTR [rax], edx
	nop
	add	rsp, 48
	pop	rbp
	ret
.L207:
	.seh_endproc
	.def	_ZN5ArrayI8FBSTRINGE3POPEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayI8FBSTRINGE3POPEv
_ZN5ArrayI8FBSTRINGE3POPEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 112
	.seh_stackalloc	112
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	lea	rax, -32[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
.L209:
	lea	rax, -64[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	jne	.L216
	lea	rdx, -64[rbp]
	lea	rax, -32[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrInit
	lea	rax, -64[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	jmp	.L212
.L211:
.L216:
	nop
.L213:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	sub	edx, 1
	mov	DWORD PTR [rax], edx
	mov	rax, QWORD PTR 16[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	movsx	rdx, eax
	mov	rax, rdx
	add	rax, rax
	add	rax, rdx
	sal	rax, 3
	lea	rdx, [rcx+rax]
	lea	rax, -64[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrAssign
	lea	rdx, -64[rbp]
	lea	rax, -32[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrInit
	lea	rax, -64[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	nop
.L212:
	lea	rax, -32[rbp]
	mov	rcx, rax
	call	fb_StrAllocTempResult
	mov	QWORD PTR -8[rbp], rax
	mov	rax, QWORD PTR -8[rbp]
	add	rsp, 112
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayI8FBSTRINGE6INSERTEiRS0_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayI8FBSTRINGE6INSERTEiRS0_
_ZN5ArrayI8FBSTRINGE6INSERTEiRS0_:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 96
	.seh_stackalloc	96
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
	mov	QWORD PTR 32[rbp], r8
.L218:
	cmp	DWORD PTR 24[rbp], 0
	js	.L232
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR 24[rbp], eax
	setg	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -8[rbp], rax
	jmp	.L221
.L232:
	nop
.L220:
	mov	QWORD PTR -8[rbp], -1
.L221:
	cmp	QWORD PTR -8[rbp], 0
	jne	.L233
	nop
.L223:
.L225:
	mov	rdx, QWORD PTR 32[rbp]
	lea	rax, -48[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrInit
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	add	eax, 1
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayI8FBSTRINGE7RESERVEEi
	mov	rax, QWORD PTR 16[rbp]
	mov	eax, DWORD PTR 72[rax]
	mov	DWORD PTR -12[rbp], eax
	mov	eax, DWORD PTR 24[rbp]
	add	eax, 1
	mov	DWORD PTR -16[rbp], eax
	jmp	.L226
.L234:
	nop
.L227:
	mov	rax, QWORD PTR 16[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	eax, DWORD PTR -12[rbp]
	movsx	rdx, eax
	mov	rax, rdx
	add	rax, rax
	add	rax, rdx
	sal	rax, 3
	sub	rax, 24
	lea	r8, [rcx+rax]
	mov	rax, QWORD PTR 16[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	eax, DWORD PTR -12[rbp]
	movsx	rdx, eax
	mov	rax, rdx
	add	rax, rax
	add	rax, rdx
	sal	rax, 3
	add	rax, rcx
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrAssign
.L228:
	sub	DWORD PTR -12[rbp], 1
.L226:
	mov	eax, DWORD PTR -12[rbp]
	cmp	eax, DWORD PTR -16[rbp]
	jge	.L234
	nop
.L229:
	mov	rax, QWORD PTR 16[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	eax, DWORD PTR 24[rbp]
	movsx	rdx, eax
	mov	rax, rdx
	add	rax, rax
	add	rax, rdx
	sal	rax, 3
	add	rax, rcx
	lea	rdx, -48[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrAssign
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	add	edx, 1
	mov	DWORD PTR [rax], edx
	lea	rax, -48[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	jmp	.L235
.L233:
	nop
.L224:
.L235:
	nop
	add	rsp, 96
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayI8FBSTRINGE6REMOVEEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayI8FBSTRINGE6REMOVEEi
_ZN5ArrayI8FBSTRINGE6REMOVEEi:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 64
	.seh_stackalloc	64
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
.L237:
	cmp	DWORD PTR 24[rbp], 0
	js	.L251
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR 24[rbp], eax
	setge	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -8[rbp], rax
	jmp	.L240
.L251:
	nop
.L239:
	mov	QWORD PTR -8[rbp], -1
.L240:
	cmp	QWORD PTR -8[rbp], 0
	jne	.L252
	nop
.L242:
.L244:
	mov	eax, DWORD PTR 24[rbp]
	mov	DWORD PTR -12[rbp], eax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	sub	eax, 2
	mov	DWORD PTR -16[rbp], eax
	jmp	.L245
.L253:
	nop
.L246:
	mov	rax, QWORD PTR 16[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	eax, DWORD PTR -12[rbp]
	movsx	rdx, eax
	mov	rax, rdx
	add	rax, rax
	add	rax, rdx
	sal	rax, 3
	add	rax, 24
	lea	r8, [rcx+rax]
	mov	rax, QWORD PTR 16[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	eax, DWORD PTR -12[rbp]
	movsx	rdx, eax
	mov	rax, rdx
	add	rax, rax
	add	rax, rdx
	sal	rax, 3
	add	rax, rcx
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrAssign
.L247:
	add	DWORD PTR -12[rbp], 1
.L245:
	mov	eax, DWORD PTR -12[rbp]
	cmp	eax, DWORD PTR -16[rbp]
	jle	.L253
	nop
.L248:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	sub	edx, 1
	mov	DWORD PTR [rax], edx
	jmp	.L254
.L252:
	nop
.L243:
.L254:
	nop
	add	rsp, 64
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayI8FBSTRINGE10REMOVESWAPEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayI8FBSTRINGE10REMOVESWAPEi
_ZN5ArrayI8FBSTRINGE10REMOVESWAPEi:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 64
	.seh_stackalloc	64
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
.L256:
	cmp	DWORD PTR 24[rbp], 0
	js	.L268
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR 24[rbp], eax
	setge	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -8[rbp], rax
	jmp	.L259
.L268:
	nop
.L258:
	mov	QWORD PTR -8[rbp], -1
.L259:
	cmp	QWORD PTR -8[rbp], 0
	jne	.L269
	nop
.L261:
.L263:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	sub	edx, 1
	mov	DWORD PTR [rax], edx
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR 24[rbp], eax
	je	.L270
	mov	rax, QWORD PTR 16[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	movsx	rdx, eax
	mov	rax, rdx
	add	rax, rax
	add	rax, rdx
	sal	rax, 3
	lea	r8, [rcx+rax]
	mov	rax, QWORD PTR 16[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	eax, DWORD PTR 24[rbp]
	movsx	rdx, eax
	mov	rax, rdx
	add	rax, rax
	add	rax, rdx
	sal	rax, 3
	add	rax, rcx
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrAssign
	jmp	.L271
.L262:
.L265:
.L269:
	nop
	jmp	.L271
.L270:
	nop
.L266:
.L271:
	nop
	add	rsp, 64
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayI8FBSTRINGE5CLEAREv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayI8FBSTRINGE5CLEAREv
_ZN5ArrayI8FBSTRINGE5CLEAREv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 80
	.seh_stackalloc	80
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
.L273:
	lea	rax, -32[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	DWORD PTR -4[rbp], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	sub	eax, 1
	mov	DWORD PTR -8[rbp], eax
	jmp	.L274
.L280:
	nop
.L275:
	mov	rax, QWORD PTR 16[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	eax, DWORD PTR -4[rbp]
	movsx	rdx, eax
	mov	rax, rdx
	add	rax, rax
	add	rax, rdx
	sal	rax, 3
	add	rax, rcx
	lea	rdx, -32[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrAssign
.L276:
	add	DWORD PTR -4[rbp], 1
.L274:
	mov	eax, DWORD PTR -4[rbp]
	cmp	eax, DWORD PTR -8[rbp]
	jle	.L280
	nop
.L277:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	DWORD PTR [rax], 0
	lea	rax, -32[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	nop
	add	rsp, 80
	pop	rbp
	ret
.L278:
	.seh_endproc
	.def	_ZN5ArrayI8FBSTRINGE11GETITERATOREv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayI8FBSTRINGE11GETITERATOREv
_ZN5ArrayI8FBSTRINGE11GETITERATOREv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
	lea	rax, -16[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
.L282:
	lea	rax, -32[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	lea	rax, -32[rbp]
	mov	rdx, QWORD PTR 24[rbp]
	mov	QWORD PTR [rax], rdx
	lea	rax, -32[rbp]
	add	rax, 8
	mov	DWORD PTR [rax], 0
	mov	rax, QWORD PTR -32[rbp]
	mov	rdx, QWORD PTR -24[rbp]
	mov	QWORD PTR -16[rbp], rax
	mov	QWORD PTR -8[rbp], rdx
	nop
.L283:
	mov	rcx, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR -16[rbp]
	mov	rdx, QWORD PTR -8[rbp]
	mov	QWORD PTR [rcx], rax
	mov	QWORD PTR 8[rcx], rdx
	mov	rax, QWORD PTR 16[rbp]
	add	rsp, 32
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN13ArrayIteratorIPvE7ISVALIDEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN13ArrayIteratorIPvE7ISVALIDEv
_ZN13ArrayIteratorIPvE7ISVALIDEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	BYTE PTR -9[rbp], 0
.L286:
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	QWORD PTR -8[rbp], rax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR -8[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	edx, eax
	setl	al
	mov	BYTE PTR -9[rbp], al
	nop
.L287:
	movzx	eax, BYTE PTR -9[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN13ArrayIteratorIPvE5VALUEEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN13ArrayIteratorIPvE5VALUEEv
_ZN13ArrayIteratorIPvE5VALUEEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR -16[rbp], 0
.L290:
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	QWORD PTR -8[rbp], rax
	mov	rax, QWORD PTR -8[rbp]
	mov	rax, QWORD PTR [rax]
	mov	rdx, QWORD PTR 16[rbp]
	add	rdx, 8
	mov	edx, DWORD PTR [rdx]
	movsx	rdx, edx
	sal	rdx, 3
	add	rax, rdx
	mov	QWORD PTR -16[rbp], rax
	nop
.L291:
	mov	rax, QWORD PTR -16[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN13ArrayIteratorIPvE8MOVENEXTEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN13ArrayIteratorIPvE8MOVENEXTEv
_ZN13ArrayIteratorIPvE8MOVENEXTEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
.L294:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	add	edx, 1
	mov	DWORD PTR [rax], edx
	nop
	pop	rbp
	ret
.L295:
	.seh_endproc
	.def	_ZN5ArrayIPvE5COUNTEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIPvE5COUNTEv
_ZN5ArrayIPvE5COUNTEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR -4[rbp], 0
.L297:
	mov	rax, QWORD PTR 16[rbp]
	mov	eax, DWORD PTR 72[rax]
	mov	DWORD PTR -4[rbp], eax
	nop
.L298:
	mov	eax, DWORD PTR -4[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIPvE8CAPACITYEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIPvE8CAPACITYEv
_ZN5ArrayIPvE8CAPACITYEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 64
	.seh_stackalloc	64
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR -20[rbp], 0
.L301:
	mov	edx, 1
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayUBound
	mov	QWORD PTR -8[rbp], rax
	mov	edx, 1
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayLBound
	mov	QWORD PTR -16[rbp], rax
	mov	rax, QWORD PTR -8[rbp]
	mov	edx, eax
	mov	rax, QWORD PTR -16[rbp]
	sub	edx, eax
	mov	eax, edx
	add	eax, 1
	mov	DWORD PTR -20[rbp], eax
	nop
.L302:
	mov	eax, DWORD PTR -20[rbp]
	add	rsp, 64
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIPvE7ISEMPTYEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIPvE7ISEMPTYEv
_ZN5ArrayIPvE7ISEMPTYEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	BYTE PTR -1[rbp], 0
.L305:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	sete	al
	mov	BYTE PTR -1[rbp], al
	nop
.L306:
	movzx	eax, BYTE PTR -1[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIPvE7RESERVEEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIPvE7RESERVEEi
_ZN5ArrayIPvE7RESERVEEi:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 80
	.seh_stackalloc	80
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
.L309:
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIPvE8CAPACITYEv
	mov	DWORD PTR -8[rbp], eax
	mov	eax, DWORD PTR 24[rbp]
	cmp	eax, DWORD PTR -8[rbp]
	jle	.L322
	nop
.L311:
.L313:
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIPvE8CAPACITYEv
	mov	DWORD PTR -12[rbp], eax
	mov	eax, DWORD PTR -12[rbp]
	mov	DWORD PTR -4[rbp], eax
	cmp	DWORD PTR -4[rbp], 7
	jg	.L323
	mov	DWORD PTR -4[rbp], 8
	jmp	.L320
.L315:
.L316:
.L323:
	nop
.L317:
.L320:
	mov	eax, DWORD PTR -4[rbp]
	cmp	eax, DWORD PTR 24[rbp]
	jge	.L324
	mov	eax, DWORD PTR -4[rbp]
	cdqe
	add	rax, rax
	mov	DWORD PTR -4[rbp], eax
	jmp	.L320
.L324:
	nop
.L319:
	mov	eax, DWORD PTR -4[rbp]
	cdqe
	sub	rax, 1
	mov	QWORD PTR 48[rsp], rax
	mov	QWORD PTR 40[rsp], 0
	mov	QWORD PTR 32[rsp], 1
	mov	r9d, 0
	mov	r8d, -1
	mov	edx, 8
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayRedimPresvEx
	jmp	.L325
.L322:
	nop
.L312:
.L325:
	nop
	add	rsp, 80
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIPvE6SHRINKEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIPvE6SHRINKEv
_ZN5ArrayIPvE6SHRINKEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 80
	.seh_stackalloc	80
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
.L327:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	jne	.L336
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayErase
	jmp	.L330
.L329:
.L336:
	nop
.L331:
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIPvE8CAPACITYEv
	mov	DWORD PTR -4[rbp], eax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR -4[rbp], eax
	je	.L337
	nop
.L333:
.L334:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cdqe
	sub	rax, 1
	mov	QWORD PTR 48[rsp], rax
	mov	QWORD PTR 40[rsp], 0
	mov	QWORD PTR 32[rsp], 1
	mov	r9d, 0
	mov	r8d, -1
	mov	edx, 8
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayRedimPresvEx
	jmp	.L338
.L337:
	nop
.L330:
.L338:
	nop
	add	rsp, 80
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIPvEixEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIPvEixEi
_ZN5ArrayIPvEixEi:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
	mov	QWORD PTR -8[rbp], 0
.L340:
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 24[rbp]
	movsx	rdx, edx
	sal	rdx, 3
	add	rax, rdx
	mov	QWORD PTR -8[rbp], rax
	nop
.L341:
	mov	rax, QWORD PTR -8[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIPvE2ATEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIPvE2ATEi
_ZN5ArrayIPvE2ATEi:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
	mov	QWORD PTR -8[rbp], 0
.L344:
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 24[rbp]
	movsx	rdx, edx
	sal	rdx, 3
	add	rax, rdx
	mov	QWORD PTR -8[rbp], rax
	nop
.L345:
	mov	rax, QWORD PTR -8[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIPvE4PUSHERS0_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIPvE4PUSHERS0_
_ZN5ArrayIPvE4PUSHERS0_:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
.L348:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	add	eax, 1
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIPvE7RESERVEEi
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	rdx, QWORD PTR 16[rbp]
	add	rdx, 72
	mov	edx, DWORD PTR [rdx]
	movsx	rdx, edx
	sal	rdx, 3
	add	rdx, rax
	mov	rax, QWORD PTR 24[rbp]
	mov	rax, QWORD PTR [rax]
	mov	QWORD PTR [rdx], rax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	add	edx, 1
	mov	DWORD PTR [rax], edx
	nop
	add	rsp, 32
	pop	rbp
	ret
.L349:
	.seh_endproc
	.def	_ZN5ArrayIPvE3POPEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIPvE3POPEv
_ZN5ArrayIPvE3POPEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR -8[rbp], 0
.L351:
	mov	QWORD PTR -16[rbp], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	jne	.L358
	mov	rax, QWORD PTR -16[rbp]
	mov	QWORD PTR -8[rbp], rax
	jmp	.L354
.L353:
.L358:
	nop
.L355:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	sub	edx, 1
	mov	DWORD PTR [rax], edx
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	rdx, QWORD PTR 16[rbp]
	add	rdx, 72
	mov	edx, DWORD PTR [rdx]
	movsx	rdx, edx
	sal	rdx, 3
	add	rax, rdx
	mov	rax, QWORD PTR [rax]
	mov	QWORD PTR -16[rbp], rax
	mov	rax, QWORD PTR -16[rbp]
	mov	QWORD PTR -8[rbp], rax
	nop
.L354:
	mov	rax, QWORD PTR -8[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIPvE6INSERTEiRS0_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIPvE6INSERTEiRS0_
_ZN5ArrayIPvE6INSERTEiRS0_:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 64
	.seh_stackalloc	64
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
	mov	QWORD PTR 32[rbp], r8
.L360:
	cmp	DWORD PTR 24[rbp], 0
	js	.L374
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR 24[rbp], eax
	setg	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -8[rbp], rax
	jmp	.L363
.L374:
	nop
.L362:
	mov	QWORD PTR -8[rbp], -1
.L363:
	cmp	QWORD PTR -8[rbp], 0
	jne	.L375
	nop
.L365:
.L367:
	mov	rax, QWORD PTR 32[rbp]
	mov	rax, QWORD PTR [rax]
	mov	QWORD PTR -24[rbp], rax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	add	eax, 1
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIPvE7RESERVEEi
	mov	rax, QWORD PTR 16[rbp]
	mov	eax, DWORD PTR 72[rax]
	mov	DWORD PTR -12[rbp], eax
	mov	eax, DWORD PTR 24[rbp]
	add	eax, 1
	mov	DWORD PTR -28[rbp], eax
	jmp	.L368
.L376:
	nop
.L369:
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR -12[rbp]
	movsx	rdx, edx
	sal	rdx, 3
	sub	rdx, 8
	lea	rcx, [rax+rdx]
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR -12[rbp]
	movsx	rdx, edx
	sal	rdx, 3
	add	rdx, rax
	mov	rax, QWORD PTR [rcx]
	mov	QWORD PTR [rdx], rax
.L370:
	sub	DWORD PTR -12[rbp], 1
.L368:
	mov	eax, DWORD PTR -12[rbp]
	cmp	eax, DWORD PTR -28[rbp]
	jge	.L376
	nop
.L371:
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 24[rbp]
	movsx	rdx, edx
	sal	rdx, 3
	add	rdx, rax
	mov	rax, QWORD PTR -24[rbp]
	mov	QWORD PTR [rdx], rax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	add	edx, 1
	mov	DWORD PTR [rax], edx
	jmp	.L377
.L375:
	nop
.L366:
.L377:
	nop
	add	rsp, 64
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIPvE6REMOVEEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIPvE6REMOVEEi
_ZN5ArrayIPvE6REMOVEEi:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
.L379:
	cmp	DWORD PTR 24[rbp], 0
	js	.L393
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR 24[rbp], eax
	setge	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -8[rbp], rax
	jmp	.L382
.L393:
	nop
.L381:
	mov	QWORD PTR -8[rbp], -1
.L382:
	cmp	QWORD PTR -8[rbp], 0
	jne	.L394
	nop
.L384:
.L386:
	mov	eax, DWORD PTR 24[rbp]
	mov	DWORD PTR -12[rbp], eax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	sub	eax, 2
	mov	DWORD PTR -16[rbp], eax
	jmp	.L387
.L395:
	nop
.L388:
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR -12[rbp]
	movsx	rdx, edx
	sal	rdx, 3
	add	rdx, 8
	lea	rcx, [rax+rdx]
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR -12[rbp]
	movsx	rdx, edx
	sal	rdx, 3
	add	rdx, rax
	mov	rax, QWORD PTR [rcx]
	mov	QWORD PTR [rdx], rax
.L389:
	add	DWORD PTR -12[rbp], 1
.L387:
	mov	eax, DWORD PTR -12[rbp]
	cmp	eax, DWORD PTR -16[rbp]
	jle	.L395
	nop
.L390:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	sub	edx, 1
	mov	DWORD PTR [rax], edx
	jmp	.L396
.L394:
	nop
.L385:
.L396:
	nop
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIPvE10REMOVESWAPEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIPvE10REMOVESWAPEi
_ZN5ArrayIPvE10REMOVESWAPEi:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
.L398:
	cmp	DWORD PTR 24[rbp], 0
	js	.L410
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR 24[rbp], eax
	setge	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -8[rbp], rax
	jmp	.L401
.L410:
	nop
.L400:
	mov	QWORD PTR -8[rbp], -1
.L401:
	cmp	QWORD PTR -8[rbp], 0
	jne	.L411
	nop
.L403:
.L405:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	sub	edx, 1
	mov	DWORD PTR [rax], edx
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR 24[rbp], eax
	je	.L412
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	rdx, QWORD PTR 16[rbp]
	add	rdx, 72
	mov	edx, DWORD PTR [rdx]
	movsx	rdx, edx
	sal	rdx, 3
	lea	rcx, [rax+rdx]
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 24[rbp]
	movsx	rdx, edx
	sal	rdx, 3
	add	rdx, rax
	mov	rax, QWORD PTR [rcx]
	mov	QWORD PTR [rdx], rax
	jmp	.L413
.L404:
.L407:
.L411:
	nop
	jmp	.L413
.L412:
	nop
.L408:
.L413:
	nop
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIPvE5CLEAREv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIPvE5CLEAREv
_ZN5ArrayIPvE5CLEAREv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
.L415:
	mov	QWORD PTR -16[rbp], 0
	mov	DWORD PTR -4[rbp], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	sub	eax, 1
	mov	DWORD PTR -8[rbp], eax
	jmp	.L416
.L422:
	nop
.L417:
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR -4[rbp]
	movsx	rdx, edx
	sal	rdx, 3
	add	rdx, rax
	mov	rax, QWORD PTR -16[rbp]
	mov	QWORD PTR [rdx], rax
.L418:
	add	DWORD PTR -4[rbp], 1
.L416:
	mov	eax, DWORD PTR -4[rbp]
	cmp	eax, DWORD PTR -8[rbp]
	jle	.L422
	nop
.L419:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	DWORD PTR [rax], 0
	nop
	add	rsp, 16
	pop	rbp
	ret
.L420:
	.seh_endproc
	.def	_ZN5ArrayIPvE11GETITERATOREv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIPvE11GETITERATOREv
_ZN5ArrayIPvE11GETITERATOREv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
	lea	rax, -16[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
.L424:
	lea	rax, -32[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	lea	rax, -32[rbp]
	mov	rdx, QWORD PTR 24[rbp]
	mov	QWORD PTR [rax], rdx
	lea	rax, -32[rbp]
	add	rax, 8
	mov	DWORD PTR [rax], 0
	mov	rax, QWORD PTR -32[rbp]
	mov	rdx, QWORD PTR -24[rbp]
	mov	QWORD PTR -16[rbp], rax
	mov	QWORD PTR -8[rbp], rdx
	nop
.L425:
	mov	rcx, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR -16[rbp]
	mov	rdx, QWORD PTR -8[rbp]
	mov	QWORD PTR [rcx], rax
	mov	QWORD PTR 8[rcx], rdx
	mov	rax, QWORD PTR 16[rbp]
	add	rsp, 32
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN13ArrayIteratorIN3TKO11INTERNENTRYEE7ISVALIDEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN13ArrayIteratorIN3TKO11INTERNENTRYEE7ISVALIDEv
_ZN13ArrayIteratorIN3TKO11INTERNENTRYEE7ISVALIDEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	BYTE PTR -9[rbp], 0
.L428:
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	QWORD PTR -8[rbp], rax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR -8[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	edx, eax
	setl	al
	mov	BYTE PTR -9[rbp], al
	nop
.L429:
	movzx	eax, BYTE PTR -9[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN13ArrayIteratorIN3TKO11INTERNENTRYEE5VALUEEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN13ArrayIteratorIN3TKO11INTERNENTRYEE5VALUEEv
_ZN13ArrayIteratorIN3TKO11INTERNENTRYEE5VALUEEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR -16[rbp], 0
.L432:
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	QWORD PTR -8[rbp], rax
	mov	rax, QWORD PTR -8[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	eax, DWORD PTR [rax]
	movsx	rdx, eax
	mov	rax, rdx
	add	rax, rax
	add	rax, rdx
	sal	rax, 3
	add	rax, rcx
	mov	QWORD PTR -16[rbp], rax
	nop
.L433:
	mov	rax, QWORD PTR -16[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN13ArrayIteratorIN3TKO11INTERNENTRYEE8MOVENEXTEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN13ArrayIteratorIN3TKO11INTERNENTRYEE8MOVENEXTEv
_ZN13ArrayIteratorIN3TKO11INTERNENTRYEE8MOVENEXTEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
.L436:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	add	edx, 1
	mov	DWORD PTR [rax], edx
	nop
	pop	rbp
	ret
.L437:
	.seh_endproc
	.def	_ZN5ArrayIN3TKO11INTERNENTRYEE5COUNTEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO11INTERNENTRYEE5COUNTEv
_ZN5ArrayIN3TKO11INTERNENTRYEE5COUNTEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR -4[rbp], 0
.L439:
	mov	rax, QWORD PTR 16[rbp]
	mov	eax, DWORD PTR 72[rax]
	mov	DWORD PTR -4[rbp], eax
	nop
.L440:
	mov	eax, DWORD PTR -4[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO11INTERNENTRYEE8CAPACITYEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO11INTERNENTRYEE8CAPACITYEv
_ZN5ArrayIN3TKO11INTERNENTRYEE8CAPACITYEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 64
	.seh_stackalloc	64
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR -20[rbp], 0
.L443:
	mov	edx, 1
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayUBound
	mov	QWORD PTR -8[rbp], rax
	mov	edx, 1
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayLBound
	mov	QWORD PTR -16[rbp], rax
	mov	rax, QWORD PTR -8[rbp]
	mov	edx, eax
	mov	rax, QWORD PTR -16[rbp]
	sub	edx, eax
	mov	eax, edx
	add	eax, 1
	mov	DWORD PTR -20[rbp], eax
	nop
.L444:
	mov	eax, DWORD PTR -20[rbp]
	add	rsp, 64
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO11INTERNENTRYEE7ISEMPTYEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO11INTERNENTRYEE7ISEMPTYEv
_ZN5ArrayIN3TKO11INTERNENTRYEE7ISEMPTYEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	BYTE PTR -1[rbp], 0
.L447:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	sete	al
	mov	BYTE PTR -1[rbp], al
	nop
.L448:
	movzx	eax, BYTE PTR -1[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO11INTERNENTRYEE7RESERVEEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO11INTERNENTRYEE7RESERVEEi
_ZN5ArrayIN3TKO11INTERNENTRYEE7RESERVEEi:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 80
	.seh_stackalloc	80
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
.L451:
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIN3TKO11INTERNENTRYEE8CAPACITYEv
	mov	DWORD PTR -8[rbp], eax
	mov	eax, DWORD PTR 24[rbp]
	cmp	eax, DWORD PTR -8[rbp]
	jle	.L464
	nop
.L453:
.L455:
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIN3TKO11INTERNENTRYEE8CAPACITYEv
	mov	DWORD PTR -12[rbp], eax
	mov	eax, DWORD PTR -12[rbp]
	mov	DWORD PTR -4[rbp], eax
	cmp	DWORD PTR -4[rbp], 7
	jg	.L465
	mov	DWORD PTR -4[rbp], 8
	jmp	.L462
.L457:
.L458:
.L465:
	nop
.L459:
.L462:
	mov	eax, DWORD PTR -4[rbp]
	cmp	eax, DWORD PTR 24[rbp]
	jge	.L466
	mov	eax, DWORD PTR -4[rbp]
	cdqe
	add	rax, rax
	mov	DWORD PTR -4[rbp], eax
	jmp	.L462
.L466:
	nop
.L461:
	mov	eax, DWORD PTR -4[rbp]
	cdqe
	sub	rax, 1
	mov	QWORD PTR 48[rsp], rax
	mov	QWORD PTR 40[rsp], 0
	mov	QWORD PTR 32[rsp], 1
	mov	r9d, 0
	mov	r8d, -1
	mov	edx, 24
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayRedimPresvEx
	jmp	.L467
.L464:
	nop
.L454:
.L467:
	nop
	add	rsp, 80
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO11INTERNENTRYEE6SHRINKEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO11INTERNENTRYEE6SHRINKEv
_ZN5ArrayIN3TKO11INTERNENTRYEE6SHRINKEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 80
	.seh_stackalloc	80
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
.L469:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	jne	.L478
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayErase
	jmp	.L472
.L471:
.L478:
	nop
.L473:
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIN3TKO11INTERNENTRYEE8CAPACITYEv
	mov	DWORD PTR -4[rbp], eax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR -4[rbp], eax
	je	.L479
	nop
.L475:
.L476:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cdqe
	sub	rax, 1
	mov	QWORD PTR 48[rsp], rax
	mov	QWORD PTR 40[rsp], 0
	mov	QWORD PTR 32[rsp], 1
	mov	r9d, 0
	mov	r8d, -1
	mov	edx, 24
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayRedimPresvEx
	jmp	.L480
.L479:
	nop
.L472:
.L480:
	nop
	add	rsp, 80
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO11INTERNENTRYEEixEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO11INTERNENTRYEEixEi
_ZN5ArrayIN3TKO11INTERNENTRYEEixEi:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
	mov	QWORD PTR -8[rbp], 0
.L482:
	mov	rax, QWORD PTR 16[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	eax, DWORD PTR 24[rbp]
	movsx	rdx, eax
	mov	rax, rdx
	add	rax, rax
	add	rax, rdx
	sal	rax, 3
	add	rax, rcx
	mov	QWORD PTR -8[rbp], rax
	nop
.L483:
	mov	rax, QWORD PTR -8[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO11INTERNENTRYEE2ATEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO11INTERNENTRYEE2ATEi
_ZN5ArrayIN3TKO11INTERNENTRYEE2ATEi:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
	mov	QWORD PTR -8[rbp], 0
.L486:
	mov	rax, QWORD PTR 16[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	eax, DWORD PTR 24[rbp]
	movsx	rdx, eax
	mov	rax, rdx
	add	rax, rax
	add	rax, rdx
	sal	rax, 3
	add	rax, rcx
	mov	QWORD PTR -8[rbp], rax
	nop
.L487:
	mov	rax, QWORD PTR -8[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO11INTERNENTRYEE4PUSHERS1_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO11INTERNENTRYEE4PUSHERS1_
_ZN5ArrayIN3TKO11INTERNENTRYEE4PUSHERS1_:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
.L490:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	add	eax, 1
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIN3TKO11INTERNENTRYEE7RESERVEEi
	mov	rax, QWORD PTR 16[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	movsx	rdx, eax
	mov	rax, rdx
	add	rax, rax
	add	rax, rdx
	sal	rax, 3
	lea	r8, [rcx+rax]
	mov	rcx, QWORD PTR 24[rbp]
	mov	rax, QWORD PTR [rcx]
	mov	rdx, QWORD PTR 8[rcx]
	mov	QWORD PTR [r8], rax
	mov	QWORD PTR 8[r8], rdx
	mov	rax, QWORD PTR 16[rcx]
	mov	QWORD PTR 16[r8], rax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	add	edx, 1
	mov	DWORD PTR [rax], edx
	nop
	add	rsp, 32
	pop	rbp
	ret
.L491:
	.seh_endproc
	.def	_ZN5ArrayIN3TKO11INTERNENTRYEE3POPEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO11INTERNENTRYEE3POPEv
_ZN5ArrayIN3TKO11INTERNENTRYEE3POPEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 64
	.seh_stackalloc	64
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
	lea	rax, -32[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
.L493:
	lea	rax, -64[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	rax, QWORD PTR 24[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	jne	.L500
	mov	rax, QWORD PTR -64[rbp]
	mov	rdx, QWORD PTR -56[rbp]
	mov	QWORD PTR -32[rbp], rax
	mov	QWORD PTR -24[rbp], rdx
	mov	rax, QWORD PTR -48[rbp]
	mov	QWORD PTR -16[rbp], rax
	jmp	.L496
.L495:
.L500:
	nop
.L497:
	mov	rax, QWORD PTR 24[rbp]
	add	rax, 72
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 24[rbp]
	add	rax, 72
	sub	edx, 1
	mov	DWORD PTR [rax], edx
	mov	rax, QWORD PTR 24[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	rax, QWORD PTR 24[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	movsx	rdx, eax
	mov	rax, rdx
	add	rax, rax
	add	rax, rdx
	sal	rax, 3
	lea	r8, [rcx+rax]
	lea	rcx, -64[rbp]
	mov	rax, QWORD PTR [r8]
	mov	rdx, QWORD PTR 8[r8]
	mov	QWORD PTR [rcx], rax
	mov	QWORD PTR 8[rcx], rdx
	mov	rax, QWORD PTR 16[r8]
	mov	QWORD PTR 16[rcx], rax
	mov	rax, QWORD PTR -64[rbp]
	mov	rdx, QWORD PTR -56[rbp]
	mov	QWORD PTR -32[rbp], rax
	mov	QWORD PTR -24[rbp], rdx
	mov	rax, QWORD PTR -48[rbp]
	mov	QWORD PTR -16[rbp], rax
	nop
.L496:
	mov	rcx, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR -32[rbp]
	mov	rdx, QWORD PTR -24[rbp]
	mov	QWORD PTR [rcx], rax
	mov	QWORD PTR 8[rcx], rdx
	mov	rax, QWORD PTR -16[rbp]
	mov	QWORD PTR 16[rcx], rax
	mov	rax, QWORD PTR 16[rbp]
	add	rsp, 64
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO11INTERNENTRYEE6INSERTEiRS1_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO11INTERNENTRYEE6INSERTEiRS1_
_ZN5ArrayIN3TKO11INTERNENTRYEE6INSERTEiRS1_:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 80
	.seh_stackalloc	80
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
	mov	QWORD PTR 32[rbp], r8
.L502:
	cmp	DWORD PTR 24[rbp], 0
	js	.L516
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR 24[rbp], eax
	setg	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -8[rbp], rax
	jmp	.L505
.L516:
	nop
.L504:
	mov	QWORD PTR -8[rbp], -1
.L505:
	cmp	QWORD PTR -8[rbp], 0
	jne	.L517
	nop
.L507:
.L509:
	lea	rcx, -48[rbp]
	mov	r8, QWORD PTR 32[rbp]
	mov	rax, QWORD PTR [r8]
	mov	rdx, QWORD PTR 8[r8]
	mov	QWORD PTR [rcx], rax
	mov	QWORD PTR 8[rcx], rdx
	mov	rax, QWORD PTR 16[r8]
	mov	QWORD PTR 16[rcx], rax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	add	eax, 1
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIN3TKO11INTERNENTRYEE7RESERVEEi
	mov	rax, QWORD PTR 16[rbp]
	mov	eax, DWORD PTR 72[rax]
	mov	DWORD PTR -12[rbp], eax
	mov	eax, DWORD PTR 24[rbp]
	add	eax, 1
	mov	DWORD PTR -16[rbp], eax
	jmp	.L510
.L518:
	nop
.L511:
	mov	rax, QWORD PTR 16[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	eax, DWORD PTR -12[rbp]
	movsx	rdx, eax
	mov	rax, rdx
	add	rax, rax
	add	rax, rdx
	sal	rax, 3
	sub	rax, 24
	lea	r8, [rcx+rax]
	mov	rax, QWORD PTR 16[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	eax, DWORD PTR -12[rbp]
	movsx	rdx, eax
	mov	rax, rdx
	add	rax, rax
	add	rax, rdx
	sal	rax, 3
	add	rcx, rax
	mov	rax, QWORD PTR [r8]
	mov	rdx, QWORD PTR 8[r8]
	mov	QWORD PTR [rcx], rax
	mov	QWORD PTR 8[rcx], rdx
	mov	rax, QWORD PTR 16[r8]
	mov	QWORD PTR 16[rcx], rax
.L512:
	sub	DWORD PTR -12[rbp], 1
.L510:
	mov	eax, DWORD PTR -12[rbp]
	cmp	eax, DWORD PTR -16[rbp]
	jge	.L518
	nop
.L513:
	mov	rax, QWORD PTR 16[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	eax, DWORD PTR 24[rbp]
	movsx	rdx, eax
	mov	rax, rdx
	add	rax, rax
	add	rax, rdx
	sal	rax, 3
	lea	r8, [rcx+rax]
	lea	rcx, -48[rbp]
	mov	rax, QWORD PTR [rcx]
	mov	rdx, QWORD PTR 8[rcx]
	mov	QWORD PTR [r8], rax
	mov	QWORD PTR 8[r8], rdx
	mov	rax, QWORD PTR 16[rcx]
	mov	QWORD PTR 16[r8], rax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	add	edx, 1
	mov	DWORD PTR [rax], edx
	jmp	.L519
.L517:
	nop
.L508:
.L519:
	nop
	add	rsp, 80
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO11INTERNENTRYEE6REMOVEEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO11INTERNENTRYEE6REMOVEEi
_ZN5ArrayIN3TKO11INTERNENTRYEE6REMOVEEi:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
.L521:
	cmp	DWORD PTR 24[rbp], 0
	js	.L535
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR 24[rbp], eax
	setge	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -8[rbp], rax
	jmp	.L524
.L535:
	nop
.L523:
	mov	QWORD PTR -8[rbp], -1
.L524:
	cmp	QWORD PTR -8[rbp], 0
	jne	.L536
	nop
.L526:
.L528:
	mov	eax, DWORD PTR 24[rbp]
	mov	DWORD PTR -12[rbp], eax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	sub	eax, 2
	mov	DWORD PTR -16[rbp], eax
	jmp	.L529
.L537:
	nop
.L530:
	mov	rax, QWORD PTR 16[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	eax, DWORD PTR -12[rbp]
	movsx	rdx, eax
	mov	rax, rdx
	add	rax, rax
	add	rax, rdx
	sal	rax, 3
	add	rax, 24
	lea	r8, [rcx+rax]
	mov	rax, QWORD PTR 16[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	eax, DWORD PTR -12[rbp]
	movsx	rdx, eax
	mov	rax, rdx
	add	rax, rax
	add	rax, rdx
	sal	rax, 3
	add	rcx, rax
	mov	rax, QWORD PTR [r8]
	mov	rdx, QWORD PTR 8[r8]
	mov	QWORD PTR [rcx], rax
	mov	QWORD PTR 8[rcx], rdx
	mov	rax, QWORD PTR 16[r8]
	mov	QWORD PTR 16[rcx], rax
.L531:
	add	DWORD PTR -12[rbp], 1
.L529:
	mov	eax, DWORD PTR -12[rbp]
	cmp	eax, DWORD PTR -16[rbp]
	jle	.L537
	nop
.L532:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	sub	edx, 1
	mov	DWORD PTR [rax], edx
	jmp	.L538
.L536:
	nop
.L527:
.L538:
	nop
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO11INTERNENTRYEE10REMOVESWAPEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO11INTERNENTRYEE10REMOVESWAPEi
_ZN5ArrayIN3TKO11INTERNENTRYEE10REMOVESWAPEi:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
.L540:
	cmp	DWORD PTR 24[rbp], 0
	js	.L552
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR 24[rbp], eax
	setge	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -8[rbp], rax
	jmp	.L543
.L552:
	nop
.L542:
	mov	QWORD PTR -8[rbp], -1
.L543:
	cmp	QWORD PTR -8[rbp], 0
	jne	.L553
	nop
.L545:
.L547:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	sub	edx, 1
	mov	DWORD PTR [rax], edx
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR 24[rbp], eax
	je	.L554
	mov	rax, QWORD PTR 16[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	movsx	rdx, eax
	mov	rax, rdx
	add	rax, rax
	add	rax, rdx
	sal	rax, 3
	lea	r8, [rcx+rax]
	mov	rax, QWORD PTR 16[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	eax, DWORD PTR 24[rbp]
	movsx	rdx, eax
	mov	rax, rdx
	add	rax, rax
	add	rax, rdx
	sal	rax, 3
	add	rcx, rax
	mov	rax, QWORD PTR [r8]
	mov	rdx, QWORD PTR 8[r8]
	mov	QWORD PTR [rcx], rax
	mov	QWORD PTR 8[rcx], rdx
	mov	rax, QWORD PTR 16[r8]
	mov	QWORD PTR 16[rcx], rax
	jmp	.L555
.L546:
.L549:
.L553:
	nop
	jmp	.L555
.L554:
	nop
.L550:
.L555:
	nop
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO11INTERNENTRYEE5CLEAREv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO11INTERNENTRYEE5CLEAREv
_ZN5ArrayIN3TKO11INTERNENTRYEE5CLEAREv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
.L557:
	lea	rax, -32[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	DWORD PTR -4[rbp], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	sub	eax, 1
	mov	DWORD PTR -8[rbp], eax
	jmp	.L558
.L564:
	nop
.L559:
	mov	rax, QWORD PTR 16[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	eax, DWORD PTR -4[rbp]
	movsx	rdx, eax
	mov	rax, rdx
	add	rax, rax
	add	rax, rdx
	sal	rax, 3
	lea	r8, [rcx+rax]
	lea	rcx, -32[rbp]
	mov	rax, QWORD PTR [rcx]
	mov	rdx, QWORD PTR 8[rcx]
	mov	QWORD PTR [r8], rax
	mov	QWORD PTR 8[r8], rdx
	mov	rax, QWORD PTR 16[rcx]
	mov	QWORD PTR 16[r8], rax
.L560:
	add	DWORD PTR -4[rbp], 1
.L558:
	mov	eax, DWORD PTR -4[rbp]
	cmp	eax, DWORD PTR -8[rbp]
	jle	.L564
	nop
.L561:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	DWORD PTR [rax], 0
	nop
	add	rsp, 32
	pop	rbp
	ret
.L562:
	.seh_endproc
	.def	_ZN5ArrayIN3TKO11INTERNENTRYEE11GETITERATOREv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO11INTERNENTRYEE11GETITERATOREv
_ZN5ArrayIN3TKO11INTERNENTRYEE11GETITERATOREv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
	lea	rax, -16[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
.L566:
	lea	rax, -32[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	lea	rax, -32[rbp]
	mov	rdx, QWORD PTR 24[rbp]
	mov	QWORD PTR [rax], rdx
	lea	rax, -32[rbp]
	add	rax, 8
	mov	DWORD PTR [rax], 0
	mov	rax, QWORD PTR -32[rbp]
	mov	rdx, QWORD PTR -24[rbp]
	mov	QWORD PTR -16[rbp], rax
	mov	QWORD PTR -8[rbp], rdx
	nop
.L567:
	mov	rcx, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR -16[rbp]
	mov	rdx, QWORD PTR -8[rbp]
	mov	QWORD PTR [rcx], rax
	mov	QWORD PTR 8[rcx], rdx
	mov	rax, QWORD PTR 16[rbp]
	add	rsp, 32
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN13ArrayIteratorIjE7ISVALIDEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN13ArrayIteratorIjE7ISVALIDEv
_ZN13ArrayIteratorIjE7ISVALIDEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	BYTE PTR -9[rbp], 0
.L570:
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	QWORD PTR -8[rbp], rax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR -8[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	edx, eax
	setl	al
	mov	BYTE PTR -9[rbp], al
	nop
.L571:
	movzx	eax, BYTE PTR -9[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN13ArrayIteratorIjE5VALUEEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN13ArrayIteratorIjE5VALUEEv
_ZN13ArrayIteratorIjE5VALUEEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR -16[rbp], 0
.L574:
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	QWORD PTR -8[rbp], rax
	mov	rax, QWORD PTR -8[rbp]
	mov	rax, QWORD PTR [rax]
	mov	rdx, QWORD PTR 16[rbp]
	add	rdx, 8
	mov	edx, DWORD PTR [rdx]
	movsx	rdx, edx
	sal	rdx, 2
	add	rax, rdx
	mov	QWORD PTR -16[rbp], rax
	nop
.L575:
	mov	rax, QWORD PTR -16[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN13ArrayIteratorIjE8MOVENEXTEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN13ArrayIteratorIjE8MOVENEXTEv
_ZN13ArrayIteratorIjE8MOVENEXTEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
.L578:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	add	edx, 1
	mov	DWORD PTR [rax], edx
	nop
	pop	rbp
	ret
.L579:
	.seh_endproc
	.def	_ZN5ArrayIjE5COUNTEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIjE5COUNTEv
_ZN5ArrayIjE5COUNTEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR -4[rbp], 0
.L581:
	mov	rax, QWORD PTR 16[rbp]
	mov	eax, DWORD PTR 72[rax]
	mov	DWORD PTR -4[rbp], eax
	nop
.L582:
	mov	eax, DWORD PTR -4[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIjE8CAPACITYEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIjE8CAPACITYEv
_ZN5ArrayIjE8CAPACITYEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 64
	.seh_stackalloc	64
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR -20[rbp], 0
.L585:
	mov	edx, 1
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayUBound
	mov	QWORD PTR -8[rbp], rax
	mov	edx, 1
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayLBound
	mov	QWORD PTR -16[rbp], rax
	mov	rax, QWORD PTR -8[rbp]
	mov	edx, eax
	mov	rax, QWORD PTR -16[rbp]
	sub	edx, eax
	mov	eax, edx
	add	eax, 1
	mov	DWORD PTR -20[rbp], eax
	nop
.L586:
	mov	eax, DWORD PTR -20[rbp]
	add	rsp, 64
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIjE7ISEMPTYEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIjE7ISEMPTYEv
_ZN5ArrayIjE7ISEMPTYEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	BYTE PTR -1[rbp], 0
.L589:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	sete	al
	mov	BYTE PTR -1[rbp], al
	nop
.L590:
	movzx	eax, BYTE PTR -1[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIjE7RESERVEEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIjE7RESERVEEi
_ZN5ArrayIjE7RESERVEEi:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 80
	.seh_stackalloc	80
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
.L593:
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIjE8CAPACITYEv
	mov	DWORD PTR -8[rbp], eax
	mov	eax, DWORD PTR 24[rbp]
	cmp	eax, DWORD PTR -8[rbp]
	jle	.L606
	nop
.L595:
.L597:
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIjE8CAPACITYEv
	mov	DWORD PTR -12[rbp], eax
	mov	eax, DWORD PTR -12[rbp]
	mov	DWORD PTR -4[rbp], eax
	cmp	DWORD PTR -4[rbp], 7
	jg	.L607
	mov	DWORD PTR -4[rbp], 8
	jmp	.L604
.L599:
.L600:
.L607:
	nop
.L601:
.L604:
	mov	eax, DWORD PTR -4[rbp]
	cmp	eax, DWORD PTR 24[rbp]
	jge	.L608
	mov	eax, DWORD PTR -4[rbp]
	cdqe
	add	rax, rax
	mov	DWORD PTR -4[rbp], eax
	jmp	.L604
.L608:
	nop
.L603:
	mov	eax, DWORD PTR -4[rbp]
	cdqe
	sub	rax, 1
	mov	QWORD PTR 48[rsp], rax
	mov	QWORD PTR 40[rsp], 0
	mov	QWORD PTR 32[rsp], 1
	mov	r9d, 0
	mov	r8d, -1
	mov	edx, 4
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayRedimPresvEx
	jmp	.L609
.L606:
	nop
.L596:
.L609:
	nop
	add	rsp, 80
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIjE6SHRINKEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIjE6SHRINKEv
_ZN5ArrayIjE6SHRINKEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 80
	.seh_stackalloc	80
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
.L611:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	jne	.L620
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayErase
	jmp	.L614
.L613:
.L620:
	nop
.L615:
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIjE8CAPACITYEv
	mov	DWORD PTR -4[rbp], eax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR -4[rbp], eax
	je	.L621
	nop
.L617:
.L618:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cdqe
	sub	rax, 1
	mov	QWORD PTR 48[rsp], rax
	mov	QWORD PTR 40[rsp], 0
	mov	QWORD PTR 32[rsp], 1
	mov	r9d, 0
	mov	r8d, -1
	mov	edx, 4
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayRedimPresvEx
	jmp	.L622
.L621:
	nop
.L614:
.L622:
	nop
	add	rsp, 80
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIjEixEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIjEixEi
_ZN5ArrayIjEixEi:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
	mov	QWORD PTR -8[rbp], 0
.L624:
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 24[rbp]
	movsx	rdx, edx
	sal	rdx, 2
	add	rax, rdx
	mov	QWORD PTR -8[rbp], rax
	nop
.L625:
	mov	rax, QWORD PTR -8[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIjE2ATEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIjE2ATEi
_ZN5ArrayIjE2ATEi:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
	mov	QWORD PTR -8[rbp], 0
.L628:
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 24[rbp]
	movsx	rdx, edx
	sal	rdx, 2
	add	rax, rdx
	mov	QWORD PTR -8[rbp], rax
	nop
.L629:
	mov	rax, QWORD PTR -8[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIjE4PUSHERj;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIjE4PUSHERj
_ZN5ArrayIjE4PUSHERj:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
.L632:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	add	eax, 1
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIjE7RESERVEEi
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	rdx, QWORD PTR 16[rbp]
	add	rdx, 72
	mov	edx, DWORD PTR [rdx]
	movsx	rdx, edx
	sal	rdx, 2
	add	rdx, rax
	mov	rax, QWORD PTR 24[rbp]
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR [rdx], eax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	add	edx, 1
	mov	DWORD PTR [rax], edx
	nop
	add	rsp, 32
	pop	rbp
	ret
.L633:
	.seh_endproc
	.def	_ZN5ArrayIjE3POPEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIjE3POPEv
_ZN5ArrayIjE3POPEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR -4[rbp], 0
.L635:
	mov	DWORD PTR -8[rbp], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	jne	.L642
	mov	eax, DWORD PTR -8[rbp]
	mov	DWORD PTR -4[rbp], eax
	jmp	.L638
.L637:
.L642:
	nop
.L639:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	sub	edx, 1
	mov	DWORD PTR [rax], edx
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	rdx, QWORD PTR 16[rbp]
	add	rdx, 72
	mov	edx, DWORD PTR [rdx]
	movsx	rdx, edx
	sal	rdx, 2
	add	rax, rdx
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR -8[rbp], eax
	mov	eax, DWORD PTR -8[rbp]
	mov	DWORD PTR -4[rbp], eax
	nop
.L638:
	mov	eax, DWORD PTR -4[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIjE6INSERTEiRj;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIjE6INSERTEiRj
_ZN5ArrayIjE6INSERTEiRj:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 64
	.seh_stackalloc	64
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
	mov	QWORD PTR 32[rbp], r8
.L644:
	cmp	DWORD PTR 24[rbp], 0
	js	.L658
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR 24[rbp], eax
	setg	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -8[rbp], rax
	jmp	.L647
.L658:
	nop
.L646:
	mov	QWORD PTR -8[rbp], -1
.L647:
	cmp	QWORD PTR -8[rbp], 0
	jne	.L659
	nop
.L649:
.L651:
	mov	rax, QWORD PTR 32[rbp]
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR -16[rbp], eax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	add	eax, 1
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIjE7RESERVEEi
	mov	rax, QWORD PTR 16[rbp]
	mov	eax, DWORD PTR 72[rax]
	mov	DWORD PTR -12[rbp], eax
	mov	eax, DWORD PTR 24[rbp]
	add	eax, 1
	mov	DWORD PTR -20[rbp], eax
	jmp	.L652
.L660:
	nop
.L653:
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR -12[rbp]
	movsx	rdx, edx
	sal	rdx, 2
	sub	rdx, 4
	lea	rcx, [rax+rdx]
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR -12[rbp]
	movsx	rdx, edx
	sal	rdx, 2
	add	rdx, rax
	mov	eax, DWORD PTR [rcx]
	mov	DWORD PTR [rdx], eax
.L654:
	sub	DWORD PTR -12[rbp], 1
.L652:
	mov	eax, DWORD PTR -12[rbp]
	cmp	eax, DWORD PTR -20[rbp]
	jge	.L660
	nop
.L655:
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 24[rbp]
	movsx	rdx, edx
	sal	rdx, 2
	add	rdx, rax
	mov	eax, DWORD PTR -16[rbp]
	mov	DWORD PTR [rdx], eax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	add	edx, 1
	mov	DWORD PTR [rax], edx
	jmp	.L661
.L659:
	nop
.L650:
.L661:
	nop
	add	rsp, 64
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIjE6REMOVEEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIjE6REMOVEEi
_ZN5ArrayIjE6REMOVEEi:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
.L663:
	cmp	DWORD PTR 24[rbp], 0
	js	.L677
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR 24[rbp], eax
	setge	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -8[rbp], rax
	jmp	.L666
.L677:
	nop
.L665:
	mov	QWORD PTR -8[rbp], -1
.L666:
	cmp	QWORD PTR -8[rbp], 0
	jne	.L678
	nop
.L668:
.L670:
	mov	eax, DWORD PTR 24[rbp]
	mov	DWORD PTR -12[rbp], eax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	sub	eax, 2
	mov	DWORD PTR -16[rbp], eax
	jmp	.L671
.L679:
	nop
.L672:
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR -12[rbp]
	movsx	rdx, edx
	sal	rdx, 2
	add	rdx, 4
	lea	rcx, [rax+rdx]
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR -12[rbp]
	movsx	rdx, edx
	sal	rdx, 2
	add	rdx, rax
	mov	eax, DWORD PTR [rcx]
	mov	DWORD PTR [rdx], eax
.L673:
	add	DWORD PTR -12[rbp], 1
.L671:
	mov	eax, DWORD PTR -12[rbp]
	cmp	eax, DWORD PTR -16[rbp]
	jle	.L679
	nop
.L674:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	sub	edx, 1
	mov	DWORD PTR [rax], edx
	jmp	.L680
.L678:
	nop
.L669:
.L680:
	nop
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIjE10REMOVESWAPEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIjE10REMOVESWAPEi
_ZN5ArrayIjE10REMOVESWAPEi:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
.L682:
	cmp	DWORD PTR 24[rbp], 0
	js	.L694
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR 24[rbp], eax
	setge	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -8[rbp], rax
	jmp	.L685
.L694:
	nop
.L684:
	mov	QWORD PTR -8[rbp], -1
.L685:
	cmp	QWORD PTR -8[rbp], 0
	jne	.L695
	nop
.L687:
.L689:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	sub	edx, 1
	mov	DWORD PTR [rax], edx
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR 24[rbp], eax
	je	.L696
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	rdx, QWORD PTR 16[rbp]
	add	rdx, 72
	mov	edx, DWORD PTR [rdx]
	movsx	rdx, edx
	sal	rdx, 2
	lea	rcx, [rax+rdx]
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 24[rbp]
	movsx	rdx, edx
	sal	rdx, 2
	add	rdx, rax
	mov	eax, DWORD PTR [rcx]
	mov	DWORD PTR [rdx], eax
	jmp	.L697
.L688:
.L691:
.L695:
	nop
	jmp	.L697
.L696:
	nop
.L692:
.L697:
	nop
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIjE5CLEAREv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIjE5CLEAREv
_ZN5ArrayIjE5CLEAREv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
.L699:
	mov	DWORD PTR -12[rbp], 0
	mov	DWORD PTR -4[rbp], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	sub	eax, 1
	mov	DWORD PTR -8[rbp], eax
	jmp	.L700
.L706:
	nop
.L701:
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR -4[rbp]
	movsx	rdx, edx
	sal	rdx, 2
	add	rdx, rax
	mov	eax, DWORD PTR -12[rbp]
	mov	DWORD PTR [rdx], eax
.L702:
	add	DWORD PTR -4[rbp], 1
.L700:
	mov	eax, DWORD PTR -4[rbp]
	cmp	eax, DWORD PTR -8[rbp]
	jle	.L706
	nop
.L703:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	DWORD PTR [rax], 0
	nop
	add	rsp, 16
	pop	rbp
	ret
.L704:
	.seh_endproc
	.def	_ZN5ArrayIjE11GETITERATOREv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIjE11GETITERATOREv
_ZN5ArrayIjE11GETITERATOREv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
	lea	rax, -16[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
.L708:
	lea	rax, -32[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	lea	rax, -32[rbp]
	mov	rdx, QWORD PTR 24[rbp]
	mov	QWORD PTR [rax], rdx
	lea	rax, -32[rbp]
	add	rax, 8
	mov	DWORD PTR [rax], 0
	mov	rax, QWORD PTR -32[rbp]
	mov	rdx, QWORD PTR -24[rbp]
	mov	QWORD PTR -16[rbp], rax
	mov	QWORD PTR -8[rbp], rdx
	nop
.L709:
	mov	rcx, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR -16[rbp]
	mov	rdx, QWORD PTR -8[rbp]
	mov	QWORD PTR [rcx], rax
	mov	QWORD PTR 8[rcx], rdx
	mov	rax, QWORD PTR 16[rbp]
	add	rsp, 32
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN13ArrayIteratorIiE7ISVALIDEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN13ArrayIteratorIiE7ISVALIDEv
_ZN13ArrayIteratorIiE7ISVALIDEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	BYTE PTR -9[rbp], 0
.L712:
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	QWORD PTR -8[rbp], rax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR -8[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	edx, eax
	setl	al
	mov	BYTE PTR -9[rbp], al
	nop
.L713:
	movzx	eax, BYTE PTR -9[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN13ArrayIteratorIiE5VALUEEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN13ArrayIteratorIiE5VALUEEv
_ZN13ArrayIteratorIiE5VALUEEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR -16[rbp], 0
.L716:
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	QWORD PTR -8[rbp], rax
	mov	rax, QWORD PTR -8[rbp]
	mov	rax, QWORD PTR [rax]
	mov	rdx, QWORD PTR 16[rbp]
	add	rdx, 8
	mov	edx, DWORD PTR [rdx]
	movsx	rdx, edx
	sal	rdx, 2
	add	rax, rdx
	mov	QWORD PTR -16[rbp], rax
	nop
.L717:
	mov	rax, QWORD PTR -16[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN13ArrayIteratorIiE8MOVENEXTEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN13ArrayIteratorIiE8MOVENEXTEv
_ZN13ArrayIteratorIiE8MOVENEXTEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
.L720:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	add	edx, 1
	mov	DWORD PTR [rax], edx
	nop
	pop	rbp
	ret
.L721:
	.seh_endproc
	.def	_ZN5ArrayIiE5COUNTEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIiE5COUNTEv
_ZN5ArrayIiE5COUNTEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR -4[rbp], 0
.L723:
	mov	rax, QWORD PTR 16[rbp]
	mov	eax, DWORD PTR 72[rax]
	mov	DWORD PTR -4[rbp], eax
	nop
.L724:
	mov	eax, DWORD PTR -4[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIiE8CAPACITYEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIiE8CAPACITYEv
_ZN5ArrayIiE8CAPACITYEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 64
	.seh_stackalloc	64
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR -20[rbp], 0
.L727:
	mov	edx, 1
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayUBound
	mov	QWORD PTR -8[rbp], rax
	mov	edx, 1
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayLBound
	mov	QWORD PTR -16[rbp], rax
	mov	rax, QWORD PTR -8[rbp]
	mov	edx, eax
	mov	rax, QWORD PTR -16[rbp]
	sub	edx, eax
	mov	eax, edx
	add	eax, 1
	mov	DWORD PTR -20[rbp], eax
	nop
.L728:
	mov	eax, DWORD PTR -20[rbp]
	add	rsp, 64
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIiE7ISEMPTYEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIiE7ISEMPTYEv
_ZN5ArrayIiE7ISEMPTYEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	BYTE PTR -1[rbp], 0
.L731:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	sete	al
	mov	BYTE PTR -1[rbp], al
	nop
.L732:
	movzx	eax, BYTE PTR -1[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIiE7RESERVEEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIiE7RESERVEEi
_ZN5ArrayIiE7RESERVEEi:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 80
	.seh_stackalloc	80
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
.L735:
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIiE8CAPACITYEv
	mov	DWORD PTR -8[rbp], eax
	mov	eax, DWORD PTR 24[rbp]
	cmp	eax, DWORD PTR -8[rbp]
	jle	.L748
	nop
.L737:
.L739:
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIiE8CAPACITYEv
	mov	DWORD PTR -12[rbp], eax
	mov	eax, DWORD PTR -12[rbp]
	mov	DWORD PTR -4[rbp], eax
	cmp	DWORD PTR -4[rbp], 7
	jg	.L749
	mov	DWORD PTR -4[rbp], 8
	jmp	.L746
.L741:
.L742:
.L749:
	nop
.L743:
.L746:
	mov	eax, DWORD PTR -4[rbp]
	cmp	eax, DWORD PTR 24[rbp]
	jge	.L750
	mov	eax, DWORD PTR -4[rbp]
	cdqe
	add	rax, rax
	mov	DWORD PTR -4[rbp], eax
	jmp	.L746
.L750:
	nop
.L745:
	mov	eax, DWORD PTR -4[rbp]
	cdqe
	sub	rax, 1
	mov	QWORD PTR 48[rsp], rax
	mov	QWORD PTR 40[rsp], 0
	mov	QWORD PTR 32[rsp], 1
	mov	r9d, 0
	mov	r8d, -1
	mov	edx, 4
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayRedimPresvEx
	jmp	.L751
.L748:
	nop
.L738:
.L751:
	nop
	add	rsp, 80
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIiE6SHRINKEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIiE6SHRINKEv
_ZN5ArrayIiE6SHRINKEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 80
	.seh_stackalloc	80
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
.L753:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	jne	.L762
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayErase
	jmp	.L756
.L755:
.L762:
	nop
.L757:
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIiE8CAPACITYEv
	mov	DWORD PTR -4[rbp], eax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR -4[rbp], eax
	je	.L763
	nop
.L759:
.L760:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cdqe
	sub	rax, 1
	mov	QWORD PTR 48[rsp], rax
	mov	QWORD PTR 40[rsp], 0
	mov	QWORD PTR 32[rsp], 1
	mov	r9d, 0
	mov	r8d, -1
	mov	edx, 4
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayRedimPresvEx
	jmp	.L764
.L763:
	nop
.L756:
.L764:
	nop
	add	rsp, 80
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIiEixEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIiEixEi
_ZN5ArrayIiEixEi:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
	mov	QWORD PTR -8[rbp], 0
.L766:
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 24[rbp]
	movsx	rdx, edx
	sal	rdx, 2
	add	rax, rdx
	mov	QWORD PTR -8[rbp], rax
	nop
.L767:
	mov	rax, QWORD PTR -8[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIiE2ATEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIiE2ATEi
_ZN5ArrayIiE2ATEi:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
	mov	QWORD PTR -8[rbp], 0
.L770:
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 24[rbp]
	movsx	rdx, edx
	sal	rdx, 2
	add	rax, rdx
	mov	QWORD PTR -8[rbp], rax
	nop
.L771:
	mov	rax, QWORD PTR -8[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIiE4PUSHERi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIiE4PUSHERi
_ZN5ArrayIiE4PUSHERi:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
.L774:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	add	eax, 1
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIiE7RESERVEEi
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	rdx, QWORD PTR 16[rbp]
	add	rdx, 72
	mov	edx, DWORD PTR [rdx]
	movsx	rdx, edx
	sal	rdx, 2
	add	rdx, rax
	mov	rax, QWORD PTR 24[rbp]
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR [rdx], eax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	add	edx, 1
	mov	DWORD PTR [rax], edx
	nop
	add	rsp, 32
	pop	rbp
	ret
.L775:
	.seh_endproc
	.def	_ZN5ArrayIiE3POPEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIiE3POPEv
_ZN5ArrayIiE3POPEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR -4[rbp], 0
.L777:
	mov	DWORD PTR -8[rbp], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	jne	.L784
	mov	eax, DWORD PTR -8[rbp]
	mov	DWORD PTR -4[rbp], eax
	jmp	.L780
.L779:
.L784:
	nop
.L781:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	sub	edx, 1
	mov	DWORD PTR [rax], edx
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	rdx, QWORD PTR 16[rbp]
	add	rdx, 72
	mov	edx, DWORD PTR [rdx]
	movsx	rdx, edx
	sal	rdx, 2
	add	rax, rdx
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR -8[rbp], eax
	mov	eax, DWORD PTR -8[rbp]
	mov	DWORD PTR -4[rbp], eax
	nop
.L780:
	mov	eax, DWORD PTR -4[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIiE6INSERTEiRi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIiE6INSERTEiRi
_ZN5ArrayIiE6INSERTEiRi:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 64
	.seh_stackalloc	64
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
	mov	QWORD PTR 32[rbp], r8
.L786:
	cmp	DWORD PTR 24[rbp], 0
	js	.L800
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR 24[rbp], eax
	setg	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -8[rbp], rax
	jmp	.L789
.L800:
	nop
.L788:
	mov	QWORD PTR -8[rbp], -1
.L789:
	cmp	QWORD PTR -8[rbp], 0
	jne	.L801
	nop
.L791:
.L793:
	mov	rax, QWORD PTR 32[rbp]
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR -16[rbp], eax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	add	eax, 1
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIiE7RESERVEEi
	mov	rax, QWORD PTR 16[rbp]
	mov	eax, DWORD PTR 72[rax]
	mov	DWORD PTR -12[rbp], eax
	mov	eax, DWORD PTR 24[rbp]
	add	eax, 1
	mov	DWORD PTR -20[rbp], eax
	jmp	.L794
.L802:
	nop
.L795:
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR -12[rbp]
	movsx	rdx, edx
	sal	rdx, 2
	sub	rdx, 4
	lea	rcx, [rax+rdx]
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR -12[rbp]
	movsx	rdx, edx
	sal	rdx, 2
	add	rdx, rax
	mov	eax, DWORD PTR [rcx]
	mov	DWORD PTR [rdx], eax
.L796:
	sub	DWORD PTR -12[rbp], 1
.L794:
	mov	eax, DWORD PTR -12[rbp]
	cmp	eax, DWORD PTR -20[rbp]
	jge	.L802
	nop
.L797:
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 24[rbp]
	movsx	rdx, edx
	sal	rdx, 2
	add	rdx, rax
	mov	eax, DWORD PTR -16[rbp]
	mov	DWORD PTR [rdx], eax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	add	edx, 1
	mov	DWORD PTR [rax], edx
	jmp	.L803
.L801:
	nop
.L792:
.L803:
	nop
	add	rsp, 64
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIiE6REMOVEEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIiE6REMOVEEi
_ZN5ArrayIiE6REMOVEEi:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
.L805:
	cmp	DWORD PTR 24[rbp], 0
	js	.L819
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR 24[rbp], eax
	setge	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -8[rbp], rax
	jmp	.L808
.L819:
	nop
.L807:
	mov	QWORD PTR -8[rbp], -1
.L808:
	cmp	QWORD PTR -8[rbp], 0
	jne	.L820
	nop
.L810:
.L812:
	mov	eax, DWORD PTR 24[rbp]
	mov	DWORD PTR -12[rbp], eax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	sub	eax, 2
	mov	DWORD PTR -16[rbp], eax
	jmp	.L813
.L821:
	nop
.L814:
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR -12[rbp]
	movsx	rdx, edx
	sal	rdx, 2
	add	rdx, 4
	lea	rcx, [rax+rdx]
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR -12[rbp]
	movsx	rdx, edx
	sal	rdx, 2
	add	rdx, rax
	mov	eax, DWORD PTR [rcx]
	mov	DWORD PTR [rdx], eax
.L815:
	add	DWORD PTR -12[rbp], 1
.L813:
	mov	eax, DWORD PTR -12[rbp]
	cmp	eax, DWORD PTR -16[rbp]
	jle	.L821
	nop
.L816:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	sub	edx, 1
	mov	DWORD PTR [rax], edx
	jmp	.L822
.L820:
	nop
.L811:
.L822:
	nop
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIiE10REMOVESWAPEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIiE10REMOVESWAPEi
_ZN5ArrayIiE10REMOVESWAPEi:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
.L824:
	cmp	DWORD PTR 24[rbp], 0
	js	.L836
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR 24[rbp], eax
	setge	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -8[rbp], rax
	jmp	.L827
.L836:
	nop
.L826:
	mov	QWORD PTR -8[rbp], -1
.L827:
	cmp	QWORD PTR -8[rbp], 0
	jne	.L837
	nop
.L829:
.L831:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	sub	edx, 1
	mov	DWORD PTR [rax], edx
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR 24[rbp], eax
	je	.L838
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	rdx, QWORD PTR 16[rbp]
	add	rdx, 72
	mov	edx, DWORD PTR [rdx]
	movsx	rdx, edx
	sal	rdx, 2
	lea	rcx, [rax+rdx]
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 24[rbp]
	movsx	rdx, edx
	sal	rdx, 2
	add	rdx, rax
	mov	eax, DWORD PTR [rcx]
	mov	DWORD PTR [rdx], eax
	jmp	.L839
.L830:
.L833:
.L837:
	nop
	jmp	.L839
.L838:
	nop
.L834:
.L839:
	nop
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIiE5CLEAREv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIiE5CLEAREv
_ZN5ArrayIiE5CLEAREv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
.L841:
	mov	DWORD PTR -12[rbp], 0
	mov	DWORD PTR -4[rbp], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	sub	eax, 1
	mov	DWORD PTR -8[rbp], eax
	jmp	.L842
.L848:
	nop
.L843:
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR -4[rbp]
	movsx	rdx, edx
	sal	rdx, 2
	add	rdx, rax
	mov	eax, DWORD PTR -12[rbp]
	mov	DWORD PTR [rdx], eax
.L844:
	add	DWORD PTR -4[rbp], 1
.L842:
	mov	eax, DWORD PTR -4[rbp]
	cmp	eax, DWORD PTR -8[rbp]
	jle	.L848
	nop
.L845:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	DWORD PTR [rax], 0
	nop
	add	rsp, 16
	pop	rbp
	ret
.L846:
	.seh_endproc
	.def	_ZN5ArrayIiE11GETITERATOREv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIiE11GETITERATOREv
_ZN5ArrayIiE11GETITERATOREv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
	lea	rax, -16[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
.L850:
	lea	rax, -32[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	lea	rax, -32[rbp]
	mov	rdx, QWORD PTR 24[rbp]
	mov	QWORD PTR [rax], rdx
	lea	rax, -32[rbp]
	add	rax, 8
	mov	DWORD PTR [rax], 0
	mov	rax, QWORD PTR -32[rbp]
	mov	rdx, QWORD PTR -24[rbp]
	mov	QWORD PTR -16[rbp], rax
	mov	QWORD PTR -8[rbp], rdx
	nop
.L851:
	mov	rcx, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR -16[rbp]
	mov	rdx, QWORD PTR -8[rbp]
	mov	QWORD PTR [rcx], rax
	mov	QWORD PTR 8[rcx], rdx
	mov	rax, QWORD PTR 16[rbp]
	add	rsp, 32
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN13ArrayIteratorIN3TKO8LINEMARKEE7ISVALIDEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN13ArrayIteratorIN3TKO8LINEMARKEE7ISVALIDEv
_ZN13ArrayIteratorIN3TKO8LINEMARKEE7ISVALIDEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	BYTE PTR -9[rbp], 0
.L854:
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	QWORD PTR -8[rbp], rax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR -8[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	edx, eax
	setl	al
	mov	BYTE PTR -9[rbp], al
	nop
.L855:
	movzx	eax, BYTE PTR -9[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN13ArrayIteratorIN3TKO8LINEMARKEE5VALUEEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN13ArrayIteratorIN3TKO8LINEMARKEE5VALUEEv
_ZN13ArrayIteratorIN3TKO8LINEMARKEE5VALUEEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR -16[rbp], 0
.L858:
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	QWORD PTR -8[rbp], rax
	mov	rax, QWORD PTR -8[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	eax, DWORD PTR [rax]
	movsx	rdx, eax
	mov	rax, rdx
	add	rax, rax
	add	rax, rdx
	sal	rax, 2
	add	rax, rcx
	mov	QWORD PTR -16[rbp], rax
	nop
.L859:
	mov	rax, QWORD PTR -16[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN13ArrayIteratorIN3TKO8LINEMARKEE8MOVENEXTEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN13ArrayIteratorIN3TKO8LINEMARKEE8MOVENEXTEv
_ZN13ArrayIteratorIN3TKO8LINEMARKEE8MOVENEXTEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
.L862:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	add	edx, 1
	mov	DWORD PTR [rax], edx
	nop
	pop	rbp
	ret
.L863:
	.seh_endproc
	.def	_ZN5ArrayIN3TKO8LINEMARKEE5COUNTEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO8LINEMARKEE5COUNTEv
_ZN5ArrayIN3TKO8LINEMARKEE5COUNTEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR -4[rbp], 0
.L865:
	mov	rax, QWORD PTR 16[rbp]
	mov	eax, DWORD PTR 72[rax]
	mov	DWORD PTR -4[rbp], eax
	nop
.L866:
	mov	eax, DWORD PTR -4[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO8LINEMARKEE8CAPACITYEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO8LINEMARKEE8CAPACITYEv
_ZN5ArrayIN3TKO8LINEMARKEE8CAPACITYEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 64
	.seh_stackalloc	64
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR -20[rbp], 0
.L869:
	mov	edx, 1
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayUBound
	mov	QWORD PTR -8[rbp], rax
	mov	edx, 1
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayLBound
	mov	QWORD PTR -16[rbp], rax
	mov	rax, QWORD PTR -8[rbp]
	mov	edx, eax
	mov	rax, QWORD PTR -16[rbp]
	sub	edx, eax
	mov	eax, edx
	add	eax, 1
	mov	DWORD PTR -20[rbp], eax
	nop
.L870:
	mov	eax, DWORD PTR -20[rbp]
	add	rsp, 64
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO8LINEMARKEE7ISEMPTYEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO8LINEMARKEE7ISEMPTYEv
_ZN5ArrayIN3TKO8LINEMARKEE7ISEMPTYEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	BYTE PTR -1[rbp], 0
.L873:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	sete	al
	mov	BYTE PTR -1[rbp], al
	nop
.L874:
	movzx	eax, BYTE PTR -1[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO8LINEMARKEE7RESERVEEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO8LINEMARKEE7RESERVEEi
_ZN5ArrayIN3TKO8LINEMARKEE7RESERVEEi:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 80
	.seh_stackalloc	80
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
.L877:
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIN3TKO8LINEMARKEE8CAPACITYEv
	mov	DWORD PTR -8[rbp], eax
	mov	eax, DWORD PTR 24[rbp]
	cmp	eax, DWORD PTR -8[rbp]
	jle	.L890
	nop
.L879:
.L881:
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIN3TKO8LINEMARKEE8CAPACITYEv
	mov	DWORD PTR -12[rbp], eax
	mov	eax, DWORD PTR -12[rbp]
	mov	DWORD PTR -4[rbp], eax
	cmp	DWORD PTR -4[rbp], 7
	jg	.L891
	mov	DWORD PTR -4[rbp], 8
	jmp	.L888
.L883:
.L884:
.L891:
	nop
.L885:
.L888:
	mov	eax, DWORD PTR -4[rbp]
	cmp	eax, DWORD PTR 24[rbp]
	jge	.L892
	mov	eax, DWORD PTR -4[rbp]
	cdqe
	add	rax, rax
	mov	DWORD PTR -4[rbp], eax
	jmp	.L888
.L892:
	nop
.L887:
	mov	eax, DWORD PTR -4[rbp]
	cdqe
	sub	rax, 1
	mov	QWORD PTR 48[rsp], rax
	mov	QWORD PTR 40[rsp], 0
	mov	QWORD PTR 32[rsp], 1
	mov	r9d, 0
	mov	r8d, -1
	mov	edx, 12
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayRedimPresvEx
	jmp	.L893
.L890:
	nop
.L880:
.L893:
	nop
	add	rsp, 80
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO8LINEMARKEE6SHRINKEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO8LINEMARKEE6SHRINKEv
_ZN5ArrayIN3TKO8LINEMARKEE6SHRINKEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 80
	.seh_stackalloc	80
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
.L895:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	jne	.L904
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayErase
	jmp	.L898
.L897:
.L904:
	nop
.L899:
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIN3TKO8LINEMARKEE8CAPACITYEv
	mov	DWORD PTR -4[rbp], eax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR -4[rbp], eax
	je	.L905
	nop
.L901:
.L902:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cdqe
	sub	rax, 1
	mov	QWORD PTR 48[rsp], rax
	mov	QWORD PTR 40[rsp], 0
	mov	QWORD PTR 32[rsp], 1
	mov	r9d, 0
	mov	r8d, -1
	mov	edx, 12
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayRedimPresvEx
	jmp	.L906
.L905:
	nop
.L898:
.L906:
	nop
	add	rsp, 80
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO8LINEMARKEEixEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO8LINEMARKEEixEi
_ZN5ArrayIN3TKO8LINEMARKEEixEi:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
	mov	QWORD PTR -8[rbp], 0
.L908:
	mov	rax, QWORD PTR 16[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	eax, DWORD PTR 24[rbp]
	movsx	rdx, eax
	mov	rax, rdx
	add	rax, rax
	add	rax, rdx
	sal	rax, 2
	add	rax, rcx
	mov	QWORD PTR -8[rbp], rax
	nop
.L909:
	mov	rax, QWORD PTR -8[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO8LINEMARKEE2ATEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO8LINEMARKEE2ATEi
_ZN5ArrayIN3TKO8LINEMARKEE2ATEi:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
	mov	QWORD PTR -8[rbp], 0
.L912:
	mov	rax, QWORD PTR 16[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	eax, DWORD PTR 24[rbp]
	movsx	rdx, eax
	mov	rax, rdx
	add	rax, rax
	add	rax, rdx
	sal	rax, 2
	add	rax, rcx
	mov	QWORD PTR -8[rbp], rax
	nop
.L913:
	mov	rax, QWORD PTR -8[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO8LINEMARKEE4PUSHERS1_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO8LINEMARKEE4PUSHERS1_
_ZN5ArrayIN3TKO8LINEMARKEE4PUSHERS1_:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
.L916:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	add	eax, 1
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIN3TKO8LINEMARKEE7RESERVEEi
	mov	rax, QWORD PTR 16[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	movsx	rdx, eax
	mov	rax, rdx
	add	rax, rax
	add	rax, rdx
	sal	rax, 2
	lea	rdx, [rcx+rax]
	mov	rax, QWORD PTR 24[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	QWORD PTR [rdx], rcx
	mov	eax, DWORD PTR 8[rax]
	mov	DWORD PTR 8[rdx], eax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	add	edx, 1
	mov	DWORD PTR [rax], edx
	nop
	add	rsp, 32
	pop	rbp
	ret
.L917:
	.seh_endproc
	.def	_ZN5ArrayIN3TKO8LINEMARKEE3POPEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO8LINEMARKEE3POPEv
_ZN5ArrayIN3TKO8LINEMARKEE3POPEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
	lea	rax, -12[rbp]
	mov	QWORD PTR [rax], 0
	mov	DWORD PTR 8[rax], 0
.L919:
	lea	rax, -24[rbp]
	mov	QWORD PTR [rax], 0
	mov	DWORD PTR 8[rax], 0
	mov	rax, QWORD PTR 24[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	jne	.L926
	mov	rax, QWORD PTR -24[rbp]
	mov	QWORD PTR -12[rbp], rax
	mov	eax, DWORD PTR -16[rbp]
	mov	DWORD PTR -4[rbp], eax
	jmp	.L922
.L921:
.L926:
	nop
.L923:
	mov	rax, QWORD PTR 24[rbp]
	add	rax, 72
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 24[rbp]
	add	rax, 72
	sub	edx, 1
	mov	DWORD PTR [rax], edx
	mov	rax, QWORD PTR 24[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	rax, QWORD PTR 24[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	movsx	rdx, eax
	mov	rax, rdx
	add	rax, rax
	add	rax, rdx
	sal	rax, 2
	lea	rdx, [rcx+rax]
	lea	rax, -24[rbp]
	mov	rcx, QWORD PTR [rdx]
	mov	QWORD PTR [rax], rcx
	mov	edx, DWORD PTR 8[rdx]
	mov	DWORD PTR 8[rax], edx
	mov	rax, QWORD PTR -24[rbp]
	mov	QWORD PTR -12[rbp], rax
	mov	eax, DWORD PTR -16[rbp]
	mov	DWORD PTR -4[rbp], eax
	nop
.L922:
	mov	rax, QWORD PTR 16[rbp]
	mov	rdx, QWORD PTR -12[rbp]
	mov	QWORD PTR [rax], rdx
	mov	edx, DWORD PTR -4[rbp]
	mov	DWORD PTR 8[rax], edx
	mov	rax, QWORD PTR 16[rbp]
	add	rsp, 32
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO8LINEMARKEE6INSERTEiRS1_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO8LINEMARKEE6INSERTEiRS1_
_ZN5ArrayIN3TKO8LINEMARKEE6INSERTEiRS1_:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 64
	.seh_stackalloc	64
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
	mov	QWORD PTR 32[rbp], r8
.L928:
	cmp	DWORD PTR 24[rbp], 0
	js	.L942
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR 24[rbp], eax
	setg	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -8[rbp], rax
	jmp	.L931
.L942:
	nop
.L930:
	mov	QWORD PTR -8[rbp], -1
.L931:
	cmp	QWORD PTR -8[rbp], 0
	jne	.L943
	nop
.L933:
.L935:
	lea	rax, -28[rbp]
	mov	rdx, QWORD PTR 32[rbp]
	mov	rcx, QWORD PTR [rdx]
	mov	QWORD PTR [rax], rcx
	mov	edx, DWORD PTR 8[rdx]
	mov	DWORD PTR 8[rax], edx
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	add	eax, 1
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIN3TKO8LINEMARKEE7RESERVEEi
	mov	rax, QWORD PTR 16[rbp]
	mov	eax, DWORD PTR 72[rax]
	mov	DWORD PTR -12[rbp], eax
	mov	eax, DWORD PTR 24[rbp]
	add	eax, 1
	mov	DWORD PTR -16[rbp], eax
	jmp	.L936
.L944:
	nop
.L937:
	mov	rax, QWORD PTR 16[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	eax, DWORD PTR -12[rbp]
	movsx	rdx, eax
	mov	rax, rdx
	add	rax, rax
	add	rax, rdx
	sal	rax, 2
	sub	rax, 12
	lea	rdx, [rcx+rax]
	mov	rax, QWORD PTR 16[rbp]
	mov	r8, QWORD PTR [rax]
	mov	eax, DWORD PTR -12[rbp]
	movsx	rcx, eax
	mov	rax, rcx
	add	rax, rax
	add	rax, rcx
	sal	rax, 2
	add	rax, r8
	mov	rcx, QWORD PTR [rdx]
	mov	QWORD PTR [rax], rcx
	mov	edx, DWORD PTR 8[rdx]
	mov	DWORD PTR 8[rax], edx
.L938:
	sub	DWORD PTR -12[rbp], 1
.L936:
	mov	eax, DWORD PTR -12[rbp]
	cmp	eax, DWORD PTR -16[rbp]
	jge	.L944
	nop
.L939:
	mov	rax, QWORD PTR 16[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	eax, DWORD PTR 24[rbp]
	movsx	rdx, eax
	mov	rax, rdx
	add	rax, rax
	add	rax, rdx
	sal	rax, 2
	lea	rdx, [rcx+rax]
	lea	rax, -28[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	QWORD PTR [rdx], rcx
	mov	eax, DWORD PTR 8[rax]
	mov	DWORD PTR 8[rdx], eax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	add	edx, 1
	mov	DWORD PTR [rax], edx
	jmp	.L945
.L943:
	nop
.L934:
.L945:
	nop
	add	rsp, 64
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO8LINEMARKEE6REMOVEEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO8LINEMARKEE6REMOVEEi
_ZN5ArrayIN3TKO8LINEMARKEE6REMOVEEi:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
.L947:
	cmp	DWORD PTR 24[rbp], 0
	js	.L961
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR 24[rbp], eax
	setge	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -8[rbp], rax
	jmp	.L950
.L961:
	nop
.L949:
	mov	QWORD PTR -8[rbp], -1
.L950:
	cmp	QWORD PTR -8[rbp], 0
	jne	.L962
	nop
.L952:
.L954:
	mov	eax, DWORD PTR 24[rbp]
	mov	DWORD PTR -12[rbp], eax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	sub	eax, 2
	mov	DWORD PTR -16[rbp], eax
	jmp	.L955
.L963:
	nop
.L956:
	mov	rax, QWORD PTR 16[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	eax, DWORD PTR -12[rbp]
	movsx	rdx, eax
	mov	rax, rdx
	add	rax, rax
	add	rax, rdx
	sal	rax, 2
	add	rax, 12
	lea	rdx, [rcx+rax]
	mov	rax, QWORD PTR 16[rbp]
	mov	r8, QWORD PTR [rax]
	mov	eax, DWORD PTR -12[rbp]
	movsx	rcx, eax
	mov	rax, rcx
	add	rax, rax
	add	rax, rcx
	sal	rax, 2
	add	rax, r8
	mov	rcx, QWORD PTR [rdx]
	mov	QWORD PTR [rax], rcx
	mov	edx, DWORD PTR 8[rdx]
	mov	DWORD PTR 8[rax], edx
.L957:
	add	DWORD PTR -12[rbp], 1
.L955:
	mov	eax, DWORD PTR -12[rbp]
	cmp	eax, DWORD PTR -16[rbp]
	jle	.L963
	nop
.L958:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	sub	edx, 1
	mov	DWORD PTR [rax], edx
	jmp	.L964
.L962:
	nop
.L953:
.L964:
	nop
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO8LINEMARKEE10REMOVESWAPEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO8LINEMARKEE10REMOVESWAPEi
_ZN5ArrayIN3TKO8LINEMARKEE10REMOVESWAPEi:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
.L966:
	cmp	DWORD PTR 24[rbp], 0
	js	.L978
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR 24[rbp], eax
	setge	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -8[rbp], rax
	jmp	.L969
.L978:
	nop
.L968:
	mov	QWORD PTR -8[rbp], -1
.L969:
	cmp	QWORD PTR -8[rbp], 0
	jne	.L979
	nop
.L971:
.L973:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	sub	edx, 1
	mov	DWORD PTR [rax], edx
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR 24[rbp], eax
	je	.L980
	mov	rax, QWORD PTR 16[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	movsx	rdx, eax
	mov	rax, rdx
	add	rax, rax
	add	rax, rdx
	sal	rax, 2
	lea	rdx, [rcx+rax]
	mov	rax, QWORD PTR 16[rbp]
	mov	r8, QWORD PTR [rax]
	mov	eax, DWORD PTR 24[rbp]
	movsx	rcx, eax
	mov	rax, rcx
	add	rax, rax
	add	rax, rcx
	sal	rax, 2
	add	rax, r8
	mov	rcx, QWORD PTR [rdx]
	mov	QWORD PTR [rax], rcx
	mov	edx, DWORD PTR 8[rdx]
	mov	DWORD PTR 8[rax], edx
	jmp	.L981
.L972:
.L975:
.L979:
	nop
	jmp	.L981
.L980:
	nop
.L976:
.L981:
	nop
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO8LINEMARKEE5CLEAREv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO8LINEMARKEE5CLEAREv
_ZN5ArrayIN3TKO8LINEMARKEE5CLEAREv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
.L983:
	lea	rax, -20[rbp]
	mov	QWORD PTR [rax], 0
	mov	DWORD PTR 8[rax], 0
	mov	DWORD PTR -4[rbp], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	sub	eax, 1
	mov	DWORD PTR -8[rbp], eax
	jmp	.L984
.L990:
	nop
.L985:
	mov	rax, QWORD PTR 16[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	eax, DWORD PTR -4[rbp]
	movsx	rdx, eax
	mov	rax, rdx
	add	rax, rax
	add	rax, rdx
	sal	rax, 2
	lea	rdx, [rcx+rax]
	lea	rax, -20[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	QWORD PTR [rdx], rcx
	mov	eax, DWORD PTR 8[rax]
	mov	DWORD PTR 8[rdx], eax
.L986:
	add	DWORD PTR -4[rbp], 1
.L984:
	mov	eax, DWORD PTR -4[rbp]
	cmp	eax, DWORD PTR -8[rbp]
	jle	.L990
	nop
.L987:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	DWORD PTR [rax], 0
	nop
	add	rsp, 32
	pop	rbp
	ret
.L988:
	.seh_endproc
	.def	_ZN5ArrayIN3TKO8LINEMARKEE11GETITERATOREv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO8LINEMARKEE11GETITERATOREv
_ZN5ArrayIN3TKO8LINEMARKEE11GETITERATOREv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
	lea	rax, -16[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
.L992:
	lea	rax, -32[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	lea	rax, -32[rbp]
	mov	rdx, QWORD PTR 24[rbp]
	mov	QWORD PTR [rax], rdx
	lea	rax, -32[rbp]
	add	rax, 8
	mov	DWORD PTR [rax], 0
	mov	rax, QWORD PTR -32[rbp]
	mov	rdx, QWORD PTR -24[rbp]
	mov	QWORD PTR -16[rbp], rax
	mov	QWORD PTR -8[rbp], rdx
	nop
.L993:
	mov	rcx, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR -16[rbp]
	mov	rdx, QWORD PTR -8[rbp]
	mov	QWORD PTR [rcx], rax
	mov	QWORD PTR 8[rcx], rdx
	mov	rax, QWORD PTR 16[rbp]
	add	rsp, 32
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN13ArrayIteratorIPN3TKO10SOURCEFILEEE7ISVALIDEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN13ArrayIteratorIPN3TKO10SOURCEFILEEE7ISVALIDEv
_ZN13ArrayIteratorIPN3TKO10SOURCEFILEEE7ISVALIDEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	BYTE PTR -9[rbp], 0
.L996:
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	QWORD PTR -8[rbp], rax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR -8[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	edx, eax
	setl	al
	mov	BYTE PTR -9[rbp], al
	nop
.L997:
	movzx	eax, BYTE PTR -9[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN13ArrayIteratorIPN3TKO10SOURCEFILEEE5VALUEEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN13ArrayIteratorIPN3TKO10SOURCEFILEEE5VALUEEv
_ZN13ArrayIteratorIPN3TKO10SOURCEFILEEE5VALUEEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR -16[rbp], 0
.L1000:
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	QWORD PTR -8[rbp], rax
	mov	rax, QWORD PTR -8[rbp]
	mov	rax, QWORD PTR [rax]
	mov	rdx, QWORD PTR 16[rbp]
	add	rdx, 8
	mov	edx, DWORD PTR [rdx]
	movsx	rdx, edx
	sal	rdx, 3
	add	rax, rdx
	mov	QWORD PTR -16[rbp], rax
	nop
.L1001:
	mov	rax, QWORD PTR -16[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN13ArrayIteratorIPN3TKO10SOURCEFILEEE8MOVENEXTEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN13ArrayIteratorIPN3TKO10SOURCEFILEEE8MOVENEXTEv
_ZN13ArrayIteratorIPN3TKO10SOURCEFILEEE8MOVENEXTEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
.L1004:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	add	edx, 1
	mov	DWORD PTR [rax], edx
	nop
	pop	rbp
	ret
.L1005:
	.seh_endproc
	.def	_ZN5ArrayIPN3TKO10SOURCEFILEEE5COUNTEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIPN3TKO10SOURCEFILEEE5COUNTEv
_ZN5ArrayIPN3TKO10SOURCEFILEEE5COUNTEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR -4[rbp], 0
.L1007:
	mov	rax, QWORD PTR 16[rbp]
	mov	eax, DWORD PTR 72[rax]
	mov	DWORD PTR -4[rbp], eax
	nop
.L1008:
	mov	eax, DWORD PTR -4[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIPN3TKO10SOURCEFILEEE8CAPACITYEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIPN3TKO10SOURCEFILEEE8CAPACITYEv
_ZN5ArrayIPN3TKO10SOURCEFILEEE8CAPACITYEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 64
	.seh_stackalloc	64
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR -20[rbp], 0
.L1011:
	mov	edx, 1
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayUBound
	mov	QWORD PTR -8[rbp], rax
	mov	edx, 1
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayLBound
	mov	QWORD PTR -16[rbp], rax
	mov	rax, QWORD PTR -8[rbp]
	mov	edx, eax
	mov	rax, QWORD PTR -16[rbp]
	sub	edx, eax
	mov	eax, edx
	add	eax, 1
	mov	DWORD PTR -20[rbp], eax
	nop
.L1012:
	mov	eax, DWORD PTR -20[rbp]
	add	rsp, 64
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIPN3TKO10SOURCEFILEEE7ISEMPTYEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIPN3TKO10SOURCEFILEEE7ISEMPTYEv
_ZN5ArrayIPN3TKO10SOURCEFILEEE7ISEMPTYEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	BYTE PTR -1[rbp], 0
.L1015:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	sete	al
	mov	BYTE PTR -1[rbp], al
	nop
.L1016:
	movzx	eax, BYTE PTR -1[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIPN3TKO10SOURCEFILEEE7RESERVEEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIPN3TKO10SOURCEFILEEE7RESERVEEi
_ZN5ArrayIPN3TKO10SOURCEFILEEE7RESERVEEi:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 80
	.seh_stackalloc	80
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
.L1019:
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIPN3TKO10SOURCEFILEEE8CAPACITYEv
	mov	DWORD PTR -8[rbp], eax
	mov	eax, DWORD PTR 24[rbp]
	cmp	eax, DWORD PTR -8[rbp]
	jle	.L1032
	nop
.L1021:
.L1023:
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIPN3TKO10SOURCEFILEEE8CAPACITYEv
	mov	DWORD PTR -12[rbp], eax
	mov	eax, DWORD PTR -12[rbp]
	mov	DWORD PTR -4[rbp], eax
	cmp	DWORD PTR -4[rbp], 7
	jg	.L1033
	mov	DWORD PTR -4[rbp], 8
	jmp	.L1030
.L1025:
.L1026:
.L1033:
	nop
.L1027:
.L1030:
	mov	eax, DWORD PTR -4[rbp]
	cmp	eax, DWORD PTR 24[rbp]
	jge	.L1034
	mov	eax, DWORD PTR -4[rbp]
	cdqe
	add	rax, rax
	mov	DWORD PTR -4[rbp], eax
	jmp	.L1030
.L1034:
	nop
.L1029:
	mov	eax, DWORD PTR -4[rbp]
	cdqe
	sub	rax, 1
	mov	QWORD PTR 48[rsp], rax
	mov	QWORD PTR 40[rsp], 0
	mov	QWORD PTR 32[rsp], 1
	mov	r9d, 0
	mov	r8d, -1
	mov	edx, 8
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayRedimPresvEx
	jmp	.L1035
.L1032:
	nop
.L1022:
.L1035:
	nop
	add	rsp, 80
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIPN3TKO10SOURCEFILEEE6SHRINKEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIPN3TKO10SOURCEFILEEE6SHRINKEv
_ZN5ArrayIPN3TKO10SOURCEFILEEE6SHRINKEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 80
	.seh_stackalloc	80
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
.L1037:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	jne	.L1046
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayErase
	jmp	.L1040
.L1039:
.L1046:
	nop
.L1041:
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIPN3TKO10SOURCEFILEEE8CAPACITYEv
	mov	DWORD PTR -4[rbp], eax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR -4[rbp], eax
	je	.L1047
	nop
.L1043:
.L1044:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cdqe
	sub	rax, 1
	mov	QWORD PTR 48[rsp], rax
	mov	QWORD PTR 40[rsp], 0
	mov	QWORD PTR 32[rsp], 1
	mov	r9d, 0
	mov	r8d, -1
	mov	edx, 8
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayRedimPresvEx
	jmp	.L1048
.L1047:
	nop
.L1040:
.L1048:
	nop
	add	rsp, 80
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIPN3TKO10SOURCEFILEEEixEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIPN3TKO10SOURCEFILEEEixEi
_ZN5ArrayIPN3TKO10SOURCEFILEEEixEi:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
	mov	QWORD PTR -8[rbp], 0
.L1050:
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 24[rbp]
	movsx	rdx, edx
	sal	rdx, 3
	add	rax, rdx
	mov	QWORD PTR -8[rbp], rax
	nop
.L1051:
	mov	rax, QWORD PTR -8[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIPN3TKO10SOURCEFILEEE2ATEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIPN3TKO10SOURCEFILEEE2ATEi
_ZN5ArrayIPN3TKO10SOURCEFILEEE2ATEi:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
	mov	QWORD PTR -8[rbp], 0
.L1054:
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 24[rbp]
	movsx	rdx, edx
	sal	rdx, 3
	add	rax, rdx
	mov	QWORD PTR -8[rbp], rax
	nop
.L1055:
	mov	rax, QWORD PTR -8[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIPN3TKO10SOURCEFILEEE4PUSHERS2_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIPN3TKO10SOURCEFILEEE4PUSHERS2_
_ZN5ArrayIPN3TKO10SOURCEFILEEE4PUSHERS2_:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
.L1058:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	add	eax, 1
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIPN3TKO10SOURCEFILEEE7RESERVEEi
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	rdx, QWORD PTR 16[rbp]
	add	rdx, 72
	mov	edx, DWORD PTR [rdx]
	movsx	rdx, edx
	sal	rdx, 3
	add	rdx, rax
	mov	rax, QWORD PTR 24[rbp]
	mov	rax, QWORD PTR [rax]
	mov	QWORD PTR [rdx], rax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	add	edx, 1
	mov	DWORD PTR [rax], edx
	nop
	add	rsp, 32
	pop	rbp
	ret
.L1059:
	.seh_endproc
	.def	_ZN5ArrayIPN3TKO10SOURCEFILEEE3POPEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIPN3TKO10SOURCEFILEEE3POPEv
_ZN5ArrayIPN3TKO10SOURCEFILEEE3POPEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR -8[rbp], 0
.L1061:
	mov	QWORD PTR -16[rbp], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	jne	.L1068
	mov	rax, QWORD PTR -16[rbp]
	mov	QWORD PTR -8[rbp], rax
	jmp	.L1064
.L1063:
.L1068:
	nop
.L1065:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	sub	edx, 1
	mov	DWORD PTR [rax], edx
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	rdx, QWORD PTR 16[rbp]
	add	rdx, 72
	mov	edx, DWORD PTR [rdx]
	movsx	rdx, edx
	sal	rdx, 3
	add	rax, rdx
	mov	rax, QWORD PTR [rax]
	mov	QWORD PTR -16[rbp], rax
	mov	rax, QWORD PTR -16[rbp]
	mov	QWORD PTR -8[rbp], rax
	nop
.L1064:
	mov	rax, QWORD PTR -8[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIPN3TKO10SOURCEFILEEE6INSERTEiRS2_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIPN3TKO10SOURCEFILEEE6INSERTEiRS2_
_ZN5ArrayIPN3TKO10SOURCEFILEEE6INSERTEiRS2_:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 64
	.seh_stackalloc	64
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
	mov	QWORD PTR 32[rbp], r8
.L1070:
	cmp	DWORD PTR 24[rbp], 0
	js	.L1084
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR 24[rbp], eax
	setg	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -8[rbp], rax
	jmp	.L1073
.L1084:
	nop
.L1072:
	mov	QWORD PTR -8[rbp], -1
.L1073:
	cmp	QWORD PTR -8[rbp], 0
	jne	.L1085
	nop
.L1075:
.L1077:
	mov	rax, QWORD PTR 32[rbp]
	mov	rax, QWORD PTR [rax]
	mov	QWORD PTR -24[rbp], rax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	add	eax, 1
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIPN3TKO10SOURCEFILEEE7RESERVEEi
	mov	rax, QWORD PTR 16[rbp]
	mov	eax, DWORD PTR 72[rax]
	mov	DWORD PTR -12[rbp], eax
	mov	eax, DWORD PTR 24[rbp]
	add	eax, 1
	mov	DWORD PTR -28[rbp], eax
	jmp	.L1078
.L1086:
	nop
.L1079:
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR -12[rbp]
	movsx	rdx, edx
	sal	rdx, 3
	sub	rdx, 8
	lea	rcx, [rax+rdx]
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR -12[rbp]
	movsx	rdx, edx
	sal	rdx, 3
	add	rdx, rax
	mov	rax, QWORD PTR [rcx]
	mov	QWORD PTR [rdx], rax
.L1080:
	sub	DWORD PTR -12[rbp], 1
.L1078:
	mov	eax, DWORD PTR -12[rbp]
	cmp	eax, DWORD PTR -28[rbp]
	jge	.L1086
	nop
.L1081:
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 24[rbp]
	movsx	rdx, edx
	sal	rdx, 3
	add	rdx, rax
	mov	rax, QWORD PTR -24[rbp]
	mov	QWORD PTR [rdx], rax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	add	edx, 1
	mov	DWORD PTR [rax], edx
	jmp	.L1087
.L1085:
	nop
.L1076:
.L1087:
	nop
	add	rsp, 64
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIPN3TKO10SOURCEFILEEE6REMOVEEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIPN3TKO10SOURCEFILEEE6REMOVEEi
_ZN5ArrayIPN3TKO10SOURCEFILEEE6REMOVEEi:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
.L1089:
	cmp	DWORD PTR 24[rbp], 0
	js	.L1103
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR 24[rbp], eax
	setge	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -8[rbp], rax
	jmp	.L1092
.L1103:
	nop
.L1091:
	mov	QWORD PTR -8[rbp], -1
.L1092:
	cmp	QWORD PTR -8[rbp], 0
	jne	.L1104
	nop
.L1094:
.L1096:
	mov	eax, DWORD PTR 24[rbp]
	mov	DWORD PTR -12[rbp], eax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	sub	eax, 2
	mov	DWORD PTR -16[rbp], eax
	jmp	.L1097
.L1105:
	nop
.L1098:
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR -12[rbp]
	movsx	rdx, edx
	sal	rdx, 3
	add	rdx, 8
	lea	rcx, [rax+rdx]
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR -12[rbp]
	movsx	rdx, edx
	sal	rdx, 3
	add	rdx, rax
	mov	rax, QWORD PTR [rcx]
	mov	QWORD PTR [rdx], rax
.L1099:
	add	DWORD PTR -12[rbp], 1
.L1097:
	mov	eax, DWORD PTR -12[rbp]
	cmp	eax, DWORD PTR -16[rbp]
	jle	.L1105
	nop
.L1100:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	sub	edx, 1
	mov	DWORD PTR [rax], edx
	jmp	.L1106
.L1104:
	nop
.L1095:
.L1106:
	nop
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIPN3TKO10SOURCEFILEEE10REMOVESWAPEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIPN3TKO10SOURCEFILEEE10REMOVESWAPEi
_ZN5ArrayIPN3TKO10SOURCEFILEEE10REMOVESWAPEi:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
.L1108:
	cmp	DWORD PTR 24[rbp], 0
	js	.L1120
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR 24[rbp], eax
	setge	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -8[rbp], rax
	jmp	.L1111
.L1120:
	nop
.L1110:
	mov	QWORD PTR -8[rbp], -1
.L1111:
	cmp	QWORD PTR -8[rbp], 0
	jne	.L1121
	nop
.L1113:
.L1115:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	sub	edx, 1
	mov	DWORD PTR [rax], edx
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR 24[rbp], eax
	je	.L1122
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	rdx, QWORD PTR 16[rbp]
	add	rdx, 72
	mov	edx, DWORD PTR [rdx]
	movsx	rdx, edx
	sal	rdx, 3
	lea	rcx, [rax+rdx]
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 24[rbp]
	movsx	rdx, edx
	sal	rdx, 3
	add	rdx, rax
	mov	rax, QWORD PTR [rcx]
	mov	QWORD PTR [rdx], rax
	jmp	.L1123
.L1114:
.L1117:
.L1121:
	nop
	jmp	.L1123
.L1122:
	nop
.L1118:
.L1123:
	nop
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIPN3TKO10SOURCEFILEEE5CLEAREv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIPN3TKO10SOURCEFILEEE5CLEAREv
_ZN5ArrayIPN3TKO10SOURCEFILEEE5CLEAREv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
.L1125:
	mov	QWORD PTR -16[rbp], 0
	mov	DWORD PTR -4[rbp], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	sub	eax, 1
	mov	DWORD PTR -8[rbp], eax
	jmp	.L1126
.L1132:
	nop
.L1127:
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR -4[rbp]
	movsx	rdx, edx
	sal	rdx, 3
	add	rdx, rax
	mov	rax, QWORD PTR -16[rbp]
	mov	QWORD PTR [rdx], rax
.L1128:
	add	DWORD PTR -4[rbp], 1
.L1126:
	mov	eax, DWORD PTR -4[rbp]
	cmp	eax, DWORD PTR -8[rbp]
	jle	.L1132
	nop
.L1129:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	DWORD PTR [rax], 0
	nop
	add	rsp, 16
	pop	rbp
	ret
.L1130:
	.seh_endproc
	.def	_ZN5ArrayIPN3TKO10SOURCEFILEEE11GETITERATOREv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIPN3TKO10SOURCEFILEEE11GETITERATOREv
_ZN5ArrayIPN3TKO10SOURCEFILEEE11GETITERATOREv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
	lea	rax, -16[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
.L1134:
	lea	rax, -32[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	lea	rax, -32[rbp]
	mov	rdx, QWORD PTR 24[rbp]
	mov	QWORD PTR [rax], rdx
	lea	rax, -32[rbp]
	add	rax, 8
	mov	DWORD PTR [rax], 0
	mov	rax, QWORD PTR -32[rbp]
	mov	rdx, QWORD PTR -24[rbp]
	mov	QWORD PTR -16[rbp], rax
	mov	QWORD PTR -8[rbp], rdx
	nop
.L1135:
	mov	rcx, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR -16[rbp]
	mov	rdx, QWORD PTR -8[rbp]
	mov	QWORD PTR [rcx], rax
	mov	QWORD PTR 8[rcx], rdx
	mov	rax, QWORD PTR 16[rbp]
	add	rsp, 32
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN6ResultIbN2FB7FSERROREE4ISOKEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN6ResultIbN2FB7FSERROREE4ISOKEv
_ZN6ResultIbN2FB7FSERROREE4ISOKEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	BYTE PTR -1[rbp], 0
.L1138:
	mov	rax, QWORD PTR 16[rbp]
	movzx	eax, BYTE PTR 96[rax]
	mov	BYTE PTR -1[rbp], al
	nop
.L1139:
	movzx	eax, BYTE PTR -1[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.section .rdata,"dr"
	.align 8
.LC0:
	.ascii "C:\\dev\\fbc-modern\\toolchains\\fbc-modern-windows\\inc\\fb\\result.bi\0"
	.text
	.def	_ZN6ResultIbN2FB7FSERROREE5VALUEEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN6ResultIbN2FB7FSERROREE5VALUEEv
_ZN6ResultIbN2FB7FSERROREE5VALUEEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 64
	.seh_stackalloc	64
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR -16[rbp], 0
.L1142:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 96
	movzx	eax, BYTE PTR [rax]
	test	al, al
	jne	.L1150
	nop
.L1143:
	mov	QWORD PTR 32[rsp], 0
	mov	r9d, 0
	lea	r8, .LC0[rip]
	mov	edx, 87
	mov	ecx, 1
	call	fb_ErrorThrowEx
	mov	QWORD PTR -8[rbp], rax
	jmp	[QWORD PTR -8[rbp]]
.L1144:
.L1145:
.L1150:
	nop
.L1146:
	mov	rax, QWORD PTR 16[rbp]
	mov	QWORD PTR -16[rbp], rax
	nop
.L1147:
	mov	rax, QWORD PTR -16[rbp]
	add	rsp, 64
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN6ResultIbN2FB7FSERROREE7FAILUREEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN6ResultIbN2FB7FSERROREE7FAILUREEv
_ZN6ResultIbN2FB7FSERROREE7FAILUREEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 64
	.seh_stackalloc	64
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR -16[rbp], 0
.L1152:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 96
	movzx	eax, BYTE PTR [rax]
	test	al, al
	je	.L1160
	nop
.L1153:
	mov	QWORD PTR 32[rsp], 0
	mov	r9d, 0
	lea	r8, .LC0[rip]
	mov	edx, 105
	mov	ecx, 1
	call	fb_ErrorThrowEx
	mov	QWORD PTR -8[rbp], rax
	jmp	[QWORD PTR -8[rbp]]
.L1154:
.L1155:
.L1160:
	nop
.L1156:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	QWORD PTR -16[rbp], rax
	nop
.L1157:
	mov	rax, QWORD PTR -16[rbp]
	add	rsp, 64
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN6ResultIbN2FB7FSERROREE7VALUEORERb;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN6ResultIbN2FB7FSERROREE7VALUEORERb
_ZN6ResultIbN2FB7FSERROREE7VALUEORERb:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
	mov	QWORD PTR -8[rbp], 0
.L1162:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 96
	movzx	eax, BYTE PTR [rax]
	test	al, al
	jne	.L1169
	mov	rax, QWORD PTR 24[rbp]
	mov	QWORD PTR -8[rbp], rax
	jmp	.L1165
.L1164:
.L1169:
	nop
.L1166:
	mov	rax, QWORD PTR 16[rbp]
	mov	QWORD PTR -8[rbp], rax
	nop
.L1165:
	mov	rax, QWORD PTR -8[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN6ResultIiN2FB7FSERROREE4ISOKEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN6ResultIiN2FB7FSERROREE4ISOKEv
_ZN6ResultIiN2FB7FSERROREE4ISOKEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	BYTE PTR -1[rbp], 0
.L1171:
	mov	rax, QWORD PTR 16[rbp]
	movzx	eax, BYTE PTR 96[rax]
	mov	BYTE PTR -1[rbp], al
	nop
.L1172:
	movzx	eax, BYTE PTR -1[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN6ResultIiN2FB7FSERROREE5VALUEEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN6ResultIiN2FB7FSERROREE5VALUEEv
_ZN6ResultIiN2FB7FSERROREE5VALUEEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 64
	.seh_stackalloc	64
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR -16[rbp], 0
.L1175:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 96
	movzx	eax, BYTE PTR [rax]
	test	al, al
	jne	.L1183
	nop
.L1176:
	mov	QWORD PTR 32[rsp], 0
	mov	r9d, 0
	lea	r8, .LC0[rip]
	mov	edx, 87
	mov	ecx, 1
	call	fb_ErrorThrowEx
	mov	QWORD PTR -8[rbp], rax
	jmp	[QWORD PTR -8[rbp]]
.L1177:
.L1178:
.L1183:
	nop
.L1179:
	mov	rax, QWORD PTR 16[rbp]
	mov	QWORD PTR -16[rbp], rax
	nop
.L1180:
	mov	rax, QWORD PTR -16[rbp]
	add	rsp, 64
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN6ResultIiN2FB7FSERROREE7FAILUREEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN6ResultIiN2FB7FSERROREE7FAILUREEv
_ZN6ResultIiN2FB7FSERROREE7FAILUREEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 64
	.seh_stackalloc	64
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR -16[rbp], 0
.L1185:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 96
	movzx	eax, BYTE PTR [rax]
	test	al, al
	je	.L1193
	nop
.L1186:
	mov	QWORD PTR 32[rsp], 0
	mov	r9d, 0
	lea	r8, .LC0[rip]
	mov	edx, 105
	mov	ecx, 1
	call	fb_ErrorThrowEx
	mov	QWORD PTR -8[rbp], rax
	jmp	[QWORD PTR -8[rbp]]
.L1187:
.L1188:
.L1193:
	nop
.L1189:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	QWORD PTR -16[rbp], rax
	nop
.L1190:
	mov	rax, QWORD PTR -16[rbp]
	add	rsp, 64
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN6ResultIiN2FB7FSERROREE7VALUEORERi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN6ResultIiN2FB7FSERROREE7VALUEORERi
_ZN6ResultIiN2FB7FSERROREE7VALUEORERi:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
	mov	QWORD PTR -8[rbp], 0
.L1195:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 96
	movzx	eax, BYTE PTR [rax]
	test	al, al
	jne	.L1202
	mov	rax, QWORD PTR 24[rbp]
	mov	QWORD PTR -8[rbp], rax
	jmp	.L1198
.L1197:
.L1202:
	nop
.L1199:
	mov	rax, QWORD PTR 16[rbp]
	mov	QWORD PTR -8[rbp], rax
	nop
.L1198:
	mov	rax, QWORD PTR -8[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN6ResultIxN2FB7FSERROREE4ISOKEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN6ResultIxN2FB7FSERROREE4ISOKEv
_ZN6ResultIxN2FB7FSERROREE4ISOKEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	BYTE PTR -1[rbp], 0
.L1204:
	mov	rax, QWORD PTR 16[rbp]
	movzx	eax, BYTE PTR 96[rax]
	mov	BYTE PTR -1[rbp], al
	nop
.L1205:
	movzx	eax, BYTE PTR -1[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN6ResultIxN2FB7FSERROREE5VALUEEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN6ResultIxN2FB7FSERROREE5VALUEEv
_ZN6ResultIxN2FB7FSERROREE5VALUEEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 64
	.seh_stackalloc	64
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR -16[rbp], 0
.L1208:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 96
	movzx	eax, BYTE PTR [rax]
	test	al, al
	jne	.L1216
	nop
.L1209:
	mov	QWORD PTR 32[rsp], 0
	mov	r9d, 0
	lea	r8, .LC0[rip]
	mov	edx, 87
	mov	ecx, 1
	call	fb_ErrorThrowEx
	mov	QWORD PTR -8[rbp], rax
	jmp	[QWORD PTR -8[rbp]]
.L1210:
.L1211:
.L1216:
	nop
.L1212:
	mov	rax, QWORD PTR 16[rbp]
	mov	QWORD PTR -16[rbp], rax
	nop
.L1213:
	mov	rax, QWORD PTR -16[rbp]
	add	rsp, 64
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN6ResultIxN2FB7FSERROREE7FAILUREEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN6ResultIxN2FB7FSERROREE7FAILUREEv
_ZN6ResultIxN2FB7FSERROREE7FAILUREEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 64
	.seh_stackalloc	64
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR -16[rbp], 0
.L1218:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 96
	movzx	eax, BYTE PTR [rax]
	test	al, al
	je	.L1226
	nop
.L1219:
	mov	QWORD PTR 32[rsp], 0
	mov	r9d, 0
	lea	r8, .LC0[rip]
	mov	edx, 105
	mov	ecx, 1
	call	fb_ErrorThrowEx
	mov	QWORD PTR -8[rbp], rax
	jmp	[QWORD PTR -8[rbp]]
.L1220:
.L1221:
.L1226:
	nop
.L1222:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	QWORD PTR -16[rbp], rax
	nop
.L1223:
	mov	rax, QWORD PTR -16[rbp]
	add	rsp, 64
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN6ResultIxN2FB7FSERROREE7VALUEORERx;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN6ResultIxN2FB7FSERROREE7VALUEORERx
_ZN6ResultIxN2FB7FSERROREE7VALUEORERx:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
	mov	QWORD PTR -8[rbp], 0
.L1228:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 96
	movzx	eax, BYTE PTR [rax]
	test	al, al
	jne	.L1235
	mov	rax, QWORD PTR 24[rbp]
	mov	QWORD PTR -8[rbp], rax
	jmp	.L1231
.L1230:
.L1235:
	nop
.L1232:
	mov	rax, QWORD PTR 16[rbp]
	mov	QWORD PTR -8[rbp], rax
	nop
.L1231:
	mov	rax, QWORD PTR -8[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN6ResultI9FBUSTRINGN2FB7FSERROREE4ISOKEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN6ResultI9FBUSTRINGN2FB7FSERROREE4ISOKEv
_ZN6ResultI9FBUSTRINGN2FB7FSERROREE4ISOKEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	BYTE PTR -1[rbp], 0
.L1237:
	mov	rax, QWORD PTR 16[rbp]
	movzx	eax, BYTE PTR 112[rax]
	mov	BYTE PTR -1[rbp], al
	nop
.L1238:
	movzx	eax, BYTE PTR -1[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN6ResultI9FBUSTRINGN2FB7FSERROREE5VALUEEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN6ResultI9FBUSTRINGN2FB7FSERROREE5VALUEEv
_ZN6ResultI9FBUSTRINGN2FB7FSERROREE5VALUEEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 64
	.seh_stackalloc	64
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR -16[rbp], 0
.L1241:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 112
	movzx	eax, BYTE PTR [rax]
	test	al, al
	jne	.L1249
	nop
.L1242:
	mov	QWORD PTR 32[rsp], 0
	mov	r9d, 0
	lea	r8, .LC0[rip]
	mov	edx, 87
	mov	ecx, 1
	call	fb_ErrorThrowEx
	mov	QWORD PTR -8[rbp], rax
	jmp	[QWORD PTR -8[rbp]]
.L1243:
.L1244:
.L1249:
	nop
.L1245:
	mov	rax, QWORD PTR 16[rbp]
	mov	QWORD PTR -16[rbp], rax
	nop
.L1246:
	mov	rax, QWORD PTR -16[rbp]
	add	rsp, 64
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN6ResultI9FBUSTRINGN2FB7FSERROREE7FAILUREEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN6ResultI9FBUSTRINGN2FB7FSERROREE7FAILUREEv
_ZN6ResultI9FBUSTRINGN2FB7FSERROREE7FAILUREEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 64
	.seh_stackalloc	64
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR -16[rbp], 0
.L1251:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 112
	movzx	eax, BYTE PTR [rax]
	test	al, al
	je	.L1259
	nop
.L1252:
	mov	QWORD PTR 32[rsp], 0
	mov	r9d, 0
	lea	r8, .LC0[rip]
	mov	edx, 105
	mov	ecx, 1
	call	fb_ErrorThrowEx
	mov	QWORD PTR -8[rbp], rax
	jmp	[QWORD PTR -8[rbp]]
.L1253:
.L1254:
.L1259:
	nop
.L1255:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 24
	mov	QWORD PTR -16[rbp], rax
	nop
.L1256:
	mov	rax, QWORD PTR -16[rbp]
	add	rsp, 64
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN6ResultI9FBUSTRINGN2FB7FSERROREE7VALUEORERS0_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN6ResultI9FBUSTRINGN2FB7FSERROREE7VALUEORERS0_
_ZN6ResultI9FBUSTRINGN2FB7FSERROREE7VALUEORERS0_:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
	mov	QWORD PTR -8[rbp], 0
.L1261:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 112
	movzx	eax, BYTE PTR [rax]
	test	al, al
	jne	.L1268
	mov	rax, QWORD PTR 24[rbp]
	mov	QWORD PTR -8[rbp], rax
	jmp	.L1264
.L1263:
.L1268:
	nop
.L1265:
	mov	rax, QWORD PTR 16[rbp]
	mov	QWORD PTR -8[rbp], rax
	nop
.L1264:
	mov	rax, QWORD PTR -8[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN6ResultI8FBSTRINGN2FB7FSERROREE4ISOKEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN6ResultI8FBSTRINGN2FB7FSERROREE4ISOKEv
_ZN6ResultI8FBSTRINGN2FB7FSERROREE4ISOKEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	BYTE PTR -1[rbp], 0
.L1270:
	mov	rax, QWORD PTR 16[rbp]
	movzx	eax, BYTE PTR 112[rax]
	mov	BYTE PTR -1[rbp], al
	nop
.L1271:
	movzx	eax, BYTE PTR -1[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN6ResultI8FBSTRINGN2FB7FSERROREE5VALUEEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN6ResultI8FBSTRINGN2FB7FSERROREE5VALUEEv
_ZN6ResultI8FBSTRINGN2FB7FSERROREE5VALUEEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 64
	.seh_stackalloc	64
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR -16[rbp], 0
.L1274:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 112
	movzx	eax, BYTE PTR [rax]
	test	al, al
	jne	.L1282
	nop
.L1275:
	mov	QWORD PTR 32[rsp], 0
	mov	r9d, 0
	lea	r8, .LC0[rip]
	mov	edx, 87
	mov	ecx, 1
	call	fb_ErrorThrowEx
	mov	QWORD PTR -8[rbp], rax
	jmp	[QWORD PTR -8[rbp]]
.L1276:
.L1277:
.L1282:
	nop
.L1278:
	mov	rax, QWORD PTR 16[rbp]
	mov	QWORD PTR -16[rbp], rax
	nop
.L1279:
	mov	rax, QWORD PTR -16[rbp]
	add	rsp, 64
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN6ResultI8FBSTRINGN2FB7FSERROREE7FAILUREEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN6ResultI8FBSTRINGN2FB7FSERROREE7FAILUREEv
_ZN6ResultI8FBSTRINGN2FB7FSERROREE7FAILUREEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 64
	.seh_stackalloc	64
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR -16[rbp], 0
.L1284:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 112
	movzx	eax, BYTE PTR [rax]
	test	al, al
	je	.L1292
	nop
.L1285:
	mov	QWORD PTR 32[rsp], 0
	mov	r9d, 0
	lea	r8, .LC0[rip]
	mov	edx, 105
	mov	ecx, 1
	call	fb_ErrorThrowEx
	mov	QWORD PTR -8[rbp], rax
	jmp	[QWORD PTR -8[rbp]]
.L1286:
.L1287:
.L1292:
	nop
.L1288:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 24
	mov	QWORD PTR -16[rbp], rax
	nop
.L1289:
	mov	rax, QWORD PTR -16[rbp]
	add	rsp, 64
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN6ResultI8FBSTRINGN2FB7FSERROREE7VALUEORERS0_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN6ResultI8FBSTRINGN2FB7FSERROREE7VALUEORERS0_
_ZN6ResultI8FBSTRINGN2FB7FSERROREE7VALUEORERS0_:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
	mov	QWORD PTR -8[rbp], 0
.L1294:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 112
	movzx	eax, BYTE PTR [rax]
	test	al, al
	jne	.L1301
	mov	rax, QWORD PTR 24[rbp]
	mov	QWORD PTR -8[rbp], rax
	jmp	.L1297
.L1296:
.L1301:
	nop
.L1298:
	mov	rax, QWORD PTR 16[rbp]
	mov	QWORD PTR -8[rbp], rax
	nop
.L1297:
	mov	rax, QWORD PTR -8[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN13ArrayIteratorI9FBUSTRINGE7ISVALIDEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN13ArrayIteratorI9FBUSTRINGE7ISVALIDEv
_ZN13ArrayIteratorI9FBUSTRINGE7ISVALIDEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	BYTE PTR -9[rbp], 0
.L1303:
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	QWORD PTR -8[rbp], rax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR -8[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	edx, eax
	setl	al
	mov	BYTE PTR -9[rbp], al
	nop
.L1304:
	movzx	eax, BYTE PTR -9[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN13ArrayIteratorI9FBUSTRINGE5VALUEEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN13ArrayIteratorI9FBUSTRINGE5VALUEEv
_ZN13ArrayIteratorI9FBUSTRINGE5VALUEEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR -16[rbp], 0
.L1307:
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	QWORD PTR -8[rbp], rax
	mov	rax, QWORD PTR -8[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	eax, DWORD PTR [rax]
	movsx	rdx, eax
	mov	rax, rdx
	add	rax, rax
	add	rax, rdx
	sal	rax, 3
	add	rax, rcx
	mov	QWORD PTR -16[rbp], rax
	nop
.L1308:
	mov	rax, QWORD PTR -16[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN13ArrayIteratorI9FBUSTRINGE8MOVENEXTEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN13ArrayIteratorI9FBUSTRINGE8MOVENEXTEv
_ZN13ArrayIteratorI9FBUSTRINGE8MOVENEXTEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
.L1311:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	add	edx, 1
	mov	DWORD PTR [rax], edx
	nop
	pop	rbp
	ret
.L1312:
	.seh_endproc
	.def	_ZN5ArrayI9FBUSTRINGE5COUNTEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayI9FBUSTRINGE5COUNTEv
_ZN5ArrayI9FBUSTRINGE5COUNTEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR -4[rbp], 0
.L1314:
	mov	rax, QWORD PTR 16[rbp]
	mov	eax, DWORD PTR 72[rax]
	mov	DWORD PTR -4[rbp], eax
	nop
.L1315:
	mov	eax, DWORD PTR -4[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayI9FBUSTRINGE8CAPACITYEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayI9FBUSTRINGE8CAPACITYEv
_ZN5ArrayI9FBUSTRINGE8CAPACITYEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 64
	.seh_stackalloc	64
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR -20[rbp], 0
.L1318:
	mov	edx, 1
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayUBound
	mov	QWORD PTR -8[rbp], rax
	mov	edx, 1
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayLBound
	mov	QWORD PTR -16[rbp], rax
	mov	rax, QWORD PTR -8[rbp]
	mov	edx, eax
	mov	rax, QWORD PTR -16[rbp]
	sub	edx, eax
	mov	eax, edx
	add	eax, 1
	mov	DWORD PTR -20[rbp], eax
	nop
.L1319:
	mov	eax, DWORD PTR -20[rbp]
	add	rsp, 64
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayI9FBUSTRINGE7ISEMPTYEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayI9FBUSTRINGE7ISEMPTYEv
_ZN5ArrayI9FBUSTRINGE7ISEMPTYEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	BYTE PTR -1[rbp], 0
.L1322:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	sete	al
	mov	BYTE PTR -1[rbp], al
	nop
.L1323:
	movzx	eax, BYTE PTR -1[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayI9FBUSTRINGE7RESERVEEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayI9FBUSTRINGE7RESERVEEi
_ZN5ArrayI9FBUSTRINGE7RESERVEEi:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 80
	.seh_stackalloc	80
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
.L1326:
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayI9FBUSTRINGE8CAPACITYEv
	mov	DWORD PTR -8[rbp], eax
	mov	eax, DWORD PTR 24[rbp]
	cmp	eax, DWORD PTR -8[rbp]
	jle	.L1339
	nop
.L1328:
.L1330:
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayI9FBUSTRINGE8CAPACITYEv
	mov	DWORD PTR -12[rbp], eax
	mov	eax, DWORD PTR -12[rbp]
	mov	DWORD PTR -4[rbp], eax
	cmp	DWORD PTR -4[rbp], 7
	jg	.L1340
	mov	DWORD PTR -4[rbp], 8
	jmp	.L1337
.L1332:
.L1333:
.L1340:
	nop
.L1334:
.L1337:
	mov	eax, DWORD PTR -4[rbp]
	cmp	eax, DWORD PTR 24[rbp]
	jge	.L1341
	mov	eax, DWORD PTR -4[rbp]
	cdqe
	add	rax, rax
	mov	DWORD PTR -4[rbp], eax
	jmp	.L1337
.L1341:
	nop
.L1336:
	mov	eax, DWORD PTR -4[rbp]
	cdqe
	sub	rax, 1
	mov	QWORD PTR 48[rsp], rax
	mov	QWORD PTR 40[rsp], 0
	mov	QWORD PTR 32[rsp], 1
	mov	r9d, 0
	mov	r8d, -1
	mov	edx, 24
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayRedimPresvEx
	jmp	.L1342
.L1339:
	nop
.L1329:
.L1342:
	nop
	add	rsp, 80
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayI9FBUSTRINGE6SHRINKEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayI9FBUSTRINGE6SHRINKEv
_ZN5ArrayI9FBUSTRINGE6SHRINKEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 80
	.seh_stackalloc	80
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
.L1344:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	jne	.L1353
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayUStrErase
	jmp	.L1347
.L1346:
.L1353:
	nop
.L1348:
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayI9FBUSTRINGE8CAPACITYEv
	mov	DWORD PTR -4[rbp], eax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR -4[rbp], eax
	je	.L1354
	nop
.L1350:
.L1351:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cdqe
	sub	rax, 1
	mov	QWORD PTR 48[rsp], rax
	mov	QWORD PTR 40[rsp], 0
	mov	QWORD PTR 32[rsp], 1
	mov	r9d, 0
	mov	r8d, -1
	mov	edx, 24
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayRedimPresvEx
	jmp	.L1355
.L1354:
	nop
.L1347:
.L1355:
	nop
	add	rsp, 80
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayI9FBUSTRINGEixEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayI9FBUSTRINGEixEi
_ZN5ArrayI9FBUSTRINGEixEi:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
	mov	QWORD PTR -8[rbp], 0
.L1357:
	mov	rax, QWORD PTR 16[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	eax, DWORD PTR 24[rbp]
	movsx	rdx, eax
	mov	rax, rdx
	add	rax, rax
	add	rax, rdx
	sal	rax, 3
	add	rax, rcx
	mov	QWORD PTR -8[rbp], rax
	nop
.L1358:
	mov	rax, QWORD PTR -8[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayI9FBUSTRINGE2ATEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayI9FBUSTRINGE2ATEi
_ZN5ArrayI9FBUSTRINGE2ATEi:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
	mov	QWORD PTR -8[rbp], 0
.L1361:
	mov	rax, QWORD PTR 16[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	eax, DWORD PTR 24[rbp]
	movsx	rdx, eax
	mov	rax, rdx
	add	rax, rax
	add	rax, rdx
	sal	rax, 3
	add	rax, rcx
	mov	QWORD PTR -8[rbp], rax
	nop
.L1362:
	mov	rax, QWORD PTR -8[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayI9FBUSTRINGE4PUSHERS0_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayI9FBUSTRINGE4PUSHERS0_
_ZN5ArrayI9FBUSTRINGE4PUSHERS0_:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 48
	.seh_stackalloc	48
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
.L1365:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	add	eax, 1
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayI9FBUSTRINGE7RESERVEEi
	mov	rax, QWORD PTR 16[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	movsx	rdx, eax
	mov	rax, rdx
	add	rax, rax
	add	rax, rdx
	sal	rax, 3
	add	rax, rcx
	mov	rdx, QWORD PTR 24[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrAssign
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	add	edx, 1
	mov	DWORD PTR [rax], edx
	nop
	add	rsp, 48
	pop	rbp
	ret
.L1366:
	.seh_endproc
	.def	_ZN5ArrayI9FBUSTRINGE3POPEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayI9FBUSTRINGE3POPEv
_ZN5ArrayI9FBUSTRINGE3POPEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 112
	.seh_stackalloc	112
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	lea	rax, -32[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
.L1368:
	lea	rax, -64[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	jne	.L1375
	lea	rdx, -64[rbp]
	lea	rax, -32[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrInit
	lea	rax, -64[rbp]
	mov	rcx, rax
	call	fb_UStrDelete
	jmp	.L1371
.L1370:
.L1375:
	nop
.L1372:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	sub	edx, 1
	mov	DWORD PTR [rax], edx
	mov	rax, QWORD PTR 16[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	movsx	rdx, eax
	mov	rax, rdx
	add	rax, rax
	add	rax, rdx
	sal	rax, 3
	lea	rdx, [rcx+rax]
	lea	rax, -64[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrAssign
	lea	rdx, -64[rbp]
	lea	rax, -32[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrInit
	lea	rax, -64[rbp]
	mov	rcx, rax
	call	fb_UStrDelete
	nop
.L1371:
	lea	rax, -32[rbp]
	mov	rcx, rax
	call	fb_UStrAllocTempResult
	mov	QWORD PTR -8[rbp], rax
	mov	rax, QWORD PTR -8[rbp]
	add	rsp, 112
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayI9FBUSTRINGE6INSERTEiRS0_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayI9FBUSTRINGE6INSERTEiRS0_
_ZN5ArrayI9FBUSTRINGE6INSERTEiRS0_:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 96
	.seh_stackalloc	96
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
	mov	QWORD PTR 32[rbp], r8
.L1377:
	cmp	DWORD PTR 24[rbp], 0
	js	.L1391
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR 24[rbp], eax
	setg	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -8[rbp], rax
	jmp	.L1380
.L1391:
	nop
.L1379:
	mov	QWORD PTR -8[rbp], -1
.L1380:
	cmp	QWORD PTR -8[rbp], 0
	jne	.L1392
	nop
.L1382:
.L1384:
	mov	rdx, QWORD PTR 32[rbp]
	lea	rax, -48[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrInit
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	add	eax, 1
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayI9FBUSTRINGE7RESERVEEi
	mov	rax, QWORD PTR 16[rbp]
	mov	eax, DWORD PTR 72[rax]
	mov	DWORD PTR -12[rbp], eax
	mov	eax, DWORD PTR 24[rbp]
	add	eax, 1
	mov	DWORD PTR -16[rbp], eax
	jmp	.L1385
.L1393:
	nop
.L1386:
	mov	rax, QWORD PTR 16[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	eax, DWORD PTR -12[rbp]
	movsx	rdx, eax
	mov	rax, rdx
	add	rax, rax
	add	rax, rdx
	sal	rax, 3
	sub	rax, 24
	lea	r8, [rcx+rax]
	mov	rax, QWORD PTR 16[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	eax, DWORD PTR -12[rbp]
	movsx	rdx, eax
	mov	rax, rdx
	add	rax, rax
	add	rax, rdx
	sal	rax, 3
	add	rax, rcx
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrAssign
.L1387:
	sub	DWORD PTR -12[rbp], 1
.L1385:
	mov	eax, DWORD PTR -12[rbp]
	cmp	eax, DWORD PTR -16[rbp]
	jge	.L1393
	nop
.L1388:
	mov	rax, QWORD PTR 16[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	eax, DWORD PTR 24[rbp]
	movsx	rdx, eax
	mov	rax, rdx
	add	rax, rax
	add	rax, rdx
	sal	rax, 3
	add	rax, rcx
	lea	rdx, -48[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrAssign
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	add	edx, 1
	mov	DWORD PTR [rax], edx
	lea	rax, -48[rbp]
	mov	rcx, rax
	call	fb_UStrDelete
	jmp	.L1394
.L1392:
	nop
.L1383:
.L1394:
	nop
	add	rsp, 96
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayI9FBUSTRINGE6REMOVEEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayI9FBUSTRINGE6REMOVEEi
_ZN5ArrayI9FBUSTRINGE6REMOVEEi:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 64
	.seh_stackalloc	64
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
.L1396:
	cmp	DWORD PTR 24[rbp], 0
	js	.L1410
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR 24[rbp], eax
	setge	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -8[rbp], rax
	jmp	.L1399
.L1410:
	nop
.L1398:
	mov	QWORD PTR -8[rbp], -1
.L1399:
	cmp	QWORD PTR -8[rbp], 0
	jne	.L1411
	nop
.L1401:
.L1403:
	mov	eax, DWORD PTR 24[rbp]
	mov	DWORD PTR -12[rbp], eax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	sub	eax, 2
	mov	DWORD PTR -16[rbp], eax
	jmp	.L1404
.L1412:
	nop
.L1405:
	mov	rax, QWORD PTR 16[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	eax, DWORD PTR -12[rbp]
	movsx	rdx, eax
	mov	rax, rdx
	add	rax, rax
	add	rax, rdx
	sal	rax, 3
	add	rax, 24
	lea	r8, [rcx+rax]
	mov	rax, QWORD PTR 16[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	eax, DWORD PTR -12[rbp]
	movsx	rdx, eax
	mov	rax, rdx
	add	rax, rax
	add	rax, rdx
	sal	rax, 3
	add	rax, rcx
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrAssign
.L1406:
	add	DWORD PTR -12[rbp], 1
.L1404:
	mov	eax, DWORD PTR -12[rbp]
	cmp	eax, DWORD PTR -16[rbp]
	jle	.L1412
	nop
.L1407:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	sub	edx, 1
	mov	DWORD PTR [rax], edx
	jmp	.L1413
.L1411:
	nop
.L1402:
.L1413:
	nop
	add	rsp, 64
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayI9FBUSTRINGE10REMOVESWAPEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayI9FBUSTRINGE10REMOVESWAPEi
_ZN5ArrayI9FBUSTRINGE10REMOVESWAPEi:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 64
	.seh_stackalloc	64
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
.L1415:
	cmp	DWORD PTR 24[rbp], 0
	js	.L1427
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR 24[rbp], eax
	setge	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -8[rbp], rax
	jmp	.L1418
.L1427:
	nop
.L1417:
	mov	QWORD PTR -8[rbp], -1
.L1418:
	cmp	QWORD PTR -8[rbp], 0
	jne	.L1428
	nop
.L1420:
.L1422:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	sub	edx, 1
	mov	DWORD PTR [rax], edx
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR 24[rbp], eax
	je	.L1429
	mov	rax, QWORD PTR 16[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	movsx	rdx, eax
	mov	rax, rdx
	add	rax, rax
	add	rax, rdx
	sal	rax, 3
	lea	r8, [rcx+rax]
	mov	rax, QWORD PTR 16[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	eax, DWORD PTR 24[rbp]
	movsx	rdx, eax
	mov	rax, rdx
	add	rax, rax
	add	rax, rdx
	sal	rax, 3
	add	rax, rcx
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrAssign
	jmp	.L1430
.L1421:
.L1424:
.L1428:
	nop
	jmp	.L1430
.L1429:
	nop
.L1425:
.L1430:
	nop
	add	rsp, 64
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayI9FBUSTRINGE5CLEAREv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayI9FBUSTRINGE5CLEAREv
_ZN5ArrayI9FBUSTRINGE5CLEAREv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 80
	.seh_stackalloc	80
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
.L1432:
	lea	rax, -32[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	DWORD PTR -4[rbp], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	sub	eax, 1
	mov	DWORD PTR -8[rbp], eax
	jmp	.L1433
.L1439:
	nop
.L1434:
	mov	rax, QWORD PTR 16[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	eax, DWORD PTR -4[rbp]
	movsx	rdx, eax
	mov	rax, rdx
	add	rax, rax
	add	rax, rdx
	sal	rax, 3
	add	rax, rcx
	lea	rdx, -32[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrAssign
.L1435:
	add	DWORD PTR -4[rbp], 1
.L1433:
	mov	eax, DWORD PTR -4[rbp]
	cmp	eax, DWORD PTR -8[rbp]
	jle	.L1439
	nop
.L1436:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	DWORD PTR [rax], 0
	lea	rax, -32[rbp]
	mov	rcx, rax
	call	fb_UStrDelete
	nop
	add	rsp, 80
	pop	rbp
	ret
.L1437:
	.seh_endproc
	.def	_ZN5ArrayI9FBUSTRINGE11GETITERATOREv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayI9FBUSTRINGE11GETITERATOREv
_ZN5ArrayI9FBUSTRINGE11GETITERATOREv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
	lea	rax, -16[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
.L1441:
	lea	rax, -32[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	lea	rax, -32[rbp]
	mov	rdx, QWORD PTR 24[rbp]
	mov	QWORD PTR [rax], rdx
	lea	rax, -32[rbp]
	add	rax, 8
	mov	DWORD PTR [rax], 0
	mov	rax, QWORD PTR -32[rbp]
	mov	rdx, QWORD PTR -24[rbp]
	mov	QWORD PTR -16[rbp], rax
	mov	QWORD PTR -8[rbp], rdx
	nop
.L1442:
	mov	rcx, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR -16[rbp]
	mov	rdx, QWORD PTR -8[rbp]
	mov	QWORD PTR [rcx], rax
	mov	QWORD PTR 8[rcx], rdx
	mov	rax, QWORD PTR 16[rbp]
	add	rsp, 32
	pop	rbp
	ret
	.seh_endproc
	.def	_Z6FsFailI9FBUSTRINGEN2FB11FSERRORCODEERKS0_S4_;	.scl	3;	.type	32;	.endef
	.seh_proc	_Z6FsFailI9FBUSTRINGEN2FB11FSERRORCODEERKS0_S4_
_Z6FsFailI9FBUSTRINGEN2FB11FSERRORCODEERKS0_S4_:
	push	rbp
	.seh_pushreg	rbp
	sub	rsp, 288
	.seh_stackalloc	288
	lea	rbp, 128[rsp]
	.seh_setframe	rbp, 128
	.seh_endprologue
	mov	QWORD PTR 176[rbp], rcx
	mov	QWORD PTR 184[rbp], rdx
	mov	QWORD PTR 192[rbp], r8
	mov	QWORD PTR 200[rbp], r9
.L1445:
	call	fb_FsOsError
	mov	DWORD PTR 156[rbp], eax
	mov	r9, QWORD PTR 192[rbp]
	mov	r8d, DWORD PTR 156[rbp]
	mov	rdx, QWORD PTR 184[rbp]
	lea	rax, -80[rbp]
	mov	rcx, QWORD PTR 200[rbp]
	mov	QWORD PTR 32[rsp], rcx
	mov	rcx, rax
	call	_ZN2FB7FSERRORC1ENS_11FSERRORCODEEiRK9FBUSTRINGS4_
	lea	rdx, -80[rbp]
	lea	rax, 16[rbp]
	mov	rcx, rax
	call	_Z4FailI9FBUSTRINGN2FB7FSERROREERS2_
	mov	QWORD PTR 144[rbp], rax
	mov	rax, QWORD PTR 144[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 176[rbp]
	call	_ZN6ResultI9FBUSTRINGN2FB7FSERROREEC1ERKS3_
	lea	rax, -80[rbp]
	mov	rcx, rax
	call	_ZN2FB7FSERRORD1Ev
	lea	rax, 16[rbp]
	mov	rcx, rax
	call	_ZN6ResultI9FBUSTRINGN2FB7FSERROREED1Ev
	nop
.L1446:
	mov	rax, QWORD PTR 176[rbp]
	add	rsp, 288
	pop	rbp
	ret
	.seh_endproc
	.def	_Z2OkI9FBUSTRINGN2FB7FSERROREERS0_;	.scl	3;	.type	32;	.endef
	.seh_proc	_Z2OkI9FBUSTRINGN2FB7FSERROREERS0_
_Z2OkI9FBUSTRINGN2FB7FSERROREERS0_:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 176
	.seh_stackalloc	176
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
.L1449:
	lea	rax, -128[rbp]
	mov	rcx, rax
	call	_ZN6ResultI9FBUSTRINGN2FB7FSERROREEC1Ev
	mov	rdx, QWORD PTR 24[rbp]
	lea	rax, -128[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrAssign
	lea	rax, -128[rbp]
	add	rax, 112
	mov	BYTE PTR [rax], 1
	lea	rax, -128[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN6ResultI9FBUSTRINGN2FB7FSERROREEC1ERKS3_
	lea	rax, -128[rbp]
	mov	rcx, rax
	call	_ZN6ResultI9FBUSTRINGN2FB7FSERROREED1Ev
	nop
.L1450:
	mov	rax, QWORD PTR 16[rbp]
	add	rsp, 176
	pop	rbp
	ret
	.seh_endproc
	.def	_Z4FailI9FBUSTRINGN2FB7FSERROREERS2_;	.scl	3;	.type	32;	.endef
	.seh_proc	_Z4FailI9FBUSTRINGN2FB7FSERROREERS2_
_Z4FailI9FBUSTRINGN2FB7FSERROREERS2_:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 160
	.seh_stackalloc	160
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
.L1453:
	lea	rax, -128[rbp]
	mov	rcx, rax
	call	_ZN6ResultI9FBUSTRINGN2FB7FSERROREEC1Ev
	lea	rax, -128[rbp]
	add	rax, 24
	mov	rdx, QWORD PTR 24[rbp]
	mov	rcx, rax
	call	_ZN2FB7FSERRORaSERKS0_
	lea	rax, -128[rbp]
	add	rax, 112
	mov	BYTE PTR [rax], 0
	lea	rax, -128[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN6ResultI9FBUSTRINGN2FB7FSERROREEC1ERKS3_
	lea	rax, -128[rbp]
	mov	rcx, rax
	call	_ZN6ResultI9FBUSTRINGN2FB7FSERROREED1Ev
	nop
.L1454:
	mov	rax, QWORD PTR 16[rbp]
	add	rsp, 160
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN6ResultIN2FB8FILEINFOEN2FB7FSERROREE4ISOKEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN6ResultIN2FB8FILEINFOEN2FB7FSERROREE4ISOKEv
_ZN6ResultIN2FB8FILEINFOEN2FB7FSERROREE4ISOKEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	BYTE PTR -1[rbp], 0
.L1457:
	mov	rax, QWORD PTR 16[rbp]
	movzx	eax, BYTE PTR 136[rax]
	mov	BYTE PTR -1[rbp], al
	nop
.L1458:
	movzx	eax, BYTE PTR -1[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN6ResultIN2FB8FILEINFOEN2FB7FSERROREE5VALUEEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN6ResultIN2FB8FILEINFOEN2FB7FSERROREE5VALUEEv
_ZN6ResultIN2FB8FILEINFOEN2FB7FSERROREE5VALUEEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 64
	.seh_stackalloc	64
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR -16[rbp], 0
.L1461:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 136
	movzx	eax, BYTE PTR [rax]
	test	al, al
	jne	.L1469
	nop
.L1462:
	mov	QWORD PTR 32[rsp], 0
	mov	r9d, 0
	lea	r8, .LC0[rip]
	mov	edx, 87
	mov	ecx, 1
	call	fb_ErrorThrowEx
	mov	QWORD PTR -8[rbp], rax
	jmp	[QWORD PTR -8[rbp]]
.L1463:
.L1464:
.L1469:
	nop
.L1465:
	mov	rax, QWORD PTR 16[rbp]
	mov	QWORD PTR -16[rbp], rax
	nop
.L1466:
	mov	rax, QWORD PTR -16[rbp]
	add	rsp, 64
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN6ResultIN2FB8FILEINFOEN2FB7FSERROREE7FAILUREEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN6ResultIN2FB8FILEINFOEN2FB7FSERROREE7FAILUREEv
_ZN6ResultIN2FB8FILEINFOEN2FB7FSERROREE7FAILUREEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 64
	.seh_stackalloc	64
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR -16[rbp], 0
.L1471:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 136
	movzx	eax, BYTE PTR [rax]
	test	al, al
	je	.L1479
	nop
.L1472:
	mov	QWORD PTR 32[rsp], 0
	mov	r9d, 0
	lea	r8, .LC0[rip]
	mov	edx, 105
	mov	ecx, 1
	call	fb_ErrorThrowEx
	mov	QWORD PTR -8[rbp], rax
	jmp	[QWORD PTR -8[rbp]]
.L1473:
.L1474:
.L1479:
	nop
.L1475:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 48
	mov	QWORD PTR -16[rbp], rax
	nop
.L1476:
	mov	rax, QWORD PTR -16[rbp]
	add	rsp, 64
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN6ResultIN2FB8FILEINFOEN2FB7FSERROREE7VALUEORERS1_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN6ResultIN2FB8FILEINFOEN2FB7FSERROREE7VALUEORERS1_
_ZN6ResultIN2FB8FILEINFOEN2FB7FSERROREE7VALUEORERS1_:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
	mov	QWORD PTR -8[rbp], 0
.L1481:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 136
	movzx	eax, BYTE PTR [rax]
	test	al, al
	jne	.L1488
	mov	rax, QWORD PTR 24[rbp]
	mov	QWORD PTR -8[rbp], rax
	jmp	.L1484
.L1483:
.L1488:
	nop
.L1485:
	mov	rax, QWORD PTR 16[rbp]
	mov	QWORD PTR -8[rbp], rax
	nop
.L1484:
	mov	rax, QWORD PTR -8[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_Z6FsFailIN2FB8FILEINFOEENS0_11FSERRORCODEERK9FBUSTRINGS5_;	.scl	3;	.type	32;	.endef
	.seh_proc	_Z6FsFailIN2FB8FILEINFOEENS0_11FSERRORCODEERK9FBUSTRINGS5_
_Z6FsFailIN2FB8FILEINFOEENS0_11FSERRORCODEERK9FBUSTRINGS5_:
	push	rbp
	.seh_pushreg	rbp
	sub	rsp, 304
	.seh_stackalloc	304
	lea	rbp, 128[rsp]
	.seh_setframe	rbp, 128
	.seh_endprologue
	mov	QWORD PTR 192[rbp], rcx
	mov	QWORD PTR 200[rbp], rdx
	mov	QWORD PTR 208[rbp], r8
	mov	QWORD PTR 216[rbp], r9
.L1490:
	call	fb_FsOsError
	mov	DWORD PTR 172[rbp], eax
	mov	r9, QWORD PTR 208[rbp]
	mov	r8d, DWORD PTR 172[rbp]
	mov	rdx, QWORD PTR 200[rbp]
	lea	rax, -80[rbp]
	mov	rcx, QWORD PTR 216[rbp]
	mov	QWORD PTR 32[rsp], rcx
	mov	rcx, rax
	call	_ZN2FB7FSERRORC1ENS_11FSERRORCODEEiRK9FBUSTRINGS4_
	lea	rdx, -80[rbp]
	lea	rax, 16[rbp]
	mov	rcx, rax
	call	_Z4FailIN2FB8FILEINFOEN2FB7FSERROREERS3_
	mov	QWORD PTR 160[rbp], rax
	mov	rax, QWORD PTR 160[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 192[rbp]
	call	_ZN6ResultIN2FB8FILEINFOEN2FB7FSERROREEC1ERKS4_
	lea	rax, -80[rbp]
	mov	rcx, rax
	call	_ZN2FB7FSERRORD1Ev
	lea	rax, 16[rbp]
	mov	rcx, rax
	call	_ZN6ResultIN2FB8FILEINFOEN2FB7FSERROREED1Ev
	nop
.L1491:
	mov	rax, QWORD PTR 192[rbp]
	add	rsp, 304
	pop	rbp
	ret
	.seh_endproc
	.def	_Z2OkIN2FB8FILEINFOEN2FB7FSERROREERS1_;	.scl	3;	.type	32;	.endef
	.seh_proc	_Z2OkIN2FB8FILEINFOEN2FB7FSERROREERS1_
_Z2OkIN2FB8FILEINFOEN2FB7FSERROREERS1_:
	push	rbp
	.seh_pushreg	rbp
	push	rbx
	.seh_pushreg	rbx
	sub	rsp, 184
	.seh_stackalloc	184
	lea	rbp, 128[rsp]
	.seh_setframe	rbp, 128
	.seh_endprologue
	mov	QWORD PTR 80[rbp], rcx
	mov	QWORD PTR 88[rbp], rdx
.L1494:
	lea	rax, -96[rbp]
	mov	rcx, rax
	call	_ZN6ResultIN2FB8FILEINFOEN2FB7FSERROREEC1Ev
	lea	rax, -96[rbp]
	mov	rdx, QWORD PTR 88[rbp]
	mov	rcx, QWORD PTR [rdx]
	mov	rbx, QWORD PTR 8[rdx]
	mov	QWORD PTR [rax], rcx
	mov	QWORD PTR 8[rax], rbx
	mov	rcx, QWORD PTR 16[rdx]
	mov	rbx, QWORD PTR 24[rdx]
	mov	QWORD PTR 16[rax], rcx
	mov	QWORD PTR 24[rax], rbx
	mov	rcx, QWORD PTR 32[rdx]
	mov	rbx, QWORD PTR 40[rdx]
	mov	QWORD PTR 32[rax], rcx
	mov	QWORD PTR 40[rax], rbx
	lea	rax, -96[rbp]
	add	rax, 136
	mov	BYTE PTR [rax], 1
	lea	rax, -96[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 80[rbp]
	call	_ZN6ResultIN2FB8FILEINFOEN2FB7FSERROREEC1ERKS4_
	lea	rax, -96[rbp]
	mov	rcx, rax
	call	_ZN6ResultIN2FB8FILEINFOEN2FB7FSERROREED1Ev
	nop
.L1495:
	mov	rax, QWORD PTR 80[rbp]
	add	rsp, 184
	pop	rbx
	pop	rbp
	ret
	.seh_endproc
	.def	_Z6FsFailIbEN2FB11FSERRORCODEERK9FBUSTRINGS4_;	.scl	3;	.type	32;	.endef
	.seh_proc	_Z6FsFailIbEN2FB11FSERRORCODEERK9FBUSTRINGS4_
_Z6FsFailIbEN2FB11FSERRORCODEERK9FBUSTRINGS4_:
	push	rbp
	.seh_pushreg	rbp
	sub	rsp, 272
	.seh_stackalloc	272
	lea	rbp, 128[rsp]
	.seh_setframe	rbp, 128
	.seh_endprologue
	mov	QWORD PTR 160[rbp], rcx
	mov	QWORD PTR 168[rbp], rdx
	mov	QWORD PTR 176[rbp], r8
	mov	QWORD PTR 184[rbp], r9
.L1498:
	call	fb_FsOsError
	mov	DWORD PTR 140[rbp], eax
	mov	r9, QWORD PTR 176[rbp]
	mov	r8d, DWORD PTR 140[rbp]
	mov	rdx, QWORD PTR 168[rbp]
	lea	rax, -80[rbp]
	mov	rcx, QWORD PTR 184[rbp]
	mov	QWORD PTR 32[rsp], rcx
	mov	rcx, rax
	call	_ZN2FB7FSERRORC1ENS_11FSERRORCODEEiRK9FBUSTRINGS4_
	lea	rdx, -80[rbp]
	lea	rax, 16[rbp]
	mov	rcx, rax
	call	_Z4FailIbN2FB7FSERROREERS1_
	mov	QWORD PTR 128[rbp], rax
	mov	rax, QWORD PTR 128[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 160[rbp]
	call	_ZN6ResultIbN2FB7FSERROREEC1ERKS2_
	lea	rax, -80[rbp]
	mov	rcx, rax
	call	_ZN2FB7FSERRORD1Ev
	lea	rax, 16[rbp]
	mov	rcx, rax
	call	_ZN6ResultIbN2FB7FSERROREED1Ev
	nop
.L1499:
	mov	rax, QWORD PTR 160[rbp]
	add	rsp, 272
	pop	rbp
	ret
	.seh_endproc
	.def	_Z2OkIbN2FB7FSERROREERb;	.scl	3;	.type	32;	.endef
	.seh_proc	_Z2OkIbN2FB7FSERROREERb
_Z2OkIbN2FB7FSERROREERb:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 144
	.seh_stackalloc	144
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
.L1502:
	lea	rax, -112[rbp]
	mov	rcx, rax
	call	_ZN6ResultIbN2FB7FSERROREEC1Ev
	lea	rax, -112[rbp]
	mov	rdx, QWORD PTR 24[rbp]
	movzx	edx, BYTE PTR [rdx]
	mov	BYTE PTR [rax], dl
	lea	rax, -112[rbp]
	add	rax, 96
	mov	BYTE PTR [rax], 1
	lea	rax, -112[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN6ResultIbN2FB7FSERROREEC1ERKS2_
	lea	rax, -112[rbp]
	mov	rcx, rax
	call	_ZN6ResultIbN2FB7FSERROREED1Ev
	nop
.L1503:
	mov	rax, QWORD PTR 16[rbp]
	add	rsp, 144
	pop	rbp
	ret
	.seh_endproc
	.def	_Z4FailIN2FB8FILEINFOEN2FB7FSERROREERS3_;	.scl	3;	.type	32;	.endef
	.seh_proc	_Z4FailIN2FB8FILEINFOEN2FB7FSERROREERS3_
_Z4FailIN2FB8FILEINFOEN2FB7FSERROREERS3_:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 176
	.seh_stackalloc	176
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
.L1506:
	lea	rax, -144[rbp]
	mov	rcx, rax
	call	_ZN6ResultIN2FB8FILEINFOEN2FB7FSERROREEC1Ev
	lea	rax, -144[rbp]
	add	rax, 48
	mov	rdx, QWORD PTR 24[rbp]
	mov	rcx, rax
	call	_ZN2FB7FSERRORaSERKS0_
	lea	rax, -144[rbp]
	add	rax, 136
	mov	BYTE PTR [rax], 0
	lea	rax, -144[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN6ResultIN2FB8FILEINFOEN2FB7FSERROREEC1ERKS4_
	lea	rax, -144[rbp]
	mov	rcx, rax
	call	_ZN6ResultIN2FB8FILEINFOEN2FB7FSERROREED1Ev
	nop
.L1507:
	mov	rax, QWORD PTR 16[rbp]
	add	rsp, 176
	pop	rbp
	ret
	.seh_endproc
	.def	_Z4FailIbN2FB7FSERROREERS1_;	.scl	3;	.type	32;	.endef
	.seh_proc	_Z4FailIbN2FB7FSERROREERS1_
_Z4FailIbN2FB7FSERROREERS1_:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 144
	.seh_stackalloc	144
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
.L1510:
	lea	rax, -112[rbp]
	mov	rcx, rax
	call	_ZN6ResultIbN2FB7FSERROREEC1Ev
	lea	rax, -112[rbp]
	add	rax, 8
	mov	rdx, QWORD PTR 24[rbp]
	mov	rcx, rax
	call	_ZN2FB7FSERRORaSERKS0_
	lea	rax, -112[rbp]
	add	rax, 96
	mov	BYTE PTR [rax], 0
	lea	rax, -112[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN6ResultIbN2FB7FSERROREEC1ERKS2_
	lea	rax, -112[rbp]
	mov	rcx, rax
	call	_ZN6ResultIbN2FB7FSERROREED1Ev
	nop
.L1511:
	mov	rax, QWORD PTR 16[rbp]
	add	rsp, 144
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN6ResultIN2FB8DIRENTRYEN2FB7FSERROREE4ISOKEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN6ResultIN2FB8DIRENTRYEN2FB7FSERROREE4ISOKEv
_ZN6ResultIN2FB8DIRENTRYEN2FB7FSERROREE4ISOKEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	BYTE PTR -1[rbp], 0
.L1514:
	mov	rax, QWORD PTR 16[rbp]
	movzx	eax, BYTE PTR 200[rax]
	mov	BYTE PTR -1[rbp], al
	nop
.L1515:
	movzx	eax, BYTE PTR -1[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN6ResultIN2FB8DIRENTRYEN2FB7FSERROREE5VALUEEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN6ResultIN2FB8DIRENTRYEN2FB7FSERROREE5VALUEEv
_ZN6ResultIN2FB8DIRENTRYEN2FB7FSERROREE5VALUEEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 64
	.seh_stackalloc	64
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR -16[rbp], 0
.L1518:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 200
	movzx	eax, BYTE PTR [rax]
	test	al, al
	jne	.L1526
	nop
.L1519:
	mov	QWORD PTR 32[rsp], 0
	mov	r9d, 0
	lea	r8, .LC0[rip]
	mov	edx, 87
	mov	ecx, 1
	call	fb_ErrorThrowEx
	mov	QWORD PTR -8[rbp], rax
	jmp	[QWORD PTR -8[rbp]]
.L1520:
.L1521:
.L1526:
	nop
.L1522:
	mov	rax, QWORD PTR 16[rbp]
	mov	QWORD PTR -16[rbp], rax
	nop
.L1523:
	mov	rax, QWORD PTR -16[rbp]
	add	rsp, 64
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN6ResultIN2FB8DIRENTRYEN2FB7FSERROREE7FAILUREEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN6ResultIN2FB8DIRENTRYEN2FB7FSERROREE7FAILUREEv
_ZN6ResultIN2FB8DIRENTRYEN2FB7FSERROREE7FAILUREEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 64
	.seh_stackalloc	64
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR -16[rbp], 0
.L1528:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 200
	movzx	eax, BYTE PTR [rax]
	test	al, al
	je	.L1536
	nop
.L1529:
	mov	QWORD PTR 32[rsp], 0
	mov	r9d, 0
	lea	r8, .LC0[rip]
	mov	edx, 105
	mov	ecx, 1
	call	fb_ErrorThrowEx
	mov	QWORD PTR -8[rbp], rax
	jmp	[QWORD PTR -8[rbp]]
.L1530:
.L1531:
.L1536:
	nop
.L1532:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 112
	mov	QWORD PTR -16[rbp], rax
	nop
.L1533:
	mov	rax, QWORD PTR -16[rbp]
	add	rsp, 64
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN6ResultIN2FB8DIRENTRYEN2FB7FSERROREE7VALUEORERS1_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN6ResultIN2FB8DIRENTRYEN2FB7FSERROREE7VALUEORERS1_
_ZN6ResultIN2FB8DIRENTRYEN2FB7FSERROREE7VALUEORERS1_:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
	mov	QWORD PTR -8[rbp], 0
.L1538:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 200
	movzx	eax, BYTE PTR [rax]
	test	al, al
	jne	.L1545
	mov	rax, QWORD PTR 24[rbp]
	mov	QWORD PTR -8[rbp], rax
	jmp	.L1541
.L1540:
.L1545:
	nop
.L1542:
	mov	rax, QWORD PTR 16[rbp]
	mov	QWORD PTR -8[rbp], rax
	nop
.L1541:
	mov	rax, QWORD PTR -8[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_Z6FsFailIN2FB8DIRENTRYEENS0_11FSERRORCODEERK9FBUSTRINGS5_;	.scl	3;	.type	32;	.endef
	.seh_proc	_Z6FsFailIN2FB8DIRENTRYEENS0_11FSERRORCODEERK9FBUSTRINGS5_
_Z6FsFailIN2FB8DIRENTRYEENS0_11FSERRORCODEERK9FBUSTRINGS5_:
	push	rbp
	.seh_pushreg	rbp
	sub	rsp, 368
	.seh_stackalloc	368
	lea	rbp, 128[rsp]
	.seh_setframe	rbp, 128
	.seh_endprologue
	mov	QWORD PTR 256[rbp], rcx
	mov	QWORD PTR 264[rbp], rdx
	mov	QWORD PTR 272[rbp], r8
	mov	QWORD PTR 280[rbp], r9
.L1547:
	call	fb_FsOsError
	mov	DWORD PTR 236[rbp], eax
	mov	r9, QWORD PTR 272[rbp]
	mov	r8d, DWORD PTR 236[rbp]
	mov	rdx, QWORD PTR 264[rbp]
	lea	rax, -80[rbp]
	mov	rcx, QWORD PTR 280[rbp]
	mov	QWORD PTR 32[rsp], rcx
	mov	rcx, rax
	call	_ZN2FB7FSERRORC1ENS_11FSERRORCODEEiRK9FBUSTRINGS4_
	lea	rdx, -80[rbp]
	lea	rax, 16[rbp]
	mov	rcx, rax
	call	_Z4FailIN2FB8DIRENTRYEN2FB7FSERROREERS3_
	mov	QWORD PTR 224[rbp], rax
	mov	rax, QWORD PTR 224[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 256[rbp]
	call	_ZN6ResultIN2FB8DIRENTRYEN2FB7FSERROREEC1ERKS4_
	lea	rax, -80[rbp]
	mov	rcx, rax
	call	_ZN2FB7FSERRORD1Ev
	lea	rax, 16[rbp]
	mov	rcx, rax
	call	_ZN6ResultIN2FB8DIRENTRYEN2FB7FSERROREED1Ev
	nop
.L1548:
	mov	rax, QWORD PTR 256[rbp]
	add	rsp, 368
	pop	rbp
	ret
	.seh_endproc
	.def	_Z2OkIN2FB8DIRENTRYEN2FB7FSERROREERS1_;	.scl	3;	.type	32;	.endef
	.seh_proc	_Z2OkIN2FB8DIRENTRYEN2FB7FSERROREERS1_
_Z2OkIN2FB8DIRENTRYEN2FB7FSERROREERS1_:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 240
	.seh_stackalloc	240
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
.L1551:
	lea	rax, -208[rbp]
	mov	rcx, rax
	call	_ZN6ResultIN2FB8DIRENTRYEN2FB7FSERROREEC1Ev
	mov	rdx, QWORD PTR 24[rbp]
	lea	rax, -208[rbp]
	mov	rcx, rax
	call	_ZN2FB8DIRENTRYaSERKS0_
	lea	rax, -208[rbp]
	add	rax, 200
	mov	BYTE PTR [rax], 1
	lea	rax, -208[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN6ResultIN2FB8DIRENTRYEN2FB7FSERROREEC1ERKS4_
	lea	rax, -208[rbp]
	mov	rcx, rax
	call	_ZN6ResultIN2FB8DIRENTRYEN2FB7FSERROREED1Ev
	nop
.L1552:
	mov	rax, QWORD PTR 16[rbp]
	add	rsp, 240
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN13ArrayIteratorIN2FB8DIRENTRYEE7ISVALIDEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN13ArrayIteratorIN2FB8DIRENTRYEE7ISVALIDEv
_ZN13ArrayIteratorIN2FB8DIRENTRYEE7ISVALIDEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	BYTE PTR -9[rbp], 0
.L1555:
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	QWORD PTR -8[rbp], rax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR -8[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	edx, eax
	setl	al
	mov	BYTE PTR -9[rbp], al
	nop
.L1556:
	movzx	eax, BYTE PTR -9[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN13ArrayIteratorIN2FB8DIRENTRYEE5VALUEEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN13ArrayIteratorIN2FB8DIRENTRYEE5VALUEEv
_ZN13ArrayIteratorIN2FB8DIRENTRYEE5VALUEEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR -16[rbp], 0
.L1559:
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	QWORD PTR -8[rbp], rax
	mov	rax, QWORD PTR -8[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	eax, DWORD PTR [rax]
	movsx	rdx, eax
	mov	rax, rdx
	sal	rax, 3
	sub	rax, rdx
	sal	rax, 4
	add	rax, rcx
	mov	QWORD PTR -16[rbp], rax
	nop
.L1560:
	mov	rax, QWORD PTR -16[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN13ArrayIteratorIN2FB8DIRENTRYEE8MOVENEXTEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN13ArrayIteratorIN2FB8DIRENTRYEE8MOVENEXTEv
_ZN13ArrayIteratorIN2FB8DIRENTRYEE8MOVENEXTEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
.L1563:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	add	edx, 1
	mov	DWORD PTR [rax], edx
	nop
	pop	rbp
	ret
.L1564:
	.seh_endproc
	.def	_ZN5ArrayIN2FB8DIRENTRYEE5COUNTEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN2FB8DIRENTRYEE5COUNTEv
_ZN5ArrayIN2FB8DIRENTRYEE5COUNTEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR -4[rbp], 0
.L1566:
	mov	rax, QWORD PTR 16[rbp]
	mov	eax, DWORD PTR 72[rax]
	mov	DWORD PTR -4[rbp], eax
	nop
.L1567:
	mov	eax, DWORD PTR -4[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN2FB8DIRENTRYEE8CAPACITYEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN2FB8DIRENTRYEE8CAPACITYEv
_ZN5ArrayIN2FB8DIRENTRYEE8CAPACITYEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 64
	.seh_stackalloc	64
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR -20[rbp], 0
.L1570:
	mov	edx, 1
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayUBound
	mov	QWORD PTR -8[rbp], rax
	mov	edx, 1
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayLBound
	mov	QWORD PTR -16[rbp], rax
	mov	rax, QWORD PTR -8[rbp]
	mov	edx, eax
	mov	rax, QWORD PTR -16[rbp]
	sub	edx, eax
	mov	eax, edx
	add	eax, 1
	mov	DWORD PTR -20[rbp], eax
	nop
.L1571:
	mov	eax, DWORD PTR -20[rbp]
	add	rsp, 64
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN2FB8DIRENTRYEE7ISEMPTYEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN2FB8DIRENTRYEE7ISEMPTYEv
_ZN5ArrayIN2FB8DIRENTRYEE7ISEMPTYEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	BYTE PTR -1[rbp], 0
.L1574:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	sete	al
	mov	BYTE PTR -1[rbp], al
	nop
.L1575:
	movzx	eax, BYTE PTR -1[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN2FB8DIRENTRYEE7RESERVEEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN2FB8DIRENTRYEE7RESERVEEi
_ZN5ArrayIN2FB8DIRENTRYEE7RESERVEEi:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 80
	.seh_stackalloc	80
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
.L1578:
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIN2FB8DIRENTRYEE8CAPACITYEv
	mov	DWORD PTR -8[rbp], eax
	mov	eax, DWORD PTR 24[rbp]
	cmp	eax, DWORD PTR -8[rbp]
	jle	.L1591
	nop
.L1580:
.L1582:
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIN2FB8DIRENTRYEE8CAPACITYEv
	mov	DWORD PTR -12[rbp], eax
	mov	eax, DWORD PTR -12[rbp]
	mov	DWORD PTR -4[rbp], eax
	cmp	DWORD PTR -4[rbp], 7
	jg	.L1592
	mov	DWORD PTR -4[rbp], 8
	jmp	.L1589
.L1584:
.L1585:
.L1592:
	nop
.L1586:
.L1589:
	mov	eax, DWORD PTR -4[rbp]
	cmp	eax, DWORD PTR 24[rbp]
	jge	.L1593
	mov	eax, DWORD PTR -4[rbp]
	cdqe
	add	rax, rax
	mov	DWORD PTR -4[rbp], eax
	jmp	.L1589
.L1593:
	nop
.L1588:
	mov	eax, DWORD PTR -4[rbp]
	cdqe
	sub	rax, 1
	mov	QWORD PTR 48[rsp], rax
	mov	QWORD PTR 40[rsp], 0
	mov	QWORD PTR 32[rsp], 1
	lea	r9, _ZN2FB8DIRENTRYD1Ev[rip]
	lea	r8, _ZN2FB8DIRENTRYC1Ev[rip]
	mov	edx, 112
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayRedimPresvObj
	jmp	.L1594
.L1591:
	nop
.L1581:
.L1594:
	nop
	add	rsp, 80
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN2FB8DIRENTRYEE6SHRINKEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN2FB8DIRENTRYEE6SHRINKEv
_ZN5ArrayIN2FB8DIRENTRYEE6SHRINKEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 80
	.seh_stackalloc	80
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
.L1596:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	jne	.L1605
	lea	r8, _ZN2FB8DIRENTRYD1Ev[rip]
	lea	rdx, _ZN2FB8DIRENTRYC1Ev[rip]
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayEraseObj
	jmp	.L1599
.L1598:
.L1605:
	nop
.L1600:
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIN2FB8DIRENTRYEE8CAPACITYEv
	mov	DWORD PTR -4[rbp], eax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR -4[rbp], eax
	je	.L1606
	nop
.L1602:
.L1603:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cdqe
	sub	rax, 1
	mov	QWORD PTR 48[rsp], rax
	mov	QWORD PTR 40[rsp], 0
	mov	QWORD PTR 32[rsp], 1
	lea	r9, _ZN2FB8DIRENTRYD1Ev[rip]
	lea	r8, _ZN2FB8DIRENTRYC1Ev[rip]
	mov	edx, 112
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayRedimPresvObj
	jmp	.L1607
.L1606:
	nop
.L1599:
.L1607:
	nop
	add	rsp, 80
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN2FB8DIRENTRYEEixEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN2FB8DIRENTRYEEixEi
_ZN5ArrayIN2FB8DIRENTRYEEixEi:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
	mov	QWORD PTR -8[rbp], 0
.L1609:
	mov	rax, QWORD PTR 16[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	eax, DWORD PTR 24[rbp]
	movsx	rdx, eax
	mov	rax, rdx
	sal	rax, 3
	sub	rax, rdx
	sal	rax, 4
	add	rax, rcx
	mov	QWORD PTR -8[rbp], rax
	nop
.L1610:
	mov	rax, QWORD PTR -8[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN2FB8DIRENTRYEE2ATEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN2FB8DIRENTRYEE2ATEi
_ZN5ArrayIN2FB8DIRENTRYEE2ATEi:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
	mov	QWORD PTR -8[rbp], 0
.L1613:
	mov	rax, QWORD PTR 16[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	eax, DWORD PTR 24[rbp]
	movsx	rdx, eax
	mov	rax, rdx
	sal	rax, 3
	sub	rax, rdx
	sal	rax, 4
	add	rax, rcx
	mov	QWORD PTR -8[rbp], rax
	nop
.L1614:
	mov	rax, QWORD PTR -8[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN2FB8DIRENTRYEE4PUSHERS1_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN2FB8DIRENTRYEE4PUSHERS1_
_ZN5ArrayIN2FB8DIRENTRYEE4PUSHERS1_:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
.L1617:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	add	eax, 1
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIN2FB8DIRENTRYEE7RESERVEEi
	mov	rax, QWORD PTR 16[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	movsx	rdx, eax
	mov	rax, rdx
	sal	rax, 3
	sub	rax, rdx
	sal	rax, 4
	add	rcx, rax
	mov	rax, QWORD PTR 24[rbp]
	mov	rdx, rax
	call	_ZN2FB8DIRENTRYaSERKS0_
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	add	edx, 1
	mov	DWORD PTR [rax], edx
	nop
	add	rsp, 32
	pop	rbp
	ret
.L1618:
	.seh_endproc
	.def	_ZN5ArrayIN2FB8DIRENTRYEE3POPEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN2FB8DIRENTRYEE3POPEv
_ZN5ArrayIN2FB8DIRENTRYEE3POPEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 144
	.seh_stackalloc	144
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
.L1620:
	lea	rax, -112[rbp]
	mov	rcx, rax
	call	_ZN2FB8DIRENTRYC1Ev
	mov	rax, QWORD PTR 24[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	jne	.L1627
	lea	rax, -112[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN2FB8DIRENTRYC1ERKS0_
	lea	rax, -112[rbp]
	mov	rcx, rax
	call	_ZN2FB8DIRENTRYD1Ev
	jmp	.L1623
.L1622:
.L1627:
	nop
.L1624:
	mov	rax, QWORD PTR 24[rbp]
	add	rax, 72
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 24[rbp]
	add	rax, 72
	sub	edx, 1
	mov	DWORD PTR [rax], edx
	mov	rax, QWORD PTR 24[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	rax, QWORD PTR 24[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	movsx	rdx, eax
	mov	rax, rdx
	sal	rax, 3
	sub	rax, rdx
	sal	rax, 4
	lea	rdx, [rcx+rax]
	lea	rax, -112[rbp]
	mov	rcx, rax
	call	_ZN2FB8DIRENTRYaSERKS0_
	lea	rax, -112[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN2FB8DIRENTRYC1ERKS0_
	lea	rax, -112[rbp]
	mov	rcx, rax
	call	_ZN2FB8DIRENTRYD1Ev
	nop
.L1623:
	mov	rax, QWORD PTR 16[rbp]
	add	rsp, 144
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN2FB8DIRENTRYEE6INSERTEiRS1_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN2FB8DIRENTRYEE6INSERTEiRS1_
_ZN5ArrayIN2FB8DIRENTRYEE6INSERTEiRS1_:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 160
	.seh_stackalloc	160
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
	mov	QWORD PTR 32[rbp], r8
.L1629:
	cmp	DWORD PTR 24[rbp], 0
	js	.L1643
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR 24[rbp], eax
	setg	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -8[rbp], rax
	jmp	.L1632
.L1643:
	nop
.L1631:
	mov	QWORD PTR -8[rbp], -1
.L1632:
	cmp	QWORD PTR -8[rbp], 0
	jne	.L1644
	nop
.L1634:
.L1636:
	mov	rdx, QWORD PTR 32[rbp]
	lea	rax, -128[rbp]
	mov	rcx, rax
	call	_ZN2FB8DIRENTRYC1ERKS0_
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	add	eax, 1
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIN2FB8DIRENTRYEE7RESERVEEi
	mov	rax, QWORD PTR 16[rbp]
	mov	eax, DWORD PTR 72[rax]
	mov	DWORD PTR -12[rbp], eax
	mov	eax, DWORD PTR 24[rbp]
	add	eax, 1
	mov	DWORD PTR -16[rbp], eax
	jmp	.L1637
.L1645:
	nop
.L1638:
	mov	rax, QWORD PTR 16[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	eax, DWORD PTR -12[rbp]
	movsx	rdx, eax
	mov	rax, rdx
	sal	rax, 3
	sub	rax, rdx
	sal	rax, 4
	sub	rax, 112
	add	rcx, rax
	mov	rax, QWORD PTR 16[rbp]
	mov	r8, QWORD PTR [rax]
	mov	eax, DWORD PTR -12[rbp]
	movsx	rdx, eax
	mov	rax, rdx
	sal	rax, 3
	sub	rax, rdx
	sal	rax, 4
	add	rax, r8
	mov	rdx, rcx
	mov	rcx, rax
	call	_ZN2FB8DIRENTRYaSERKS0_
.L1639:
	sub	DWORD PTR -12[rbp], 1
.L1637:
	mov	eax, DWORD PTR -12[rbp]
	cmp	eax, DWORD PTR -16[rbp]
	jge	.L1645
	nop
.L1640:
	mov	rax, QWORD PTR 16[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	eax, DWORD PTR 24[rbp]
	movsx	rdx, eax
	mov	rax, rdx
	sal	rax, 3
	sub	rax, rdx
	sal	rax, 4
	add	rcx, rax
	lea	rax, -128[rbp]
	mov	rdx, rax
	call	_ZN2FB8DIRENTRYaSERKS0_
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	add	edx, 1
	mov	DWORD PTR [rax], edx
	lea	rax, -128[rbp]
	mov	rcx, rax
	call	_ZN2FB8DIRENTRYD1Ev
	jmp	.L1646
.L1644:
	nop
.L1635:
.L1646:
	nop
	add	rsp, 160
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN2FB8DIRENTRYEE6REMOVEEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN2FB8DIRENTRYEE6REMOVEEi
_ZN5ArrayIN2FB8DIRENTRYEE6REMOVEEi:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 48
	.seh_stackalloc	48
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
.L1648:
	cmp	DWORD PTR 24[rbp], 0
	js	.L1662
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR 24[rbp], eax
	setge	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -8[rbp], rax
	jmp	.L1651
.L1662:
	nop
.L1650:
	mov	QWORD PTR -8[rbp], -1
.L1651:
	cmp	QWORD PTR -8[rbp], 0
	jne	.L1663
	nop
.L1653:
.L1655:
	mov	eax, DWORD PTR 24[rbp]
	mov	DWORD PTR -12[rbp], eax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	sub	eax, 2
	mov	DWORD PTR -16[rbp], eax
	jmp	.L1656
.L1664:
	nop
.L1657:
	mov	rax, QWORD PTR 16[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	eax, DWORD PTR -12[rbp]
	movsx	rdx, eax
	mov	rax, rdx
	sal	rax, 3
	sub	rax, rdx
	sal	rax, 4
	add	rax, 112
	add	rcx, rax
	mov	rax, QWORD PTR 16[rbp]
	mov	r8, QWORD PTR [rax]
	mov	eax, DWORD PTR -12[rbp]
	movsx	rdx, eax
	mov	rax, rdx
	sal	rax, 3
	sub	rax, rdx
	sal	rax, 4
	add	rax, r8
	mov	rdx, rcx
	mov	rcx, rax
	call	_ZN2FB8DIRENTRYaSERKS0_
.L1658:
	add	DWORD PTR -12[rbp], 1
.L1656:
	mov	eax, DWORD PTR -12[rbp]
	cmp	eax, DWORD PTR -16[rbp]
	jle	.L1664
	nop
.L1659:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	sub	edx, 1
	mov	DWORD PTR [rax], edx
	jmp	.L1665
.L1663:
	nop
.L1654:
.L1665:
	nop
	add	rsp, 48
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN2FB8DIRENTRYEE10REMOVESWAPEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN2FB8DIRENTRYEE10REMOVESWAPEi
_ZN5ArrayIN2FB8DIRENTRYEE10REMOVESWAPEi:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 48
	.seh_stackalloc	48
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
.L1667:
	cmp	DWORD PTR 24[rbp], 0
	js	.L1679
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR 24[rbp], eax
	setge	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -8[rbp], rax
	jmp	.L1670
.L1679:
	nop
.L1669:
	mov	QWORD PTR -8[rbp], -1
.L1670:
	cmp	QWORD PTR -8[rbp], 0
	jne	.L1680
	nop
.L1672:
.L1674:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	sub	edx, 1
	mov	DWORD PTR [rax], edx
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR 24[rbp], eax
	je	.L1681
	mov	rax, QWORD PTR 16[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	movsx	rdx, eax
	mov	rax, rdx
	sal	rax, 3
	sub	rax, rdx
	sal	rax, 4
	add	rcx, rax
	mov	rax, QWORD PTR 16[rbp]
	mov	r8, QWORD PTR [rax]
	mov	eax, DWORD PTR 24[rbp]
	movsx	rdx, eax
	mov	rax, rdx
	sal	rax, 3
	sub	rax, rdx
	sal	rax, 4
	add	rax, r8
	mov	rdx, rcx
	mov	rcx, rax
	call	_ZN2FB8DIRENTRYaSERKS0_
	jmp	.L1682
.L1673:
.L1676:
.L1680:
	nop
	jmp	.L1682
.L1681:
	nop
.L1677:
.L1682:
	nop
	add	rsp, 48
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN2FB8DIRENTRYEE5CLEAREv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN2FB8DIRENTRYEE5CLEAREv
_ZN5ArrayIN2FB8DIRENTRYEE5CLEAREv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 160
	.seh_stackalloc	160
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
.L1684:
	lea	rax, -128[rbp]
	mov	rcx, rax
	call	_ZN2FB8DIRENTRYC1Ev
	mov	DWORD PTR -4[rbp], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	sub	eax, 1
	mov	DWORD PTR -8[rbp], eax
	jmp	.L1685
.L1691:
	nop
.L1686:
	mov	rax, QWORD PTR 16[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	eax, DWORD PTR -4[rbp]
	movsx	rdx, eax
	mov	rax, rdx
	sal	rax, 3
	sub	rax, rdx
	sal	rax, 4
	add	rcx, rax
	lea	rax, -128[rbp]
	mov	rdx, rax
	call	_ZN2FB8DIRENTRYaSERKS0_
.L1687:
	add	DWORD PTR -4[rbp], 1
.L1685:
	mov	eax, DWORD PTR -4[rbp]
	cmp	eax, DWORD PTR -8[rbp]
	jle	.L1691
	nop
.L1688:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	DWORD PTR [rax], 0
	lea	rax, -128[rbp]
	mov	rcx, rax
	call	_ZN2FB8DIRENTRYD1Ev
	nop
	add	rsp, 160
	pop	rbp
	ret
.L1689:
	.seh_endproc
	.def	_ZN5ArrayIN2FB8DIRENTRYEE11GETITERATOREv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN2FB8DIRENTRYEE11GETITERATOREv
_ZN5ArrayIN2FB8DIRENTRYEE11GETITERATOREv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
	lea	rax, -16[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
.L1693:
	lea	rax, -32[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	lea	rax, -32[rbp]
	mov	rdx, QWORD PTR 24[rbp]
	mov	QWORD PTR [rax], rdx
	lea	rax, -32[rbp]
	add	rax, 8
	mov	DWORD PTR [rax], 0
	mov	rax, QWORD PTR -32[rbp]
	mov	rdx, QWORD PTR -24[rbp]
	mov	QWORD PTR -16[rbp], rax
	mov	QWORD PTR -8[rbp], rdx
	nop
.L1694:
	mov	rcx, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR -16[rbp]
	mov	rdx, QWORD PTR -8[rbp]
	mov	QWORD PTR [rcx], rax
	mov	QWORD PTR 8[rcx], rdx
	mov	rax, QWORD PTR 16[rbp]
	add	rsp, 32
	pop	rbp
	ret
	.seh_endproc
	.def	_Z4FailIiN2FB7FSERROREERS1_;	.scl	3;	.type	32;	.endef
	.seh_proc	_Z4FailIiN2FB7FSERROREERS1_
_Z4FailIiN2FB7FSERROREERS1_:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 144
	.seh_stackalloc	144
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
.L1697:
	lea	rax, -112[rbp]
	mov	rcx, rax
	call	_ZN6ResultIiN2FB7FSERROREEC1Ev
	lea	rax, -112[rbp]
	add	rax, 8
	mov	rdx, QWORD PTR 24[rbp]
	mov	rcx, rax
	call	_ZN2FB7FSERRORaSERKS0_
	lea	rax, -112[rbp]
	add	rax, 96
	mov	BYTE PTR [rax], 0
	lea	rax, -112[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN6ResultIiN2FB7FSERROREEC1ERKS2_
	lea	rax, -112[rbp]
	mov	rcx, rax
	call	_ZN6ResultIiN2FB7FSERROREED1Ev
	nop
.L1698:
	mov	rax, QWORD PTR 16[rbp]
	add	rsp, 144
	pop	rbp
	ret
	.seh_endproc
	.def	_Z2OkIiN2FB7FSERROREERi;	.scl	3;	.type	32;	.endef
	.seh_proc	_Z2OkIiN2FB7FSERROREERi
_Z2OkIiN2FB7FSERROREERi:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 144
	.seh_stackalloc	144
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
.L1701:
	lea	rax, -112[rbp]
	mov	rcx, rax
	call	_ZN6ResultIiN2FB7FSERROREEC1Ev
	lea	rax, -112[rbp]
	mov	rdx, QWORD PTR 24[rbp]
	mov	edx, DWORD PTR [rdx]
	mov	DWORD PTR [rax], edx
	lea	rax, -112[rbp]
	add	rax, 96
	mov	BYTE PTR [rax], 1
	lea	rax, -112[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN6ResultIiN2FB7FSERROREEC1ERKS2_
	lea	rax, -112[rbp]
	mov	rcx, rax
	call	_ZN6ResultIiN2FB7FSERROREED1Ev
	nop
.L1702:
	mov	rax, QWORD PTR 16[rbp]
	add	rsp, 144
	pop	rbp
	ret
	.seh_endproc
	.def	_Z4FailIN2FB8DIRENTRYEN2FB7FSERROREERS3_;	.scl	3;	.type	32;	.endef
	.seh_proc	_Z4FailIN2FB8DIRENTRYEN2FB7FSERROREERS3_
_Z4FailIN2FB8DIRENTRYEN2FB7FSERROREERS3_:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 240
	.seh_stackalloc	240
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
.L1705:
	lea	rax, -208[rbp]
	mov	rcx, rax
	call	_ZN6ResultIN2FB8DIRENTRYEN2FB7FSERROREEC1Ev
	lea	rax, -208[rbp]
	add	rax, 112
	mov	rdx, QWORD PTR 24[rbp]
	mov	rcx, rax
	call	_ZN2FB7FSERRORaSERKS0_
	lea	rax, -208[rbp]
	add	rax, 200
	mov	BYTE PTR [rax], 0
	lea	rax, -208[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN6ResultIN2FB8DIRENTRYEN2FB7FSERROREEC1ERKS4_
	lea	rax, -208[rbp]
	mov	rcx, rax
	call	_ZN6ResultIN2FB8DIRENTRYEN2FB7FSERROREED1Ev
	nop
.L1706:
	mov	rax, QWORD PTR 16[rbp]
	add	rsp, 240
	pop	rbp
	ret
	.seh_endproc
	.def	_Z6FsFailIxEN2FB11FSERRORCODEERK9FBUSTRINGS4_;	.scl	3;	.type	32;	.endef
	.seh_proc	_Z6FsFailIxEN2FB11FSERRORCODEERK9FBUSTRINGS4_
_Z6FsFailIxEN2FB11FSERRORCODEERK9FBUSTRINGS4_:
	push	rbp
	.seh_pushreg	rbp
	sub	rsp, 272
	.seh_stackalloc	272
	lea	rbp, 128[rsp]
	.seh_setframe	rbp, 128
	.seh_endprologue
	mov	QWORD PTR 160[rbp], rcx
	mov	QWORD PTR 168[rbp], rdx
	mov	QWORD PTR 176[rbp], r8
	mov	QWORD PTR 184[rbp], r9
.L1709:
	call	fb_FsOsError
	mov	DWORD PTR 140[rbp], eax
	mov	r9, QWORD PTR 176[rbp]
	mov	r8d, DWORD PTR 140[rbp]
	mov	rdx, QWORD PTR 168[rbp]
	lea	rax, -80[rbp]
	mov	rcx, QWORD PTR 184[rbp]
	mov	QWORD PTR 32[rsp], rcx
	mov	rcx, rax
	call	_ZN2FB7FSERRORC1ENS_11FSERRORCODEEiRK9FBUSTRINGS4_
	lea	rdx, -80[rbp]
	lea	rax, 16[rbp]
	mov	rcx, rax
	call	_Z4FailIxN2FB7FSERROREERS1_
	mov	QWORD PTR 128[rbp], rax
	mov	rax, QWORD PTR 128[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 160[rbp]
	call	_ZN6ResultIxN2FB7FSERROREEC1ERKS2_
	lea	rax, -80[rbp]
	mov	rcx, rax
	call	_ZN2FB7FSERRORD1Ev
	lea	rax, 16[rbp]
	mov	rcx, rax
	call	_ZN6ResultIxN2FB7FSERROREED1Ev
	nop
.L1710:
	mov	rax, QWORD PTR 160[rbp]
	add	rsp, 272
	pop	rbp
	ret
	.seh_endproc
	.def	_Z2OkIxN2FB7FSERROREERx;	.scl	3;	.type	32;	.endef
	.seh_proc	_Z2OkIxN2FB7FSERROREERx
_Z2OkIxN2FB7FSERROREERx:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 144
	.seh_stackalloc	144
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
.L1713:
	lea	rax, -112[rbp]
	mov	rcx, rax
	call	_ZN6ResultIxN2FB7FSERROREEC1Ev
	lea	rax, -112[rbp]
	mov	rdx, QWORD PTR 24[rbp]
	mov	rdx, QWORD PTR [rdx]
	mov	QWORD PTR [rax], rdx
	lea	rax, -112[rbp]
	add	rax, 96
	mov	BYTE PTR [rax], 1
	lea	rax, -112[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN6ResultIxN2FB7FSERROREEC1ERKS2_
	lea	rax, -112[rbp]
	mov	rcx, rax
	call	_ZN6ResultIxN2FB7FSERROREED1Ev
	nop
.L1714:
	mov	rax, QWORD PTR 16[rbp]
	add	rsp, 144
	pop	rbp
	ret
	.seh_endproc
	.def	_Z4FailIxN2FB7FSERROREERS1_;	.scl	3;	.type	32;	.endef
	.seh_proc	_Z4FailIxN2FB7FSERROREERS1_
_Z4FailIxN2FB7FSERROREERS1_:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 144
	.seh_stackalloc	144
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
.L1717:
	lea	rax, -112[rbp]
	mov	rcx, rax
	call	_ZN6ResultIxN2FB7FSERROREEC1Ev
	lea	rax, -112[rbp]
	add	rax, 8
	mov	rdx, QWORD PTR 24[rbp]
	mov	rcx, rax
	call	_ZN2FB7FSERRORaSERKS0_
	lea	rax, -112[rbp]
	add	rax, 96
	mov	BYTE PTR [rax], 0
	lea	rax, -112[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN6ResultIxN2FB7FSERROREEC1ERKS2_
	lea	rax, -112[rbp]
	mov	rcx, rax
	call	_ZN6ResultIxN2FB7FSERROREED1Ev
	nop
.L1718:
	mov	rax, QWORD PTR 16[rbp]
	add	rsp, 144
	pop	rbp
	ret
	.seh_endproc
	.def	_Z6FsFailIiEN2FB11FSERRORCODEERK9FBUSTRINGS4_;	.scl	3;	.type	32;	.endef
	.seh_proc	_Z6FsFailIiEN2FB11FSERRORCODEERK9FBUSTRINGS4_
_Z6FsFailIiEN2FB11FSERRORCODEERK9FBUSTRINGS4_:
	push	rbp
	.seh_pushreg	rbp
	sub	rsp, 272
	.seh_stackalloc	272
	lea	rbp, 128[rsp]
	.seh_setframe	rbp, 128
	.seh_endprologue
	mov	QWORD PTR 160[rbp], rcx
	mov	QWORD PTR 168[rbp], rdx
	mov	QWORD PTR 176[rbp], r8
	mov	QWORD PTR 184[rbp], r9
.L1721:
	call	fb_FsOsError
	mov	DWORD PTR 140[rbp], eax
	mov	r9, QWORD PTR 176[rbp]
	mov	r8d, DWORD PTR 140[rbp]
	mov	rdx, QWORD PTR 168[rbp]
	lea	rax, -80[rbp]
	mov	rcx, QWORD PTR 184[rbp]
	mov	QWORD PTR 32[rsp], rcx
	mov	rcx, rax
	call	_ZN2FB7FSERRORC1ENS_11FSERRORCODEEiRK9FBUSTRINGS4_
	lea	rdx, -80[rbp]
	lea	rax, 16[rbp]
	mov	rcx, rax
	call	_Z4FailIiN2FB7FSERROREERS1_
	mov	QWORD PTR 128[rbp], rax
	mov	rax, QWORD PTR 128[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 160[rbp]
	call	_ZN6ResultIiN2FB7FSERROREEC1ERKS2_
	lea	rax, -80[rbp]
	mov	rcx, rax
	call	_ZN2FB7FSERRORD1Ev
	lea	rax, 16[rbp]
	mov	rcx, rax
	call	_ZN6ResultIiN2FB7FSERROREED1Ev
	nop
.L1722:
	mov	rax, QWORD PTR 160[rbp]
	add	rsp, 272
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN6ResultIjN2FB7FSERROREE4ISOKEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN6ResultIjN2FB7FSERROREE4ISOKEv
_ZN6ResultIjN2FB7FSERROREE4ISOKEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	BYTE PTR -1[rbp], 0
.L1725:
	mov	rax, QWORD PTR 16[rbp]
	movzx	eax, BYTE PTR 96[rax]
	mov	BYTE PTR -1[rbp], al
	nop
.L1726:
	movzx	eax, BYTE PTR -1[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN6ResultIjN2FB7FSERROREE5VALUEEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN6ResultIjN2FB7FSERROREE5VALUEEv
_ZN6ResultIjN2FB7FSERROREE5VALUEEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 64
	.seh_stackalloc	64
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR -16[rbp], 0
.L1729:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 96
	movzx	eax, BYTE PTR [rax]
	test	al, al
	jne	.L1737
	nop
.L1730:
	mov	QWORD PTR 32[rsp], 0
	mov	r9d, 0
	lea	r8, .LC0[rip]
	mov	edx, 87
	mov	ecx, 1
	call	fb_ErrorThrowEx
	mov	QWORD PTR -8[rbp], rax
	jmp	[QWORD PTR -8[rbp]]
.L1731:
.L1732:
.L1737:
	nop
.L1733:
	mov	rax, QWORD PTR 16[rbp]
	mov	QWORD PTR -16[rbp], rax
	nop
.L1734:
	mov	rax, QWORD PTR -16[rbp]
	add	rsp, 64
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN6ResultIjN2FB7FSERROREE7FAILUREEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN6ResultIjN2FB7FSERROREE7FAILUREEv
_ZN6ResultIjN2FB7FSERROREE7FAILUREEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 64
	.seh_stackalloc	64
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR -16[rbp], 0
.L1739:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 96
	movzx	eax, BYTE PTR [rax]
	test	al, al
	je	.L1747
	nop
.L1740:
	mov	QWORD PTR 32[rsp], 0
	mov	r9d, 0
	lea	r8, .LC0[rip]
	mov	edx, 105
	mov	ecx, 1
	call	fb_ErrorThrowEx
	mov	QWORD PTR -8[rbp], rax
	jmp	[QWORD PTR -8[rbp]]
.L1741:
.L1742:
.L1747:
	nop
.L1743:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	QWORD PTR -16[rbp], rax
	nop
.L1744:
	mov	rax, QWORD PTR -16[rbp]
	add	rsp, 64
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN6ResultIjN2FB7FSERROREE7VALUEORERj;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN6ResultIjN2FB7FSERROREE7VALUEORERj
_ZN6ResultIjN2FB7FSERROREE7VALUEORERj:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
	mov	QWORD PTR -8[rbp], 0
.L1749:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 96
	movzx	eax, BYTE PTR [rax]
	test	al, al
	jne	.L1756
	mov	rax, QWORD PTR 24[rbp]
	mov	QWORD PTR -8[rbp], rax
	jmp	.L1752
.L1751:
.L1756:
	nop
.L1753:
	mov	rax, QWORD PTR 16[rbp]
	mov	QWORD PTR -8[rbp], rax
	nop
.L1752:
	mov	rax, QWORD PTR -8[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_Z6FsFailIjEN2FB11FSERRORCODEERK9FBUSTRINGS4_;	.scl	3;	.type	32;	.endef
	.seh_proc	_Z6FsFailIjEN2FB11FSERRORCODEERK9FBUSTRINGS4_
_Z6FsFailIjEN2FB11FSERRORCODEERK9FBUSTRINGS4_:
	push	rbp
	.seh_pushreg	rbp
	sub	rsp, 272
	.seh_stackalloc	272
	lea	rbp, 128[rsp]
	.seh_setframe	rbp, 128
	.seh_endprologue
	mov	QWORD PTR 160[rbp], rcx
	mov	QWORD PTR 168[rbp], rdx
	mov	QWORD PTR 176[rbp], r8
	mov	QWORD PTR 184[rbp], r9
.L1758:
	call	fb_FsOsError
	mov	DWORD PTR 140[rbp], eax
	mov	r9, QWORD PTR 176[rbp]
	mov	r8d, DWORD PTR 140[rbp]
	mov	rdx, QWORD PTR 168[rbp]
	lea	rax, -80[rbp]
	mov	rcx, QWORD PTR 184[rbp]
	mov	QWORD PTR 32[rsp], rcx
	mov	rcx, rax
	call	_ZN2FB7FSERRORC1ENS_11FSERRORCODEEiRK9FBUSTRINGS4_
	lea	rdx, -80[rbp]
	lea	rax, 16[rbp]
	mov	rcx, rax
	call	_Z4FailIjN2FB7FSERROREERS1_
	mov	QWORD PTR 128[rbp], rax
	mov	rax, QWORD PTR 128[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 160[rbp]
	call	_ZN6ResultIjN2FB7FSERROREEC1ERKS2_
	lea	rax, -80[rbp]
	mov	rcx, rax
	call	_ZN2FB7FSERRORD1Ev
	lea	rax, 16[rbp]
	mov	rcx, rax
	call	_ZN6ResultIjN2FB7FSERROREED1Ev
	nop
.L1759:
	mov	rax, QWORD PTR 160[rbp]
	add	rsp, 272
	pop	rbp
	ret
	.seh_endproc
	.def	_Z2OkIjN2FB7FSERROREERj;	.scl	3;	.type	32;	.endef
	.seh_proc	_Z2OkIjN2FB7FSERROREERj
_Z2OkIjN2FB7FSERROREERj:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 144
	.seh_stackalloc	144
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
.L1762:
	lea	rax, -112[rbp]
	mov	rcx, rax
	call	_ZN6ResultIjN2FB7FSERROREEC1Ev
	lea	rax, -112[rbp]
	mov	rdx, QWORD PTR 24[rbp]
	mov	edx, DWORD PTR [rdx]
	mov	DWORD PTR [rax], edx
	lea	rax, -112[rbp]
	add	rax, 96
	mov	BYTE PTR [rax], 1
	lea	rax, -112[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN6ResultIjN2FB7FSERROREEC1ERKS2_
	lea	rax, -112[rbp]
	mov	rcx, rax
	call	_ZN6ResultIjN2FB7FSERROREED1Ev
	nop
.L1763:
	mov	rax, QWORD PTR 16[rbp]
	add	rsp, 144
	pop	rbp
	ret
	.seh_endproc
	.def	_Z4FailIjN2FB7FSERROREERS1_;	.scl	3;	.type	32;	.endef
	.seh_proc	_Z4FailIjN2FB7FSERROREERS1_
_Z4FailIjN2FB7FSERROREERS1_:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 144
	.seh_stackalloc	144
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
.L1766:
	lea	rax, -112[rbp]
	mov	rcx, rax
	call	_ZN6ResultIjN2FB7FSERROREEC1Ev
	lea	rax, -112[rbp]
	add	rax, 8
	mov	rdx, QWORD PTR 24[rbp]
	mov	rcx, rax
	call	_ZN2FB7FSERRORaSERKS0_
	lea	rax, -112[rbp]
	add	rax, 96
	mov	BYTE PTR [rax], 0
	lea	rax, -112[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN6ResultIjN2FB7FSERROREEC1ERKS2_
	lea	rax, -112[rbp]
	mov	rcx, rax
	call	_ZN6ResultIjN2FB7FSERROREED1Ev
	nop
.L1767:
	mov	rax, QWORD PTR 16[rbp]
	add	rsp, 144
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN6ResultIN2FB9DISKSPACEEN2FB7FSERROREE4ISOKEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN6ResultIN2FB9DISKSPACEEN2FB7FSERROREE4ISOKEv
_ZN6ResultIN2FB9DISKSPACEEN2FB7FSERROREE4ISOKEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	BYTE PTR -1[rbp], 0
.L1770:
	mov	rax, QWORD PTR 16[rbp]
	movzx	eax, BYTE PTR 112[rax]
	mov	BYTE PTR -1[rbp], al
	nop
.L1771:
	movzx	eax, BYTE PTR -1[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN6ResultIN2FB9DISKSPACEEN2FB7FSERROREE5VALUEEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN6ResultIN2FB9DISKSPACEEN2FB7FSERROREE5VALUEEv
_ZN6ResultIN2FB9DISKSPACEEN2FB7FSERROREE5VALUEEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 64
	.seh_stackalloc	64
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR -16[rbp], 0
.L1774:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 112
	movzx	eax, BYTE PTR [rax]
	test	al, al
	jne	.L1782
	nop
.L1775:
	mov	QWORD PTR 32[rsp], 0
	mov	r9d, 0
	lea	r8, .LC0[rip]
	mov	edx, 87
	mov	ecx, 1
	call	fb_ErrorThrowEx
	mov	QWORD PTR -8[rbp], rax
	jmp	[QWORD PTR -8[rbp]]
.L1776:
.L1777:
.L1782:
	nop
.L1778:
	mov	rax, QWORD PTR 16[rbp]
	mov	QWORD PTR -16[rbp], rax
	nop
.L1779:
	mov	rax, QWORD PTR -16[rbp]
	add	rsp, 64
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN6ResultIN2FB9DISKSPACEEN2FB7FSERROREE7FAILUREEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN6ResultIN2FB9DISKSPACEEN2FB7FSERROREE7FAILUREEv
_ZN6ResultIN2FB9DISKSPACEEN2FB7FSERROREE7FAILUREEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 64
	.seh_stackalloc	64
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR -16[rbp], 0
.L1784:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 112
	movzx	eax, BYTE PTR [rax]
	test	al, al
	je	.L1792
	nop
.L1785:
	mov	QWORD PTR 32[rsp], 0
	mov	r9d, 0
	lea	r8, .LC0[rip]
	mov	edx, 105
	mov	ecx, 1
	call	fb_ErrorThrowEx
	mov	QWORD PTR -8[rbp], rax
	jmp	[QWORD PTR -8[rbp]]
.L1786:
.L1787:
.L1792:
	nop
.L1788:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 24
	mov	QWORD PTR -16[rbp], rax
	nop
.L1789:
	mov	rax, QWORD PTR -16[rbp]
	add	rsp, 64
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN6ResultIN2FB9DISKSPACEEN2FB7FSERROREE7VALUEORERS1_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN6ResultIN2FB9DISKSPACEEN2FB7FSERROREE7VALUEORERS1_
_ZN6ResultIN2FB9DISKSPACEEN2FB7FSERROREE7VALUEORERS1_:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
	mov	QWORD PTR -8[rbp], 0
.L1794:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 112
	movzx	eax, BYTE PTR [rax]
	test	al, al
	jne	.L1801
	mov	rax, QWORD PTR 24[rbp]
	mov	QWORD PTR -8[rbp], rax
	jmp	.L1797
.L1796:
.L1801:
	nop
.L1798:
	mov	rax, QWORD PTR 16[rbp]
	mov	QWORD PTR -8[rbp], rax
	nop
.L1797:
	mov	rax, QWORD PTR -8[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN6ResultIN2FB10VOLUMEINFOEN2FB7FSERROREE4ISOKEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN6ResultIN2FB10VOLUMEINFOEN2FB7FSERROREE4ISOKEv
_ZN6ResultIN2FB10VOLUMEINFOEN2FB7FSERROREE4ISOKEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	BYTE PTR -1[rbp], 0
.L1803:
	mov	rax, QWORD PTR 16[rbp]
	movzx	eax, BYTE PTR 168[rax]
	mov	BYTE PTR -1[rbp], al
	nop
.L1804:
	movzx	eax, BYTE PTR -1[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN6ResultIN2FB10VOLUMEINFOEN2FB7FSERROREE5VALUEEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN6ResultIN2FB10VOLUMEINFOEN2FB7FSERROREE5VALUEEv
_ZN6ResultIN2FB10VOLUMEINFOEN2FB7FSERROREE5VALUEEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 64
	.seh_stackalloc	64
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR -16[rbp], 0
.L1807:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 168
	movzx	eax, BYTE PTR [rax]
	test	al, al
	jne	.L1815
	nop
.L1808:
	mov	QWORD PTR 32[rsp], 0
	mov	r9d, 0
	lea	r8, .LC0[rip]
	mov	edx, 87
	mov	ecx, 1
	call	fb_ErrorThrowEx
	mov	QWORD PTR -8[rbp], rax
	jmp	[QWORD PTR -8[rbp]]
.L1809:
.L1810:
.L1815:
	nop
.L1811:
	mov	rax, QWORD PTR 16[rbp]
	mov	QWORD PTR -16[rbp], rax
	nop
.L1812:
	mov	rax, QWORD PTR -16[rbp]
	add	rsp, 64
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN6ResultIN2FB10VOLUMEINFOEN2FB7FSERROREE7FAILUREEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN6ResultIN2FB10VOLUMEINFOEN2FB7FSERROREE7FAILUREEv
_ZN6ResultIN2FB10VOLUMEINFOEN2FB7FSERROREE7FAILUREEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 64
	.seh_stackalloc	64
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR -16[rbp], 0
.L1817:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 168
	movzx	eax, BYTE PTR [rax]
	test	al, al
	je	.L1825
	nop
.L1818:
	mov	QWORD PTR 32[rsp], 0
	mov	r9d, 0
	lea	r8, .LC0[rip]
	mov	edx, 105
	mov	ecx, 1
	call	fb_ErrorThrowEx
	mov	QWORD PTR -8[rbp], rax
	jmp	[QWORD PTR -8[rbp]]
.L1819:
.L1820:
.L1825:
	nop
.L1821:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 80
	mov	QWORD PTR -16[rbp], rax
	nop
.L1822:
	mov	rax, QWORD PTR -16[rbp]
	add	rsp, 64
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN6ResultIN2FB10VOLUMEINFOEN2FB7FSERROREE7VALUEORERS1_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN6ResultIN2FB10VOLUMEINFOEN2FB7FSERROREE7VALUEORERS1_
_ZN6ResultIN2FB10VOLUMEINFOEN2FB7FSERROREE7VALUEORERS1_:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
	mov	QWORD PTR -8[rbp], 0
.L1827:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 168
	movzx	eax, BYTE PTR [rax]
	test	al, al
	jne	.L1834
	mov	rax, QWORD PTR 24[rbp]
	mov	QWORD PTR -8[rbp], rax
	jmp	.L1830
.L1829:
.L1834:
	nop
.L1831:
	mov	rax, QWORD PTR 16[rbp]
	mov	QWORD PTR -8[rbp], rax
	nop
.L1830:
	mov	rax, QWORD PTR -8[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN13ArrayIteratorIN2FB10VOLUMEINFOEE7ISVALIDEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN13ArrayIteratorIN2FB10VOLUMEINFOEE7ISVALIDEv
_ZN13ArrayIteratorIN2FB10VOLUMEINFOEE7ISVALIDEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	BYTE PTR -9[rbp], 0
.L1836:
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	QWORD PTR -8[rbp], rax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR -8[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	edx, eax
	setl	al
	mov	BYTE PTR -9[rbp], al
	nop
.L1837:
	movzx	eax, BYTE PTR -9[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN13ArrayIteratorIN2FB10VOLUMEINFOEE5VALUEEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN13ArrayIteratorIN2FB10VOLUMEINFOEE5VALUEEv
_ZN13ArrayIteratorIN2FB10VOLUMEINFOEE5VALUEEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR -16[rbp], 0
.L1840:
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	QWORD PTR -8[rbp], rax
	mov	rax, QWORD PTR -8[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	eax, DWORD PTR [rax]
	movsx	rdx, eax
	mov	rax, rdx
	sal	rax, 2
	add	rax, rdx
	sal	rax, 4
	add	rax, rcx
	mov	QWORD PTR -16[rbp], rax
	nop
.L1841:
	mov	rax, QWORD PTR -16[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN13ArrayIteratorIN2FB10VOLUMEINFOEE8MOVENEXTEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN13ArrayIteratorIN2FB10VOLUMEINFOEE8MOVENEXTEv
_ZN13ArrayIteratorIN2FB10VOLUMEINFOEE8MOVENEXTEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
.L1844:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	add	edx, 1
	mov	DWORD PTR [rax], edx
	nop
	pop	rbp
	ret
.L1845:
	.seh_endproc
	.def	_ZN5ArrayIN2FB10VOLUMEINFOEE5COUNTEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN2FB10VOLUMEINFOEE5COUNTEv
_ZN5ArrayIN2FB10VOLUMEINFOEE5COUNTEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR -4[rbp], 0
.L1847:
	mov	rax, QWORD PTR 16[rbp]
	mov	eax, DWORD PTR 72[rax]
	mov	DWORD PTR -4[rbp], eax
	nop
.L1848:
	mov	eax, DWORD PTR -4[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN2FB10VOLUMEINFOEE8CAPACITYEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN2FB10VOLUMEINFOEE8CAPACITYEv
_ZN5ArrayIN2FB10VOLUMEINFOEE8CAPACITYEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 64
	.seh_stackalloc	64
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR -20[rbp], 0
.L1851:
	mov	edx, 1
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayUBound
	mov	QWORD PTR -8[rbp], rax
	mov	edx, 1
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayLBound
	mov	QWORD PTR -16[rbp], rax
	mov	rax, QWORD PTR -8[rbp]
	mov	edx, eax
	mov	rax, QWORD PTR -16[rbp]
	sub	edx, eax
	mov	eax, edx
	add	eax, 1
	mov	DWORD PTR -20[rbp], eax
	nop
.L1852:
	mov	eax, DWORD PTR -20[rbp]
	add	rsp, 64
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN2FB10VOLUMEINFOEE7ISEMPTYEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN2FB10VOLUMEINFOEE7ISEMPTYEv
_ZN5ArrayIN2FB10VOLUMEINFOEE7ISEMPTYEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	BYTE PTR -1[rbp], 0
.L1855:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	sete	al
	mov	BYTE PTR -1[rbp], al
	nop
.L1856:
	movzx	eax, BYTE PTR -1[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN2FB10VOLUMEINFOEE7RESERVEEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN2FB10VOLUMEINFOEE7RESERVEEi
_ZN5ArrayIN2FB10VOLUMEINFOEE7RESERVEEi:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 80
	.seh_stackalloc	80
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
.L1859:
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIN2FB10VOLUMEINFOEE8CAPACITYEv
	mov	DWORD PTR -8[rbp], eax
	mov	eax, DWORD PTR 24[rbp]
	cmp	eax, DWORD PTR -8[rbp]
	jle	.L1872
	nop
.L1861:
.L1863:
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIN2FB10VOLUMEINFOEE8CAPACITYEv
	mov	DWORD PTR -12[rbp], eax
	mov	eax, DWORD PTR -12[rbp]
	mov	DWORD PTR -4[rbp], eax
	cmp	DWORD PTR -4[rbp], 7
	jg	.L1873
	mov	DWORD PTR -4[rbp], 8
	jmp	.L1870
.L1865:
.L1866:
.L1873:
	nop
.L1867:
.L1870:
	mov	eax, DWORD PTR -4[rbp]
	cmp	eax, DWORD PTR 24[rbp]
	jge	.L1874
	mov	eax, DWORD PTR -4[rbp]
	cdqe
	add	rax, rax
	mov	DWORD PTR -4[rbp], eax
	jmp	.L1870
.L1874:
	nop
.L1869:
	mov	eax, DWORD PTR -4[rbp]
	cdqe
	sub	rax, 1
	mov	QWORD PTR 48[rsp], rax
	mov	QWORD PTR 40[rsp], 0
	mov	QWORD PTR 32[rsp], 1
	lea	r9, _ZN2FB10VOLUMEINFOD1Ev[rip]
	lea	r8, _ZN2FB10VOLUMEINFOC1Ev[rip]
	mov	edx, 80
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayRedimPresvObj
	jmp	.L1875
.L1872:
	nop
.L1862:
.L1875:
	nop
	add	rsp, 80
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN2FB10VOLUMEINFOEE6SHRINKEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN2FB10VOLUMEINFOEE6SHRINKEv
_ZN5ArrayIN2FB10VOLUMEINFOEE6SHRINKEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 80
	.seh_stackalloc	80
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
.L1877:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	jne	.L1886
	lea	r8, _ZN2FB10VOLUMEINFOD1Ev[rip]
	lea	rdx, _ZN2FB10VOLUMEINFOC1Ev[rip]
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayEraseObj
	jmp	.L1880
.L1879:
.L1886:
	nop
.L1881:
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIN2FB10VOLUMEINFOEE8CAPACITYEv
	mov	DWORD PTR -4[rbp], eax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR -4[rbp], eax
	je	.L1887
	nop
.L1883:
.L1884:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cdqe
	sub	rax, 1
	mov	QWORD PTR 48[rsp], rax
	mov	QWORD PTR 40[rsp], 0
	mov	QWORD PTR 32[rsp], 1
	lea	r9, _ZN2FB10VOLUMEINFOD1Ev[rip]
	lea	r8, _ZN2FB10VOLUMEINFOC1Ev[rip]
	mov	edx, 80
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayRedimPresvObj
	jmp	.L1888
.L1887:
	nop
.L1880:
.L1888:
	nop
	add	rsp, 80
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN2FB10VOLUMEINFOEEixEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN2FB10VOLUMEINFOEEixEi
_ZN5ArrayIN2FB10VOLUMEINFOEEixEi:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
	mov	QWORD PTR -8[rbp], 0
.L1890:
	mov	rax, QWORD PTR 16[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	eax, DWORD PTR 24[rbp]
	movsx	rdx, eax
	mov	rax, rdx
	sal	rax, 2
	add	rax, rdx
	sal	rax, 4
	add	rax, rcx
	mov	QWORD PTR -8[rbp], rax
	nop
.L1891:
	mov	rax, QWORD PTR -8[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN2FB10VOLUMEINFOEE2ATEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN2FB10VOLUMEINFOEE2ATEi
_ZN5ArrayIN2FB10VOLUMEINFOEE2ATEi:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
	mov	QWORD PTR -8[rbp], 0
.L1894:
	mov	rax, QWORD PTR 16[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	eax, DWORD PTR 24[rbp]
	movsx	rdx, eax
	mov	rax, rdx
	sal	rax, 2
	add	rax, rdx
	sal	rax, 4
	add	rax, rcx
	mov	QWORD PTR -8[rbp], rax
	nop
.L1895:
	mov	rax, QWORD PTR -8[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN2FB10VOLUMEINFOEE4PUSHERS1_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN2FB10VOLUMEINFOEE4PUSHERS1_
_ZN5ArrayIN2FB10VOLUMEINFOEE4PUSHERS1_:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
.L1898:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	add	eax, 1
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIN2FB10VOLUMEINFOEE7RESERVEEi
	mov	rax, QWORD PTR 16[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	movsx	rdx, eax
	mov	rax, rdx
	sal	rax, 2
	add	rax, rdx
	sal	rax, 4
	add	rcx, rax
	mov	rax, QWORD PTR 24[rbp]
	mov	rdx, rax
	call	_ZN2FB10VOLUMEINFOaSERKS0_
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	add	edx, 1
	mov	DWORD PTR [rax], edx
	nop
	add	rsp, 32
	pop	rbp
	ret
.L1899:
	.seh_endproc
	.def	_ZN5ArrayIN2FB10VOLUMEINFOEE3POPEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN2FB10VOLUMEINFOEE3POPEv
_ZN5ArrayIN2FB10VOLUMEINFOEE3POPEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 112
	.seh_stackalloc	112
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
.L1901:
	lea	rax, -80[rbp]
	mov	rcx, rax
	call	_ZN2FB10VOLUMEINFOC1Ev
	mov	rax, QWORD PTR 24[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	jne	.L1908
	lea	rax, -80[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN2FB10VOLUMEINFOC1ERKS0_
	lea	rax, -80[rbp]
	mov	rcx, rax
	call	_ZN2FB10VOLUMEINFOD1Ev
	jmp	.L1904
.L1903:
.L1908:
	nop
.L1905:
	mov	rax, QWORD PTR 24[rbp]
	add	rax, 72
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 24[rbp]
	add	rax, 72
	sub	edx, 1
	mov	DWORD PTR [rax], edx
	mov	rax, QWORD PTR 24[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	rax, QWORD PTR 24[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	movsx	rdx, eax
	mov	rax, rdx
	sal	rax, 2
	add	rax, rdx
	sal	rax, 4
	lea	rdx, [rcx+rax]
	lea	rax, -80[rbp]
	mov	rcx, rax
	call	_ZN2FB10VOLUMEINFOaSERKS0_
	lea	rax, -80[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN2FB10VOLUMEINFOC1ERKS0_
	lea	rax, -80[rbp]
	mov	rcx, rax
	call	_ZN2FB10VOLUMEINFOD1Ev
	nop
.L1904:
	mov	rax, QWORD PTR 16[rbp]
	add	rsp, 112
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN2FB10VOLUMEINFOEE6INSERTEiRS1_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN2FB10VOLUMEINFOEE6INSERTEiRS1_
_ZN5ArrayIN2FB10VOLUMEINFOEE6INSERTEiRS1_:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	add	rsp, -128
	.seh_stackalloc	128
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
	mov	QWORD PTR 32[rbp], r8
.L1910:
	cmp	DWORD PTR 24[rbp], 0
	js	.L1924
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR 24[rbp], eax
	setg	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -8[rbp], rax
	jmp	.L1913
.L1924:
	nop
.L1912:
	mov	QWORD PTR -8[rbp], -1
.L1913:
	cmp	QWORD PTR -8[rbp], 0
	jne	.L1925
	nop
.L1915:
.L1917:
	mov	rdx, QWORD PTR 32[rbp]
	lea	rax, -96[rbp]
	mov	rcx, rax
	call	_ZN2FB10VOLUMEINFOC1ERKS0_
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	add	eax, 1
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIN2FB10VOLUMEINFOEE7RESERVEEi
	mov	rax, QWORD PTR 16[rbp]
	mov	eax, DWORD PTR 72[rax]
	mov	DWORD PTR -12[rbp], eax
	mov	eax, DWORD PTR 24[rbp]
	add	eax, 1
	mov	DWORD PTR -16[rbp], eax
	jmp	.L1918
.L1926:
	nop
.L1919:
	mov	rax, QWORD PTR 16[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	eax, DWORD PTR -12[rbp]
	movsx	rdx, eax
	mov	rax, rdx
	sal	rax, 2
	add	rax, rdx
	sal	rax, 4
	sub	rax, 80
	add	rcx, rax
	mov	rax, QWORD PTR 16[rbp]
	mov	r8, QWORD PTR [rax]
	mov	eax, DWORD PTR -12[rbp]
	movsx	rdx, eax
	mov	rax, rdx
	sal	rax, 2
	add	rax, rdx
	sal	rax, 4
	add	rax, r8
	mov	rdx, rcx
	mov	rcx, rax
	call	_ZN2FB10VOLUMEINFOaSERKS0_
.L1920:
	sub	DWORD PTR -12[rbp], 1
.L1918:
	mov	eax, DWORD PTR -12[rbp]
	cmp	eax, DWORD PTR -16[rbp]
	jge	.L1926
	nop
.L1921:
	mov	rax, QWORD PTR 16[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	eax, DWORD PTR 24[rbp]
	movsx	rdx, eax
	mov	rax, rdx
	sal	rax, 2
	add	rax, rdx
	sal	rax, 4
	add	rcx, rax
	lea	rax, -96[rbp]
	mov	rdx, rax
	call	_ZN2FB10VOLUMEINFOaSERKS0_
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	add	edx, 1
	mov	DWORD PTR [rax], edx
	lea	rax, -96[rbp]
	mov	rcx, rax
	call	_ZN2FB10VOLUMEINFOD1Ev
	jmp	.L1927
.L1925:
	nop
.L1916:
.L1927:
	nop
	sub	rsp, -128
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN2FB10VOLUMEINFOEE6REMOVEEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN2FB10VOLUMEINFOEE6REMOVEEi
_ZN5ArrayIN2FB10VOLUMEINFOEE6REMOVEEi:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 48
	.seh_stackalloc	48
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
.L1929:
	cmp	DWORD PTR 24[rbp], 0
	js	.L1943
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR 24[rbp], eax
	setge	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -8[rbp], rax
	jmp	.L1932
.L1943:
	nop
.L1931:
	mov	QWORD PTR -8[rbp], -1
.L1932:
	cmp	QWORD PTR -8[rbp], 0
	jne	.L1944
	nop
.L1934:
.L1936:
	mov	eax, DWORD PTR 24[rbp]
	mov	DWORD PTR -12[rbp], eax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	sub	eax, 2
	mov	DWORD PTR -16[rbp], eax
	jmp	.L1937
.L1945:
	nop
.L1938:
	mov	rax, QWORD PTR 16[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	eax, DWORD PTR -12[rbp]
	movsx	rdx, eax
	mov	rax, rdx
	sal	rax, 2
	add	rax, rdx
	sal	rax, 4
	add	rax, 80
	add	rcx, rax
	mov	rax, QWORD PTR 16[rbp]
	mov	r8, QWORD PTR [rax]
	mov	eax, DWORD PTR -12[rbp]
	movsx	rdx, eax
	mov	rax, rdx
	sal	rax, 2
	add	rax, rdx
	sal	rax, 4
	add	rax, r8
	mov	rdx, rcx
	mov	rcx, rax
	call	_ZN2FB10VOLUMEINFOaSERKS0_
.L1939:
	add	DWORD PTR -12[rbp], 1
.L1937:
	mov	eax, DWORD PTR -12[rbp]
	cmp	eax, DWORD PTR -16[rbp]
	jle	.L1945
	nop
.L1940:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	sub	edx, 1
	mov	DWORD PTR [rax], edx
	jmp	.L1946
.L1944:
	nop
.L1935:
.L1946:
	nop
	add	rsp, 48
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN2FB10VOLUMEINFOEE10REMOVESWAPEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN2FB10VOLUMEINFOEE10REMOVESWAPEi
_ZN5ArrayIN2FB10VOLUMEINFOEE10REMOVESWAPEi:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 48
	.seh_stackalloc	48
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
.L1948:
	cmp	DWORD PTR 24[rbp], 0
	js	.L1960
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR 24[rbp], eax
	setge	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -8[rbp], rax
	jmp	.L1951
.L1960:
	nop
.L1950:
	mov	QWORD PTR -8[rbp], -1
.L1951:
	cmp	QWORD PTR -8[rbp], 0
	jne	.L1961
	nop
.L1953:
.L1955:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	sub	edx, 1
	mov	DWORD PTR [rax], edx
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR 24[rbp], eax
	je	.L1962
	mov	rax, QWORD PTR 16[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	movsx	rdx, eax
	mov	rax, rdx
	sal	rax, 2
	add	rax, rdx
	sal	rax, 4
	add	rcx, rax
	mov	rax, QWORD PTR 16[rbp]
	mov	r8, QWORD PTR [rax]
	mov	eax, DWORD PTR 24[rbp]
	movsx	rdx, eax
	mov	rax, rdx
	sal	rax, 2
	add	rax, rdx
	sal	rax, 4
	add	rax, r8
	mov	rdx, rcx
	mov	rcx, rax
	call	_ZN2FB10VOLUMEINFOaSERKS0_
	jmp	.L1963
.L1954:
.L1957:
.L1961:
	nop
	jmp	.L1963
.L1962:
	nop
.L1958:
.L1963:
	nop
	add	rsp, 48
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN2FB10VOLUMEINFOEE5CLEAREv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN2FB10VOLUMEINFOEE5CLEAREv
_ZN5ArrayIN2FB10VOLUMEINFOEE5CLEAREv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	add	rsp, -128
	.seh_stackalloc	128
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
.L1965:
	lea	rax, -96[rbp]
	mov	rcx, rax
	call	_ZN2FB10VOLUMEINFOC1Ev
	mov	DWORD PTR -4[rbp], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	sub	eax, 1
	mov	DWORD PTR -8[rbp], eax
	jmp	.L1966
.L1972:
	nop
.L1967:
	mov	rax, QWORD PTR 16[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	eax, DWORD PTR -4[rbp]
	movsx	rdx, eax
	mov	rax, rdx
	sal	rax, 2
	add	rax, rdx
	sal	rax, 4
	add	rcx, rax
	lea	rax, -96[rbp]
	mov	rdx, rax
	call	_ZN2FB10VOLUMEINFOaSERKS0_
.L1968:
	add	DWORD PTR -4[rbp], 1
.L1966:
	mov	eax, DWORD PTR -4[rbp]
	cmp	eax, DWORD PTR -8[rbp]
	jle	.L1972
	nop
.L1969:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	DWORD PTR [rax], 0
	lea	rax, -96[rbp]
	mov	rcx, rax
	call	_ZN2FB10VOLUMEINFOD1Ev
	nop
	sub	rsp, -128
	pop	rbp
	ret
.L1970:
	.seh_endproc
	.def	_ZN5ArrayIN2FB10VOLUMEINFOEE11GETITERATOREv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN2FB10VOLUMEINFOEE11GETITERATOREv
_ZN5ArrayIN2FB10VOLUMEINFOEE11GETITERATOREv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
	lea	rax, -16[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
.L1974:
	lea	rax, -32[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	lea	rax, -32[rbp]
	mov	rdx, QWORD PTR 24[rbp]
	mov	QWORD PTR [rax], rdx
	lea	rax, -32[rbp]
	add	rax, 8
	mov	DWORD PTR [rax], 0
	mov	rax, QWORD PTR -32[rbp]
	mov	rdx, QWORD PTR -24[rbp]
	mov	QWORD PTR -16[rbp], rax
	mov	QWORD PTR -8[rbp], rdx
	nop
.L1975:
	mov	rcx, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR -16[rbp]
	mov	rdx, QWORD PTR -8[rbp]
	mov	QWORD PTR [rcx], rax
	mov	QWORD PTR 8[rcx], rdx
	mov	rax, QWORD PTR 16[rbp]
	add	rsp, 32
	pop	rbp
	ret
	.seh_endproc
	.def	_Z6FsFailIN2FB9DISKSPACEEENS0_11FSERRORCODEERK9FBUSTRINGS5_;	.scl	3;	.type	32;	.endef
	.seh_proc	_Z6FsFailIN2FB9DISKSPACEEENS0_11FSERRORCODEERK9FBUSTRINGS5_
_Z6FsFailIN2FB9DISKSPACEEENS0_11FSERRORCODEERK9FBUSTRINGS5_:
	push	rbp
	.seh_pushreg	rbp
	sub	rsp, 288
	.seh_stackalloc	288
	lea	rbp, 128[rsp]
	.seh_setframe	rbp, 128
	.seh_endprologue
	mov	QWORD PTR 176[rbp], rcx
	mov	QWORD PTR 184[rbp], rdx
	mov	QWORD PTR 192[rbp], r8
	mov	QWORD PTR 200[rbp], r9
.L1978:
	call	fb_FsOsError
	mov	DWORD PTR 156[rbp], eax
	mov	r9, QWORD PTR 192[rbp]
	mov	r8d, DWORD PTR 156[rbp]
	mov	rdx, QWORD PTR 184[rbp]
	lea	rax, -80[rbp]
	mov	rcx, QWORD PTR 200[rbp]
	mov	QWORD PTR 32[rsp], rcx
	mov	rcx, rax
	call	_ZN2FB7FSERRORC1ENS_11FSERRORCODEEiRK9FBUSTRINGS4_
	lea	rdx, -80[rbp]
	lea	rax, 16[rbp]
	mov	rcx, rax
	call	_Z4FailIN2FB9DISKSPACEEN2FB7FSERROREERS3_
	mov	QWORD PTR 144[rbp], rax
	mov	rax, QWORD PTR 144[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 176[rbp]
	call	_ZN6ResultIN2FB9DISKSPACEEN2FB7FSERROREEC1ERKS4_
	lea	rax, -80[rbp]
	mov	rcx, rax
	call	_ZN2FB7FSERRORD1Ev
	lea	rax, 16[rbp]
	mov	rcx, rax
	call	_ZN6ResultIN2FB9DISKSPACEEN2FB7FSERROREED1Ev
	nop
.L1979:
	mov	rax, QWORD PTR 176[rbp]
	add	rsp, 288
	pop	rbp
	ret
	.seh_endproc
	.def	_Z2OkIN2FB9DISKSPACEEN2FB7FSERROREERS1_;	.scl	3;	.type	32;	.endef
	.seh_proc	_Z2OkIN2FB9DISKSPACEEN2FB7FSERROREERS1_
_Z2OkIN2FB9DISKSPACEEN2FB7FSERROREERS1_:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 160
	.seh_stackalloc	160
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
.L1982:
	lea	rax, -128[rbp]
	mov	rcx, rax
	call	_ZN6ResultIN2FB9DISKSPACEEN2FB7FSERROREEC1Ev
	lea	rcx, -128[rbp]
	mov	r8, QWORD PTR 24[rbp]
	mov	rax, QWORD PTR [r8]
	mov	rdx, QWORD PTR 8[r8]
	mov	QWORD PTR [rcx], rax
	mov	QWORD PTR 8[rcx], rdx
	mov	rax, QWORD PTR 16[r8]
	mov	QWORD PTR 16[rcx], rax
	lea	rax, -128[rbp]
	add	rax, 112
	mov	BYTE PTR [rax], 1
	lea	rax, -128[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN6ResultIN2FB9DISKSPACEEN2FB7FSERROREEC1ERKS4_
	lea	rax, -128[rbp]
	mov	rcx, rax
	call	_ZN6ResultIN2FB9DISKSPACEEN2FB7FSERROREED1Ev
	nop
.L1983:
	mov	rax, QWORD PTR 16[rbp]
	add	rsp, 160
	pop	rbp
	ret
	.seh_endproc
	.def	_Z6FsFailIN2FB10VOLUMEINFOEENS0_11FSERRORCODEERK9FBUSTRINGS5_;	.scl	3;	.type	32;	.endef
	.seh_proc	_Z6FsFailIN2FB10VOLUMEINFOEENS0_11FSERRORCODEERK9FBUSTRINGS5_
_Z6FsFailIN2FB10VOLUMEINFOEENS0_11FSERRORCODEERK9FBUSTRINGS5_:
	push	rbp
	.seh_pushreg	rbp
	sub	rsp, 336
	.seh_stackalloc	336
	lea	rbp, 128[rsp]
	.seh_setframe	rbp, 128
	.seh_endprologue
	mov	QWORD PTR 224[rbp], rcx
	mov	QWORD PTR 232[rbp], rdx
	mov	QWORD PTR 240[rbp], r8
	mov	QWORD PTR 248[rbp], r9
.L1986:
	call	fb_FsOsError
	mov	DWORD PTR 204[rbp], eax
	mov	r9, QWORD PTR 240[rbp]
	mov	r8d, DWORD PTR 204[rbp]
	mov	rdx, QWORD PTR 232[rbp]
	lea	rax, -80[rbp]
	mov	rcx, QWORD PTR 248[rbp]
	mov	QWORD PTR 32[rsp], rcx
	mov	rcx, rax
	call	_ZN2FB7FSERRORC1ENS_11FSERRORCODEEiRK9FBUSTRINGS4_
	lea	rdx, -80[rbp]
	lea	rax, 16[rbp]
	mov	rcx, rax
	call	_Z4FailIN2FB10VOLUMEINFOEN2FB7FSERROREERS3_
	mov	QWORD PTR 192[rbp], rax
	mov	rax, QWORD PTR 192[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 224[rbp]
	call	_ZN6ResultIN2FB10VOLUMEINFOEN2FB7FSERROREEC1ERKS4_
	lea	rax, -80[rbp]
	mov	rcx, rax
	call	_ZN2FB7FSERRORD1Ev
	lea	rax, 16[rbp]
	mov	rcx, rax
	call	_ZN6ResultIN2FB10VOLUMEINFOEN2FB7FSERROREED1Ev
	nop
.L1987:
	mov	rax, QWORD PTR 224[rbp]
	add	rsp, 336
	pop	rbp
	ret
	.seh_endproc
	.def	_Z2OkIN2FB10VOLUMEINFOEN2FB7FSERROREERS1_;	.scl	3;	.type	32;	.endef
	.seh_proc	_Z2OkIN2FB10VOLUMEINFOEN2FB7FSERROREERS1_
_Z2OkIN2FB10VOLUMEINFOEN2FB7FSERROREERS1_:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 208
	.seh_stackalloc	208
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
.L1990:
	lea	rax, -176[rbp]
	mov	rcx, rax
	call	_ZN6ResultIN2FB10VOLUMEINFOEN2FB7FSERROREEC1Ev
	mov	rdx, QWORD PTR 24[rbp]
	lea	rax, -176[rbp]
	mov	rcx, rax
	call	_ZN2FB10VOLUMEINFOaSERKS0_
	lea	rax, -176[rbp]
	add	rax, 168
	mov	BYTE PTR [rax], 1
	lea	rax, -176[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN6ResultIN2FB10VOLUMEINFOEN2FB7FSERROREEC1ERKS4_
	lea	rax, -176[rbp]
	mov	rcx, rax
	call	_ZN6ResultIN2FB10VOLUMEINFOEN2FB7FSERROREED1Ev
	nop
.L1991:
	mov	rax, QWORD PTR 16[rbp]
	add	rsp, 208
	pop	rbp
	ret
	.seh_endproc
	.def	_Z4FailIN2FB9DISKSPACEEN2FB7FSERROREERS3_;	.scl	3;	.type	32;	.endef
	.seh_proc	_Z4FailIN2FB9DISKSPACEEN2FB7FSERROREERS3_
_Z4FailIN2FB9DISKSPACEEN2FB7FSERROREERS3_:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 160
	.seh_stackalloc	160
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
.L1994:
	lea	rax, -128[rbp]
	mov	rcx, rax
	call	_ZN6ResultIN2FB9DISKSPACEEN2FB7FSERROREEC1Ev
	lea	rax, -128[rbp]
	add	rax, 24
	mov	rdx, QWORD PTR 24[rbp]
	mov	rcx, rax
	call	_ZN2FB7FSERRORaSERKS0_
	lea	rax, -128[rbp]
	add	rax, 112
	mov	BYTE PTR [rax], 0
	lea	rax, -128[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN6ResultIN2FB9DISKSPACEEN2FB7FSERROREEC1ERKS4_
	lea	rax, -128[rbp]
	mov	rcx, rax
	call	_ZN6ResultIN2FB9DISKSPACEEN2FB7FSERROREED1Ev
	nop
.L1995:
	mov	rax, QWORD PTR 16[rbp]
	add	rsp, 160
	pop	rbp
	ret
	.seh_endproc
	.def	_Z4FailIN2FB10VOLUMEINFOEN2FB7FSERROREERS3_;	.scl	3;	.type	32;	.endef
	.seh_proc	_Z4FailIN2FB10VOLUMEINFOEN2FB7FSERROREERS3_
_Z4FailIN2FB10VOLUMEINFOEN2FB7FSERROREERS3_:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 208
	.seh_stackalloc	208
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
.L1998:
	lea	rax, -176[rbp]
	mov	rcx, rax
	call	_ZN6ResultIN2FB10VOLUMEINFOEN2FB7FSERROREEC1Ev
	lea	rax, -176[rbp]
	add	rax, 80
	mov	rdx, QWORD PTR 24[rbp]
	mov	rcx, rax
	call	_ZN2FB7FSERRORaSERKS0_
	lea	rax, -176[rbp]
	add	rax, 168
	mov	BYTE PTR [rax], 0
	lea	rax, -176[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN6ResultIN2FB10VOLUMEINFOEN2FB7FSERROREEC1ERKS4_
	lea	rax, -176[rbp]
	mov	rcx, rax
	call	_ZN6ResultIN2FB10VOLUMEINFOEN2FB7FSERROREED1Ev
	nop
.L1999:
	mov	rax, QWORD PTR 16[rbp]
	add	rsp, 208
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN13ArrayIteratorIN2FB8FSCHANGEEE7ISVALIDEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN13ArrayIteratorIN2FB8FSCHANGEEE7ISVALIDEv
_ZN13ArrayIteratorIN2FB8FSCHANGEEE7ISVALIDEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	BYTE PTR -9[rbp], 0
.L2002:
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	QWORD PTR -8[rbp], rax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR -8[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	edx, eax
	setl	al
	mov	BYTE PTR -9[rbp], al
	nop
.L2003:
	movzx	eax, BYTE PTR -9[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN13ArrayIteratorIN2FB8FSCHANGEEE5VALUEEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN13ArrayIteratorIN2FB8FSCHANGEEE5VALUEEv
_ZN13ArrayIteratorIN2FB8FSCHANGEEE5VALUEEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR -16[rbp], 0
.L2006:
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	QWORD PTR -8[rbp], rax
	mov	rax, QWORD PTR -8[rbp]
	mov	rax, QWORD PTR [rax]
	mov	rdx, QWORD PTR 16[rbp]
	add	rdx, 8
	mov	edx, DWORD PTR [rdx]
	movsx	rdx, edx
	sal	rdx, 5
	add	rax, rdx
	mov	QWORD PTR -16[rbp], rax
	nop
.L2007:
	mov	rax, QWORD PTR -16[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN13ArrayIteratorIN2FB8FSCHANGEEE8MOVENEXTEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN13ArrayIteratorIN2FB8FSCHANGEEE8MOVENEXTEv
_ZN13ArrayIteratorIN2FB8FSCHANGEEE8MOVENEXTEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
.L2010:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	add	edx, 1
	mov	DWORD PTR [rax], edx
	nop
	pop	rbp
	ret
.L2011:
	.seh_endproc
	.def	_ZN5ArrayIN2FB8FSCHANGEEE5COUNTEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN2FB8FSCHANGEEE5COUNTEv
_ZN5ArrayIN2FB8FSCHANGEEE5COUNTEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR -4[rbp], 0
.L2013:
	mov	rax, QWORD PTR 16[rbp]
	mov	eax, DWORD PTR 72[rax]
	mov	DWORD PTR -4[rbp], eax
	nop
.L2014:
	mov	eax, DWORD PTR -4[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN2FB8FSCHANGEEE8CAPACITYEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN2FB8FSCHANGEEE8CAPACITYEv
_ZN5ArrayIN2FB8FSCHANGEEE8CAPACITYEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 64
	.seh_stackalloc	64
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR -20[rbp], 0
.L2017:
	mov	edx, 1
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayUBound
	mov	QWORD PTR -8[rbp], rax
	mov	edx, 1
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayLBound
	mov	QWORD PTR -16[rbp], rax
	mov	rax, QWORD PTR -8[rbp]
	mov	edx, eax
	mov	rax, QWORD PTR -16[rbp]
	sub	edx, eax
	mov	eax, edx
	add	eax, 1
	mov	DWORD PTR -20[rbp], eax
	nop
.L2018:
	mov	eax, DWORD PTR -20[rbp]
	add	rsp, 64
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN2FB8FSCHANGEEE7ISEMPTYEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN2FB8FSCHANGEEE7ISEMPTYEv
_ZN5ArrayIN2FB8FSCHANGEEE7ISEMPTYEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	BYTE PTR -1[rbp], 0
.L2021:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	sete	al
	mov	BYTE PTR -1[rbp], al
	nop
.L2022:
	movzx	eax, BYTE PTR -1[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN2FB8FSCHANGEEE7RESERVEEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN2FB8FSCHANGEEE7RESERVEEi
_ZN5ArrayIN2FB8FSCHANGEEE7RESERVEEi:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 80
	.seh_stackalloc	80
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
.L2025:
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIN2FB8FSCHANGEEE8CAPACITYEv
	mov	DWORD PTR -8[rbp], eax
	mov	eax, DWORD PTR 24[rbp]
	cmp	eax, DWORD PTR -8[rbp]
	jle	.L2038
	nop
.L2027:
.L2029:
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIN2FB8FSCHANGEEE8CAPACITYEv
	mov	DWORD PTR -12[rbp], eax
	mov	eax, DWORD PTR -12[rbp]
	mov	DWORD PTR -4[rbp], eax
	cmp	DWORD PTR -4[rbp], 7
	jg	.L2039
	mov	DWORD PTR -4[rbp], 8
	jmp	.L2036
.L2031:
.L2032:
.L2039:
	nop
.L2033:
.L2036:
	mov	eax, DWORD PTR -4[rbp]
	cmp	eax, DWORD PTR 24[rbp]
	jge	.L2040
	mov	eax, DWORD PTR -4[rbp]
	cdqe
	add	rax, rax
	mov	DWORD PTR -4[rbp], eax
	jmp	.L2036
.L2040:
	nop
.L2035:
	mov	eax, DWORD PTR -4[rbp]
	cdqe
	sub	rax, 1
	mov	QWORD PTR 48[rsp], rax
	mov	QWORD PTR 40[rsp], 0
	mov	QWORD PTR 32[rsp], 1
	lea	r9, _ZN2FB8FSCHANGED1Ev[rip]
	lea	r8, _ZN2FB8FSCHANGEC1Ev[rip]
	mov	edx, 32
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayRedimPresvObj
	jmp	.L2041
.L2038:
	nop
.L2028:
.L2041:
	nop
	add	rsp, 80
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN2FB8FSCHANGEEE6SHRINKEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN2FB8FSCHANGEEE6SHRINKEv
_ZN5ArrayIN2FB8FSCHANGEEE6SHRINKEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 80
	.seh_stackalloc	80
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
.L2043:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	jne	.L2052
	lea	r8, _ZN2FB8FSCHANGED1Ev[rip]
	lea	rdx, _ZN2FB8FSCHANGEC1Ev[rip]
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayEraseObj
	jmp	.L2046
.L2045:
.L2052:
	nop
.L2047:
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIN2FB8FSCHANGEEE8CAPACITYEv
	mov	DWORD PTR -4[rbp], eax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR -4[rbp], eax
	je	.L2053
	nop
.L2049:
.L2050:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cdqe
	sub	rax, 1
	mov	QWORD PTR 48[rsp], rax
	mov	QWORD PTR 40[rsp], 0
	mov	QWORD PTR 32[rsp], 1
	lea	r9, _ZN2FB8FSCHANGED1Ev[rip]
	lea	r8, _ZN2FB8FSCHANGEC1Ev[rip]
	mov	edx, 32
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayRedimPresvObj
	jmp	.L2054
.L2053:
	nop
.L2046:
.L2054:
	nop
	add	rsp, 80
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN2FB8FSCHANGEEEixEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN2FB8FSCHANGEEEixEi
_ZN5ArrayIN2FB8FSCHANGEEEixEi:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
	mov	QWORD PTR -8[rbp], 0
.L2056:
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 24[rbp]
	movsx	rdx, edx
	sal	rdx, 5
	add	rax, rdx
	mov	QWORD PTR -8[rbp], rax
	nop
.L2057:
	mov	rax, QWORD PTR -8[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN2FB8FSCHANGEEE2ATEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN2FB8FSCHANGEEE2ATEi
_ZN5ArrayIN2FB8FSCHANGEEE2ATEi:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
	mov	QWORD PTR -8[rbp], 0
.L2060:
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 24[rbp]
	movsx	rdx, edx
	sal	rdx, 5
	add	rax, rdx
	mov	QWORD PTR -8[rbp], rax
	nop
.L2061:
	mov	rax, QWORD PTR -8[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN2FB8FSCHANGEEE4PUSHERS1_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN2FB8FSCHANGEEE4PUSHERS1_
_ZN5ArrayIN2FB8FSCHANGEEE4PUSHERS1_:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
.L2064:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	add	eax, 1
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIN2FB8FSCHANGEEE7RESERVEEi
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	rdx, QWORD PTR 16[rbp]
	add	rdx, 72
	mov	edx, DWORD PTR [rdx]
	movsx	rdx, edx
	sal	rdx, 5
	lea	rcx, [rax+rdx]
	mov	rax, QWORD PTR 24[rbp]
	mov	rdx, rax
	call	_ZN2FB8FSCHANGEaSERKS0_
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	add	edx, 1
	mov	DWORD PTR [rax], edx
	nop
	add	rsp, 32
	pop	rbp
	ret
.L2065:
	.seh_endproc
	.def	_ZN5ArrayIN2FB8FSCHANGEEE3POPEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN2FB8FSCHANGEEE3POPEv
_ZN5ArrayIN2FB8FSCHANGEEE3POPEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 64
	.seh_stackalloc	64
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
.L2067:
	lea	rax, -32[rbp]
	mov	rcx, rax
	call	_ZN2FB8FSCHANGEC1Ev
	mov	rax, QWORD PTR 24[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	jne	.L2074
	lea	rax, -32[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN2FB8FSCHANGEC1ERKS0_
	lea	rax, -32[rbp]
	mov	rcx, rax
	call	_ZN2FB8FSCHANGED1Ev
	jmp	.L2070
.L2069:
.L2074:
	nop
.L2071:
	mov	rax, QWORD PTR 24[rbp]
	add	rax, 72
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 24[rbp]
	add	rax, 72
	sub	edx, 1
	mov	DWORD PTR [rax], edx
	mov	rax, QWORD PTR 24[rbp]
	mov	rax, QWORD PTR [rax]
	mov	rdx, QWORD PTR 24[rbp]
	add	rdx, 72
	mov	edx, DWORD PTR [rdx]
	movsx	rdx, edx
	sal	rdx, 5
	add	rdx, rax
	lea	rax, -32[rbp]
	mov	rcx, rax
	call	_ZN2FB8FSCHANGEaSERKS0_
	lea	rax, -32[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN2FB8FSCHANGEC1ERKS0_
	lea	rax, -32[rbp]
	mov	rcx, rax
	call	_ZN2FB8FSCHANGED1Ev
	nop
.L2070:
	mov	rax, QWORD PTR 16[rbp]
	add	rsp, 64
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN2FB8FSCHANGEEE6INSERTEiRS1_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN2FB8FSCHANGEEE6INSERTEiRS1_
_ZN5ArrayIN2FB8FSCHANGEEE6INSERTEiRS1_:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 80
	.seh_stackalloc	80
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
	mov	QWORD PTR 32[rbp], r8
.L2076:
	cmp	DWORD PTR 24[rbp], 0
	js	.L2090
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR 24[rbp], eax
	setg	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -8[rbp], rax
	jmp	.L2079
.L2090:
	nop
.L2078:
	mov	QWORD PTR -8[rbp], -1
.L2079:
	cmp	QWORD PTR -8[rbp], 0
	jne	.L2091
	nop
.L2081:
.L2083:
	mov	rdx, QWORD PTR 32[rbp]
	lea	rax, -48[rbp]
	mov	rcx, rax
	call	_ZN2FB8FSCHANGEC1ERKS0_
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	add	eax, 1
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIN2FB8FSCHANGEEE7RESERVEEi
	mov	rax, QWORD PTR 16[rbp]
	mov	eax, DWORD PTR 72[rax]
	mov	DWORD PTR -12[rbp], eax
	mov	eax, DWORD PTR 24[rbp]
	add	eax, 1
	mov	DWORD PTR -16[rbp], eax
	jmp	.L2084
.L2092:
	nop
.L2085:
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR -12[rbp]
	movsx	rdx, edx
	sal	rdx, 5
	sub	rdx, 32
	add	rdx, rax
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	ecx, DWORD PTR -12[rbp]
	movsx	rcx, ecx
	sal	rcx, 5
	add	rax, rcx
	mov	rcx, rax
	call	_ZN2FB8FSCHANGEaSERKS0_
.L2086:
	sub	DWORD PTR -12[rbp], 1
.L2084:
	mov	eax, DWORD PTR -12[rbp]
	cmp	eax, DWORD PTR -16[rbp]
	jge	.L2092
	nop
.L2087:
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 24[rbp]
	movsx	rdx, edx
	sal	rdx, 5
	lea	rcx, [rax+rdx]
	lea	rax, -48[rbp]
	mov	rdx, rax
	call	_ZN2FB8FSCHANGEaSERKS0_
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	add	edx, 1
	mov	DWORD PTR [rax], edx
	lea	rax, -48[rbp]
	mov	rcx, rax
	call	_ZN2FB8FSCHANGED1Ev
	jmp	.L2093
.L2091:
	nop
.L2082:
.L2093:
	nop
	add	rsp, 80
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN2FB8FSCHANGEEE6REMOVEEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN2FB8FSCHANGEEE6REMOVEEi
_ZN5ArrayIN2FB8FSCHANGEEE6REMOVEEi:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 48
	.seh_stackalloc	48
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
.L2095:
	cmp	DWORD PTR 24[rbp], 0
	js	.L2109
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR 24[rbp], eax
	setge	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -8[rbp], rax
	jmp	.L2098
.L2109:
	nop
.L2097:
	mov	QWORD PTR -8[rbp], -1
.L2098:
	cmp	QWORD PTR -8[rbp], 0
	jne	.L2110
	nop
.L2100:
.L2102:
	mov	eax, DWORD PTR 24[rbp]
	mov	DWORD PTR -12[rbp], eax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	sub	eax, 2
	mov	DWORD PTR -16[rbp], eax
	jmp	.L2103
.L2111:
	nop
.L2104:
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR -12[rbp]
	movsx	rdx, edx
	sal	rdx, 5
	add	rdx, 32
	add	rdx, rax
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	ecx, DWORD PTR -12[rbp]
	movsx	rcx, ecx
	sal	rcx, 5
	add	rax, rcx
	mov	rcx, rax
	call	_ZN2FB8FSCHANGEaSERKS0_
.L2105:
	add	DWORD PTR -12[rbp], 1
.L2103:
	mov	eax, DWORD PTR -12[rbp]
	cmp	eax, DWORD PTR -16[rbp]
	jle	.L2111
	nop
.L2106:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	sub	edx, 1
	mov	DWORD PTR [rax], edx
	jmp	.L2112
.L2110:
	nop
.L2101:
.L2112:
	nop
	add	rsp, 48
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN2FB8FSCHANGEEE10REMOVESWAPEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN2FB8FSCHANGEEE10REMOVESWAPEi
_ZN5ArrayIN2FB8FSCHANGEEE10REMOVESWAPEi:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 48
	.seh_stackalloc	48
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
.L2114:
	cmp	DWORD PTR 24[rbp], 0
	js	.L2126
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR 24[rbp], eax
	setge	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -8[rbp], rax
	jmp	.L2117
.L2126:
	nop
.L2116:
	mov	QWORD PTR -8[rbp], -1
.L2117:
	cmp	QWORD PTR -8[rbp], 0
	jne	.L2127
	nop
.L2119:
.L2121:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	sub	edx, 1
	mov	DWORD PTR [rax], edx
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR 24[rbp], eax
	je	.L2128
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	rdx, QWORD PTR 16[rbp]
	add	rdx, 72
	mov	edx, DWORD PTR [rdx]
	movsx	rdx, edx
	sal	rdx, 5
	add	rdx, rax
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	ecx, DWORD PTR 24[rbp]
	movsx	rcx, ecx
	sal	rcx, 5
	add	rax, rcx
	mov	rcx, rax
	call	_ZN2FB8FSCHANGEaSERKS0_
	jmp	.L2129
.L2120:
.L2123:
.L2127:
	nop
	jmp	.L2129
.L2128:
	nop
.L2124:
.L2129:
	nop
	add	rsp, 48
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN2FB8FSCHANGEEE5CLEAREv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN2FB8FSCHANGEEE5CLEAREv
_ZN5ArrayIN2FB8FSCHANGEEE5CLEAREv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 80
	.seh_stackalloc	80
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
.L2131:
	lea	rax, -48[rbp]
	mov	rcx, rax
	call	_ZN2FB8FSCHANGEC1Ev
	mov	DWORD PTR -4[rbp], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	sub	eax, 1
	mov	DWORD PTR -8[rbp], eax
	jmp	.L2132
.L2138:
	nop
.L2133:
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR -4[rbp]
	movsx	rdx, edx
	sal	rdx, 5
	lea	rcx, [rax+rdx]
	lea	rax, -48[rbp]
	mov	rdx, rax
	call	_ZN2FB8FSCHANGEaSERKS0_
.L2134:
	add	DWORD PTR -4[rbp], 1
.L2132:
	mov	eax, DWORD PTR -4[rbp]
	cmp	eax, DWORD PTR -8[rbp]
	jle	.L2138
	nop
.L2135:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	DWORD PTR [rax], 0
	lea	rax, -48[rbp]
	mov	rcx, rax
	call	_ZN2FB8FSCHANGED1Ev
	nop
	add	rsp, 80
	pop	rbp
	ret
.L2136:
	.seh_endproc
	.def	_ZN5ArrayIN2FB8FSCHANGEEE11GETITERATOREv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN2FB8FSCHANGEEE11GETITERATOREv
_ZN5ArrayIN2FB8FSCHANGEEE11GETITERATOREv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
	lea	rax, -16[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
.L2140:
	lea	rax, -32[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	lea	rax, -32[rbp]
	mov	rdx, QWORD PTR 24[rbp]
	mov	QWORD PTR [rax], rdx
	lea	rax, -32[rbp]
	add	rax, 8
	mov	DWORD PTR [rax], 0
	mov	rax, QWORD PTR -32[rbp]
	mov	rdx, QWORD PTR -24[rbp]
	mov	QWORD PTR -16[rbp], rax
	mov	QWORD PTR -8[rbp], rdx
	nop
.L2141:
	mov	rcx, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR -16[rbp]
	mov	rdx, QWORD PTR -8[rbp]
	mov	QWORD PTR [rcx], rax
	mov	QWORD PTR 8[rcx], rdx
	mov	rax, QWORD PTR 16[rbp]
	add	rsp, 32
	pop	rbp
	ret
	.seh_endproc
	.globl	_ZN3TKO9MAKERANGEEjj
	.def	_ZN3TKO9MAKERANGEEjj;	.scl	2;	.type	32;	.endef
	.seh_proc	_ZN3TKO9MAKERANGEEjj
_ZN3TKO9MAKERANGEEjj:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	DWORD PTR 16[rbp], ecx
	mov	DWORD PTR 24[rbp], edx
	lea	rax, -8[rbp]
	mov	QWORD PTR [rax], 0
.L2144:
	lea	rax, -16[rbp]
	mov	QWORD PTR [rax], 0
	lea	rax, -16[rbp]
	mov	edx, DWORD PTR 16[rbp]
	mov	DWORD PTR [rax], edx
	lea	rax, -16[rbp]
	add	rax, 4
	mov	edx, DWORD PTR 24[rbp]
	mov	DWORD PTR [rax], edx
	mov	rax, QWORD PTR -16[rbp]
	mov	QWORD PTR -8[rbp], rax
	nop
.L2145:
	mov	rax, QWORD PTR -8[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.globl	_ZN3TKO10POINTRANGEEj
	.def	_ZN3TKO10POINTRANGEEj;	.scl	2;	.type	32;	.endef
	.seh_proc	_ZN3TKO10POINTRANGEEj
_ZN3TKO10POINTRANGEEj:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 48
	.seh_stackalloc	48
	.seh_endprologue
	mov	DWORD PTR 16[rbp], ecx
	lea	rax, -8[rbp]
	mov	QWORD PTR [rax], 0
.L2148:
	mov	edx, DWORD PTR 16[rbp]
	mov	ecx, DWORD PTR 16[rbp]
	call	_ZN3TKO9MAKERANGEEjj
	mov	QWORD PTR -16[rbp], rax
	mov	rax, QWORD PTR -16[rbp]
	mov	QWORD PTR -8[rbp], rax
	nop
.L2149:
	mov	rax, QWORD PTR -8[rbp]
	add	rsp, 48
	pop	rbp
	ret
	.seh_endproc
	.globl	_ZN3TKO13SOURCEMANAGERC1Ev
	.def	_ZN3TKO13SOURCEMANAGERC1Ev;	.scl	2;	.type	32;	.endef
	.seh_proc	_ZN3TKO13SOURCEMANAGERC1Ev
_ZN3TKO13SOURCEMANAGERC1Ev:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
.L2152:
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIPN3TKO10SOURCEFILEEEC1Ev
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 80
	mov	DWORD PTR [rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 88
	mov	QWORD PTR [rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 88
	mov	QWORD PTR [rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 80
	mov	DWORD PTR [rax], 1
	nop
	add	rsp, 32
	pop	rbp
	ret
.L2153:
	.seh_endproc
	.globl	_ZN3TKO13SOURCEMANAGER6ATTACHEPNS_8INTERNERE
	.def	_ZN3TKO13SOURCEMANAGER6ATTACHEPNS_8INTERNERE;	.scl	2;	.type	32;	.endef
	.seh_proc	_ZN3TKO13SOURCEMANAGER6ATTACHEPNS_8INTERNERE
_ZN3TKO13SOURCEMANAGER6ATTACHEPNS_8INTERNERE:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
.L2155:
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 88[rax]
	mov	rax, QWORD PTR 24[rbp]
	mov	QWORD PTR [rdx], rax
	nop
	pop	rbp
	ret
.L2156:
	.seh_endproc
	.globl	_ZN3TKO13SOURCEMANAGERD1Ev
	.def	_ZN3TKO13SOURCEMANAGERD1Ev;	.scl	2;	.type	32;	.endef
	.seh_proc	_ZN3TKO13SOURCEMANAGERD1Ev
_ZN3TKO13SOURCEMANAGERD1Ev:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 96
	.seh_stackalloc	96
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
.L2158:
	lea	rax, -64[rbp]
	mov	rdx, QWORD PTR 16[rbp]
	mov	rcx, rax
	call	_ZN5ArrayIPN3TKO10SOURCEFILEEE11GETITERATOREv
	mov	rax, QWORD PTR -64[rbp]
	mov	rdx, QWORD PTR -56[rbp]
	mov	QWORD PTR -48[rbp], rax
	mov	QWORD PTR -40[rbp], rdx
	jmp	.L2159
.L2168:
	nop
.L2160:
	lea	rax, -48[rbp]
	mov	rcx, rax
	call	_ZN13ArrayIteratorIPN3TKO10SOURCEFILEEE5VALUEEv
	mov	QWORD PTR -16[rbp], rax
	mov	rax, QWORD PTR -16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	QWORD PTR -24[rbp], rax
	cmp	QWORD PTR -24[rbp], 0
	je	.L2167
	mov	rax, QWORD PTR -24[rbp]
	mov	rcx, rax
	call	_ZN3TKO10SOURCEFILED1Ev
	mov	rax, QWORD PTR -24[rbp]
	mov	rcx, rax
	call	free
	jmp	.L2163
.L2162:
.L2167:
	nop
.L2163:
	lea	rax, -48[rbp]
	mov	rcx, rax
	call	_ZN13ArrayIteratorIPN3TKO10SOURCEFILEEE8MOVENEXTEv
.L2159:
	lea	rax, -48[rbp]
	mov	rcx, rax
	call	_ZN13ArrayIteratorIPN3TKO10SOURCEFILEEE7ISVALIDEv
	mov	BYTE PTR -1[rbp], al
	movsx	eax, BYTE PTR -1[rbp]
	neg	eax
	test	eax, eax
	jne	.L2168
	nop
.L2164:
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIPN3TKO10SOURCEFILEEE5CLEAREv
.L2165:
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIPN3TKO10SOURCEFILEEED1Ev
	nop
	add	rsp, 96
	pop	rbp
	ret
	.seh_endproc
	.globl	_ZN3TKO13SOURCEMANAGER5COUNTEv
	.def	_ZN3TKO13SOURCEMANAGER5COUNTEv;	.scl	2;	.type	32;	.endef
	.seh_proc	_ZN3TKO13SOURCEMANAGER5COUNTEv
_ZN3TKO13SOURCEMANAGER5COUNTEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 48
	.seh_stackalloc	48
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR -8[rbp], 0
.L2170:
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIPN3TKO10SOURCEFILEEE5COUNTEv
	mov	DWORD PTR -4[rbp], eax
	mov	eax, DWORD PTR -4[rbp]
	mov	DWORD PTR -8[rbp], eax
	nop
.L2171:
	mov	eax, DWORD PTR -8[rbp]
	add	rsp, 48
	pop	rbp
	ret
	.seh_endproc
	.globl	_ZN3TKO13SOURCEMANAGER6FILEATEj
	.def	_ZN3TKO13SOURCEMANAGER6FILEATEj;	.scl	2;	.type	32;	.endef
	.seh_proc	_ZN3TKO13SOURCEMANAGER6FILEATEj
_ZN3TKO13SOURCEMANAGER6FILEATEj:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 64
	.seh_stackalloc	64
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
	mov	QWORD PTR -24[rbp], 0
.L2174:
	cmp	DWORD PTR 24[rbp], 0
	jne	.L2183
	mov	QWORD PTR -24[rbp], 0
	jmp	.L2177
.L2183:
	nop
.L2176:
	mov	eax, DWORD PTR 24[rbp]
	sub	eax, 1
	mov	DWORD PTR -4[rbp], eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIPN3TKO10SOURCEFILEEE5COUNTEv
	mov	DWORD PTR -8[rbp], eax
	mov	eax, DWORD PTR -4[rbp]
	cmp	eax, DWORD PTR -8[rbp]
	jl	.L2184
	mov	QWORD PTR -24[rbp], 0
	jmp	.L2177
.L2184:
	nop
.L2179:
	mov	eax, DWORD PTR -4[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIPN3TKO10SOURCEFILEEEixEi
	mov	QWORD PTR -16[rbp], rax
	mov	rax, QWORD PTR -16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	QWORD PTR -24[rbp], rax
	nop
.L2177:
	mov	rax, QWORD PTR -24[rbp]
	add	rsp, 64
	pop	rbp
	ret
	.seh_endproc
	.section .rdata,"dr"
.LC1:
	.ascii "<builtin>\0"
	.text
	.globl	_ZN3TKO13SOURCEMANAGER9ISBUILTINEj
	.def	_ZN3TKO13SOURCEMANAGER9ISBUILTINEj;	.scl	2;	.type	32;	.endef
	.seh_proc	_ZN3TKO13SOURCEMANAGER9ISBUILTINEj
_ZN3TKO13SOURCEMANAGER9ISBUILTINEj:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 112
	.seh_stackalloc	112
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
	mov	BYTE PTR -13[rbp], 0
.L2186:
	cmp	DWORD PTR 24[rbp], 0
	jne	.L2192
	mov	BYTE PTR -13[rbp], 0
	jmp	.L2189
.L2192:
	nop
.L2188:
	lea	rax, -80[rbp]
	mov	edx, DWORD PTR 24[rbp]
	mov	r8d, edx
	mov	rdx, QWORD PTR 16[rbp]
	mov	rcx, rax
	call	_ZN3TKO13SOURCEMANAGER6DECODEEj
	mov	rax, QWORD PTR -80[rbp]
	mov	rdx, QWORD PTR -72[rbp]
	mov	QWORD PTR -48[rbp], rax
	mov	QWORD PTR -40[rbp], rdx
	mov	rax, QWORD PTR -64[rbp]
	mov	QWORD PTR -32[rbp], rax
	lea	rax, -48[rbp]
	mov	eax, DWORD PTR [rax]
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN3TKO13SOURCEMANAGER6PATHOFEj
	mov	QWORD PTR -8[rbp], rax
	mov	rax, QWORD PTR -8[rbp]
	mov	r9d, 10
	lea	r8, .LC1[rip]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrCompare
	mov	DWORD PTR -12[rbp], eax
	cmp	DWORD PTR -12[rbp], 0
	sete	al
	mov	BYTE PTR -13[rbp], al
	nop
.L2189:
	movzx	eax, BYTE PTR -13[rbp]
	add	rsp, 112
	pop	rbp
	ret
	.seh_endproc
	.section .rdata,"dr"
.LC2:
	.ascii "<none>\0"
	.text
	.globl	_ZN3TKO13SOURCEMANAGER6PATHOFEj
	.def	_ZN3TKO13SOURCEMANAGER6PATHOFEj;	.scl	2;	.type	32;	.endef
	.seh_proc	_ZN3TKO13SOURCEMANAGER6PATHOFEj
_ZN3TKO13SOURCEMANAGER6PATHOFEj:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 112
	.seh_stackalloc	112
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
	lea	rax, -64[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
.L2194:
	mov	eax, DWORD PTR 24[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN3TKO13SOURCEMANAGER6FILEATEj
	mov	QWORD PTR -8[rbp], rax
	mov	rax, QWORD PTR -8[rbp]
	mov	QWORD PTR -16[rbp], rax
	cmp	QWORD PTR -16[rbp], 0
	jne	.L2200
	lea	rax, -64[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9d, 7
	lea	r8, .LC2[rip]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrInit
	jmp	.L2197
.L2200:
	nop
.L2196:
	mov	rax, QWORD PTR -16[rbp]
	add	rax, 4
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 88
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN3TKO8INTERNER8SPELLINGEj
	mov	QWORD PTR -24[rbp], rax
	mov	rdx, QWORD PTR -24[rbp]
	lea	rax, -64[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrInit
	nop
.L2197:
	lea	rax, -64[rbp]
	mov	rcx, rax
	call	fb_StrAllocTempResult
	mov	QWORD PTR -32[rbp], rax
	mov	rax, QWORD PTR -32[rbp]
	add	rsp, 112
	pop	rbp
	ret
	.seh_endproc
	.globl	_ZN3TKO13SOURCEMANAGER10TOTALBYTESEv
	.def	_ZN3TKO13SOURCEMANAGER10TOTALBYTESEv;	.scl	2;	.type	32;	.endef
	.seh_proc	_ZN3TKO13SOURCEMANAGER10TOTALBYTESEv
_ZN3TKO13SOURCEMANAGER10TOTALBYTESEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 112
	.seh_stackalloc	112
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR -48[rbp], 0
.L2202:
	mov	QWORD PTR -8[rbp], 0
	lea	rax, -80[rbp]
	mov	rdx, QWORD PTR 16[rbp]
	mov	rcx, rax
	call	_ZN5ArrayIPN3TKO10SOURCEFILEEE11GETITERATOREv
	mov	rax, QWORD PTR -80[rbp]
	mov	rdx, QWORD PTR -72[rbp]
	mov	QWORD PTR -64[rbp], rax
	mov	QWORD PTR -56[rbp], rdx
	jmp	.L2203
.L2210:
	nop
.L2204:
	lea	rax, -64[rbp]
	mov	rcx, rax
	call	_ZN13ArrayIteratorIPN3TKO10SOURCEFILEEE5VALUEEv
	mov	QWORD PTR -24[rbp], rax
	mov	rax, QWORD PTR -24[rbp]
	mov	rax, QWORD PTR [rax]
	mov	QWORD PTR -32[rbp], rax
	mov	rax, QWORD PTR -32[rbp]
	add	rax, 8
	mov	rcx, rax
	call	_ZN5ArrayIhE5COUNTEv
	mov	DWORD PTR -36[rbp], eax
	mov	eax, DWORD PTR -36[rbp]
	cdqe
	add	QWORD PTR -8[rbp], rax
.L2205:
	lea	rax, -64[rbp]
	mov	rcx, rax
	call	_ZN13ArrayIteratorIPN3TKO10SOURCEFILEEE8MOVENEXTEv
.L2203:
	lea	rax, -64[rbp]
	mov	rcx, rax
	call	_ZN13ArrayIteratorIPN3TKO10SOURCEFILEEE7ISVALIDEv
	mov	BYTE PTR -9[rbp], al
	movsx	eax, BYTE PTR -9[rbp]
	neg	eax
	test	eax, eax
	jne	.L2210
	nop
.L2206:
	mov	rax, QWORD PTR -8[rbp]
	mov	QWORD PTR -48[rbp], rax
	nop
.L2207:
	mov	rax, QWORD PTR -48[rbp]
	add	rsp, 112
	pop	rbp
	ret
	.seh_endproc
	.globl	_ZN3TKO13SOURCEMANAGER4FINDER9FBUSTRING
	.def	_ZN3TKO13SOURCEMANAGER4FINDER9FBUSTRING;	.scl	2;	.type	32;	.endef
	.seh_proc	_ZN3TKO13SOURCEMANAGER4FINDER9FBUSTRING
_ZN3TKO13SOURCEMANAGER4FINDER9FBUSTRING:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 176
	.seh_stackalloc	176
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
	mov	DWORD PTR -116[rbp], 0
.L2212:
	lea	rax, -112[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	lea	rax, -80[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	rdx, QWORD PTR 24[rbp]
	lea	rax, -80[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrAssign
	lea	rax, -80[rbp]
	mov	rcx, rax
	call	_ZN3TKO4TEXT13USTRINGTOUTF8E9FBUSTRING
	mov	QWORD PTR -16[rbp], rax
	mov	rdx, QWORD PTR -16[rbp]
	lea	rax, -112[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrAssign
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 88
	mov	rax, QWORD PTR [rax]
	lea	rdx, -112[rbp]
	mov	rcx, rax
	call	_ZN3TKO8INTERNER9GETSTRINGE8FBSTRING
	mov	DWORD PTR -20[rbp], eax
	mov	eax, DWORD PTR -20[rbp]
	mov	DWORD PTR -24[rbp], eax
	lea	rax, -112[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	lea	rax, -80[rbp]
	mov	rcx, rax
	call	fb_UStrDelete
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIPN3TKO10SOURCEFILEEE5COUNTEv
	mov	DWORD PTR -28[rbp], eax
	mov	eax, DWORD PTR -28[rbp]
	mov	DWORD PTR -32[rbp], eax
	mov	DWORD PTR -4[rbp], 0
	mov	eax, DWORD PTR -32[rbp]
	sub	eax, 1
	mov	DWORD PTR -36[rbp], eax
	jmp	.L2213
.L2224:
	nop
.L2214:
	mov	eax, DWORD PTR -4[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIPN3TKO10SOURCEFILEEEixEi
	mov	QWORD PTR -48[rbp], rax
	mov	rax, QWORD PTR -48[rbp]
	mov	rax, QWORD PTR [rax]
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR -24[rbp], eax
	jne	.L2223
	mov	eax, DWORD PTR -4[rbp]
	add	eax, 1
	mov	DWORD PTR -116[rbp], eax
	jmp	.L2217
.L2216:
.L2223:
	nop
.L2218:
	add	DWORD PTR -4[rbp], 1
.L2213:
	mov	eax, DWORD PTR -4[rbp]
	cmp	eax, DWORD PTR -36[rbp]
	jle	.L2224
	nop
.L2219:
	mov	DWORD PTR -116[rbp], 0
	nop
.L2217:
	mov	eax, DWORD PTR -116[rbp]
	add	rsp, 176
	pop	rbp
	ret
	.seh_endproc
	.globl	_ZN3TKO13SOURCEMANAGER5ADOPTER9FBUSTRINGS2_R5ArrayIhEb
	.def	_ZN3TKO13SOURCEMANAGER5ADOPTER9FBUSTRINGS2_R5ArrayIhEb;	.scl	2;	.type	32;	.endef
	.seh_proc	_ZN3TKO13SOURCEMANAGER5ADOPTER9FBUSTRINGS2_R5ArrayIhEb
_ZN3TKO13SOURCEMANAGER5ADOPTER9FBUSTRINGS2_R5ArrayIhEb:
	push	rbp
	.seh_pushreg	rbp
	sub	rsp, 320
	.seh_stackalloc	320
	lea	rbp, 128[rsp]
	.seh_setframe	rbp, 128
	.seh_endprologue
	mov	QWORD PTR 208[rbp], rcx
	mov	QWORD PTR 216[rbp], rdx
	mov	QWORD PTR 224[rbp], r8
	mov	QWORD PTR 232[rbp], r9
	mov	eax, DWORD PTR 240[rbp]
	mov	BYTE PTR -68[rbp], al
	mov	DWORD PTR -52[rbp], 0
.L2226:
	mov	edx, 1
	mov	ecx, 272
	call	calloc
	mov	QWORD PTR 176[rbp], rax
	mov	rax, QWORD PTR 176[rbp]
	mov	QWORD PTR 168[rbp], rax
	cmp	QWORD PTR 168[rbp], 0
	je	.L2240
	mov	rax, QWORD PTR 168[rbp]
	mov	rcx, rax
	call	_ZN3TKO10SOURCEFILEC1Ev
	jmp	.L2228
.L2240:
	nop
.L2228:
	mov	rax, QWORD PTR 168[rbp]
	mov	QWORD PTR -64[rbp], rax
	lea	rax, 16[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	lea	rax, 48[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	rdx, QWORD PTR 216[rbp]
	lea	rax, 48[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrAssign
	lea	rax, 48[rbp]
	mov	rcx, rax
	call	_ZN3TKO4TEXT13USTRINGTOUTF8E9FBUSTRING
	mov	QWORD PTR 160[rbp], rax
	mov	rdx, QWORD PTR 160[rbp]
	lea	rax, 16[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrAssign
	mov	rax, QWORD PTR 208[rbp]
	add	rax, 88
	mov	rax, QWORD PTR [rax]
	lea	rdx, 16[rbp]
	mov	rcx, rax
	call	_ZN3TKO8INTERNER9GETSTRINGE8FBSTRING
	mov	DWORD PTR 156[rbp], eax
	mov	rax, QWORD PTR -64[rbp]
	mov	edx, DWORD PTR 156[rbp]
	mov	DWORD PTR [rax], edx
	lea	rax, 16[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	lea	rax, 48[rbp]
	mov	rcx, rax
	call	fb_UStrDelete
	lea	rax, -48[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	lea	rax, -16[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	rdx, QWORD PTR 224[rbp]
	lea	rax, -16[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrAssign
	lea	rax, -16[rbp]
	mov	rcx, rax
	call	_ZN3TKO4TEXT13USTRINGTOUTF8E9FBUSTRING
	mov	QWORD PTR 144[rbp], rax
	mov	rdx, QWORD PTR 144[rbp]
	lea	rax, -48[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrAssign
	mov	rax, QWORD PTR 208[rbp]
	add	rax, 88
	mov	rax, QWORD PTR [rax]
	lea	rdx, -48[rbp]
	mov	rcx, rax
	call	_ZN3TKO8INTERNER9GETSTRINGE8FBSTRING
	mov	DWORD PTR 140[rbp], eax
	mov	rax, QWORD PTR -64[rbp]
	lea	rdx, 4[rax]
	mov	eax, DWORD PTR 140[rbp]
	mov	DWORD PTR [rdx], eax
	lea	rax, -48[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	lea	rax, -16[rbp]
	mov	rcx, rax
	call	fb_UStrDelete
	mov	rax, QWORD PTR -64[rbp]
	lea	rdx, 184[rax]
	movzx	eax, BYTE PTR -68[rbp]
	mov	BYTE PTR [rdx], al
	mov	rax, QWORD PTR 232[rbp]
	mov	rcx, rax
	call	_ZN5ArrayIhE5COUNTEv
	mov	DWORD PTR 136[rbp], eax
	mov	eax, DWORD PTR 136[rbp]
	mov	DWORD PTR 132[rbp], eax
	mov	QWORD PTR 184[rbp], 0
	cmp	DWORD PTR 132[rbp], 0
	jle	.L2241
	mov	rax, QWORD PTR 232[rbp]
	mov	edx, 0
	mov	rcx, rax
	call	_ZN5ArrayIhEixEi
	mov	QWORD PTR 120[rbp], rax
	mov	rax, QWORD PTR 120[rbp]
	mov	QWORD PTR 184[rbp], rax
	jmp	.L2230
.L2241:
	nop
.L2230:
	mov	edx, DWORD PTR 132[rbp]
	mov	rax, QWORD PTR 184[rbp]
	mov	rcx, rax
	call	_ZN3TKO4TEXT14DETECTENCODINGEPKhi
	mov	QWORD PTR 112[rbp], rax
	mov	rax, QWORD PTR -64[rbp]
	lea	rdx, 168[rax]
	mov	rax, QWORD PTR 112[rbp]
	mov	QWORD PTR [rdx], rax
	mov	rax, QWORD PTR -64[rbp]
	add	rax, 188
	mov	DWORD PTR [rax], -1
	mov	rax, QWORD PTR -64[rbp]
	add	rax, 168
	mov	rax, QWORD PTR [rax]
	cmp	rax, 6
	jne	.L2242
	mov	edx, DWORD PTR 132[rbp]
	mov	rax, QWORD PTR 184[rbp]
	mov	rcx, rax
	call	_ZN3TKO4TEXT16FIRSTINVALIDUTF8EPKhi
	mov	DWORD PTR 108[rbp], eax
	mov	rax, QWORD PTR -64[rbp]
	lea	rdx, 188[rax]
	mov	eax, DWORD PTR 108[rbp]
	mov	DWORD PTR [rdx], eax
	jmp	.L2233
.L2232:
.L2242:
	nop
.L2233:
	mov	rax, QWORD PTR -64[rbp]
	add	rax, 168
	mov	rcx, QWORD PTR [rax]
	mov	rax, QWORD PTR -64[rbp]
	lea	rdx, 8[rax]
	mov	rax, QWORD PTR 232[rbp]
	mov	r8, rcx
	mov	rcx, rax
	call	_ZN3TKO4TEXT15NORMALIZETOUTF8ER5ArrayIhES3_NS0_8ENCODINGE
	mov	rax, QWORD PTR -64[rbp]
	add	rax, 8
	mov	rcx, rax
	call	_ZN5ArrayIhE5COUNTEv
	mov	DWORD PTR 104[rbp], eax
	mov	eax, DWORD PTR 104[rbp]
	mov	DWORD PTR 100[rbp], eax
	cmp	DWORD PTR 100[rbp], 0
	jle	.L2243
	mov	rax, QWORD PTR -64[rbp]
	add	rax, 8
	mov	edx, 0
	mov	rcx, rax
	call	_ZN5ArrayIhEixEi
	mov	QWORD PTR 88[rbp], rax
	mov	edx, DWORD PTR 100[rbp]
	mov	rax, QWORD PTR 88[rbp]
	mov	rcx, rax
	call	_ZN3TKO9HASHBYTESEPKhi
	mov	DWORD PTR 84[rbp], eax
	mov	rax, QWORD PTR -64[rbp]
	lea	rdx, 180[rax]
	mov	eax, DWORD PTR 84[rbp]
	mov	DWORD PTR [rdx], eax
	jmp	.L2236
.L2243:
	nop
.L2235:
	mov	rax, QWORD PTR -64[rbp]
	add	rax, 180
	mov	DWORD PTR [rax], 0
.L2236:
	mov	rax, QWORD PTR -64[rbp]
	mov	rcx, rax
	call	_ZN3TKO14BUILDLINEINDEXEPNS_10SOURCEFILEE
	mov	rax, QWORD PTR -64[rbp]
	lea	rdx, 176[rax]
	mov	rax, QWORD PTR 208[rbp]
	mov	eax, DWORD PTR 80[rax]
	mov	DWORD PTR [rdx], eax
	mov	rax, QWORD PTR 208[rbp]
	add	rax, 80
	mov	edx, DWORD PTR [rax]
	mov	eax, DWORD PTR 100[rbp]
	add	edx, eax
	mov	rax, QWORD PTR 208[rbp]
	add	rax, 80
	add	edx, 1
	mov	DWORD PTR [rax], edx
	lea	rax, -64[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 208[rbp]
	call	_ZN5ArrayIPN3TKO10SOURCEFILEEE4PUSHERS2_
	mov	rcx, QWORD PTR 208[rbp]
	call	_ZN5ArrayIPN3TKO10SOURCEFILEEE5COUNTEv
	mov	DWORD PTR 80[rbp], eax
	mov	eax, DWORD PTR 80[rbp]
	mov	DWORD PTR -52[rbp], eax
	nop
.L2237:
	mov	eax, DWORD PTR -52[rbp]
	add	rsp, 320
	pop	rbp
	ret
	.seh_endproc
	.globl	_ZN3TKO13SOURCEMANAGER8LOADFILEER9FBUSTRINGS2_
	.def	_ZN3TKO13SOURCEMANAGER8LOADFILEER9FBUSTRINGS2_;	.scl	2;	.type	32;	.endef
	.seh_proc	_ZN3TKO13SOURCEMANAGER8LOADFILEER9FBUSTRINGS2_
_ZN3TKO13SOURCEMANAGER8LOADFILEER9FBUSTRINGS2_:
	push	rbp
	.seh_pushreg	rbp
	sub	rsp, 464
	.seh_stackalloc	464
	lea	rbp, 128[rsp]
	.seh_setframe	rbp, 128
	.seh_endprologue
	mov	QWORD PTR 352[rbp], rcx
	mov	QWORD PTR 360[rbp], rdx
	mov	QWORD PTR 368[rbp], r8
	mov	DWORD PTR 272[rbp], 0
.L2245:
	mov	WORD PTR 270[rbp], 0
	lea	rdx, 270[rbp]
	mov	rax, QWORD PTR 368[rbp]
	mov	DWORD PTR 32[rsp], 0
	movabs	r9, -9223372036854775808
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrAssign
	mov	rdx, QWORD PTR 360[rbp]
	lea	rax, 144[rbp]
	mov	rcx, rax
	call	_ZN2FB12ABSOLUTEPATHERK9FBUSTRING
	mov	rdx, QWORD PTR 360[rbp]
	lea	rax, 112[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrInit
	lea	rax, 144[rbp]
	mov	rcx, rax
	call	_ZN6ResultI9FBUSTRINGN2FB7FSERROREE4ISOKEv
	mov	BYTE PTR 335[rbp], al
	cmp	BYTE PTR 335[rbp], 0
	je	.L2257
	lea	rax, 144[rbp]
	mov	rcx, rax
	call	_ZN6ResultI9FBUSTRINGN2FB7FSERROREE5VALUEEv
	mov	QWORD PTR 320[rbp], rax
	mov	rax, QWORD PTR 320[rbp]
	mov	edx, 1
	mov	rcx, rax
	call	fb_UStrPathNormalize
	mov	QWORD PTR 312[rbp], rax
	mov	rdx, QWORD PTR 312[rbp]
	lea	rax, 112[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrAssign
	jmp	.L2247
.L2257:
	nop
.L2247:
	lea	rax, 112[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 352[rbp]
	call	_ZN3TKO13SOURCEMANAGER4FINDER9FBUSTRING
	mov	DWORD PTR 308[rbp], eax
	mov	eax, DWORD PTR 308[rbp]
	mov	DWORD PTR 304[rbp], eax
	cmp	DWORD PTR 304[rbp], 0
	je	.L2258
	mov	eax, DWORD PTR 304[rbp]
	mov	DWORD PTR 272[rbp], eax
	lea	rax, 112[rbp]
	mov	rcx, rax
	call	fb_UStrDelete
	lea	rax, 144[rbp]
	mov	rcx, rax
	call	_ZN6ResultI9FBUSTRINGN2FB7FSERROREED1Ev
	jmp	.L2250
.L2258:
	nop
.L2249:
	lea	rax, 32[rbp]
	mov	rcx, rax
	call	_ZN5ArrayIhEC1Ev
	lea	rcx, 32[rbp]
	lea	rdx, 112[rbp]
	lea	rax, -80[rbp]
	mov	r8, rcx
	mov	rcx, rax
	call	_ZN2FB12READALLBYTESERK9FBUSTRINGR5ArrayIhE
	lea	rax, -80[rbp]
	mov	rcx, rax
	call	_ZN6ResultIxN2FB7FSERROREE4ISOKEv
	mov	BYTE PTR 303[rbp], al
	cmp	BYTE PTR 303[rbp], 0
	jne	.L2259
	lea	rax, -80[rbp]
	mov	rcx, rax
	call	_ZN6ResultIxN2FB7FSERROREE7FAILUREEv
	mov	QWORD PTR 288[rbp], rax
	mov	rax, QWORD PTR 288[rbp]
	mov	rcx, rax
	call	_ZNK2FB7FSERROR7MESSAGEEv
	mov	QWORD PTR 280[rbp], rax
	mov	rdx, QWORD PTR 280[rbp]
	mov	rax, QWORD PTR 368[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrAssign
	mov	DWORD PTR 272[rbp], 0
	lea	rax, -80[rbp]
	mov	rcx, rax
	call	_ZN6ResultIxN2FB7FSERROREED1Ev
	lea	rax, 32[rbp]
	mov	rcx, rax
	call	_ZN5ArrayIhED1Ev
	lea	rax, 112[rbp]
	mov	rcx, rax
	call	fb_UStrDelete
	lea	rax, 144[rbp]
	mov	rcx, rax
	call	_ZN6ResultI9FBUSTRINGN2FB7FSERROREED1Ev
	jmp	.L2250
.L2252:
.L2259:
	nop
.L2253:
	lea	rcx, 32[rbp]
	mov	rdx, QWORD PTR 360[rbp]
	lea	rax, 112[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, rcx
	mov	r8, rdx
	mov	rdx, rax
	mov	rcx, QWORD PTR 352[rbp]
	call	_ZN3TKO13SOURCEMANAGER5ADOPTER9FBUSTRINGS2_R5ArrayIhEb
	mov	DWORD PTR 276[rbp], eax
	mov	eax, DWORD PTR 276[rbp]
	mov	DWORD PTR 272[rbp], eax
	lea	rax, -80[rbp]
	mov	rcx, rax
	call	_ZN6ResultIxN2FB7FSERROREED1Ev
	lea	rax, 32[rbp]
	mov	rcx, rax
	call	_ZN5ArrayIhED1Ev
	lea	rax, 112[rbp]
	mov	rcx, rax
	call	fb_UStrDelete
	lea	rax, 144[rbp]
	mov	rcx, rax
	call	_ZN6ResultI9FBUSTRINGN2FB7FSERROREED1Ev
	nop
.L2250:
	mov	eax, DWORD PTR 272[rbp]
	add	rsp, 464
	pop	rbp
	ret
	.seh_endproc
	.globl	_ZN3TKO13SOURCEMANAGER10ADDVIRTUALER9FBUSTRINGR8FBSTRING
	.def	_ZN3TKO13SOURCEMANAGER10ADDVIRTUALER9FBUSTRINGR8FBSTRING;	.scl	2;	.type	32;	.endef
	.seh_proc	_ZN3TKO13SOURCEMANAGER10ADDVIRTUALER9FBUSTRINGR8FBSTRING
_ZN3TKO13SOURCEMANAGER10ADDVIRTUALER9FBUSTRINGR8FBSTRING:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 160
	.seh_stackalloc	160
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
	mov	QWORD PTR 32[rbp], r8
	mov	DWORD PTR -32[rbp], 0
.L2261:
	lea	rax, -112[rbp]
	mov	rcx, rax
	call	_ZN5ArrayIhEC1Ev
	mov	rax, QWORD PTR 32[rbp]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrLen
	mov	QWORD PTR -16[rbp], rax
	mov	rax, QWORD PTR -16[rbp]
	mov	DWORD PTR -20[rbp], eax
	mov	edx, DWORD PTR -20[rbp]
	lea	rax, -112[rbp]
	mov	rcx, rax
	call	_ZN5ArrayIhE7RESERVEEi
	mov	DWORD PTR -4[rbp], 0
	mov	eax, DWORD PTR -20[rbp]
	sub	eax, 1
	mov	DWORD PTR -24[rbp], eax
	jmp	.L2262
.L2269:
	nop
.L2263:
	mov	rax, QWORD PTR 32[rbp]
	mov	rdx, QWORD PTR [rax]
	mov	eax, DWORD PTR -4[rbp]
	cdqe
	add	rdx, rax
	lea	rax, -112[rbp]
	mov	rcx, rax
	call	_ZN5ArrayIhE4PUSHERh
.L2264:
	add	DWORD PTR -4[rbp], 1
.L2262:
	mov	eax, DWORD PTR -4[rbp]
	cmp	eax, DWORD PTR -24[rbp]
	jle	.L2269
	nop
.L2265:
	lea	rcx, -112[rbp]
	mov	rdx, QWORD PTR 24[rbp]
	mov	rax, QWORD PTR 24[rbp]
	mov	DWORD PTR 32[rsp], 1
	mov	r9, rcx
	mov	r8, rdx
	mov	rdx, rax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN3TKO13SOURCEMANAGER5ADOPTER9FBUSTRINGS2_R5ArrayIhEb
	mov	DWORD PTR -28[rbp], eax
	mov	eax, DWORD PTR -28[rbp]
	mov	DWORD PTR -32[rbp], eax
	lea	rax, -112[rbp]
	mov	rcx, rax
	call	_ZN5ArrayIhED1Ev
	nop
.L2266:
	mov	eax, DWORD PTR -32[rbp]
	add	rsp, 160
	pop	rbp
	ret
	.seh_endproc
	.globl	_ZN3TKO13SOURCEMANAGER6LOCFOREji
	.def	_ZN3TKO13SOURCEMANAGER6LOCFOREji;	.scl	2;	.type	32;	.endef
	.seh_proc	_ZN3TKO13SOURCEMANAGER6LOCFOREji
_ZN3TKO13SOURCEMANAGER6LOCFOREji:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 64
	.seh_stackalloc	64
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
	mov	DWORD PTR 32[rbp], r8d
	mov	DWORD PTR -28[rbp], 0
.L2271:
	mov	eax, DWORD PTR 24[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN3TKO13SOURCEMANAGER6FILEATEj
	mov	QWORD PTR -8[rbp], rax
	mov	rax, QWORD PTR -8[rbp]
	mov	QWORD PTR -16[rbp], rax
	cmp	QWORD PTR -16[rbp], 0
	jne	.L2281
	mov	DWORD PTR -28[rbp], 0
	jmp	.L2274
.L2281:
	nop
.L2273:
	cmp	DWORD PTR 32[rbp], 0
	jns	.L2282
	mov	DWORD PTR 32[rbp], 0
	jmp	.L2276
.L2282:
	nop
.L2276:
	mov	rax, QWORD PTR -16[rbp]
	add	rax, 8
	mov	rcx, rax
	call	_ZN5ArrayIhE5COUNTEv
	mov	DWORD PTR -20[rbp], eax
	mov	eax, DWORD PTR 32[rbp]
	cmp	eax, DWORD PTR -20[rbp]
	jle	.L2283
	mov	rax, QWORD PTR -16[rbp]
	add	rax, 8
	mov	rcx, rax
	call	_ZN5ArrayIhE5COUNTEv
	mov	DWORD PTR -24[rbp], eax
	mov	eax, DWORD PTR -24[rbp]
	mov	DWORD PTR 32[rbp], eax
	jmp	.L2278
.L2283:
	nop
.L2278:
	mov	rax, QWORD PTR -16[rbp]
	add	rax, 176
	mov	edx, DWORD PTR [rax]
	mov	eax, DWORD PTR 32[rbp]
	add	eax, edx
	mov	DWORD PTR -28[rbp], eax
	nop
.L2274:
	mov	eax, DWORD PTR -28[rbp]
	add	rsp, 64
	pop	rbp
	ret
	.seh_endproc
	.globl	_ZN3TKO13SOURCEMANAGER6DECODEEj
	.def	_ZN3TKO13SOURCEMANAGER6DECODEEj;	.scl	2;	.type	32;	.endef
	.seh_proc	_ZN3TKO13SOURCEMANAGER6DECODEEj
_ZN3TKO13SOURCEMANAGER6DECODEEj:
	push	rbp
	.seh_pushreg	rbp
	sub	rsp, 288
	.seh_stackalloc	288
	lea	rbp, 128[rsp]
	.seh_setframe	rbp, 128
	.seh_endprologue
	mov	QWORD PTR 176[rbp], rcx
	mov	QWORD PTR 184[rbp], rdx
	mov	DWORD PTR 192[rbp], r8d
	lea	rax, -64[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
.L2285:
	lea	rax, -96[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	lea	rax, -96[rbp]
	mov	DWORD PTR [rax], 0
	lea	rax, -96[rbp]
	add	rax, 4
	mov	DWORD PTR [rax], 0
	lea	rax, -96[rbp]
	add	rax, 12
	mov	DWORD PTR [rax], 0
	lea	rax, -96[rbp]
	add	rax, 16
	mov	DWORD PTR [rax], 0
	cmp	DWORD PTR 192[rbp], 0
	jne	.L2328
	mov	rax, QWORD PTR -96[rbp]
	mov	rdx, QWORD PTR -88[rbp]
	mov	QWORD PTR -64[rbp], rax
	mov	QWORD PTR -56[rbp], rdx
	mov	rax, QWORD PTR -80[rbp]
	mov	QWORD PTR -48[rbp], rax
	jmp	.L2288
.L2328:
	nop
.L2287:
	mov	DWORD PTR 156[rbp], 0
	mov	rax, QWORD PTR 184[rbp]
	mov	rcx, rax
	call	_ZN5ArrayIPN3TKO10SOURCEFILEEE5COUNTEv
	mov	DWORD PTR 116[rbp], eax
	mov	eax, DWORD PTR 116[rbp]
	sub	eax, 1
	mov	DWORD PTR 152[rbp], eax
	mov	DWORD PTR 148[rbp], -1
.L2289:
	mov	eax, DWORD PTR 156[rbp]
	cmp	eax, DWORD PTR 152[rbp]
	jg	.L2329
	mov	eax, DWORD PTR 156[rbp]
	movsx	rdx, eax
	mov	eax, DWORD PTR 152[rbp]
	cdqe
	add	rax, rdx
	mov	rdx, rax
	shr	rdx, 63
	add	rax, rdx
	sar	rax
	mov	DWORD PTR 112[rbp], eax
	mov	edx, DWORD PTR 112[rbp]
	mov	rax, QWORD PTR 184[rbp]
	mov	rcx, rax
	call	_ZN5ArrayIPN3TKO10SOURCEFILEEEixEi
	mov	QWORD PTR 104[rbp], rax
	mov	rax, QWORD PTR 104[rbp]
	mov	rax, QWORD PTR [rax]
	mov	QWORD PTR 96[rbp], rax
	mov	rax, QWORD PTR 96[rbp]
	add	rax, 8
	mov	rcx, rax
	call	_ZN5ArrayIhE5COUNTEv
	mov	DWORD PTR 92[rbp], eax
	mov	rax, QWORD PTR 96[rbp]
	add	rax, 176
	mov	edx, DWORD PTR [rax]
	mov	eax, DWORD PTR 92[rbp]
	add	eax, edx
	mov	DWORD PTR 88[rbp], eax
	mov	rax, QWORD PTR 96[rbp]
	add	rax, 176
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR 192[rbp], eax
	jnb	.L2330
	mov	eax, DWORD PTR 112[rbp]
	sub	eax, 1
	mov	DWORD PTR 152[rbp], eax
	jmp	.L2294
.L2330:
	nop
.L2293:
	mov	eax, DWORD PTR 192[rbp]
	cmp	eax, DWORD PTR 88[rbp]
	jbe	.L2331
	mov	eax, DWORD PTR 112[rbp]
	add	eax, 1
	mov	DWORD PTR 156[rbp], eax
	jmp	.L2294
.L2331:
	nop
.L2296:
	mov	eax, DWORD PTR 112[rbp]
	mov	DWORD PTR 148[rbp], eax
	jmp	.L2291
.L2294:
	jmp	.L2289
.L2329:
	nop
.L2291:
	cmp	DWORD PTR 148[rbp], 0
	jns	.L2332
	mov	rax, QWORD PTR -96[rbp]
	mov	rdx, QWORD PTR -88[rbp]
	mov	QWORD PTR -64[rbp], rax
	mov	QWORD PTR -56[rbp], rdx
	mov	rax, QWORD PTR -80[rbp]
	mov	QWORD PTR -48[rbp], rax
	jmp	.L2288
.L2332:
	nop
.L2298:
	mov	edx, DWORD PTR 148[rbp]
	mov	rax, QWORD PTR 184[rbp]
	mov	rcx, rax
	call	_ZN5ArrayIPN3TKO10SOURCEFILEEEixEi
	mov	QWORD PTR 80[rbp], rax
	mov	rax, QWORD PTR 80[rbp]
	mov	rax, QWORD PTR [rax]
	mov	QWORD PTR 72[rbp], rax
	mov	rax, QWORD PTR 72[rbp]
	add	rax, 176
	mov	eax, DWORD PTR [rax]
	mov	edx, DWORD PTR 192[rbp]
	sub	edx, eax
	mov	eax, edx
	mov	DWORD PTR 68[rbp], eax
	mov	eax, DWORD PTR 148[rbp]
	lea	edx, 1[rax]
	lea	rax, -96[rbp]
	mov	DWORD PTR [rax], edx
	lea	rax, -96[rbp]
	add	rax, 16
	mov	edx, DWORD PTR 68[rbp]
	mov	DWORD PTR [rax], edx
	mov	DWORD PTR 156[rbp], 0
	mov	rax, QWORD PTR 72[rbp]
	add	rax, 88
	mov	rcx, rax
	call	_ZN5ArrayIiE5COUNTEv
	mov	DWORD PTR 64[rbp], eax
	mov	eax, DWORD PTR 64[rbp]
	sub	eax, 1
	mov	DWORD PTR 152[rbp], eax
	mov	DWORD PTR 144[rbp], 0
.L2299:
	mov	eax, DWORD PTR 156[rbp]
	cmp	eax, DWORD PTR 152[rbp]
	jg	.L2333
	mov	eax, DWORD PTR 156[rbp]
	movsx	rdx, eax
	mov	eax, DWORD PTR 152[rbp]
	cdqe
	add	rax, rdx
	mov	rdx, rax
	shr	rdx, 63
	add	rax, rdx
	sar	rax
	mov	DWORD PTR 60[rbp], eax
	mov	rax, QWORD PTR 72[rbp]
	lea	rcx, 88[rax]
	mov	eax, DWORD PTR 60[rbp]
	mov	edx, eax
	call	_ZN5ArrayIiEixEi
	mov	QWORD PTR 48[rbp], rax
	mov	rax, QWORD PTR 48[rbp]
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR 68[rbp], eax
	jl	.L2334
	mov	eax, DWORD PTR 60[rbp]
	mov	DWORD PTR 144[rbp], eax
	mov	eax, DWORD PTR 60[rbp]
	add	eax, 1
	mov	DWORD PTR 156[rbp], eax
	jmp	.L2304
.L2334:
	nop
.L2303:
	mov	eax, DWORD PTR 60[rbp]
	sub	eax, 1
	mov	DWORD PTR 152[rbp], eax
.L2304:
	jmp	.L2299
.L2333:
	nop
.L2301:
	lea	rax, -96[rbp]
	add	rax, 8
	mov	edx, DWORD PTR 144[rbp]
	add	edx, 1
	mov	DWORD PTR [rax], edx
	lea	rax, -96[rbp]
	add	rax, 4
	mov	edx, DWORD PTR -88[rbp]
	mov	DWORD PTR [rax], edx
	lea	rax, -96[rbp]
	add	rax, 20
	mov	DWORD PTR [rax], 0
	mov	rax, QWORD PTR 72[rbp]
	add	rax, 192
	mov	rcx, rax
	call	_ZN5ArrayIN3TKO8LINEMARKEE5COUNTEv
	mov	DWORD PTR 44[rbp], eax
	cmp	DWORD PTR 44[rbp], 0
	jle	.L2335
	mov	DWORD PTR 140[rbp], 0
	mov	rax, QWORD PTR 72[rbp]
	add	rax, 192
	mov	rcx, rax
	call	_ZN5ArrayIN3TKO8LINEMARKEE5COUNTEv
	mov	DWORD PTR 40[rbp], eax
	mov	eax, DWORD PTR 40[rbp]
	sub	eax, 1
	mov	DWORD PTR 136[rbp], eax
	mov	DWORD PTR 132[rbp], -1
.L2307:
	mov	eax, DWORD PTR 140[rbp]
	cmp	eax, DWORD PTR 136[rbp]
	jg	.L2336
	mov	eax, DWORD PTR 140[rbp]
	movsx	rdx, eax
	mov	eax, DWORD PTR 136[rbp]
	cdqe
	add	rax, rdx
	mov	rdx, rax
	shr	rdx, 63
	add	rax, rdx
	sar	rax
	mov	DWORD PTR 36[rbp], eax
	mov	rax, QWORD PTR 72[rbp]
	lea	rcx, 192[rax]
	mov	eax, DWORD PTR 36[rbp]
	mov	edx, eax
	call	_ZN5ArrayIN3TKO8LINEMARKEEixEi
	mov	QWORD PTR 24[rbp], rax
	mov	rax, QWORD PTR 24[rbp]
	mov	edx, DWORD PTR [rax]
	lea	rax, -96[rbp]
	add	rax, 8
	mov	eax, DWORD PTR [rax]
	cmp	edx, eax
	jg	.L2337
	mov	eax, DWORD PTR 36[rbp]
	mov	DWORD PTR 132[rbp], eax
	mov	eax, DWORD PTR 36[rbp]
	add	eax, 1
	mov	DWORD PTR 140[rbp], eax
	jmp	.L2312
.L2337:
	nop
.L2311:
	mov	eax, DWORD PTR 36[rbp]
	sub	eax, 1
	mov	DWORD PTR 136[rbp], eax
.L2312:
	jmp	.L2307
.L2336:
	nop
.L2309:
	cmp	DWORD PTR 132[rbp], 0
	js	.L2338
	mov	rax, QWORD PTR 72[rbp]
	lea	rcx, 192[rax]
	mov	eax, DWORD PTR 132[rbp]
	mov	edx, eax
	call	_ZN5ArrayIN3TKO8LINEMARKEEixEi
	mov	QWORD PTR 16[rbp], rax
	mov	rax, QWORD PTR 72[rbp]
	lea	rcx, 192[rax]
	mov	eax, DWORD PTR 132[rbp]
	mov	edx, eax
	call	_ZN5ArrayIN3TKO8LINEMARKEEixEi
	mov	QWORD PTR 8[rbp], rax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 4
	mov	edx, DWORD PTR [rax]
	lea	rax, -96[rbp]
	add	rax, 8
	mov	eax, DWORD PTR [rax]
	lea	ecx, [rdx+rax]
	mov	rax, QWORD PTR 8[rbp]
	mov	edx, DWORD PTR [rax]
	lea	rax, -96[rbp]
	add	rax, 4
	sub	ecx, edx
	mov	edx, ecx
	mov	DWORD PTR [rax], edx
	mov	rax, QWORD PTR 72[rbp]
	lea	rcx, 192[rax]
	mov	eax, DWORD PTR 132[rbp]
	mov	edx, eax
	call	_ZN5ArrayIN3TKO8LINEMARKEEixEi
	mov	QWORD PTR 0[rbp], rax
	lea	rax, -96[rbp]
	add	rax, 20
	mov	rdx, QWORD PTR 0[rbp]
	mov	edx, DWORD PTR 8[rdx]
	mov	DWORD PTR [rax], edx
	jmp	.L2316
.L2306:
.L2314:
.L2315:
.L2335:
	nop
	jmp	.L2316
.L2338:
	nop
.L2316:
	mov	QWORD PTR 120[rbp], 0
	mov	rax, QWORD PTR 72[rbp]
	add	rax, 8
	mov	rcx, rax
	call	_ZN5ArrayIhE5COUNTEv
	mov	DWORD PTR -4[rbp], eax
	cmp	DWORD PTR -4[rbp], 0
	jle	.L2339
	mov	rax, QWORD PTR 72[rbp]
	add	rax, 8
	mov	edx, 0
	mov	rcx, rax
	call	_ZN5ArrayIhEixEi
	mov	QWORD PTR -16[rbp], rax
	mov	rax, QWORD PTR -16[rbp]
	mov	QWORD PTR 120[rbp], rax
	jmp	.L2318
.L2339:
	nop
.L2318:
	mov	rax, QWORD PTR 72[rbp]
	lea	rcx, 88[rax]
	mov	eax, DWORD PTR 144[rbp]
	mov	edx, eax
	call	_ZN5ArrayIiEixEi
	mov	QWORD PTR -24[rbp], rax
	mov	rax, QWORD PTR -24[rbp]
	mov	edx, DWORD PTR [rax]
	mov	ecx, DWORD PTR 68[rbp]
	mov	rax, QWORD PTR 120[rbp]
	mov	r9d, 8
	mov	r8d, ecx
	mov	rcx, rax
	call	_ZN3TKO4TEXT8COLUMNOFEPKhiii
	mov	DWORD PTR -28[rbp], eax
	lea	rax, -96[rbp]
	add	rax, 12
	mov	edx, DWORD PTR -28[rbp]
	mov	DWORD PTR [rax], edx
	mov	rax, QWORD PTR -96[rbp]
	mov	rdx, QWORD PTR -88[rbp]
	mov	QWORD PTR -64[rbp], rax
	mov	QWORD PTR -56[rbp], rdx
	mov	rax, QWORD PTR -80[rbp]
	mov	QWORD PTR -48[rbp], rax
	nop
.L2288:
	mov	rcx, QWORD PTR 176[rbp]
	mov	rax, QWORD PTR -64[rbp]
	mov	rdx, QWORD PTR -56[rbp]
	mov	QWORD PTR [rcx], rax
	mov	QWORD PTR 8[rcx], rdx
	mov	rax, QWORD PTR -48[rbp]
	mov	QWORD PTR 16[rcx], rax
	mov	rax, QWORD PTR 176[rbp]
	add	rsp, 288
	pop	rbp
	ret
	.seh_endproc
	.globl	_ZN3TKO13SOURCEMANAGER11ADDLINEMARKEjiijb
	.def	_ZN3TKO13SOURCEMANAGER11ADDLINEMARKEjiijb;	.scl	2;	.type	32;	.endef
	.seh_proc	_ZN3TKO13SOURCEMANAGER11ADDLINEMARKEjiijb
_ZN3TKO13SOURCEMANAGER11ADDLINEMARKEjiijb:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 160
	.seh_stackalloc	160
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
	mov	DWORD PTR 32[rbp], r8d
	mov	DWORD PTR 40[rbp], r9d
	mov	eax, DWORD PTR 56[rbp]
	mov	BYTE PTR -116[rbp], al
.L2341:
	mov	eax, DWORD PTR 24[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN3TKO13SOURCEMANAGER6FILEATEj
	mov	QWORD PTR -24[rbp], rax
	mov	rax, QWORD PTR -24[rbp]
	mov	QWORD PTR -32[rbp], rax
	cmp	QWORD PTR -32[rbp], 0
	je	.L2368
	nop
.L2343:
	mov	eax, DWORD PTR 48[rbp]
	mov	DWORD PTR -4[rbp], eax
	cmp	BYTE PTR -116[rbp], 0
	jne	.L2369
	mov	rax, QWORD PTR -32[rbp]
	mov	eax, DWORD PTR 4[rax]
	mov	DWORD PTR -4[rbp], eax
	mov	rax, QWORD PTR -32[rbp]
	add	rax, 192
	mov	rcx, rax
	call	_ZN5ArrayIN3TKO8LINEMARKEE5COUNTEv
	mov	DWORD PTR -36[rbp], eax
	mov	eax, DWORD PTR -36[rbp]
	sub	eax, 1
	mov	DWORD PTR -8[rbp], eax
	jmp	.L2347
.L2371:
	nop
.L2348:
	mov	rax, QWORD PTR -32[rbp]
	lea	rcx, 192[rax]
	mov	eax, DWORD PTR -8[rbp]
	mov	edx, eax
	call	_ZN5ArrayIN3TKO8LINEMARKEEixEi
	mov	QWORD PTR -48[rbp], rax
	mov	rax, QWORD PTR -48[rbp]
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR 32[rbp], eax
	jle	.L2370
	mov	rax, QWORD PTR -32[rbp]
	lea	rcx, 192[rax]
	mov	eax, DWORD PTR -8[rbp]
	mov	edx, eax
	call	_ZN5ArrayIN3TKO8LINEMARKEEixEi
	mov	QWORD PTR -56[rbp], rax
	mov	rax, QWORD PTR -56[rbp]
	mov	eax, DWORD PTR 8[rax]
	mov	DWORD PTR -4[rbp], eax
	jmp	.L2354
.L2350:
.L2351:
.L2370:
	nop
.L2352:
	sub	DWORD PTR -8[rbp], 1
.L2347:
	cmp	DWORD PTR -8[rbp], 0
	jns	.L2371
	jmp	.L2354
.L2346:
.L2353:
.L2369:
	nop
.L2354:
	mov	rax, QWORD PTR -32[rbp]
	add	rax, 192
	mov	rcx, rax
	call	_ZN5ArrayIN3TKO8LINEMARKEE5COUNTEv
	mov	DWORD PTR -60[rbp], eax
	mov	eax, DWORD PTR -60[rbp]
	sub	eax, 1
	mov	DWORD PTR -12[rbp], eax
	jmp	.L2355
.L2374:
	nop
.L2356:
	mov	rax, QWORD PTR -32[rbp]
	lea	rcx, 192[rax]
	mov	eax, DWORD PTR -12[rbp]
	mov	edx, eax
	call	_ZN5ArrayIN3TKO8LINEMARKEEixEi
	mov	QWORD PTR -72[rbp], rax
	mov	rax, QWORD PTR -72[rbp]
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR 32[rbp], eax
	jne	.L2372
	mov	rax, QWORD PTR -32[rbp]
	lea	rcx, 192[rax]
	mov	eax, DWORD PTR -12[rbp]
	mov	edx, eax
	call	_ZN5ArrayIN3TKO8LINEMARKEEixEi
	mov	QWORD PTR -80[rbp], rax
	mov	rax, QWORD PTR -80[rbp]
	lea	rdx, 4[rax]
	mov	eax, DWORD PTR 40[rbp]
	mov	DWORD PTR [rdx], eax
	mov	rax, QWORD PTR -32[rbp]
	lea	rcx, 192[rax]
	mov	eax, DWORD PTR -12[rbp]
	mov	edx, eax
	call	_ZN5ArrayIN3TKO8LINEMARKEEixEi
	mov	QWORD PTR -88[rbp], rax
	mov	rax, QWORD PTR -88[rbp]
	lea	rdx, 8[rax]
	mov	eax, DWORD PTR -4[rbp]
	mov	DWORD PTR [rdx], eax
	jmp	.L2344
.L2358:
.L2372:
	nop
.L2359:
	mov	rax, QWORD PTR -32[rbp]
	lea	rcx, 192[rax]
	mov	eax, DWORD PTR -12[rbp]
	mov	edx, eax
	call	_ZN5ArrayIN3TKO8LINEMARKEEixEi
	mov	QWORD PTR -96[rbp], rax
	mov	rax, QWORD PTR -96[rbp]
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR 32[rbp], eax
	jg	.L2373
.L2361:
	nop
.L2363:
	sub	DWORD PTR -12[rbp], 1
.L2355:
	cmp	DWORD PTR -12[rbp], 0
	jns	.L2374
	jmp	.L2362
.L2373:
	nop
.L2362:
	lea	rax, -108[rbp]
	mov	QWORD PTR [rax], 0
	mov	DWORD PTR 8[rax], 0
	lea	rax, -108[rbp]
	mov	edx, DWORD PTR 32[rbp]
	mov	DWORD PTR [rax], edx
	lea	rax, -108[rbp]
	add	rax, 4
	mov	edx, DWORD PTR 40[rbp]
	mov	DWORD PTR [rax], edx
	lea	rax, -108[rbp]
	add	rax, 8
	mov	edx, DWORD PTR -4[rbp]
	mov	DWORD PTR [rax], edx
	mov	rax, QWORD PTR -32[rbp]
	lea	rcx, 192[rax]
	lea	rax, -108[rbp]
	mov	rdx, rax
	call	_ZN5ArrayIN3TKO8LINEMARKEE4PUSHERS1_
	jmp	.L2375
.L2368:
	nop
.L2344:
.L2375:
	nop
	add	rsp, 160
	pop	rbp
	ret
	.seh_endproc
	.globl	_ZN3TKO13SOURCEMANAGER11SHOWNPATHOFERNS_10DECODEDLOCE
	.def	_ZN3TKO13SOURCEMANAGER11SHOWNPATHOFERNS_10DECODEDLOCE;	.scl	2;	.type	32;	.endef
	.seh_proc	_ZN3TKO13SOURCEMANAGER11SHOWNPATHOFERNS_10DECODEDLOCE
_ZN3TKO13SOURCEMANAGER11SHOWNPATHOFERNS_10DECODEDLOCE:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 96
	.seh_stackalloc	96
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
	lea	rax, -48[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
.L2377:
	mov	rax, QWORD PTR 24[rbp]
	add	rax, 20
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	je	.L2383
	mov	rax, QWORD PTR 24[rbp]
	add	rax, 20
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 88
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN3TKO8INTERNER8SPELLINGEj
	mov	QWORD PTR -8[rbp], rax
	mov	rdx, QWORD PTR -8[rbp]
	lea	rax, -48[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrInit
	jmp	.L2380
.L2383:
	nop
.L2379:
	mov	rax, QWORD PTR 24[rbp]
	mov	eax, DWORD PTR [rax]
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN3TKO13SOURCEMANAGER6PATHOFEj
	mov	QWORD PTR -16[rbp], rax
	mov	rdx, QWORD PTR -16[rbp]
	lea	rax, -48[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrInit
	nop
.L2380:
	lea	rax, -48[rbp]
	mov	rcx, rax
	call	fb_StrAllocTempResult
	mov	QWORD PTR -24[rbp], rax
	mov	rax, QWORD PTR -24[rbp]
	add	rsp, 96
	pop	rbp
	ret
	.seh_endproc
	.globl	_ZN3TKO13SOURCEMANAGER9LINECOUNTEj
	.def	_ZN3TKO13SOURCEMANAGER9LINECOUNTEj;	.scl	2;	.type	32;	.endef
	.seh_proc	_ZN3TKO13SOURCEMANAGER9LINECOUNTEj
_ZN3TKO13SOURCEMANAGER9LINECOUNTEj:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 64
	.seh_stackalloc	64
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
	mov	DWORD PTR -24[rbp], 0
.L2385:
	mov	eax, DWORD PTR 24[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN3TKO13SOURCEMANAGER6FILEATEj
	mov	QWORD PTR -8[rbp], rax
	mov	rax, QWORD PTR -8[rbp]
	mov	QWORD PTR -16[rbp], rax
	cmp	QWORD PTR -16[rbp], 0
	jne	.L2391
	mov	DWORD PTR -24[rbp], 0
	jmp	.L2388
.L2391:
	nop
.L2387:
	mov	rax, QWORD PTR -16[rbp]
	add	rax, 88
	mov	rcx, rax
	call	_ZN5ArrayIiE5COUNTEv
	mov	DWORD PTR -20[rbp], eax
	mov	eax, DWORD PTR -20[rbp]
	mov	DWORD PTR -24[rbp], eax
	nop
.L2388:
	mov	eax, DWORD PTR -24[rbp]
	add	rsp, 64
	pop	rbp
	ret
	.seh_endproc
	.globl	_ZN3TKO13SOURCEMANAGER16CONTENTLINECOUNTEj
	.def	_ZN3TKO13SOURCEMANAGER16CONTENTLINECOUNTEj;	.scl	2;	.type	32;	.endef
	.seh_proc	_ZN3TKO13SOURCEMANAGER16CONTENTLINECOUNTEj
_ZN3TKO13SOURCEMANAGER16CONTENTLINECOUNTEj:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 112
	.seh_stackalloc	112
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
	mov	DWORD PTR -72[rbp], 0
.L2393:
	mov	eax, DWORD PTR 24[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN3TKO13SOURCEMANAGER6FILEATEj
	mov	QWORD PTR -32[rbp], rax
	mov	rax, QWORD PTR -32[rbp]
	mov	QWORD PTR -40[rbp], rax
	cmp	QWORD PTR -40[rbp], 0
	jne	.L2409
	mov	DWORD PTR -72[rbp], 0
	jmp	.L2396
.L2409:
	nop
.L2395:
	mov	rax, QWORD PTR -40[rbp]
	add	rax, 88
	mov	rcx, rax
	call	_ZN5ArrayIiE5COUNTEv
	mov	DWORD PTR -44[rbp], eax
	mov	eax, DWORD PTR -44[rbp]
	mov	DWORD PTR -20[rbp], eax
	mov	rax, QWORD PTR -40[rbp]
	add	rax, 8
	mov	rcx, rax
	call	_ZN5ArrayIhE5COUNTEv
	mov	DWORD PTR -48[rbp], eax
	cmp	DWORD PTR -48[rbp], 0
	jle	.L2410
	mov	rax, QWORD PTR -40[rbp]
	add	rax, 8
	mov	rcx, rax
	call	_ZN5ArrayIhE5COUNTEv
	mov	DWORD PTR -52[rbp], eax
	mov	eax, DWORD PTR -52[rbp]
	lea	edx, -1[rax]
	mov	rax, QWORD PTR -40[rbp]
	add	rax, 8
	mov	rcx, rax
	call	_ZN5ArrayIhEixEi
	mov	QWORD PTR -64[rbp], rax
	mov	rax, QWORD PTR -64[rbp]
	movzx	eax, BYTE PTR [rax]
	cmp	al, 10
	sete	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -8[rbp], rax
	jmp	.L2399
.L2410:
	nop
.L2398:
	mov	QWORD PTR -8[rbp], 0
.L2399:
	cmp	QWORD PTR -8[rbp], 0
	setne	al
	mov	BYTE PTR -65[rbp], al
	movsx	eax, BYTE PTR -65[rbp]
	neg	eax
	test	eax, eax
	je	.L2411
	cmp	DWORD PTR -20[rbp], 1
	setg	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -16[rbp], rax
	jmp	.L2402
.L2411:
	nop
.L2401:
	mov	QWORD PTR -16[rbp], 0
.L2402:
	cmp	QWORD PTR -16[rbp], 0
	je	.L2412
	sub	DWORD PTR -20[rbp], 1
	jmp	.L2404
.L2412:
	nop
.L2404:
	mov	eax, DWORD PTR -20[rbp]
	mov	DWORD PTR -72[rbp], eax
	nop
.L2396:
	mov	eax, DWORD PTR -72[rbp]
	add	rsp, 112
	pop	rbp
	ret
	.seh_endproc
	.globl	_ZN3TKO13SOURCEMANAGER9LINESTARTEji
	.def	_ZN3TKO13SOURCEMANAGER9LINESTARTEji;	.scl	2;	.type	32;	.endef
	.seh_proc	_ZN3TKO13SOURCEMANAGER9LINESTARTEji
_ZN3TKO13SOURCEMANAGER9LINESTARTEji:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 80
	.seh_stackalloc	80
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
	mov	DWORD PTR 32[rbp], r8d
	mov	DWORD PTR -44[rbp], 0
.L2414:
	mov	eax, DWORD PTR 24[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN3TKO13SOURCEMANAGER6FILEATEj
	mov	QWORD PTR -16[rbp], rax
	mov	rax, QWORD PTR -16[rbp]
	mov	QWORD PTR -24[rbp], rax
	cmp	QWORD PTR -24[rbp], 0
	jne	.L2427
	mov	DWORD PTR -44[rbp], 0
	jmp	.L2417
.L2427:
	nop
.L2416:
	cmp	DWORD PTR 32[rbp], 0
	jle	.L2428
	mov	rax, QWORD PTR -24[rbp]
	add	rax, 88
	mov	rcx, rax
	call	_ZN5ArrayIiE5COUNTEv
	mov	DWORD PTR -28[rbp], eax
	mov	eax, DWORD PTR 32[rbp]
	cmp	eax, DWORD PTR -28[rbp]
	setg	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -8[rbp], rax
	jmp	.L2420
.L2428:
	nop
.L2419:
	mov	QWORD PTR -8[rbp], -1
.L2420:
	cmp	QWORD PTR -8[rbp], 0
	setne	al
	mov	BYTE PTR -29[rbp], al
	cmp	BYTE PTR -29[rbp], 0
	je	.L2429
	mov	DWORD PTR -44[rbp], 0
	jmp	.L2417
.L2429:
	nop
.L2422:
	mov	eax, DWORD PTR 32[rbp]
	lea	edx, -1[rax]
	mov	rax, QWORD PTR -24[rbp]
	add	rax, 88
	mov	rcx, rax
	call	_ZN5ArrayIiEixEi
	mov	QWORD PTR -40[rbp], rax
	mov	rax, QWORD PTR -40[rbp]
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR -44[rbp], eax
	nop
.L2417:
	mov	eax, DWORD PTR -44[rbp]
	add	rsp, 80
	pop	rbp
	ret
	.seh_endproc
	.globl	_ZN3TKO13SOURCEMANAGER10LINELENGTHEji
	.def	_ZN3TKO13SOURCEMANAGER10LINELENGTHEji;	.scl	2;	.type	32;	.endef
	.seh_proc	_ZN3TKO13SOURCEMANAGER10LINELENGTHEji
_ZN3TKO13SOURCEMANAGER10LINELENGTHEji:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	add	rsp, -128
	.seh_stackalloc	128
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
	mov	DWORD PTR 32[rbp], r8d
	mov	DWORD PTR -96[rbp], 0
.L2431:
	mov	eax, DWORD PTR 24[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN3TKO13SOURCEMANAGER6FILEATEj
	mov	QWORD PTR -32[rbp], rax
	mov	rax, QWORD PTR -32[rbp]
	mov	QWORD PTR -40[rbp], rax
	cmp	QWORD PTR -40[rbp], 0
	jne	.L2456
	mov	DWORD PTR -96[rbp], 0
	jmp	.L2434
.L2456:
	nop
.L2433:
	cmp	DWORD PTR 32[rbp], 0
	jle	.L2457
	mov	rax, QWORD PTR -40[rbp]
	add	rax, 88
	mov	rcx, rax
	call	_ZN5ArrayIiE5COUNTEv
	mov	DWORD PTR -44[rbp], eax
	mov	eax, DWORD PTR 32[rbp]
	cmp	eax, DWORD PTR -44[rbp]
	setg	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -8[rbp], rax
	jmp	.L2437
.L2457:
	nop
.L2436:
	mov	QWORD PTR -8[rbp], -1
.L2437:
	cmp	QWORD PTR -8[rbp], 0
	setne	al
	mov	BYTE PTR -45[rbp], al
	cmp	BYTE PTR -45[rbp], 0
	je	.L2458
	mov	DWORD PTR -96[rbp], 0
	jmp	.L2434
.L2458:
	nop
.L2439:
	mov	eax, DWORD PTR 32[rbp]
	lea	edx, -1[rax]
	mov	rax, QWORD PTR -40[rbp]
	add	rax, 88
	mov	rcx, rax
	call	_ZN5ArrayIiEixEi
	mov	QWORD PTR -56[rbp], rax
	mov	rax, QWORD PTR -56[rbp]
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR -60[rbp], eax
	mov	rax, QWORD PTR -40[rbp]
	add	rax, 8
	mov	rcx, rax
	call	_ZN5ArrayIhE5COUNTEv
	mov	DWORD PTR -64[rbp], eax
	mov	eax, DWORD PTR -64[rbp]
	mov	DWORD PTR -12[rbp], eax
	mov	rax, QWORD PTR -40[rbp]
	add	rax, 88
	mov	rcx, rax
	call	_ZN5ArrayIiE5COUNTEv
	mov	DWORD PTR -68[rbp], eax
	mov	eax, DWORD PTR 32[rbp]
	cmp	eax, DWORD PTR -68[rbp]
	jge	.L2459
	mov	rax, QWORD PTR -40[rbp]
	lea	rcx, 88[rax]
	mov	eax, DWORD PTR 32[rbp]
	mov	edx, eax
	call	_ZN5ArrayIiEixEi
	mov	QWORD PTR -80[rbp], rax
	mov	rax, QWORD PTR -80[rbp]
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR -12[rbp], eax
	jmp	.L2450
.L2441:
.L2459:
	nop
.L2442:
.L2450:
	mov	eax, DWORD PTR -12[rbp]
	cmp	eax, DWORD PTR -60[rbp]
	jle	.L2460
	mov	eax, DWORD PTR -12[rbp]
	lea	edx, -1[rax]
	mov	rax, QWORD PTR -40[rbp]
	add	rax, 8
	mov	rcx, rax
	call	_ZN5ArrayIhEixEi
	mov	QWORD PTR -88[rbp], rax
	mov	rax, QWORD PTR -88[rbp]
	movzx	eax, BYTE PTR [rax]
	mov	BYTE PTR -89[rbp], al
	cmp	BYTE PTR -89[rbp], 10
	je	.L2461
	cmp	BYTE PTR -89[rbp], 13
	sete	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -24[rbp], rax
	jmp	.L2447
.L2461:
	nop
.L2446:
	mov	QWORD PTR -24[rbp], -1
.L2447:
	cmp	QWORD PTR -24[rbp], 0
	setne	al
	mov	BYTE PTR -90[rbp], al
	cmp	BYTE PTR -90[rbp], 0
	je	.L2462
	nop
.L2449:
	sub	DWORD PTR -12[rbp], 1
	jmp	.L2450
.L2460:
	nop
	jmp	.L2444
.L2462:
	nop
.L2444:
	mov	eax, DWORD PTR -12[rbp]
	sub	eax, DWORD PTR -60[rbp]
	mov	DWORD PTR -96[rbp], eax
	nop
.L2434:
	mov	eax, DWORD PTR -96[rbp]
	sub	rsp, -128
	pop	rbp
	ret
	.seh_endproc
	.section .rdata,"dr"
.LC3:
	.ascii "\0"
	.text
	.globl	_ZN3TKO13SOURCEMANAGER8LINETEXTEji
	.def	_ZN3TKO13SOURCEMANAGER8LINETEXTEji;	.scl	2;	.type	32;	.endef
	.seh_proc	_ZN3TKO13SOURCEMANAGER8LINETEXTEji
_ZN3TKO13SOURCEMANAGER8LINETEXTEji:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 160
	.seh_stackalloc	160
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
	mov	DWORD PTR 32[rbp], r8d
	lea	rax, -80[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
.L2464:
	mov	eax, DWORD PTR 24[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN3TKO13SOURCEMANAGER6FILEATEj
	mov	QWORD PTR -8[rbp], rax
	mov	rax, QWORD PTR -8[rbp]
	mov	QWORD PTR -16[rbp], rax
	cmp	QWORD PTR -16[rbp], 0
	jne	.L2473
	lea	rax, -80[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9d, 1
	lea	r8, .LC3[rip]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrInit
	jmp	.L2467
.L2473:
	nop
.L2466:
	mov	edx, DWORD PTR 32[rbp]
	mov	eax, DWORD PTR 24[rbp]
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN3TKO13SOURCEMANAGER9LINESTARTEji
	mov	DWORD PTR -20[rbp], eax
	mov	eax, DWORD PTR -20[rbp]
	mov	DWORD PTR -24[rbp], eax
	mov	edx, DWORD PTR 32[rbp]
	mov	eax, DWORD PTR 24[rbp]
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN3TKO13SOURCEMANAGER10LINELENGTHEji
	mov	DWORD PTR -28[rbp], eax
	mov	eax, DWORD PTR -28[rbp]
	mov	DWORD PTR -32[rbp], eax
	cmp	DWORD PTR -32[rbp], 0
	jg	.L2474
	lea	rax, -80[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9d, 1
	lea	r8, .LC3[rip]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrInit
	jmp	.L2467
.L2474:
	nop
.L2469:
	mov	eax, DWORD PTR -32[rbp]
	cdqe
	mov	rcx, rax
	call	fb_SPACE
	mov	QWORD PTR -40[rbp], rax
	mov	rdx, QWORD PTR -40[rbp]
	lea	rax, -112[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrInit
	mov	rax, QWORD PTR -16[rbp]
	lea	rcx, 8[rax]
	mov	eax, DWORD PTR -24[rbp]
	mov	edx, eax
	call	_ZN5ArrayIhEixEi
	mov	QWORD PTR -48[rbp], rax
	mov	eax, DWORD PTR -32[rbp]
	movsx	rcx, eax
	lea	rax, -112[rbp]
	mov	rax, QWORD PTR [rax]
	mov	rdx, QWORD PTR -48[rbp]
	mov	r8, rcx
	mov	rcx, rax
	call	memcpy
	lea	rdx, -112[rbp]
	lea	rax, -80[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrInit
	lea	rax, -112[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	nop
.L2467:
	lea	rax, -80[rbp]
	mov	rcx, rax
	call	fb_StrAllocTempResult
	mov	QWORD PTR -56[rbp], rax
	mov	rax, QWORD PTR -56[rbp]
	add	rsp, 160
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIhEC1Ev;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIhEC1Ev
_ZN5ArrayIhEC1Ev:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	rax, QWORD PTR 16[rbp]
	mov	QWORD PTR [rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	QWORD PTR [rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 16
	mov	QWORD PTR [rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 24
	mov	QWORD PTR [rax], 1
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 32
	mov	QWORD PTR [rax], 1
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 40
	mov	QWORD PTR [rax], 17
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 48
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	DWORD PTR [rax], 0
	nop
	pop	rbp
	ret
.L2476:
.L2477:
	.seh_endproc
	.def	_ZN5ArrayIhEaSERKS0_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIhEaSERKS0_
_ZN5ArrayIhEaSERKS0_:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 80
	.seh_stackalloc	80
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
.L2479:
	mov	rax, QWORD PTR 24[rbp]
	mov	QWORD PTR 32[rsp], 0
	mov	r9d, 0
	mov	r8d, 0
	mov	rdx, rax
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayRedimTo
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR 8[rax]
	mov	QWORD PTR -8[rbp], rax
	mov	rax, QWORD PTR 24[rbp]
	mov	rax, QWORD PTR 8[rax]
	mov	QWORD PTR -16[rbp], rax
	mov	rax, QWORD PTR 24[rbp]
	add	rax, 16
	mov	rdx, QWORD PTR [rax]
	mov	rax, QWORD PTR -16[rbp]
	add	rax, rdx
	mov	QWORD PTR -24[rbp], rax
.L2480:
	mov	rax, QWORD PTR -16[rbp]
	cmp	rax, QWORD PTR -24[rbp]
	jnb	.L2485
	mov	rax, QWORD PTR -16[rbp]
	movzx	edx, BYTE PTR [rax]
	mov	rax, QWORD PTR -8[rbp]
	mov	BYTE PTR [rax], dl
	add	QWORD PTR -8[rbp], 1
	add	QWORD PTR -16[rbp], 1
	jmp	.L2480
.L2485:
	nop
.L2482:
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 72[rax]
	mov	rax, QWORD PTR 24[rbp]
	mov	eax, DWORD PTR 72[rax]
	mov	DWORD PTR [rdx], eax
	nop
	add	rsp, 80
	pop	rbp
	ret
.L2483:
	.seh_endproc
	.def	_ZN5ArrayIhED1Ev;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIhED1Ev
_ZN5ArrayIhED1Ev:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
.L2487:
.L2488:
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayErase
	nop
	add	rsp, 32
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayI8FBSTRINGEaSERKS1_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayI8FBSTRINGEaSERKS1_
_ZN5ArrayI8FBSTRINGEaSERKS1_:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 80
	.seh_stackalloc	80
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
.L2490:
	mov	rax, QWORD PTR 24[rbp]
	mov	QWORD PTR 32[rsp], 0
	mov	r9d, 0
	mov	r8d, -1
	mov	rdx, rax
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayRedimTo
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR 8[rax]
	mov	QWORD PTR -8[rbp], rax
	mov	rax, QWORD PTR 24[rbp]
	mov	rax, QWORD PTR 8[rax]
	mov	QWORD PTR -16[rbp], rax
	mov	rax, QWORD PTR 24[rbp]
	add	rax, 16
	mov	rdx, QWORD PTR [rax]
	mov	rax, QWORD PTR -16[rbp]
	add	rax, rdx
	mov	QWORD PTR -24[rbp], rax
.L2491:
	mov	rax, QWORD PTR -16[rbp]
	cmp	rax, QWORD PTR -24[rbp]
	jnb	.L2496
	mov	rdx, QWORD PTR -16[rbp]
	mov	rax, QWORD PTR -8[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrAssign
	add	QWORD PTR -8[rbp], 24
	add	QWORD PTR -16[rbp], 24
	jmp	.L2491
.L2496:
	nop
.L2493:
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 72[rax]
	mov	rax, QWORD PTR 24[rbp]
	mov	eax, DWORD PTR 72[rax]
	mov	DWORD PTR [rdx], eax
	nop
	add	rsp, 80
	pop	rbp
	ret
.L2494:
	.seh_endproc
	.def	_ZN5ArrayIPvEC1Ev;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIPvEC1Ev
_ZN5ArrayIPvEC1Ev:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	rax, QWORD PTR 16[rbp]
	mov	QWORD PTR [rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	QWORD PTR [rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 16
	mov	QWORD PTR [rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 24
	mov	QWORD PTR [rax], 8
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 32
	mov	QWORD PTR [rax], 1
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 40
	mov	QWORD PTR [rax], 17
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 48
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	DWORD PTR [rax], 0
	nop
	pop	rbp
	ret
.L2498:
.L2499:
	.seh_endproc
	.def	_ZN5ArrayIPvEaSERKS1_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIPvEaSERKS1_
_ZN5ArrayIPvEaSERKS1_:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 80
	.seh_stackalloc	80
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
.L2501:
	mov	rax, QWORD PTR 24[rbp]
	mov	QWORD PTR 32[rsp], 0
	mov	r9d, 0
	mov	r8d, 0
	mov	rdx, rax
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayRedimTo
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR 8[rax]
	mov	QWORD PTR -8[rbp], rax
	mov	rax, QWORD PTR 24[rbp]
	mov	rax, QWORD PTR 8[rax]
	mov	QWORD PTR -16[rbp], rax
	mov	rax, QWORD PTR 24[rbp]
	add	rax, 16
	mov	rdx, QWORD PTR [rax]
	mov	rax, QWORD PTR -16[rbp]
	add	rax, rdx
	mov	QWORD PTR -24[rbp], rax
.L2502:
	mov	rax, QWORD PTR -16[rbp]
	cmp	rax, QWORD PTR -24[rbp]
	jnb	.L2507
	mov	rax, QWORD PTR -16[rbp]
	mov	rdx, QWORD PTR [rax]
	mov	rax, QWORD PTR -8[rbp]
	mov	QWORD PTR [rax], rdx
	add	QWORD PTR -8[rbp], 8
	add	QWORD PTR -16[rbp], 8
	jmp	.L2502
.L2507:
	nop
.L2504:
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 72[rax]
	mov	rax, QWORD PTR 24[rbp]
	mov	eax, DWORD PTR 72[rax]
	mov	DWORD PTR [rdx], eax
	nop
	add	rsp, 80
	pop	rbp
	ret
.L2505:
	.seh_endproc
	.def	_ZN3TKO9BYTEARENAC1Ev;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN3TKO9BYTEARENAC1Ev
_ZN3TKO9BYTEARENAC1Ev:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIPvEC1Ev
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 80
	mov	QWORD PTR [rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 88
	mov	DWORD PTR [rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 96
	mov	QWORD PTR [rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 104
	mov	QWORD PTR [rax], 0
	nop
	add	rsp, 32
	pop	rbp
	ret
.L2509:
.L2510:
	.seh_endproc
	.def	_ZN3TKO9BYTEARENAaSERKS0_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN3TKO9BYTEARENAaSERKS0_
_ZN3TKO9BYTEARENAaSERKS0_:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
.L2512:
	mov	rax, QWORD PTR 24[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIPvEaSERKS1_
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 80[rax]
	mov	rax, QWORD PTR 24[rbp]
	mov	rax, QWORD PTR 80[rax]
	mov	QWORD PTR [rdx], rax
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 88[rax]
	mov	rax, QWORD PTR 24[rbp]
	mov	eax, DWORD PTR 88[rax]
	mov	DWORD PTR [rdx], eax
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 96[rax]
	mov	rax, QWORD PTR 24[rbp]
	mov	rax, QWORD PTR 96[rax]
	mov	QWORD PTR [rdx], rax
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 104[rax]
	mov	rax, QWORD PTR 24[rbp]
	mov	rax, QWORD PTR 104[rax]
	mov	QWORD PTR [rdx], rax
	nop
	add	rsp, 32
	pop	rbp
	ret
.L2513:
	.seh_endproc
	.def	_ZN5ArrayIN3TKO11INTERNENTRYEEC1Ev;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO11INTERNENTRYEEC1Ev
_ZN5ArrayIN3TKO11INTERNENTRYEEC1Ev:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	rax, QWORD PTR 16[rbp]
	mov	QWORD PTR [rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	QWORD PTR [rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 16
	mov	QWORD PTR [rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 24
	mov	QWORD PTR [rax], 24
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 32
	mov	QWORD PTR [rax], 1
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 40
	mov	QWORD PTR [rax], 17
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 48
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	DWORD PTR [rax], 0
	nop
	pop	rbp
	ret
.L2515:
.L2516:
	.seh_endproc
	.def	_ZN5ArrayIN3TKO11INTERNENTRYEEaSERKS2_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO11INTERNENTRYEEaSERKS2_
_ZN5ArrayIN3TKO11INTERNENTRYEEaSERKS2_:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 80
	.seh_stackalloc	80
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
.L2518:
	mov	rax, QWORD PTR 24[rbp]
	mov	QWORD PTR 32[rsp], 0
	mov	r9d, 0
	mov	r8d, 0
	mov	rdx, rax
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayRedimTo
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR 8[rax]
	mov	QWORD PTR -8[rbp], rax
	mov	rax, QWORD PTR 24[rbp]
	mov	rax, QWORD PTR 8[rax]
	mov	QWORD PTR -16[rbp], rax
	mov	rax, QWORD PTR 24[rbp]
	add	rax, 16
	mov	rdx, QWORD PTR [rax]
	mov	rax, QWORD PTR -16[rbp]
	add	rax, rdx
	mov	QWORD PTR -24[rbp], rax
.L2519:
	mov	rax, QWORD PTR -16[rbp]
	cmp	rax, QWORD PTR -24[rbp]
	jnb	.L2524
	mov	rcx, QWORD PTR -8[rbp]
	mov	r8, QWORD PTR -16[rbp]
	mov	rax, QWORD PTR [r8]
	mov	rdx, QWORD PTR 8[r8]
	mov	QWORD PTR [rcx], rax
	mov	QWORD PTR 8[rcx], rdx
	mov	rax, QWORD PTR 16[r8]
	mov	QWORD PTR 16[rcx], rax
	add	QWORD PTR -8[rbp], 24
	add	QWORD PTR -16[rbp], 24
	jmp	.L2519
.L2524:
	nop
.L2521:
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 72[rax]
	mov	rax, QWORD PTR 24[rbp]
	mov	eax, DWORD PTR 72[rax]
	mov	DWORD PTR [rdx], eax
	nop
	add	rsp, 80
	pop	rbp
	ret
.L2522:
	.seh_endproc
	.def	_ZN5ArrayIN3TKO11INTERNENTRYEED1Ev;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO11INTERNENTRYEED1Ev
_ZN5ArrayIN3TKO11INTERNENTRYEED1Ev:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
.L2526:
.L2527:
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayErase
	nop
	add	rsp, 32
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIjEC1Ev;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIjEC1Ev
_ZN5ArrayIjEC1Ev:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	rax, QWORD PTR 16[rbp]
	mov	QWORD PTR [rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	QWORD PTR [rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 16
	mov	QWORD PTR [rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 24
	mov	QWORD PTR [rax], 4
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 32
	mov	QWORD PTR [rax], 1
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 40
	mov	QWORD PTR [rax], 17
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 48
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	DWORD PTR [rax], 0
	nop
	pop	rbp
	ret
.L2529:
.L2530:
	.seh_endproc
	.def	_ZN5ArrayIjEaSERKS0_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIjEaSERKS0_
_ZN5ArrayIjEaSERKS0_:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 80
	.seh_stackalloc	80
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
.L2532:
	mov	rax, QWORD PTR 24[rbp]
	mov	QWORD PTR 32[rsp], 0
	mov	r9d, 0
	mov	r8d, 0
	mov	rdx, rax
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayRedimTo
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR 8[rax]
	mov	QWORD PTR -8[rbp], rax
	mov	rax, QWORD PTR 24[rbp]
	mov	rax, QWORD PTR 8[rax]
	mov	QWORD PTR -16[rbp], rax
	mov	rax, QWORD PTR 24[rbp]
	add	rax, 16
	mov	rdx, QWORD PTR [rax]
	mov	rax, QWORD PTR -16[rbp]
	add	rax, rdx
	mov	QWORD PTR -24[rbp], rax
.L2533:
	mov	rax, QWORD PTR -16[rbp]
	cmp	rax, QWORD PTR -24[rbp]
	jnb	.L2538
	mov	rax, QWORD PTR -16[rbp]
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR -8[rbp]
	mov	DWORD PTR [rax], edx
	add	QWORD PTR -8[rbp], 4
	add	QWORD PTR -16[rbp], 4
	jmp	.L2533
.L2538:
	nop
.L2535:
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 72[rax]
	mov	rax, QWORD PTR 24[rbp]
	mov	eax, DWORD PTR 72[rax]
	mov	DWORD PTR [rdx], eax
	nop
	add	rsp, 80
	pop	rbp
	ret
.L2536:
	.seh_endproc
	.def	_ZN5ArrayIjED1Ev;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIjED1Ev
_ZN5ArrayIjED1Ev:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
.L2540:
.L2541:
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayErase
	nop
	add	rsp, 32
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN3TKO8INTERNERaSERKS0_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN3TKO8INTERNERaSERKS0_
_ZN3TKO8INTERNERaSERKS0_:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
.L2543:
	mov	rax, QWORD PTR 24[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN3TKO9BYTEARENAaSERKS0_
	mov	rax, QWORD PTR 24[rbp]
	lea	rdx, 112[rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 112
	mov	rcx, rax
	call	_ZN5ArrayIN3TKO11INTERNENTRYEEaSERKS2_
	mov	rax, QWORD PTR 24[rbp]
	lea	rdx, 192[rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 192
	mov	rcx, rax
	call	_ZN5ArrayIjEaSERKS0_
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 272[rax]
	mov	rax, QWORD PTR 24[rbp]
	mov	eax, DWORD PTR 272[rax]
	mov	DWORD PTR [rdx], eax
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 276[rax]
	mov	rax, QWORD PTR 24[rbp]
	mov	eax, DWORD PTR 276[rax]
	mov	DWORD PTR [rdx], eax
	nop
	add	rsp, 32
	pop	rbp
	ret
.L2544:
	.seh_endproc
	.def	_ZN5ArrayIiEC1Ev;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIiEC1Ev
_ZN5ArrayIiEC1Ev:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	rax, QWORD PTR 16[rbp]
	mov	QWORD PTR [rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	QWORD PTR [rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 16
	mov	QWORD PTR [rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 24
	mov	QWORD PTR [rax], 4
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 32
	mov	QWORD PTR [rax], 1
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 40
	mov	QWORD PTR [rax], 17
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 48
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	DWORD PTR [rax], 0
	nop
	pop	rbp
	ret
.L2546:
.L2547:
	.seh_endproc
	.def	_ZN5ArrayIiEaSERKS0_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIiEaSERKS0_
_ZN5ArrayIiEaSERKS0_:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 80
	.seh_stackalloc	80
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
.L2549:
	mov	rax, QWORD PTR 24[rbp]
	mov	QWORD PTR 32[rsp], 0
	mov	r9d, 0
	mov	r8d, 0
	mov	rdx, rax
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayRedimTo
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR 8[rax]
	mov	QWORD PTR -8[rbp], rax
	mov	rax, QWORD PTR 24[rbp]
	mov	rax, QWORD PTR 8[rax]
	mov	QWORD PTR -16[rbp], rax
	mov	rax, QWORD PTR 24[rbp]
	add	rax, 16
	mov	rdx, QWORD PTR [rax]
	mov	rax, QWORD PTR -16[rbp]
	add	rax, rdx
	mov	QWORD PTR -24[rbp], rax
.L2550:
	mov	rax, QWORD PTR -16[rbp]
	cmp	rax, QWORD PTR -24[rbp]
	jnb	.L2555
	mov	rax, QWORD PTR -16[rbp]
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR -8[rbp]
	mov	DWORD PTR [rax], edx
	add	QWORD PTR -8[rbp], 4
	add	QWORD PTR -16[rbp], 4
	jmp	.L2550
.L2555:
	nop
.L2552:
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 72[rax]
	mov	rax, QWORD PTR 24[rbp]
	mov	eax, DWORD PTR 72[rax]
	mov	DWORD PTR [rdx], eax
	nop
	add	rsp, 80
	pop	rbp
	ret
.L2553:
	.seh_endproc
	.def	_ZN5ArrayIiED1Ev;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIiED1Ev
_ZN5ArrayIiED1Ev:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
.L2557:
.L2558:
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayErase
	nop
	add	rsp, 32
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO8LINEMARKEEC1Ev;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO8LINEMARKEEC1Ev
_ZN5ArrayIN3TKO8LINEMARKEEC1Ev:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	rax, QWORD PTR 16[rbp]
	mov	QWORD PTR [rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	QWORD PTR [rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 16
	mov	QWORD PTR [rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 24
	mov	QWORD PTR [rax], 12
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 32
	mov	QWORD PTR [rax], 1
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 40
	mov	QWORD PTR [rax], 17
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 48
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	DWORD PTR [rax], 0
	nop
	pop	rbp
	ret
.L2560:
.L2561:
	.seh_endproc
	.def	_ZN5ArrayIN3TKO8LINEMARKEEaSERKS2_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO8LINEMARKEEaSERKS2_
_ZN5ArrayIN3TKO8LINEMARKEEaSERKS2_:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 80
	.seh_stackalloc	80
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
.L2563:
	mov	rax, QWORD PTR 24[rbp]
	mov	QWORD PTR 32[rsp], 0
	mov	r9d, 0
	mov	r8d, 0
	mov	rdx, rax
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayRedimTo
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR 8[rax]
	mov	QWORD PTR -8[rbp], rax
	mov	rax, QWORD PTR 24[rbp]
	mov	rax, QWORD PTR 8[rax]
	mov	QWORD PTR -16[rbp], rax
	mov	rax, QWORD PTR 24[rbp]
	add	rax, 16
	mov	rdx, QWORD PTR [rax]
	mov	rax, QWORD PTR -16[rbp]
	add	rax, rdx
	mov	QWORD PTR -24[rbp], rax
.L2564:
	mov	rax, QWORD PTR -16[rbp]
	cmp	rax, QWORD PTR -24[rbp]
	jnb	.L2569
	mov	rax, QWORD PTR -8[rbp]
	mov	rdx, QWORD PTR -16[rbp]
	mov	rcx, QWORD PTR [rdx]
	mov	QWORD PTR [rax], rcx
	mov	edx, DWORD PTR 8[rdx]
	mov	DWORD PTR 8[rax], edx
	add	QWORD PTR -8[rbp], 12
	add	QWORD PTR -16[rbp], 12
	jmp	.L2564
.L2569:
	nop
.L2566:
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 72[rax]
	mov	rax, QWORD PTR 24[rbp]
	mov	eax, DWORD PTR 72[rax]
	mov	DWORD PTR [rdx], eax
	nop
	add	rsp, 80
	pop	rbp
	ret
.L2567:
	.seh_endproc
	.def	_ZN5ArrayIN3TKO8LINEMARKEED1Ev;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO8LINEMARKEED1Ev
_ZN5ArrayIN3TKO8LINEMARKEED1Ev:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
.L2571:
.L2572:
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayErase
	nop
	add	rsp, 32
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN3TKO10SOURCEFILEC1Ev;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN3TKO10SOURCEFILEC1Ev
_ZN3TKO10SOURCEFILEC1Ev:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	rax, QWORD PTR 16[rbp]
	mov	DWORD PTR [rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 4
	mov	DWORD PTR [rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	rcx, rax
	call	_ZN5ArrayIhEC1Ev
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 88
	mov	rcx, rax
	call	_ZN5ArrayIiEC1Ev
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 168
	mov	QWORD PTR [rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 176
	mov	DWORD PTR [rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 180
	mov	DWORD PTR [rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 184
	mov	BYTE PTR [rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 188
	mov	DWORD PTR [rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 192
	mov	rcx, rax
	call	_ZN5ArrayIN3TKO8LINEMARKEEC1Ev
	nop
	add	rsp, 32
	pop	rbp
	ret
.L2574:
.L2575:
	.seh_endproc
	.def	_ZN3TKO10SOURCEFILEaSERKS0_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN3TKO10SOURCEFILEaSERKS0_
_ZN3TKO10SOURCEFILEaSERKS0_:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
.L2577:
	mov	rax, QWORD PTR 24[rbp]
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	mov	DWORD PTR [rax], edx
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 4[rax]
	mov	rax, QWORD PTR 24[rbp]
	mov	eax, DWORD PTR 4[rax]
	mov	DWORD PTR [rdx], eax
	mov	rax, QWORD PTR 24[rbp]
	lea	rdx, 8[rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	rcx, rax
	call	_ZN5ArrayIhEaSERKS0_
	mov	rax, QWORD PTR 24[rbp]
	lea	rdx, 88[rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 88
	mov	rcx, rax
	call	_ZN5ArrayIiEaSERKS0_
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 168[rax]
	mov	rax, QWORD PTR 24[rbp]
	mov	rax, QWORD PTR 168[rax]
	mov	QWORD PTR [rdx], rax
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 176[rax]
	mov	rax, QWORD PTR 24[rbp]
	mov	eax, DWORD PTR 176[rax]
	mov	DWORD PTR [rdx], eax
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 180[rax]
	mov	rax, QWORD PTR 24[rbp]
	mov	eax, DWORD PTR 180[rax]
	mov	DWORD PTR [rdx], eax
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 184[rax]
	mov	rax, QWORD PTR 24[rbp]
	movzx	eax, BYTE PTR 184[rax]
	mov	BYTE PTR [rdx], al
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 188[rax]
	mov	rax, QWORD PTR 24[rbp]
	mov	eax, DWORD PTR 188[rax]
	mov	DWORD PTR [rdx], eax
	mov	rax, QWORD PTR 24[rbp]
	lea	rdx, 192[rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 192
	mov	rcx, rax
	call	_ZN5ArrayIN3TKO8LINEMARKEEaSERKS2_
	nop
	add	rsp, 32
	pop	rbp
	ret
.L2578:
	.seh_endproc
	.def	_ZN3TKO10SOURCEFILED1Ev;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN3TKO10SOURCEFILED1Ev
_ZN3TKO10SOURCEFILED1Ev:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
.L2580:
.L2581:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 192
	mov	rcx, rax
	call	_ZN5ArrayIN3TKO8LINEMARKEED1Ev
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 88
	mov	rcx, rax
	call	_ZN5ArrayIiED1Ev
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	rcx, rax
	call	_ZN5ArrayIhED1Ev
	nop
	add	rsp, 32
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIPN3TKO10SOURCEFILEEEC1Ev;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIPN3TKO10SOURCEFILEEEC1Ev
_ZN5ArrayIPN3TKO10SOURCEFILEEEC1Ev:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	rax, QWORD PTR 16[rbp]
	mov	QWORD PTR [rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	QWORD PTR [rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 16
	mov	QWORD PTR [rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 24
	mov	QWORD PTR [rax], 8
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 32
	mov	QWORD PTR [rax], 1
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 40
	mov	QWORD PTR [rax], 17
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 48
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	DWORD PTR [rax], 0
	nop
	pop	rbp
	ret
.L2583:
.L2584:
	.seh_endproc
	.def	_ZN5ArrayIPN3TKO10SOURCEFILEEEaSERKS3_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIPN3TKO10SOURCEFILEEEaSERKS3_
_ZN5ArrayIPN3TKO10SOURCEFILEEEaSERKS3_:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 80
	.seh_stackalloc	80
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
.L2586:
	mov	rax, QWORD PTR 24[rbp]
	mov	QWORD PTR 32[rsp], 0
	mov	r9d, 0
	mov	r8d, 0
	mov	rdx, rax
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayRedimTo
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR 8[rax]
	mov	QWORD PTR -8[rbp], rax
	mov	rax, QWORD PTR 24[rbp]
	mov	rax, QWORD PTR 8[rax]
	mov	QWORD PTR -16[rbp], rax
	mov	rax, QWORD PTR 24[rbp]
	add	rax, 16
	mov	rdx, QWORD PTR [rax]
	mov	rax, QWORD PTR -16[rbp]
	add	rax, rdx
	mov	QWORD PTR -24[rbp], rax
.L2587:
	mov	rax, QWORD PTR -16[rbp]
	cmp	rax, QWORD PTR -24[rbp]
	jnb	.L2592
	mov	rax, QWORD PTR -16[rbp]
	mov	rdx, QWORD PTR [rax]
	mov	rax, QWORD PTR -8[rbp]
	mov	QWORD PTR [rax], rdx
	add	QWORD PTR -8[rbp], 8
	add	QWORD PTR -16[rbp], 8
	jmp	.L2587
.L2592:
	nop
.L2589:
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 72[rax]
	mov	rax, QWORD PTR 24[rbp]
	mov	eax, DWORD PTR 72[rax]
	mov	DWORD PTR [rdx], eax
	nop
	add	rsp, 80
	pop	rbp
	ret
.L2590:
	.seh_endproc
	.def	_ZN5ArrayIPN3TKO10SOURCEFILEEED1Ev;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIPN3TKO10SOURCEFILEEED1Ev
_ZN5ArrayIPN3TKO10SOURCEFILEEED1Ev:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
.L2594:
.L2595:
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayErase
	nop
	add	rsp, 32
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN3TKO13SOURCEMANAGERaSERKS0_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN3TKO13SOURCEMANAGERaSERKS0_
_ZN3TKO13SOURCEMANAGERaSERKS0_:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
.L2597:
	mov	rax, QWORD PTR 24[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIPN3TKO10SOURCEFILEEEaSERKS3_
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 80[rax]
	mov	rax, QWORD PTR 24[rbp]
	mov	eax, DWORD PTR 80[rax]
	mov	DWORD PTR [rdx], eax
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 88[rax]
	mov	rax, QWORD PTR 24[rbp]
	mov	rax, QWORD PTR 88[rax]
	mov	QWORD PTR [rdx], rax
	nop
	add	rsp, 32
	pop	rbp
	ret
.L2598:
	.seh_endproc
	.def	_ZN2FB7FSERRORaSERKS0_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN2FB7FSERRORaSERKS0_
_ZN2FB7FSERRORaSERKS0_:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 48
	.seh_stackalloc	48
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
.L2600:
	mov	rax, QWORD PTR 24[rbp]
	mov	rdx, QWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	mov	QWORD PTR [rax], rdx
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 8[rax]
	mov	rax, QWORD PTR 24[rbp]
	mov	eax, DWORD PTR 8[rax]
	mov	DWORD PTR [rdx], eax
	mov	rax, QWORD PTR 24[rbp]
	lea	rdx, 16[rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 16
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrAssign
	mov	rax, QWORD PTR 24[rbp]
	lea	rdx, 40[rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 40
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrAssign
	mov	rax, QWORD PTR 24[rbp]
	lea	rdx, 64[rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 64
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrAssign
	nop
	add	rsp, 48
	pop	rbp
	ret
.L2601:
	.seh_endproc
	.def	_ZN2FB7FSERRORD1Ev;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN2FB7FSERRORD1Ev
_ZN2FB7FSERRORD1Ev:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
.L2603:
.L2604:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 64
	mov	rcx, rax
	call	fb_UStrDelete
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 40
	mov	rcx, rax
	call	fb_UStrDelete
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 16
	mov	rcx, rax
	call	fb_UStrDelete
	nop
	add	rsp, 32
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN2FB7FSERRORC1Ev;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN2FB7FSERRORC1Ev
_ZN2FB7FSERRORC1Ev:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
.L2606:
	mov	rax, QWORD PTR 16[rbp]
	mov	QWORD PTR [rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	DWORD PTR [rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 16
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 40
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 64
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	rax, QWORD PTR 16[rbp]
	mov	QWORD PTR [rax], 16
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	DWORD PTR [rax], 0
	nop
	pop	rbp
	ret
.L2607:
	.seh_endproc
	.def	_ZN2FB7FSERRORC1ENS_11FSERRORCODEEiRK9FBUSTRINGS4_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN2FB7FSERRORC1ENS_11FSERRORCODEEiRK9FBUSTRINGS4_
_ZN2FB7FSERRORC1ENS_11FSERRORCODEEiRK9FBUSTRINGS4_:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 48
	.seh_stackalloc	48
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
	mov	DWORD PTR 32[rbp], r8d
	mov	QWORD PTR 40[rbp], r9
.L2609:
	mov	rax, QWORD PTR 16[rbp]
	mov	QWORD PTR [rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	DWORD PTR [rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 16
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 40
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 64
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	rax, QWORD PTR 16[rbp]
	mov	rdx, QWORD PTR 24[rbp]
	mov	QWORD PTR [rax], rdx
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 8[rax]
	mov	eax, DWORD PTR 32[rbp]
	mov	DWORD PTR [rdx], eax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 16
	mov	rdx, QWORD PTR 40[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrAssign
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 40
	mov	rdx, QWORD PTR 48[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrAssign
	nop
	add	rsp, 48
	pop	rbp
	ret
.L2610:
	.seh_endproc
	.def	_ZNK2FB7FSERROR7MESSAGEEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZNK2FB7FSERROR7MESSAGEEv
_ZNK2FB7FSERROR7MESSAGEEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 96
	.seh_stackalloc	96
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	lea	rax, -48[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
.L2612:
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	fb_UStrFsErrorMessage
	mov	QWORD PTR -8[rbp], rax
	mov	rdx, QWORD PTR -8[rbp]
	lea	rax, -48[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrInit
	nop
.L2613:
	lea	rax, -48[rbp]
	mov	rcx, rax
	call	fb_UStrAllocTempResult
	mov	QWORD PTR -16[rbp], rax
	mov	rax, QWORD PTR -16[rbp]
	add	rsp, 96
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN2FB7FSERROR8SETPATH2ERK9FBUSTRING;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN2FB7FSERROR8SETPATH2ERK9FBUSTRING
_ZN2FB7FSERROR8SETPATH2ERK9FBUSTRING:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 48
	.seh_stackalloc	48
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
.L2616:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 64
	mov	rdx, QWORD PTR 24[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrAssign
	nop
	add	rsp, 48
	pop	rbp
	ret
.L2617:
	.seh_endproc
	.def	_ZN6ResultIbN2FB7FSERROREEC1Ev;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN6ResultIbN2FB7FSERROREEC1Ev
_ZN6ResultIbN2FB7FSERROREEC1Ev:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	rax, QWORD PTR 16[rbp]
	mov	BYTE PTR [rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	rcx, rax
	call	_ZN2FB7FSERRORC1Ev
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 96
	mov	BYTE PTR [rax], 0
	nop
	add	rsp, 32
	pop	rbp
	ret
.L2619:
.L2620:
	.seh_endproc
	.def	_ZN6ResultIbN2FB7FSERROREEaSERKS2_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN6ResultIbN2FB7FSERROREEaSERKS2_
_ZN6ResultIbN2FB7FSERROREEaSERKS2_:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
.L2622:
	mov	rax, QWORD PTR 24[rbp]
	movzx	edx, BYTE PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	mov	BYTE PTR [rax], dl
	mov	rax, QWORD PTR 24[rbp]
	lea	rdx, 8[rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	rcx, rax
	call	_ZN2FB7FSERRORaSERKS0_
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 96[rax]
	mov	rax, QWORD PTR 24[rbp]
	movzx	eax, BYTE PTR 96[rax]
	mov	BYTE PTR [rdx], al
	nop
	add	rsp, 32
	pop	rbp
	ret
.L2623:
	.seh_endproc
	.def	_ZN6ResultIbN2FB7FSERROREEC1ERKS2_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN6ResultIbN2FB7FSERROREEC1ERKS2_
_ZN6ResultIbN2FB7FSERROREEC1ERKS2_:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
.L2625:
	mov	rax, QWORD PTR 16[rbp]
	mov	BYTE PTR [rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	rcx, rax
	call	_ZN2FB7FSERRORC1Ev
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 96
	mov	BYTE PTR [rax], 0
	mov	rax, QWORD PTR 24[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN6ResultIbN2FB7FSERROREEaSERKS2_
	nop
	add	rsp, 32
	pop	rbp
	ret
.L2626:
	.seh_endproc
	.def	_ZN6ResultIbN2FB7FSERROREED1Ev;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN6ResultIbN2FB7FSERROREED1Ev
_ZN6ResultIbN2FB7FSERROREED1Ev:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
.L2628:
.L2629:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	rcx, rax
	call	_ZN2FB7FSERRORD1Ev
	nop
	add	rsp, 32
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN6ResultIiN2FB7FSERROREEC1Ev;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN6ResultIiN2FB7FSERROREEC1Ev
_ZN6ResultIiN2FB7FSERROREEC1Ev:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	rax, QWORD PTR 16[rbp]
	mov	DWORD PTR [rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	rcx, rax
	call	_ZN2FB7FSERRORC1Ev
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 96
	mov	BYTE PTR [rax], 0
	nop
	add	rsp, 32
	pop	rbp
	ret
.L2631:
.L2632:
	.seh_endproc
	.def	_ZN6ResultIiN2FB7FSERROREEaSERKS2_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN6ResultIiN2FB7FSERROREEaSERKS2_
_ZN6ResultIiN2FB7FSERROREEaSERKS2_:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
.L2634:
	mov	rax, QWORD PTR 24[rbp]
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	mov	DWORD PTR [rax], edx
	mov	rax, QWORD PTR 24[rbp]
	lea	rdx, 8[rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	rcx, rax
	call	_ZN2FB7FSERRORaSERKS0_
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 96[rax]
	mov	rax, QWORD PTR 24[rbp]
	movzx	eax, BYTE PTR 96[rax]
	mov	BYTE PTR [rdx], al
	nop
	add	rsp, 32
	pop	rbp
	ret
.L2635:
	.seh_endproc
	.def	_ZN6ResultIiN2FB7FSERROREEC1ERKS2_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN6ResultIiN2FB7FSERROREEC1ERKS2_
_ZN6ResultIiN2FB7FSERROREEC1ERKS2_:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
.L2637:
	mov	rax, QWORD PTR 16[rbp]
	mov	DWORD PTR [rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	rcx, rax
	call	_ZN2FB7FSERRORC1Ev
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 96
	mov	BYTE PTR [rax], 0
	mov	rax, QWORD PTR 24[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN6ResultIiN2FB7FSERROREEaSERKS2_
	nop
	add	rsp, 32
	pop	rbp
	ret
.L2638:
	.seh_endproc
	.def	_ZN6ResultIiN2FB7FSERROREED1Ev;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN6ResultIiN2FB7FSERROREED1Ev
_ZN6ResultIiN2FB7FSERROREED1Ev:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
.L2640:
.L2641:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	rcx, rax
	call	_ZN2FB7FSERRORD1Ev
	nop
	add	rsp, 32
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN6ResultIxN2FB7FSERROREEC1Ev;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN6ResultIxN2FB7FSERROREEC1Ev
_ZN6ResultIxN2FB7FSERROREEC1Ev:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	rax, QWORD PTR 16[rbp]
	mov	QWORD PTR [rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	rcx, rax
	call	_ZN2FB7FSERRORC1Ev
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 96
	mov	BYTE PTR [rax], 0
	nop
	add	rsp, 32
	pop	rbp
	ret
.L2643:
.L2644:
	.seh_endproc
	.def	_ZN6ResultIxN2FB7FSERROREEaSERKS2_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN6ResultIxN2FB7FSERROREEaSERKS2_
_ZN6ResultIxN2FB7FSERROREEaSERKS2_:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
.L2646:
	mov	rax, QWORD PTR 24[rbp]
	mov	rdx, QWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	mov	QWORD PTR [rax], rdx
	mov	rax, QWORD PTR 24[rbp]
	lea	rdx, 8[rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	rcx, rax
	call	_ZN2FB7FSERRORaSERKS0_
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 96[rax]
	mov	rax, QWORD PTR 24[rbp]
	movzx	eax, BYTE PTR 96[rax]
	mov	BYTE PTR [rdx], al
	nop
	add	rsp, 32
	pop	rbp
	ret
.L2647:
	.seh_endproc
	.def	_ZN6ResultIxN2FB7FSERROREEC1ERKS2_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN6ResultIxN2FB7FSERROREEC1ERKS2_
_ZN6ResultIxN2FB7FSERROREEC1ERKS2_:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
.L2649:
	mov	rax, QWORD PTR 16[rbp]
	mov	QWORD PTR [rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	rcx, rax
	call	_ZN2FB7FSERRORC1Ev
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 96
	mov	BYTE PTR [rax], 0
	mov	rax, QWORD PTR 24[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN6ResultIxN2FB7FSERROREEaSERKS2_
	nop
	add	rsp, 32
	pop	rbp
	ret
.L2650:
	.seh_endproc
	.def	_ZN6ResultIxN2FB7FSERROREED1Ev;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN6ResultIxN2FB7FSERROREED1Ev
_ZN6ResultIxN2FB7FSERROREED1Ev:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
.L2652:
.L2653:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	rcx, rax
	call	_ZN2FB7FSERRORD1Ev
	nop
	add	rsp, 32
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN6ResultI9FBUSTRINGN2FB7FSERROREEC1Ev;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN6ResultI9FBUSTRINGN2FB7FSERROREEC1Ev
_ZN6ResultI9FBUSTRINGN2FB7FSERROREEC1Ev:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	rax, QWORD PTR 16[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 24
	mov	rcx, rax
	call	_ZN2FB7FSERRORC1Ev
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 112
	mov	BYTE PTR [rax], 0
	nop
	add	rsp, 32
	pop	rbp
	ret
.L2655:
.L2656:
	.seh_endproc
	.def	_ZN6ResultI9FBUSTRINGN2FB7FSERROREEaSERKS3_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN6ResultI9FBUSTRINGN2FB7FSERROREEaSERKS3_
_ZN6ResultI9FBUSTRINGN2FB7FSERROREEaSERKS3_:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 48
	.seh_stackalloc	48
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
.L2658:
	mov	rax, QWORD PTR 24[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rax
	mov	rdx, -1
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_UStrAssign
	mov	rax, QWORD PTR 24[rbp]
	lea	rdx, 24[rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 24
	mov	rcx, rax
	call	_ZN2FB7FSERRORaSERKS0_
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 112[rax]
	mov	rax, QWORD PTR 24[rbp]
	movzx	eax, BYTE PTR 112[rax]
	mov	BYTE PTR [rdx], al
	nop
	add	rsp, 48
	pop	rbp
	ret
.L2659:
	.seh_endproc
	.def	_ZN6ResultI9FBUSTRINGN2FB7FSERROREEC1ERKS3_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN6ResultI9FBUSTRINGN2FB7FSERROREEC1ERKS3_
_ZN6ResultI9FBUSTRINGN2FB7FSERROREEC1ERKS3_:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
.L2661:
	mov	rax, QWORD PTR 16[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 24
	mov	rcx, rax
	call	_ZN2FB7FSERRORC1Ev
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 112
	mov	BYTE PTR [rax], 0
	mov	rax, QWORD PTR 24[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN6ResultI9FBUSTRINGN2FB7FSERROREEaSERKS3_
	nop
	add	rsp, 32
	pop	rbp
	ret
.L2662:
	.seh_endproc
	.def	_ZN6ResultI9FBUSTRINGN2FB7FSERROREED1Ev;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN6ResultI9FBUSTRINGN2FB7FSERROREED1Ev
_ZN6ResultI9FBUSTRINGN2FB7FSERROREED1Ev:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
.L2664:
.L2665:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 24
	mov	rcx, rax
	call	_ZN2FB7FSERRORD1Ev
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_UStrDelete
	nop
	add	rsp, 32
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN6ResultI8FBSTRINGN2FB7FSERROREEaSERKS3_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN6ResultI8FBSTRINGN2FB7FSERROREEaSERKS3_
_ZN6ResultI8FBSTRINGN2FB7FSERROREEaSERKS3_:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 48
	.seh_stackalloc	48
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
.L2667:
	mov	rax, QWORD PTR 24[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rax
	mov	rdx, -1
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_StrAssign
	mov	rax, QWORD PTR 24[rbp]
	lea	rdx, 24[rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 24
	mov	rcx, rax
	call	_ZN2FB7FSERRORaSERKS0_
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 112[rax]
	mov	rax, QWORD PTR 24[rbp]
	movzx	eax, BYTE PTR 112[rax]
	mov	BYTE PTR [rdx], al
	nop
	add	rsp, 48
	pop	rbp
	ret
.L2668:
	.seh_endproc
	.def	_ZN2FB8PATHJOINERK9FBUSTRINGS2_S2_i;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN2FB8PATHJOINERK9FBUSTRINGS2_S2_i
_ZN2FB8PATHJOINERK9FBUSTRINGS2_S2_i:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	add	rsp, -128
	.seh_stackalloc	128
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
	mov	QWORD PTR 32[rbp], r8
	mov	DWORD PTR 40[rbp], r9d
	lea	rax, -80[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
.L2670:
	lea	rax, -48[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	edx, DWORD PTR 40[rbp]
	mov	rax, QWORD PTR 24[rbp]
	mov	r8d, edx
	mov	rdx, rax
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_UStrPathJoin2
	mov	QWORD PTR -8[rbp], rax
	mov	rdx, QWORD PTR -8[rbp]
	lea	rax, -48[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrAssign
	mov	ecx, DWORD PTR 40[rbp]
	mov	rdx, QWORD PTR 32[rbp]
	lea	rax, -48[rbp]
	mov	r8d, ecx
	mov	rcx, rax
	call	fb_UStrPathJoin2
	mov	QWORD PTR -16[rbp], rax
	mov	rdx, QWORD PTR -16[rbp]
	lea	rax, -80[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrInit
	lea	rax, -48[rbp]
	mov	rcx, rax
	call	fb_UStrDelete
	nop
.L2671:
	lea	rax, -80[rbp]
	mov	rcx, rax
	call	fb_UStrAllocTempResult
	mov	QWORD PTR -24[rbp], rax
	mov	rax, QWORD PTR -24[rbp]
	sub	rsp, -128
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN2FB8PATHJOINERK9FBUSTRINGS2_S2_S2_i;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN2FB8PATHJOINERK9FBUSTRINGS2_S2_S2_i
_ZN2FB8PATHJOINERK9FBUSTRINGS2_S2_S2_i:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 176
	.seh_stackalloc	176
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
	mov	QWORD PTR 32[rbp], r8
	mov	QWORD PTR 40[rbp], r9
	lea	rax, -128[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
.L2674:
	lea	rax, -96[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	lea	rax, -64[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	edx, DWORD PTR 48[rbp]
	mov	rax, QWORD PTR 24[rbp]
	mov	r8d, edx
	mov	rdx, rax
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_UStrPathJoin2
	mov	QWORD PTR -8[rbp], rax
	mov	rdx, QWORD PTR -8[rbp]
	lea	rax, -64[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrAssign
	mov	ecx, DWORD PTR 48[rbp]
	mov	rdx, QWORD PTR 32[rbp]
	lea	rax, -64[rbp]
	mov	r8d, ecx
	mov	rcx, rax
	call	fb_UStrPathJoin2
	mov	QWORD PTR -16[rbp], rax
	mov	rdx, QWORD PTR -16[rbp]
	lea	rax, -96[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrAssign
	mov	ecx, DWORD PTR 48[rbp]
	mov	rdx, QWORD PTR 40[rbp]
	lea	rax, -96[rbp]
	mov	r8d, ecx
	mov	rcx, rax
	call	fb_UStrPathJoin2
	mov	QWORD PTR -24[rbp], rax
	mov	rdx, QWORD PTR -24[rbp]
	lea	rax, -128[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrInit
	lea	rax, -96[rbp]
	mov	rcx, rax
	call	fb_UStrDelete
	lea	rax, -64[rbp]
	mov	rcx, rax
	call	fb_UStrDelete
	nop
.L2675:
	lea	rax, -128[rbp]
	mov	rcx, rax
	call	fb_UStrAllocTempResult
	mov	QWORD PTR -32[rbp], rax
	mov	rax, QWORD PTR -32[rbp]
	add	rsp, 176
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayI9FBUSTRINGEC1Ev;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayI9FBUSTRINGEC1Ev
_ZN5ArrayI9FBUSTRINGEC1Ev:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	rax, QWORD PTR 16[rbp]
	mov	QWORD PTR [rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	QWORD PTR [rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 16
	mov	QWORD PTR [rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 24
	mov	QWORD PTR [rax], 24
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 32
	mov	QWORD PTR [rax], 1
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 40
	mov	QWORD PTR [rax], 17
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 48
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	DWORD PTR [rax], 0
	nop
	pop	rbp
	ret
.L2678:
.L2679:
	.seh_endproc
	.def	_ZN5ArrayI9FBUSTRINGEaSERKS1_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayI9FBUSTRINGEaSERKS1_
_ZN5ArrayI9FBUSTRINGEaSERKS1_:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 80
	.seh_stackalloc	80
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
.L2681:
	mov	rax, QWORD PTR 24[rbp]
	mov	QWORD PTR 32[rsp], 0
	mov	r9d, 0
	mov	r8d, 0
	mov	rdx, rax
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayRedimTo
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR 8[rax]
	mov	QWORD PTR -8[rbp], rax
	mov	rax, QWORD PTR 24[rbp]
	mov	rax, QWORD PTR 8[rax]
	mov	QWORD PTR -16[rbp], rax
	mov	rax, QWORD PTR 24[rbp]
	add	rax, 16
	mov	rdx, QWORD PTR [rax]
	mov	rax, QWORD PTR -16[rbp]
	add	rax, rdx
	mov	QWORD PTR -24[rbp], rax
.L2682:
	mov	rax, QWORD PTR -16[rbp]
	cmp	rax, QWORD PTR -24[rbp]
	jnb	.L2687
	mov	rdx, QWORD PTR -16[rbp]
	mov	rax, QWORD PTR -8[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrAssign
	add	QWORD PTR -8[rbp], 24
	add	QWORD PTR -16[rbp], 24
	jmp	.L2682
.L2687:
	nop
.L2684:
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 72[rax]
	mov	rax, QWORD PTR 24[rbp]
	mov	eax, DWORD PTR 72[rax]
	mov	DWORD PTR [rdx], eax
	nop
	add	rsp, 80
	pop	rbp
	ret
.L2685:
	.seh_endproc
	.def	_ZN5ArrayI9FBUSTRINGED1Ev;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayI9FBUSTRINGED1Ev
_ZN5ArrayI9FBUSTRINGED1Ev:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
.L2689:
.L2690:
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayUStrErase
	nop
	add	rsp, 32
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN2FB9PATHSPLITERK9FBUSTRINGR5ArrayI9FBUSTRINGEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN2FB9PATHSPLITERK9FBUSTRINGR5ArrayI9FBUSTRINGEi
_ZN2FB9PATHSPLITERK9FBUSTRINGR5ArrayI9FBUSTRINGEi:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 176
	.seh_stackalloc	176
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
	mov	DWORD PTR 32[rbp], r8d
	mov	DWORD PTR -44[rbp], 0
.L2692:
	mov	QWORD PTR -8[rbp], 0
	mov	QWORD PTR -56[rbp], 0
	mov	QWORD PTR -64[rbp], 0
	mov	DWORD PTR -12[rbp], 0
	mov	eax, DWORD PTR 32[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_UStrPathNormalize
	mov	QWORD PTR -24[rbp], rax
	mov	rdx, QWORD PTR -24[rbp]
	lea	rax, -96[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrInit
	mov	rax, QWORD PTR 24[rbp]
	mov	rcx, rax
	call	_ZN5ArrayI9FBUSTRINGE5CLEAREv
.L2693:
	lea	r8, -56[rbp]
	mov	rcx, QWORD PTR -8[rbp]
	mov	edx, DWORD PTR 32[rbp]
	lea	rax, -96[rbp]
	mov	r9, r8
	mov	r8, rcx
	mov	rcx, rax
	call	fb_UStrPathNextComp
	mov	QWORD PTR -32[rbp], rax
	mov	rax, QWORD PTR -32[rbp]
	mov	QWORD PTR -64[rbp], rax
	mov	rax, QWORD PTR -64[rbp]
	test	rax, rax
	js	.L2700
	nop
.L2695:
	lea	rax, -128[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	rdx, QWORD PTR -56[rbp]
	mov	rax, QWORD PTR -64[rbp]
	lea	rcx, 1[rax]
	lea	rax, -96[rbp]
	mov	r9, rdx
	mov	r8, rcx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrMid
	mov	QWORD PTR -40[rbp], rax
	mov	rdx, QWORD PTR -40[rbp]
	lea	rax, -128[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrAssign
	lea	rdx, -128[rbp]
	mov	rax, QWORD PTR 24[rbp]
	mov	rcx, rax
	call	_ZN5ArrayI9FBUSTRINGE4PUSHERS0_
	lea	rax, -128[rbp]
	mov	rcx, rax
	call	fb_UStrDelete
	add	DWORD PTR -12[rbp], 1
	mov	rdx, QWORD PTR -64[rbp]
	mov	rax, QWORD PTR -56[rbp]
	add	rax, rdx
	mov	QWORD PTR -8[rbp], rax
.L2697:
	jmp	.L2693
.L2700:
	nop
.L2696:
	mov	eax, DWORD PTR -12[rbp]
	mov	DWORD PTR -44[rbp], eax
	lea	rax, -96[rbp]
	mov	rcx, rax
	call	fb_UStrDelete
	nop
.L2698:
	mov	eax, DWORD PTR -44[rbp]
	add	rsp, 176
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN2FB13PATHSEPARATOREi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN2FB13PATHSEPARATOREi
_ZN2FB13PATHSEPARATOREi:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 96
	.seh_stackalloc	96
	.seh_endprologue
	mov	DWORD PTR 16[rbp], ecx
	lea	rax, -32[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
.L2702:
	cmp	DWORD PTR 16[rbp], 1
	jne	.L2708
	mov	WORD PTR -40[rbp], 92
	mov	WORD PTR -38[rbp], 0
	lea	rdx, -40[rbp]
	lea	rax, -32[rbp]
	mov	DWORD PTR 32[rsp], 0
	movabs	r9, -9223372036854775807
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrInit
	jmp	.L2705
.L2708:
	nop
.L2704:
	mov	WORD PTR -36[rbp], 47
	mov	WORD PTR -34[rbp], 0
	lea	rdx, -36[rbp]
	lea	rax, -32[rbp]
	mov	DWORD PTR 32[rsp], 0
	movabs	r9, -9223372036854775807
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrInit
	nop
.L2705:
	lea	rax, -32[rbp]
	mov	rcx, rax
	call	fb_UStrAllocTempResult
	mov	QWORD PTR -8[rbp], rax
	mov	rax, QWORD PTR -8[rbp]
	add	rsp, 96
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN6ResultIN2FB8FILEINFOEN2FB7FSERROREEC1Ev;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN6ResultIN2FB8FILEINFOEN2FB7FSERROREEC1Ev
_ZN6ResultIN2FB8FILEINFOEN2FB7FSERROREEC1Ev:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	rax, QWORD PTR 16[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	QWORD PTR 24[rax], 0
	mov	QWORD PTR 32[rax], 0
	mov	QWORD PTR 40[rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 48
	mov	rcx, rax
	call	_ZN2FB7FSERRORC1Ev
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 136
	mov	BYTE PTR [rax], 0
	nop
	add	rsp, 32
	pop	rbp
	ret
.L2710:
.L2711:
	.seh_endproc
	.def	_ZN6ResultIN2FB8FILEINFOEN2FB7FSERROREEaSERKS4_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN6ResultIN2FB8FILEINFOEN2FB7FSERROREEaSERKS4_
_ZN6ResultIN2FB8FILEINFOEN2FB7FSERROREEaSERKS4_:
	push	rbp
	.seh_pushreg	rbp
	push	rbx
	.seh_pushreg	rbx
	sub	rsp, 40
	.seh_stackalloc	40
	lea	rbp, 128[rsp]
	.seh_setframe	rbp, 128
	.seh_endprologue
	mov	QWORD PTR -64[rbp], rcx
	mov	QWORD PTR -56[rbp], rdx
.L2713:
	mov	rax, QWORD PTR -64[rbp]
	mov	rdx, QWORD PTR -56[rbp]
	mov	rcx, QWORD PTR [rdx]
	mov	rbx, QWORD PTR 8[rdx]
	mov	QWORD PTR [rax], rcx
	mov	QWORD PTR 8[rax], rbx
	mov	rcx, QWORD PTR 16[rdx]
	mov	rbx, QWORD PTR 24[rdx]
	mov	QWORD PTR 16[rax], rcx
	mov	QWORD PTR 24[rax], rbx
	mov	rcx, QWORD PTR 32[rdx]
	mov	rbx, QWORD PTR 40[rdx]
	mov	QWORD PTR 32[rax], rcx
	mov	QWORD PTR 40[rax], rbx
	mov	rax, QWORD PTR -56[rbp]
	lea	rdx, 48[rax]
	mov	rax, QWORD PTR -64[rbp]
	add	rax, 48
	mov	rcx, rax
	call	_ZN2FB7FSERRORaSERKS0_
	mov	rax, QWORD PTR -64[rbp]
	lea	rdx, 136[rax]
	mov	rax, QWORD PTR -56[rbp]
	movzx	eax, BYTE PTR 136[rax]
	mov	BYTE PTR [rdx], al
	nop
	add	rsp, 40
	pop	rbx
	pop	rbp
	ret
.L2714:
	.seh_endproc
	.def	_ZN6ResultIN2FB8FILEINFOEN2FB7FSERROREEC1ERKS4_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN6ResultIN2FB8FILEINFOEN2FB7FSERROREEC1ERKS4_
_ZN6ResultIN2FB8FILEINFOEN2FB7FSERROREEC1ERKS4_:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
.L2716:
	mov	rax, QWORD PTR 16[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	QWORD PTR 24[rax], 0
	mov	QWORD PTR 32[rax], 0
	mov	QWORD PTR 40[rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 48
	mov	rcx, rax
	call	_ZN2FB7FSERRORC1Ev
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 136
	mov	BYTE PTR [rax], 0
	mov	rax, QWORD PTR 24[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN6ResultIN2FB8FILEINFOEN2FB7FSERROREEaSERKS4_
	nop
	add	rsp, 32
	pop	rbp
	ret
.L2717:
	.seh_endproc
	.def	_ZN6ResultIN2FB8FILEINFOEN2FB7FSERROREED1Ev;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN6ResultIN2FB8FILEINFOEN2FB7FSERROREED1Ev
_ZN6ResultIN2FB8FILEINFOEN2FB7FSERROREED1Ev:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
.L2719:
.L2720:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 48
	mov	rcx, rax
	call	_ZN2FB7FSERRORD1Ev
	nop
	add	rsp, 32
	pop	rbp
	ret
	.seh_endproc
	.def	_ZNK2FB8FILEINFO6ISFILEEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZNK2FB8FILEINFO6ISFILEEv
_ZNK2FB8FILEINFO6ISFILEEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	BYTE PTR -1[rbp], 0
.L2722:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 36
	mov	eax, DWORD PTR [rax]
	cmp	eax, 1
	sete	al
	mov	BYTE PTR -1[rbp], al
	nop
.L2723:
	movzx	eax, BYTE PTR -1[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZNK2FB8FILEINFO11ISDIRECTORYEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZNK2FB8FILEINFO11ISDIRECTORYEv
_ZNK2FB8FILEINFO11ISDIRECTORYEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	BYTE PTR -1[rbp], 0
.L2726:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 36
	mov	eax, DWORD PTR [rax]
	cmp	eax, 2
	sete	al
	mov	BYTE PTR -1[rbp], al
	nop
.L2727:
	movzx	eax, BYTE PTR -1[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZNK2FB8FILEINFO9ISSYMLINKEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZNK2FB8FILEINFO9ISSYMLINKEv
_ZNK2FB8FILEINFO9ISSYMLINKEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	BYTE PTR -1[rbp], 0
.L2730:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 36
	mov	eax, DWORD PTR [rax]
	cmp	eax, 3
	sete	al
	mov	BYTE PTR -1[rbp], al
	nop
.L2731:
	movzx	eax, BYTE PTR -1[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZNK2FB8FILEINFO11MODIFIEDUTCEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZNK2FB8FILEINFO11MODIFIEDUTCEv
_ZNK2FB8FILEINFO11MODIFIEDUTCEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR -8[rbp], 0
.L2734:
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR 8[rax]
	mov	QWORD PTR -8[rbp], rax
	nop
.L2735:
	mov	rax, QWORD PTR -8[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZNK2FB8FILEINFO11ACCESSEDUTCEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZNK2FB8FILEINFO11ACCESSEDUTCEv
_ZNK2FB8FILEINFO11ACCESSEDUTCEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR -8[rbp], 0
.L2738:
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR 24[rax]
	mov	QWORD PTR -8[rbp], rax
	nop
.L2739:
	mov	rax, QWORD PTR -8[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZNK2FB8FILEINFO8ISHIDDENEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZNK2FB8FILEINFO8ISHIDDENEv
_ZNK2FB8FILEINFO8ISHIDDENEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	BYTE PTR -1[rbp], 0
.L2742:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 40
	mov	eax, DWORD PTR [rax]
	cdqe
	and	eax, 2
	test	rax, rax
	setne	al
	mov	BYTE PTR -1[rbp], al
	nop
.L2743:
	movzx	eax, BYTE PTR -1[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN2FB12HAPPLYHIDDENERK9FBUSTRINGRNS_8FILEINFOE;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN2FB12HAPPLYHIDDENERK9FBUSTRINGRNS_8FILEINFOE
_ZN2FB12HAPPLYHIDDENERK9FBUSTRINGRNS_8FILEINFOE:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
	nop
	pop	rbp
	ret
.L2746:
.L2747:
	.seh_endproc
	.def	_ZN2FB4STATERK9FBUSTRING;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN2FB4STATERK9FBUSTRING
_ZN2FB4STATERK9FBUSTRING:
	push	rbp
	.seh_pushreg	rbp
	sub	rsp, 464
	.seh_stackalloc	464
	lea	rbp, 128[rsp]
	.seh_setframe	rbp, 128
	.seh_endprologue
	mov	QWORD PTR 352[rbp], rcx
	mov	QWORD PTR 360[rbp], rdx
.L2749:
	lea	rax, 112[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	QWORD PTR 24[rax], 0
	mov	QWORD PTR 32[rax], 0
	mov	QWORD PTR 40[rax], 0
	lea	rdx, 112[rbp]
	mov	rax, QWORD PTR 360[rbp]
	mov	r8, rdx
	mov	edx, 1
	mov	rcx, rax
	call	fb_UStrFsStat
	mov	DWORD PTR 332[rbp], eax
	mov	eax, DWORD PTR 332[rbp]
	mov	DWORD PTR 328[rbp], eax
	cmp	DWORD PTR 328[rbp], 0
	je	.L2756
	lea	rax, 80[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	WORD PTR 70[rbp], 83
	mov	WORD PTR 72[rbp], 116
	mov	WORD PTR 74[rbp], 97
	mov	WORD PTR 76[rbp], 116
	mov	WORD PTR 78[rbp], 0
	lea	rdx, 70[rbp]
	lea	rax, 80[rbp]
	mov	DWORD PTR 32[rsp], 0
	movabs	r9, -9223372036854775804
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrAssign
	mov	eax, DWORD PTR 328[rbp]
	movsx	rdx, eax
	mov	r8, QWORD PTR 360[rbp]
	lea	rcx, 80[rbp]
	lea	rax, -80[rbp]
	mov	r9, r8
	mov	r8, rcx
	mov	rcx, rax
	call	_Z6FsFailIN2FB8FILEINFOEENS0_11FSERRORCODEERK9FBUSTRINGS5_
	mov	QWORD PTR 320[rbp], rax
	mov	rax, QWORD PTR 320[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 352[rbp]
	call	_ZN6ResultIN2FB8FILEINFOEN2FB7FSERROREEC1ERKS4_
	lea	rax, 80[rbp]
	mov	rcx, rax
	call	fb_UStrDelete
	lea	rax, -80[rbp]
	mov	rcx, rax
	call	_ZN6ResultIN2FB8FILEINFOEN2FB7FSERROREED1Ev
	jmp	.L2752
.L2751:
.L2756:
	nop
.L2753:
	lea	rdx, 112[rbp]
	mov	rax, QWORD PTR 360[rbp]
	mov	rcx, rax
	call	_ZN2FB12HAPPLYHIDDENERK9FBUSTRINGRNS_8FILEINFOE
	lea	rdx, 112[rbp]
	lea	rax, 160[rbp]
	mov	rcx, rax
	call	_Z2OkIN2FB8FILEINFOEN2FB7FSERROREERS1_
	mov	QWORD PTR 312[rbp], rax
	mov	rax, QWORD PTR 312[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 352[rbp]
	call	_ZN6ResultIN2FB8FILEINFOEN2FB7FSERROREEC1ERKS4_
	lea	rax, 160[rbp]
	mov	rcx, rax
	call	_ZN6ResultIN2FB8FILEINFOEN2FB7FSERROREED1Ev
	nop
.L2752:
	mov	rax, QWORD PTR 352[rbp]
	add	rsp, 464
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN2FB5LSTATERK9FBUSTRING;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN2FB5LSTATERK9FBUSTRING
_ZN2FB5LSTATERK9FBUSTRING:
	push	rbp
	.seh_pushreg	rbp
	sub	rsp, 464
	.seh_stackalloc	464
	lea	rbp, 128[rsp]
	.seh_setframe	rbp, 128
	.seh_endprologue
	mov	QWORD PTR 352[rbp], rcx
	mov	QWORD PTR 360[rbp], rdx
.L2758:
	lea	rax, 112[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	QWORD PTR 24[rax], 0
	mov	QWORD PTR 32[rax], 0
	mov	QWORD PTR 40[rax], 0
	lea	rdx, 112[rbp]
	mov	rax, QWORD PTR 360[rbp]
	mov	r8, rdx
	mov	edx, 0
	mov	rcx, rax
	call	fb_UStrFsStat
	mov	DWORD PTR 332[rbp], eax
	mov	eax, DWORD PTR 332[rbp]
	mov	DWORD PTR 328[rbp], eax
	cmp	DWORD PTR 328[rbp], 0
	je	.L2765
	lea	rax, 80[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	WORD PTR 68[rbp], 76
	mov	WORD PTR 70[rbp], 83
	mov	WORD PTR 72[rbp], 116
	mov	WORD PTR 74[rbp], 97
	mov	WORD PTR 76[rbp], 116
	mov	WORD PTR 78[rbp], 0
	lea	rdx, 68[rbp]
	lea	rax, 80[rbp]
	mov	DWORD PTR 32[rsp], 0
	movabs	r9, -9223372036854775803
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrAssign
	mov	eax, DWORD PTR 328[rbp]
	movsx	rdx, eax
	mov	r8, QWORD PTR 360[rbp]
	lea	rcx, 80[rbp]
	lea	rax, -80[rbp]
	mov	r9, r8
	mov	r8, rcx
	mov	rcx, rax
	call	_Z6FsFailIN2FB8FILEINFOEENS0_11FSERRORCODEERK9FBUSTRINGS5_
	mov	QWORD PTR 320[rbp], rax
	mov	rax, QWORD PTR 320[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 352[rbp]
	call	_ZN6ResultIN2FB8FILEINFOEN2FB7FSERROREEC1ERKS4_
	lea	rax, 80[rbp]
	mov	rcx, rax
	call	fb_UStrDelete
	lea	rax, -80[rbp]
	mov	rcx, rax
	call	_ZN6ResultIN2FB8FILEINFOEN2FB7FSERROREED1Ev
	jmp	.L2761
.L2760:
.L2765:
	nop
.L2762:
	lea	rdx, 112[rbp]
	mov	rax, QWORD PTR 360[rbp]
	mov	rcx, rax
	call	_ZN2FB12HAPPLYHIDDENERK9FBUSTRINGRNS_8FILEINFOE
	lea	rdx, 112[rbp]
	lea	rax, 160[rbp]
	mov	rcx, rax
	call	_Z2OkIN2FB8FILEINFOEN2FB7FSERROREERS1_
	mov	QWORD PTR 312[rbp], rax
	mov	rax, QWORD PTR 312[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 352[rbp]
	call	_ZN6ResultIN2FB8FILEINFOEN2FB7FSERROREEC1ERKS4_
	lea	rax, 160[rbp]
	mov	rcx, rax
	call	_ZN6ResultIN2FB8FILEINFOEN2FB7FSERROREED1Ev
	nop
.L2761:
	mov	rax, QWORD PTR 352[rbp]
	add	rsp, 464
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN2FB6EXISTSERK9FBUSTRING;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN2FB6EXISTSERK9FBUSTRING
_ZN2FB6EXISTSERK9FBUSTRING:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 96
	.seh_stackalloc	96
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	BYTE PTR -5[rbp], 0
.L2767:
	lea	rax, -64[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	QWORD PTR 24[rax], 0
	mov	QWORD PTR 32[rax], 0
	mov	QWORD PTR 40[rax], 0
	lea	rax, -64[rbp]
	mov	r8, rax
	mov	edx, 1
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_UStrFsStat
	mov	DWORD PTR -4[rbp], eax
	cmp	DWORD PTR -4[rbp], 0
	sete	al
	mov	BYTE PTR -5[rbp], al
	nop
.L2768:
	movzx	eax, BYTE PTR -5[rbp]
	add	rsp, 96
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN2FB5ISDIRERK9FBUSTRING;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN2FB5ISDIRERK9FBUSTRING
_ZN2FB5ISDIRERK9FBUSTRING:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 96
	.seh_stackalloc	96
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	BYTE PTR -6[rbp], 0
.L2771:
	lea	rax, -64[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	QWORD PTR 24[rax], 0
	mov	QWORD PTR 32[rax], 0
	mov	QWORD PTR 40[rax], 0
	lea	rax, -64[rbp]
	mov	r8, rax
	mov	edx, 1
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_UStrFsStat
	mov	DWORD PTR -4[rbp], eax
	cmp	DWORD PTR -4[rbp], 0
	je	.L2777
	mov	BYTE PTR -6[rbp], 0
	jmp	.L2774
.L2777:
	nop
.L2773:
	lea	rax, -64[rbp]
	mov	rcx, rax
	call	_ZNK2FB8FILEINFO11ISDIRECTORYEv
	mov	BYTE PTR -5[rbp], al
	movzx	eax, BYTE PTR -5[rbp]
	mov	BYTE PTR -6[rbp], al
	nop
.L2774:
	movzx	eax, BYTE PTR -6[rbp]
	add	rsp, 96
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN2FB12ABSOLUTEPATHERK9FBUSTRING;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN2FB12ABSOLUTEPATHERK9FBUSTRING
_ZN2FB12ABSOLUTEPATHERK9FBUSTRING:
	push	rbp
	.seh_pushreg	rbp
	sub	rsp, 416
	.seh_stackalloc	416
	lea	rbp, 128[rsp]
	.seh_setframe	rbp, 128
	.seh_endprologue
	mov	QWORD PTR 304[rbp], rcx
	mov	QWORD PTR 312[rbp], rdx
.L2779:
	mov	DWORD PTR 140[rbp], 0
	lea	rdx, 140[rbp]
	mov	rax, QWORD PTR 312[rbp]
	mov	rcx, rax
	call	fb_UStrFsAbsolutePath
	mov	QWORD PTR 280[rbp], rax
	mov	rdx, QWORD PTR 280[rbp]
	lea	rax, 112[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrInit
	mov	eax, DWORD PTR 140[rbp]
	test	eax, eax
	je	.L2786
	lea	rax, 80[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	WORD PTR 48[rbp], 65
	mov	WORD PTR 50[rbp], 98
	mov	WORD PTR 52[rbp], 115
	mov	WORD PTR 54[rbp], 111
	mov	WORD PTR 56[rbp], 108
	mov	WORD PTR 58[rbp], 117
	mov	WORD PTR 60[rbp], 116
	mov	WORD PTR 62[rbp], 101
	mov	WORD PTR 64[rbp], 80
	mov	WORD PTR 66[rbp], 97
	mov	WORD PTR 68[rbp], 116
	mov	WORD PTR 70[rbp], 104
	mov	WORD PTR 72[rbp], 0
	lea	rdx, 48[rbp]
	lea	rax, 80[rbp]
	mov	DWORD PTR 32[rsp], 0
	movabs	r9, -9223372036854775796
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrAssign
	mov	eax, DWORD PTR 140[rbp]
	movsx	rdx, eax
	mov	r8, QWORD PTR 312[rbp]
	lea	rcx, 80[rbp]
	lea	rax, -80[rbp]
	mov	r9, r8
	mov	r8, rcx
	mov	rcx, rax
	call	_Z6FsFailI9FBUSTRINGEN2FB11FSERRORCODEERKS0_S4_
	mov	QWORD PTR 272[rbp], rax
	mov	rax, QWORD PTR 272[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 304[rbp]
	call	_ZN6ResultI9FBUSTRINGN2FB7FSERROREEC1ERKS3_
	lea	rax, 80[rbp]
	mov	rcx, rax
	call	fb_UStrDelete
	lea	rax, -80[rbp]
	mov	rcx, rax
	call	_ZN6ResultI9FBUSTRINGN2FB7FSERROREED1Ev
	lea	rax, 112[rbp]
	mov	rcx, rax
	call	fb_UStrDelete
	jmp	.L2782
.L2781:
.L2786:
	nop
.L2783:
	lea	rdx, 112[rbp]
	lea	rax, 144[rbp]
	mov	rcx, rax
	call	_Z2OkI9FBUSTRINGN2FB7FSERROREERS0_
	mov	QWORD PTR 264[rbp], rax
	mov	rax, QWORD PTR 264[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 304[rbp]
	call	_ZN6ResultI9FBUSTRINGN2FB7FSERROREEC1ERKS3_
	lea	rax, 144[rbp]
	mov	rcx, rax
	call	_ZN6ResultI9FBUSTRINGN2FB7FSERROREED1Ev
	lea	rax, 112[rbp]
	mov	rcx, rax
	call	fb_UStrDelete
	nop
.L2782:
	mov	rax, QWORD PTR 304[rbp]
	add	rsp, 416
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN2FB8DIRENTRYC1Ev;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN2FB8DIRENTRYC1Ev
_ZN2FB8DIRENTRYC1Ev:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	rax, QWORD PTR 16[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 24
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 48
	mov	DWORD PTR [rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 52
	mov	DWORD PTR [rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 56
	mov	DWORD PTR [rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 64
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	QWORD PTR 24[rax], 0
	mov	QWORD PTR 32[rax], 0
	mov	QWORD PTR 40[rax], 0
	nop
	pop	rbp
	ret
.L2788:
.L2789:
	.seh_endproc
	.def	_ZN2FB8DIRENTRYaSERKS0_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN2FB8DIRENTRYaSERKS0_
_ZN2FB8DIRENTRYaSERKS0_:
	push	rbp
	.seh_pushreg	rbp
	push	rbx
	.seh_pushreg	rbx
	sub	rsp, 56
	.seh_stackalloc	56
	lea	rbp, 128[rsp]
	.seh_setframe	rbp, 128
	.seh_endprologue
	mov	QWORD PTR -48[rbp], rcx
	mov	QWORD PTR -40[rbp], rdx
.L2791:
	mov	rax, QWORD PTR -40[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rax
	mov	rdx, -1
	mov	rcx, QWORD PTR -48[rbp]
	call	fb_UStrAssign
	mov	rax, QWORD PTR -40[rbp]
	lea	rdx, 24[rax]
	mov	rax, QWORD PTR -48[rbp]
	add	rax, 24
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrAssign
	mov	rax, QWORD PTR -48[rbp]
	lea	rdx, 48[rax]
	mov	rax, QWORD PTR -40[rbp]
	mov	eax, DWORD PTR 48[rax]
	mov	DWORD PTR [rdx], eax
	mov	rax, QWORD PTR -48[rbp]
	lea	rdx, 52[rax]
	mov	rax, QWORD PTR -40[rbp]
	mov	eax, DWORD PTR 52[rax]
	mov	DWORD PTR [rdx], eax
	mov	rax, QWORD PTR -48[rbp]
	lea	rdx, 56[rax]
	mov	rax, QWORD PTR -40[rbp]
	mov	eax, DWORD PTR 56[rax]
	mov	DWORD PTR [rdx], eax
	mov	rax, QWORD PTR -40[rbp]
	lea	rdx, 64[rax]
	mov	rax, QWORD PTR -48[rbp]
	add	rax, 64
	mov	rcx, QWORD PTR [rdx]
	mov	rbx, QWORD PTR 8[rdx]
	mov	QWORD PTR [rax], rcx
	mov	QWORD PTR 8[rax], rbx
	mov	rcx, QWORD PTR 16[rdx]
	mov	rbx, QWORD PTR 24[rdx]
	mov	QWORD PTR 16[rax], rcx
	mov	QWORD PTR 24[rax], rbx
	mov	rcx, QWORD PTR 32[rdx]
	mov	rbx, QWORD PTR 40[rdx]
	mov	QWORD PTR 32[rax], rcx
	mov	QWORD PTR 40[rax], rbx
	nop
	add	rsp, 56
	pop	rbx
	pop	rbp
	ret
.L2792:
	.seh_endproc
	.def	_ZN2FB8DIRENTRYC1ERKS0_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN2FB8DIRENTRYC1ERKS0_
_ZN2FB8DIRENTRYC1ERKS0_:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
.L2794:
	mov	rax, QWORD PTR 16[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 24
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 48
	mov	DWORD PTR [rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 52
	mov	DWORD PTR [rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 56
	mov	DWORD PTR [rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 64
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	QWORD PTR 24[rax], 0
	mov	QWORD PTR 32[rax], 0
	mov	QWORD PTR 40[rax], 0
	mov	rax, QWORD PTR 24[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN2FB8DIRENTRYaSERKS0_
	nop
	add	rsp, 32
	pop	rbp
	ret
.L2795:
	.seh_endproc
	.def	_ZN2FB8DIRENTRYD1Ev;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN2FB8DIRENTRYD1Ev
_ZN2FB8DIRENTRYD1Ev:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
.L2797:
.L2798:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 24
	mov	rcx, rax
	call	fb_UStrDelete
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_UStrDelete
	nop
	add	rsp, 32
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN6ResultIN2FB8DIRENTRYEN2FB7FSERROREEC1Ev;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN6ResultIN2FB8DIRENTRYEN2FB7FSERROREEC1Ev
_ZN6ResultIN2FB8DIRENTRYEN2FB7FSERROREEC1Ev:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN2FB8DIRENTRYC1Ev
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 112
	mov	rcx, rax
	call	_ZN2FB7FSERRORC1Ev
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 200
	mov	BYTE PTR [rax], 0
	nop
	add	rsp, 32
	pop	rbp
	ret
.L2800:
.L2801:
	.seh_endproc
	.def	_ZN6ResultIN2FB8DIRENTRYEN2FB7FSERROREEaSERKS4_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN6ResultIN2FB8DIRENTRYEN2FB7FSERROREEaSERKS4_
_ZN6ResultIN2FB8DIRENTRYEN2FB7FSERROREEaSERKS4_:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
.L2803:
	mov	rax, QWORD PTR 24[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN2FB8DIRENTRYaSERKS0_
	mov	rax, QWORD PTR 24[rbp]
	lea	rdx, 112[rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 112
	mov	rcx, rax
	call	_ZN2FB7FSERRORaSERKS0_
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 200[rax]
	mov	rax, QWORD PTR 24[rbp]
	movzx	eax, BYTE PTR 200[rax]
	mov	BYTE PTR [rdx], al
	nop
	add	rsp, 32
	pop	rbp
	ret
.L2804:
	.seh_endproc
	.def	_ZN6ResultIN2FB8DIRENTRYEN2FB7FSERROREEC1ERKS4_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN6ResultIN2FB8DIRENTRYEN2FB7FSERROREEC1ERKS4_
_ZN6ResultIN2FB8DIRENTRYEN2FB7FSERROREEC1ERKS4_:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
.L2806:
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN2FB8DIRENTRYC1Ev
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 112
	mov	rcx, rax
	call	_ZN2FB7FSERRORC1Ev
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 200
	mov	BYTE PTR [rax], 0
	mov	rax, QWORD PTR 24[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN6ResultIN2FB8DIRENTRYEN2FB7FSERROREEaSERKS4_
	nop
	add	rsp, 32
	pop	rbp
	ret
.L2807:
	.seh_endproc
	.def	_ZN6ResultIN2FB8DIRENTRYEN2FB7FSERROREED1Ev;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN6ResultIN2FB8DIRENTRYEN2FB7FSERROREED1Ev
_ZN6ResultIN2FB8DIRENTRYEN2FB7FSERROREED1Ev:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
.L2809:
.L2810:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 112
	mov	rcx, rax
	call	_ZN2FB7FSERRORD1Ev
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN2FB8DIRENTRYD1Ev
	nop
	add	rsp, 32
	pop	rbp
	ret
	.seh_endproc
	.def	_ZNK2FB8DIRENTRY4NAMEEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZNK2FB8DIRENTRY4NAMEEv
_ZNK2FB8DIRENTRY4NAMEEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 80
	.seh_stackalloc	80
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	lea	rax, -32[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
.L2812:
	lea	rax, -32[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, QWORD PTR 16[rbp]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrInit
	nop
.L2813:
	lea	rax, -32[rbp]
	mov	rcx, rax
	call	fb_UStrAllocTempResult
	mov	QWORD PTR -8[rbp], rax
	mov	rax, QWORD PTR -8[rbp]
	add	rsp, 80
	pop	rbp
	ret
	.seh_endproc
	.def	_ZNK2FB8DIRENTRY4PATHEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZNK2FB8DIRENTRY4PATHEv
_ZNK2FB8DIRENTRY4PATHEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 80
	.seh_stackalloc	80
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	lea	rax, -32[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
.L2816:
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 24[rax]
	lea	rax, -32[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrInit
	nop
.L2817:
	lea	rax, -32[rbp]
	mov	rcx, rax
	call	fb_UStrAllocTempResult
	mov	QWORD PTR -8[rbp], rax
	mov	rax, QWORD PTR -8[rbp]
	add	rsp, 80
	pop	rbp
	ret
	.seh_endproc
	.def	_ZNK2FB8DIRENTRY5DEPTHEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZNK2FB8DIRENTRY5DEPTHEv
_ZNK2FB8DIRENTRY5DEPTHEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR -4[rbp], 0
.L2820:
	mov	rax, QWORD PTR 16[rbp]
	mov	eax, DWORD PTR 52[rax]
	mov	DWORD PTR -4[rbp], eax
	nop
.L2821:
	mov	eax, DWORD PTR -4[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZNK2FB8DIRENTRY11ISDIRECTORYEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZNK2FB8DIRENTRY11ISDIRECTORYEv
_ZNK2FB8DIRENTRY11ISDIRECTORYEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	BYTE PTR -1[rbp], 0
.L2824:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 48
	mov	eax, DWORD PTR [rax]
	cmp	eax, 2
	sete	al
	mov	BYTE PTR -1[rbp], al
	nop
.L2825:
	movzx	eax, BYTE PTR -1[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZNK2FB8DIRENTRY9ISSYMLINKEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZNK2FB8DIRENTRY9ISSYMLINKEv
_ZNK2FB8DIRENTRY9ISSYMLINKEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	BYTE PTR -1[rbp], 0
.L2828:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 48
	mov	eax, DWORD PTR [rax]
	cmp	eax, 3
	sete	al
	mov	BYTE PTR -1[rbp], al
	nop
.L2829:
	movzx	eax, BYTE PTR -1[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN2FB11DIRITERATORC1Ev;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN2FB11DIRITERATORC1Ev
_ZN2FB11DIRITERATORC1Ev:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	rax, QWORD PTR 16[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 24
	mov	QWORD PTR [rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 32
	mov	BYTE PTR [rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 33
	mov	BYTE PTR [rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 40
	mov	rcx, rax
	call	_ZN6ResultIN2FB8DIRENTRYEN2FB7FSERROREEC1Ev
	nop
	add	rsp, 32
	pop	rbp
	ret
.L2832:
.L2833:
	.seh_endproc
	.def	_ZN2FB11DIRITERATORaSERKS0_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN2FB11DIRITERATORaSERKS0_
_ZN2FB11DIRITERATORaSERKS0_:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 48
	.seh_stackalloc	48
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
.L2835:
	mov	rax, QWORD PTR 24[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rax
	mov	rdx, -1
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_UStrAssign
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 24[rax]
	mov	rax, QWORD PTR 24[rbp]
	mov	rax, QWORD PTR 24[rax]
	mov	QWORD PTR [rdx], rax
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 32[rax]
	mov	rax, QWORD PTR 24[rbp]
	movzx	eax, BYTE PTR 32[rax]
	mov	BYTE PTR [rdx], al
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 33[rax]
	mov	rax, QWORD PTR 24[rbp]
	movzx	eax, BYTE PTR 33[rax]
	mov	BYTE PTR [rdx], al
	mov	rax, QWORD PTR 24[rbp]
	lea	rdx, 40[rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 40
	mov	rcx, rax
	call	_ZN6ResultIN2FB8DIRENTRYEN2FB7FSERROREEaSERKS4_
	nop
	add	rsp, 48
	pop	rbp
	ret
.L2836:
	.seh_endproc
	.def	_ZN2FB11DIRITERATORC1ERKS0_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN2FB11DIRITERATORC1ERKS0_
_ZN2FB11DIRITERATORC1ERKS0_:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
.L2838:
	mov	rax, QWORD PTR 16[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 24
	mov	QWORD PTR [rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 32
	mov	BYTE PTR [rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 33
	mov	BYTE PTR [rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 40
	mov	rcx, rax
	call	_ZN6ResultIN2FB8DIRENTRYEN2FB7FSERROREEC1Ev
	mov	rax, QWORD PTR 24[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN2FB11DIRITERATORaSERKS0_
	nop
	add	rsp, 32
	pop	rbp
	ret
.L2839:
	.seh_endproc
	.def	_ZN2FB11DIRITERATOR5HOPENEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN2FB11DIRITERATOR5HOPENEv
_ZN2FB11DIRITERATOR5HOPENEv:
	push	rbp
	.seh_pushreg	rbp
	sub	rsp, 320
	.seh_stackalloc	320
	lea	rbp, 128[rsp]
	.seh_setframe	rbp, 128
	.seh_endprologue
	mov	QWORD PTR 208[rbp], rcx
.L2841:
	mov	rax, QWORD PTR 208[rbp]
	add	rax, 32
	movzx	eax, BYTE PTR [rax]
	test	al, al
	jne	.L2849
	nop
.L2843:
	mov	rax, QWORD PTR 208[rbp]
	add	rax, 32
	mov	BYTE PTR [rax], 1
	mov	rax, QWORD PTR 208[rbp]
	add	rax, 24
	mov	rdx, rax
	mov	rcx, QWORD PTR 208[rbp]
	call	fb_UStrFsDirOpen
	mov	DWORD PTR 188[rbp], eax
	mov	eax, DWORD PTR 188[rbp]
	mov	DWORD PTR 184[rbp], eax
	cmp	DWORD PTR 184[rbp], 0
	je	.L2850
	mov	rax, QWORD PTR 208[rbp]
	add	rax, 24
	mov	QWORD PTR [rax], 0
	mov	rax, QWORD PTR 208[rbp]
	add	rax, 33
	mov	BYTE PTR [rax], 1
	lea	rax, 144[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	WORD PTR 128[rbp], 82
	mov	WORD PTR 130[rbp], 101
	mov	WORD PTR 132[rbp], 97
	mov	WORD PTR 134[rbp], 100
	mov	WORD PTR 136[rbp], 68
	mov	WORD PTR 138[rbp], 105
	mov	WORD PTR 140[rbp], 114
	mov	WORD PTR 142[rbp], 0
	lea	rdx, 128[rbp]
	lea	rax, 144[rbp]
	mov	DWORD PTR 32[rsp], 0
	movabs	r9, -9223372036854775801
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrAssign
	mov	eax, DWORD PTR 184[rbp]
	movsx	rdx, eax
	lea	rcx, 144[rbp]
	lea	rax, -80[rbp]
	mov	r9, QWORD PTR 208[rbp]
	mov	r8, rcx
	mov	rcx, rax
	call	_Z6FsFailIN2FB8DIRENTRYEENS0_11FSERRORCODEERK9FBUSTRINGS5_
	mov	QWORD PTR 176[rbp], rax
	mov	rax, QWORD PTR 208[rbp]
	lea	rcx, 40[rax]
	mov	rax, QWORD PTR 176[rbp]
	mov	rdx, rax
	call	_ZN6ResultIN2FB8DIRENTRYEN2FB7FSERROREEaSERKS4_
	lea	rax, 144[rbp]
	mov	rcx, rax
	call	fb_UStrDelete
	lea	rax, -80[rbp]
	mov	rcx, rax
	call	_ZN6ResultIN2FB8DIRENTRYEN2FB7FSERROREED1Ev
	jmp	.L2851
.L2846:
.L2850:
	nop
.L2847:
	mov	rcx, QWORD PTR 208[rbp]
	call	_ZN2FB11DIRITERATOR6HFETCHEv
	jmp	.L2851
.L2849:
	nop
.L2844:
.L2851:
	nop
	add	rsp, 320
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN2FB11DIRITERATOR6HFETCHEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN2FB11DIRITERATOR6HFETCHEv
_ZN2FB11DIRITERATOR6HFETCHEv:
	push	rbp
	.seh_pushreg	rbp
	push	rdi
	.seh_pushreg	rdi
	push	rbx
	.seh_pushreg	rbx
	sub	rsp, 1296
	.seh_stackalloc	1296
	lea	rbp, 128[rsp]
	.seh_setframe	rbp, 128
	.seh_endprologue
	mov	QWORD PTR 1200[rbp], rcx
.L2853:
	lea	rax, 320[rbp]
	mov	r8, rax
	mov	eax, 0
	mov	edx, 73
	mov	rdi, r8
	mov	rcx, rdx
	rep stosq
	mov	rax, QWORD PTR 1200[rbp]
	add	rax, 24
	mov	rax, QWORD PTR [rax]
	lea	rdx, 320[rbp]
	mov	rcx, rax
	call	fb_FsDirRead
	mov	DWORD PTR 1164[rbp], eax
	mov	eax, DWORD PTR 1164[rbp]
	mov	DWORD PTR 1160[rbp], eax
	cmp	DWORD PTR 1160[rbp], -1
	jne	.L2863
	mov	rax, QWORD PTR 1200[rbp]
	add	rax, 33
	mov	BYTE PTR [rax], 0
	nop
.L2856:
	jmp	.L2865
.L2855:
.L2863:
	nop
.L2857:
	cmp	DWORD PTR 1160[rbp], 0
	je	.L2864
	mov	rax, QWORD PTR 1200[rbp]
	add	rax, 33
	mov	BYTE PTR [rax], 1
	lea	rax, 144[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	WORD PTR 128[rbp], 82
	mov	WORD PTR 130[rbp], 101
	mov	WORD PTR 132[rbp], 97
	mov	WORD PTR 134[rbp], 100
	mov	WORD PTR 136[rbp], 68
	mov	WORD PTR 138[rbp], 105
	mov	WORD PTR 140[rbp], 114
	mov	WORD PTR 142[rbp], 0
	lea	rdx, 128[rbp]
	lea	rax, 144[rbp]
	mov	DWORD PTR 32[rsp], 0
	movabs	r9, -9223372036854775801
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrAssign
	mov	eax, DWORD PTR 1160[rbp]
	movsx	rdx, eax
	lea	rcx, 144[rbp]
	lea	rax, -80[rbp]
	mov	r9, QWORD PTR 1200[rbp]
	mov	r8, rcx
	mov	rcx, rax
	call	_Z6FsFailIN2FB8DIRENTRYEENS0_11FSERRORCODEERK9FBUSTRINGS5_
	mov	QWORD PTR 1152[rbp], rax
	mov	rax, QWORD PTR 1200[rbp]
	lea	rcx, 40[rax]
	mov	rax, QWORD PTR 1152[rbp]
	mov	rdx, rax
	call	_ZN6ResultIN2FB8DIRENTRYEN2FB7FSERROREEaSERKS4_
	lea	rax, 144[rbp]
	mov	rcx, rax
	call	fb_UStrDelete
	lea	rax, -80[rbp]
	mov	rcx, rax
	call	_ZN6ResultIN2FB8DIRENTRYEN2FB7FSERROREED1Ev
	jmp	.L2865
.L2859:
.L2864:
	nop
.L2860:
	lea	rax, 208[rbp]
	mov	rcx, rax
	call	_ZN2FB8DIRENTRYC1Ev
	lea	rax, 320[rbp]
	mov	rcx, rax
	call	fb_UStrFsDirEntName
	mov	QWORD PTR 1144[rbp], rax
	mov	rdx, QWORD PTR 1144[rbp]
	lea	rax, 176[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrInit
	lea	rdx, 176[rbp]
	lea	rax, 208[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrAssign
	lea	rax, 176[rbp]
	mov	r8d, 1
	mov	rdx, rax
	mov	rcx, QWORD PTR 1200[rbp]
	call	fb_UStrPathJoin2
	mov	QWORD PTR 1136[rbp], rax
	lea	rax, 208[rbp]
	add	rax, 24
	mov	rdx, QWORD PTR 1136[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrAssign
	lea	rax, 208[rbp]
	add	rax, 48
	mov	edx, DWORD PTR 844[rbp]
	mov	DWORD PTR [rax], edx
	lea	rax, 208[rbp]
	add	rax, 52
	mov	DWORD PTR [rax], 0
	lea	rax, 208[rbp]
	add	rax, 56
	mov	edx, DWORD PTR 848[rbp]
	mov	DWORD PTR [rax], edx
	lea	rdx, 320[rbp]
	add	rdx, 536
	lea	rax, 208[rbp]
	add	rax, 64
	mov	rcx, QWORD PTR [rdx]
	mov	rbx, QWORD PTR 8[rdx]
	mov	QWORD PTR [rax], rcx
	mov	QWORD PTR 8[rax], rbx
	mov	rcx, QWORD PTR 16[rdx]
	mov	rbx, QWORD PTR 24[rdx]
	mov	QWORD PTR 16[rax], rcx
	mov	QWORD PTR 24[rax], rbx
	mov	rcx, QWORD PTR 32[rdx]
	mov	rbx, QWORD PTR 40[rdx]
	mov	QWORD PTR 32[rax], rcx
	mov	QWORD PTR 40[rax], rbx
	mov	rax, QWORD PTR 1200[rbp]
	add	rax, 33
	mov	BYTE PTR [rax], 1
	lea	rdx, 208[rbp]
	lea	rax, 912[rbp]
	mov	rcx, rax
	call	_Z2OkIN2FB8DIRENTRYEN2FB7FSERROREERS1_
	mov	QWORD PTR 1128[rbp], rax
	mov	rax, QWORD PTR 1200[rbp]
	lea	rcx, 40[rax]
	mov	rax, QWORD PTR 1128[rbp]
	mov	rdx, rax
	call	_ZN6ResultIN2FB8DIRENTRYEN2FB7FSERROREEaSERKS4_
	lea	rax, 912[rbp]
	mov	rcx, rax
	call	_ZN6ResultIN2FB8DIRENTRYEN2FB7FSERROREED1Ev
	lea	rax, 176[rbp]
	mov	rcx, rax
	call	fb_UStrDelete
	lea	rax, 208[rbp]
	mov	rcx, rax
	call	_ZN2FB8DIRENTRYD1Ev
.L2865:
	nop
	add	rsp, 1296
	pop	rbx
	pop	rdi
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN2FB11DIRITERATOR7ISVALIDEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN2FB11DIRITERATOR7ISVALIDEv
_ZN2FB11DIRITERATOR7ISVALIDEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 48
	.seh_stackalloc	48
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	BYTE PTR -1[rbp], 0
.L2867:
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN2FB11DIRITERATOR5HOPENEv
	mov	rax, QWORD PTR 16[rbp]
	movzx	eax, BYTE PTR 33[rax]
	mov	BYTE PTR -1[rbp], al
	nop
.L2868:
	movzx	eax, BYTE PTR -1[rbp]
	add	rsp, 48
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN2FB11DIRITERATOR5VALUEEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN2FB11DIRITERATOR5VALUEEv
_ZN2FB11DIRITERATOR5VALUEEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 48
	.seh_stackalloc	48
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR -8[rbp], 0
.L2871:
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN2FB11DIRITERATOR5HOPENEv
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 40
	mov	QWORD PTR -8[rbp], rax
	nop
.L2872:
	mov	rax, QWORD PTR -8[rbp]
	add	rsp, 48
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN2FB11DIRITERATOR8MOVENEXTEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN2FB11DIRITERATOR8MOVENEXTEv
_ZN2FB11DIRITERATOR8MOVENEXTEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
.L2875:
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN2FB11DIRITERATOR5HOPENEv
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 24
	mov	rax, QWORD PTR [rax]
	test	rax, rax
	jne	.L2881
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 33
	mov	BYTE PTR [rax], 0
	jmp	.L2878
.L2877:
.L2881:
	nop
.L2879:
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN2FB11DIRITERATOR6HFETCHEv
	nop
.L2878:
	nop
	add	rsp, 32
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN2FB11DIRITERATORD1Ev;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN2FB11DIRITERATORD1Ev
_ZN2FB11DIRITERATORD1Ev:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
.L2883:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 24
	mov	rax, QWORD PTR [rax]
	test	rax, rax
	je	.L2888
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 24
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	fb_FsDirClose
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 24
	mov	QWORD PTR [rax], 0
	jmp	.L2887
.L2885:
.L2886:
.L2888:
	nop
.L2887:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 40
	mov	rcx, rax
	call	_ZN6ResultIN2FB8DIRENTRYEN2FB7FSERROREED1Ev
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_UStrDelete
	nop
	add	rsp, 32
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN2FB8DIRRANGEC1Ev;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN2FB8DIRRANGEC1Ev
_ZN2FB8DIRRANGEC1Ev:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	rax, QWORD PTR 16[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	nop
	pop	rbp
	ret
.L2890:
.L2891:
	.seh_endproc
	.def	_ZN2FB8DIRRANGEaSERKS0_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN2FB8DIRRANGEaSERKS0_
_ZN2FB8DIRRANGEaSERKS0_:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 48
	.seh_stackalloc	48
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
.L2893:
	mov	rax, QWORD PTR 24[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rax
	mov	rdx, -1
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_UStrAssign
	nop
	add	rsp, 48
	pop	rbp
	ret
.L2894:
	.seh_endproc
	.def	_ZN2FB8DIRRANGEC1ERKS0_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN2FB8DIRRANGEC1ERKS0_
_ZN2FB8DIRRANGEC1ERKS0_:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
.L2896:
	mov	rax, QWORD PTR 16[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	rax, QWORD PTR 24[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN2FB8DIRRANGEaSERKS0_
	nop
	add	rsp, 32
	pop	rbp
	ret
.L2897:
	.seh_endproc
	.def	_ZN2FB8DIRRANGED1Ev;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN2FB8DIRRANGED1Ev
_ZN2FB8DIRRANGED1Ev:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
.L2899:
.L2900:
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_UStrDelete
	nop
	add	rsp, 32
	pop	rbp
	ret
	.seh_endproc
	.def	_ZNK2FB8DIRRANGE11GETITERATOREv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZNK2FB8DIRRANGE11GETITERATOREv
_ZNK2FB8DIRRANGE11GETITERATOREv:
	push	rbp
	.seh_pushreg	rbp
	sub	rsp, 304
	.seh_stackalloc	304
	lea	rbp, 128[rsp]
	.seh_setframe	rbp, 128
	.seh_endprologue
	mov	QWORD PTR 192[rbp], rcx
	mov	QWORD PTR 200[rbp], rdx
.L2902:
	lea	rax, -80[rbp]
	mov	rcx, rax
	call	_ZN2FB11DIRITERATORC1Ev
	mov	rdx, QWORD PTR 200[rbp]
	lea	rax, -80[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrAssign
	lea	rax, -80[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 192[rbp]
	call	_ZN2FB11DIRITERATORC1ERKS0_
	lea	rax, -80[rbp]
	mov	rcx, rax
	call	_ZN2FB11DIRITERATORD1Ev
	nop
.L2903:
	mov	rax, QWORD PTR 192[rbp]
	add	rsp, 304
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN2FB7READDIRERK9FBUSTRING;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN2FB7READDIRERK9FBUSTRING
_ZN2FB7READDIRERK9FBUSTRING:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 80
	.seh_stackalloc	80
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
.L2906:
	lea	rax, -32[rbp]
	mov	rcx, rax
	call	_ZN2FB8DIRRANGEC1Ev
	mov	rdx, QWORD PTR 24[rbp]
	lea	rax, -32[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrAssign
	lea	rax, -32[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN2FB8DIRRANGEC1ERKS0_
	lea	rax, -32[rbp]
	mov	rcx, rax
	call	_ZN2FB8DIRRANGED1Ev
	nop
.L2907:
	mov	rax, QWORD PTR 16[rbp]
	add	rsp, 80
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN2FB8DIRENTRYEEC1Ev;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN2FB8DIRENTRYEEC1Ev
_ZN5ArrayIN2FB8DIRENTRYEEC1Ev:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	rax, QWORD PTR 16[rbp]
	mov	QWORD PTR [rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	QWORD PTR [rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 16
	mov	QWORD PTR [rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 24
	mov	QWORD PTR [rax], 112
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 32
	mov	QWORD PTR [rax], 1
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 40
	mov	QWORD PTR [rax], 17
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 48
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	DWORD PTR [rax], 0
	nop
	pop	rbp
	ret
.L2910:
.L2911:
	.seh_endproc
	.def	_ZN5ArrayIN2FB8DIRENTRYEEaSERKS2_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN2FB8DIRENTRYEEaSERKS2_
_ZN5ArrayIN2FB8DIRENTRYEEaSERKS2_:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 80
	.seh_stackalloc	80
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
.L2913:
	mov	rax, QWORD PTR 24[rbp]
	lea	rdx, _ZN2FB8DIRENTRYD1Ev[rip]
	mov	QWORD PTR 32[rsp], rdx
	lea	r9, _ZN2FB8DIRENTRYC1Ev[rip]
	mov	r8d, 0
	mov	rdx, rax
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayRedimTo
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR 8[rax]
	mov	QWORD PTR -8[rbp], rax
	mov	rax, QWORD PTR 24[rbp]
	mov	rax, QWORD PTR 8[rax]
	mov	QWORD PTR -16[rbp], rax
	mov	rax, QWORD PTR 24[rbp]
	add	rax, 16
	mov	rdx, QWORD PTR [rax]
	mov	rax, QWORD PTR -16[rbp]
	add	rax, rdx
	mov	QWORD PTR -24[rbp], rax
.L2914:
	mov	rax, QWORD PTR -16[rbp]
	cmp	rax, QWORD PTR -24[rbp]
	jnb	.L2919
	mov	rdx, QWORD PTR -16[rbp]
	mov	rax, QWORD PTR -8[rbp]
	mov	rcx, rax
	call	_ZN2FB8DIRENTRYaSERKS0_
	add	QWORD PTR -8[rbp], 112
	add	QWORD PTR -16[rbp], 112
	jmp	.L2914
.L2919:
	nop
.L2916:
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 72[rax]
	mov	rax, QWORD PTR 24[rbp]
	mov	eax, DWORD PTR 72[rax]
	mov	DWORD PTR [rdx], eax
	nop
	add	rsp, 80
	pop	rbp
	ret
.L2917:
	.seh_endproc
	.def	_ZN5ArrayIN2FB8DIRENTRYEED1Ev;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN2FB8DIRENTRYEED1Ev
_ZN5ArrayIN2FB8DIRENTRYEED1Ev:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
.L2921:
.L2922:
	lea	r8, _ZN2FB8DIRENTRYD1Ev[rip]
	lea	rdx, _ZN2FB8DIRENTRYC1Ev[rip]
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayEraseObj
	nop
	add	rsp, 32
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN2FB7LISTDIRERK9FBUSTRINGR5ArrayIN2FB8DIRENTRYEE;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN2FB7LISTDIRERK9FBUSTRINGR5ArrayIN2FB8DIRENTRYEE
_ZN2FB7LISTDIRERK9FBUSTRINGR5ArrayIN2FB8DIRENTRYEE:
	push	rbp
	.seh_pushreg	rbp
	sub	rsp, 816
	.seh_stackalloc	816
	lea	rbp, 128[rsp]
	.seh_setframe	rbp, 128
	.seh_endprologue
	mov	QWORD PTR 704[rbp], rcx
	mov	QWORD PTR 712[rbp], rdx
	mov	QWORD PTR 720[rbp], r8
.L2924:
	mov	DWORD PTR 508[rbp], 0
	mov	rax, QWORD PTR 720[rbp]
	mov	rcx, rax
	call	_ZN5ArrayIN2FB8DIRENTRYEE5CLEAREv
	mov	rdx, QWORD PTR 712[rbp]
	lea	rax, 480[rbp]
	mov	rcx, rax
	call	_ZN2FB7READDIRERK9FBUSTRING
	mov	QWORD PTR 680[rbp], rax
	mov	rdx, QWORD PTR 680[rbp]
	lea	rax, 224[rbp]
	mov	rcx, rax
	call	_ZNK2FB8DIRRANGE11GETITERATOREv
	lea	rax, 480[rbp]
	mov	rcx, rax
	call	_ZN2FB8DIRRANGED1Ev
	jmp	.L2925
.L2937:
	nop
.L2926:
	lea	rax, 224[rbp]
	mov	rcx, rax
	call	_ZN2FB11DIRITERATOR5VALUEEv
	mov	QWORD PTR 656[rbp], rax
	mov	rdx, QWORD PTR 656[rbp]
	lea	rax, 16[rbp]
	mov	rcx, rax
	call	_ZN6ResultIN2FB8DIRENTRYEN2FB7FSERROREEC1ERKS4_
	lea	rax, 16[rbp]
	mov	rcx, rax
	call	_ZN6ResultIN2FB8DIRENTRYEN2FB7FSERROREE4ISOKEv
	mov	BYTE PTR 655[rbp], al
	cmp	BYTE PTR 655[rbp], 0
	jne	.L2936
	lea	rax, 16[rbp]
	mov	rcx, rax
	call	_ZN6ResultIN2FB8DIRENTRYEN2FB7FSERROREE7FAILUREEv
	mov	QWORD PTR 640[rbp], rax
	mov	rdx, QWORD PTR 640[rbp]
	lea	rax, -96[rbp]
	mov	rcx, rax
	call	_Z4FailIiN2FB7FSERROREERS1_
	mov	QWORD PTR 632[rbp], rax
	mov	rax, QWORD PTR 632[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 704[rbp]
	call	_ZN6ResultIiN2FB7FSERROREEC1ERKS2_
	lea	rax, -96[rbp]
	mov	rcx, rax
	call	_ZN6ResultIiN2FB7FSERROREED1Ev
	lea	rax, 16[rbp]
	mov	rcx, rax
	call	_ZN6ResultIN2FB8DIRENTRYEN2FB7FSERROREED1Ev
	lea	rax, 224[rbp]
	mov	rcx, rax
	call	_ZN2FB11DIRITERATORD1Ev
	jmp	.L2929
.L2928:
.L2936:
	nop
.L2930:
	lea	rax, 16[rbp]
	mov	rcx, rax
	call	_ZN6ResultIN2FB8DIRENTRYEN2FB7FSERROREE5VALUEEv
	mov	QWORD PTR 624[rbp], rax
	mov	rdx, QWORD PTR 624[rbp]
	mov	rax, QWORD PTR 720[rbp]
	mov	rcx, rax
	call	_ZN5ArrayIN2FB8DIRENTRYEE4PUSHERS1_
	mov	eax, DWORD PTR 508[rbp]
	add	eax, 1
	mov	DWORD PTR 508[rbp], eax
	lea	rax, 16[rbp]
	mov	rcx, rax
	call	_ZN6ResultIN2FB8DIRENTRYEN2FB7FSERROREED1Ev
.L2931:
	lea	rax, 224[rbp]
	mov	rcx, rax
	call	_ZN2FB11DIRITERATOR8MOVENEXTEv
.L2925:
	lea	rax, 224[rbp]
	mov	rcx, rax
	call	_ZN2FB11DIRITERATOR7ISVALIDEv
	mov	BYTE PTR 679[rbp], al
	movsx	eax, BYTE PTR 679[rbp]
	neg	eax
	test	eax, eax
	jne	.L2937
	nop
.L2932:
	lea	rax, 224[rbp]
	mov	rcx, rax
	call	_ZN2FB11DIRITERATORD1Ev
	lea	rdx, 508[rbp]
	lea	rax, 512[rbp]
	mov	rcx, rax
	call	_Z2OkIiN2FB7FSERROREERi
	mov	QWORD PTR 664[rbp], rax
	mov	rax, QWORD PTR 664[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 704[rbp]
	call	_ZN6ResultIiN2FB7FSERROREEC1ERKS2_
	lea	rax, 512[rbp]
	mov	rcx, rax
	call	_ZN6ResultIiN2FB7FSERROREED1Ev
	nop
.L2929:
	mov	rax, QWORD PTR 704[rbp]
	add	rsp, 816
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN2FB11WALKOPTIONSC1Ev;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN2FB11WALKOPTIONSC1Ev
_ZN2FB11WALKOPTIONSC1Ev:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
.L2939:
	mov	rax, QWORD PTR 16[rbp]
	mov	BYTE PTR [rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 1
	mov	BYTE PTR [rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 2
	mov	BYTE PTR [rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 3
	mov	BYTE PTR [rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 4
	mov	DWORD PTR [rax], 0
	mov	rax, QWORD PTR 16[rbp]
	mov	BYTE PTR [rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 1
	mov	BYTE PTR [rax], 1
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 2
	mov	BYTE PTR [rax], 1
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 3
	mov	BYTE PTR [rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 4
	mov	DWORD PTR [rax], 0
	nop
	pop	rbp
	ret
.L2940:
	.seh_endproc
	.def	_ZN2FB12WALKITERATORC1Ev;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN2FB12WALKITERATORC1Ev
_ZN2FB12WALKITERATORC1Ev:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	rax, QWORD PTR 16[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 24
	mov	rcx, rax
	call	_ZN2FB11WALKOPTIONSC1Ev
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 32
	mov	rcx, rax
	call	_ZN5ArrayIN2FB8DIRENTRYEEC1Ev
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 112
	mov	BYTE PTR [rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 113
	mov	BYTE PTR [rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 114
	mov	BYTE PTR [rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 120
	mov	rcx, rax
	call	_ZN2FB7FSERRORC1Ev
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 208
	mov	rcx, rax
	call	_ZN6ResultIN2FB8DIRENTRYEN2FB7FSERROREEC1Ev
	nop
	add	rsp, 32
	pop	rbp
	ret
.L2942:
.L2943:
	.seh_endproc
	.def	_ZN2FB12WALKITERATORaSERKS0_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN2FB12WALKITERATORaSERKS0_
_ZN2FB12WALKITERATORaSERKS0_:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 48
	.seh_stackalloc	48
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
.L2945:
	mov	rax, QWORD PTR 24[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rax
	mov	rdx, -1
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_UStrAssign
	mov	rax, QWORD PTR 24[rbp]
	add	rax, 24
	mov	rdx, QWORD PTR 16[rbp]
	add	rdx, 24
	mov	rax, QWORD PTR [rax]
	mov	QWORD PTR [rdx], rax
	mov	rax, QWORD PTR 24[rbp]
	lea	rdx, 32[rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 32
	mov	rcx, rax
	call	_ZN5ArrayIN2FB8DIRENTRYEEaSERKS2_
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 112[rax]
	mov	rax, QWORD PTR 24[rbp]
	movzx	eax, BYTE PTR 112[rax]
	mov	BYTE PTR [rdx], al
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 113[rax]
	mov	rax, QWORD PTR 24[rbp]
	movzx	eax, BYTE PTR 113[rax]
	mov	BYTE PTR [rdx], al
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 114[rax]
	mov	rax, QWORD PTR 24[rbp]
	movzx	eax, BYTE PTR 114[rax]
	mov	BYTE PTR [rdx], al
	mov	rax, QWORD PTR 24[rbp]
	lea	rdx, 120[rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 120
	mov	rcx, rax
	call	_ZN2FB7FSERRORaSERKS0_
	mov	rax, QWORD PTR 24[rbp]
	lea	rdx, 208[rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 208
	mov	rcx, rax
	call	_ZN6ResultIN2FB8DIRENTRYEN2FB7FSERROREEaSERKS4_
	nop
	add	rsp, 48
	pop	rbp
	ret
.L2946:
	.seh_endproc
	.def	_ZN2FB12WALKITERATORC1ERKS0_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN2FB12WALKITERATORC1ERKS0_
_ZN2FB12WALKITERATORC1ERKS0_:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
.L2948:
	mov	rax, QWORD PTR 16[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 24
	mov	rcx, rax
	call	_ZN2FB11WALKOPTIONSC1Ev
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 32
	mov	rcx, rax
	call	_ZN5ArrayIN2FB8DIRENTRYEEC1Ev
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 112
	mov	BYTE PTR [rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 113
	mov	BYTE PTR [rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 114
	mov	BYTE PTR [rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 120
	mov	rcx, rax
	call	_ZN2FB7FSERRORC1Ev
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 208
	mov	rcx, rax
	call	_ZN6ResultIN2FB8DIRENTRYEN2FB7FSERROREEC1Ev
	mov	rax, QWORD PTR 24[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN2FB12WALKITERATORaSERKS0_
	nop
	add	rsp, 32
	pop	rbp
	ret
.L2949:
	.seh_endproc
	.def	_ZN2FB12WALKITERATORD1Ev;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN2FB12WALKITERATORD1Ev
_ZN2FB12WALKITERATORD1Ev:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
.L2951:
.L2952:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 208
	mov	rcx, rax
	call	_ZN6ResultIN2FB8DIRENTRYEN2FB7FSERROREED1Ev
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 120
	mov	rcx, rax
	call	_ZN2FB7FSERRORD1Ev
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 32
	mov	rcx, rax
	call	_ZN5ArrayIN2FB8DIRENTRYEED1Ev
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_UStrDelete
	nop
	add	rsp, 32
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN2FB12WALKITERATOR7HHIDDENERNS_8DIRENTRYE;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN2FB12WALKITERATOR7HHIDDENERNS_8DIRENTRYE
_ZN2FB12WALKITERATOR7HHIDDENERNS_8DIRENTRYE:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 48
	.seh_stackalloc	48
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
	mov	BYTE PTR -2[rbp], 0
.L2954:
	mov	rax, QWORD PTR 24[rbp]
	add	rax, 64
	mov	rcx, rax
	call	_ZNK2FB8FILEINFO8ISHIDDENEv
	mov	BYTE PTR -1[rbp], al
	movzx	eax, BYTE PTR -1[rbp]
	mov	BYTE PTR -2[rbp], al
	nop
.L2955:
	movzx	eax, BYTE PTR -2[rbp]
	add	rsp, 48
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN2FB12WALKITERATOR12HDESCENDABLEERNS_8DIRENTRYE;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN2FB12WALKITERATOR12HDESCENDABLEERNS_8DIRENTRYE
_ZN2FB12WALKITERATOR12HDESCENDABLEERNS_8DIRENTRYE:
	push	rbp
	.seh_pushreg	rbp
	sub	rsp, 304
	.seh_stackalloc	304
	lea	rbp, 128[rsp]
	.seh_setframe	rbp, 128
	.seh_endprologue
	mov	QWORD PTR 192[rbp], rcx
	mov	QWORD PTR 200[rbp], rdx
	mov	BYTE PTR 83[rbp], 0
.L2958:
	mov	rax, QWORD PTR 200[rbp]
	mov	rcx, rax
	call	_ZNK2FB8DIRENTRY11ISDIRECTORYEv
	mov	BYTE PTR 159[rbp], al
	cmp	BYTE PTR 159[rbp], 0
	jne	.L2998
	mov	BYTE PTR 83[rbp], 0
	jmp	.L2961
.L2998:
	nop
.L2960:
	mov	rax, QWORD PTR 200[rbp]
	mov	rcx, rax
	call	_ZNK2FB8DIRENTRY9ISSYMLINKEv
	mov	BYTE PTR 158[rbp], al
	cmp	BYTE PTR 158[rbp], 0
	je	.L2999
	mov	rax, QWORD PTR 192[rbp]
	add	rax, 24
	movzx	eax, BYTE PTR [rax]
	test	al, al
	sete	al
	mov	BYTE PTR 175[rbp], al
	jmp	.L2964
.L2999:
	nop
.L2963:
	mov	BYTE PTR 175[rbp], 0
.L2964:
	cmp	BYTE PTR 175[rbp], 0
	je	.L3000
	mov	BYTE PTR 83[rbp], 0
	jmp	.L2961
.L3000:
	nop
.L2966:
	mov	rax, QWORD PTR 192[rbp]
	add	rax, 28
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	jle	.L3001
	mov	rax, QWORD PTR 200[rbp]
	mov	rcx, rax
	call	_ZNK2FB8DIRENTRY5DEPTHEv
	mov	DWORD PTR 152[rbp], eax
	mov	eax, DWORD PTR 152[rbp]
	cdqe
	lea	rdx, 1[rax]
	mov	rax, QWORD PTR 192[rbp]
	add	rax, 28
	mov	eax, DWORD PTR [rax]
	cdqe
	cmp	rdx, rax
	jl	.L3002
	mov	BYTE PTR 83[rbp], 0
	jmp	.L2961
.L2968:
.L2970:
.L3001:
	nop
	jmp	.L2971
.L3002:
	nop
.L2971:
	mov	rax, QWORD PTR 192[rbp]
	add	rax, 24
	movzx	eax, BYTE PTR [rax]
	test	al, al
	je	.L3003
	mov	QWORD PTR 40[rbp], 0
	mov	QWORD PTR 32[rbp], 0
	mov	QWORD PTR 24[rbp], 0
	mov	QWORD PTR 16[rbp], 0
	lea	rax, 48[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	rax, QWORD PTR 200[rbp]
	mov	rcx, rax
	call	_ZNK2FB8DIRENTRY4PATHEv
	mov	QWORD PTR 144[rbp], rax
	mov	rdx, QWORD PTR 144[rbp]
	lea	rax, 48[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrAssign
	lea	rcx, 32[rbp]
	lea	rdx, 40[rbp]
	lea	rax, 48[rbp]
	mov	r8, rcx
	mov	rcx, rax
	call	fb_UStrFsIdentity
	mov	DWORD PTR 140[rbp], eax
	cmp	DWORD PTR 140[rbp], 0
	sete	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR 128[rbp], rax
	lea	rax, 48[rbp]
	mov	rcx, rax
	call	fb_UStrDelete
	cmp	QWORD PTR 128[rbp], 0
	je	.L3004
	lea	rax, -16[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	rax, QWORD PTR 200[rbp]
	mov	rcx, rax
	call	_ZNK2FB8DIRENTRY4PATHEv
	mov	QWORD PTR 120[rbp], rax
	mov	rdx, QWORD PTR 120[rbp]
	lea	rax, -16[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrAssign
	lea	rax, -16[rbp]
	mov	edx, 1
	mov	rcx, rax
	call	fb_UStrPathParent
	mov	QWORD PTR 112[rbp], rax
	mov	rdx, QWORD PTR 112[rbp]
	lea	rax, -48[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrInit
	lea	rax, -16[rbp]
	mov	rcx, rax
	call	fb_UStrDelete
.L2976:
	lea	rax, -48[rbp]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrLen
	mov	QWORD PTR 104[rbp], rax
	cmp	QWORD PTR 104[rbp], 0
	jle	.L3005
	lea	rcx, 16[rbp]
	lea	rdx, 24[rbp]
	lea	rax, -48[rbp]
	mov	r8, rcx
	mov	rcx, rax
	call	fb_UStrFsIdentity
	mov	DWORD PTR 100[rbp], eax
	cmp	DWORD PTR 100[rbp], 0
	jne	.L3006
	mov	rdx, QWORD PTR 24[rbp]
	mov	rax, QWORD PTR 40[rbp]
	cmp	rdx, rax
	jne	.L3007
	mov	rdx, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR 32[rbp]
	cmp	rdx, rax
	sete	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR 160[rbp], rax
	jmp	.L2983
.L3007:
	nop
.L2982:
	mov	QWORD PTR 160[rbp], 0
.L2983:
	cmp	QWORD PTR 160[rbp], 0
	je	.L3008
	mov	BYTE PTR 83[rbp], 0
	lea	rax, -48[rbp]
	mov	rcx, rax
	call	fb_UStrDelete
	jmp	.L2961
.L2980:
.L2985:
.L2986:
.L3006:
	nop
	jmp	.L2987
.L3008:
	nop
.L2987:
	lea	rax, -48[rbp]
	mov	edx, 1
	mov	rcx, rax
	call	fb_UStrPathParent
	mov	QWORD PTR 88[rbp], rax
	mov	rdx, QWORD PTR 88[rbp]
	lea	rax, -80[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrInit
	lea	rdx, -48[rbp]
	lea	rax, -80[rbp]
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrCompare
	mov	DWORD PTR 84[rbp], eax
	cmp	DWORD PTR 84[rbp], 0
	jne	.L3009
	lea	rax, -80[rbp]
	mov	rcx, rax
	call	fb_UStrDelete
	jmp	.L2978
.L3009:
	nop
.L2989:
	lea	rdx, -80[rbp]
	lea	rax, -48[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrAssign
	lea	rax, -80[rbp]
	mov	rcx, rax
	call	fb_UStrDelete
	jmp	.L2976
.L3005:
	nop
.L2978:
	lea	rax, -48[rbp]
	mov	rcx, rax
	call	fb_UStrDelete
	jmp	.L2991
.L2975:
.L2990:
.L2973:
.L3003:
	nop
	jmp	.L2991
.L3004:
	nop
.L2991:
	mov	BYTE PTR 83[rbp], 1
	nop
.L2961:
	movzx	eax, BYTE PTR 83[rbp]
	add	rsp, 304
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN2FB12WALKITERATOR13HPUSHCHILDRENERK9FBUSTRINGi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN2FB12WALKITERATOR13HPUSHCHILDRENERK9FBUSTRINGi
_ZN2FB12WALKITERATOR13HPUSHCHILDRENERK9FBUSTRINGi:
	push	rbp
	.seh_pushreg	rbp
	sub	rsp, 368
	.seh_stackalloc	368
	lea	rbp, 128[rsp]
	.seh_setframe	rbp, 128
	.seh_endprologue
	mov	QWORD PTR 256[rbp], rcx
	mov	QWORD PTR 264[rbp], rdx
	mov	DWORD PTR 272[rbp], r8d
.L3011:
	lea	rax, 128[rbp]
	mov	rcx, rax
	call	_ZN5ArrayIN2FB8DIRENTRYEEC1Ev
	lea	rcx, 128[rbp]
	mov	rdx, QWORD PTR 264[rbp]
	lea	rax, 16[rbp]
	mov	r8, rcx
	mov	rcx, rax
	call	_ZN2FB7LISTDIRERK9FBUSTRINGR5ArrayIN2FB8DIRENTRYEE
	lea	rax, 16[rbp]
	mov	rcx, rax
	call	_ZN6ResultIiN2FB7FSERROREE4ISOKEv
	mov	BYTE PTR 235[rbp], al
	cmp	BYTE PTR 235[rbp], 0
	jne	.L3022
	mov	rax, QWORD PTR 256[rbp]
	add	rax, 114
	mov	BYTE PTR [rax], 1
	lea	rax, 16[rbp]
	mov	rcx, rax
	call	_ZN6ResultIiN2FB7FSERROREE7FAILUREEv
	mov	QWORD PTR 224[rbp], rax
	mov	rax, QWORD PTR 256[rbp]
	lea	rcx, 120[rax]
	mov	rax, QWORD PTR 224[rbp]
	mov	rdx, rax
	call	_ZN2FB7FSERRORaSERKS0_
	lea	rax, 16[rbp]
	mov	rcx, rax
	call	_ZN6ResultIiN2FB7FSERROREED1Ev
	lea	rax, 128[rbp]
	mov	rcx, rax
	call	_ZN5ArrayIN2FB8DIRENTRYEED1Ev
	jmp	.L3014
.L3013:
.L3022:
	nop
.L3015:
	lea	rax, 128[rbp]
	mov	rcx, rax
	call	_ZN5ArrayIN2FB8DIRENTRYEE5COUNTEv
	mov	DWORD PTR 220[rbp], eax
	mov	eax, DWORD PTR 220[rbp]
	sub	eax, 1
	mov	DWORD PTR 236[rbp], eax
	jmp	.L3016
.L3023:
	nop
.L3017:
	mov	edx, DWORD PTR 236[rbp]
	lea	rax, 128[rbp]
	mov	rcx, rax
	call	_ZN5ArrayIN2FB8DIRENTRYEEixEi
	mov	QWORD PTR 208[rbp], rax
	mov	rdx, QWORD PTR 208[rbp]
	lea	rax, -96[rbp]
	mov	rcx, rax
	call	_ZN2FB8DIRENTRYC1ERKS0_
	lea	rax, -96[rbp]
	add	rax, 52
	mov	edx, DWORD PTR 272[rbp]
	mov	DWORD PTR [rax], edx
	mov	rax, QWORD PTR 256[rbp]
	lea	rcx, 32[rax]
	lea	rax, -96[rbp]
	mov	rdx, rax
	call	_ZN5ArrayIN2FB8DIRENTRYEE4PUSHERS1_
	lea	rax, -96[rbp]
	mov	rcx, rax
	call	_ZN2FB8DIRENTRYD1Ev
.L3018:
	sub	DWORD PTR 236[rbp], 1
.L3016:
	cmp	DWORD PTR 236[rbp], 0
	jns	.L3023
	nop
.L3019:
	lea	rax, 16[rbp]
	mov	rcx, rax
	call	_ZN6ResultIiN2FB7FSERROREED1Ev
	lea	rax, 128[rbp]
	mov	rcx, rax
	call	_ZN5ArrayIN2FB8DIRENTRYEED1Ev
	nop
.L3014:
	nop
	add	rsp, 368
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN2FB12WALKITERATOR8HADVANCEEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN2FB12WALKITERATOR8HADVANCEEv
_ZN2FB12WALKITERATOR8HADVANCEEv:
	push	rbp
	.seh_pushreg	rbp
	sub	rsp, 448
	.seh_stackalloc	448
	lea	rbp, 128[rsp]
	.seh_setframe	rbp, 128
	.seh_endprologue
	mov	QWORD PTR 336[rbp], rcx
.L3025:
.L3026:
	mov	rax, QWORD PTR 336[rbp]
	add	rax, 114
	movzx	eax, BYTE PTR [rax]
	test	al, al
	je	.L3060
	mov	rax, QWORD PTR 336[rbp]
	add	rax, 114
	mov	BYTE PTR [rax], 0
	mov	rax, QWORD PTR 336[rbp]
	add	rax, 113
	mov	BYTE PTR [rax], 1
	mov	rax, QWORD PTR 336[rbp]
	lea	rdx, 120[rax]
	lea	rax, 32[rbp]
	mov	rcx, rax
	call	_Z4FailIN2FB8DIRENTRYEN2FB7FSERROREERS3_
	mov	QWORD PTR 304[rbp], rax
	mov	rax, QWORD PTR 336[rbp]
	lea	rcx, 208[rax]
	mov	rax, QWORD PTR 304[rbp]
	mov	rdx, rax
	call	_ZN6ResultIN2FB8DIRENTRYEN2FB7FSERROREEaSERKS4_
	lea	rax, 32[rbp]
	mov	rcx, rax
	call	_ZN6ResultIN2FB8DIRENTRYEN2FB7FSERROREED1Ev
	jmp	.L3024
.L3028:
.L3060:
	nop
.L3030:
	mov	rax, QWORD PTR 336[rbp]
	add	rax, 32
	mov	rcx, rax
	call	_ZN5ArrayIN2FB8DIRENTRYEE7ISEMPTYEv
	mov	BYTE PTR 303[rbp], al
	cmp	BYTE PTR 303[rbp], 0
	je	.L3061
	mov	rax, QWORD PTR 336[rbp]
	add	rax, 113
	mov	BYTE PTR [rax], 0
	nop
.L3054:
	jmp	.L3024
.L3053:
.L3032:
.L3061:
	nop
.L3033:
	mov	rax, QWORD PTR 336[rbp]
	lea	rdx, 32[rax]
	lea	rax, -80[rbp]
	mov	rcx, rax
	call	_ZN5ArrayIN2FB8DIRENTRYEE3POPEv
	lea	rax, -80[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 336[rbp]
	call	_ZN2FB12WALKITERATOR12HDESCENDABLEERNS_8DIRENTRYE
	mov	BYTE PTR 302[rbp], al
	movzx	eax, BYTE PTR 302[rbp]
	mov	BYTE PTR 301[rbp], al
	mov	BYTE PTR 317[rbp], 1
	lea	rax, -80[rbp]
	mov	rcx, rax
	call	_ZNK2FB8DIRENTRY11ISDIRECTORYEv
	mov	BYTE PTR 300[rbp], al
	cmp	BYTE PTR 300[rbp], 0
	je	.L3062
	mov	rax, QWORD PTR 336[rbp]
	add	rax, 25
	movzx	eax, BYTE PTR [rax]
	test	al, al
	sete	al
	mov	BYTE PTR 319[rbp], al
	jmp	.L3036
.L3062:
	nop
.L3035:
	mov	BYTE PTR 319[rbp], 0
.L3036:
	cmp	BYTE PTR 319[rbp], 0
	je	.L3063
	mov	BYTE PTR 317[rbp], 0
	jmp	.L3039
.L3038:
.L3063:
	nop
.L3039:
	mov	rax, QWORD PTR 336[rbp]
	add	rax, 26
	movzx	eax, BYTE PTR [rax]
	test	al, al
	jne	.L3064
	lea	rax, -80[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 336[rbp]
	call	_ZN2FB12WALKITERATOR7HHIDDENERNS_8DIRENTRYE
	mov	BYTE PTR 299[rbp], al
	cmp	BYTE PTR 299[rbp], 0
	setne	al
	mov	BYTE PTR 318[rbp], al
	jmp	.L3042
.L3064:
	nop
.L3041:
	mov	BYTE PTR 318[rbp], 0
.L3042:
	cmp	BYTE PTR 318[rbp], 0
	je	.L3065
	mov	BYTE PTR 317[rbp], 0
	jmp	.L3045
.L3044:
.L3065:
	nop
.L3045:
	cmp	BYTE PTR 301[rbp], 0
	je	.L3066
	lea	rax, -80[rbp]
	mov	rcx, rax
	call	_ZNK2FB8DIRENTRY5DEPTHEv
	mov	DWORD PTR 292[rbp], eax
	lea	rax, 240[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	lea	rax, -80[rbp]
	mov	rcx, rax
	call	_ZNK2FB8DIRENTRY4PATHEv
	mov	QWORD PTR 280[rbp], rax
	mov	rdx, QWORD PTR 280[rbp]
	lea	rax, 240[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrAssign
	mov	eax, DWORD PTR 292[rbp]
	lea	edx, 1[rax]
	lea	rax, 240[rbp]
	mov	r8d, edx
	mov	rdx, rax
	mov	rcx, QWORD PTR 336[rbp]
	call	_ZN2FB12WALKITERATOR13HPUSHCHILDRENERK9FBUSTRINGi
	lea	rax, 240[rbp]
	mov	rcx, rax
	call	fb_UStrDelete
	jmp	.L3048
.L3047:
.L3066:
	nop
.L3048:
	cmp	BYTE PTR 317[rbp], 0
	je	.L3067
	mov	rax, QWORD PTR 336[rbp]
	add	rax, 113
	mov	BYTE PTR [rax], 1
	lea	rdx, -80[rbp]
	lea	rax, 32[rbp]
	mov	rcx, rax
	call	_Z2OkIN2FB8DIRENTRYEN2FB7FSERROREERS1_
	mov	QWORD PTR 272[rbp], rax
	mov	rax, QWORD PTR 336[rbp]
	lea	rcx, 208[rax]
	mov	rax, QWORD PTR 272[rbp]
	mov	rdx, rax
	call	_ZN6ResultIN2FB8DIRENTRYEN2FB7FSERROREEaSERKS4_
	lea	rax, 32[rbp]
	mov	rcx, rax
	call	_ZN6ResultIN2FB8DIRENTRYEN2FB7FSERROREED1Ev
	lea	rax, -80[rbp]
	mov	rcx, rax
	call	_ZN2FB8DIRENTRYD1Ev
	jmp	.L3024
.L3050:
.L3067:
	nop
.L3051:
	lea	rax, -80[rbp]
	mov	rcx, rax
	call	_ZN2FB8DIRENTRYD1Ev
.L3052:
	jmp	.L3025
.L3024:
	add	rsp, 448
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN2FB12WALKITERATOR5HOPENEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN2FB12WALKITERATOR5HOPENEv
_ZN2FB12WALKITERATOR5HOPENEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
.L3069:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 112
	movzx	eax, BYTE PTR [rax]
	test	al, al
	jne	.L3073
	nop
.L3071:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 112
	mov	BYTE PTR [rax], 1
	mov	r8d, 0
	mov	rdx, QWORD PTR 16[rbp]
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN2FB12WALKITERATOR13HPUSHCHILDRENERK9FBUSTRINGi
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN2FB12WALKITERATOR8HADVANCEEv
	jmp	.L3074
.L3073:
	nop
.L3072:
.L3074:
	nop
	add	rsp, 32
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN2FB12WALKITERATOR7ISVALIDEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN2FB12WALKITERATOR7ISVALIDEv
_ZN2FB12WALKITERATOR7ISVALIDEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 48
	.seh_stackalloc	48
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	BYTE PTR -1[rbp], 0
.L3076:
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN2FB12WALKITERATOR5HOPENEv
	mov	rax, QWORD PTR 16[rbp]
	movzx	eax, BYTE PTR 113[rax]
	mov	BYTE PTR -1[rbp], al
	nop
.L3077:
	movzx	eax, BYTE PTR -1[rbp]
	add	rsp, 48
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN2FB12WALKITERATOR5VALUEEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN2FB12WALKITERATOR5VALUEEv
_ZN2FB12WALKITERATOR5VALUEEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 48
	.seh_stackalloc	48
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR -8[rbp], 0
.L3080:
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN2FB12WALKITERATOR5HOPENEv
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 208
	mov	QWORD PTR -8[rbp], rax
	nop
.L3081:
	mov	rax, QWORD PTR -8[rbp]
	add	rsp, 48
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN2FB12WALKITERATOR8MOVENEXTEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN2FB12WALKITERATOR8MOVENEXTEv
_ZN2FB12WALKITERATOR8MOVENEXTEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 48
	.seh_stackalloc	48
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
.L3084:
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN2FB12WALKITERATOR5HOPENEv
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 27
	movzx	eax, BYTE PTR [rax]
	test	al, al
	je	.L3094
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 208
	mov	rcx, rax
	call	_ZN6ResultIN2FB8DIRENTRYEN2FB7FSERROREE4ISOKEv
	mov	BYTE PTR -2[rbp], al
	cmp	BYTE PTR -2[rbp], 0
	sete	al
	mov	BYTE PTR -1[rbp], al
	jmp	.L3087
.L3094:
	nop
.L3086:
	mov	BYTE PTR -1[rbp], 0
.L3087:
	cmp	BYTE PTR -1[rbp], 0
	je	.L3095
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 113
	mov	BYTE PTR [rax], 0
	jmp	.L3090
.L3089:
.L3095:
	nop
.L3091:
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN2FB12WALKITERATOR8HADVANCEEv
	nop
.L3090:
	nop
	add	rsp, 48
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN2FB9WALKRANGEC1Ev;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN2FB9WALKRANGEC1Ev
_ZN2FB9WALKRANGEC1Ev:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	rax, QWORD PTR 16[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 24
	mov	rcx, rax
	call	_ZN2FB11WALKOPTIONSC1Ev
	nop
	add	rsp, 32
	pop	rbp
	ret
.L3097:
.L3098:
	.seh_endproc
	.def	_ZN2FB9WALKRANGEaSERKS0_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN2FB9WALKRANGEaSERKS0_
_ZN2FB9WALKRANGEaSERKS0_:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 48
	.seh_stackalloc	48
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
.L3100:
	mov	rax, QWORD PTR 24[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rax
	mov	rdx, -1
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_UStrAssign
	mov	rax, QWORD PTR 24[rbp]
	add	rax, 24
	mov	rdx, QWORD PTR 16[rbp]
	add	rdx, 24
	mov	rax, QWORD PTR [rax]
	mov	QWORD PTR [rdx], rax
	nop
	add	rsp, 48
	pop	rbp
	ret
.L3101:
	.seh_endproc
	.def	_ZN2FB9WALKRANGEC1ERKS0_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN2FB9WALKRANGEC1ERKS0_
_ZN2FB9WALKRANGEC1ERKS0_:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
.L3103:
	mov	rax, QWORD PTR 16[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 24
	mov	rcx, rax
	call	_ZN2FB11WALKOPTIONSC1Ev
	mov	rax, QWORD PTR 24[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN2FB9WALKRANGEaSERKS0_
	nop
	add	rsp, 32
	pop	rbp
	ret
.L3104:
	.seh_endproc
	.def	_ZN2FB9WALKRANGED1Ev;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN2FB9WALKRANGED1Ev
_ZN2FB9WALKRANGED1Ev:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
.L3106:
.L3107:
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_UStrDelete
	nop
	add	rsp, 32
	pop	rbp
	ret
	.seh_endproc
	.def	_ZNK2FB9WALKRANGE11GETITERATOREv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZNK2FB9WALKRANGE11GETITERATOREv
_ZNK2FB9WALKRANGE11GETITERATOREv:
	push	rbp
	.seh_pushreg	rbp
	sub	rsp, 464
	.seh_stackalloc	464
	lea	rbp, 128[rsp]
	.seh_setframe	rbp, 128
	.seh_endprologue
	mov	QWORD PTR 352[rbp], rcx
	mov	QWORD PTR 360[rbp], rdx
.L3109:
	lea	rax, -80[rbp]
	mov	rcx, rax
	call	_ZN2FB12WALKITERATORC1Ev
	mov	rdx, QWORD PTR 360[rbp]
	lea	rax, -80[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrAssign
	mov	rax, QWORD PTR 360[rbp]
	lea	rdx, 24[rax]
	lea	rax, -80[rbp]
	add	rax, 24
	mov	rdx, QWORD PTR [rdx]
	mov	QWORD PTR [rax], rdx
	lea	rax, -80[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 352[rbp]
	call	_ZN2FB12WALKITERATORC1ERKS0_
	lea	rax, -80[rbp]
	mov	rcx, rax
	call	_ZN2FB12WALKITERATORD1Ev
	nop
.L3110:
	mov	rax, QWORD PTR 352[rbp]
	add	rsp, 464
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN2FB7WALKDIRERK9FBUSTRING;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN2FB7WALKDIRERK9FBUSTRING
_ZN2FB7WALKDIRERK9FBUSTRING:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 96
	.seh_stackalloc	96
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
.L3113:
	lea	rax, -32[rbp]
	mov	rcx, rax
	call	_ZN2FB9WALKRANGEC1Ev
	lea	rax, -40[rbp]
	mov	rcx, rax
	call	_ZN2FB11WALKOPTIONSC1Ev
	mov	rdx, QWORD PTR 24[rbp]
	lea	rax, -32[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrAssign
	lea	rax, -32[rbp]
	add	rax, 24
	mov	rdx, QWORD PTR -40[rbp]
	mov	QWORD PTR [rax], rdx
	lea	rax, -32[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN2FB9WALKRANGEC1ERKS0_
	lea	rax, -32[rbp]
	mov	rcx, rax
	call	_ZN2FB9WALKRANGED1Ev
	nop
.L3114:
	mov	rax, QWORD PTR 16[rbp]
	add	rsp, 96
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN2FB11READALLTEXTERK9FBUSTRING;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN2FB11READALLTEXTERK9FBUSTRING
_ZN2FB11READALLTEXTERK9FBUSTRING:
	push	rbp
	.seh_pushreg	rbp
	sub	rsp, 416
	.seh_stackalloc	416
	lea	rbp, 128[rsp]
	.seh_setframe	rbp, 128
	.seh_endprologue
	mov	QWORD PTR 304[rbp], rcx
	mov	QWORD PTR 312[rbp], rdx
.L3117:
	mov	DWORD PTR 140[rbp], 0
	lea	rdx, 140[rbp]
	mov	rax, QWORD PTR 312[rbp]
	mov	rcx, rax
	call	fb_UStrFsReadAllText
	mov	QWORD PTR 280[rbp], rax
	mov	rdx, QWORD PTR 280[rbp]
	lea	rax, 112[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrInit
	mov	eax, DWORD PTR 140[rbp]
	test	eax, eax
	je	.L3124
	lea	rax, 80[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	WORD PTR 48[rbp], 82
	mov	WORD PTR 50[rbp], 101
	mov	WORD PTR 52[rbp], 97
	mov	WORD PTR 54[rbp], 100
	mov	WORD PTR 56[rbp], 65
	mov	WORD PTR 58[rbp], 108
	mov	WORD PTR 60[rbp], 108
	mov	WORD PTR 62[rbp], 84
	mov	WORD PTR 64[rbp], 101
	mov	WORD PTR 66[rbp], 120
	mov	WORD PTR 68[rbp], 116
	mov	WORD PTR 70[rbp], 0
	lea	rdx, 48[rbp]
	lea	rax, 80[rbp]
	mov	DWORD PTR 32[rsp], 0
	movabs	r9, -9223372036854775797
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrAssign
	mov	eax, DWORD PTR 140[rbp]
	movsx	rdx, eax
	mov	r8, QWORD PTR 312[rbp]
	lea	rcx, 80[rbp]
	lea	rax, -80[rbp]
	mov	r9, r8
	mov	r8, rcx
	mov	rcx, rax
	call	_Z6FsFailI9FBUSTRINGEN2FB11FSERRORCODEERKS0_S4_
	mov	QWORD PTR 272[rbp], rax
	mov	rax, QWORD PTR 272[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 304[rbp]
	call	_ZN6ResultI9FBUSTRINGN2FB7FSERROREEC1ERKS3_
	lea	rax, 80[rbp]
	mov	rcx, rax
	call	fb_UStrDelete
	lea	rax, -80[rbp]
	mov	rcx, rax
	call	_ZN6ResultI9FBUSTRINGN2FB7FSERROREED1Ev
	lea	rax, 112[rbp]
	mov	rcx, rax
	call	fb_UStrDelete
	jmp	.L3120
.L3119:
.L3124:
	nop
.L3121:
	lea	rdx, 112[rbp]
	lea	rax, 144[rbp]
	mov	rcx, rax
	call	_Z2OkI9FBUSTRINGN2FB7FSERROREERS0_
	mov	QWORD PTR 264[rbp], rax
	mov	rax, QWORD PTR 264[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 304[rbp]
	call	_ZN6ResultI9FBUSTRINGN2FB7FSERROREEC1ERKS3_
	lea	rax, 144[rbp]
	mov	rcx, rax
	call	_ZN6ResultI9FBUSTRINGN2FB7FSERROREED1Ev
	lea	rax, 112[rbp]
	mov	rcx, rax
	call	fb_UStrDelete
	nop
.L3120:
	mov	rax, QWORD PTR 304[rbp]
	add	rsp, 416
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN2FB12READALLBYTESERK9FBUSTRINGR5ArrayIhE;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN2FB12READALLBYTESERK9FBUSTRINGR5ArrayIhE
_ZN2FB12READALLBYTESERK9FBUSTRINGR5ArrayIhE:
	push	rbp
	.seh_pushreg	rbp
	sub	rsp, 384
	.seh_stackalloc	384
	lea	rbp, 128[rsp]
	.seh_setframe	rbp, 128
	.seh_endprologue
	mov	QWORD PTR 272[rbp], rcx
	mov	QWORD PTR 280[rbp], rdx
	mov	QWORD PTR 288[rbp], r8
.L3126:
	mov	QWORD PTR 104[rbp], 0
	mov	QWORD PTR 96[rbp], 0
	mov	rax, QWORD PTR 288[rbp]
	mov	rcx, rax
	call	_ZN5ArrayIhE5CLEAREv
	lea	rcx, 96[rbp]
	lea	rdx, 104[rbp]
	mov	rax, QWORD PTR 280[rbp]
	mov	r8, rcx
	mov	rcx, rax
	call	fb_UStrFsReadWhole
	mov	DWORD PTR 244[rbp], eax
	mov	eax, DWORD PTR 244[rbp]
	mov	DWORD PTR 240[rbp], eax
	cmp	DWORD PTR 240[rbp], 0
	je	.L3141
	lea	rax, 64[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	WORD PTR 32[rbp], 82
	mov	WORD PTR 34[rbp], 101
	mov	WORD PTR 36[rbp], 97
	mov	WORD PTR 38[rbp], 100
	mov	WORD PTR 40[rbp], 65
	mov	WORD PTR 42[rbp], 108
	mov	WORD PTR 44[rbp], 108
	mov	WORD PTR 46[rbp], 66
	mov	WORD PTR 48[rbp], 121
	mov	WORD PTR 50[rbp], 116
	mov	WORD PTR 52[rbp], 101
	mov	WORD PTR 54[rbp], 115
	mov	WORD PTR 56[rbp], 0
	lea	rdx, 32[rbp]
	lea	rax, 64[rbp]
	mov	DWORD PTR 32[rsp], 0
	movabs	r9, -9223372036854775796
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrAssign
	mov	eax, DWORD PTR 240[rbp]
	movsx	rdx, eax
	mov	r8, QWORD PTR 280[rbp]
	lea	rcx, 64[rbp]
	lea	rax, -80[rbp]
	mov	r9, r8
	mov	r8, rcx
	mov	rcx, rax
	call	_Z6FsFailIxEN2FB11FSERRORCODEERK9FBUSTRINGS4_
	mov	QWORD PTR 232[rbp], rax
	mov	rax, QWORD PTR 232[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 272[rbp]
	call	_ZN6ResultIxN2FB7FSERROREEC1ERKS2_
	lea	rax, 64[rbp]
	mov	rcx, rax
	call	fb_UStrDelete
	lea	rax, -80[rbp]
	mov	rcx, rax
	call	_ZN6ResultIxN2FB7FSERROREED1Ev
	jmp	.L3129
.L3128:
.L3141:
	nop
.L3130:
	mov	rax, QWORD PTR 96[rbp]
	test	rax, rax
	jle	.L3142
	mov	rax, QWORD PTR 96[rbp]
	mov	edx, eax
	mov	rax, QWORD PTR 288[rbp]
	mov	rcx, rax
	call	_ZN5ArrayIhE7RESERVEEi
	mov	QWORD PTR 248[rbp], 0
	mov	rax, QWORD PTR 96[rbp]
	sub	rax, 1
	mov	QWORD PTR 224[rbp], rax
	jmp	.L3133
.L3143:
	nop
.L3134:
	mov	rdx, QWORD PTR 104[rbp]
	mov	rax, QWORD PTR 248[rbp]
	add	rdx, rax
	mov	rax, QWORD PTR 288[rbp]
	mov	rcx, rax
	call	_ZN5ArrayIhE4PUSHERh
.L3135:
	add	QWORD PTR 248[rbp], 1
.L3133:
	mov	rax, QWORD PTR 248[rbp]
	cmp	rax, QWORD PTR 224[rbp]
	jle	.L3143
	jmp	.L3137
.L3132:
.L3136:
.L3142:
	nop
.L3137:
	mov	rax, QWORD PTR 104[rbp]
	mov	rcx, rax
	call	fb_FsFreeBuf
	lea	rdx, 96[rbp]
	lea	rax, 112[rbp]
	mov	rcx, rax
	call	_Z2OkIxN2FB7FSERROREERx
	mov	QWORD PTR 216[rbp], rax
	mov	rax, QWORD PTR 216[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 272[rbp]
	call	_ZN6ResultIxN2FB7FSERROREEC1ERKS2_
	lea	rax, 112[rbp]
	mov	rcx, rax
	call	_ZN6ResultIxN2FB7FSERROREED1Ev
	nop
.L3129:
	mov	rax, QWORD PTR 272[rbp]
	add	rsp, 384
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN2FB12WRITEALLTEXTERK9FBUSTRINGS2_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN2FB12WRITEALLTEXTERK9FBUSTRINGS2_
_ZN2FB12WRITEALLTEXTERK9FBUSTRINGS2_:
	push	rbp
	.seh_pushreg	rbp
	sub	rsp, 352
	.seh_stackalloc	352
	lea	rbp, 128[rsp]
	.seh_setframe	rbp, 128
	.seh_endprologue
	mov	QWORD PTR 240[rbp], rcx
	mov	QWORD PTR 248[rbp], rdx
	mov	QWORD PTR 256[rbp], r8
.L3145:
	mov	rdx, QWORD PTR 256[rbp]
	mov	rax, QWORD PTR 248[rbp]
	mov	r8d, 0
	mov	rcx, rax
	call	fb_UStrFsWriteAllText
	mov	DWORD PTR 220[rbp], eax
	mov	eax, DWORD PTR 220[rbp]
	mov	DWORD PTR 216[rbp], eax
	cmp	DWORD PTR 216[rbp], 0
	je	.L3152
	lea	rax, 64[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	WORD PTR 32[rbp], 87
	mov	WORD PTR 34[rbp], 114
	mov	WORD PTR 36[rbp], 105
	mov	WORD PTR 38[rbp], 116
	mov	WORD PTR 40[rbp], 101
	mov	WORD PTR 42[rbp], 65
	mov	WORD PTR 44[rbp], 108
	mov	WORD PTR 46[rbp], 108
	mov	WORD PTR 48[rbp], 84
	mov	WORD PTR 50[rbp], 101
	mov	WORD PTR 52[rbp], 120
	mov	WORD PTR 54[rbp], 116
	mov	WORD PTR 56[rbp], 0
	lea	rdx, 32[rbp]
	lea	rax, 64[rbp]
	mov	DWORD PTR 32[rsp], 0
	movabs	r9, -9223372036854775796
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrAssign
	mov	eax, DWORD PTR 216[rbp]
	movsx	rdx, eax
	mov	r8, QWORD PTR 248[rbp]
	lea	rcx, 64[rbp]
	lea	rax, -80[rbp]
	mov	r9, r8
	mov	r8, rcx
	mov	rcx, rax
	call	_Z6FsFailIbEN2FB11FSERRORCODEERK9FBUSTRINGS4_
	mov	QWORD PTR 208[rbp], rax
	mov	rax, QWORD PTR 208[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 240[rbp]
	call	_ZN6ResultIbN2FB7FSERROREEC1ERKS2_
	lea	rax, 64[rbp]
	mov	rcx, rax
	call	fb_UStrDelete
	lea	rax, -80[rbp]
	mov	rcx, rax
	call	_ZN6ResultIbN2FB7FSERROREED1Ev
	jmp	.L3148
.L3147:
.L3152:
	nop
.L3149:
	mov	BYTE PTR 95[rbp], 1
	lea	rdx, 95[rbp]
	lea	rax, 96[rbp]
	mov	rcx, rax
	call	_Z2OkIbN2FB7FSERROREERb
	mov	QWORD PTR 200[rbp], rax
	mov	rax, QWORD PTR 200[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 240[rbp]
	call	_ZN6ResultIbN2FB7FSERROREEC1ERKS2_
	lea	rax, 96[rbp]
	mov	rcx, rax
	call	_ZN6ResultIbN2FB7FSERROREED1Ev
	nop
.L3148:
	mov	rax, QWORD PTR 240[rbp]
	add	rsp, 352
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN2FB12CREATEDIRALLERK9FBUSTRING;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN2FB12CREATEDIRALLERK9FBUSTRING
_ZN2FB12CREATEDIRALLERK9FBUSTRING:
	push	rbp
	.seh_pushreg	rbp
	sub	rsp, 720
	.seh_stackalloc	720
	lea	rbp, 128[rsp]
	.seh_setframe	rbp, 128
	.seh_endprologue
	mov	QWORD PTR 608[rbp], rcx
	mov	QWORD PTR 616[rbp], rdx
.L3154:
	mov	rax, QWORD PTR 616[rbp]
	mov	edx, 1
	mov	rcx, rax
	call	fb_UStrPathNormalize
	mov	QWORD PTR 576[rbp], rax
	mov	rdx, QWORD PTR 576[rbp]
	lea	rax, 336[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrInit
	lea	rax, 336[rbp]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrLen
	mov	QWORD PTR 568[rbp], rax
	cmp	QWORD PTR 568[rbp], 0
	jne	.L3178
	lea	rax, 192[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	WORD PTR 160[rbp], 67
	mov	WORD PTR 162[rbp], 114
	mov	WORD PTR 164[rbp], 101
	mov	WORD PTR 166[rbp], 97
	mov	WORD PTR 168[rbp], 116
	mov	WORD PTR 170[rbp], 101
	mov	WORD PTR 172[rbp], 68
	mov	WORD PTR 174[rbp], 105
	mov	WORD PTR 176[rbp], 114
	mov	WORD PTR 178[rbp], 65
	mov	WORD PTR 180[rbp], 108
	mov	WORD PTR 182[rbp], 108
	mov	WORD PTR 184[rbp], 0
	lea	rdx, 160[rbp]
	lea	rax, 192[rbp]
	mov	DWORD PTR 32[rsp], 0
	movabs	r9, -9223372036854775796
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrAssign
	mov	rcx, QWORD PTR 616[rbp]
	lea	rdx, 192[rbp]
	lea	rax, -80[rbp]
	mov	r9, rcx
	mov	r8, rdx
	mov	edx, 7
	mov	rcx, rax
	call	_Z6FsFailIbEN2FB11FSERRORCODEERK9FBUSTRINGS4_
	mov	QWORD PTR 560[rbp], rax
	mov	rax, QWORD PTR 560[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 608[rbp]
	call	_ZN6ResultIbN2FB7FSERROREEC1ERKS2_
	lea	rax, 192[rbp]
	mov	rcx, rax
	call	fb_UStrDelete
	lea	rax, -80[rbp]
	mov	rcx, rax
	call	_ZN6ResultIbN2FB7FSERROREED1Ev
	lea	rax, 336[rbp]
	mov	rcx, rax
	call	fb_UStrDelete
	jmp	.L3157
.L3156:
.L3178:
	nop
.L3158:
	lea	rax, 256[rbp]
	mov	rcx, rax
	call	_ZN5ArrayI9FBUSTRINGEC1Ev
	lea	rdx, 256[rbp]
	lea	rax, 336[rbp]
	mov	r8d, 1
	mov	rcx, rax
	call	_ZN2FB9PATHSPLITERK9FBUSTRINGR5ArrayI9FBUSTRINGEi
	mov	DWORD PTR 556[rbp], eax
	mov	eax, DWORD PTR 556[rbp]
	mov	DWORD PTR 552[rbp], eax
	lea	rax, 336[rbp]
	mov	edx, 1
	mov	rcx, rax
	call	fb_UStrPathRoot
	mov	QWORD PTR 544[rbp], rax
	mov	rdx, QWORD PTR 544[rbp]
	lea	rax, 224[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrInit
	lea	rax, 224[rbp]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrLen
	mov	QWORD PTR 536[rbp], rax
	cmp	QWORD PTR 536[rbp], 0
	jne	.L3179
	mov	WORD PTR 156[rbp], 46
	mov	WORD PTR 158[rbp], 0
	lea	rdx, 156[rbp]
	lea	rax, 224[rbp]
	mov	DWORD PTR 32[rsp], 0
	movabs	r9, -9223372036854775807
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrAssign
	jmp	.L3160
.L3179:
	nop
.L3160:
	mov	DWORD PTR 588[rbp], 0
	mov	eax, DWORD PTR 552[rbp]
	sub	eax, 1
	mov	DWORD PTR 532[rbp], eax
	jmp	.L3161
.L3183:
	nop
.L3162:
	mov	edx, DWORD PTR 588[rbp]
	lea	rax, 256[rbp]
	mov	rcx, rax
	call	_ZN5ArrayI9FBUSTRINGEixEi
	mov	QWORD PTR 512[rbp], rax
	mov	rdx, QWORD PTR 512[rbp]
	lea	rax, 224[rbp]
	mov	r8d, 1
	mov	rcx, rax
	call	fb_UStrPathJoin2
	mov	QWORD PTR 504[rbp], rax
	mov	rdx, QWORD PTR 504[rbp]
	lea	rax, 224[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrAssign
	lea	rax, 224[rbp]
	mov	rcx, rax
	call	fb_UStrFsCreateDir
	mov	DWORD PTR 500[rbp], eax
	mov	eax, DWORD PTR 500[rbp]
	mov	DWORD PTR 496[rbp], eax
	cmp	DWORD PTR 496[rbp], 0
	je	.L3180
	nop
.L3164:
	cmp	DWORD PTR 496[rbp], 3
	jne	.L3181
	lea	rax, 224[rbp]
	mov	rcx, rax
	call	_ZN2FB5ISDIRERK9FBUSTRING
	mov	BYTE PTR 495[rbp], al
	cmp	BYTE PTR 495[rbp], 0
	jne	.L3182
	nop
.L3169:
	lea	rax, 64[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	WORD PTR 32[rbp], 67
	mov	WORD PTR 34[rbp], 114
	mov	WORD PTR 36[rbp], 101
	mov	WORD PTR 38[rbp], 97
	mov	WORD PTR 40[rbp], 116
	mov	WORD PTR 42[rbp], 101
	mov	WORD PTR 44[rbp], 68
	mov	WORD PTR 46[rbp], 105
	mov	WORD PTR 48[rbp], 114
	mov	WORD PTR 50[rbp], 65
	mov	WORD PTR 52[rbp], 108
	mov	WORD PTR 54[rbp], 108
	mov	WORD PTR 56[rbp], 0
	lea	rdx, 32[rbp]
	lea	rax, 64[rbp]
	mov	DWORD PTR 32[rsp], 0
	movabs	r9, -9223372036854775796
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrAssign
	lea	rcx, 224[rbp]
	lea	rdx, 64[rbp]
	lea	rax, -80[rbp]
	mov	r9, rcx
	mov	r8, rdx
	mov	edx, 4
	mov	rcx, rax
	call	_Z6FsFailIbEN2FB11FSERRORCODEERK9FBUSTRINGS4_
	mov	QWORD PTR 480[rbp], rax
	mov	rax, QWORD PTR 480[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 608[rbp]
	call	_ZN6ResultIbN2FB7FSERROREEC1ERKS2_
	lea	rax, 64[rbp]
	mov	rcx, rax
	call	fb_UStrDelete
	lea	rax, -80[rbp]
	mov	rcx, rax
	call	_ZN6ResultIbN2FB7FSERROREED1Ev
	lea	rax, 224[rbp]
	mov	rcx, rax
	call	fb_UStrDelete
	lea	rax, 256[rbp]
	mov	rcx, rax
	call	_ZN5ArrayI9FBUSTRINGED1Ev
	lea	rax, 336[rbp]
	mov	rcx, rax
	call	fb_UStrDelete
	jmp	.L3157
.L3167:
.L3181:
	nop
.L3171:
	lea	rax, 128[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	WORD PTR 96[rbp], 67
	mov	WORD PTR 98[rbp], 114
	mov	WORD PTR 100[rbp], 101
	mov	WORD PTR 102[rbp], 97
	mov	WORD PTR 104[rbp], 116
	mov	WORD PTR 106[rbp], 101
	mov	WORD PTR 108[rbp], 68
	mov	WORD PTR 110[rbp], 105
	mov	WORD PTR 112[rbp], 114
	mov	WORD PTR 114[rbp], 65
	mov	WORD PTR 116[rbp], 108
	mov	WORD PTR 118[rbp], 108
	mov	WORD PTR 120[rbp], 0
	lea	rdx, 96[rbp]
	lea	rax, 128[rbp]
	mov	DWORD PTR 32[rsp], 0
	movabs	r9, -9223372036854775796
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrAssign
	mov	eax, DWORD PTR 496[rbp]
	movsx	rdx, eax
	lea	r8, 224[rbp]
	lea	rcx, 128[rbp]
	lea	rax, -80[rbp]
	mov	r9, r8
	mov	r8, rcx
	mov	rcx, rax
	call	_Z6FsFailIbEN2FB11FSERRORCODEERK9FBUSTRINGS4_
	mov	QWORD PTR 472[rbp], rax
	mov	rax, QWORD PTR 472[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 608[rbp]
	call	_ZN6ResultIbN2FB7FSERROREEC1ERKS2_
	lea	rax, 128[rbp]
	mov	rcx, rax
	call	fb_UStrDelete
	lea	rax, -80[rbp]
	mov	rcx, rax
	call	_ZN6ResultIbN2FB7FSERROREED1Ev
	lea	rax, 224[rbp]
	mov	rcx, rax
	call	fb_UStrDelete
	lea	rax, 256[rbp]
	mov	rcx, rax
	call	_ZN5ArrayI9FBUSTRINGED1Ev
	lea	rax, 336[rbp]
	mov	rcx, rax
	call	fb_UStrDelete
	jmp	.L3157
.L3180:
	nop
	jmp	.L3172
.L3182:
	nop
.L3172:
	add	DWORD PTR 588[rbp], 1
.L3161:
	mov	eax, DWORD PTR 588[rbp]
	cmp	eax, DWORD PTR 532[rbp]
	jle	.L3183
	nop
.L3173:
	mov	BYTE PTR 367[rbp], 1
	lea	rdx, 367[rbp]
	lea	rax, 368[rbp]
	mov	rcx, rax
	call	_Z2OkIbN2FB7FSERROREERb
	mov	QWORD PTR 520[rbp], rax
	mov	rax, QWORD PTR 520[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 608[rbp]
	call	_ZN6ResultIbN2FB7FSERROREEC1ERKS2_
	lea	rax, 368[rbp]
	mov	rcx, rax
	call	_ZN6ResultIbN2FB7FSERROREED1Ev
	lea	rax, 224[rbp]
	mov	rcx, rax
	call	fb_UStrDelete
	lea	rax, 256[rbp]
	mov	rcx, rax
	call	_ZN5ArrayI9FBUSTRINGED1Ev
	lea	rax, 336[rbp]
	mov	rcx, rax
	call	fb_UStrDelete
	nop
.L3157:
	mov	rax, QWORD PTR 608[rbp]
	add	rsp, 720
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN2FB12REMOVEDIRALLERK9FBUSTRING;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN2FB12REMOVEDIRALLERK9FBUSTRING
_ZN2FB12REMOVEDIRALLERK9FBUSTRING:
	push	rbp
	.seh_pushreg	rbp
	sub	rsp, 800
	.seh_stackalloc	800
	lea	rbp, 128[rsp]
	.seh_setframe	rbp, 128
	.seh_endprologue
	mov	QWORD PTR 688[rbp], rcx
	mov	QWORD PTR 696[rbp], rdx
.L3185:
	lea	rax, 304[rbp]
	mov	rcx, rax
	call	_ZN5ArrayIN2FB8DIRENTRYEEC1Ev
	mov	QWORD PTR 664[rbp], 0
	lea	rcx, 304[rbp]
	mov	rdx, QWORD PTR 696[rbp]
	lea	rax, 192[rbp]
	mov	r8, rcx
	mov	rcx, rax
	call	_ZN2FB7LISTDIRERK9FBUSTRINGR5ArrayIN2FB8DIRENTRYEE
	lea	rax, 192[rbp]
	mov	rcx, rax
	call	_ZN6ResultIiN2FB7FSERROREE4ISOKEv
	mov	BYTE PTR 643[rbp], al
	cmp	BYTE PTR 643[rbp], 0
	jne	.L3228
	lea	rax, 192[rbp]
	mov	rcx, rax
	call	_ZN6ResultIiN2FB7FSERROREE7FAILUREEv
	mov	QWORD PTR 632[rbp], rax
	mov	rdx, QWORD PTR 632[rbp]
	lea	rax, -80[rbp]
	mov	rcx, rax
	call	_Z4FailIxN2FB7FSERROREERS1_
	mov	QWORD PTR 624[rbp], rax
	mov	rax, QWORD PTR 624[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 688[rbp]
	call	_ZN6ResultIxN2FB7FSERROREEC1ERKS2_
	lea	rax, -80[rbp]
	mov	rcx, rax
	call	_ZN6ResultIxN2FB7FSERROREED1Ev
	lea	rax, 192[rbp]
	mov	rcx, rax
	call	_ZN6ResultIiN2FB7FSERROREED1Ev
	lea	rax, 304[rbp]
	mov	rcx, rax
	call	_ZN5ArrayIN2FB8DIRENTRYEED1Ev
	jmp	.L3188
.L3187:
.L3228:
	nop
.L3189:
	mov	DWORD PTR 660[rbp], 0
	lea	rax, 304[rbp]
	mov	rcx, rax
	call	_ZN5ArrayIN2FB8DIRENTRYEE5COUNTEv
	mov	DWORD PTR 620[rbp], eax
	mov	eax, DWORD PTR 620[rbp]
	sub	eax, 1
	mov	DWORD PTR 616[rbp], eax
	jmp	.L3190
.L3236:
	nop
.L3191:
	mov	edx, DWORD PTR 660[rbp]
	lea	rax, 304[rbp]
	mov	rcx, rax
	call	_ZN5ArrayIN2FB8DIRENTRYEEixEi
	mov	QWORD PTR 584[rbp], rax
	mov	rax, QWORD PTR 584[rbp]
	mov	rcx, rax
	call	_ZNK2FB8DIRENTRY4PATHEv
	mov	QWORD PTR 576[rbp], rax
	mov	rdx, QWORD PTR 576[rbp]
	lea	rax, 160[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrInit
	mov	edx, DWORD PTR 660[rbp]
	lea	rax, 304[rbp]
	mov	rcx, rax
	call	_ZN5ArrayIN2FB8DIRENTRYEEixEi
	mov	QWORD PTR 568[rbp], rax
	mov	rax, QWORD PTR 568[rbp]
	mov	rcx, rax
	call	_ZNK2FB8DIRENTRY11ISDIRECTORYEv
	mov	BYTE PTR 567[rbp], al
	cmp	BYTE PTR 567[rbp], 0
	je	.L3229
	mov	edx, DWORD PTR 660[rbp]
	lea	rax, 304[rbp]
	mov	rcx, rax
	call	_ZN5ArrayIN2FB8DIRENTRYEEixEi
	mov	QWORD PTR 552[rbp], rax
	mov	rax, QWORD PTR 552[rbp]
	mov	rcx, rax
	call	_ZNK2FB8DIRENTRY9ISSYMLINKEv
	mov	BYTE PTR 551[rbp], al
	cmp	BYTE PTR 551[rbp], 0
	sete	al
	mov	BYTE PTR 659[rbp], al
	jmp	.L3194
.L3229:
	nop
.L3193:
	mov	BYTE PTR 659[rbp], 0
.L3194:
	cmp	BYTE PTR 659[rbp], 0
	je	.L3230
	lea	rdx, 160[rbp]
	lea	rax, -80[rbp]
	mov	rcx, rax
	call	_ZN2FB12REMOVEDIRALLERK9FBUSTRING
	lea	rax, -80[rbp]
	mov	rcx, rax
	call	_ZN6ResultIxN2FB7FSERROREE4ISOKEv
	mov	BYTE PTR 550[rbp], al
	cmp	BYTE PTR 550[rbp], 0
	jne	.L3231
	lea	rax, -80[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 688[rbp]
	call	_ZN6ResultIxN2FB7FSERROREEC1ERKS2_
	lea	rax, -80[rbp]
	mov	rcx, rax
	call	_ZN6ResultIxN2FB7FSERROREED1Ev
	lea	rax, 160[rbp]
	mov	rcx, rax
	call	fb_UStrDelete
	lea	rax, 192[rbp]
	mov	rcx, rax
	call	_ZN6ResultIiN2FB7FSERROREED1Ev
	lea	rax, 304[rbp]
	mov	rcx, rax
	call	_ZN5ArrayIN2FB8DIRENTRYEED1Ev
	jmp	.L3188
.L3198:
.L3231:
	nop
.L3200:
	lea	rax, -80[rbp]
	mov	rcx, rax
	call	_ZN6ResultIxN2FB7FSERROREE5VALUEEv
	mov	QWORD PTR 536[rbp], rax
	mov	rax, QWORD PTR 536[rbp]
	mov	rax, QWORD PTR [rax]
	add	QWORD PTR 664[rbp], rax
	lea	rax, -80[rbp]
	mov	rcx, rax
	call	_ZN6ResultIxN2FB7FSERROREED1Ev
	jmp	.L3201
.L3230:
	nop
.L3196:
	lea	rax, 160[rbp]
	mov	rcx, rax
	call	fb_UStrFsRemoveFile
	mov	DWORD PTR 532[rbp], eax
	mov	eax, DWORD PTR 532[rbp]
	mov	DWORD PTR 644[rbp], eax
	cmp	DWORD PTR 644[rbp], 11
	jne	.L3232
	lea	rax, 160[rbp]
	mov	edx, 0
	mov	rcx, rax
	call	fb_UStrFsSetReadOnly
	lea	rax, 160[rbp]
	mov	rcx, rax
	call	fb_UStrFsRemoveFile
	mov	DWORD PTR 528[rbp], eax
	mov	eax, DWORD PTR 528[rbp]
	mov	DWORD PTR 644[rbp], eax
	jmp	.L3204
.L3203:
.L3232:
	nop
.L3204:
	cmp	DWORD PTR 644[rbp], 0
	je	.L3233
	mov	edx, DWORD PTR 660[rbp]
	lea	rax, 304[rbp]
	mov	rcx, rax
	call	_ZN5ArrayIN2FB8DIRENTRYEEixEi
	mov	QWORD PTR 520[rbp], rax
	mov	rax, QWORD PTR 520[rbp]
	mov	rcx, rax
	call	_ZNK2FB8DIRENTRY9ISSYMLINKEv
	mov	BYTE PTR 519[rbp], al
	movsx	eax, BYTE PTR 519[rbp]
	neg	eax
	test	eax, eax
	setne	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR 648[rbp], rax
	jmp	.L3207
.L3233:
	nop
.L3206:
	mov	QWORD PTR 648[rbp], 0
.L3207:
	cmp	QWORD PTR 648[rbp], 0
	je	.L3234
	lea	rax, 160[rbp]
	mov	rcx, rax
	call	fb_UStrFsRemoveDir
	mov	DWORD PTR 512[rbp], eax
	mov	eax, DWORD PTR 512[rbp]
	mov	DWORD PTR 644[rbp], eax
	jmp	.L3210
.L3209:
.L3234:
	nop
.L3210:
	cmp	DWORD PTR 644[rbp], 0
	je	.L3235
	lea	rax, 128[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	WORD PTR 96[rbp], 82
	mov	WORD PTR 98[rbp], 101
	mov	WORD PTR 100[rbp], 109
	mov	WORD PTR 102[rbp], 111
	mov	WORD PTR 104[rbp], 118
	mov	WORD PTR 106[rbp], 101
	mov	WORD PTR 108[rbp], 68
	mov	WORD PTR 110[rbp], 105
	mov	WORD PTR 112[rbp], 114
	mov	WORD PTR 114[rbp], 65
	mov	WORD PTR 116[rbp], 108
	mov	WORD PTR 118[rbp], 108
	mov	WORD PTR 120[rbp], 0
	lea	rdx, 96[rbp]
	lea	rax, 128[rbp]
	mov	DWORD PTR 32[rsp], 0
	movabs	r9, -9223372036854775796
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrAssign
	mov	eax, DWORD PTR 644[rbp]
	movsx	rdx, eax
	lea	r8, 160[rbp]
	lea	rcx, 128[rbp]
	lea	rax, -80[rbp]
	mov	r9, r8
	mov	r8, rcx
	mov	rcx, rax
	call	_Z6FsFailIxEN2FB11FSERRORCODEERK9FBUSTRINGS4_
	mov	QWORD PTR 504[rbp], rax
	mov	rax, QWORD PTR 504[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 688[rbp]
	call	_ZN6ResultIxN2FB7FSERROREEC1ERKS2_
	lea	rax, 128[rbp]
	mov	rcx, rax
	call	fb_UStrDelete
	lea	rax, -80[rbp]
	mov	rcx, rax
	call	_ZN6ResultIxN2FB7FSERROREED1Ev
	lea	rax, 160[rbp]
	mov	rcx, rax
	call	fb_UStrDelete
	lea	rax, 192[rbp]
	mov	rcx, rax
	call	_ZN6ResultIiN2FB7FSERROREED1Ev
	lea	rax, 304[rbp]
	mov	rcx, rax
	call	_ZN5ArrayIN2FB8DIRENTRYEED1Ev
	jmp	.L3188
.L3212:
.L3235:
	nop
.L3213:
	add	QWORD PTR 664[rbp], 1
.L3201:
	lea	rax, 160[rbp]
	mov	rcx, rax
	call	fb_UStrDelete
.L3214:
	add	DWORD PTR 660[rbp], 1
.L3190:
	mov	eax, DWORD PTR 660[rbp]
	cmp	eax, DWORD PTR 616[rbp]
	jle	.L3236
	nop
.L3215:
	mov	rax, QWORD PTR 696[rbp]
	mov	rcx, rax
	call	fb_UStrFsRemoveDir
	mov	DWORD PTR 612[rbp], eax
	mov	eax, DWORD PTR 612[rbp]
	mov	DWORD PTR 608[rbp], eax
	cmp	DWORD PTR 608[rbp], 0
	je	.L3237
	lea	rax, 64[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	WORD PTR 32[rbp], 82
	mov	WORD PTR 34[rbp], 101
	mov	WORD PTR 36[rbp], 109
	mov	WORD PTR 38[rbp], 111
	mov	WORD PTR 40[rbp], 118
	mov	WORD PTR 42[rbp], 101
	mov	WORD PTR 44[rbp], 68
	mov	WORD PTR 46[rbp], 105
	mov	WORD PTR 48[rbp], 114
	mov	WORD PTR 50[rbp], 65
	mov	WORD PTR 52[rbp], 108
	mov	WORD PTR 54[rbp], 108
	mov	WORD PTR 56[rbp], 0
	lea	rdx, 32[rbp]
	lea	rax, 64[rbp]
	mov	DWORD PTR 32[rsp], 0
	movabs	r9, -9223372036854775796
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrAssign
	mov	eax, DWORD PTR 608[rbp]
	movsx	rdx, eax
	mov	r8, QWORD PTR 696[rbp]
	lea	rcx, 64[rbp]
	lea	rax, -80[rbp]
	mov	r9, r8
	mov	r8, rcx
	mov	rcx, rax
	call	_Z6FsFailIxEN2FB11FSERRORCODEERK9FBUSTRINGS4_
	mov	QWORD PTR 600[rbp], rax
	mov	rax, QWORD PTR 600[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 688[rbp]
	call	_ZN6ResultIxN2FB7FSERROREEC1ERKS2_
	lea	rax, 64[rbp]
	mov	rcx, rax
	call	fb_UStrDelete
	lea	rax, -80[rbp]
	mov	rcx, rax
	call	_ZN6ResultIxN2FB7FSERROREED1Ev
	lea	rax, 192[rbp]
	mov	rcx, rax
	call	_ZN6ResultIiN2FB7FSERROREED1Ev
	lea	rax, 304[rbp]
	mov	rcx, rax
	call	_ZN5ArrayIN2FB8DIRENTRYEED1Ev
	jmp	.L3188
.L3217:
.L3237:
	nop
.L3218:
	mov	rax, QWORD PTR 664[rbp]
	add	rax, 1
	mov	QWORD PTR 392[rbp], rax
	lea	rdx, 392[rbp]
	lea	rax, 400[rbp]
	mov	rcx, rax
	call	_Z2OkIxN2FB7FSERROREERx
	mov	QWORD PTR 592[rbp], rax
	mov	rax, QWORD PTR 592[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 688[rbp]
	call	_ZN6ResultIxN2FB7FSERROREEC1ERKS2_
	lea	rax, 400[rbp]
	mov	rcx, rax
	call	_ZN6ResultIxN2FB7FSERROREED1Ev
	lea	rax, 192[rbp]
	mov	rcx, rax
	call	_ZN6ResultIiN2FB7FSERROREED1Ev
	lea	rax, 304[rbp]
	mov	rcx, rax
	call	_ZN5ArrayIN2FB8DIRENTRYEED1Ev
	nop
.L3188:
	mov	rax, QWORD PTR 688[rbp]
	add	rsp, 800
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN2FB8COPYFILEERK9FBUSTRINGS2_b;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN2FB8COPYFILEERK9FBUSTRINGS2_b
_ZN2FB8COPYFILEERK9FBUSTRINGS2_b:
	push	rbp
	.seh_pushreg	rbp
	sub	rsp, 464
	.seh_stackalloc	464
	lea	rbp, 128[rsp]
	.seh_setframe	rbp, 128
	.seh_endprologue
	mov	QWORD PTR 352[rbp], rcx
	mov	QWORD PTR 360[rbp], rdx
	mov	QWORD PTR 368[rbp], r8
	mov	eax, r9d
	mov	BYTE PTR 376[rbp], al
.L3239:
	cmp	BYTE PTR 376[rbp], 0
	je	.L3250
	mov	QWORD PTR 328[rbp], 1
	jmp	.L3242
.L3250:
	nop
.L3241:
	mov	QWORD PTR 328[rbp], 0
.L3242:
	mov	rax, QWORD PTR 328[rbp]
	mov	ecx, eax
	mov	rdx, QWORD PTR 368[rbp]
	mov	rax, QWORD PTR 360[rbp]
	mov	r8d, ecx
	mov	rcx, rax
	call	fb_UStrFsCopyFile
	mov	DWORD PTR 324[rbp], eax
	mov	eax, DWORD PTR 324[rbp]
	mov	DWORD PTR 320[rbp], eax
	cmp	DWORD PTR 320[rbp], 0
	je	.L3251
	lea	rax, 160[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	WORD PTR 128[rbp], 67
	mov	WORD PTR 130[rbp], 111
	mov	WORD PTR 132[rbp], 112
	mov	WORD PTR 134[rbp], 121
	mov	WORD PTR 136[rbp], 70
	mov	WORD PTR 138[rbp], 105
	mov	WORD PTR 140[rbp], 108
	mov	WORD PTR 142[rbp], 101
	mov	WORD PTR 144[rbp], 0
	lea	rdx, 128[rbp]
	lea	rax, 160[rbp]
	mov	DWORD PTR 32[rsp], 0
	movabs	r9, -9223372036854775800
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrAssign
	call	fb_FsOsError
	mov	DWORD PTR 316[rbp], eax
	mov	eax, DWORD PTR 320[rbp]
	movsx	rdx, eax
	lea	r9, 160[rbp]
	mov	r8d, DWORD PTR 316[rbp]
	lea	rax, -80[rbp]
	mov	rcx, QWORD PTR 360[rbp]
	mov	QWORD PTR 32[rsp], rcx
	mov	rcx, rax
	call	_ZN2FB7FSERRORC1ENS_11FSERRORCODEEiRK9FBUSTRINGS4_
	lea	rax, 160[rbp]
	mov	rcx, rax
	call	fb_UStrDelete
	mov	rdx, QWORD PTR 368[rbp]
	lea	rax, -80[rbp]
	mov	rcx, rax
	call	_ZN2FB7FSERROR8SETPATH2ERK9FBUSTRING
	lea	rdx, -80[rbp]
	lea	rax, 16[rbp]
	mov	rcx, rax
	call	_Z4FailIbN2FB7FSERROREERS1_
	mov	QWORD PTR 304[rbp], rax
	mov	rax, QWORD PTR 304[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 352[rbp]
	call	_ZN6ResultIbN2FB7FSERROREEC1ERKS2_
	lea	rax, 16[rbp]
	mov	rcx, rax
	call	_ZN6ResultIbN2FB7FSERROREED1Ev
	lea	rax, -80[rbp]
	mov	rcx, rax
	call	_ZN2FB7FSERRORD1Ev
	jmp	.L3245
.L3244:
.L3251:
	nop
.L3246:
	mov	BYTE PTR 191[rbp], 1
	lea	rdx, 191[rbp]
	lea	rax, 192[rbp]
	mov	rcx, rax
	call	_Z2OkIbN2FB7FSERROREERb
	mov	QWORD PTR 296[rbp], rax
	mov	rax, QWORD PTR 296[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 352[rbp]
	call	_ZN6ResultIbN2FB7FSERROREEC1ERKS2_
	lea	rax, 192[rbp]
	mov	rcx, rax
	call	_ZN6ResultIbN2FB7FSERROREED1Ev
	nop
.L3245:
	mov	rax, QWORD PTR 352[rbp]
	add	rsp, 464
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN2FB7COPYDIRERK9FBUSTRINGS2_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN2FB7COPYDIRERK9FBUSTRINGS2_
_ZN2FB7COPYDIRERK9FBUSTRINGS2_:
	push	rbp
	.seh_pushreg	rbp
	sub	rsp, 1472
	.seh_stackalloc	1472
	lea	rbp, 128[rsp]
	.seh_setframe	rbp, 128
	.seh_endprologue
	mov	QWORD PTR 1360[rbp], rcx
	mov	QWORD PTR 1368[rbp], rdx
	mov	QWORD PTR 1376[rbp], r8
.L3253:
	lea	rax, 912[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	lea	rax, 880[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	rdx, QWORD PTR 1368[rbp]
	lea	rax, 752[rbp]
	mov	rcx, rax
	call	_ZN2FB12ABSOLUTEPATHERK9FBUSTRING
	mov	rdx, QWORD PTR 1376[rbp]
	lea	rax, 624[rbp]
	mov	rcx, rax
	call	_ZN2FB12ABSOLUTEPATHERK9FBUSTRING
	lea	rax, 752[rbp]
	mov	rcx, rax
	call	_ZN6ResultI9FBUSTRINGN2FB7FSERROREE4ISOKEv
	mov	BYTE PTR 1338[rbp], al
	cmp	BYTE PTR 1338[rbp], 0
	jne	.L3295
	lea	rax, 752[rbp]
	mov	rcx, rax
	call	_ZN6ResultI9FBUSTRINGN2FB7FSERROREE7FAILUREEv
	mov	QWORD PTR 1328[rbp], rax
	mov	rdx, QWORD PTR 1328[rbp]
	lea	rax, 32[rbp]
	mov	rcx, rax
	call	_Z4FailIxN2FB7FSERROREERS1_
	mov	QWORD PTR 1320[rbp], rax
	mov	rax, QWORD PTR 1320[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 1360[rbp]
	call	_ZN6ResultIxN2FB7FSERROREEC1ERKS2_
	lea	rax, 32[rbp]
	mov	rcx, rax
	call	_ZN6ResultIxN2FB7FSERROREED1Ev
	lea	rax, 624[rbp]
	mov	rcx, rax
	call	_ZN6ResultI9FBUSTRINGN2FB7FSERROREED1Ev
	lea	rax, 752[rbp]
	mov	rcx, rax
	call	_ZN6ResultI9FBUSTRINGN2FB7FSERROREED1Ev
	lea	rax, 880[rbp]
	mov	rcx, rax
	call	fb_UStrDelete
	lea	rax, 912[rbp]
	mov	rcx, rax
	call	fb_UStrDelete
	jmp	.L3256
.L3295:
	nop
.L3255:
	lea	rax, 624[rbp]
	mov	rcx, rax
	call	_ZN6ResultI9FBUSTRINGN2FB7FSERROREE4ISOKEv
	mov	BYTE PTR 1319[rbp], al
	cmp	BYTE PTR 1319[rbp], 0
	jne	.L3296
	lea	rax, 624[rbp]
	mov	rcx, rax
	call	_ZN6ResultI9FBUSTRINGN2FB7FSERROREE7FAILUREEv
	mov	QWORD PTR 1304[rbp], rax
	mov	rdx, QWORD PTR 1304[rbp]
	lea	rax, 32[rbp]
	mov	rcx, rax
	call	_Z4FailIxN2FB7FSERROREERS1_
	mov	QWORD PTR 1296[rbp], rax
	mov	rax, QWORD PTR 1296[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 1360[rbp]
	call	_ZN6ResultIxN2FB7FSERROREEC1ERKS2_
	lea	rax, 32[rbp]
	mov	rcx, rax
	call	_ZN6ResultIxN2FB7FSERROREED1Ev
	lea	rax, 624[rbp]
	mov	rcx, rax
	call	_ZN6ResultI9FBUSTRINGN2FB7FSERROREED1Ev
	lea	rax, 752[rbp]
	mov	rcx, rax
	call	_ZN6ResultI9FBUSTRINGN2FB7FSERROREED1Ev
	lea	rax, 880[rbp]
	mov	rcx, rax
	call	fb_UStrDelete
	lea	rax, 912[rbp]
	mov	rcx, rax
	call	fb_UStrDelete
	jmp	.L3256
.L3296:
	nop
.L3258:
	lea	rax, 752[rbp]
	mov	rcx, rax
	call	_ZN6ResultI9FBUSTRINGN2FB7FSERROREE5VALUEEv
	mov	QWORD PTR 1288[rbp], rax
	mov	rax, QWORD PTR 1288[rbp]
	mov	edx, 1
	mov	rcx, rax
	call	fb_UStrPathNormalize
	mov	QWORD PTR 1280[rbp], rax
	mov	rdx, QWORD PTR 1280[rbp]
	lea	rax, 912[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrAssign
	lea	rax, 624[rbp]
	mov	rcx, rax
	call	_ZN6ResultI9FBUSTRINGN2FB7FSERROREE5VALUEEv
	mov	QWORD PTR 1272[rbp], rax
	mov	rax, QWORD PTR 1272[rbp]
	mov	edx, 1
	mov	rcx, rax
	call	fb_UStrPathNormalize
	mov	QWORD PTR 1264[rbp], rax
	mov	rdx, QWORD PTR 1264[rbp]
	lea	rax, 880[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrAssign
	lea	rdx, 912[rbp]
	lea	rax, 880[rbp]
	mov	r8d, 1
	mov	rcx, rax
	call	fb_UStrPathStartsWith
	mov	BYTE PTR 1263[rbp], al
	cmp	BYTE PTR 1263[rbp], 0
	je	.L3297
	lea	rax, 288[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	WORD PTR 272[rbp], 67
	mov	WORD PTR 274[rbp], 111
	mov	WORD PTR 276[rbp], 112
	mov	WORD PTR 278[rbp], 121
	mov	WORD PTR 280[rbp], 68
	mov	WORD PTR 282[rbp], 105
	mov	WORD PTR 284[rbp], 114
	mov	WORD PTR 286[rbp], 0
	lea	rdx, 272[rbp]
	lea	rax, 288[rbp]
	mov	DWORD PTR 32[rsp], 0
	movabs	r9, -9223372036854775801
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrAssign
	mov	rcx, QWORD PTR 1376[rbp]
	lea	rdx, 288[rbp]
	lea	rax, 32[rbp]
	mov	r9, rcx
	mov	r8, rdx
	mov	edx, 7
	mov	rcx, rax
	call	_Z6FsFailIxEN2FB11FSERRORCODEERK9FBUSTRINGS4_
	mov	QWORD PTR 1248[rbp], rax
	mov	rax, QWORD PTR 1248[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 1360[rbp]
	call	_ZN6ResultIxN2FB7FSERROREEC1ERKS2_
	lea	rax, 288[rbp]
	mov	rcx, rax
	call	fb_UStrDelete
	lea	rax, 32[rbp]
	mov	rcx, rax
	call	_ZN6ResultIxN2FB7FSERROREED1Ev
	lea	rax, 624[rbp]
	mov	rcx, rax
	call	_ZN6ResultI9FBUSTRINGN2FB7FSERROREED1Ev
	lea	rax, 752[rbp]
	mov	rcx, rax
	call	_ZN6ResultI9FBUSTRINGN2FB7FSERROREED1Ev
	lea	rax, 880[rbp]
	mov	rcx, rax
	call	fb_UStrDelete
	lea	rax, 912[rbp]
	mov	rcx, rax
	call	fb_UStrDelete
	jmp	.L3256
.L3260:
.L3297:
	nop
.L3261:
	mov	rdx, QWORD PTR 1376[rbp]
	lea	rax, 512[rbp]
	mov	rcx, rax
	call	_ZN2FB12CREATEDIRALLERK9FBUSTRING
	lea	rax, 512[rbp]
	mov	rcx, rax
	call	_ZN6ResultIbN2FB7FSERROREE4ISOKEv
	mov	BYTE PTR 1247[rbp], al
	cmp	BYTE PTR 1247[rbp], 0
	jne	.L3298
	lea	rax, 512[rbp]
	mov	rcx, rax
	call	_ZN6ResultIbN2FB7FSERROREE7FAILUREEv
	mov	QWORD PTR 1232[rbp], rax
	mov	rdx, QWORD PTR 1232[rbp]
	lea	rax, 32[rbp]
	mov	rcx, rax
	call	_Z4FailIxN2FB7FSERROREERS1_
	mov	QWORD PTR 1224[rbp], rax
	mov	rax, QWORD PTR 1224[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 1360[rbp]
	call	_ZN6ResultIxN2FB7FSERROREEC1ERKS2_
	lea	rax, 32[rbp]
	mov	rcx, rax
	call	_ZN6ResultIxN2FB7FSERROREED1Ev
	lea	rax, 512[rbp]
	mov	rcx, rax
	call	_ZN6ResultIbN2FB7FSERROREED1Ev
	lea	rax, 624[rbp]
	mov	rcx, rax
	call	_ZN6ResultI9FBUSTRINGN2FB7FSERROREED1Ev
	lea	rax, 752[rbp]
	mov	rcx, rax
	call	_ZN6ResultI9FBUSTRINGN2FB7FSERROREED1Ev
	lea	rax, 880[rbp]
	mov	rcx, rax
	call	fb_UStrDelete
	lea	rax, 912[rbp]
	mov	rcx, rax
	call	fb_UStrDelete
	jmp	.L3256
.L3263:
.L3298:
	nop
.L3264:
	lea	rax, 432[rbp]
	mov	rcx, rax
	call	_ZN5ArrayIN2FB8DIRENTRYEEC1Ev
	lea	rcx, 432[rbp]
	mov	rdx, QWORD PTR 1368[rbp]
	lea	rax, 320[rbp]
	mov	r8, rcx
	mov	rcx, rax
	call	_ZN2FB7LISTDIRERK9FBUSTRINGR5ArrayIN2FB8DIRENTRYEE
	lea	rax, 320[rbp]
	mov	rcx, rax
	call	_ZN6ResultIiN2FB7FSERROREE4ISOKEv
	mov	BYTE PTR 1223[rbp], al
	cmp	BYTE PTR 1223[rbp], 0
	jne	.L3299
	lea	rax, 320[rbp]
	mov	rcx, rax
	call	_ZN6ResultIiN2FB7FSERROREE7FAILUREEv
	mov	QWORD PTR 1208[rbp], rax
	mov	rdx, QWORD PTR 1208[rbp]
	lea	rax, 32[rbp]
	mov	rcx, rax
	call	_Z4FailIxN2FB7FSERROREERS1_
	mov	QWORD PTR 1200[rbp], rax
	mov	rax, QWORD PTR 1200[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 1360[rbp]
	call	_ZN6ResultIxN2FB7FSERROREEC1ERKS2_
	lea	rax, 32[rbp]
	mov	rcx, rax
	call	_ZN6ResultIxN2FB7FSERROREED1Ev
	lea	rax, 320[rbp]
	mov	rcx, rax
	call	_ZN6ResultIiN2FB7FSERROREED1Ev
	lea	rax, 432[rbp]
	mov	rcx, rax
	call	_ZN5ArrayIN2FB8DIRENTRYEED1Ev
	lea	rax, 512[rbp]
	mov	rcx, rax
	call	_ZN6ResultIbN2FB7FSERROREED1Ev
	lea	rax, 624[rbp]
	mov	rcx, rax
	call	_ZN6ResultI9FBUSTRINGN2FB7FSERROREED1Ev
	lea	rax, 752[rbp]
	mov	rcx, rax
	call	_ZN6ResultI9FBUSTRINGN2FB7FSERROREED1Ev
	lea	rax, 880[rbp]
	mov	rcx, rax
	call	fb_UStrDelete
	lea	rax, 912[rbp]
	mov	rcx, rax
	call	fb_UStrDelete
	jmp	.L3256
.L3266:
.L3299:
	nop
.L3267:
	mov	QWORD PTR 312[rbp], 1
	mov	DWORD PTR 1340[rbp], 0
	lea	rax, 432[rbp]
	mov	rcx, rax
	call	_ZN5ArrayIN2FB8DIRENTRYEE5COUNTEv
	mov	DWORD PTR 1196[rbp], eax
	mov	eax, DWORD PTR 1196[rbp]
	sub	eax, 1
	mov	DWORD PTR 1192[rbp], eax
	jmp	.L3268
.L3304:
	nop
.L3269:
	lea	rax, 240[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	edx, DWORD PTR 1340[rbp]
	lea	rax, 432[rbp]
	mov	rcx, rax
	call	_ZN5ArrayIN2FB8DIRENTRYEEixEi
	mov	QWORD PTR 1176[rbp], rax
	mov	rax, QWORD PTR 1176[rbp]
	mov	rcx, rax
	call	_ZNK2FB8DIRENTRY4NAMEEv
	mov	QWORD PTR 1168[rbp], rax
	mov	rdx, QWORD PTR 1168[rbp]
	lea	rax, 240[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrAssign
	lea	rdx, 240[rbp]
	mov	rax, QWORD PTR 1376[rbp]
	mov	r8d, 1
	mov	rcx, rax
	call	fb_UStrPathJoin2
	mov	QWORD PTR 1160[rbp], rax
	mov	rdx, QWORD PTR 1160[rbp]
	lea	rax, 208[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrInit
	lea	rax, 240[rbp]
	mov	rcx, rax
	call	fb_UStrDelete
	mov	edx, DWORD PTR 1340[rbp]
	lea	rax, 432[rbp]
	mov	rcx, rax
	call	_ZN5ArrayIN2FB8DIRENTRYEEixEi
	mov	QWORD PTR 1152[rbp], rax
	mov	rax, QWORD PTR 1152[rbp]
	mov	rcx, rax
	call	_ZNK2FB8DIRENTRY11ISDIRECTORYEv
	mov	BYTE PTR 1151[rbp], al
	cmp	BYTE PTR 1151[rbp], 0
	je	.L3300
	mov	edx, DWORD PTR 1340[rbp]
	lea	rax, 432[rbp]
	mov	rcx, rax
	call	_ZN5ArrayIN2FB8DIRENTRYEEixEi
	mov	QWORD PTR 1136[rbp], rax
	mov	rax, QWORD PTR 1136[rbp]
	mov	rcx, rax
	call	_ZNK2FB8DIRENTRY9ISSYMLINKEv
	mov	BYTE PTR 1135[rbp], al
	cmp	BYTE PTR 1135[rbp], 0
	sete	al
	mov	BYTE PTR 1339[rbp], al
	jmp	.L3272
.L3300:
	nop
.L3271:
	mov	BYTE PTR 1339[rbp], 0
.L3272:
	cmp	BYTE PTR 1339[rbp], 0
	je	.L3301
	lea	rax, 176[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	edx, DWORD PTR 1340[rbp]
	lea	rax, 432[rbp]
	mov	rcx, rax
	call	_ZN5ArrayIN2FB8DIRENTRYEEixEi
	mov	QWORD PTR 1120[rbp], rax
	mov	rax, QWORD PTR 1120[rbp]
	mov	rcx, rax
	call	_ZNK2FB8DIRENTRY4PATHEv
	mov	QWORD PTR 1112[rbp], rax
	mov	rdx, QWORD PTR 1112[rbp]
	lea	rax, 176[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrAssign
	lea	rcx, 208[rbp]
	lea	rdx, 176[rbp]
	lea	rax, 32[rbp]
	mov	r8, rcx
	mov	rcx, rax
	call	_ZN2FB7COPYDIRERK9FBUSTRINGS2_
	lea	rax, 176[rbp]
	mov	rcx, rax
	call	fb_UStrDelete
	lea	rax, 32[rbp]
	mov	rcx, rax
	call	_ZN6ResultIxN2FB7FSERROREE4ISOKEv
	mov	BYTE PTR 1111[rbp], al
	cmp	BYTE PTR 1111[rbp], 0
	jne	.L3302
	lea	rax, 32[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 1360[rbp]
	call	_ZN6ResultIxN2FB7FSERROREEC1ERKS2_
	lea	rax, 32[rbp]
	mov	rcx, rax
	call	_ZN6ResultIxN2FB7FSERROREED1Ev
	lea	rax, 208[rbp]
	mov	rcx, rax
	call	fb_UStrDelete
	lea	rax, 320[rbp]
	mov	rcx, rax
	call	_ZN6ResultIiN2FB7FSERROREED1Ev
	lea	rax, 432[rbp]
	mov	rcx, rax
	call	_ZN5ArrayIN2FB8DIRENTRYEED1Ev
	lea	rax, 512[rbp]
	mov	rcx, rax
	call	_ZN6ResultIbN2FB7FSERROREED1Ev
	lea	rax, 624[rbp]
	mov	rcx, rax
	call	_ZN6ResultI9FBUSTRINGN2FB7FSERROREED1Ev
	lea	rax, 752[rbp]
	mov	rcx, rax
	call	_ZN6ResultI9FBUSTRINGN2FB7FSERROREED1Ev
	lea	rax, 880[rbp]
	mov	rcx, rax
	call	fb_UStrDelete
	lea	rax, 912[rbp]
	mov	rcx, rax
	call	fb_UStrDelete
	jmp	.L3256
.L3302:
	nop
.L3276:
	lea	rax, 32[rbp]
	mov	rcx, rax
	call	_ZN6ResultIxN2FB7FSERROREE5VALUEEv
	mov	QWORD PTR 1096[rbp], rax
	mov	rax, QWORD PTR 1096[rbp]
	mov	rdx, QWORD PTR [rax]
	mov	rax, QWORD PTR 312[rbp]
	add	rax, rdx
	mov	QWORD PTR 312[rbp], rax
	lea	rax, 32[rbp]
	mov	rcx, rax
	call	_ZN6ResultIxN2FB7FSERROREED1Ev
	jmp	.L3278
.L3301:
	nop
.L3274:
	lea	rax, 144[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	edx, DWORD PTR 1340[rbp]
	lea	rax, 432[rbp]
	mov	rcx, rax
	call	_ZN5ArrayIN2FB8DIRENTRYEEixEi
	mov	QWORD PTR 1088[rbp], rax
	mov	rax, QWORD PTR 1088[rbp]
	mov	rcx, rax
	call	_ZNK2FB8DIRENTRY4PATHEv
	mov	QWORD PTR 1080[rbp], rax
	mov	rdx, QWORD PTR 1080[rbp]
	lea	rax, 144[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrAssign
	lea	rcx, 208[rbp]
	lea	rdx, 144[rbp]
	lea	rax, -80[rbp]
	mov	r9d, 0
	mov	r8, rcx
	mov	rcx, rax
	call	_ZN2FB8COPYFILEERK9FBUSTRINGS2_b
	lea	rax, 144[rbp]
	mov	rcx, rax
	call	fb_UStrDelete
	lea	rax, -80[rbp]
	mov	rcx, rax
	call	_ZN6ResultIbN2FB7FSERROREE4ISOKEv
	mov	BYTE PTR 1079[rbp], al
	cmp	BYTE PTR 1079[rbp], 0
	jne	.L3303
	lea	rax, -80[rbp]
	mov	rcx, rax
	call	_ZN6ResultIbN2FB7FSERROREE7FAILUREEv
	mov	QWORD PTR 1064[rbp], rax
	mov	rdx, QWORD PTR 1064[rbp]
	lea	rax, 32[rbp]
	mov	rcx, rax
	call	_Z4FailIxN2FB7FSERROREERS1_
	mov	QWORD PTR 1056[rbp], rax
	mov	rax, QWORD PTR 1056[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 1360[rbp]
	call	_ZN6ResultIxN2FB7FSERROREEC1ERKS2_
	lea	rax, 32[rbp]
	mov	rcx, rax
	call	_ZN6ResultIxN2FB7FSERROREED1Ev
	lea	rax, -80[rbp]
	mov	rcx, rax
	call	_ZN6ResultIbN2FB7FSERROREED1Ev
	lea	rax, 208[rbp]
	mov	rcx, rax
	call	fb_UStrDelete
	lea	rax, 320[rbp]
	mov	rcx, rax
	call	_ZN6ResultIiN2FB7FSERROREED1Ev
	lea	rax, 432[rbp]
	mov	rcx, rax
	call	_ZN5ArrayIN2FB8DIRENTRYEED1Ev
	lea	rax, 512[rbp]
	mov	rcx, rax
	call	_ZN6ResultIbN2FB7FSERROREED1Ev
	lea	rax, 624[rbp]
	mov	rcx, rax
	call	_ZN6ResultI9FBUSTRINGN2FB7FSERROREED1Ev
	lea	rax, 752[rbp]
	mov	rcx, rax
	call	_ZN6ResultI9FBUSTRINGN2FB7FSERROREED1Ev
	lea	rax, 880[rbp]
	mov	rcx, rax
	call	fb_UStrDelete
	lea	rax, 912[rbp]
	mov	rcx, rax
	call	fb_UStrDelete
	jmp	.L3256
.L3280:
.L3303:
	nop
.L3281:
	mov	rax, QWORD PTR 312[rbp]
	add	rax, 1
	mov	QWORD PTR 312[rbp], rax
	lea	rax, -80[rbp]
	mov	rcx, rax
	call	_ZN6ResultIbN2FB7FSERROREED1Ev
.L3278:
	lea	rax, 208[rbp]
	mov	rcx, rax
	call	fb_UStrDelete
.L3282:
	add	DWORD PTR 1340[rbp], 1
.L3268:
	mov	eax, DWORD PTR 1340[rbp]
	cmp	eax, DWORD PTR 1192[rbp]
	jle	.L3304
	nop
.L3283:
	lea	rdx, 312[rbp]
	lea	rax, 944[rbp]
	mov	rcx, rax
	call	_Z2OkIxN2FB7FSERROREERx
	mov	QWORD PTR 1184[rbp], rax
	mov	rax, QWORD PTR 1184[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 1360[rbp]
	call	_ZN6ResultIxN2FB7FSERROREEC1ERKS2_
	lea	rax, 944[rbp]
	mov	rcx, rax
	call	_ZN6ResultIxN2FB7FSERROREED1Ev
	lea	rax, 320[rbp]
	mov	rcx, rax
	call	_ZN6ResultIiN2FB7FSERROREED1Ev
	lea	rax, 432[rbp]
	mov	rcx, rax
	call	_ZN5ArrayIN2FB8DIRENTRYEED1Ev
	lea	rax, 512[rbp]
	mov	rcx, rax
	call	_ZN6ResultIbN2FB7FSERROREED1Ev
	lea	rax, 624[rbp]
	mov	rcx, rax
	call	_ZN6ResultI9FBUSTRINGN2FB7FSERROREED1Ev
	lea	rax, 752[rbp]
	mov	rcx, rax
	call	_ZN6ResultI9FBUSTRINGN2FB7FSERROREED1Ev
	lea	rax, 880[rbp]
	mov	rcx, rax
	call	fb_UStrDelete
	lea	rax, 912[rbp]
	mov	rcx, rax
	call	fb_UStrDelete
	nop
.L3256:
	mov	rax, QWORD PTR 1360[rbp]
	add	rsp, 1472
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN2FB8GLOBROOTERK9FBUSTRINGi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN2FB8GLOBROOTERK9FBUSTRINGi
_ZN2FB8GLOBROOTERK9FBUSTRINGi:
	push	rbp
	.seh_pushreg	rbp
	sub	rsp, 288
	.seh_stackalloc	288
	lea	rbp, 128[rsp]
	.seh_setframe	rbp, 128
	.seh_endprologue
	mov	QWORD PTR 176[rbp], rcx
	mov	DWORD PTR 184[rbp], edx
	lea	rax, 32[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
.L3306:
	mov	eax, DWORD PTR 184[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 176[rbp]
	call	fb_UStrFsPatternWildcardAt
	mov	QWORD PTR 128[rbp], rax
	mov	rax, QWORD PTR 128[rbp]
	mov	QWORD PTR 120[rbp], rax
	cmp	QWORD PTR 120[rbp], 0
	jns	.L3338
	mov	eax, DWORD PTR 184[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 176[rbp]
	call	fb_UStrPathParent
	mov	QWORD PTR 112[rbp], rax
	mov	rdx, QWORD PTR 112[rbp]
	lea	rax, -32[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrInit
	lea	rax, -32[rbp]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrLen
	mov	QWORD PTR 104[rbp], rax
	cmp	QWORD PTR 104[rbp], 0
	jne	.L3339
	mov	WORD PTR -36[rbp], 46
	mov	WORD PTR -34[rbp], 0
	lea	rdx, -36[rbp]
	lea	rax, 32[rbp]
	mov	DWORD PTR 32[rsp], 0
	movabs	r9, -9223372036854775807
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrInit
	lea	rax, -32[rbp]
	mov	rcx, rax
	call	fb_UStrDelete
	jmp	.L3312
.L3339:
	nop
.L3310:
	lea	rdx, -32[rbp]
	lea	rax, 32[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrInit
	lea	rax, -32[rbp]
	mov	rcx, rax
	call	fb_UStrDelete
	jmp	.L3312
.L3308:
.L3338:
	nop
.L3313:
	mov	eax, DWORD PTR 184[rbp]
	mov	ecx, eax
	call	_ZN2FB13PATHSEPARATOREi
	mov	QWORD PTR 96[rbp], rax
	mov	rdx, QWORD PTR 96[rbp]
	mov	rax, rbp
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrInit
	mov	rax, QWORD PTR 120[rbp]
	sub	rax, 1
	mov	QWORD PTR 152[rbp], rax
	jmp	.L3314
.L3344:
	nop
.L3315:
	mov	rax, QWORD PTR 152[rbp]
	add	rax, 1
	mov	r9d, 1
	mov	r8, rax
	mov	rdx, -1
	mov	rcx, QWORD PTR 176[rbp]
	call	fb_UStrMid
	mov	QWORD PTR 88[rbp], rax
	mov	rdx, QWORD PTR 88[rbp]
	lea	rax, -64[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrInit
	mov	WORD PTR -68[rbp], 92
	mov	WORD PTR -66[rbp], 0
	lea	rdx, -68[rbp]
	lea	rax, -64[rbp]
	movabs	r9, -9223372036854775807
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrCompare
	mov	DWORD PTR 84[rbp], eax
	cmp	DWORD PTR 84[rbp], 0
	jne	.L3340
	cmp	DWORD PTR 184[rbp], 1
	sete	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR 144[rbp], rax
	jmp	.L3318
.L3340:
	nop
.L3317:
	mov	QWORD PTR 144[rbp], 0
.L3318:
	cmp	QWORD PTR 144[rbp], 0
	jne	.L3341
	mov	WORD PTR -72[rbp], 47
	mov	WORD PTR -70[rbp], 0
	lea	rdx, -72[rbp]
	lea	rax, -64[rbp]
	movabs	r9, -9223372036854775807
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrCompare
	mov	DWORD PTR 80[rbp], eax
	cmp	DWORD PTR 80[rbp], 0
	sete	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR 136[rbp], rax
	jmp	.L3321
.L3341:
	nop
.L3320:
	mov	QWORD PTR 136[rbp], -1
.L3321:
	cmp	QWORD PTR 136[rbp], 0
	je	.L3342
	cmp	QWORD PTR 152[rbp], 0
	jne	.L3343
	mov	rdx, rbp
	lea	rax, 32[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrInit
	lea	rax, -64[rbp]
	mov	rcx, rax
	call	fb_UStrDelete
	mov	rax, rbp
	mov	rcx, rax
	call	fb_UStrDelete
	jmp	.L3312
.L3343:
	nop
.L3325:
	mov	rax, QWORD PTR 152[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 176[rbp]
	call	fb_UStrLeftD
	mov	QWORD PTR 72[rbp], rax
	mov	rdx, QWORD PTR 72[rbp]
	lea	rax, 32[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrInit
	lea	rax, -64[rbp]
	mov	rcx, rax
	call	fb_UStrDelete
	mov	rax, rbp
	mov	rcx, rax
	call	fb_UStrDelete
	jmp	.L3312
.L3323:
.L3342:
	nop
.L3327:
	lea	rax, -64[rbp]
	mov	rcx, rax
	call	fb_UStrDelete
.L3328:
	sub	QWORD PTR 152[rbp], 1
.L3314:
	cmp	QWORD PTR 152[rbp], 0
	jns	.L3344
	nop
.L3329:
	mov	WORD PTR -4[rbp], 46
	mov	WORD PTR -2[rbp], 0
	lea	rdx, -4[rbp]
	lea	rax, 32[rbp]
	mov	DWORD PTR 32[rsp], 0
	movabs	r9, -9223372036854775807
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrInit
	mov	rax, rbp
	mov	rcx, rax
	call	fb_UStrDelete
	nop
.L3312:
	lea	rax, 32[rbp]
	mov	rcx, rax
	call	fb_UStrAllocTempResult
	mov	QWORD PTR 64[rbp], rax
	mov	rax, QWORD PTR 64[rbp]
	add	rsp, 288
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN2FB13HGLOBRELATIVEERK9FBUSTRINGS2_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN2FB13HGLOBRELATIVEERK9FBUSTRINGS2_
_ZN2FB13HGLOBRELATIVEERK9FBUSTRINGS2_:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 224
	.seh_stackalloc	224
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
	lea	rax, -96[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
.L3346:
	mov	rax, QWORD PTR 24[rbp]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrLen
	mov	QWORD PTR -16[rbp], rax
	mov	rax, QWORD PTR -16[rbp]
	add	rax, 1
	mov	r9, -1
	mov	r8, rax
	mov	rdx, -1
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_UStrMid
	mov	QWORD PTR -24[rbp], rax
	mov	rdx, QWORD PTR -24[rbp]
	lea	rax, -128[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrInit
.L3347:
	lea	rax, -128[rbp]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrLen
	mov	QWORD PTR -32[rbp], rax
	cmp	QWORD PTR -32[rbp], 0
	jle	.L3359
	lea	rax, -128[rbp]
	mov	edx, 1
	mov	rcx, rax
	call	fb_UStrLeftD
	mov	QWORD PTR -40[rbp], rax
	mov	rdx, QWORD PTR -40[rbp]
	lea	rax, -160[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrInit
	mov	WORD PTR -164[rbp], 92
	mov	WORD PTR -162[rbp], 0
	lea	rdx, -164[rbp]
	lea	rax, -160[rbp]
	movabs	r9, -9223372036854775807
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrCompare
	mov	DWORD PTR -44[rbp], eax
	cmp	DWORD PTR -44[rbp], 0
	je	.L3360
	mov	WORD PTR -168[rbp], 47
	mov	WORD PTR -166[rbp], 0
	lea	rdx, -168[rbp]
	lea	rax, -160[rbp]
	movabs	r9, -9223372036854775807
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrCompare
	mov	DWORD PTR -48[rbp], eax
	cmp	DWORD PTR -48[rbp], 0
	setne	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -8[rbp], rax
	jmp	.L3352
.L3360:
	nop
.L3351:
	mov	QWORD PTR -8[rbp], 0
.L3352:
	cmp	QWORD PTR -8[rbp], 0
	je	.L3361
	lea	rax, -160[rbp]
	mov	rcx, rax
	call	fb_UStrDelete
	jmp	.L3349
.L3361:
	nop
.L3354:
	lea	rax, -128[rbp]
	mov	r9, -1
	mov	r8d, 2
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrMid
	mov	QWORD PTR -56[rbp], rax
	mov	rdx, QWORD PTR -56[rbp]
	lea	rax, -128[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrAssign
	lea	rax, -160[rbp]
	mov	rcx, rax
	call	fb_UStrDelete
	jmp	.L3347
.L3359:
	nop
.L3349:
	lea	rdx, -128[rbp]
	lea	rax, -96[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrInit
	lea	rax, -128[rbp]
	mov	rcx, rax
	call	fb_UStrDelete
	nop
.L3355:
	lea	rax, -96[rbp]
	mov	rcx, rax
	call	fb_UStrAllocTempResult
	mov	QWORD PTR -64[rbp], rax
	mov	rax, QWORD PTR -64[rbp]
	add	rsp, 224
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN6ResultIjN2FB7FSERROREEC1Ev;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN6ResultIjN2FB7FSERROREEC1Ev
_ZN6ResultIjN2FB7FSERROREEC1Ev:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	rax, QWORD PTR 16[rbp]
	mov	DWORD PTR [rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	rcx, rax
	call	_ZN2FB7FSERRORC1Ev
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 96
	mov	BYTE PTR [rax], 0
	nop
	add	rsp, 32
	pop	rbp
	ret
.L3363:
.L3364:
	.seh_endproc
	.def	_ZN6ResultIjN2FB7FSERROREEaSERKS2_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN6ResultIjN2FB7FSERROREEaSERKS2_
_ZN6ResultIjN2FB7FSERROREEaSERKS2_:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
.L3366:
	mov	rax, QWORD PTR 24[rbp]
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	mov	DWORD PTR [rax], edx
	mov	rax, QWORD PTR 24[rbp]
	lea	rdx, 8[rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	rcx, rax
	call	_ZN2FB7FSERRORaSERKS0_
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 96[rax]
	mov	rax, QWORD PTR 24[rbp]
	movzx	eax, BYTE PTR 96[rax]
	mov	BYTE PTR [rdx], al
	nop
	add	rsp, 32
	pop	rbp
	ret
.L3367:
	.seh_endproc
	.def	_ZN6ResultIjN2FB7FSERROREEC1ERKS2_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN6ResultIjN2FB7FSERROREEC1ERKS2_
_ZN6ResultIjN2FB7FSERROREEC1ERKS2_:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
.L3369:
	mov	rax, QWORD PTR 16[rbp]
	mov	DWORD PTR [rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	rcx, rax
	call	_ZN2FB7FSERRORC1Ev
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 96
	mov	BYTE PTR [rax], 0
	mov	rax, QWORD PTR 24[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN6ResultIjN2FB7FSERROREEaSERKS2_
	nop
	add	rsp, 32
	pop	rbp
	ret
.L3370:
	.seh_endproc
	.def	_ZN6ResultIjN2FB7FSERROREED1Ev;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN6ResultIjN2FB7FSERROREED1Ev
_ZN6ResultIjN2FB7FSERROREED1Ev:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
.L3372:
.L3373:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	rcx, rax
	call	_ZN2FB7FSERRORD1Ev
	nop
	add	rsp, 32
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN2FB13CREATESYMLINKERK9FBUSTRINGS2_b;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN2FB13CREATESYMLINKERK9FBUSTRINGS2_b
_ZN2FB13CREATESYMLINKERK9FBUSTRINGS2_b:
	push	rbp
	.seh_pushreg	rbp
	sub	rsp, 464
	.seh_stackalloc	464
	lea	rbp, 128[rsp]
	.seh_setframe	rbp, 128
	.seh_endprologue
	mov	QWORD PTR 352[rbp], rcx
	mov	QWORD PTR 360[rbp], rdx
	mov	QWORD PTR 368[rbp], r8
	mov	eax, r9d
	mov	BYTE PTR 376[rbp], al
.L3375:
	cmp	BYTE PTR 376[rbp], 0
	je	.L3386
	mov	QWORD PTR 328[rbp], 1
	jmp	.L3378
.L3386:
	nop
.L3377:
	mov	QWORD PTR 328[rbp], 0
.L3378:
	mov	rax, QWORD PTR 328[rbp]
	mov	ecx, eax
	mov	rdx, QWORD PTR 368[rbp]
	mov	rax, QWORD PTR 360[rbp]
	mov	r8d, ecx
	mov	rcx, rax
	call	fb_UStrFsCreateSymlink
	mov	DWORD PTR 324[rbp], eax
	mov	eax, DWORD PTR 324[rbp]
	mov	DWORD PTR 320[rbp], eax
	cmp	DWORD PTR 320[rbp], 0
	je	.L3387
	lea	rax, 160[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	WORD PTR 128[rbp], 67
	mov	WORD PTR 130[rbp], 114
	mov	WORD PTR 132[rbp], 101
	mov	WORD PTR 134[rbp], 97
	mov	WORD PTR 136[rbp], 116
	mov	WORD PTR 138[rbp], 101
	mov	WORD PTR 140[rbp], 83
	mov	WORD PTR 142[rbp], 121
	mov	WORD PTR 144[rbp], 109
	mov	WORD PTR 146[rbp], 108
	mov	WORD PTR 148[rbp], 105
	mov	WORD PTR 150[rbp], 110
	mov	WORD PTR 152[rbp], 107
	mov	WORD PTR 154[rbp], 0
	lea	rdx, 128[rbp]
	lea	rax, 160[rbp]
	mov	DWORD PTR 32[rsp], 0
	movabs	r9, -9223372036854775795
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrAssign
	call	fb_FsOsError
	mov	DWORD PTR 316[rbp], eax
	mov	eax, DWORD PTR 320[rbp]
	movsx	rdx, eax
	lea	r9, 160[rbp]
	mov	r8d, DWORD PTR 316[rbp]
	lea	rax, -80[rbp]
	mov	rcx, QWORD PTR 368[rbp]
	mov	QWORD PTR 32[rsp], rcx
	mov	rcx, rax
	call	_ZN2FB7FSERRORC1ENS_11FSERRORCODEEiRK9FBUSTRINGS4_
	lea	rax, 160[rbp]
	mov	rcx, rax
	call	fb_UStrDelete
	mov	rdx, QWORD PTR 360[rbp]
	lea	rax, -80[rbp]
	mov	rcx, rax
	call	_ZN2FB7FSERROR8SETPATH2ERK9FBUSTRING
	lea	rdx, -80[rbp]
	lea	rax, 16[rbp]
	mov	rcx, rax
	call	_Z4FailIbN2FB7FSERROREERS1_
	mov	QWORD PTR 304[rbp], rax
	mov	rax, QWORD PTR 304[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 352[rbp]
	call	_ZN6ResultIbN2FB7FSERROREEC1ERKS2_
	lea	rax, 16[rbp]
	mov	rcx, rax
	call	_ZN6ResultIbN2FB7FSERROREED1Ev
	lea	rax, -80[rbp]
	mov	rcx, rax
	call	_ZN2FB7FSERRORD1Ev
	jmp	.L3381
.L3380:
.L3387:
	nop
.L3382:
	mov	BYTE PTR 191[rbp], 1
	lea	rdx, 191[rbp]
	lea	rax, 192[rbp]
	mov	rcx, rax
	call	_Z2OkIbN2FB7FSERROREERb
	mov	QWORD PTR 296[rbp], rax
	mov	rax, QWORD PTR 296[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 352[rbp]
	call	_ZN6ResultIbN2FB7FSERROREEC1ERKS2_
	lea	rax, 192[rbp]
	mov	rcx, rax
	call	_ZN6ResultIbN2FB7FSERROREED1Ev
	nop
.L3381:
	mov	rax, QWORD PTR 352[rbp]
	add	rsp, 464
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN2FB8READLINKERK9FBUSTRING;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN2FB8READLINKERK9FBUSTRING
_ZN2FB8READLINKERK9FBUSTRING:
	push	rbp
	.seh_pushreg	rbp
	sub	rsp, 416
	.seh_stackalloc	416
	lea	rbp, 128[rsp]
	.seh_setframe	rbp, 128
	.seh_endprologue
	mov	QWORD PTR 304[rbp], rcx
	mov	QWORD PTR 312[rbp], rdx
.L3389:
	mov	DWORD PTR 140[rbp], 0
	lea	rdx, 140[rbp]
	mov	rax, QWORD PTR 312[rbp]
	mov	rcx, rax
	call	fb_UStrFsReadLink
	mov	QWORD PTR 280[rbp], rax
	mov	rdx, QWORD PTR 280[rbp]
	lea	rax, 112[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrInit
	mov	eax, DWORD PTR 140[rbp]
	test	eax, eax
	je	.L3396
	lea	rax, 80[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	WORD PTR 48[rbp], 82
	mov	WORD PTR 50[rbp], 101
	mov	WORD PTR 52[rbp], 97
	mov	WORD PTR 54[rbp], 100
	mov	WORD PTR 56[rbp], 76
	mov	WORD PTR 58[rbp], 105
	mov	WORD PTR 60[rbp], 110
	mov	WORD PTR 62[rbp], 107
	mov	WORD PTR 64[rbp], 0
	lea	rdx, 48[rbp]
	lea	rax, 80[rbp]
	mov	DWORD PTR 32[rsp], 0
	movabs	r9, -9223372036854775800
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrAssign
	mov	eax, DWORD PTR 140[rbp]
	movsx	rdx, eax
	mov	r8, QWORD PTR 312[rbp]
	lea	rcx, 80[rbp]
	lea	rax, -80[rbp]
	mov	r9, r8
	mov	r8, rcx
	mov	rcx, rax
	call	_Z6FsFailI9FBUSTRINGEN2FB11FSERRORCODEERKS0_S4_
	mov	QWORD PTR 272[rbp], rax
	mov	rax, QWORD PTR 272[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 304[rbp]
	call	_ZN6ResultI9FBUSTRINGN2FB7FSERROREEC1ERKS3_
	lea	rax, 80[rbp]
	mov	rcx, rax
	call	fb_UStrDelete
	lea	rax, -80[rbp]
	mov	rcx, rax
	call	_ZN6ResultI9FBUSTRINGN2FB7FSERROREED1Ev
	lea	rax, 112[rbp]
	mov	rcx, rax
	call	fb_UStrDelete
	jmp	.L3392
.L3391:
.L3396:
	nop
.L3393:
	lea	rdx, 112[rbp]
	lea	rax, 144[rbp]
	mov	rcx, rax
	call	_Z2OkI9FBUSTRINGN2FB7FSERROREERS0_
	mov	QWORD PTR 264[rbp], rax
	mov	rax, QWORD PTR 264[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 304[rbp]
	call	_ZN6ResultI9FBUSTRINGN2FB7FSERROREEC1ERKS3_
	lea	rax, 144[rbp]
	mov	rcx, rax
	call	_ZN6ResultI9FBUSTRINGN2FB7FSERROREED1Ev
	lea	rax, 112[rbp]
	mov	rcx, rax
	call	fb_UStrDelete
	nop
.L3392:
	mov	rax, QWORD PTR 304[rbp]
	add	rsp, 416
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN2FB9HCOPYMETAERK9FBUSTRINGS2_RKNS_11COPYOPTIONSE;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN2FB9HCOPYMETAERK9FBUSTRINGS2_RKNS_11COPYOPTIONSE
_ZN2FB9HCOPYMETAERK9FBUSTRINGS2_RKNS_11COPYOPTIONSE:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 224
	.seh_stackalloc	224
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
	mov	QWORD PTR 32[rbp], r8
.L3398:
	mov	rax, QWORD PTR 32[rbp]
	add	rax, 1
	movzx	eax, BYTE PTR [rax]
	test	al, al
	je	.L3412
	mov	DWORD PTR -44[rbp], 0
	lea	rax, -44[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_UStrFsGetPerm
	mov	DWORD PTR -4[rbp], eax
	cmp	DWORD PTR -4[rbp], 0
	jne	.L3413
	mov	edx, DWORD PTR -44[rbp]
	mov	rax, QWORD PTR 24[rbp]
	mov	rcx, rax
	call	fb_UStrFsSetPerm
	jmp	.L3404
.L3402:
.L3403:
.L3400:
.L3412:
	nop
	jmp	.L3404
.L3413:
	nop
.L3404:
	mov	rax, QWORD PTR 32[rbp]
	movzx	eax, BYTE PTR [rax]
	test	al, al
	je	.L3414
	lea	rax, -192[rbp]
	mov	rdx, QWORD PTR 16[rbp]
	mov	rcx, rax
	call	_ZN2FB5LSTATERK9FBUSTRING
	lea	rax, -192[rbp]
	mov	rcx, rax
	call	_ZN6ResultIN2FB8FILEINFOEN2FB7FSERROREE4ISOKEv
	mov	BYTE PTR -5[rbp], al
	cmp	BYTE PTR -5[rbp], 0
	je	.L3415
	lea	rax, -192[rbp]
	mov	rcx, rax
	call	_ZN6ResultIN2FB8FILEINFOEN2FB7FSERROREE5VALUEEv
	mov	QWORD PTR -16[rbp], rax
	mov	rax, QWORD PTR -16[rbp]
	mov	rcx, rax
	call	_ZNK2FB8FILEINFO11ACCESSEDUTCEv
	mov	QWORD PTR -24[rbp], rax
	lea	rax, -192[rbp]
	mov	rcx, rax
	call	_ZN6ResultIN2FB8FILEINFOEN2FB7FSERROREE5VALUEEv
	mov	QWORD PTR -32[rbp], rax
	mov	rax, QWORD PTR -32[rbp]
	mov	rcx, rax
	call	_ZNK2FB8FILEINFO11MODIFIEDUTCEv
	mov	QWORD PTR -40[rbp], rax
	mov	rcx, QWORD PTR -24[rbp]
	mov	rdx, QWORD PTR -40[rbp]
	mov	rax, QWORD PTR 24[rbp]
	mov	r8, rcx
	mov	rcx, rax
	call	fb_UStrFsSetTimes
	jmp	.L3409
.L3408:
.L3415:
	nop
.L3409:
	lea	rax, -192[rbp]
	mov	rcx, rax
	call	_ZN6ResultIN2FB8FILEINFOEN2FB7FSERROREED1Ev
	jmp	.L3416
.L3406:
.L3410:
.L3414:
	nop
.L3411:
.L3416:
	nop
	add	rsp, 224
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN2FB7COPYDIRERK9FBUSTRINGS2_RKNS_11COPYOPTIONSE;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN2FB7COPYDIRERK9FBUSTRINGS2_RKNS_11COPYOPTIONSE
_ZN2FB7COPYDIRERK9FBUSTRINGS2_RKNS_11COPYOPTIONSE:
	push	rbp
	.seh_pushreg	rbp
	sub	rsp, 1760
	.seh_stackalloc	1760
	lea	rbp, 128[rsp]
	.seh_setframe	rbp, 128
	.seh_endprologue
	mov	QWORD PTR 1648[rbp], rcx
	mov	QWORD PTR 1656[rbp], rdx
	mov	QWORD PTR 1664[rbp], r8
	mov	QWORD PTR 1672[rbp], r9
.L3418:
	lea	rax, 1104[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	lea	rax, 1072[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	rdx, QWORD PTR 1656[rbp]
	lea	rax, 944[rbp]
	mov	rcx, rax
	call	_ZN2FB12ABSOLUTEPATHERK9FBUSTRING
	mov	rdx, QWORD PTR 1664[rbp]
	lea	rax, 816[rbp]
	mov	rcx, rax
	call	_ZN2FB12ABSOLUTEPATHERK9FBUSTRING
	lea	rax, 944[rbp]
	mov	rcx, rax
	call	_ZN6ResultI9FBUSTRINGN2FB7FSERROREE4ISOKEv
	mov	BYTE PTR 1625[rbp], al
	cmp	BYTE PTR 1625[rbp], 0
	jne	.L3475
	lea	rax, 944[rbp]
	mov	rcx, rax
	call	_ZN6ResultI9FBUSTRINGN2FB7FSERROREE7FAILUREEv
	mov	QWORD PTR 1616[rbp], rax
	mov	rdx, QWORD PTR 1616[rbp]
	lea	rax, 144[rbp]
	mov	rcx, rax
	call	_Z4FailIxN2FB7FSERROREERS1_
	mov	QWORD PTR 1608[rbp], rax
	mov	rax, QWORD PTR 1608[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 1648[rbp]
	call	_ZN6ResultIxN2FB7FSERROREEC1ERKS2_
	lea	rax, 144[rbp]
	mov	rcx, rax
	call	_ZN6ResultIxN2FB7FSERROREED1Ev
	lea	rax, 816[rbp]
	mov	rcx, rax
	call	_ZN6ResultI9FBUSTRINGN2FB7FSERROREED1Ev
	lea	rax, 944[rbp]
	mov	rcx, rax
	call	_ZN6ResultI9FBUSTRINGN2FB7FSERROREED1Ev
	lea	rax, 1072[rbp]
	mov	rcx, rax
	call	fb_UStrDelete
	lea	rax, 1104[rbp]
	mov	rcx, rax
	call	fb_UStrDelete
	jmp	.L3421
.L3475:
	nop
.L3420:
	lea	rax, 816[rbp]
	mov	rcx, rax
	call	_ZN6ResultI9FBUSTRINGN2FB7FSERROREE4ISOKEv
	mov	BYTE PTR 1607[rbp], al
	cmp	BYTE PTR 1607[rbp], 0
	jne	.L3476
	lea	rax, 816[rbp]
	mov	rcx, rax
	call	_ZN6ResultI9FBUSTRINGN2FB7FSERROREE7FAILUREEv
	mov	QWORD PTR 1592[rbp], rax
	mov	rdx, QWORD PTR 1592[rbp]
	lea	rax, 144[rbp]
	mov	rcx, rax
	call	_Z4FailIxN2FB7FSERROREERS1_
	mov	QWORD PTR 1584[rbp], rax
	mov	rax, QWORD PTR 1584[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 1648[rbp]
	call	_ZN6ResultIxN2FB7FSERROREEC1ERKS2_
	lea	rax, 144[rbp]
	mov	rcx, rax
	call	_ZN6ResultIxN2FB7FSERROREED1Ev
	lea	rax, 816[rbp]
	mov	rcx, rax
	call	_ZN6ResultI9FBUSTRINGN2FB7FSERROREED1Ev
	lea	rax, 944[rbp]
	mov	rcx, rax
	call	_ZN6ResultI9FBUSTRINGN2FB7FSERROREED1Ev
	lea	rax, 1072[rbp]
	mov	rcx, rax
	call	fb_UStrDelete
	lea	rax, 1104[rbp]
	mov	rcx, rax
	call	fb_UStrDelete
	jmp	.L3421
.L3476:
	nop
.L3423:
	lea	rax, 944[rbp]
	mov	rcx, rax
	call	_ZN6ResultI9FBUSTRINGN2FB7FSERROREE5VALUEEv
	mov	QWORD PTR 1576[rbp], rax
	mov	rax, QWORD PTR 1576[rbp]
	mov	edx, 1
	mov	rcx, rax
	call	fb_UStrPathNormalize
	mov	QWORD PTR 1568[rbp], rax
	mov	rdx, QWORD PTR 1568[rbp]
	lea	rax, 1104[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrAssign
	lea	rax, 816[rbp]
	mov	rcx, rax
	call	_ZN6ResultI9FBUSTRINGN2FB7FSERROREE5VALUEEv
	mov	QWORD PTR 1560[rbp], rax
	mov	rax, QWORD PTR 1560[rbp]
	mov	edx, 1
	mov	rcx, rax
	call	fb_UStrPathNormalize
	mov	QWORD PTR 1552[rbp], rax
	mov	rdx, QWORD PTR 1552[rbp]
	lea	rax, 1072[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrAssign
	lea	rdx, 1104[rbp]
	lea	rax, 1072[rbp]
	mov	r8d, 1
	mov	rcx, rax
	call	fb_UStrPathStartsWith
	mov	BYTE PTR 1551[rbp], al
	cmp	BYTE PTR 1551[rbp], 0
	je	.L3477
	lea	rax, 480[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	WORD PTR 464[rbp], 67
	mov	WORD PTR 466[rbp], 111
	mov	WORD PTR 468[rbp], 112
	mov	WORD PTR 470[rbp], 121
	mov	WORD PTR 472[rbp], 68
	mov	WORD PTR 474[rbp], 105
	mov	WORD PTR 476[rbp], 114
	mov	WORD PTR 478[rbp], 0
	lea	rdx, 464[rbp]
	lea	rax, 480[rbp]
	mov	DWORD PTR 32[rsp], 0
	movabs	r9, -9223372036854775801
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrAssign
	mov	rcx, QWORD PTR 1664[rbp]
	lea	rdx, 480[rbp]
	lea	rax, 144[rbp]
	mov	r9, rcx
	mov	r8, rdx
	mov	edx, 7
	mov	rcx, rax
	call	_Z6FsFailIxEN2FB11FSERRORCODEERK9FBUSTRINGS4_
	mov	QWORD PTR 1536[rbp], rax
	mov	rax, QWORD PTR 1536[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 1648[rbp]
	call	_ZN6ResultIxN2FB7FSERROREEC1ERKS2_
	lea	rax, 480[rbp]
	mov	rcx, rax
	call	fb_UStrDelete
	lea	rax, 144[rbp]
	mov	rcx, rax
	call	_ZN6ResultIxN2FB7FSERROREED1Ev
	lea	rax, 816[rbp]
	mov	rcx, rax
	call	_ZN6ResultI9FBUSTRINGN2FB7FSERROREED1Ev
	lea	rax, 944[rbp]
	mov	rcx, rax
	call	_ZN6ResultI9FBUSTRINGN2FB7FSERROREED1Ev
	lea	rax, 1072[rbp]
	mov	rcx, rax
	call	fb_UStrDelete
	lea	rax, 1104[rbp]
	mov	rcx, rax
	call	fb_UStrDelete
	jmp	.L3421
.L3425:
.L3477:
	nop
.L3426:
	mov	rdx, QWORD PTR 1664[rbp]
	lea	rax, 704[rbp]
	mov	rcx, rax
	call	_ZN2FB12CREATEDIRALLERK9FBUSTRING
	lea	rax, 704[rbp]
	mov	rcx, rax
	call	_ZN6ResultIbN2FB7FSERROREE4ISOKEv
	mov	BYTE PTR 1535[rbp], al
	cmp	BYTE PTR 1535[rbp], 0
	jne	.L3478
	lea	rax, 704[rbp]
	mov	rcx, rax
	call	_ZN6ResultIbN2FB7FSERROREE7FAILUREEv
	mov	QWORD PTR 1520[rbp], rax
	mov	rdx, QWORD PTR 1520[rbp]
	lea	rax, 144[rbp]
	mov	rcx, rax
	call	_Z4FailIxN2FB7FSERROREERS1_
	mov	QWORD PTR 1512[rbp], rax
	mov	rax, QWORD PTR 1512[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 1648[rbp]
	call	_ZN6ResultIxN2FB7FSERROREEC1ERKS2_
	lea	rax, 144[rbp]
	mov	rcx, rax
	call	_ZN6ResultIxN2FB7FSERROREED1Ev
	lea	rax, 704[rbp]
	mov	rcx, rax
	call	_ZN6ResultIbN2FB7FSERROREED1Ev
	lea	rax, 816[rbp]
	mov	rcx, rax
	call	_ZN6ResultI9FBUSTRINGN2FB7FSERROREED1Ev
	lea	rax, 944[rbp]
	mov	rcx, rax
	call	_ZN6ResultI9FBUSTRINGN2FB7FSERROREED1Ev
	lea	rax, 1072[rbp]
	mov	rcx, rax
	call	fb_UStrDelete
	lea	rax, 1104[rbp]
	mov	rcx, rax
	call	fb_UStrDelete
	jmp	.L3421
.L3428:
.L3478:
	nop
.L3429:
	lea	rax, 624[rbp]
	mov	rcx, rax
	call	_ZN5ArrayIN2FB8DIRENTRYEEC1Ev
	lea	rcx, 624[rbp]
	mov	rdx, QWORD PTR 1656[rbp]
	lea	rax, 512[rbp]
	mov	r8, rcx
	mov	rcx, rax
	call	_ZN2FB7LISTDIRERK9FBUSTRINGR5ArrayIN2FB8DIRENTRYEE
	lea	rax, 512[rbp]
	mov	rcx, rax
	call	_ZN6ResultIiN2FB7FSERROREE4ISOKEv
	mov	BYTE PTR 1511[rbp], al
	cmp	BYTE PTR 1511[rbp], 0
	jne	.L3479
	lea	rax, 512[rbp]
	mov	rcx, rax
	call	_ZN6ResultIiN2FB7FSERROREE7FAILUREEv
	mov	QWORD PTR 1496[rbp], rax
	mov	rdx, QWORD PTR 1496[rbp]
	lea	rax, 144[rbp]
	mov	rcx, rax
	call	_Z4FailIxN2FB7FSERROREERS1_
	mov	QWORD PTR 1488[rbp], rax
	mov	rax, QWORD PTR 1488[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 1648[rbp]
	call	_ZN6ResultIxN2FB7FSERROREEC1ERKS2_
	lea	rax, 144[rbp]
	mov	rcx, rax
	call	_ZN6ResultIxN2FB7FSERROREED1Ev
	lea	rax, 512[rbp]
	mov	rcx, rax
	call	_ZN6ResultIiN2FB7FSERROREED1Ev
	lea	rax, 624[rbp]
	mov	rcx, rax
	call	_ZN5ArrayIN2FB8DIRENTRYEED1Ev
	lea	rax, 704[rbp]
	mov	rcx, rax
	call	_ZN6ResultIbN2FB7FSERROREED1Ev
	lea	rax, 816[rbp]
	mov	rcx, rax
	call	_ZN6ResultI9FBUSTRINGN2FB7FSERROREED1Ev
	lea	rax, 944[rbp]
	mov	rcx, rax
	call	_ZN6ResultI9FBUSTRINGN2FB7FSERROREED1Ev
	lea	rax, 1072[rbp]
	mov	rcx, rax
	call	fb_UStrDelete
	lea	rax, 1104[rbp]
	mov	rcx, rax
	call	fb_UStrDelete
	jmp	.L3421
.L3431:
.L3479:
	nop
.L3432:
	mov	QWORD PTR 504[rbp], 1
	mov	DWORD PTR 1628[rbp], 0
	lea	rax, 624[rbp]
	mov	rcx, rax
	call	_ZN5ArrayIN2FB8DIRENTRYEE5COUNTEv
	mov	DWORD PTR 1484[rbp], eax
	mov	eax, DWORD PTR 1484[rbp]
	sub	eax, 1
	mov	DWORD PTR 1480[rbp], eax
	jmp	.L3433
.L3488:
	nop
.L3434:
	lea	rax, 432[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	edx, DWORD PTR 1628[rbp]
	lea	rax, 624[rbp]
	mov	rcx, rax
	call	_ZN5ArrayIN2FB8DIRENTRYEEixEi
	mov	QWORD PTR 1464[rbp], rax
	mov	rax, QWORD PTR 1464[rbp]
	mov	rcx, rax
	call	_ZNK2FB8DIRENTRY4NAMEEv
	mov	QWORD PTR 1456[rbp], rax
	mov	rdx, QWORD PTR 1456[rbp]
	lea	rax, 432[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrAssign
	lea	rdx, 432[rbp]
	mov	rax, QWORD PTR 1664[rbp]
	mov	r8d, 1
	mov	rcx, rax
	call	fb_UStrPathJoin2
	mov	QWORD PTR 1448[rbp], rax
	mov	rdx, QWORD PTR 1448[rbp]
	lea	rax, 400[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrInit
	lea	rax, 432[rbp]
	mov	rcx, rax
	call	fb_UStrDelete
	mov	edx, DWORD PTR 1628[rbp]
	lea	rax, 624[rbp]
	mov	rcx, rax
	call	_ZN5ArrayIN2FB8DIRENTRYEEixEi
	mov	QWORD PTR 1440[rbp], rax
	mov	rax, QWORD PTR 1440[rbp]
	mov	rcx, rax
	call	_ZNK2FB8DIRENTRY9ISSYMLINKEv
	mov	BYTE PTR 1439[rbp], al
	cmp	BYTE PTR 1439[rbp], 0
	je	.L3480
	mov	rax, QWORD PTR 1672[rbp]
	add	rax, 2
	movzx	eax, BYTE PTR [rax]
	test	al, al
	setne	al
	mov	BYTE PTR 1627[rbp], al
	jmp	.L3437
.L3480:
	nop
.L3436:
	mov	BYTE PTR 1627[rbp], 0
.L3437:
	cmp	BYTE PTR 1627[rbp], 0
	je	.L3481
	lea	rax, 368[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	edx, DWORD PTR 1628[rbp]
	lea	rax, 624[rbp]
	mov	rcx, rax
	call	_ZN5ArrayIN2FB8DIRENTRYEEixEi
	mov	QWORD PTR 1424[rbp], rax
	mov	rax, QWORD PTR 1424[rbp]
	mov	rcx, rax
	call	_ZNK2FB8DIRENTRY4PATHEv
	mov	QWORD PTR 1416[rbp], rax
	mov	rdx, QWORD PTR 1416[rbp]
	lea	rax, 368[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrAssign
	lea	rdx, 368[rbp]
	lea	rax, 144[rbp]
	mov	rcx, rax
	call	_ZN2FB8READLINKERK9FBUSTRING
	lea	rax, 368[rbp]
	mov	rcx, rax
	call	fb_UStrDelete
	lea	rax, 144[rbp]
	mov	rcx, rax
	call	_ZN6ResultI9FBUSTRINGN2FB7FSERROREE4ISOKEv
	mov	BYTE PTR 1415[rbp], al
	cmp	BYTE PTR 1415[rbp], 0
	je	.L3482
	mov	edx, DWORD PTR 1628[rbp]
	lea	rax, 624[rbp]
	mov	rcx, rax
	call	_ZN5ArrayIN2FB8DIRENTRYEEixEi
	mov	QWORD PTR 1400[rbp], rax
	mov	rax, QWORD PTR 1400[rbp]
	mov	rcx, rax
	call	_ZNK2FB8DIRENTRY11ISDIRECTORYEv
	mov	BYTE PTR 1399[rbp], al
	lea	rax, 144[rbp]
	mov	rcx, rax
	call	_ZN6ResultI9FBUSTRINGN2FB7FSERROREE5VALUEEv
	mov	QWORD PTR 1384[rbp], rax
	movsx	r8d, BYTE PTR 1399[rbp]
	lea	rcx, 400[rbp]
	mov	rdx, QWORD PTR 1384[rbp]
	lea	rax, -80[rbp]
	mov	r9d, r8d
	mov	r8, rcx
	mov	rcx, rax
	call	_ZN2FB13CREATESYMLINKERK9FBUSTRINGS2_b
	lea	rax, -80[rbp]
	mov	rcx, rax
	call	_ZN6ResultIbN2FB7FSERROREE4ISOKEv
	mov	BYTE PTR 1383[rbp], al
	cmp	BYTE PTR 1383[rbp], 0
	jne	.L3483
	lea	rax, -80[rbp]
	mov	rcx, rax
	call	_ZN6ResultIbN2FB7FSERROREE7FAILUREEv
	mov	QWORD PTR 1368[rbp], rax
	mov	rdx, QWORD PTR 1368[rbp]
	lea	rax, 32[rbp]
	mov	rcx, rax
	call	_Z4FailIxN2FB7FSERROREERS1_
	mov	QWORD PTR 1360[rbp], rax
	mov	rax, QWORD PTR 1360[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 1648[rbp]
	call	_ZN6ResultIxN2FB7FSERROREEC1ERKS2_
	lea	rax, 32[rbp]
	mov	rcx, rax
	call	_ZN6ResultIxN2FB7FSERROREED1Ev
	lea	rax, -80[rbp]
	mov	rcx, rax
	call	_ZN6ResultIbN2FB7FSERROREED1Ev
	lea	rax, 144[rbp]
	mov	rcx, rax
	call	_ZN6ResultI9FBUSTRINGN2FB7FSERROREED1Ev
	lea	rax, 400[rbp]
	mov	rcx, rax
	call	fb_UStrDelete
	lea	rax, 512[rbp]
	mov	rcx, rax
	call	_ZN6ResultIiN2FB7FSERROREED1Ev
	lea	rax, 624[rbp]
	mov	rcx, rax
	call	_ZN5ArrayIN2FB8DIRENTRYEED1Ev
	lea	rax, 704[rbp]
	mov	rcx, rax
	call	_ZN6ResultIbN2FB7FSERROREED1Ev
	lea	rax, 816[rbp]
	mov	rcx, rax
	call	_ZN6ResultI9FBUSTRINGN2FB7FSERROREED1Ev
	lea	rax, 944[rbp]
	mov	rcx, rax
	call	_ZN6ResultI9FBUSTRINGN2FB7FSERROREED1Ev
	lea	rax, 1072[rbp]
	mov	rcx, rax
	call	fb_UStrDelete
	lea	rax, 1104[rbp]
	mov	rcx, rax
	call	fb_UStrDelete
	jmp	.L3421
.L3443:
.L3483:
	nop
.L3445:
	mov	rax, QWORD PTR 504[rbp]
	add	rax, 1
	mov	QWORD PTR 504[rbp], rax
	lea	rax, -80[rbp]
	mov	rcx, rax
	call	_ZN6ResultIbN2FB7FSERROREED1Ev
	lea	rax, 144[rbp]
	mov	rcx, rax
	call	_ZN6ResultI9FBUSTRINGN2FB7FSERROREED1Ev
	lea	rax, 400[rbp]
	mov	rcx, rax
	call	fb_UStrDelete
	jmp	.L3446
.L3441:
.L3482:
	nop
.L3447:
	lea	rax, 144[rbp]
	mov	rcx, rax
	call	_ZN6ResultI9FBUSTRINGN2FB7FSERROREED1Ev
	jmp	.L3448
.L3439:
.L3481:
	nop
.L3448:
	mov	edx, DWORD PTR 1628[rbp]
	lea	rax, 624[rbp]
	mov	rcx, rax
	call	_ZN5ArrayIN2FB8DIRENTRYEEixEi
	mov	QWORD PTR 1352[rbp], rax
	mov	rax, QWORD PTR 1352[rbp]
	mov	rcx, rax
	call	_ZNK2FB8DIRENTRY11ISDIRECTORYEv
	mov	BYTE PTR 1351[rbp], al
	cmp	BYTE PTR 1351[rbp], 0
	je	.L3484
	mov	edx, DWORD PTR 1628[rbp]
	lea	rax, 624[rbp]
	mov	rcx, rax
	call	_ZN5ArrayIN2FB8DIRENTRYEEixEi
	mov	QWORD PTR 1336[rbp], rax
	mov	rax, QWORD PTR 1336[rbp]
	mov	rcx, rax
	call	_ZNK2FB8DIRENTRY9ISSYMLINKEv
	mov	BYTE PTR 1335[rbp], al
	cmp	BYTE PTR 1335[rbp], 0
	sete	al
	mov	BYTE PTR 1626[rbp], al
	jmp	.L3451
.L3484:
	nop
.L3450:
	mov	BYTE PTR 1626[rbp], 0
.L3451:
	cmp	BYTE PTR 1626[rbp], 0
	je	.L3485
	lea	rax, 336[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	edx, DWORD PTR 1628[rbp]
	lea	rax, 624[rbp]
	mov	rcx, rax
	call	_ZN5ArrayIN2FB8DIRENTRYEEixEi
	mov	QWORD PTR 1320[rbp], rax
	mov	rax, QWORD PTR 1320[rbp]
	mov	rcx, rax
	call	_ZNK2FB8DIRENTRY4PATHEv
	mov	QWORD PTR 1312[rbp], rax
	mov	rdx, QWORD PTR 1312[rbp]
	lea	rax, 336[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrAssign
	mov	r8, QWORD PTR 1672[rbp]
	lea	rcx, 400[rbp]
	lea	rdx, 336[rbp]
	lea	rax, 144[rbp]
	mov	r9, r8
	mov	r8, rcx
	mov	rcx, rax
	call	_ZN2FB7COPYDIRERK9FBUSTRINGS2_RKNS_11COPYOPTIONSE
	lea	rax, 336[rbp]
	mov	rcx, rax
	call	fb_UStrDelete
	lea	rax, 144[rbp]
	mov	rcx, rax
	call	_ZN6ResultIxN2FB7FSERROREE4ISOKEv
	mov	BYTE PTR 1311[rbp], al
	cmp	BYTE PTR 1311[rbp], 0
	jne	.L3486
	lea	rax, 144[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 1648[rbp]
	call	_ZN6ResultIxN2FB7FSERROREEC1ERKS2_
	lea	rax, 144[rbp]
	mov	rcx, rax
	call	_ZN6ResultIxN2FB7FSERROREED1Ev
	lea	rax, 400[rbp]
	mov	rcx, rax
	call	fb_UStrDelete
	lea	rax, 512[rbp]
	mov	rcx, rax
	call	_ZN6ResultIiN2FB7FSERROREED1Ev
	lea	rax, 624[rbp]
	mov	rcx, rax
	call	_ZN5ArrayIN2FB8DIRENTRYEED1Ev
	lea	rax, 704[rbp]
	mov	rcx, rax
	call	_ZN6ResultIbN2FB7FSERROREED1Ev
	lea	rax, 816[rbp]
	mov	rcx, rax
	call	_ZN6ResultI9FBUSTRINGN2FB7FSERROREED1Ev
	lea	rax, 944[rbp]
	mov	rcx, rax
	call	_ZN6ResultI9FBUSTRINGN2FB7FSERROREED1Ev
	lea	rax, 1072[rbp]
	mov	rcx, rax
	call	fb_UStrDelete
	lea	rax, 1104[rbp]
	mov	rcx, rax
	call	fb_UStrDelete
	jmp	.L3421
.L3486:
	nop
.L3455:
	lea	rax, 144[rbp]
	mov	rcx, rax
	call	_ZN6ResultIxN2FB7FSERROREE5VALUEEv
	mov	QWORD PTR 1296[rbp], rax
	mov	rax, QWORD PTR 1296[rbp]
	mov	rdx, QWORD PTR [rax]
	mov	rax, QWORD PTR 504[rbp]
	add	rax, rdx
	mov	QWORD PTR 504[rbp], rax
	lea	rax, 144[rbp]
	mov	rcx, rax
	call	_ZN6ResultIxN2FB7FSERROREED1Ev
	jmp	.L3456
.L3485:
	nop
.L3453:
	lea	rax, 304[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	edx, DWORD PTR 1628[rbp]
	lea	rax, 624[rbp]
	mov	rcx, rax
	call	_ZN5ArrayIN2FB8DIRENTRYEEixEi
	mov	QWORD PTR 1288[rbp], rax
	mov	rax, QWORD PTR 1288[rbp]
	mov	rcx, rax
	call	_ZNK2FB8DIRENTRY4PATHEv
	mov	QWORD PTR 1280[rbp], rax
	mov	rdx, QWORD PTR 1280[rbp]
	lea	rax, 304[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrAssign
	mov	rax, QWORD PTR 1672[rbp]
	add	rax, 3
	movzx	eax, BYTE PTR [rax]
	movsx	r8d, al
	lea	rcx, 400[rbp]
	lea	rdx, 304[rbp]
	lea	rax, 32[rbp]
	mov	r9d, r8d
	mov	r8, rcx
	mov	rcx, rax
	call	_ZN2FB8COPYFILEERK9FBUSTRINGS2_b
	lea	rax, 304[rbp]
	mov	rcx, rax
	call	fb_UStrDelete
	lea	rax, 32[rbp]
	mov	rcx, rax
	call	_ZN6ResultIbN2FB7FSERROREE4ISOKEv
	mov	BYTE PTR 1279[rbp], al
	cmp	BYTE PTR 1279[rbp], 0
	jne	.L3487
	lea	rax, 32[rbp]
	mov	rcx, rax
	call	_ZN6ResultIbN2FB7FSERROREE7FAILUREEv
	mov	QWORD PTR 1264[rbp], rax
	mov	rdx, QWORD PTR 1264[rbp]
	lea	rax, 144[rbp]
	mov	rcx, rax
	call	_Z4FailIxN2FB7FSERROREERS1_
	mov	QWORD PTR 1256[rbp], rax
	mov	rax, QWORD PTR 1256[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 1648[rbp]
	call	_ZN6ResultIxN2FB7FSERROREEC1ERKS2_
	lea	rax, 144[rbp]
	mov	rcx, rax
	call	_ZN6ResultIxN2FB7FSERROREED1Ev
	lea	rax, 32[rbp]
	mov	rcx, rax
	call	_ZN6ResultIbN2FB7FSERROREED1Ev
	lea	rax, 400[rbp]
	mov	rcx, rax
	call	fb_UStrDelete
	lea	rax, 512[rbp]
	mov	rcx, rax
	call	_ZN6ResultIiN2FB7FSERROREED1Ev
	lea	rax, 624[rbp]
	mov	rcx, rax
	call	_ZN5ArrayIN2FB8DIRENTRYEED1Ev
	lea	rax, 704[rbp]
	mov	rcx, rax
	call	_ZN6ResultIbN2FB7FSERROREED1Ev
	lea	rax, 816[rbp]
	mov	rcx, rax
	call	_ZN6ResultI9FBUSTRINGN2FB7FSERROREED1Ev
	lea	rax, 944[rbp]
	mov	rcx, rax
	call	_ZN6ResultI9FBUSTRINGN2FB7FSERROREED1Ev
	lea	rax, 1072[rbp]
	mov	rcx, rax
	call	fb_UStrDelete
	lea	rax, 1104[rbp]
	mov	rcx, rax
	call	fb_UStrDelete
	jmp	.L3421
.L3458:
.L3487:
	nop
.L3459:
	lea	rax, 272[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	edx, DWORD PTR 1628[rbp]
	lea	rax, 624[rbp]
	mov	rcx, rax
	call	_ZN5ArrayIN2FB8DIRENTRYEEixEi
	mov	QWORD PTR 1248[rbp], rax
	mov	rax, QWORD PTR 1248[rbp]
	mov	rcx, rax
	call	_ZNK2FB8DIRENTRY4PATHEv
	mov	QWORD PTR 1240[rbp], rax
	mov	rdx, QWORD PTR 1240[rbp]
	lea	rax, 272[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrAssign
	mov	rcx, QWORD PTR 1672[rbp]
	lea	rdx, 400[rbp]
	lea	rax, 272[rbp]
	mov	r8, rcx
	mov	rcx, rax
	call	_ZN2FB9HCOPYMETAERK9FBUSTRINGS2_RKNS_11COPYOPTIONSE
	lea	rax, 272[rbp]
	mov	rcx, rax
	call	fb_UStrDelete
	mov	rax, QWORD PTR 504[rbp]
	add	rax, 1
	mov	QWORD PTR 504[rbp], rax
	lea	rax, 32[rbp]
	mov	rcx, rax
	call	_ZN6ResultIbN2FB7FSERROREED1Ev
.L3456:
	lea	rax, 400[rbp]
	mov	rcx, rax
	call	fb_UStrDelete
.L3446:
	add	DWORD PTR 1628[rbp], 1
.L3433:
	mov	eax, DWORD PTR 1628[rbp]
	cmp	eax, DWORD PTR 1480[rbp]
	jle	.L3488
	nop
.L3460:
	mov	rcx, QWORD PTR 1672[rbp]
	mov	rdx, QWORD PTR 1664[rbp]
	mov	rax, QWORD PTR 1656[rbp]
	mov	r8, rcx
	mov	rcx, rax
	call	_ZN2FB9HCOPYMETAERK9FBUSTRINGS2_RKNS_11COPYOPTIONSE
	lea	rdx, 504[rbp]
	lea	rax, 1136[rbp]
	mov	rcx, rax
	call	_Z2OkIxN2FB7FSERROREERx
	mov	QWORD PTR 1472[rbp], rax
	mov	rax, QWORD PTR 1472[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 1648[rbp]
	call	_ZN6ResultIxN2FB7FSERROREEC1ERKS2_
	lea	rax, 1136[rbp]
	mov	rcx, rax
	call	_ZN6ResultIxN2FB7FSERROREED1Ev
	lea	rax, 512[rbp]
	mov	rcx, rax
	call	_ZN6ResultIiN2FB7FSERROREED1Ev
	lea	rax, 624[rbp]
	mov	rcx, rax
	call	_ZN5ArrayIN2FB8DIRENTRYEED1Ev
	lea	rax, 704[rbp]
	mov	rcx, rax
	call	_ZN6ResultIbN2FB7FSERROREED1Ev
	lea	rax, 816[rbp]
	mov	rcx, rax
	call	_ZN6ResultI9FBUSTRINGN2FB7FSERROREED1Ev
	lea	rax, 944[rbp]
	mov	rcx, rax
	call	_ZN6ResultI9FBUSTRINGN2FB7FSERROREED1Ev
	lea	rax, 1072[rbp]
	mov	rcx, rax
	call	fb_UStrDelete
	lea	rax, 1104[rbp]
	mov	rcx, rax
	call	fb_UStrDelete
	nop
.L3421:
	mov	rax, QWORD PTR 1648[rbp]
	add	rsp, 1760
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN2FB10VOLUMEINFOC1Ev;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN2FB10VOLUMEINFOC1Ev
_ZN2FB10VOLUMEINFOC1Ev:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	rax, QWORD PTR 16[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 24
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 48
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	DWORD PTR [rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 76
	mov	BYTE PTR [rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 77
	mov	BYTE PTR [rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 78
	mov	BYTE PTR [rax], 0
	nop
	pop	rbp
	ret
.L3490:
.L3491:
	.seh_endproc
	.def	_ZN2FB10VOLUMEINFOaSERKS0_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN2FB10VOLUMEINFOaSERKS0_
_ZN2FB10VOLUMEINFOaSERKS0_:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 48
	.seh_stackalloc	48
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
.L3493:
	mov	rax, QWORD PTR 24[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rax
	mov	rdx, -1
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_UStrAssign
	mov	rax, QWORD PTR 24[rbp]
	lea	rdx, 24[rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 24
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrAssign
	mov	rax, QWORD PTR 24[rbp]
	lea	rdx, 48[rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 48
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrAssign
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 72[rax]
	mov	rax, QWORD PTR 24[rbp]
	mov	eax, DWORD PTR 72[rax]
	mov	DWORD PTR [rdx], eax
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 76[rax]
	mov	rax, QWORD PTR 24[rbp]
	movzx	eax, BYTE PTR 76[rax]
	mov	BYTE PTR [rdx], al
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 77[rax]
	mov	rax, QWORD PTR 24[rbp]
	movzx	eax, BYTE PTR 77[rax]
	mov	BYTE PTR [rdx], al
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 78[rax]
	mov	rax, QWORD PTR 24[rbp]
	movzx	eax, BYTE PTR 78[rax]
	mov	BYTE PTR [rdx], al
	nop
	add	rsp, 48
	pop	rbp
	ret
.L3494:
	.seh_endproc
	.def	_ZN2FB10VOLUMEINFOC1ERKS0_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN2FB10VOLUMEINFOC1ERKS0_
_ZN2FB10VOLUMEINFOC1ERKS0_:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
.L3496:
	mov	rax, QWORD PTR 16[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 24
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 48
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	DWORD PTR [rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 76
	mov	BYTE PTR [rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 77
	mov	BYTE PTR [rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 78
	mov	BYTE PTR [rax], 0
	mov	rax, QWORD PTR 24[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN2FB10VOLUMEINFOaSERKS0_
	nop
	add	rsp, 32
	pop	rbp
	ret
.L3497:
	.seh_endproc
	.def	_ZN2FB10VOLUMEINFOD1Ev;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN2FB10VOLUMEINFOD1Ev
_ZN2FB10VOLUMEINFOD1Ev:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
.L3499:
.L3500:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 48
	mov	rcx, rax
	call	fb_UStrDelete
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 24
	mov	rcx, rax
	call	fb_UStrDelete
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_UStrDelete
	nop
	add	rsp, 32
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN6ResultIN2FB9DISKSPACEEN2FB7FSERROREEC1Ev;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN6ResultIN2FB9DISKSPACEEN2FB7FSERROREEC1Ev
_ZN6ResultIN2FB9DISKSPACEEN2FB7FSERROREEC1Ev:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	rax, QWORD PTR 16[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 24
	mov	rcx, rax
	call	_ZN2FB7FSERRORC1Ev
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 112
	mov	BYTE PTR [rax], 0
	nop
	add	rsp, 32
	pop	rbp
	ret
.L3502:
.L3503:
	.seh_endproc
	.def	_ZN6ResultIN2FB9DISKSPACEEN2FB7FSERROREEaSERKS4_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN6ResultIN2FB9DISKSPACEEN2FB7FSERROREEaSERKS4_
_ZN6ResultIN2FB9DISKSPACEEN2FB7FSERROREEaSERKS4_:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
.L3505:
	mov	rcx, QWORD PTR 16[rbp]
	mov	r8, QWORD PTR 24[rbp]
	mov	rax, QWORD PTR [r8]
	mov	rdx, QWORD PTR 8[r8]
	mov	QWORD PTR [rcx], rax
	mov	QWORD PTR 8[rcx], rdx
	mov	rax, QWORD PTR 16[r8]
	mov	QWORD PTR 16[rcx], rax
	mov	rax, QWORD PTR 24[rbp]
	lea	rdx, 24[rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 24
	mov	rcx, rax
	call	_ZN2FB7FSERRORaSERKS0_
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 112[rax]
	mov	rax, QWORD PTR 24[rbp]
	movzx	eax, BYTE PTR 112[rax]
	mov	BYTE PTR [rdx], al
	nop
	add	rsp, 32
	pop	rbp
	ret
.L3506:
	.seh_endproc
	.def	_ZN6ResultIN2FB9DISKSPACEEN2FB7FSERROREEC1ERKS4_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN6ResultIN2FB9DISKSPACEEN2FB7FSERROREEC1ERKS4_
_ZN6ResultIN2FB9DISKSPACEEN2FB7FSERROREEC1ERKS4_:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
.L3508:
	mov	rax, QWORD PTR 16[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 24
	mov	rcx, rax
	call	_ZN2FB7FSERRORC1Ev
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 112
	mov	BYTE PTR [rax], 0
	mov	rax, QWORD PTR 24[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN6ResultIN2FB9DISKSPACEEN2FB7FSERROREEaSERKS4_
	nop
	add	rsp, 32
	pop	rbp
	ret
.L3509:
	.seh_endproc
	.def	_ZN6ResultIN2FB9DISKSPACEEN2FB7FSERROREED1Ev;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN6ResultIN2FB9DISKSPACEEN2FB7FSERROREED1Ev
_ZN6ResultIN2FB9DISKSPACEEN2FB7FSERROREED1Ev:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
.L3511:
.L3512:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 24
	mov	rcx, rax
	call	_ZN2FB7FSERRORD1Ev
	nop
	add	rsp, 32
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN6ResultIN2FB10VOLUMEINFOEN2FB7FSERROREEC1Ev;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN6ResultIN2FB10VOLUMEINFOEN2FB7FSERROREEC1Ev
_ZN6ResultIN2FB10VOLUMEINFOEN2FB7FSERROREEC1Ev:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN2FB10VOLUMEINFOC1Ev
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 80
	mov	rcx, rax
	call	_ZN2FB7FSERRORC1Ev
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 168
	mov	BYTE PTR [rax], 0
	nop
	add	rsp, 32
	pop	rbp
	ret
.L3514:
.L3515:
	.seh_endproc
	.def	_ZN6ResultIN2FB10VOLUMEINFOEN2FB7FSERROREEaSERKS4_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN6ResultIN2FB10VOLUMEINFOEN2FB7FSERROREEaSERKS4_
_ZN6ResultIN2FB10VOLUMEINFOEN2FB7FSERROREEaSERKS4_:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
.L3517:
	mov	rax, QWORD PTR 24[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN2FB10VOLUMEINFOaSERKS0_
	mov	rax, QWORD PTR 24[rbp]
	lea	rdx, 80[rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 80
	mov	rcx, rax
	call	_ZN2FB7FSERRORaSERKS0_
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 168[rax]
	mov	rax, QWORD PTR 24[rbp]
	movzx	eax, BYTE PTR 168[rax]
	mov	BYTE PTR [rdx], al
	nop
	add	rsp, 32
	pop	rbp
	ret
.L3518:
	.seh_endproc
	.def	_ZN6ResultIN2FB10VOLUMEINFOEN2FB7FSERROREEC1ERKS4_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN6ResultIN2FB10VOLUMEINFOEN2FB7FSERROREEC1ERKS4_
_ZN6ResultIN2FB10VOLUMEINFOEN2FB7FSERROREEC1ERKS4_:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
.L3520:
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN2FB10VOLUMEINFOC1Ev
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 80
	mov	rcx, rax
	call	_ZN2FB7FSERRORC1Ev
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 168
	mov	BYTE PTR [rax], 0
	mov	rax, QWORD PTR 24[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN6ResultIN2FB10VOLUMEINFOEN2FB7FSERROREEaSERKS4_
	nop
	add	rsp, 32
	pop	rbp
	ret
.L3521:
	.seh_endproc
	.def	_ZN6ResultIN2FB10VOLUMEINFOEN2FB7FSERROREED1Ev;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN6ResultIN2FB10VOLUMEINFOEN2FB7FSERROREED1Ev
_ZN6ResultIN2FB10VOLUMEINFOEN2FB7FSERROREED1Ev:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
.L3523:
.L3524:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 80
	mov	rcx, rax
	call	_ZN2FB7FSERRORD1Ev
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN2FB10VOLUMEINFOD1Ev
	nop
	add	rsp, 32
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN2FB11HMAKEVOLUMEEPNS_13VOLUMEINFORAWE;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN2FB11HMAKEVOLUMEEPNS_13VOLUMEINFORAWE
_ZN2FB11HMAKEVOLUMEEPNS_13VOLUMEINFORAWE:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 160
	.seh_stackalloc	160
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
.L3526:
	lea	rax, -112[rbp]
	mov	rcx, rax
	call	_ZN2FB10VOLUMEINFOC1Ev
	mov	rax, QWORD PTR 24[rbp]
	mov	rcx, rax
	call	fb_UStrFsVolumeRoot
	mov	QWORD PTR -8[rbp], rax
	mov	rdx, QWORD PTR -8[rbp]
	lea	rax, -112[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrAssign
	mov	rax, QWORD PTR 24[rbp]
	mov	rcx, rax
	call	fb_UStrFsVolumeName
	mov	QWORD PTR -16[rbp], rax
	lea	rax, -112[rbp]
	add	rax, 24
	mov	rdx, QWORD PTR -16[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrAssign
	mov	rax, QWORD PTR 24[rbp]
	mov	rcx, rax
	call	fb_UStrFsVolumeFsType
	mov	QWORD PTR -24[rbp], rax
	lea	rax, -112[rbp]
	add	rax, 48
	mov	rdx, QWORD PTR -24[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrAssign
	lea	rax, -112[rbp]
	add	rax, 72
	mov	rdx, QWORD PTR 24[rbp]
	mov	edx, DWORD PTR 2076[rdx]
	mov	DWORD PTR [rax], edx
	mov	rax, QWORD PTR 24[rbp]
	add	rax, 2080
	mov	eax, DWORD PTR [rax]
	cdqe
	and	eax, 1
	test	rax, rax
	setne	dl
	lea	rax, -112[rbp]
	add	rax, 76
	mov	BYTE PTR [rax], dl
	mov	rax, QWORD PTR 24[rbp]
	add	rax, 2080
	mov	eax, DWORD PTR [rax]
	cdqe
	and	eax, 2
	test	rax, rax
	setne	dl
	lea	rax, -112[rbp]
	add	rax, 77
	mov	BYTE PTR [rax], dl
	mov	rax, QWORD PTR 24[rbp]
	add	rax, 2080
	mov	eax, DWORD PTR [rax]
	cdqe
	and	eax, 4
	test	rax, rax
	setne	dl
	lea	rax, -112[rbp]
	add	rax, 78
	mov	BYTE PTR [rax], dl
	lea	rax, -112[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN2FB10VOLUMEINFOC1ERKS0_
	lea	rax, -112[rbp]
	mov	rcx, rax
	call	_ZN2FB10VOLUMEINFOD1Ev
	nop
.L3527:
	mov	rax, QWORD PTR 16[rbp]
	add	rsp, 160
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN2FB10VOLUMEINFOEEaSERKS2_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN2FB10VOLUMEINFOEEaSERKS2_
_ZN5ArrayIN2FB10VOLUMEINFOEEaSERKS2_:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 80
	.seh_stackalloc	80
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
.L3530:
	mov	rax, QWORD PTR 24[rbp]
	lea	rdx, _ZN2FB10VOLUMEINFOD1Ev[rip]
	mov	QWORD PTR 32[rsp], rdx
	lea	r9, _ZN2FB10VOLUMEINFOC1Ev[rip]
	mov	r8d, 0
	mov	rdx, rax
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayRedimTo
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR 8[rax]
	mov	QWORD PTR -8[rbp], rax
	mov	rax, QWORD PTR 24[rbp]
	mov	rax, QWORD PTR 8[rax]
	mov	QWORD PTR -16[rbp], rax
	mov	rax, QWORD PTR 24[rbp]
	add	rax, 16
	mov	rdx, QWORD PTR [rax]
	mov	rax, QWORD PTR -16[rbp]
	add	rax, rdx
	mov	QWORD PTR -24[rbp], rax
.L3531:
	mov	rax, QWORD PTR -16[rbp]
	cmp	rax, QWORD PTR -24[rbp]
	jnb	.L3536
	mov	rdx, QWORD PTR -16[rbp]
	mov	rax, QWORD PTR -8[rbp]
	mov	rcx, rax
	call	_ZN2FB10VOLUMEINFOaSERKS0_
	add	QWORD PTR -8[rbp], 80
	add	QWORD PTR -16[rbp], 80
	jmp	.L3531
.L3536:
	nop
.L3533:
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 72[rax]
	mov	rax, QWORD PTR 24[rbp]
	mov	eax, DWORD PTR 72[rax]
	mov	DWORD PTR [rdx], eax
	nop
	add	rsp, 80
	pop	rbp
	ret
.L3534:
	.seh_endproc
	.def	_ZN2FB8FILELOCK7RELEASEEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN2FB8FILELOCK7RELEASEEv
_ZN2FB8FILELOCK7RELEASEEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
.L3538:
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	test	rax, rax
	je	.L3543
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	fb_FsLockRelease
	mov	rax, QWORD PTR 16[rbp]
	mov	QWORD PTR [rax], 0
	jmp	.L3544
.L3540:
.L3541:
.L3543:
	nop
.L3542:
.L3544:
	nop
	add	rsp, 32
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN2FB16MEMORYMAPPEDFILE5CLOSEEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN2FB16MEMORYMAPPEDFILE5CLOSEEv
_ZN2FB16MEMORYMAPPEDFILE5CLOSEEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
.L3546:
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	test	rax, rax
	je	.L3551
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	fb_FsMmapClose
	mov	rax, QWORD PTR 16[rbp]
	mov	QWORD PTR [rax], 0
	jmp	.L3552
.L3548:
.L3549:
.L3551:
	nop
.L3550:
.L3552:
	nop
	add	rsp, 32
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN2FB8FSCHANGEC1Ev;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN2FB8FSCHANGEC1Ev
_ZN2FB8FSCHANGEC1Ev:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	rax, QWORD PTR 16[rbp]
	mov	QWORD PTR [rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	nop
	pop	rbp
	ret
.L3554:
.L3555:
	.seh_endproc
	.def	_ZN2FB8FSCHANGEaSERKS0_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN2FB8FSCHANGEaSERKS0_
_ZN2FB8FSCHANGEaSERKS0_:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 48
	.seh_stackalloc	48
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
.L3557:
	mov	rax, QWORD PTR 24[rbp]
	mov	rdx, QWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	mov	QWORD PTR [rax], rdx
	mov	rax, QWORD PTR 24[rbp]
	lea	rdx, 8[rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrAssign
	nop
	add	rsp, 48
	pop	rbp
	ret
.L3558:
	.seh_endproc
	.def	_ZN2FB8FSCHANGEC1ERKS0_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN2FB8FSCHANGEC1ERKS0_
_ZN2FB8FSCHANGEC1ERKS0_:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
.L3560:
	mov	rax, QWORD PTR 16[rbp]
	mov	QWORD PTR [rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	rax, QWORD PTR 24[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN2FB8FSCHANGEaSERKS0_
	nop
	add	rsp, 32
	pop	rbp
	ret
.L3561:
	.seh_endproc
	.def	_ZN2FB8FSCHANGED1Ev;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN2FB8FSCHANGED1Ev
_ZN2FB8FSCHANGED1Ev:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
.L3563:
.L3564:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	rcx, rax
	call	fb_UStrDelete
	nop
	add	rsp, 32
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN2FB8FSCHANGEEEaSERKS2_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN2FB8FSCHANGEEEaSERKS2_
_ZN5ArrayIN2FB8FSCHANGEEEaSERKS2_:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 80
	.seh_stackalloc	80
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
.L3566:
	mov	rax, QWORD PTR 24[rbp]
	lea	rdx, _ZN2FB8FSCHANGED1Ev[rip]
	mov	QWORD PTR 32[rsp], rdx
	lea	r9, _ZN2FB8FSCHANGEC1Ev[rip]
	mov	r8d, 0
	mov	rdx, rax
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayRedimTo
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR 8[rax]
	mov	QWORD PTR -8[rbp], rax
	mov	rax, QWORD PTR 24[rbp]
	mov	rax, QWORD PTR 8[rax]
	mov	QWORD PTR -16[rbp], rax
	mov	rax, QWORD PTR 24[rbp]
	add	rax, 16
	mov	rdx, QWORD PTR [rax]
	mov	rax, QWORD PTR -16[rbp]
	add	rax, rdx
	mov	QWORD PTR -24[rbp], rax
.L3567:
	mov	rax, QWORD PTR -16[rbp]
	cmp	rax, QWORD PTR -24[rbp]
	jnb	.L3572
	mov	rdx, QWORD PTR -16[rbp]
	mov	rax, QWORD PTR -8[rbp]
	mov	rcx, rax
	call	_ZN2FB8FSCHANGEaSERKS0_
	add	QWORD PTR -8[rbp], 32
	add	QWORD PTR -16[rbp], 32
	jmp	.L3567
.L3572:
	nop
.L3569:
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 72[rax]
	mov	rax, QWORD PTR 24[rbp]
	mov	eax, DWORD PTR 72[rax]
	mov	DWORD PTR [rdx], eax
	nop
	add	rsp, 80
	pop	rbp
	ret
.L3570:
	.seh_endproc
	.def	_ZN2FB11FILEWATCHER4STOPEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN2FB11FILEWATCHER4STOPEv
_ZN2FB11FILEWATCHER4STOPEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
.L3574:
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	test	rax, rax
	je	.L3579
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	fb_FsWatchStop
	mov	rax, QWORD PTR 16[rbp]
	mov	QWORD PTR [rax], 0
	jmp	.L3580
.L3576:
.L3577:
.L3579:
	nop
.L3578:
.L3580:
	nop
	add	rsp, 32
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN3TKO14BUILDLINEINDEXEPNS_10SOURCEFILEE;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN3TKO14BUILDLINEINDEXEPNS_10SOURCEFILEE
_ZN3TKO14BUILDLINEINDEXEPNS_10SOURCEFILEE:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 64
	.seh_stackalloc	64
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
.L3582:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 88
	mov	rcx, rax
	call	_ZN5ArrayIiE5CLEAREv
	mov	DWORD PTR -28[rbp], 0
	mov	rax, QWORD PTR 16[rbp]
	lea	rcx, 88[rax]
	lea	rax, -28[rbp]
	mov	rdx, rax
	call	_ZN5ArrayIiE4PUSHERi
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	rcx, rax
	call	_ZN5ArrayIhE5COUNTEv
	mov	DWORD PTR -8[rbp], eax
	mov	eax, DWORD PTR -8[rbp]
	mov	DWORD PTR -12[rbp], eax
	mov	DWORD PTR -4[rbp], 0
.L3583:
	mov	eax, DWORD PTR -4[rbp]
	cmp	eax, DWORD PTR -12[rbp]
	jge	.L3591
	mov	rax, QWORD PTR 16[rbp]
	lea	rcx, 8[rax]
	mov	eax, DWORD PTR -4[rbp]
	mov	edx, eax
	call	_ZN5ArrayIhEixEi
	mov	QWORD PTR -24[rbp], rax
	mov	rax, QWORD PTR -24[rbp]
	movzx	eax, BYTE PTR [rax]
	cmp	al, 10
	jne	.L3592
	mov	eax, DWORD PTR -4[rbp]
	add	eax, 1
	mov	DWORD PTR -32[rbp], eax
	mov	rax, QWORD PTR 16[rbp]
	lea	rcx, 88[rax]
	lea	rax, -32[rbp]
	mov	rdx, rax
	call	_ZN5ArrayIiE4PUSHERi
	jmp	.L3588
.L3587:
.L3592:
	nop
.L3588:
	add	DWORD PTR -4[rbp], 1
	jmp	.L3583
.L3585:
.L3591:
	nop
.L3589:
	nop
	add	rsp, 64
	pop	rbp
	ret
	.seh_endproc
	.def	fb_ArrayUBound;	.scl	2;	.type	32;	.endef
	.def	fb_ArrayLBound;	.scl	2;	.type	32;	.endef
	.def	fb_ArrayRedimPresvEx;	.scl	2;	.type	32;	.endef
	.def	fb_ArrayErase;	.scl	2;	.type	32;	.endef
	.def	fb_ArrayStrErase;	.scl	2;	.type	32;	.endef
	.def	fb_StrAssign;	.scl	2;	.type	32;	.endef
	.def	fb_StrInit;	.scl	2;	.type	32;	.endef
	.def	fb_StrDelete;	.scl	2;	.type	32;	.endef
	.def	fb_StrAllocTempResult;	.scl	2;	.type	32;	.endef
	.def	fb_ErrorThrowEx;	.scl	2;	.type	32;	.endef
	.def	fb_ArrayUStrErase;	.scl	2;	.type	32;	.endef
	.def	fb_UStrAssign;	.scl	2;	.type	32;	.endef
	.def	fb_UStrInit;	.scl	2;	.type	32;	.endef
	.def	fb_UStrDelete;	.scl	2;	.type	32;	.endef
	.def	fb_UStrAllocTempResult;	.scl	2;	.type	32;	.endef
	.def	fb_FsOsError;	.scl	2;	.type	32;	.endef
	.def	fb_ArrayRedimPresvObj;	.scl	2;	.type	32;	.endef
	.def	fb_ArrayEraseObj;	.scl	2;	.type	32;	.endef
	.def	free;	.scl	2;	.type	32;	.endef
	.def	fb_StrCompare;	.scl	2;	.type	32;	.endef
	.def	_ZN3TKO8INTERNER8SPELLINGEj;	.scl	2;	.type	32;	.endef
	.def	_ZN3TKO4TEXT13USTRINGTOUTF8E9FBUSTRING;	.scl	2;	.type	32;	.endef
	.def	_ZN3TKO8INTERNER9GETSTRINGE8FBSTRING;	.scl	2;	.type	32;	.endef
	.def	calloc;	.scl	2;	.type	32;	.endef
	.def	_ZN3TKO4TEXT14DETECTENCODINGEPKhi;	.scl	2;	.type	32;	.endef
	.def	_ZN3TKO4TEXT16FIRSTINVALIDUTF8EPKhi;	.scl	2;	.type	32;	.endef
	.def	_ZN3TKO4TEXT15NORMALIZETOUTF8ER5ArrayIhES3_NS0_8ENCODINGE;	.scl	2;	.type	32;	.endef
	.def	_ZN3TKO9HASHBYTESEPKhi;	.scl	2;	.type	32;	.endef
	.def	fb_UStrPathNormalize;	.scl	2;	.type	32;	.endef
	.def	fb_StrLen;	.scl	2;	.type	32;	.endef
	.def	_ZN3TKO4TEXT8COLUMNOFEPKhiii;	.scl	2;	.type	32;	.endef
	.def	fb_SPACE;	.scl	2;	.type	32;	.endef
	.def	memcpy;	.scl	2;	.type	32;	.endef
	.def	fb_ArrayRedimTo;	.scl	2;	.type	32;	.endef
	.def	fb_UStrFsErrorMessage;	.scl	2;	.type	32;	.endef
	.def	fb_UStrPathJoin2;	.scl	2;	.type	32;	.endef
	.def	fb_UStrPathNextComp;	.scl	2;	.type	32;	.endef
	.def	fb_UStrMid;	.scl	2;	.type	32;	.endef
	.def	fb_UStrFsStat;	.scl	2;	.type	32;	.endef
	.def	fb_UStrFsAbsolutePath;	.scl	2;	.type	32;	.endef
	.def	fb_UStrFsDirOpen;	.scl	2;	.type	32;	.endef
	.def	fb_FsDirRead;	.scl	2;	.type	32;	.endef
	.def	fb_UStrFsDirEntName;	.scl	2;	.type	32;	.endef
	.def	fb_FsDirClose;	.scl	2;	.type	32;	.endef
	.def	fb_UStrFsIdentity;	.scl	2;	.type	32;	.endef
	.def	fb_UStrPathParent;	.scl	2;	.type	32;	.endef
	.def	fb_UStrLen;	.scl	2;	.type	32;	.endef
	.def	fb_UStrCompare;	.scl	2;	.type	32;	.endef
	.def	fb_UStrFsReadAllText;	.scl	2;	.type	32;	.endef
	.def	fb_UStrFsReadWhole;	.scl	2;	.type	32;	.endef
	.def	fb_FsFreeBuf;	.scl	2;	.type	32;	.endef
	.def	fb_UStrFsWriteAllText;	.scl	2;	.type	32;	.endef
	.def	fb_UStrPathRoot;	.scl	2;	.type	32;	.endef
	.def	fb_UStrFsCreateDir;	.scl	2;	.type	32;	.endef
	.def	fb_UStrFsRemoveFile;	.scl	2;	.type	32;	.endef
	.def	fb_UStrFsSetReadOnly;	.scl	2;	.type	32;	.endef
	.def	fb_UStrFsRemoveDir;	.scl	2;	.type	32;	.endef
	.def	fb_UStrFsCopyFile;	.scl	2;	.type	32;	.endef
	.def	fb_UStrPathStartsWith;	.scl	2;	.type	32;	.endef
	.def	fb_UStrFsPatternWildcardAt;	.scl	2;	.type	32;	.endef
	.def	fb_UStrLeftD;	.scl	2;	.type	32;	.endef
	.def	fb_UStrFsCreateSymlink;	.scl	2;	.type	32;	.endef
	.def	fb_UStrFsReadLink;	.scl	2;	.type	32;	.endef
	.def	fb_UStrFsGetPerm;	.scl	2;	.type	32;	.endef
	.def	fb_UStrFsSetPerm;	.scl	2;	.type	32;	.endef
	.def	fb_UStrFsSetTimes;	.scl	2;	.type	32;	.endef
	.def	fb_UStrFsVolumeRoot;	.scl	2;	.type	32;	.endef
	.def	fb_UStrFsVolumeName;	.scl	2;	.type	32;	.endef
	.def	fb_UStrFsVolumeFsType;	.scl	2;	.type	32;	.endef
	.def	fb_FsLockRelease;	.scl	2;	.type	32;	.endef
	.def	fb_FsMmapClose;	.scl	2;	.type	32;	.endef
	.def	fb_FsWatchStop;	.scl	2;	.type	32;	.endef
