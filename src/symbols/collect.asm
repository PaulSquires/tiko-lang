	.file	"collect.c"
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
	.def	_ZN13ArrayIteratorIN3TKO5TOKENEE7ISVALIDEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN13ArrayIteratorIN3TKO5TOKENEE7ISVALIDEv
_ZN13ArrayIteratorIN3TKO5TOKENEE7ISVALIDEv:
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
	.def	_ZN13ArrayIteratorIN3TKO5TOKENEE5VALUEEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN13ArrayIteratorIN3TKO5TOKENEE5VALUEEv
_ZN13ArrayIteratorIN3TKO5TOKENEE5VALUEEv:
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
	sal	rdx, 4
	add	rax, rdx
	mov	QWORD PTR -16[rbp], rax
	nop
.L291:
	mov	rax, QWORD PTR -16[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN13ArrayIteratorIN3TKO5TOKENEE8MOVENEXTEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN13ArrayIteratorIN3TKO5TOKENEE8MOVENEXTEv
_ZN13ArrayIteratorIN3TKO5TOKENEE8MOVENEXTEv:
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
	.def	_ZN5ArrayIN3TKO5TOKENEE5COUNTEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO5TOKENEE5COUNTEv
_ZN5ArrayIN3TKO5TOKENEE5COUNTEv:
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
	.def	_ZN5ArrayIN3TKO5TOKENEE8CAPACITYEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO5TOKENEE8CAPACITYEv
_ZN5ArrayIN3TKO5TOKENEE8CAPACITYEv:
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
	.def	_ZN5ArrayIN3TKO5TOKENEE7ISEMPTYEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO5TOKENEE7ISEMPTYEv
_ZN5ArrayIN3TKO5TOKENEE7ISEMPTYEv:
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
	.def	_ZN5ArrayIN3TKO5TOKENEE7RESERVEEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO5TOKENEE7RESERVEEi
_ZN5ArrayIN3TKO5TOKENEE7RESERVEEi:
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
	call	_ZN5ArrayIN3TKO5TOKENEE8CAPACITYEv
	mov	DWORD PTR -8[rbp], eax
	mov	eax, DWORD PTR 24[rbp]
	cmp	eax, DWORD PTR -8[rbp]
	jle	.L322
	nop
.L311:
.L313:
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIN3TKO5TOKENEE8CAPACITYEv
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
	mov	edx, 16
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
	.def	_ZN5ArrayIN3TKO5TOKENEE6SHRINKEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO5TOKENEE6SHRINKEv
_ZN5ArrayIN3TKO5TOKENEE6SHRINKEv:
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
	call	_ZN5ArrayIN3TKO5TOKENEE8CAPACITYEv
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
	mov	edx, 16
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
	.def	_ZN5ArrayIN3TKO5TOKENEEixEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO5TOKENEEixEi
_ZN5ArrayIN3TKO5TOKENEEixEi:
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
	sal	rdx, 4
	add	rax, rdx
	mov	QWORD PTR -8[rbp], rax
	nop
.L341:
	mov	rax, QWORD PTR -8[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO5TOKENEE2ATEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO5TOKENEE2ATEi
_ZN5ArrayIN3TKO5TOKENEE2ATEi:
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
	sal	rdx, 4
	add	rax, rdx
	mov	QWORD PTR -8[rbp], rax
	nop
.L345:
	mov	rax, QWORD PTR -8[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO5TOKENEE4PUSHERS1_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO5TOKENEE4PUSHERS1_
_ZN5ArrayIN3TKO5TOKENEE4PUSHERS1_:
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
	call	_ZN5ArrayIN3TKO5TOKENEE7RESERVEEi
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	rdx, QWORD PTR 16[rbp]
	add	rdx, 72
	mov	edx, DWORD PTR [rdx]
	movsx	rdx, edx
	sal	rdx, 4
	lea	rcx, [rax+rdx]
	mov	rax, QWORD PTR 24[rbp]
	mov	rdx, QWORD PTR 8[rax]
	mov	rax, QWORD PTR [rax]
	mov	QWORD PTR [rcx], rax
	mov	QWORD PTR 8[rcx], rdx
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
	.def	_ZN5ArrayIN3TKO5TOKENEE3POPEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO5TOKENEE3POPEv
_ZN5ArrayIN3TKO5TOKENEE3POPEv:
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
.L351:
	lea	rax, -32[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	rax, QWORD PTR 24[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	jne	.L358
	mov	rax, QWORD PTR -32[rbp]
	mov	rdx, QWORD PTR -24[rbp]
	mov	QWORD PTR -16[rbp], rax
	mov	QWORD PTR -8[rbp], rdx
	jmp	.L354
.L353:
.L358:
	nop
.L355:
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
	sal	rdx, 4
	add	rax, rdx
	mov	rdx, QWORD PTR 8[rax]
	mov	rax, QWORD PTR [rax]
	mov	QWORD PTR -32[rbp], rax
	mov	QWORD PTR -24[rbp], rdx
	mov	rax, QWORD PTR -32[rbp]
	mov	rdx, QWORD PTR -24[rbp]
	mov	QWORD PTR -16[rbp], rax
	mov	QWORD PTR -8[rbp], rdx
	nop
.L354:
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
	.def	_ZN5ArrayIN3TKO5TOKENEE6INSERTEiRS1_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO5TOKENEE6INSERTEiRS1_
_ZN5ArrayIN3TKO5TOKENEE6INSERTEiRS1_:
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
	mov	rdx, QWORD PTR 8[rax]
	mov	rax, QWORD PTR [rax]
	mov	QWORD PTR -32[rbp], rax
	mov	QWORD PTR -24[rbp], rdx
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	add	eax, 1
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIN3TKO5TOKENEE7RESERVEEi
	mov	rax, QWORD PTR 16[rbp]
	mov	eax, DWORD PTR 72[rax]
	mov	DWORD PTR -12[rbp], eax
	mov	eax, DWORD PTR 24[rbp]
	add	eax, 1
	mov	DWORD PTR -16[rbp], eax
	jmp	.L368
.L376:
	nop
.L369:
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR -12[rbp]
	movsx	rdx, edx
	sal	rdx, 4
	sub	rdx, 16
	add	rdx, rax
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	ecx, DWORD PTR -12[rbp]
	movsx	rcx, ecx
	sal	rcx, 4
	add	rcx, rax
	mov	rax, QWORD PTR [rdx]
	mov	rdx, QWORD PTR 8[rdx]
	mov	QWORD PTR [rcx], rax
	mov	QWORD PTR 8[rcx], rdx
.L370:
	sub	DWORD PTR -12[rbp], 1
.L368:
	mov	eax, DWORD PTR -12[rbp]
	cmp	eax, DWORD PTR -16[rbp]
	jge	.L376
	nop
.L371:
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 24[rbp]
	movsx	rdx, edx
	sal	rdx, 4
	lea	rcx, [rax+rdx]
	mov	rax, QWORD PTR -32[rbp]
	mov	rdx, QWORD PTR -24[rbp]
	mov	QWORD PTR [rcx], rax
	mov	QWORD PTR 8[rcx], rdx
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
	.def	_ZN5ArrayIN3TKO5TOKENEE6REMOVEEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO5TOKENEE6REMOVEEi
_ZN5ArrayIN3TKO5TOKENEE6REMOVEEi:
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
	sal	rdx, 4
	add	rdx, 16
	add	rdx, rax
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	ecx, DWORD PTR -12[rbp]
	movsx	rcx, ecx
	sal	rcx, 4
	add	rcx, rax
	mov	rax, QWORD PTR [rdx]
	mov	rdx, QWORD PTR 8[rdx]
	mov	QWORD PTR [rcx], rax
	mov	QWORD PTR 8[rcx], rdx
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
	.def	_ZN5ArrayIN3TKO5TOKENEE10REMOVESWAPEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO5TOKENEE10REMOVESWAPEi
_ZN5ArrayIN3TKO5TOKENEE10REMOVESWAPEi:
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
	sal	rdx, 4
	add	rdx, rax
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	ecx, DWORD PTR 24[rbp]
	movsx	rcx, ecx
	sal	rcx, 4
	add	rcx, rax
	mov	rax, QWORD PTR [rdx]
	mov	rdx, QWORD PTR 8[rdx]
	mov	QWORD PTR [rcx], rax
	mov	QWORD PTR 8[rcx], rdx
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
	.def	_ZN5ArrayIN3TKO5TOKENEE5CLEAREv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO5TOKENEE5CLEAREv
_ZN5ArrayIN3TKO5TOKENEE5CLEAREv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
.L415:
	lea	rax, -32[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
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
	sal	rdx, 4
	lea	rcx, [rax+rdx]
	mov	rax, QWORD PTR -32[rbp]
	mov	rdx, QWORD PTR -24[rbp]
	mov	QWORD PTR [rcx], rax
	mov	QWORD PTR 8[rcx], rdx
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
	add	rsp, 32
	pop	rbp
	ret
.L420:
	.seh_endproc
	.def	_ZN5ArrayIN3TKO5TOKENEE11GETITERATOREv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO5TOKENEE11GETITERATOREv
_ZN5ArrayIN3TKO5TOKENEE11GETITERATOREv:
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
	.def	_ZN13ArrayIteratorIN3TKO7LITERALEE7ISVALIDEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN13ArrayIteratorIN3TKO7LITERALEE7ISVALIDEv
_ZN13ArrayIteratorIN3TKO7LITERALEE7ISVALIDEv:
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
	.def	_ZN13ArrayIteratorIN3TKO7LITERALEE5VALUEEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN13ArrayIteratorIN3TKO7LITERALEE5VALUEEv
_ZN13ArrayIteratorIN3TKO7LITERALEE5VALUEEv:
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
	sal	rax, 2
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
	.def	_ZN13ArrayIteratorIN3TKO7LITERALEE8MOVENEXTEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN13ArrayIteratorIN3TKO7LITERALEE8MOVENEXTEv
_ZN13ArrayIteratorIN3TKO7LITERALEE8MOVENEXTEv:
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
	.def	_ZN5ArrayIN3TKO7LITERALEE5COUNTEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO7LITERALEE5COUNTEv
_ZN5ArrayIN3TKO7LITERALEE5COUNTEv:
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
	.def	_ZN5ArrayIN3TKO7LITERALEE8CAPACITYEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO7LITERALEE8CAPACITYEv
_ZN5ArrayIN3TKO7LITERALEE8CAPACITYEv:
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
	.def	_ZN5ArrayIN3TKO7LITERALEE7ISEMPTYEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO7LITERALEE7ISEMPTYEv
_ZN5ArrayIN3TKO7LITERALEE7ISEMPTYEv:
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
	.def	_ZN5ArrayIN3TKO7LITERALEE7RESERVEEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO7LITERALEE7RESERVEEi
_ZN5ArrayIN3TKO7LITERALEE7RESERVEEi:
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
	call	_ZN5ArrayIN3TKO7LITERALEE8CAPACITYEv
	mov	DWORD PTR -8[rbp], eax
	mov	eax, DWORD PTR 24[rbp]
	cmp	eax, DWORD PTR -8[rbp]
	jle	.L464
	nop
.L453:
.L455:
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIN3TKO7LITERALEE8CAPACITYEv
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
	mov	edx, 40
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
	.def	_ZN5ArrayIN3TKO7LITERALEE6SHRINKEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO7LITERALEE6SHRINKEv
_ZN5ArrayIN3TKO7LITERALEE6SHRINKEv:
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
	call	_ZN5ArrayIN3TKO7LITERALEE8CAPACITYEv
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
	mov	edx, 40
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
	.def	_ZN5ArrayIN3TKO7LITERALEEixEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO7LITERALEEixEi
_ZN5ArrayIN3TKO7LITERALEEixEi:
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
	sal	rax, 2
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
	.def	_ZN5ArrayIN3TKO7LITERALEE2ATEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO7LITERALEE2ATEi
_ZN5ArrayIN3TKO7LITERALEE2ATEi:
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
	sal	rax, 2
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
	.def	_ZN5ArrayIN3TKO7LITERALEE4PUSHERS1_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO7LITERALEE4PUSHERS1_
_ZN5ArrayIN3TKO7LITERALEE4PUSHERS1_:
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
.L490:
	mov	rax, QWORD PTR -64[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	add	eax, 1
	mov	edx, eax
	mov	rcx, QWORD PTR -64[rbp]
	call	_ZN5ArrayIN3TKO7LITERALEE7RESERVEEi
	mov	rax, QWORD PTR -64[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	rax, QWORD PTR -64[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	movsx	rdx, eax
	mov	rax, rdx
	sal	rax, 2
	add	rax, rdx
	sal	rax, 3
	lea	rdx, [rcx+rax]
	mov	rax, QWORD PTR -56[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	rbx, QWORD PTR 8[rax]
	mov	QWORD PTR [rdx], rcx
	mov	QWORD PTR 8[rdx], rbx
	mov	rcx, QWORD PTR 16[rax]
	mov	rbx, QWORD PTR 24[rax]
	mov	QWORD PTR 16[rdx], rcx
	mov	QWORD PTR 24[rdx], rbx
	mov	rax, QWORD PTR 32[rax]
	mov	QWORD PTR 32[rdx], rax
	mov	rax, QWORD PTR -64[rbp]
	add	rax, 72
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR -64[rbp]
	add	rax, 72
	add	edx, 1
	mov	DWORD PTR [rax], edx
	nop
	add	rsp, 40
	pop	rbx
	pop	rbp
	ret
.L491:
	.seh_endproc
	.def	_ZN5ArrayIN3TKO7LITERALEE3POPEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO7LITERALEE3POPEv
_ZN5ArrayIN3TKO7LITERALEE3POPEv:
	push	rbp
	.seh_pushreg	rbp
	push	rbx
	.seh_pushreg	rbx
	sub	rsp, 104
	.seh_stackalloc	104
	lea	rbp, 128[rsp]
	.seh_setframe	rbp, 128
	.seh_endprologue
	mov	QWORD PTR 0[rbp], rcx
	mov	QWORD PTR 8[rbp], rdx
	lea	rax, -80[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	QWORD PTR 24[rax], 0
	mov	QWORD PTR 32[rax], 0
.L493:
	lea	rax, -128[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	QWORD PTR 24[rax], 0
	mov	QWORD PTR 32[rax], 0
	mov	rax, QWORD PTR 8[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	jne	.L500
	mov	rax, QWORD PTR -128[rbp]
	mov	rdx, QWORD PTR -120[rbp]
	mov	QWORD PTR -80[rbp], rax
	mov	QWORD PTR -72[rbp], rdx
	mov	rax, QWORD PTR -112[rbp]
	mov	rdx, QWORD PTR -104[rbp]
	mov	QWORD PTR -64[rbp], rax
	mov	QWORD PTR -56[rbp], rdx
	mov	rax, QWORD PTR -96[rbp]
	mov	QWORD PTR -48[rbp], rax
	jmp	.L496
.L495:
.L500:
	nop
.L497:
	mov	rax, QWORD PTR 8[rbp]
	add	rax, 72
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 8[rbp]
	add	rax, 72
	sub	edx, 1
	mov	DWORD PTR [rax], edx
	mov	rax, QWORD PTR 8[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	rax, QWORD PTR 8[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	movsx	rdx, eax
	mov	rax, rdx
	sal	rax, 2
	add	rax, rdx
	sal	rax, 3
	lea	rdx, [rcx+rax]
	lea	rax, -128[rbp]
	mov	rcx, QWORD PTR [rdx]
	mov	rbx, QWORD PTR 8[rdx]
	mov	QWORD PTR [rax], rcx
	mov	QWORD PTR 8[rax], rbx
	mov	rcx, QWORD PTR 16[rdx]
	mov	rbx, QWORD PTR 24[rdx]
	mov	QWORD PTR 16[rax], rcx
	mov	QWORD PTR 24[rax], rbx
	mov	rdx, QWORD PTR 32[rdx]
	mov	QWORD PTR 32[rax], rdx
	mov	rax, QWORD PTR -128[rbp]
	mov	rdx, QWORD PTR -120[rbp]
	mov	QWORD PTR -80[rbp], rax
	mov	QWORD PTR -72[rbp], rdx
	mov	rax, QWORD PTR -112[rbp]
	mov	rdx, QWORD PTR -104[rbp]
	mov	QWORD PTR -64[rbp], rax
	mov	QWORD PTR -56[rbp], rdx
	mov	rax, QWORD PTR -96[rbp]
	mov	QWORD PTR -48[rbp], rax
	nop
.L496:
	mov	rax, QWORD PTR 0[rbp]
	mov	rcx, QWORD PTR -80[rbp]
	mov	rbx, QWORD PTR -72[rbp]
	mov	QWORD PTR [rax], rcx
	mov	QWORD PTR 8[rax], rbx
	mov	rcx, QWORD PTR -64[rbp]
	mov	rbx, QWORD PTR -56[rbp]
	mov	QWORD PTR 16[rax], rcx
	mov	QWORD PTR 24[rax], rbx
	mov	rdx, QWORD PTR -48[rbp]
	mov	QWORD PTR 32[rax], rdx
	mov	rax, QWORD PTR 0[rbp]
	add	rsp, 104
	pop	rbx
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO7LITERALEE6INSERTEiRS1_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO7LITERALEE6INSERTEiRS1_
_ZN5ArrayIN3TKO7LITERALEE6INSERTEiRS1_:
	push	rbp
	.seh_pushreg	rbp
	push	rbx
	.seh_pushreg	rbx
	sub	rsp, 104
	.seh_stackalloc	104
	lea	rbp, 128[rsp]
	.seh_setframe	rbp, 128
	.seh_endprologue
	mov	QWORD PTR 0[rbp], rcx
	mov	DWORD PTR 8[rbp], edx
	mov	QWORD PTR 16[rbp], r8
.L502:
	cmp	DWORD PTR 8[rbp], 0
	js	.L516
	mov	rax, QWORD PTR 0[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR 8[rbp], eax
	setg	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -40[rbp], rax
	jmp	.L505
.L516:
	nop
.L504:
	mov	QWORD PTR -40[rbp], -1
.L505:
	cmp	QWORD PTR -40[rbp], 0
	jne	.L517
	nop
.L507:
.L509:
	lea	rax, -96[rbp]
	mov	rdx, QWORD PTR 16[rbp]
	mov	rcx, QWORD PTR [rdx]
	mov	rbx, QWORD PTR 8[rdx]
	mov	QWORD PTR [rax], rcx
	mov	QWORD PTR 8[rax], rbx
	mov	rcx, QWORD PTR 16[rdx]
	mov	rbx, QWORD PTR 24[rdx]
	mov	QWORD PTR 16[rax], rcx
	mov	QWORD PTR 24[rax], rbx
	mov	rdx, QWORD PTR 32[rdx]
	mov	QWORD PTR 32[rax], rdx
	mov	rax, QWORD PTR 0[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	add	eax, 1
	mov	edx, eax
	mov	rcx, QWORD PTR 0[rbp]
	call	_ZN5ArrayIN3TKO7LITERALEE7RESERVEEi
	mov	rax, QWORD PTR 0[rbp]
	mov	eax, DWORD PTR 72[rax]
	mov	DWORD PTR -44[rbp], eax
	mov	eax, DWORD PTR 8[rbp]
	add	eax, 1
	mov	DWORD PTR -48[rbp], eax
	jmp	.L510
.L518:
	nop
.L511:
	mov	rax, QWORD PTR 0[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	eax, DWORD PTR -44[rbp]
	movsx	rdx, eax
	mov	rax, rdx
	sal	rax, 2
	add	rax, rdx
	sal	rax, 3
	sub	rax, 40
	lea	rdx, [rcx+rax]
	mov	rax, QWORD PTR 0[rbp]
	mov	r8, QWORD PTR [rax]
	mov	eax, DWORD PTR -44[rbp]
	movsx	rcx, eax
	mov	rax, rcx
	sal	rax, 2
	add	rax, rcx
	sal	rax, 3
	add	rax, r8
	mov	rcx, QWORD PTR [rdx]
	mov	rbx, QWORD PTR 8[rdx]
	mov	QWORD PTR [rax], rcx
	mov	QWORD PTR 8[rax], rbx
	mov	rcx, QWORD PTR 16[rdx]
	mov	rbx, QWORD PTR 24[rdx]
	mov	QWORD PTR 16[rax], rcx
	mov	QWORD PTR 24[rax], rbx
	mov	rdx, QWORD PTR 32[rdx]
	mov	QWORD PTR 32[rax], rdx
.L512:
	sub	DWORD PTR -44[rbp], 1
.L510:
	mov	eax, DWORD PTR -44[rbp]
	cmp	eax, DWORD PTR -48[rbp]
	jge	.L518
	nop
.L513:
	mov	rax, QWORD PTR 0[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	eax, DWORD PTR 8[rbp]
	movsx	rdx, eax
	mov	rax, rdx
	sal	rax, 2
	add	rax, rdx
	sal	rax, 3
	lea	rdx, [rcx+rax]
	lea	rax, -96[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	rbx, QWORD PTR 8[rax]
	mov	QWORD PTR [rdx], rcx
	mov	QWORD PTR 8[rdx], rbx
	mov	rcx, QWORD PTR 16[rax]
	mov	rbx, QWORD PTR 24[rax]
	mov	QWORD PTR 16[rdx], rcx
	mov	QWORD PTR 24[rdx], rbx
	mov	rax, QWORD PTR 32[rax]
	mov	QWORD PTR 32[rdx], rax
	mov	rax, QWORD PTR 0[rbp]
	add	rax, 72
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 0[rbp]
	add	rax, 72
	add	edx, 1
	mov	DWORD PTR [rax], edx
	jmp	.L519
.L517:
	nop
.L508:
.L519:
	nop
	add	rsp, 104
	pop	rbx
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO7LITERALEE6REMOVEEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO7LITERALEE6REMOVEEi
_ZN5ArrayIN3TKO7LITERALEE6REMOVEEi:
	push	rbp
	.seh_pushreg	rbp
	push	rbx
	.seh_pushreg	rbx
	sub	rsp, 24
	.seh_stackalloc	24
	lea	rbp, 128[rsp]
	.seh_setframe	rbp, 128
	.seh_endprologue
	mov	QWORD PTR -80[rbp], rcx
	mov	DWORD PTR -72[rbp], edx
.L521:
	cmp	DWORD PTR -72[rbp], 0
	js	.L535
	mov	rax, QWORD PTR -80[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR -72[rbp], eax
	setge	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -120[rbp], rax
	jmp	.L524
.L535:
	nop
.L523:
	mov	QWORD PTR -120[rbp], -1
.L524:
	cmp	QWORD PTR -120[rbp], 0
	jne	.L536
	nop
.L526:
.L528:
	mov	eax, DWORD PTR -72[rbp]
	mov	DWORD PTR -124[rbp], eax
	mov	rax, QWORD PTR -80[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	sub	eax, 2
	mov	DWORD PTR -128[rbp], eax
	jmp	.L529
.L537:
	nop
.L530:
	mov	rax, QWORD PTR -80[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	eax, DWORD PTR -124[rbp]
	movsx	rdx, eax
	mov	rax, rdx
	sal	rax, 2
	add	rax, rdx
	sal	rax, 3
	add	rax, 40
	lea	rdx, [rcx+rax]
	mov	rax, QWORD PTR -80[rbp]
	mov	r8, QWORD PTR [rax]
	mov	eax, DWORD PTR -124[rbp]
	movsx	rcx, eax
	mov	rax, rcx
	sal	rax, 2
	add	rax, rcx
	sal	rax, 3
	add	rax, r8
	mov	rcx, QWORD PTR [rdx]
	mov	rbx, QWORD PTR 8[rdx]
	mov	QWORD PTR [rax], rcx
	mov	QWORD PTR 8[rax], rbx
	mov	rcx, QWORD PTR 16[rdx]
	mov	rbx, QWORD PTR 24[rdx]
	mov	QWORD PTR 16[rax], rcx
	mov	QWORD PTR 24[rax], rbx
	mov	rdx, QWORD PTR 32[rdx]
	mov	QWORD PTR 32[rax], rdx
.L531:
	add	DWORD PTR -124[rbp], 1
.L529:
	mov	eax, DWORD PTR -124[rbp]
	cmp	eax, DWORD PTR -128[rbp]
	jle	.L537
	nop
.L532:
	mov	rax, QWORD PTR -80[rbp]
	add	rax, 72
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR -80[rbp]
	add	rax, 72
	sub	edx, 1
	mov	DWORD PTR [rax], edx
	jmp	.L538
.L536:
	nop
.L527:
.L538:
	nop
	add	rsp, 24
	pop	rbx
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO7LITERALEE10REMOVESWAPEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO7LITERALEE10REMOVESWAPEi
_ZN5ArrayIN3TKO7LITERALEE10REMOVESWAPEi:
	push	rbp
	.seh_pushreg	rbp
	push	rbx
	.seh_pushreg	rbx
	sub	rsp, 24
	.seh_stackalloc	24
	lea	rbp, 128[rsp]
	.seh_setframe	rbp, 128
	.seh_endprologue
	mov	QWORD PTR -80[rbp], rcx
	mov	DWORD PTR -72[rbp], edx
.L540:
	cmp	DWORD PTR -72[rbp], 0
	js	.L552
	mov	rax, QWORD PTR -80[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR -72[rbp], eax
	setge	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -120[rbp], rax
	jmp	.L543
.L552:
	nop
.L542:
	mov	QWORD PTR -120[rbp], -1
.L543:
	cmp	QWORD PTR -120[rbp], 0
	jne	.L553
	nop
.L545:
.L547:
	mov	rax, QWORD PTR -80[rbp]
	add	rax, 72
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR -80[rbp]
	add	rax, 72
	sub	edx, 1
	mov	DWORD PTR [rax], edx
	mov	rax, QWORD PTR -80[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR -72[rbp], eax
	je	.L554
	mov	rax, QWORD PTR -80[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	rax, QWORD PTR -80[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	movsx	rdx, eax
	mov	rax, rdx
	sal	rax, 2
	add	rax, rdx
	sal	rax, 3
	lea	rdx, [rcx+rax]
	mov	rax, QWORD PTR -80[rbp]
	mov	r8, QWORD PTR [rax]
	mov	eax, DWORD PTR -72[rbp]
	movsx	rcx, eax
	mov	rax, rcx
	sal	rax, 2
	add	rax, rcx
	sal	rax, 3
	add	rax, r8
	mov	rcx, QWORD PTR [rdx]
	mov	rbx, QWORD PTR 8[rdx]
	mov	QWORD PTR [rax], rcx
	mov	QWORD PTR 8[rax], rbx
	mov	rcx, QWORD PTR 16[rdx]
	mov	rbx, QWORD PTR 24[rdx]
	mov	QWORD PTR 16[rax], rcx
	mov	QWORD PTR 24[rax], rbx
	mov	rdx, QWORD PTR 32[rdx]
	mov	QWORD PTR 32[rax], rdx
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
	add	rsp, 24
	pop	rbx
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO7LITERALEE5CLEAREv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO7LITERALEE5CLEAREv
_ZN5ArrayIN3TKO7LITERALEE5CLEAREv:
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
.L557:
	lea	rax, -128[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	QWORD PTR 24[rax], 0
	mov	QWORD PTR 32[rax], 0
	mov	DWORD PTR -84[rbp], 0
	mov	rax, QWORD PTR -48[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	sub	eax, 1
	mov	DWORD PTR -88[rbp], eax
	jmp	.L558
.L564:
	nop
.L559:
	mov	rax, QWORD PTR -48[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	eax, DWORD PTR -84[rbp]
	movsx	rdx, eax
	mov	rax, rdx
	sal	rax, 2
	add	rax, rdx
	sal	rax, 3
	lea	rdx, [rcx+rax]
	lea	rax, -128[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	rbx, QWORD PTR 8[rax]
	mov	QWORD PTR [rdx], rcx
	mov	QWORD PTR 8[rdx], rbx
	mov	rcx, QWORD PTR 16[rax]
	mov	rbx, QWORD PTR 24[rax]
	mov	QWORD PTR 16[rdx], rcx
	mov	QWORD PTR 24[rdx], rbx
	mov	rax, QWORD PTR 32[rax]
	mov	QWORD PTR 32[rdx], rax
.L560:
	add	DWORD PTR -84[rbp], 1
.L558:
	mov	eax, DWORD PTR -84[rbp]
	cmp	eax, DWORD PTR -88[rbp]
	jle	.L564
	nop
.L561:
	mov	rax, QWORD PTR -48[rbp]
	add	rax, 72
	mov	DWORD PTR [rax], 0
	nop
	add	rsp, 56
	pop	rbx
	pop	rbp
	ret
.L562:
	.seh_endproc
	.def	_ZN5ArrayIN3TKO7LITERALEE11GETITERATOREv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO7LITERALEE11GETITERATOREv
_ZN5ArrayIN3TKO7LITERALEE11GETITERATOREv:
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
	.def	_ZN13ArrayIteratorItE7ISVALIDEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN13ArrayIteratorItE7ISVALIDEv
_ZN13ArrayIteratorItE7ISVALIDEv:
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
	.def	_ZN13ArrayIteratorItE5VALUEEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN13ArrayIteratorItE5VALUEEv
_ZN13ArrayIteratorItE5VALUEEv:
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
	add	rdx, rdx
	add	rax, rdx
	mov	QWORD PTR -16[rbp], rax
	nop
.L575:
	mov	rax, QWORD PTR -16[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN13ArrayIteratorItE8MOVENEXTEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN13ArrayIteratorItE8MOVENEXTEv
_ZN13ArrayIteratorItE8MOVENEXTEv:
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
	.def	_ZN5ArrayItE5COUNTEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayItE5COUNTEv
_ZN5ArrayItE5COUNTEv:
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
	.def	_ZN5ArrayItE8CAPACITYEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayItE8CAPACITYEv
_ZN5ArrayItE8CAPACITYEv:
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
	.def	_ZN5ArrayItE7ISEMPTYEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayItE7ISEMPTYEv
_ZN5ArrayItE7ISEMPTYEv:
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
	.def	_ZN5ArrayItE7RESERVEEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayItE7RESERVEEi
_ZN5ArrayItE7RESERVEEi:
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
	call	_ZN5ArrayItE8CAPACITYEv
	mov	DWORD PTR -8[rbp], eax
	mov	eax, DWORD PTR 24[rbp]
	cmp	eax, DWORD PTR -8[rbp]
	jle	.L606
	nop
.L595:
.L597:
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayItE8CAPACITYEv
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
	mov	edx, 2
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
	.def	_ZN5ArrayItE6SHRINKEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayItE6SHRINKEv
_ZN5ArrayItE6SHRINKEv:
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
	call	_ZN5ArrayItE8CAPACITYEv
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
	mov	edx, 2
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
	.def	_ZN5ArrayItEixEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayItEixEi
_ZN5ArrayItEixEi:
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
	add	rdx, rdx
	add	rax, rdx
	mov	QWORD PTR -8[rbp], rax
	nop
.L625:
	mov	rax, QWORD PTR -8[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayItE2ATEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayItE2ATEi
_ZN5ArrayItE2ATEi:
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
	add	rdx, rdx
	add	rax, rdx
	mov	QWORD PTR -8[rbp], rax
	nop
.L629:
	mov	rax, QWORD PTR -8[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayItE4PUSHERt;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayItE4PUSHERt
_ZN5ArrayItE4PUSHERt:
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
	call	_ZN5ArrayItE7RESERVEEi
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	rdx, QWORD PTR 16[rbp]
	add	rdx, 72
	mov	edx, DWORD PTR [rdx]
	movsx	rdx, edx
	add	rdx, rdx
	add	rdx, rax
	mov	rax, QWORD PTR 24[rbp]
	movzx	eax, WORD PTR [rax]
	mov	WORD PTR [rdx], ax
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
	.def	_ZN5ArrayItE3POPEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayItE3POPEv
_ZN5ArrayItE3POPEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	WORD PTR -2[rbp], 0
.L635:
	mov	WORD PTR -4[rbp], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	jne	.L642
	movzx	eax, WORD PTR -4[rbp]
	mov	WORD PTR -2[rbp], ax
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
	add	rdx, rdx
	add	rax, rdx
	movzx	eax, WORD PTR [rax]
	mov	WORD PTR -4[rbp], ax
	movzx	eax, WORD PTR -4[rbp]
	mov	WORD PTR -2[rbp], ax
	nop
.L638:
	movzx	eax, WORD PTR -2[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayItE6INSERTEiRt;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayItE6INSERTEiRt
_ZN5ArrayItE6INSERTEiRt:
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
	movzx	eax, WORD PTR [rax]
	mov	WORD PTR -14[rbp], ax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	add	eax, 1
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayItE7RESERVEEi
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
	add	rdx, rdx
	sub	rdx, 2
	lea	rcx, [rax+rdx]
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR -12[rbp]
	movsx	rdx, edx
	add	rdx, rdx
	add	rdx, rax
	movzx	eax, WORD PTR [rcx]
	mov	WORD PTR [rdx], ax
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
	add	rdx, rdx
	add	rdx, rax
	movzx	eax, WORD PTR -14[rbp]
	mov	WORD PTR [rdx], ax
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
	.def	_ZN5ArrayItE6REMOVEEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayItE6REMOVEEi
_ZN5ArrayItE6REMOVEEi:
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
	add	rdx, rdx
	add	rdx, 2
	lea	rcx, [rax+rdx]
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR -12[rbp]
	movsx	rdx, edx
	add	rdx, rdx
	add	rdx, rax
	movzx	eax, WORD PTR [rcx]
	mov	WORD PTR [rdx], ax
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
	.def	_ZN5ArrayItE10REMOVESWAPEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayItE10REMOVESWAPEi
_ZN5ArrayItE10REMOVESWAPEi:
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
	add	rdx, rdx
	lea	rcx, [rax+rdx]
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 24[rbp]
	movsx	rdx, edx
	add	rdx, rdx
	add	rdx, rax
	movzx	eax, WORD PTR [rcx]
	mov	WORD PTR [rdx], ax
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
	.def	_ZN5ArrayItE5CLEAREv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayItE5CLEAREv
_ZN5ArrayItE5CLEAREv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
.L699:
	mov	WORD PTR -10[rbp], 0
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
	add	rdx, rdx
	add	rdx, rax
	movzx	eax, WORD PTR -10[rbp]
	mov	WORD PTR [rdx], ax
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
	.def	_ZN5ArrayItE11GETITERATOREv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayItE11GETITERATOREv
_ZN5ArrayItE11GETITERATOREv:
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
	.def	_ZN13ArrayIteratorIN3TKO7ASTNODEEE7ISVALIDEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN13ArrayIteratorIN3TKO7ASTNODEEE7ISVALIDEv
_ZN13ArrayIteratorIN3TKO7ASTNODEEE7ISVALIDEv:
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
	.def	_ZN13ArrayIteratorIN3TKO7ASTNODEEE5VALUEEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN13ArrayIteratorIN3TKO7ASTNODEEE5VALUEEv
_ZN13ArrayIteratorIN3TKO7ASTNODEEE5VALUEEv:
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
.L717:
	mov	rax, QWORD PTR -16[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN13ArrayIteratorIN3TKO7ASTNODEEE8MOVENEXTEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN13ArrayIteratorIN3TKO7ASTNODEEE8MOVENEXTEv
_ZN13ArrayIteratorIN3TKO7ASTNODEEE8MOVENEXTEv:
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
	.def	_ZN5ArrayIN3TKO7ASTNODEEE5COUNTEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO7ASTNODEEE5COUNTEv
_ZN5ArrayIN3TKO7ASTNODEEE5COUNTEv:
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
	.def	_ZN5ArrayIN3TKO7ASTNODEEE8CAPACITYEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO7ASTNODEEE8CAPACITYEv
_ZN5ArrayIN3TKO7ASTNODEEE8CAPACITYEv:
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
	.def	_ZN5ArrayIN3TKO7ASTNODEEE7ISEMPTYEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO7ASTNODEEE7ISEMPTYEv
_ZN5ArrayIN3TKO7ASTNODEEE7ISEMPTYEv:
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
	.def	_ZN5ArrayIN3TKO7ASTNODEEE7RESERVEEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO7ASTNODEEE7RESERVEEi
_ZN5ArrayIN3TKO7ASTNODEEE7RESERVEEi:
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
	call	_ZN5ArrayIN3TKO7ASTNODEEE8CAPACITYEv
	mov	DWORD PTR -8[rbp], eax
	mov	eax, DWORD PTR 24[rbp]
	cmp	eax, DWORD PTR -8[rbp]
	jle	.L748
	nop
.L737:
.L739:
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIN3TKO7ASTNODEEE8CAPACITYEv
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
	mov	edx, 12
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
	.def	_ZN5ArrayIN3TKO7ASTNODEEE6SHRINKEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO7ASTNODEEE6SHRINKEv
_ZN5ArrayIN3TKO7ASTNODEEE6SHRINKEv:
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
	call	_ZN5ArrayIN3TKO7ASTNODEEE8CAPACITYEv
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
	mov	edx, 12
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
	.def	_ZN5ArrayIN3TKO7ASTNODEEEixEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO7ASTNODEEEixEi
_ZN5ArrayIN3TKO7ASTNODEEEixEi:
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
.L767:
	mov	rax, QWORD PTR -8[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO7ASTNODEEE2ATEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO7ASTNODEEE2ATEi
_ZN5ArrayIN3TKO7ASTNODEEE2ATEi:
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
.L771:
	mov	rax, QWORD PTR -8[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO7ASTNODEEE4PUSHERS1_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO7ASTNODEEE4PUSHERS1_
_ZN5ArrayIN3TKO7ASTNODEEE4PUSHERS1_:
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
	call	_ZN5ArrayIN3TKO7ASTNODEEE7RESERVEEi
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
.L775:
	.seh_endproc
	.def	_ZN5ArrayIN3TKO7ASTNODEEE3POPEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO7ASTNODEEE3POPEv
_ZN5ArrayIN3TKO7ASTNODEEE3POPEv:
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
.L777:
	lea	rax, -24[rbp]
	mov	QWORD PTR [rax], 0
	mov	DWORD PTR 8[rax], 0
	mov	rax, QWORD PTR 24[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	jne	.L784
	mov	rax, QWORD PTR -24[rbp]
	mov	QWORD PTR -12[rbp], rax
	mov	eax, DWORD PTR -16[rbp]
	mov	DWORD PTR -4[rbp], eax
	jmp	.L780
.L779:
.L784:
	nop
.L781:
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
.L780:
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
	.def	_ZN5ArrayIN3TKO7ASTNODEEE6INSERTEiRS1_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO7ASTNODEEE6INSERTEiRS1_
_ZN5ArrayIN3TKO7ASTNODEEE6INSERTEiRS1_:
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
	call	_ZN5ArrayIN3TKO7ASTNODEEE7RESERVEEi
	mov	rax, QWORD PTR 16[rbp]
	mov	eax, DWORD PTR 72[rax]
	mov	DWORD PTR -12[rbp], eax
	mov	eax, DWORD PTR 24[rbp]
	add	eax, 1
	mov	DWORD PTR -16[rbp], eax
	jmp	.L794
.L802:
	nop
.L795:
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
.L796:
	sub	DWORD PTR -12[rbp], 1
.L794:
	mov	eax, DWORD PTR -12[rbp]
	cmp	eax, DWORD PTR -16[rbp]
	jge	.L802
	nop
.L797:
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
	.def	_ZN5ArrayIN3TKO7ASTNODEEE6REMOVEEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO7ASTNODEEE6REMOVEEi
_ZN5ArrayIN3TKO7ASTNODEEE6REMOVEEi:
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
	.def	_ZN5ArrayIN3TKO7ASTNODEEE10REMOVESWAPEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO7ASTNODEEE10REMOVESWAPEi
_ZN5ArrayIN3TKO7ASTNODEEE10REMOVESWAPEi:
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
	.def	_ZN5ArrayIN3TKO7ASTNODEEE5CLEAREv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO7ASTNODEEE5CLEAREv
_ZN5ArrayIN3TKO7ASTNODEEE5CLEAREv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
.L841:
	lea	rax, -20[rbp]
	mov	QWORD PTR [rax], 0
	mov	DWORD PTR 8[rax], 0
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
	add	rsp, 32
	pop	rbp
	ret
.L846:
	.seh_endproc
	.def	_ZN5ArrayIN3TKO7ASTNODEEE11GETITERATOREv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO7ASTNODEEE11GETITERATOREv
_ZN5ArrayIN3TKO7ASTNODEEE11GETITERATOREv:
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
	.def	_ZN13ArrayIteratorIN3TKO12UNARYPAYLOADEE7ISVALIDEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN13ArrayIteratorIN3TKO12UNARYPAYLOADEE7ISVALIDEv
_ZN13ArrayIteratorIN3TKO12UNARYPAYLOADEE7ISVALIDEv:
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
	.def	_ZN13ArrayIteratorIN3TKO12UNARYPAYLOADEE5VALUEEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN13ArrayIteratorIN3TKO12UNARYPAYLOADEE5VALUEEv
_ZN13ArrayIteratorIN3TKO12UNARYPAYLOADEE5VALUEEv:
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
	mov	rax, QWORD PTR [rax]
	mov	rdx, QWORD PTR 16[rbp]
	add	rdx, 8
	mov	edx, DWORD PTR [rdx]
	movsx	rdx, edx
	sal	rdx, 3
	add	rax, rdx
	mov	QWORD PTR -16[rbp], rax
	nop
.L859:
	mov	rax, QWORD PTR -16[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN13ArrayIteratorIN3TKO12UNARYPAYLOADEE8MOVENEXTEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN13ArrayIteratorIN3TKO12UNARYPAYLOADEE8MOVENEXTEv
_ZN13ArrayIteratorIN3TKO12UNARYPAYLOADEE8MOVENEXTEv:
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
	.def	_ZN5ArrayIN3TKO12UNARYPAYLOADEE5COUNTEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO12UNARYPAYLOADEE5COUNTEv
_ZN5ArrayIN3TKO12UNARYPAYLOADEE5COUNTEv:
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
	.def	_ZN5ArrayIN3TKO12UNARYPAYLOADEE8CAPACITYEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO12UNARYPAYLOADEE8CAPACITYEv
_ZN5ArrayIN3TKO12UNARYPAYLOADEE8CAPACITYEv:
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
	.def	_ZN5ArrayIN3TKO12UNARYPAYLOADEE7ISEMPTYEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO12UNARYPAYLOADEE7ISEMPTYEv
_ZN5ArrayIN3TKO12UNARYPAYLOADEE7ISEMPTYEv:
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
	.def	_ZN5ArrayIN3TKO12UNARYPAYLOADEE7RESERVEEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO12UNARYPAYLOADEE7RESERVEEi
_ZN5ArrayIN3TKO12UNARYPAYLOADEE7RESERVEEi:
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
	call	_ZN5ArrayIN3TKO12UNARYPAYLOADEE8CAPACITYEv
	mov	DWORD PTR -8[rbp], eax
	mov	eax, DWORD PTR 24[rbp]
	cmp	eax, DWORD PTR -8[rbp]
	jle	.L890
	nop
.L879:
.L881:
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIN3TKO12UNARYPAYLOADEE8CAPACITYEv
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
	mov	edx, 8
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
	.def	_ZN5ArrayIN3TKO12UNARYPAYLOADEE6SHRINKEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO12UNARYPAYLOADEE6SHRINKEv
_ZN5ArrayIN3TKO12UNARYPAYLOADEE6SHRINKEv:
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
	call	_ZN5ArrayIN3TKO12UNARYPAYLOADEE8CAPACITYEv
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
	mov	edx, 8
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
	.def	_ZN5ArrayIN3TKO12UNARYPAYLOADEEixEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO12UNARYPAYLOADEEixEi
_ZN5ArrayIN3TKO12UNARYPAYLOADEEixEi:
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
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 24[rbp]
	movsx	rdx, edx
	sal	rdx, 3
	add	rax, rdx
	mov	QWORD PTR -8[rbp], rax
	nop
.L909:
	mov	rax, QWORD PTR -8[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO12UNARYPAYLOADEE2ATEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO12UNARYPAYLOADEE2ATEi
_ZN5ArrayIN3TKO12UNARYPAYLOADEE2ATEi:
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
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 24[rbp]
	movsx	rdx, edx
	sal	rdx, 3
	add	rax, rdx
	mov	QWORD PTR -8[rbp], rax
	nop
.L913:
	mov	rax, QWORD PTR -8[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO12UNARYPAYLOADEE4PUSHERS1_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO12UNARYPAYLOADEE4PUSHERS1_
_ZN5ArrayIN3TKO12UNARYPAYLOADEE4PUSHERS1_:
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
	call	_ZN5ArrayIN3TKO12UNARYPAYLOADEE7RESERVEEi
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
.L917:
	.seh_endproc
	.def	_ZN5ArrayIN3TKO12UNARYPAYLOADEE3POPEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO12UNARYPAYLOADEE3POPEv
_ZN5ArrayIN3TKO12UNARYPAYLOADEE3POPEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	lea	rax, -8[rbp]
	mov	QWORD PTR [rax], 0
.L919:
	lea	rax, -16[rbp]
	mov	QWORD PTR [rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	jne	.L926
	mov	rax, QWORD PTR -16[rbp]
	mov	QWORD PTR -8[rbp], rax
	jmp	.L922
.L921:
.L926:
	nop
.L923:
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
.L922:
	mov	rax, QWORD PTR -8[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO12UNARYPAYLOADEE6INSERTEiRS1_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO12UNARYPAYLOADEE6INSERTEiRS1_
_ZN5ArrayIN3TKO12UNARYPAYLOADEE6INSERTEiRS1_:
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
	mov	rax, QWORD PTR 32[rbp]
	mov	rax, QWORD PTR [rax]
	mov	QWORD PTR -24[rbp], rax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	add	eax, 1
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIN3TKO12UNARYPAYLOADEE7RESERVEEi
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
.L938:
	sub	DWORD PTR -12[rbp], 1
.L936:
	mov	eax, DWORD PTR -12[rbp]
	cmp	eax, DWORD PTR -16[rbp]
	jge	.L944
	nop
.L939:
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
	.def	_ZN5ArrayIN3TKO12UNARYPAYLOADEE6REMOVEEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO12UNARYPAYLOADEE6REMOVEEi
_ZN5ArrayIN3TKO12UNARYPAYLOADEE6REMOVEEi:
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
	.def	_ZN5ArrayIN3TKO12UNARYPAYLOADEE10REMOVESWAPEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO12UNARYPAYLOADEE10REMOVESWAPEi
_ZN5ArrayIN3TKO12UNARYPAYLOADEE10REMOVESWAPEi:
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
	.def	_ZN5ArrayIN3TKO12UNARYPAYLOADEE5CLEAREv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO12UNARYPAYLOADEE5CLEAREv
_ZN5ArrayIN3TKO12UNARYPAYLOADEE5CLEAREv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
.L983:
	lea	rax, -16[rbp]
	mov	QWORD PTR [rax], 0
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
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR -4[rbp]
	movsx	rdx, edx
	sal	rdx, 3
	add	rdx, rax
	mov	rax, QWORD PTR -16[rbp]
	mov	QWORD PTR [rdx], rax
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
	add	rsp, 16
	pop	rbp
	ret
.L988:
	.seh_endproc
	.def	_ZN5ArrayIN3TKO12UNARYPAYLOADEE11GETITERATOREv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO12UNARYPAYLOADEE11GETITERATOREv
_ZN5ArrayIN3TKO12UNARYPAYLOADEE11GETITERATOREv:
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
	.def	_ZN13ArrayIteratorIN3TKO13BINARYPAYLOADEE7ISVALIDEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN13ArrayIteratorIN3TKO13BINARYPAYLOADEE7ISVALIDEv
_ZN13ArrayIteratorIN3TKO13BINARYPAYLOADEE7ISVALIDEv:
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
	.def	_ZN13ArrayIteratorIN3TKO13BINARYPAYLOADEE5VALUEEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN13ArrayIteratorIN3TKO13BINARYPAYLOADEE5VALUEEv
_ZN13ArrayIteratorIN3TKO13BINARYPAYLOADEE5VALUEEv:
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
.L1001:
	mov	rax, QWORD PTR -16[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN13ArrayIteratorIN3TKO13BINARYPAYLOADEE8MOVENEXTEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN13ArrayIteratorIN3TKO13BINARYPAYLOADEE8MOVENEXTEv
_ZN13ArrayIteratorIN3TKO13BINARYPAYLOADEE8MOVENEXTEv:
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
	.def	_ZN5ArrayIN3TKO13BINARYPAYLOADEE5COUNTEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO13BINARYPAYLOADEE5COUNTEv
_ZN5ArrayIN3TKO13BINARYPAYLOADEE5COUNTEv:
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
	.def	_ZN5ArrayIN3TKO13BINARYPAYLOADEE8CAPACITYEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO13BINARYPAYLOADEE8CAPACITYEv
_ZN5ArrayIN3TKO13BINARYPAYLOADEE8CAPACITYEv:
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
	.def	_ZN5ArrayIN3TKO13BINARYPAYLOADEE7ISEMPTYEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO13BINARYPAYLOADEE7ISEMPTYEv
_ZN5ArrayIN3TKO13BINARYPAYLOADEE7ISEMPTYEv:
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
	.def	_ZN5ArrayIN3TKO13BINARYPAYLOADEE7RESERVEEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO13BINARYPAYLOADEE7RESERVEEi
_ZN5ArrayIN3TKO13BINARYPAYLOADEE7RESERVEEi:
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
	call	_ZN5ArrayIN3TKO13BINARYPAYLOADEE8CAPACITYEv
	mov	DWORD PTR -8[rbp], eax
	mov	eax, DWORD PTR 24[rbp]
	cmp	eax, DWORD PTR -8[rbp]
	jle	.L1032
	nop
.L1021:
.L1023:
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIN3TKO13BINARYPAYLOADEE8CAPACITYEv
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
	mov	edx, 12
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
	.def	_ZN5ArrayIN3TKO13BINARYPAYLOADEE6SHRINKEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO13BINARYPAYLOADEE6SHRINKEv
_ZN5ArrayIN3TKO13BINARYPAYLOADEE6SHRINKEv:
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
	call	_ZN5ArrayIN3TKO13BINARYPAYLOADEE8CAPACITYEv
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
	mov	edx, 12
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
	.def	_ZN5ArrayIN3TKO13BINARYPAYLOADEEixEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO13BINARYPAYLOADEEixEi
_ZN5ArrayIN3TKO13BINARYPAYLOADEEixEi:
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
.L1051:
	mov	rax, QWORD PTR -8[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO13BINARYPAYLOADEE2ATEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO13BINARYPAYLOADEE2ATEi
_ZN5ArrayIN3TKO13BINARYPAYLOADEE2ATEi:
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
.L1055:
	mov	rax, QWORD PTR -8[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO13BINARYPAYLOADEE4PUSHERS1_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO13BINARYPAYLOADEE4PUSHERS1_
_ZN5ArrayIN3TKO13BINARYPAYLOADEE4PUSHERS1_:
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
	call	_ZN5ArrayIN3TKO13BINARYPAYLOADEE7RESERVEEi
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
.L1059:
	.seh_endproc
	.def	_ZN5ArrayIN3TKO13BINARYPAYLOADEE3POPEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO13BINARYPAYLOADEE3POPEv
_ZN5ArrayIN3TKO13BINARYPAYLOADEE3POPEv:
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
.L1061:
	lea	rax, -24[rbp]
	mov	QWORD PTR [rax], 0
	mov	DWORD PTR 8[rax], 0
	mov	rax, QWORD PTR 24[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	jne	.L1068
	mov	rax, QWORD PTR -24[rbp]
	mov	QWORD PTR -12[rbp], rax
	mov	eax, DWORD PTR -16[rbp]
	mov	DWORD PTR -4[rbp], eax
	jmp	.L1064
.L1063:
.L1068:
	nop
.L1065:
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
.L1064:
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
	.def	_ZN5ArrayIN3TKO13BINARYPAYLOADEE6INSERTEiRS1_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO13BINARYPAYLOADEE6INSERTEiRS1_
_ZN5ArrayIN3TKO13BINARYPAYLOADEE6INSERTEiRS1_:
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
	call	_ZN5ArrayIN3TKO13BINARYPAYLOADEE7RESERVEEi
	mov	rax, QWORD PTR 16[rbp]
	mov	eax, DWORD PTR 72[rax]
	mov	DWORD PTR -12[rbp], eax
	mov	eax, DWORD PTR 24[rbp]
	add	eax, 1
	mov	DWORD PTR -16[rbp], eax
	jmp	.L1078
.L1086:
	nop
.L1079:
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
.L1080:
	sub	DWORD PTR -12[rbp], 1
.L1078:
	mov	eax, DWORD PTR -12[rbp]
	cmp	eax, DWORD PTR -16[rbp]
	jge	.L1086
	nop
.L1081:
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
	.def	_ZN5ArrayIN3TKO13BINARYPAYLOADEE6REMOVEEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO13BINARYPAYLOADEE6REMOVEEi
_ZN5ArrayIN3TKO13BINARYPAYLOADEE6REMOVEEi:
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
	.def	_ZN5ArrayIN3TKO13BINARYPAYLOADEE10REMOVESWAPEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO13BINARYPAYLOADEE10REMOVESWAPEi
_ZN5ArrayIN3TKO13BINARYPAYLOADEE10REMOVESWAPEi:
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
	.def	_ZN5ArrayIN3TKO13BINARYPAYLOADEE5CLEAREv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO13BINARYPAYLOADEE5CLEAREv
_ZN5ArrayIN3TKO13BINARYPAYLOADEE5CLEAREv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
.L1125:
	lea	rax, -20[rbp]
	mov	QWORD PTR [rax], 0
	mov	DWORD PTR 8[rax], 0
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
	add	rsp, 32
	pop	rbp
	ret
.L1130:
	.seh_endproc
	.def	_ZN5ArrayIN3TKO13BINARYPAYLOADEE11GETITERATOREv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO13BINARYPAYLOADEE11GETITERATOREv
_ZN5ArrayIN3TKO13BINARYPAYLOADEE11GETITERATOREv:
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
	.def	_ZN13ArrayIteratorIN3TKO14LITERALPAYLOADEE7ISVALIDEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN13ArrayIteratorIN3TKO14LITERALPAYLOADEE7ISVALIDEv
_ZN13ArrayIteratorIN3TKO14LITERALPAYLOADEE7ISVALIDEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	BYTE PTR -9[rbp], 0
.L1138:
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
.L1139:
	movzx	eax, BYTE PTR -9[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN13ArrayIteratorIN3TKO14LITERALPAYLOADEE5VALUEEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN13ArrayIteratorIN3TKO14LITERALPAYLOADEE5VALUEEv
_ZN13ArrayIteratorIN3TKO14LITERALPAYLOADEE5VALUEEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR -16[rbp], 0
.L1142:
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
.L1143:
	mov	rax, QWORD PTR -16[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN13ArrayIteratorIN3TKO14LITERALPAYLOADEE8MOVENEXTEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN13ArrayIteratorIN3TKO14LITERALPAYLOADEE8MOVENEXTEv
_ZN13ArrayIteratorIN3TKO14LITERALPAYLOADEE8MOVENEXTEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
.L1146:
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
.L1147:
	.seh_endproc
	.def	_ZN5ArrayIN3TKO14LITERALPAYLOADEE5COUNTEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO14LITERALPAYLOADEE5COUNTEv
_ZN5ArrayIN3TKO14LITERALPAYLOADEE5COUNTEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR -4[rbp], 0
.L1149:
	mov	rax, QWORD PTR 16[rbp]
	mov	eax, DWORD PTR 72[rax]
	mov	DWORD PTR -4[rbp], eax
	nop
.L1150:
	mov	eax, DWORD PTR -4[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO14LITERALPAYLOADEE8CAPACITYEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO14LITERALPAYLOADEE8CAPACITYEv
_ZN5ArrayIN3TKO14LITERALPAYLOADEE8CAPACITYEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 64
	.seh_stackalloc	64
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR -20[rbp], 0
.L1153:
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
.L1154:
	mov	eax, DWORD PTR -20[rbp]
	add	rsp, 64
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO14LITERALPAYLOADEE7ISEMPTYEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO14LITERALPAYLOADEE7ISEMPTYEv
_ZN5ArrayIN3TKO14LITERALPAYLOADEE7ISEMPTYEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	BYTE PTR -1[rbp], 0
.L1157:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	sete	al
	mov	BYTE PTR -1[rbp], al
	nop
.L1158:
	movzx	eax, BYTE PTR -1[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO14LITERALPAYLOADEE7RESERVEEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO14LITERALPAYLOADEE7RESERVEEi
_ZN5ArrayIN3TKO14LITERALPAYLOADEE7RESERVEEi:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 80
	.seh_stackalloc	80
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
.L1161:
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIN3TKO14LITERALPAYLOADEE8CAPACITYEv
	mov	DWORD PTR -8[rbp], eax
	mov	eax, DWORD PTR 24[rbp]
	cmp	eax, DWORD PTR -8[rbp]
	jle	.L1174
	nop
.L1163:
.L1165:
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIN3TKO14LITERALPAYLOADEE8CAPACITYEv
	mov	DWORD PTR -12[rbp], eax
	mov	eax, DWORD PTR -12[rbp]
	mov	DWORD PTR -4[rbp], eax
	cmp	DWORD PTR -4[rbp], 7
	jg	.L1175
	mov	DWORD PTR -4[rbp], 8
	jmp	.L1172
.L1167:
.L1168:
.L1175:
	nop
.L1169:
.L1172:
	mov	eax, DWORD PTR -4[rbp]
	cmp	eax, DWORD PTR 24[rbp]
	jge	.L1176
	mov	eax, DWORD PTR -4[rbp]
	cdqe
	add	rax, rax
	mov	DWORD PTR -4[rbp], eax
	jmp	.L1172
.L1176:
	nop
.L1171:
	mov	eax, DWORD PTR -4[rbp]
	cdqe
	sub	rax, 1
	mov	QWORD PTR 48[rsp], rax
	mov	QWORD PTR 40[rsp], 0
	mov	QWORD PTR 32[rsp], 1
	mov	r9d, 0
	mov	r8d, -1
	mov	edx, 32
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayRedimPresvEx
	jmp	.L1177
.L1174:
	nop
.L1164:
.L1177:
	nop
	add	rsp, 80
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO14LITERALPAYLOADEE6SHRINKEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO14LITERALPAYLOADEE6SHRINKEv
_ZN5ArrayIN3TKO14LITERALPAYLOADEE6SHRINKEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 80
	.seh_stackalloc	80
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
.L1179:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	jne	.L1188
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayErase
	jmp	.L1182
.L1181:
.L1188:
	nop
.L1183:
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIN3TKO14LITERALPAYLOADEE8CAPACITYEv
	mov	DWORD PTR -4[rbp], eax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR -4[rbp], eax
	je	.L1189
	nop
.L1185:
.L1186:
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
	mov	edx, 32
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayRedimPresvEx
	jmp	.L1190
.L1189:
	nop
.L1182:
.L1190:
	nop
	add	rsp, 80
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO14LITERALPAYLOADEEixEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO14LITERALPAYLOADEEixEi
_ZN5ArrayIN3TKO14LITERALPAYLOADEEixEi:
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
.L1192:
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 24[rbp]
	movsx	rdx, edx
	sal	rdx, 5
	add	rax, rdx
	mov	QWORD PTR -8[rbp], rax
	nop
.L1193:
	mov	rax, QWORD PTR -8[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO14LITERALPAYLOADEE2ATEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO14LITERALPAYLOADEE2ATEi
_ZN5ArrayIN3TKO14LITERALPAYLOADEE2ATEi:
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
.L1196:
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 24[rbp]
	movsx	rdx, edx
	sal	rdx, 5
	add	rax, rdx
	mov	QWORD PTR -8[rbp], rax
	nop
.L1197:
	mov	rax, QWORD PTR -8[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO14LITERALPAYLOADEE4PUSHERS1_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO14LITERALPAYLOADEE4PUSHERS1_
_ZN5ArrayIN3TKO14LITERALPAYLOADEE4PUSHERS1_:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
.L1200:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	add	eax, 1
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIN3TKO14LITERALPAYLOADEE7RESERVEEi
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	rdx, QWORD PTR 16[rbp]
	add	rdx, 72
	mov	edx, DWORD PTR [rdx]
	movsx	rdx, edx
	sal	rdx, 5
	lea	r8, [rax+rdx]
	mov	rcx, QWORD PTR 24[rbp]
	mov	rax, QWORD PTR [rcx]
	mov	rdx, QWORD PTR 8[rcx]
	mov	QWORD PTR [r8], rax
	mov	QWORD PTR 8[r8], rdx
	mov	rax, QWORD PTR 16[rcx]
	mov	rdx, QWORD PTR 24[rcx]
	mov	QWORD PTR 16[r8], rax
	mov	QWORD PTR 24[r8], rdx
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
.L1201:
	.seh_endproc
	.def	_ZN5ArrayIN3TKO14LITERALPAYLOADEE3POPEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO14LITERALPAYLOADEE3POPEv
_ZN5ArrayIN3TKO14LITERALPAYLOADEE3POPEv:
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
	mov	QWORD PTR 24[rax], 0
.L1203:
	lea	rax, -64[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	QWORD PTR 24[rax], 0
	mov	rax, QWORD PTR 24[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	jne	.L1210
	mov	rax, QWORD PTR -64[rbp]
	mov	rdx, QWORD PTR -56[rbp]
	mov	QWORD PTR -32[rbp], rax
	mov	QWORD PTR -24[rbp], rdx
	mov	rax, QWORD PTR -48[rbp]
	mov	rdx, QWORD PTR -40[rbp]
	mov	QWORD PTR -16[rbp], rax
	mov	QWORD PTR -8[rbp], rdx
	jmp	.L1206
.L1205:
.L1210:
	nop
.L1207:
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
	lea	r8, [rax+rdx]
	lea	rcx, -64[rbp]
	mov	rax, QWORD PTR [r8]
	mov	rdx, QWORD PTR 8[r8]
	mov	QWORD PTR [rcx], rax
	mov	QWORD PTR 8[rcx], rdx
	mov	rax, QWORD PTR 16[r8]
	mov	rdx, QWORD PTR 24[r8]
	mov	QWORD PTR 16[rcx], rax
	mov	QWORD PTR 24[rcx], rdx
	mov	rax, QWORD PTR -64[rbp]
	mov	rdx, QWORD PTR -56[rbp]
	mov	QWORD PTR -32[rbp], rax
	mov	QWORD PTR -24[rbp], rdx
	mov	rax, QWORD PTR -48[rbp]
	mov	rdx, QWORD PTR -40[rbp]
	mov	QWORD PTR -16[rbp], rax
	mov	QWORD PTR -8[rbp], rdx
	nop
.L1206:
	mov	rcx, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR -32[rbp]
	mov	rdx, QWORD PTR -24[rbp]
	mov	QWORD PTR [rcx], rax
	mov	QWORD PTR 8[rcx], rdx
	mov	rax, QWORD PTR -16[rbp]
	mov	rdx, QWORD PTR -8[rbp]
	mov	QWORD PTR 16[rcx], rax
	mov	QWORD PTR 24[rcx], rdx
	mov	rax, QWORD PTR 16[rbp]
	add	rsp, 64
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO14LITERALPAYLOADEE6INSERTEiRS1_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO14LITERALPAYLOADEE6INSERTEiRS1_
_ZN5ArrayIN3TKO14LITERALPAYLOADEE6INSERTEiRS1_:
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
.L1212:
	cmp	DWORD PTR 24[rbp], 0
	js	.L1226
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR 24[rbp], eax
	setg	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -8[rbp], rax
	jmp	.L1215
.L1226:
	nop
.L1214:
	mov	QWORD PTR -8[rbp], -1
.L1215:
	cmp	QWORD PTR -8[rbp], 0
	jne	.L1227
	nop
.L1217:
.L1219:
	lea	rcx, -48[rbp]
	mov	r8, QWORD PTR 32[rbp]
	mov	rax, QWORD PTR [r8]
	mov	rdx, QWORD PTR 8[r8]
	mov	QWORD PTR [rcx], rax
	mov	QWORD PTR 8[rcx], rdx
	mov	rax, QWORD PTR 16[r8]
	mov	rdx, QWORD PTR 24[r8]
	mov	QWORD PTR 16[rcx], rax
	mov	QWORD PTR 24[rcx], rdx
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	add	eax, 1
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIN3TKO14LITERALPAYLOADEE7RESERVEEi
	mov	rax, QWORD PTR 16[rbp]
	mov	eax, DWORD PTR 72[rax]
	mov	DWORD PTR -12[rbp], eax
	mov	eax, DWORD PTR 24[rbp]
	add	eax, 1
	mov	DWORD PTR -16[rbp], eax
	jmp	.L1220
.L1228:
	nop
.L1221:
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR -12[rbp]
	movsx	rdx, edx
	sal	rdx, 5
	sub	rdx, 32
	lea	r8, [rax+rdx]
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR -12[rbp]
	movsx	rdx, edx
	sal	rdx, 5
	lea	rcx, [rax+rdx]
	mov	rax, QWORD PTR [r8]
	mov	rdx, QWORD PTR 8[r8]
	mov	QWORD PTR [rcx], rax
	mov	QWORD PTR 8[rcx], rdx
	mov	rax, QWORD PTR 16[r8]
	mov	rdx, QWORD PTR 24[r8]
	mov	QWORD PTR 16[rcx], rax
	mov	QWORD PTR 24[rcx], rdx
.L1222:
	sub	DWORD PTR -12[rbp], 1
.L1220:
	mov	eax, DWORD PTR -12[rbp]
	cmp	eax, DWORD PTR -16[rbp]
	jge	.L1228
	nop
.L1223:
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 24[rbp]
	movsx	rdx, edx
	sal	rdx, 5
	lea	r8, [rax+rdx]
	lea	rcx, -48[rbp]
	mov	rax, QWORD PTR [rcx]
	mov	rdx, QWORD PTR 8[rcx]
	mov	QWORD PTR [r8], rax
	mov	QWORD PTR 8[r8], rdx
	mov	rax, QWORD PTR 16[rcx]
	mov	rdx, QWORD PTR 24[rcx]
	mov	QWORD PTR 16[r8], rax
	mov	QWORD PTR 24[r8], rdx
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	add	edx, 1
	mov	DWORD PTR [rax], edx
	jmp	.L1229
.L1227:
	nop
.L1218:
.L1229:
	nop
	add	rsp, 80
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO14LITERALPAYLOADEE6REMOVEEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO14LITERALPAYLOADEE6REMOVEEi
_ZN5ArrayIN3TKO14LITERALPAYLOADEE6REMOVEEi:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
.L1231:
	cmp	DWORD PTR 24[rbp], 0
	js	.L1245
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR 24[rbp], eax
	setge	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -8[rbp], rax
	jmp	.L1234
.L1245:
	nop
.L1233:
	mov	QWORD PTR -8[rbp], -1
.L1234:
	cmp	QWORD PTR -8[rbp], 0
	jne	.L1246
	nop
.L1236:
.L1238:
	mov	eax, DWORD PTR 24[rbp]
	mov	DWORD PTR -12[rbp], eax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	sub	eax, 2
	mov	DWORD PTR -16[rbp], eax
	jmp	.L1239
.L1247:
	nop
.L1240:
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR -12[rbp]
	movsx	rdx, edx
	sal	rdx, 5
	add	rdx, 32
	lea	r8, [rax+rdx]
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR -12[rbp]
	movsx	rdx, edx
	sal	rdx, 5
	lea	rcx, [rax+rdx]
	mov	rax, QWORD PTR [r8]
	mov	rdx, QWORD PTR 8[r8]
	mov	QWORD PTR [rcx], rax
	mov	QWORD PTR 8[rcx], rdx
	mov	rax, QWORD PTR 16[r8]
	mov	rdx, QWORD PTR 24[r8]
	mov	QWORD PTR 16[rcx], rax
	mov	QWORD PTR 24[rcx], rdx
.L1241:
	add	DWORD PTR -12[rbp], 1
.L1239:
	mov	eax, DWORD PTR -12[rbp]
	cmp	eax, DWORD PTR -16[rbp]
	jle	.L1247
	nop
.L1242:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	sub	edx, 1
	mov	DWORD PTR [rax], edx
	jmp	.L1248
.L1246:
	nop
.L1237:
.L1248:
	nop
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO14LITERALPAYLOADEE10REMOVESWAPEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO14LITERALPAYLOADEE10REMOVESWAPEi
_ZN5ArrayIN3TKO14LITERALPAYLOADEE10REMOVESWAPEi:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
.L1250:
	cmp	DWORD PTR 24[rbp], 0
	js	.L1262
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR 24[rbp], eax
	setge	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -8[rbp], rax
	jmp	.L1253
.L1262:
	nop
.L1252:
	mov	QWORD PTR -8[rbp], -1
.L1253:
	cmp	QWORD PTR -8[rbp], 0
	jne	.L1263
	nop
.L1255:
.L1257:
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
	je	.L1264
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	rdx, QWORD PTR 16[rbp]
	add	rdx, 72
	mov	edx, DWORD PTR [rdx]
	movsx	rdx, edx
	sal	rdx, 5
	lea	r8, [rax+rdx]
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 24[rbp]
	movsx	rdx, edx
	sal	rdx, 5
	lea	rcx, [rax+rdx]
	mov	rax, QWORD PTR [r8]
	mov	rdx, QWORD PTR 8[r8]
	mov	QWORD PTR [rcx], rax
	mov	QWORD PTR 8[rcx], rdx
	mov	rax, QWORD PTR 16[r8]
	mov	rdx, QWORD PTR 24[r8]
	mov	QWORD PTR 16[rcx], rax
	mov	QWORD PTR 24[rcx], rdx
	jmp	.L1265
.L1256:
.L1259:
.L1263:
	nop
	jmp	.L1265
.L1264:
	nop
.L1260:
.L1265:
	nop
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO14LITERALPAYLOADEE5CLEAREv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO14LITERALPAYLOADEE5CLEAREv
_ZN5ArrayIN3TKO14LITERALPAYLOADEE5CLEAREv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 48
	.seh_stackalloc	48
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
.L1267:
	lea	rax, -48[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	QWORD PTR 24[rax], 0
	mov	DWORD PTR -4[rbp], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	sub	eax, 1
	mov	DWORD PTR -8[rbp], eax
	jmp	.L1268
.L1274:
	nop
.L1269:
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR -4[rbp]
	movsx	rdx, edx
	sal	rdx, 5
	lea	r8, [rax+rdx]
	lea	rcx, -48[rbp]
	mov	rax, QWORD PTR [rcx]
	mov	rdx, QWORD PTR 8[rcx]
	mov	QWORD PTR [r8], rax
	mov	QWORD PTR 8[r8], rdx
	mov	rax, QWORD PTR 16[rcx]
	mov	rdx, QWORD PTR 24[rcx]
	mov	QWORD PTR 16[r8], rax
	mov	QWORD PTR 24[r8], rdx
.L1270:
	add	DWORD PTR -4[rbp], 1
.L1268:
	mov	eax, DWORD PTR -4[rbp]
	cmp	eax, DWORD PTR -8[rbp]
	jle	.L1274
	nop
.L1271:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	DWORD PTR [rax], 0
	nop
	add	rsp, 48
	pop	rbp
	ret
.L1272:
	.seh_endproc
	.def	_ZN5ArrayIN3TKO14LITERALPAYLOADEE11GETITERATOREv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO14LITERALPAYLOADEE11GETITERATOREv
_ZN5ArrayIN3TKO14LITERALPAYLOADEE11GETITERATOREv:
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
.L1276:
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
.L1277:
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
	.def	_ZN13ArrayIteratorIN3TKO12IDENTPAYLOADEE7ISVALIDEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN13ArrayIteratorIN3TKO12IDENTPAYLOADEE7ISVALIDEv
_ZN13ArrayIteratorIN3TKO12IDENTPAYLOADEE7ISVALIDEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	BYTE PTR -9[rbp], 0
.L1280:
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
.L1281:
	movzx	eax, BYTE PTR -9[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN13ArrayIteratorIN3TKO12IDENTPAYLOADEE5VALUEEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN13ArrayIteratorIN3TKO12IDENTPAYLOADEE5VALUEEv
_ZN13ArrayIteratorIN3TKO12IDENTPAYLOADEE5VALUEEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR -16[rbp], 0
.L1284:
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
.L1285:
	mov	rax, QWORD PTR -16[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN13ArrayIteratorIN3TKO12IDENTPAYLOADEE8MOVENEXTEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN13ArrayIteratorIN3TKO12IDENTPAYLOADEE8MOVENEXTEv
_ZN13ArrayIteratorIN3TKO12IDENTPAYLOADEE8MOVENEXTEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
.L1288:
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
.L1289:
	.seh_endproc
	.def	_ZN5ArrayIN3TKO12IDENTPAYLOADEE5COUNTEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO12IDENTPAYLOADEE5COUNTEv
_ZN5ArrayIN3TKO12IDENTPAYLOADEE5COUNTEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR -4[rbp], 0
.L1291:
	mov	rax, QWORD PTR 16[rbp]
	mov	eax, DWORD PTR 72[rax]
	mov	DWORD PTR -4[rbp], eax
	nop
.L1292:
	mov	eax, DWORD PTR -4[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO12IDENTPAYLOADEE8CAPACITYEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO12IDENTPAYLOADEE8CAPACITYEv
_ZN5ArrayIN3TKO12IDENTPAYLOADEE8CAPACITYEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 64
	.seh_stackalloc	64
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR -20[rbp], 0
.L1295:
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
.L1296:
	mov	eax, DWORD PTR -20[rbp]
	add	rsp, 64
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO12IDENTPAYLOADEE7ISEMPTYEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO12IDENTPAYLOADEE7ISEMPTYEv
_ZN5ArrayIN3TKO12IDENTPAYLOADEE7ISEMPTYEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	BYTE PTR -1[rbp], 0
.L1299:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	sete	al
	mov	BYTE PTR -1[rbp], al
	nop
.L1300:
	movzx	eax, BYTE PTR -1[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO12IDENTPAYLOADEE7RESERVEEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO12IDENTPAYLOADEE7RESERVEEi
_ZN5ArrayIN3TKO12IDENTPAYLOADEE7RESERVEEi:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 80
	.seh_stackalloc	80
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
.L1303:
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIN3TKO12IDENTPAYLOADEE8CAPACITYEv
	mov	DWORD PTR -8[rbp], eax
	mov	eax, DWORD PTR 24[rbp]
	cmp	eax, DWORD PTR -8[rbp]
	jle	.L1316
	nop
.L1305:
.L1307:
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIN3TKO12IDENTPAYLOADEE8CAPACITYEv
	mov	DWORD PTR -12[rbp], eax
	mov	eax, DWORD PTR -12[rbp]
	mov	DWORD PTR -4[rbp], eax
	cmp	DWORD PTR -4[rbp], 7
	jg	.L1317
	mov	DWORD PTR -4[rbp], 8
	jmp	.L1314
.L1309:
.L1310:
.L1317:
	nop
.L1311:
.L1314:
	mov	eax, DWORD PTR -4[rbp]
	cmp	eax, DWORD PTR 24[rbp]
	jge	.L1318
	mov	eax, DWORD PTR -4[rbp]
	cdqe
	add	rax, rax
	mov	DWORD PTR -4[rbp], eax
	jmp	.L1314
.L1318:
	nop
.L1313:
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
	jmp	.L1319
.L1316:
	nop
.L1306:
.L1319:
	nop
	add	rsp, 80
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO12IDENTPAYLOADEE6SHRINKEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO12IDENTPAYLOADEE6SHRINKEv
_ZN5ArrayIN3TKO12IDENTPAYLOADEE6SHRINKEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 80
	.seh_stackalloc	80
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
.L1321:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	jne	.L1330
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayErase
	jmp	.L1324
.L1323:
.L1330:
	nop
.L1325:
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIN3TKO12IDENTPAYLOADEE8CAPACITYEv
	mov	DWORD PTR -4[rbp], eax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR -4[rbp], eax
	je	.L1331
	nop
.L1327:
.L1328:
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
	jmp	.L1332
.L1331:
	nop
.L1324:
.L1332:
	nop
	add	rsp, 80
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO12IDENTPAYLOADEEixEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO12IDENTPAYLOADEEixEi
_ZN5ArrayIN3TKO12IDENTPAYLOADEEixEi:
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
.L1334:
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
.L1335:
	mov	rax, QWORD PTR -8[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO12IDENTPAYLOADEE2ATEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO12IDENTPAYLOADEE2ATEi
_ZN5ArrayIN3TKO12IDENTPAYLOADEE2ATEi:
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
.L1338:
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
.L1339:
	mov	rax, QWORD PTR -8[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO12IDENTPAYLOADEE4PUSHERS1_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO12IDENTPAYLOADEE4PUSHERS1_
_ZN5ArrayIN3TKO12IDENTPAYLOADEE4PUSHERS1_:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
.L1342:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	add	eax, 1
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIN3TKO12IDENTPAYLOADEE7RESERVEEi
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
.L1343:
	.seh_endproc
	.def	_ZN5ArrayIN3TKO12IDENTPAYLOADEE3POPEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO12IDENTPAYLOADEE3POPEv
_ZN5ArrayIN3TKO12IDENTPAYLOADEE3POPEv:
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
.L1345:
	lea	rax, -24[rbp]
	mov	QWORD PTR [rax], 0
	mov	DWORD PTR 8[rax], 0
	mov	rax, QWORD PTR 24[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	jne	.L1352
	mov	rax, QWORD PTR -24[rbp]
	mov	QWORD PTR -12[rbp], rax
	mov	eax, DWORD PTR -16[rbp]
	mov	DWORD PTR -4[rbp], eax
	jmp	.L1348
.L1347:
.L1352:
	nop
.L1349:
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
.L1348:
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
	.def	_ZN5ArrayIN3TKO12IDENTPAYLOADEE6INSERTEiRS1_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO12IDENTPAYLOADEE6INSERTEiRS1_
_ZN5ArrayIN3TKO12IDENTPAYLOADEE6INSERTEiRS1_:
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
.L1354:
	cmp	DWORD PTR 24[rbp], 0
	js	.L1368
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR 24[rbp], eax
	setg	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -8[rbp], rax
	jmp	.L1357
.L1368:
	nop
.L1356:
	mov	QWORD PTR -8[rbp], -1
.L1357:
	cmp	QWORD PTR -8[rbp], 0
	jne	.L1369
	nop
.L1359:
.L1361:
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
	call	_ZN5ArrayIN3TKO12IDENTPAYLOADEE7RESERVEEi
	mov	rax, QWORD PTR 16[rbp]
	mov	eax, DWORD PTR 72[rax]
	mov	DWORD PTR -12[rbp], eax
	mov	eax, DWORD PTR 24[rbp]
	add	eax, 1
	mov	DWORD PTR -16[rbp], eax
	jmp	.L1362
.L1370:
	nop
.L1363:
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
.L1364:
	sub	DWORD PTR -12[rbp], 1
.L1362:
	mov	eax, DWORD PTR -12[rbp]
	cmp	eax, DWORD PTR -16[rbp]
	jge	.L1370
	nop
.L1365:
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
	jmp	.L1371
.L1369:
	nop
.L1360:
.L1371:
	nop
	add	rsp, 64
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO12IDENTPAYLOADEE6REMOVEEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO12IDENTPAYLOADEE6REMOVEEi
_ZN5ArrayIN3TKO12IDENTPAYLOADEE6REMOVEEi:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
.L1373:
	cmp	DWORD PTR 24[rbp], 0
	js	.L1387
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR 24[rbp], eax
	setge	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -8[rbp], rax
	jmp	.L1376
.L1387:
	nop
.L1375:
	mov	QWORD PTR -8[rbp], -1
.L1376:
	cmp	QWORD PTR -8[rbp], 0
	jne	.L1388
	nop
.L1378:
.L1380:
	mov	eax, DWORD PTR 24[rbp]
	mov	DWORD PTR -12[rbp], eax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	sub	eax, 2
	mov	DWORD PTR -16[rbp], eax
	jmp	.L1381
.L1389:
	nop
.L1382:
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
.L1383:
	add	DWORD PTR -12[rbp], 1
.L1381:
	mov	eax, DWORD PTR -12[rbp]
	cmp	eax, DWORD PTR -16[rbp]
	jle	.L1389
	nop
.L1384:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	sub	edx, 1
	mov	DWORD PTR [rax], edx
	jmp	.L1390
.L1388:
	nop
.L1379:
.L1390:
	nop
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO12IDENTPAYLOADEE10REMOVESWAPEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO12IDENTPAYLOADEE10REMOVESWAPEi
_ZN5ArrayIN3TKO12IDENTPAYLOADEE10REMOVESWAPEi:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
.L1392:
	cmp	DWORD PTR 24[rbp], 0
	js	.L1404
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR 24[rbp], eax
	setge	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -8[rbp], rax
	jmp	.L1395
.L1404:
	nop
.L1394:
	mov	QWORD PTR -8[rbp], -1
.L1395:
	cmp	QWORD PTR -8[rbp], 0
	jne	.L1405
	nop
.L1397:
.L1399:
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
	je	.L1406
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
	jmp	.L1407
.L1398:
.L1401:
.L1405:
	nop
	jmp	.L1407
.L1406:
	nop
.L1402:
.L1407:
	nop
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO12IDENTPAYLOADEE5CLEAREv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO12IDENTPAYLOADEE5CLEAREv
_ZN5ArrayIN3TKO12IDENTPAYLOADEE5CLEAREv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
.L1409:
	lea	rax, -20[rbp]
	mov	QWORD PTR [rax], 0
	mov	DWORD PTR 8[rax], 0
	mov	DWORD PTR -4[rbp], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	sub	eax, 1
	mov	DWORD PTR -8[rbp], eax
	jmp	.L1410
.L1416:
	nop
.L1411:
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
.L1412:
	add	DWORD PTR -4[rbp], 1
.L1410:
	mov	eax, DWORD PTR -4[rbp]
	cmp	eax, DWORD PTR -8[rbp]
	jle	.L1416
	nop
.L1413:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	DWORD PTR [rax], 0
	nop
	add	rsp, 32
	pop	rbp
	ret
.L1414:
	.seh_endproc
	.def	_ZN5ArrayIN3TKO12IDENTPAYLOADEE11GETITERATOREv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO12IDENTPAYLOADEE11GETITERATOREv
_ZN5ArrayIN3TKO12IDENTPAYLOADEE11GETITERATOREv:
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
.L1418:
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
.L1419:
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
	.def	_ZN13ArrayIteratorIN3TKO11LISTPAYLOADEE7ISVALIDEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN13ArrayIteratorIN3TKO11LISTPAYLOADEE7ISVALIDEv
_ZN13ArrayIteratorIN3TKO11LISTPAYLOADEE7ISVALIDEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	BYTE PTR -9[rbp], 0
.L1422:
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
.L1423:
	movzx	eax, BYTE PTR -9[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN13ArrayIteratorIN3TKO11LISTPAYLOADEE5VALUEEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN13ArrayIteratorIN3TKO11LISTPAYLOADEE5VALUEEv
_ZN13ArrayIteratorIN3TKO11LISTPAYLOADEE5VALUEEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR -16[rbp], 0
.L1426:
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
.L1427:
	mov	rax, QWORD PTR -16[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN13ArrayIteratorIN3TKO11LISTPAYLOADEE8MOVENEXTEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN13ArrayIteratorIN3TKO11LISTPAYLOADEE8MOVENEXTEv
_ZN13ArrayIteratorIN3TKO11LISTPAYLOADEE8MOVENEXTEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
.L1430:
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
.L1431:
	.seh_endproc
	.def	_ZN5ArrayIN3TKO11LISTPAYLOADEE5COUNTEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO11LISTPAYLOADEE5COUNTEv
_ZN5ArrayIN3TKO11LISTPAYLOADEE5COUNTEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR -4[rbp], 0
.L1433:
	mov	rax, QWORD PTR 16[rbp]
	mov	eax, DWORD PTR 72[rax]
	mov	DWORD PTR -4[rbp], eax
	nop
.L1434:
	mov	eax, DWORD PTR -4[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO11LISTPAYLOADEE8CAPACITYEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO11LISTPAYLOADEE8CAPACITYEv
_ZN5ArrayIN3TKO11LISTPAYLOADEE8CAPACITYEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 64
	.seh_stackalloc	64
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR -20[rbp], 0
.L1437:
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
.L1438:
	mov	eax, DWORD PTR -20[rbp]
	add	rsp, 64
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO11LISTPAYLOADEE7ISEMPTYEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO11LISTPAYLOADEE7ISEMPTYEv
_ZN5ArrayIN3TKO11LISTPAYLOADEE7ISEMPTYEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	BYTE PTR -1[rbp], 0
.L1441:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	sete	al
	mov	BYTE PTR -1[rbp], al
	nop
.L1442:
	movzx	eax, BYTE PTR -1[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO11LISTPAYLOADEE7RESERVEEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO11LISTPAYLOADEE7RESERVEEi
_ZN5ArrayIN3TKO11LISTPAYLOADEE7RESERVEEi:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 80
	.seh_stackalloc	80
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
.L1445:
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIN3TKO11LISTPAYLOADEE8CAPACITYEv
	mov	DWORD PTR -8[rbp], eax
	mov	eax, DWORD PTR 24[rbp]
	cmp	eax, DWORD PTR -8[rbp]
	jle	.L1458
	nop
.L1447:
.L1449:
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIN3TKO11LISTPAYLOADEE8CAPACITYEv
	mov	DWORD PTR -12[rbp], eax
	mov	eax, DWORD PTR -12[rbp]
	mov	DWORD PTR -4[rbp], eax
	cmp	DWORD PTR -4[rbp], 7
	jg	.L1459
	mov	DWORD PTR -4[rbp], 8
	jmp	.L1456
.L1451:
.L1452:
.L1459:
	nop
.L1453:
.L1456:
	mov	eax, DWORD PTR -4[rbp]
	cmp	eax, DWORD PTR 24[rbp]
	jge	.L1460
	mov	eax, DWORD PTR -4[rbp]
	cdqe
	add	rax, rax
	mov	DWORD PTR -4[rbp], eax
	jmp	.L1456
.L1460:
	nop
.L1455:
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
	jmp	.L1461
.L1458:
	nop
.L1448:
.L1461:
	nop
	add	rsp, 80
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO11LISTPAYLOADEE6SHRINKEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO11LISTPAYLOADEE6SHRINKEv
_ZN5ArrayIN3TKO11LISTPAYLOADEE6SHRINKEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 80
	.seh_stackalloc	80
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
.L1463:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	jne	.L1472
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayErase
	jmp	.L1466
.L1465:
.L1472:
	nop
.L1467:
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIN3TKO11LISTPAYLOADEE8CAPACITYEv
	mov	DWORD PTR -4[rbp], eax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR -4[rbp], eax
	je	.L1473
	nop
.L1469:
.L1470:
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
	jmp	.L1474
.L1473:
	nop
.L1466:
.L1474:
	nop
	add	rsp, 80
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO11LISTPAYLOADEEixEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO11LISTPAYLOADEEixEi
_ZN5ArrayIN3TKO11LISTPAYLOADEEixEi:
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
.L1476:
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
.L1477:
	mov	rax, QWORD PTR -8[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO11LISTPAYLOADEE2ATEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO11LISTPAYLOADEE2ATEi
_ZN5ArrayIN3TKO11LISTPAYLOADEE2ATEi:
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
.L1480:
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
.L1481:
	mov	rax, QWORD PTR -8[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO11LISTPAYLOADEE4PUSHERS1_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO11LISTPAYLOADEE4PUSHERS1_
_ZN5ArrayIN3TKO11LISTPAYLOADEE4PUSHERS1_:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
.L1484:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	add	eax, 1
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIN3TKO11LISTPAYLOADEE7RESERVEEi
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
.L1485:
	.seh_endproc
	.def	_ZN5ArrayIN3TKO11LISTPAYLOADEE3POPEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO11LISTPAYLOADEE3POPEv
_ZN5ArrayIN3TKO11LISTPAYLOADEE3POPEv:
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
.L1487:
	lea	rax, -24[rbp]
	mov	QWORD PTR [rax], 0
	mov	DWORD PTR 8[rax], 0
	mov	rax, QWORD PTR 24[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	jne	.L1494
	mov	rax, QWORD PTR -24[rbp]
	mov	QWORD PTR -12[rbp], rax
	mov	eax, DWORD PTR -16[rbp]
	mov	DWORD PTR -4[rbp], eax
	jmp	.L1490
.L1489:
.L1494:
	nop
.L1491:
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
.L1490:
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
	.def	_ZN5ArrayIN3TKO11LISTPAYLOADEE6INSERTEiRS1_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO11LISTPAYLOADEE6INSERTEiRS1_
_ZN5ArrayIN3TKO11LISTPAYLOADEE6INSERTEiRS1_:
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
.L1496:
	cmp	DWORD PTR 24[rbp], 0
	js	.L1510
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR 24[rbp], eax
	setg	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -8[rbp], rax
	jmp	.L1499
.L1510:
	nop
.L1498:
	mov	QWORD PTR -8[rbp], -1
.L1499:
	cmp	QWORD PTR -8[rbp], 0
	jne	.L1511
	nop
.L1501:
.L1503:
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
	call	_ZN5ArrayIN3TKO11LISTPAYLOADEE7RESERVEEi
	mov	rax, QWORD PTR 16[rbp]
	mov	eax, DWORD PTR 72[rax]
	mov	DWORD PTR -12[rbp], eax
	mov	eax, DWORD PTR 24[rbp]
	add	eax, 1
	mov	DWORD PTR -16[rbp], eax
	jmp	.L1504
.L1512:
	nop
.L1505:
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
.L1506:
	sub	DWORD PTR -12[rbp], 1
.L1504:
	mov	eax, DWORD PTR -12[rbp]
	cmp	eax, DWORD PTR -16[rbp]
	jge	.L1512
	nop
.L1507:
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
	jmp	.L1513
.L1511:
	nop
.L1502:
.L1513:
	nop
	add	rsp, 64
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO11LISTPAYLOADEE6REMOVEEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO11LISTPAYLOADEE6REMOVEEi
_ZN5ArrayIN3TKO11LISTPAYLOADEE6REMOVEEi:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
.L1515:
	cmp	DWORD PTR 24[rbp], 0
	js	.L1529
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR 24[rbp], eax
	setge	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -8[rbp], rax
	jmp	.L1518
.L1529:
	nop
.L1517:
	mov	QWORD PTR -8[rbp], -1
.L1518:
	cmp	QWORD PTR -8[rbp], 0
	jne	.L1530
	nop
.L1520:
.L1522:
	mov	eax, DWORD PTR 24[rbp]
	mov	DWORD PTR -12[rbp], eax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	sub	eax, 2
	mov	DWORD PTR -16[rbp], eax
	jmp	.L1523
.L1531:
	nop
.L1524:
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
.L1525:
	add	DWORD PTR -12[rbp], 1
.L1523:
	mov	eax, DWORD PTR -12[rbp]
	cmp	eax, DWORD PTR -16[rbp]
	jle	.L1531
	nop
.L1526:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	sub	edx, 1
	mov	DWORD PTR [rax], edx
	jmp	.L1532
.L1530:
	nop
.L1521:
.L1532:
	nop
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO11LISTPAYLOADEE10REMOVESWAPEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO11LISTPAYLOADEE10REMOVESWAPEi
_ZN5ArrayIN3TKO11LISTPAYLOADEE10REMOVESWAPEi:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
.L1534:
	cmp	DWORD PTR 24[rbp], 0
	js	.L1546
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR 24[rbp], eax
	setge	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -8[rbp], rax
	jmp	.L1537
.L1546:
	nop
.L1536:
	mov	QWORD PTR -8[rbp], -1
.L1537:
	cmp	QWORD PTR -8[rbp], 0
	jne	.L1547
	nop
.L1539:
.L1541:
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
	je	.L1548
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
	jmp	.L1549
.L1540:
.L1543:
.L1547:
	nop
	jmp	.L1549
.L1548:
	nop
.L1544:
.L1549:
	nop
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO11LISTPAYLOADEE5CLEAREv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO11LISTPAYLOADEE5CLEAREv
_ZN5ArrayIN3TKO11LISTPAYLOADEE5CLEAREv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
.L1551:
	lea	rax, -20[rbp]
	mov	QWORD PTR [rax], 0
	mov	DWORD PTR 8[rax], 0
	mov	DWORD PTR -4[rbp], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	sub	eax, 1
	mov	DWORD PTR -8[rbp], eax
	jmp	.L1552
.L1558:
	nop
.L1553:
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
.L1554:
	add	DWORD PTR -4[rbp], 1
.L1552:
	mov	eax, DWORD PTR -4[rbp]
	cmp	eax, DWORD PTR -8[rbp]
	jle	.L1558
	nop
.L1555:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	DWORD PTR [rax], 0
	nop
	add	rsp, 32
	pop	rbp
	ret
.L1556:
	.seh_endproc
	.def	_ZN5ArrayIN3TKO11LISTPAYLOADEE11GETITERATOREv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO11LISTPAYLOADEE11GETITERATOREv
_ZN5ArrayIN3TKO11LISTPAYLOADEE11GETITERATOREv:
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
.L1560:
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
.L1561:
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
	.def	_ZN13ArrayIteratorIN3TKO11STMTPAYLOADEE7ISVALIDEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN13ArrayIteratorIN3TKO11STMTPAYLOADEE7ISVALIDEv
_ZN13ArrayIteratorIN3TKO11STMTPAYLOADEE7ISVALIDEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	BYTE PTR -9[rbp], 0
.L1564:
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
.L1565:
	movzx	eax, BYTE PTR -9[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN13ArrayIteratorIN3TKO11STMTPAYLOADEE5VALUEEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN13ArrayIteratorIN3TKO11STMTPAYLOADEE5VALUEEv
_ZN13ArrayIteratorIN3TKO11STMTPAYLOADEE5VALUEEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR -16[rbp], 0
.L1568:
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
	add	rax, rax
	add	rax, rdx
	sal	rax, 2
	add	rax, rcx
	mov	QWORD PTR -16[rbp], rax
	nop
.L1569:
	mov	rax, QWORD PTR -16[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN13ArrayIteratorIN3TKO11STMTPAYLOADEE8MOVENEXTEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN13ArrayIteratorIN3TKO11STMTPAYLOADEE8MOVENEXTEv
_ZN13ArrayIteratorIN3TKO11STMTPAYLOADEE8MOVENEXTEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
.L1572:
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
.L1573:
	.seh_endproc
	.def	_ZN5ArrayIN3TKO11STMTPAYLOADEE5COUNTEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO11STMTPAYLOADEE5COUNTEv
_ZN5ArrayIN3TKO11STMTPAYLOADEE5COUNTEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR -4[rbp], 0
.L1575:
	mov	rax, QWORD PTR 16[rbp]
	mov	eax, DWORD PTR 72[rax]
	mov	DWORD PTR -4[rbp], eax
	nop
.L1576:
	mov	eax, DWORD PTR -4[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO11STMTPAYLOADEE8CAPACITYEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO11STMTPAYLOADEE8CAPACITYEv
_ZN5ArrayIN3TKO11STMTPAYLOADEE8CAPACITYEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 64
	.seh_stackalloc	64
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR -20[rbp], 0
.L1579:
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
.L1580:
	mov	eax, DWORD PTR -20[rbp]
	add	rsp, 64
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO11STMTPAYLOADEE7ISEMPTYEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO11STMTPAYLOADEE7ISEMPTYEv
_ZN5ArrayIN3TKO11STMTPAYLOADEE7ISEMPTYEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	BYTE PTR -1[rbp], 0
.L1583:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	sete	al
	mov	BYTE PTR -1[rbp], al
	nop
.L1584:
	movzx	eax, BYTE PTR -1[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO11STMTPAYLOADEE7RESERVEEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO11STMTPAYLOADEE7RESERVEEi
_ZN5ArrayIN3TKO11STMTPAYLOADEE7RESERVEEi:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 80
	.seh_stackalloc	80
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
.L1587:
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIN3TKO11STMTPAYLOADEE8CAPACITYEv
	mov	DWORD PTR -8[rbp], eax
	mov	eax, DWORD PTR 24[rbp]
	cmp	eax, DWORD PTR -8[rbp]
	jle	.L1600
	nop
.L1589:
.L1591:
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIN3TKO11STMTPAYLOADEE8CAPACITYEv
	mov	DWORD PTR -12[rbp], eax
	mov	eax, DWORD PTR -12[rbp]
	mov	DWORD PTR -4[rbp], eax
	cmp	DWORD PTR -4[rbp], 7
	jg	.L1601
	mov	DWORD PTR -4[rbp], 8
	jmp	.L1598
.L1593:
.L1594:
.L1601:
	nop
.L1595:
.L1598:
	mov	eax, DWORD PTR -4[rbp]
	cmp	eax, DWORD PTR 24[rbp]
	jge	.L1602
	mov	eax, DWORD PTR -4[rbp]
	cdqe
	add	rax, rax
	mov	DWORD PTR -4[rbp], eax
	jmp	.L1598
.L1602:
	nop
.L1597:
	mov	eax, DWORD PTR -4[rbp]
	cdqe
	sub	rax, 1
	mov	QWORD PTR 48[rsp], rax
	mov	QWORD PTR 40[rsp], 0
	mov	QWORD PTR 32[rsp], 1
	mov	r9d, 0
	mov	r8d, -1
	mov	edx, 44
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayRedimPresvEx
	jmp	.L1603
.L1600:
	nop
.L1590:
.L1603:
	nop
	add	rsp, 80
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO11STMTPAYLOADEE6SHRINKEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO11STMTPAYLOADEE6SHRINKEv
_ZN5ArrayIN3TKO11STMTPAYLOADEE6SHRINKEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 80
	.seh_stackalloc	80
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
.L1605:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	jne	.L1614
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayErase
	jmp	.L1608
.L1607:
.L1614:
	nop
.L1609:
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIN3TKO11STMTPAYLOADEE8CAPACITYEv
	mov	DWORD PTR -4[rbp], eax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR -4[rbp], eax
	je	.L1615
	nop
.L1611:
.L1612:
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
	mov	edx, 44
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayRedimPresvEx
	jmp	.L1616
.L1615:
	nop
.L1608:
.L1616:
	nop
	add	rsp, 80
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO11STMTPAYLOADEEixEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO11STMTPAYLOADEEixEi
_ZN5ArrayIN3TKO11STMTPAYLOADEEixEi:
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
.L1618:
	mov	rax, QWORD PTR 16[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	eax, DWORD PTR 24[rbp]
	movsx	rdx, eax
	mov	rax, rdx
	sal	rax, 2
	add	rax, rdx
	add	rax, rax
	add	rax, rdx
	sal	rax, 2
	add	rax, rcx
	mov	QWORD PTR -8[rbp], rax
	nop
.L1619:
	mov	rax, QWORD PTR -8[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO11STMTPAYLOADEE2ATEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO11STMTPAYLOADEE2ATEi
_ZN5ArrayIN3TKO11STMTPAYLOADEE2ATEi:
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
.L1622:
	mov	rax, QWORD PTR 16[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	eax, DWORD PTR 24[rbp]
	movsx	rdx, eax
	mov	rax, rdx
	sal	rax, 2
	add	rax, rdx
	add	rax, rax
	add	rax, rdx
	sal	rax, 2
	add	rax, rcx
	mov	QWORD PTR -8[rbp], rax
	nop
.L1623:
	mov	rax, QWORD PTR -8[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO11STMTPAYLOADEE4PUSHERS1_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO11STMTPAYLOADEE4PUSHERS1_
_ZN5ArrayIN3TKO11STMTPAYLOADEE4PUSHERS1_:
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
.L1626:
	mov	rax, QWORD PTR -64[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	add	eax, 1
	mov	edx, eax
	mov	rcx, QWORD PTR -64[rbp]
	call	_ZN5ArrayIN3TKO11STMTPAYLOADEE7RESERVEEi
	mov	rax, QWORD PTR -64[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	rax, QWORD PTR -64[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	movsx	rdx, eax
	mov	rax, rdx
	sal	rax, 2
	add	rax, rdx
	add	rax, rax
	add	rax, rdx
	sal	rax, 2
	lea	rdx, [rcx+rax]
	mov	rax, QWORD PTR -56[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	rbx, QWORD PTR 8[rax]
	mov	QWORD PTR [rdx], rcx
	mov	QWORD PTR 8[rdx], rbx
	mov	rcx, QWORD PTR 16[rax]
	mov	rbx, QWORD PTR 24[rax]
	mov	QWORD PTR 16[rdx], rcx
	mov	QWORD PTR 24[rdx], rbx
	mov	rcx, QWORD PTR 32[rax]
	mov	QWORD PTR 32[rdx], rcx
	mov	eax, DWORD PTR 40[rax]
	mov	DWORD PTR 40[rdx], eax
	mov	rax, QWORD PTR -64[rbp]
	add	rax, 72
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR -64[rbp]
	add	rax, 72
	add	edx, 1
	mov	DWORD PTR [rax], edx
	nop
	add	rsp, 40
	pop	rbx
	pop	rbp
	ret
.L1627:
	.seh_endproc
	.def	_ZN5ArrayIN3TKO11STMTPAYLOADEE3POPEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO11STMTPAYLOADEE3POPEv
_ZN5ArrayIN3TKO11STMTPAYLOADEE3POPEv:
	push	rbp
	.seh_pushreg	rbp
	push	rbx
	.seh_pushreg	rbx
	sub	rsp, 104
	.seh_stackalloc	104
	lea	rbp, 128[rsp]
	.seh_setframe	rbp, 128
	.seh_endprologue
	mov	QWORD PTR 0[rbp], rcx
	mov	QWORD PTR 8[rbp], rdx
	lea	rax, -80[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	QWORD PTR 24[rax], 0
	mov	QWORD PTR 32[rax], 0
	mov	DWORD PTR 40[rax], 0
.L1629:
	lea	rax, -128[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	QWORD PTR 24[rax], 0
	mov	QWORD PTR 32[rax], 0
	mov	DWORD PTR 40[rax], 0
	mov	rax, QWORD PTR 8[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	jne	.L1636
	mov	rax, QWORD PTR -128[rbp]
	mov	rdx, QWORD PTR -120[rbp]
	mov	QWORD PTR -80[rbp], rax
	mov	QWORD PTR -72[rbp], rdx
	mov	rax, QWORD PTR -112[rbp]
	mov	rdx, QWORD PTR -104[rbp]
	mov	QWORD PTR -64[rbp], rax
	mov	QWORD PTR -56[rbp], rdx
	mov	rax, QWORD PTR -96[rbp]
	mov	QWORD PTR -48[rbp], rax
	mov	eax, DWORD PTR -88[rbp]
	mov	DWORD PTR -40[rbp], eax
	jmp	.L1632
.L1631:
.L1636:
	nop
.L1633:
	mov	rax, QWORD PTR 8[rbp]
	add	rax, 72
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 8[rbp]
	add	rax, 72
	sub	edx, 1
	mov	DWORD PTR [rax], edx
	mov	rax, QWORD PTR 8[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	rax, QWORD PTR 8[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	movsx	rdx, eax
	mov	rax, rdx
	sal	rax, 2
	add	rax, rdx
	add	rax, rax
	add	rax, rdx
	sal	rax, 2
	lea	rdx, [rcx+rax]
	lea	rax, -128[rbp]
	mov	rcx, QWORD PTR [rdx]
	mov	rbx, QWORD PTR 8[rdx]
	mov	QWORD PTR [rax], rcx
	mov	QWORD PTR 8[rax], rbx
	mov	rcx, QWORD PTR 16[rdx]
	mov	rbx, QWORD PTR 24[rdx]
	mov	QWORD PTR 16[rax], rcx
	mov	QWORD PTR 24[rax], rbx
	mov	rcx, QWORD PTR 32[rdx]
	mov	QWORD PTR 32[rax], rcx
	mov	edx, DWORD PTR 40[rdx]
	mov	DWORD PTR 40[rax], edx
	mov	rax, QWORD PTR -128[rbp]
	mov	rdx, QWORD PTR -120[rbp]
	mov	QWORD PTR -80[rbp], rax
	mov	QWORD PTR -72[rbp], rdx
	mov	rax, QWORD PTR -112[rbp]
	mov	rdx, QWORD PTR -104[rbp]
	mov	QWORD PTR -64[rbp], rax
	mov	QWORD PTR -56[rbp], rdx
	mov	rax, QWORD PTR -96[rbp]
	mov	QWORD PTR -48[rbp], rax
	mov	eax, DWORD PTR -88[rbp]
	mov	DWORD PTR -40[rbp], eax
	nop
.L1632:
	mov	rax, QWORD PTR 0[rbp]
	mov	rcx, QWORD PTR -80[rbp]
	mov	rbx, QWORD PTR -72[rbp]
	mov	QWORD PTR [rax], rcx
	mov	QWORD PTR 8[rax], rbx
	mov	rcx, QWORD PTR -64[rbp]
	mov	rbx, QWORD PTR -56[rbp]
	mov	QWORD PTR 16[rax], rcx
	mov	QWORD PTR 24[rax], rbx
	mov	rdx, QWORD PTR -48[rbp]
	mov	QWORD PTR 32[rax], rdx
	mov	edx, DWORD PTR -40[rbp]
	mov	DWORD PTR 40[rax], edx
	mov	rax, QWORD PTR 0[rbp]
	add	rsp, 104
	pop	rbx
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO11STMTPAYLOADEE6INSERTEiRS1_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO11STMTPAYLOADEE6INSERTEiRS1_
_ZN5ArrayIN3TKO11STMTPAYLOADEE6INSERTEiRS1_:
	push	rbp
	.seh_pushreg	rbp
	push	rbx
	.seh_pushreg	rbx
	sub	rsp, 104
	.seh_stackalloc	104
	lea	rbp, 128[rsp]
	.seh_setframe	rbp, 128
	.seh_endprologue
	mov	QWORD PTR 0[rbp], rcx
	mov	DWORD PTR 8[rbp], edx
	mov	QWORD PTR 16[rbp], r8
.L1638:
	cmp	DWORD PTR 8[rbp], 0
	js	.L1652
	mov	rax, QWORD PTR 0[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR 8[rbp], eax
	setg	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -40[rbp], rax
	jmp	.L1641
.L1652:
	nop
.L1640:
	mov	QWORD PTR -40[rbp], -1
.L1641:
	cmp	QWORD PTR -40[rbp], 0
	jne	.L1653
	nop
.L1643:
.L1645:
	lea	rax, -96[rbp]
	mov	rdx, QWORD PTR 16[rbp]
	mov	rcx, QWORD PTR [rdx]
	mov	rbx, QWORD PTR 8[rdx]
	mov	QWORD PTR [rax], rcx
	mov	QWORD PTR 8[rax], rbx
	mov	rcx, QWORD PTR 16[rdx]
	mov	rbx, QWORD PTR 24[rdx]
	mov	QWORD PTR 16[rax], rcx
	mov	QWORD PTR 24[rax], rbx
	mov	rcx, QWORD PTR 32[rdx]
	mov	QWORD PTR 32[rax], rcx
	mov	edx, DWORD PTR 40[rdx]
	mov	DWORD PTR 40[rax], edx
	mov	rax, QWORD PTR 0[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	add	eax, 1
	mov	edx, eax
	mov	rcx, QWORD PTR 0[rbp]
	call	_ZN5ArrayIN3TKO11STMTPAYLOADEE7RESERVEEi
	mov	rax, QWORD PTR 0[rbp]
	mov	eax, DWORD PTR 72[rax]
	mov	DWORD PTR -44[rbp], eax
	mov	eax, DWORD PTR 8[rbp]
	add	eax, 1
	mov	DWORD PTR -48[rbp], eax
	jmp	.L1646
.L1654:
	nop
.L1647:
	mov	rax, QWORD PTR 0[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	eax, DWORD PTR -44[rbp]
	movsx	rdx, eax
	mov	rax, rdx
	sal	rax, 2
	add	rax, rdx
	add	rax, rax
	add	rax, rdx
	sal	rax, 2
	sub	rax, 44
	lea	rdx, [rcx+rax]
	mov	rax, QWORD PTR 0[rbp]
	mov	r8, QWORD PTR [rax]
	mov	eax, DWORD PTR -44[rbp]
	movsx	rcx, eax
	mov	rax, rcx
	sal	rax, 2
	add	rax, rcx
	add	rax, rax
	add	rax, rcx
	sal	rax, 2
	add	rax, r8
	mov	rcx, QWORD PTR [rdx]
	mov	rbx, QWORD PTR 8[rdx]
	mov	QWORD PTR [rax], rcx
	mov	QWORD PTR 8[rax], rbx
	mov	rcx, QWORD PTR 16[rdx]
	mov	rbx, QWORD PTR 24[rdx]
	mov	QWORD PTR 16[rax], rcx
	mov	QWORD PTR 24[rax], rbx
	mov	rcx, QWORD PTR 32[rdx]
	mov	QWORD PTR 32[rax], rcx
	mov	edx, DWORD PTR 40[rdx]
	mov	DWORD PTR 40[rax], edx
.L1648:
	sub	DWORD PTR -44[rbp], 1
.L1646:
	mov	eax, DWORD PTR -44[rbp]
	cmp	eax, DWORD PTR -48[rbp]
	jge	.L1654
	nop
.L1649:
	mov	rax, QWORD PTR 0[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	eax, DWORD PTR 8[rbp]
	movsx	rdx, eax
	mov	rax, rdx
	sal	rax, 2
	add	rax, rdx
	add	rax, rax
	add	rax, rdx
	sal	rax, 2
	lea	rdx, [rcx+rax]
	lea	rax, -96[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	rbx, QWORD PTR 8[rax]
	mov	QWORD PTR [rdx], rcx
	mov	QWORD PTR 8[rdx], rbx
	mov	rcx, QWORD PTR 16[rax]
	mov	rbx, QWORD PTR 24[rax]
	mov	QWORD PTR 16[rdx], rcx
	mov	QWORD PTR 24[rdx], rbx
	mov	rcx, QWORD PTR 32[rax]
	mov	QWORD PTR 32[rdx], rcx
	mov	eax, DWORD PTR 40[rax]
	mov	DWORD PTR 40[rdx], eax
	mov	rax, QWORD PTR 0[rbp]
	add	rax, 72
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 0[rbp]
	add	rax, 72
	add	edx, 1
	mov	DWORD PTR [rax], edx
	jmp	.L1655
.L1653:
	nop
.L1644:
.L1655:
	nop
	add	rsp, 104
	pop	rbx
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO11STMTPAYLOADEE6REMOVEEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO11STMTPAYLOADEE6REMOVEEi
_ZN5ArrayIN3TKO11STMTPAYLOADEE6REMOVEEi:
	push	rbp
	.seh_pushreg	rbp
	push	rbx
	.seh_pushreg	rbx
	sub	rsp, 24
	.seh_stackalloc	24
	lea	rbp, 128[rsp]
	.seh_setframe	rbp, 128
	.seh_endprologue
	mov	QWORD PTR -80[rbp], rcx
	mov	DWORD PTR -72[rbp], edx
.L1657:
	cmp	DWORD PTR -72[rbp], 0
	js	.L1671
	mov	rax, QWORD PTR -80[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR -72[rbp], eax
	setge	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -120[rbp], rax
	jmp	.L1660
.L1671:
	nop
.L1659:
	mov	QWORD PTR -120[rbp], -1
.L1660:
	cmp	QWORD PTR -120[rbp], 0
	jne	.L1672
	nop
.L1662:
.L1664:
	mov	eax, DWORD PTR -72[rbp]
	mov	DWORD PTR -124[rbp], eax
	mov	rax, QWORD PTR -80[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	sub	eax, 2
	mov	DWORD PTR -128[rbp], eax
	jmp	.L1665
.L1673:
	nop
.L1666:
	mov	rax, QWORD PTR -80[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	eax, DWORD PTR -124[rbp]
	movsx	rdx, eax
	mov	rax, rdx
	sal	rax, 2
	add	rax, rdx
	add	rax, rax
	add	rax, rdx
	sal	rax, 2
	add	rax, 44
	lea	rdx, [rcx+rax]
	mov	rax, QWORD PTR -80[rbp]
	mov	r8, QWORD PTR [rax]
	mov	eax, DWORD PTR -124[rbp]
	movsx	rcx, eax
	mov	rax, rcx
	sal	rax, 2
	add	rax, rcx
	add	rax, rax
	add	rax, rcx
	sal	rax, 2
	add	rax, r8
	mov	rcx, QWORD PTR [rdx]
	mov	rbx, QWORD PTR 8[rdx]
	mov	QWORD PTR [rax], rcx
	mov	QWORD PTR 8[rax], rbx
	mov	rcx, QWORD PTR 16[rdx]
	mov	rbx, QWORD PTR 24[rdx]
	mov	QWORD PTR 16[rax], rcx
	mov	QWORD PTR 24[rax], rbx
	mov	rcx, QWORD PTR 32[rdx]
	mov	QWORD PTR 32[rax], rcx
	mov	edx, DWORD PTR 40[rdx]
	mov	DWORD PTR 40[rax], edx
.L1667:
	add	DWORD PTR -124[rbp], 1
.L1665:
	mov	eax, DWORD PTR -124[rbp]
	cmp	eax, DWORD PTR -128[rbp]
	jle	.L1673
	nop
.L1668:
	mov	rax, QWORD PTR -80[rbp]
	add	rax, 72
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR -80[rbp]
	add	rax, 72
	sub	edx, 1
	mov	DWORD PTR [rax], edx
	jmp	.L1674
.L1672:
	nop
.L1663:
.L1674:
	nop
	add	rsp, 24
	pop	rbx
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO11STMTPAYLOADEE10REMOVESWAPEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO11STMTPAYLOADEE10REMOVESWAPEi
_ZN5ArrayIN3TKO11STMTPAYLOADEE10REMOVESWAPEi:
	push	rbp
	.seh_pushreg	rbp
	push	rbx
	.seh_pushreg	rbx
	sub	rsp, 24
	.seh_stackalloc	24
	lea	rbp, 128[rsp]
	.seh_setframe	rbp, 128
	.seh_endprologue
	mov	QWORD PTR -80[rbp], rcx
	mov	DWORD PTR -72[rbp], edx
.L1676:
	cmp	DWORD PTR -72[rbp], 0
	js	.L1688
	mov	rax, QWORD PTR -80[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR -72[rbp], eax
	setge	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -120[rbp], rax
	jmp	.L1679
.L1688:
	nop
.L1678:
	mov	QWORD PTR -120[rbp], -1
.L1679:
	cmp	QWORD PTR -120[rbp], 0
	jne	.L1689
	nop
.L1681:
.L1683:
	mov	rax, QWORD PTR -80[rbp]
	add	rax, 72
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR -80[rbp]
	add	rax, 72
	sub	edx, 1
	mov	DWORD PTR [rax], edx
	mov	rax, QWORD PTR -80[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR -72[rbp], eax
	je	.L1690
	mov	rax, QWORD PTR -80[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	rax, QWORD PTR -80[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	movsx	rdx, eax
	mov	rax, rdx
	sal	rax, 2
	add	rax, rdx
	add	rax, rax
	add	rax, rdx
	sal	rax, 2
	lea	rdx, [rcx+rax]
	mov	rax, QWORD PTR -80[rbp]
	mov	r8, QWORD PTR [rax]
	mov	eax, DWORD PTR -72[rbp]
	movsx	rcx, eax
	mov	rax, rcx
	sal	rax, 2
	add	rax, rcx
	add	rax, rax
	add	rax, rcx
	sal	rax, 2
	add	rax, r8
	mov	rcx, QWORD PTR [rdx]
	mov	rbx, QWORD PTR 8[rdx]
	mov	QWORD PTR [rax], rcx
	mov	QWORD PTR 8[rax], rbx
	mov	rcx, QWORD PTR 16[rdx]
	mov	rbx, QWORD PTR 24[rdx]
	mov	QWORD PTR 16[rax], rcx
	mov	QWORD PTR 24[rax], rbx
	mov	rcx, QWORD PTR 32[rdx]
	mov	QWORD PTR 32[rax], rcx
	mov	edx, DWORD PTR 40[rdx]
	mov	DWORD PTR 40[rax], edx
	jmp	.L1691
.L1682:
.L1685:
.L1689:
	nop
	jmp	.L1691
.L1690:
	nop
.L1686:
.L1691:
	nop
	add	rsp, 24
	pop	rbx
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO11STMTPAYLOADEE5CLEAREv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO11STMTPAYLOADEE5CLEAREv
_ZN5ArrayIN3TKO11STMTPAYLOADEE5CLEAREv:
	push	rbp
	.seh_pushreg	rbp
	push	rbx
	.seh_pushreg	rbx
	sub	rsp, 72
	.seh_stackalloc	72
	lea	rbp, 128[rsp]
	.seh_setframe	rbp, 128
	.seh_endprologue
	mov	QWORD PTR -32[rbp], rcx
.L1693:
	lea	rax, -128[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	QWORD PTR 24[rax], 0
	mov	QWORD PTR 32[rax], 0
	mov	DWORD PTR 40[rax], 0
	mov	DWORD PTR -68[rbp], 0
	mov	rax, QWORD PTR -32[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	sub	eax, 1
	mov	DWORD PTR -72[rbp], eax
	jmp	.L1694
.L1700:
	nop
.L1695:
	mov	rax, QWORD PTR -32[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	eax, DWORD PTR -68[rbp]
	movsx	rdx, eax
	mov	rax, rdx
	sal	rax, 2
	add	rax, rdx
	add	rax, rax
	add	rax, rdx
	sal	rax, 2
	lea	rdx, [rcx+rax]
	lea	rax, -128[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	rbx, QWORD PTR 8[rax]
	mov	QWORD PTR [rdx], rcx
	mov	QWORD PTR 8[rdx], rbx
	mov	rcx, QWORD PTR 16[rax]
	mov	rbx, QWORD PTR 24[rax]
	mov	QWORD PTR 16[rdx], rcx
	mov	QWORD PTR 24[rdx], rbx
	mov	rcx, QWORD PTR 32[rax]
	mov	QWORD PTR 32[rdx], rcx
	mov	eax, DWORD PTR 40[rax]
	mov	DWORD PTR 40[rdx], eax
.L1696:
	add	DWORD PTR -68[rbp], 1
.L1694:
	mov	eax, DWORD PTR -68[rbp]
	cmp	eax, DWORD PTR -72[rbp]
	jle	.L1700
	nop
.L1697:
	mov	rax, QWORD PTR -32[rbp]
	add	rax, 72
	mov	DWORD PTR [rax], 0
	nop
	add	rsp, 72
	pop	rbx
	pop	rbp
	ret
.L1698:
	.seh_endproc
	.def	_ZN5ArrayIN3TKO11STMTPAYLOADEE11GETITERATOREv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO11STMTPAYLOADEE11GETITERATOREv
_ZN5ArrayIN3TKO11STMTPAYLOADEE11GETITERATOREv:
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
.L1702:
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
.L1703:
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
.L1706:
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
.L1707:
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
.L1710:
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
.L1711:
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
.L1714:
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
.L1715:
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
.L1717:
	mov	rax, QWORD PTR 16[rbp]
	mov	eax, DWORD PTR 72[rax]
	mov	DWORD PTR -4[rbp], eax
	nop
.L1718:
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
.L1721:
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
.L1722:
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
.L1725:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	sete	al
	mov	BYTE PTR -1[rbp], al
	nop
.L1726:
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
.L1729:
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIjE8CAPACITYEv
	mov	DWORD PTR -8[rbp], eax
	mov	eax, DWORD PTR 24[rbp]
	cmp	eax, DWORD PTR -8[rbp]
	jle	.L1742
	nop
.L1731:
.L1733:
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIjE8CAPACITYEv
	mov	DWORD PTR -12[rbp], eax
	mov	eax, DWORD PTR -12[rbp]
	mov	DWORD PTR -4[rbp], eax
	cmp	DWORD PTR -4[rbp], 7
	jg	.L1743
	mov	DWORD PTR -4[rbp], 8
	jmp	.L1740
.L1735:
.L1736:
.L1743:
	nop
.L1737:
.L1740:
	mov	eax, DWORD PTR -4[rbp]
	cmp	eax, DWORD PTR 24[rbp]
	jge	.L1744
	mov	eax, DWORD PTR -4[rbp]
	cdqe
	add	rax, rax
	mov	DWORD PTR -4[rbp], eax
	jmp	.L1740
.L1744:
	nop
.L1739:
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
	jmp	.L1745
.L1742:
	nop
.L1732:
.L1745:
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
.L1747:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	jne	.L1756
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayErase
	jmp	.L1750
.L1749:
.L1756:
	nop
.L1751:
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIjE8CAPACITYEv
	mov	DWORD PTR -4[rbp], eax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR -4[rbp], eax
	je	.L1757
	nop
.L1753:
.L1754:
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
	jmp	.L1758
.L1757:
	nop
.L1750:
.L1758:
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
.L1760:
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 24[rbp]
	movsx	rdx, edx
	sal	rdx, 2
	add	rax, rdx
	mov	QWORD PTR -8[rbp], rax
	nop
.L1761:
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
.L1764:
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 24[rbp]
	movsx	rdx, edx
	sal	rdx, 2
	add	rax, rdx
	mov	QWORD PTR -8[rbp], rax
	nop
.L1765:
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
.L1768:
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
.L1769:
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
.L1771:
	mov	DWORD PTR -8[rbp], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	jne	.L1778
	mov	eax, DWORD PTR -8[rbp]
	mov	DWORD PTR -4[rbp], eax
	jmp	.L1774
.L1773:
.L1778:
	nop
.L1775:
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
.L1774:
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
.L1780:
	cmp	DWORD PTR 24[rbp], 0
	js	.L1794
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR 24[rbp], eax
	setg	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -8[rbp], rax
	jmp	.L1783
.L1794:
	nop
.L1782:
	mov	QWORD PTR -8[rbp], -1
.L1783:
	cmp	QWORD PTR -8[rbp], 0
	jne	.L1795
	nop
.L1785:
.L1787:
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
	jmp	.L1788
.L1796:
	nop
.L1789:
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
.L1790:
	sub	DWORD PTR -12[rbp], 1
.L1788:
	mov	eax, DWORD PTR -12[rbp]
	cmp	eax, DWORD PTR -20[rbp]
	jge	.L1796
	nop
.L1791:
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
	jmp	.L1797
.L1795:
	nop
.L1786:
.L1797:
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
.L1799:
	cmp	DWORD PTR 24[rbp], 0
	js	.L1813
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR 24[rbp], eax
	setge	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -8[rbp], rax
	jmp	.L1802
.L1813:
	nop
.L1801:
	mov	QWORD PTR -8[rbp], -1
.L1802:
	cmp	QWORD PTR -8[rbp], 0
	jne	.L1814
	nop
.L1804:
.L1806:
	mov	eax, DWORD PTR 24[rbp]
	mov	DWORD PTR -12[rbp], eax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	sub	eax, 2
	mov	DWORD PTR -16[rbp], eax
	jmp	.L1807
.L1815:
	nop
.L1808:
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
.L1809:
	add	DWORD PTR -12[rbp], 1
.L1807:
	mov	eax, DWORD PTR -12[rbp]
	cmp	eax, DWORD PTR -16[rbp]
	jle	.L1815
	nop
.L1810:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	sub	edx, 1
	mov	DWORD PTR [rax], edx
	jmp	.L1816
.L1814:
	nop
.L1805:
.L1816:
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
.L1818:
	cmp	DWORD PTR 24[rbp], 0
	js	.L1830
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR 24[rbp], eax
	setge	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -8[rbp], rax
	jmp	.L1821
.L1830:
	nop
.L1820:
	mov	QWORD PTR -8[rbp], -1
.L1821:
	cmp	QWORD PTR -8[rbp], 0
	jne	.L1831
	nop
.L1823:
.L1825:
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
	je	.L1832
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
	jmp	.L1833
.L1824:
.L1827:
.L1831:
	nop
	jmp	.L1833
.L1832:
	nop
.L1828:
.L1833:
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
.L1835:
	mov	DWORD PTR -12[rbp], 0
	mov	DWORD PTR -4[rbp], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	sub	eax, 1
	mov	DWORD PTR -8[rbp], eax
	jmp	.L1836
.L1842:
	nop
.L1837:
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR -4[rbp]
	movsx	rdx, edx
	sal	rdx, 2
	add	rdx, rax
	mov	eax, DWORD PTR -12[rbp]
	mov	DWORD PTR [rdx], eax
.L1838:
	add	DWORD PTR -4[rbp], 1
.L1836:
	mov	eax, DWORD PTR -4[rbp]
	cmp	eax, DWORD PTR -8[rbp]
	jle	.L1842
	nop
.L1839:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	DWORD PTR [rax], 0
	nop
	add	rsp, 16
	pop	rbp
	ret
.L1840:
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
.L1844:
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
.L1845:
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
.L1848:
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
.L1849:
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
.L1852:
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
.L1853:
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
.L1856:
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
.L1857:
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
.L1859:
	mov	rax, QWORD PTR 16[rbp]
	mov	eax, DWORD PTR 72[rax]
	mov	DWORD PTR -4[rbp], eax
	nop
.L1860:
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
.L1863:
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
.L1864:
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
.L1867:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	sete	al
	mov	BYTE PTR -1[rbp], al
	nop
.L1868:
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
.L1871:
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIPvE8CAPACITYEv
	mov	DWORD PTR -8[rbp], eax
	mov	eax, DWORD PTR 24[rbp]
	cmp	eax, DWORD PTR -8[rbp]
	jle	.L1884
	nop
.L1873:
.L1875:
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIPvE8CAPACITYEv
	mov	DWORD PTR -12[rbp], eax
	mov	eax, DWORD PTR -12[rbp]
	mov	DWORD PTR -4[rbp], eax
	cmp	DWORD PTR -4[rbp], 7
	jg	.L1885
	mov	DWORD PTR -4[rbp], 8
	jmp	.L1882
.L1877:
.L1878:
.L1885:
	nop
.L1879:
.L1882:
	mov	eax, DWORD PTR -4[rbp]
	cmp	eax, DWORD PTR 24[rbp]
	jge	.L1886
	mov	eax, DWORD PTR -4[rbp]
	cdqe
	add	rax, rax
	mov	DWORD PTR -4[rbp], eax
	jmp	.L1882
.L1886:
	nop
.L1881:
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
	jmp	.L1887
.L1884:
	nop
.L1874:
.L1887:
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
.L1889:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	jne	.L1898
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayErase
	jmp	.L1892
.L1891:
.L1898:
	nop
.L1893:
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIPvE8CAPACITYEv
	mov	DWORD PTR -4[rbp], eax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR -4[rbp], eax
	je	.L1899
	nop
.L1895:
.L1896:
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
	jmp	.L1900
.L1899:
	nop
.L1892:
.L1900:
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
.L1902:
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 24[rbp]
	movsx	rdx, edx
	sal	rdx, 3
	add	rax, rdx
	mov	QWORD PTR -8[rbp], rax
	nop
.L1903:
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
.L1906:
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 24[rbp]
	movsx	rdx, edx
	sal	rdx, 3
	add	rax, rdx
	mov	QWORD PTR -8[rbp], rax
	nop
.L1907:
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
.L1910:
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
.L1911:
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
.L1913:
	mov	QWORD PTR -16[rbp], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	jne	.L1920
	mov	rax, QWORD PTR -16[rbp]
	mov	QWORD PTR -8[rbp], rax
	jmp	.L1916
.L1915:
.L1920:
	nop
.L1917:
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
.L1916:
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
.L1922:
	cmp	DWORD PTR 24[rbp], 0
	js	.L1936
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR 24[rbp], eax
	setg	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -8[rbp], rax
	jmp	.L1925
.L1936:
	nop
.L1924:
	mov	QWORD PTR -8[rbp], -1
.L1925:
	cmp	QWORD PTR -8[rbp], 0
	jne	.L1937
	nop
.L1927:
.L1929:
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
	jmp	.L1930
.L1938:
	nop
.L1931:
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
.L1932:
	sub	DWORD PTR -12[rbp], 1
.L1930:
	mov	eax, DWORD PTR -12[rbp]
	cmp	eax, DWORD PTR -28[rbp]
	jge	.L1938
	nop
.L1933:
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
	jmp	.L1939
.L1937:
	nop
.L1928:
.L1939:
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
.L1941:
	cmp	DWORD PTR 24[rbp], 0
	js	.L1955
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR 24[rbp], eax
	setge	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -8[rbp], rax
	jmp	.L1944
.L1955:
	nop
.L1943:
	mov	QWORD PTR -8[rbp], -1
.L1944:
	cmp	QWORD PTR -8[rbp], 0
	jne	.L1956
	nop
.L1946:
.L1948:
	mov	eax, DWORD PTR 24[rbp]
	mov	DWORD PTR -12[rbp], eax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	sub	eax, 2
	mov	DWORD PTR -16[rbp], eax
	jmp	.L1949
.L1957:
	nop
.L1950:
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
.L1951:
	add	DWORD PTR -12[rbp], 1
.L1949:
	mov	eax, DWORD PTR -12[rbp]
	cmp	eax, DWORD PTR -16[rbp]
	jle	.L1957
	nop
.L1952:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	sub	edx, 1
	mov	DWORD PTR [rax], edx
	jmp	.L1958
.L1956:
	nop
.L1947:
.L1958:
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
.L1960:
	cmp	DWORD PTR 24[rbp], 0
	js	.L1972
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR 24[rbp], eax
	setge	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -8[rbp], rax
	jmp	.L1963
.L1972:
	nop
.L1962:
	mov	QWORD PTR -8[rbp], -1
.L1963:
	cmp	QWORD PTR -8[rbp], 0
	jne	.L1973
	nop
.L1965:
.L1967:
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
	je	.L1974
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
	jmp	.L1975
.L1966:
.L1969:
.L1973:
	nop
	jmp	.L1975
.L1974:
	nop
.L1970:
.L1975:
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
.L1977:
	mov	QWORD PTR -16[rbp], 0
	mov	DWORD PTR -4[rbp], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	sub	eax, 1
	mov	DWORD PTR -8[rbp], eax
	jmp	.L1978
.L1984:
	nop
.L1979:
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR -4[rbp]
	movsx	rdx, edx
	sal	rdx, 3
	add	rdx, rax
	mov	rax, QWORD PTR -16[rbp]
	mov	QWORD PTR [rdx], rax
.L1980:
	add	DWORD PTR -4[rbp], 1
.L1978:
	mov	eax, DWORD PTR -4[rbp]
	cmp	eax, DWORD PTR -8[rbp]
	jle	.L1984
	nop
.L1981:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	DWORD PTR [rax], 0
	nop
	add	rsp, 16
	pop	rbp
	ret
.L1982:
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
.L1986:
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
.L1987:
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
.L1990:
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
.L1991:
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
.L1994:
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
.L1995:
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
.L1998:
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
.L1999:
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
.L2001:
	mov	rax, QWORD PTR 16[rbp]
	mov	eax, DWORD PTR 72[rax]
	mov	DWORD PTR -4[rbp], eax
	nop
.L2002:
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
.L2005:
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
.L2006:
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
.L2009:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	sete	al
	mov	BYTE PTR -1[rbp], al
	nop
.L2010:
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
.L2013:
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIN3TKO11INTERNENTRYEE8CAPACITYEv
	mov	DWORD PTR -8[rbp], eax
	mov	eax, DWORD PTR 24[rbp]
	cmp	eax, DWORD PTR -8[rbp]
	jle	.L2026
	nop
.L2015:
.L2017:
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIN3TKO11INTERNENTRYEE8CAPACITYEv
	mov	DWORD PTR -12[rbp], eax
	mov	eax, DWORD PTR -12[rbp]
	mov	DWORD PTR -4[rbp], eax
	cmp	DWORD PTR -4[rbp], 7
	jg	.L2027
	mov	DWORD PTR -4[rbp], 8
	jmp	.L2024
.L2019:
.L2020:
.L2027:
	nop
.L2021:
.L2024:
	mov	eax, DWORD PTR -4[rbp]
	cmp	eax, DWORD PTR 24[rbp]
	jge	.L2028
	mov	eax, DWORD PTR -4[rbp]
	cdqe
	add	rax, rax
	mov	DWORD PTR -4[rbp], eax
	jmp	.L2024
.L2028:
	nop
.L2023:
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
	jmp	.L2029
.L2026:
	nop
.L2016:
.L2029:
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
.L2031:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	jne	.L2040
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayErase
	jmp	.L2034
.L2033:
.L2040:
	nop
.L2035:
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIN3TKO11INTERNENTRYEE8CAPACITYEv
	mov	DWORD PTR -4[rbp], eax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR -4[rbp], eax
	je	.L2041
	nop
.L2037:
.L2038:
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
	jmp	.L2042
.L2041:
	nop
.L2034:
.L2042:
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
.L2044:
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
.L2045:
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
.L2048:
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
.L2049:
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
.L2052:
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
.L2053:
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
.L2055:
	lea	rax, -64[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	rax, QWORD PTR 24[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	jne	.L2062
	mov	rax, QWORD PTR -64[rbp]
	mov	rdx, QWORD PTR -56[rbp]
	mov	QWORD PTR -32[rbp], rax
	mov	QWORD PTR -24[rbp], rdx
	mov	rax, QWORD PTR -48[rbp]
	mov	QWORD PTR -16[rbp], rax
	jmp	.L2058
.L2057:
.L2062:
	nop
.L2059:
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
.L2058:
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
.L2064:
	cmp	DWORD PTR 24[rbp], 0
	js	.L2078
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR 24[rbp], eax
	setg	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -8[rbp], rax
	jmp	.L2067
.L2078:
	nop
.L2066:
	mov	QWORD PTR -8[rbp], -1
.L2067:
	cmp	QWORD PTR -8[rbp], 0
	jne	.L2079
	nop
.L2069:
.L2071:
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
	jmp	.L2072
.L2080:
	nop
.L2073:
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
.L2074:
	sub	DWORD PTR -12[rbp], 1
.L2072:
	mov	eax, DWORD PTR -12[rbp]
	cmp	eax, DWORD PTR -16[rbp]
	jge	.L2080
	nop
.L2075:
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
	jmp	.L2081
.L2079:
	nop
.L2070:
.L2081:
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
.L2083:
	cmp	DWORD PTR 24[rbp], 0
	js	.L2097
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR 24[rbp], eax
	setge	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -8[rbp], rax
	jmp	.L2086
.L2097:
	nop
.L2085:
	mov	QWORD PTR -8[rbp], -1
.L2086:
	cmp	QWORD PTR -8[rbp], 0
	jne	.L2098
	nop
.L2088:
.L2090:
	mov	eax, DWORD PTR 24[rbp]
	mov	DWORD PTR -12[rbp], eax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	sub	eax, 2
	mov	DWORD PTR -16[rbp], eax
	jmp	.L2091
.L2099:
	nop
.L2092:
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
.L2093:
	add	DWORD PTR -12[rbp], 1
.L2091:
	mov	eax, DWORD PTR -12[rbp]
	cmp	eax, DWORD PTR -16[rbp]
	jle	.L2099
	nop
.L2094:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	sub	edx, 1
	mov	DWORD PTR [rax], edx
	jmp	.L2100
.L2098:
	nop
.L2089:
.L2100:
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
.L2102:
	cmp	DWORD PTR 24[rbp], 0
	js	.L2114
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR 24[rbp], eax
	setge	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -8[rbp], rax
	jmp	.L2105
.L2114:
	nop
.L2104:
	mov	QWORD PTR -8[rbp], -1
.L2105:
	cmp	QWORD PTR -8[rbp], 0
	jne	.L2115
	nop
.L2107:
.L2109:
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
	je	.L2116
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
	jmp	.L2117
.L2108:
.L2111:
.L2115:
	nop
	jmp	.L2117
.L2116:
	nop
.L2112:
.L2117:
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
.L2119:
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
	jmp	.L2120
.L2126:
	nop
.L2121:
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
.L2122:
	add	DWORD PTR -4[rbp], 1
.L2120:
	mov	eax, DWORD PTR -4[rbp]
	cmp	eax, DWORD PTR -8[rbp]
	jle	.L2126
	nop
.L2123:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	DWORD PTR [rax], 0
	nop
	add	rsp, 32
	pop	rbp
	ret
.L2124:
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
.L2128:
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
.L2129:
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
	.def	_ZN13ArrayIteratorIN3TKO8TYPEINFOEE7ISVALIDEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN13ArrayIteratorIN3TKO8TYPEINFOEE7ISVALIDEv
_ZN13ArrayIteratorIN3TKO8TYPEINFOEE7ISVALIDEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	BYTE PTR -9[rbp], 0
.L2132:
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
.L2133:
	movzx	eax, BYTE PTR -9[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN13ArrayIteratorIN3TKO8TYPEINFOEE5VALUEEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN13ArrayIteratorIN3TKO8TYPEINFOEE5VALUEEv
_ZN13ArrayIteratorIN3TKO8TYPEINFOEE5VALUEEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR -16[rbp], 0
.L2136:
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
	add	rax, rax
	add	rax, rdx
	sal	rax, 2
	add	rax, rcx
	mov	QWORD PTR -16[rbp], rax
	nop
.L2137:
	mov	rax, QWORD PTR -16[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN13ArrayIteratorIN3TKO8TYPEINFOEE8MOVENEXTEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN13ArrayIteratorIN3TKO8TYPEINFOEE8MOVENEXTEv
_ZN13ArrayIteratorIN3TKO8TYPEINFOEE8MOVENEXTEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
.L2140:
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
.L2141:
	.seh_endproc
	.def	_ZN5ArrayIN3TKO8TYPEINFOEE5COUNTEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO8TYPEINFOEE5COUNTEv
_ZN5ArrayIN3TKO8TYPEINFOEE5COUNTEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR -4[rbp], 0
.L2143:
	mov	rax, QWORD PTR 16[rbp]
	mov	eax, DWORD PTR 72[rax]
	mov	DWORD PTR -4[rbp], eax
	nop
.L2144:
	mov	eax, DWORD PTR -4[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO8TYPEINFOEE8CAPACITYEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO8TYPEINFOEE8CAPACITYEv
_ZN5ArrayIN3TKO8TYPEINFOEE8CAPACITYEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 64
	.seh_stackalloc	64
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR -20[rbp], 0
.L2147:
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
.L2148:
	mov	eax, DWORD PTR -20[rbp]
	add	rsp, 64
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO8TYPEINFOEE7ISEMPTYEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO8TYPEINFOEE7ISEMPTYEv
_ZN5ArrayIN3TKO8TYPEINFOEE7ISEMPTYEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	BYTE PTR -1[rbp], 0
.L2151:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	sete	al
	mov	BYTE PTR -1[rbp], al
	nop
.L2152:
	movzx	eax, BYTE PTR -1[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO8TYPEINFOEE7RESERVEEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO8TYPEINFOEE7RESERVEEi
_ZN5ArrayIN3TKO8TYPEINFOEE7RESERVEEi:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 80
	.seh_stackalloc	80
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
.L2155:
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIN3TKO8TYPEINFOEE8CAPACITYEv
	mov	DWORD PTR -8[rbp], eax
	mov	eax, DWORD PTR 24[rbp]
	cmp	eax, DWORD PTR -8[rbp]
	jle	.L2168
	nop
.L2157:
.L2159:
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIN3TKO8TYPEINFOEE8CAPACITYEv
	mov	DWORD PTR -12[rbp], eax
	mov	eax, DWORD PTR -12[rbp]
	mov	DWORD PTR -4[rbp], eax
	cmp	DWORD PTR -4[rbp], 7
	jg	.L2169
	mov	DWORD PTR -4[rbp], 8
	jmp	.L2166
.L2161:
.L2162:
.L2169:
	nop
.L2163:
.L2166:
	mov	eax, DWORD PTR -4[rbp]
	cmp	eax, DWORD PTR 24[rbp]
	jge	.L2170
	mov	eax, DWORD PTR -4[rbp]
	cdqe
	add	rax, rax
	mov	DWORD PTR -4[rbp], eax
	jmp	.L2166
.L2170:
	nop
.L2165:
	mov	eax, DWORD PTR -4[rbp]
	cdqe
	sub	rax, 1
	mov	QWORD PTR 48[rsp], rax
	mov	QWORD PTR 40[rsp], 0
	mov	QWORD PTR 32[rsp], 1
	mov	r9d, 0
	mov	r8d, -1
	mov	edx, 44
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayRedimPresvEx
	jmp	.L2171
.L2168:
	nop
.L2158:
.L2171:
	nop
	add	rsp, 80
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO8TYPEINFOEE6SHRINKEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO8TYPEINFOEE6SHRINKEv
_ZN5ArrayIN3TKO8TYPEINFOEE6SHRINKEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 80
	.seh_stackalloc	80
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
.L2173:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	jne	.L2182
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayErase
	jmp	.L2176
.L2175:
.L2182:
	nop
.L2177:
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIN3TKO8TYPEINFOEE8CAPACITYEv
	mov	DWORD PTR -4[rbp], eax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR -4[rbp], eax
	je	.L2183
	nop
.L2179:
.L2180:
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
	mov	edx, 44
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayRedimPresvEx
	jmp	.L2184
.L2183:
	nop
.L2176:
.L2184:
	nop
	add	rsp, 80
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO8TYPEINFOEEixEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO8TYPEINFOEEixEi
_ZN5ArrayIN3TKO8TYPEINFOEEixEi:
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
.L2186:
	mov	rax, QWORD PTR 16[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	eax, DWORD PTR 24[rbp]
	movsx	rdx, eax
	mov	rax, rdx
	sal	rax, 2
	add	rax, rdx
	add	rax, rax
	add	rax, rdx
	sal	rax, 2
	add	rax, rcx
	mov	QWORD PTR -8[rbp], rax
	nop
.L2187:
	mov	rax, QWORD PTR -8[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO8TYPEINFOEE2ATEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO8TYPEINFOEE2ATEi
_ZN5ArrayIN3TKO8TYPEINFOEE2ATEi:
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
.L2190:
	mov	rax, QWORD PTR 16[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	eax, DWORD PTR 24[rbp]
	movsx	rdx, eax
	mov	rax, rdx
	sal	rax, 2
	add	rax, rdx
	add	rax, rax
	add	rax, rdx
	sal	rax, 2
	add	rax, rcx
	mov	QWORD PTR -8[rbp], rax
	nop
.L2191:
	mov	rax, QWORD PTR -8[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO8TYPEINFOEE4PUSHERS1_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO8TYPEINFOEE4PUSHERS1_
_ZN5ArrayIN3TKO8TYPEINFOEE4PUSHERS1_:
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
.L2194:
	mov	rax, QWORD PTR -64[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	add	eax, 1
	mov	edx, eax
	mov	rcx, QWORD PTR -64[rbp]
	call	_ZN5ArrayIN3TKO8TYPEINFOEE7RESERVEEi
	mov	rax, QWORD PTR -64[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	rax, QWORD PTR -64[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	movsx	rdx, eax
	mov	rax, rdx
	sal	rax, 2
	add	rax, rdx
	add	rax, rax
	add	rax, rdx
	sal	rax, 2
	lea	rdx, [rcx+rax]
	mov	rax, QWORD PTR -56[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	rbx, QWORD PTR 8[rax]
	mov	QWORD PTR [rdx], rcx
	mov	QWORD PTR 8[rdx], rbx
	mov	rcx, QWORD PTR 16[rax]
	mov	rbx, QWORD PTR 24[rax]
	mov	QWORD PTR 16[rdx], rcx
	mov	QWORD PTR 24[rdx], rbx
	mov	rcx, QWORD PTR 32[rax]
	mov	QWORD PTR 32[rdx], rcx
	mov	eax, DWORD PTR 40[rax]
	mov	DWORD PTR 40[rdx], eax
	mov	rax, QWORD PTR -64[rbp]
	add	rax, 72
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR -64[rbp]
	add	rax, 72
	add	edx, 1
	mov	DWORD PTR [rax], edx
	nop
	add	rsp, 40
	pop	rbx
	pop	rbp
	ret
.L2195:
	.seh_endproc
	.def	_ZN5ArrayIN3TKO8TYPEINFOEE3POPEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO8TYPEINFOEE3POPEv
_ZN5ArrayIN3TKO8TYPEINFOEE3POPEv:
	push	rbp
	.seh_pushreg	rbp
	push	rbx
	.seh_pushreg	rbx
	sub	rsp, 104
	.seh_stackalloc	104
	lea	rbp, 128[rsp]
	.seh_setframe	rbp, 128
	.seh_endprologue
	mov	QWORD PTR 0[rbp], rcx
	mov	QWORD PTR 8[rbp], rdx
	lea	rax, -80[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	QWORD PTR 24[rax], 0
	mov	QWORD PTR 32[rax], 0
	mov	DWORD PTR 40[rax], 0
.L2197:
	lea	rax, -128[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	QWORD PTR 24[rax], 0
	mov	QWORD PTR 32[rax], 0
	mov	DWORD PTR 40[rax], 0
	mov	rax, QWORD PTR 8[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	jne	.L2204
	mov	rax, QWORD PTR -128[rbp]
	mov	rdx, QWORD PTR -120[rbp]
	mov	QWORD PTR -80[rbp], rax
	mov	QWORD PTR -72[rbp], rdx
	mov	rax, QWORD PTR -112[rbp]
	mov	rdx, QWORD PTR -104[rbp]
	mov	QWORD PTR -64[rbp], rax
	mov	QWORD PTR -56[rbp], rdx
	mov	rax, QWORD PTR -96[rbp]
	mov	QWORD PTR -48[rbp], rax
	mov	eax, DWORD PTR -88[rbp]
	mov	DWORD PTR -40[rbp], eax
	jmp	.L2200
.L2199:
.L2204:
	nop
.L2201:
	mov	rax, QWORD PTR 8[rbp]
	add	rax, 72
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 8[rbp]
	add	rax, 72
	sub	edx, 1
	mov	DWORD PTR [rax], edx
	mov	rax, QWORD PTR 8[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	rax, QWORD PTR 8[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	movsx	rdx, eax
	mov	rax, rdx
	sal	rax, 2
	add	rax, rdx
	add	rax, rax
	add	rax, rdx
	sal	rax, 2
	lea	rdx, [rcx+rax]
	lea	rax, -128[rbp]
	mov	rcx, QWORD PTR [rdx]
	mov	rbx, QWORD PTR 8[rdx]
	mov	QWORD PTR [rax], rcx
	mov	QWORD PTR 8[rax], rbx
	mov	rcx, QWORD PTR 16[rdx]
	mov	rbx, QWORD PTR 24[rdx]
	mov	QWORD PTR 16[rax], rcx
	mov	QWORD PTR 24[rax], rbx
	mov	rcx, QWORD PTR 32[rdx]
	mov	QWORD PTR 32[rax], rcx
	mov	edx, DWORD PTR 40[rdx]
	mov	DWORD PTR 40[rax], edx
	mov	rax, QWORD PTR -128[rbp]
	mov	rdx, QWORD PTR -120[rbp]
	mov	QWORD PTR -80[rbp], rax
	mov	QWORD PTR -72[rbp], rdx
	mov	rax, QWORD PTR -112[rbp]
	mov	rdx, QWORD PTR -104[rbp]
	mov	QWORD PTR -64[rbp], rax
	mov	QWORD PTR -56[rbp], rdx
	mov	rax, QWORD PTR -96[rbp]
	mov	QWORD PTR -48[rbp], rax
	mov	eax, DWORD PTR -88[rbp]
	mov	DWORD PTR -40[rbp], eax
	nop
.L2200:
	mov	rax, QWORD PTR 0[rbp]
	mov	rcx, QWORD PTR -80[rbp]
	mov	rbx, QWORD PTR -72[rbp]
	mov	QWORD PTR [rax], rcx
	mov	QWORD PTR 8[rax], rbx
	mov	rcx, QWORD PTR -64[rbp]
	mov	rbx, QWORD PTR -56[rbp]
	mov	QWORD PTR 16[rax], rcx
	mov	QWORD PTR 24[rax], rbx
	mov	rdx, QWORD PTR -48[rbp]
	mov	QWORD PTR 32[rax], rdx
	mov	edx, DWORD PTR -40[rbp]
	mov	DWORD PTR 40[rax], edx
	mov	rax, QWORD PTR 0[rbp]
	add	rsp, 104
	pop	rbx
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO8TYPEINFOEE6INSERTEiRS1_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO8TYPEINFOEE6INSERTEiRS1_
_ZN5ArrayIN3TKO8TYPEINFOEE6INSERTEiRS1_:
	push	rbp
	.seh_pushreg	rbp
	push	rbx
	.seh_pushreg	rbx
	sub	rsp, 104
	.seh_stackalloc	104
	lea	rbp, 128[rsp]
	.seh_setframe	rbp, 128
	.seh_endprologue
	mov	QWORD PTR 0[rbp], rcx
	mov	DWORD PTR 8[rbp], edx
	mov	QWORD PTR 16[rbp], r8
.L2206:
	cmp	DWORD PTR 8[rbp], 0
	js	.L2220
	mov	rax, QWORD PTR 0[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR 8[rbp], eax
	setg	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -40[rbp], rax
	jmp	.L2209
.L2220:
	nop
.L2208:
	mov	QWORD PTR -40[rbp], -1
.L2209:
	cmp	QWORD PTR -40[rbp], 0
	jne	.L2221
	nop
.L2211:
.L2213:
	lea	rax, -96[rbp]
	mov	rdx, QWORD PTR 16[rbp]
	mov	rcx, QWORD PTR [rdx]
	mov	rbx, QWORD PTR 8[rdx]
	mov	QWORD PTR [rax], rcx
	mov	QWORD PTR 8[rax], rbx
	mov	rcx, QWORD PTR 16[rdx]
	mov	rbx, QWORD PTR 24[rdx]
	mov	QWORD PTR 16[rax], rcx
	mov	QWORD PTR 24[rax], rbx
	mov	rcx, QWORD PTR 32[rdx]
	mov	QWORD PTR 32[rax], rcx
	mov	edx, DWORD PTR 40[rdx]
	mov	DWORD PTR 40[rax], edx
	mov	rax, QWORD PTR 0[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	add	eax, 1
	mov	edx, eax
	mov	rcx, QWORD PTR 0[rbp]
	call	_ZN5ArrayIN3TKO8TYPEINFOEE7RESERVEEi
	mov	rax, QWORD PTR 0[rbp]
	mov	eax, DWORD PTR 72[rax]
	mov	DWORD PTR -44[rbp], eax
	mov	eax, DWORD PTR 8[rbp]
	add	eax, 1
	mov	DWORD PTR -48[rbp], eax
	jmp	.L2214
.L2222:
	nop
.L2215:
	mov	rax, QWORD PTR 0[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	eax, DWORD PTR -44[rbp]
	movsx	rdx, eax
	mov	rax, rdx
	sal	rax, 2
	add	rax, rdx
	add	rax, rax
	add	rax, rdx
	sal	rax, 2
	sub	rax, 44
	lea	rdx, [rcx+rax]
	mov	rax, QWORD PTR 0[rbp]
	mov	r8, QWORD PTR [rax]
	mov	eax, DWORD PTR -44[rbp]
	movsx	rcx, eax
	mov	rax, rcx
	sal	rax, 2
	add	rax, rcx
	add	rax, rax
	add	rax, rcx
	sal	rax, 2
	add	rax, r8
	mov	rcx, QWORD PTR [rdx]
	mov	rbx, QWORD PTR 8[rdx]
	mov	QWORD PTR [rax], rcx
	mov	QWORD PTR 8[rax], rbx
	mov	rcx, QWORD PTR 16[rdx]
	mov	rbx, QWORD PTR 24[rdx]
	mov	QWORD PTR 16[rax], rcx
	mov	QWORD PTR 24[rax], rbx
	mov	rcx, QWORD PTR 32[rdx]
	mov	QWORD PTR 32[rax], rcx
	mov	edx, DWORD PTR 40[rdx]
	mov	DWORD PTR 40[rax], edx
.L2216:
	sub	DWORD PTR -44[rbp], 1
.L2214:
	mov	eax, DWORD PTR -44[rbp]
	cmp	eax, DWORD PTR -48[rbp]
	jge	.L2222
	nop
.L2217:
	mov	rax, QWORD PTR 0[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	eax, DWORD PTR 8[rbp]
	movsx	rdx, eax
	mov	rax, rdx
	sal	rax, 2
	add	rax, rdx
	add	rax, rax
	add	rax, rdx
	sal	rax, 2
	lea	rdx, [rcx+rax]
	lea	rax, -96[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	rbx, QWORD PTR 8[rax]
	mov	QWORD PTR [rdx], rcx
	mov	QWORD PTR 8[rdx], rbx
	mov	rcx, QWORD PTR 16[rax]
	mov	rbx, QWORD PTR 24[rax]
	mov	QWORD PTR 16[rdx], rcx
	mov	QWORD PTR 24[rdx], rbx
	mov	rcx, QWORD PTR 32[rax]
	mov	QWORD PTR 32[rdx], rcx
	mov	eax, DWORD PTR 40[rax]
	mov	DWORD PTR 40[rdx], eax
	mov	rax, QWORD PTR 0[rbp]
	add	rax, 72
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 0[rbp]
	add	rax, 72
	add	edx, 1
	mov	DWORD PTR [rax], edx
	jmp	.L2223
.L2221:
	nop
.L2212:
.L2223:
	nop
	add	rsp, 104
	pop	rbx
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO8TYPEINFOEE6REMOVEEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO8TYPEINFOEE6REMOVEEi
_ZN5ArrayIN3TKO8TYPEINFOEE6REMOVEEi:
	push	rbp
	.seh_pushreg	rbp
	push	rbx
	.seh_pushreg	rbx
	sub	rsp, 24
	.seh_stackalloc	24
	lea	rbp, 128[rsp]
	.seh_setframe	rbp, 128
	.seh_endprologue
	mov	QWORD PTR -80[rbp], rcx
	mov	DWORD PTR -72[rbp], edx
.L2225:
	cmp	DWORD PTR -72[rbp], 0
	js	.L2239
	mov	rax, QWORD PTR -80[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR -72[rbp], eax
	setge	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -120[rbp], rax
	jmp	.L2228
.L2239:
	nop
.L2227:
	mov	QWORD PTR -120[rbp], -1
.L2228:
	cmp	QWORD PTR -120[rbp], 0
	jne	.L2240
	nop
.L2230:
.L2232:
	mov	eax, DWORD PTR -72[rbp]
	mov	DWORD PTR -124[rbp], eax
	mov	rax, QWORD PTR -80[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	sub	eax, 2
	mov	DWORD PTR -128[rbp], eax
	jmp	.L2233
.L2241:
	nop
.L2234:
	mov	rax, QWORD PTR -80[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	eax, DWORD PTR -124[rbp]
	movsx	rdx, eax
	mov	rax, rdx
	sal	rax, 2
	add	rax, rdx
	add	rax, rax
	add	rax, rdx
	sal	rax, 2
	add	rax, 44
	lea	rdx, [rcx+rax]
	mov	rax, QWORD PTR -80[rbp]
	mov	r8, QWORD PTR [rax]
	mov	eax, DWORD PTR -124[rbp]
	movsx	rcx, eax
	mov	rax, rcx
	sal	rax, 2
	add	rax, rcx
	add	rax, rax
	add	rax, rcx
	sal	rax, 2
	add	rax, r8
	mov	rcx, QWORD PTR [rdx]
	mov	rbx, QWORD PTR 8[rdx]
	mov	QWORD PTR [rax], rcx
	mov	QWORD PTR 8[rax], rbx
	mov	rcx, QWORD PTR 16[rdx]
	mov	rbx, QWORD PTR 24[rdx]
	mov	QWORD PTR 16[rax], rcx
	mov	QWORD PTR 24[rax], rbx
	mov	rcx, QWORD PTR 32[rdx]
	mov	QWORD PTR 32[rax], rcx
	mov	edx, DWORD PTR 40[rdx]
	mov	DWORD PTR 40[rax], edx
.L2235:
	add	DWORD PTR -124[rbp], 1
.L2233:
	mov	eax, DWORD PTR -124[rbp]
	cmp	eax, DWORD PTR -128[rbp]
	jle	.L2241
	nop
.L2236:
	mov	rax, QWORD PTR -80[rbp]
	add	rax, 72
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR -80[rbp]
	add	rax, 72
	sub	edx, 1
	mov	DWORD PTR [rax], edx
	jmp	.L2242
.L2240:
	nop
.L2231:
.L2242:
	nop
	add	rsp, 24
	pop	rbx
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO8TYPEINFOEE10REMOVESWAPEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO8TYPEINFOEE10REMOVESWAPEi
_ZN5ArrayIN3TKO8TYPEINFOEE10REMOVESWAPEi:
	push	rbp
	.seh_pushreg	rbp
	push	rbx
	.seh_pushreg	rbx
	sub	rsp, 24
	.seh_stackalloc	24
	lea	rbp, 128[rsp]
	.seh_setframe	rbp, 128
	.seh_endprologue
	mov	QWORD PTR -80[rbp], rcx
	mov	DWORD PTR -72[rbp], edx
.L2244:
	cmp	DWORD PTR -72[rbp], 0
	js	.L2256
	mov	rax, QWORD PTR -80[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR -72[rbp], eax
	setge	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -120[rbp], rax
	jmp	.L2247
.L2256:
	nop
.L2246:
	mov	QWORD PTR -120[rbp], -1
.L2247:
	cmp	QWORD PTR -120[rbp], 0
	jne	.L2257
	nop
.L2249:
.L2251:
	mov	rax, QWORD PTR -80[rbp]
	add	rax, 72
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR -80[rbp]
	add	rax, 72
	sub	edx, 1
	mov	DWORD PTR [rax], edx
	mov	rax, QWORD PTR -80[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR -72[rbp], eax
	je	.L2258
	mov	rax, QWORD PTR -80[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	rax, QWORD PTR -80[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	movsx	rdx, eax
	mov	rax, rdx
	sal	rax, 2
	add	rax, rdx
	add	rax, rax
	add	rax, rdx
	sal	rax, 2
	lea	rdx, [rcx+rax]
	mov	rax, QWORD PTR -80[rbp]
	mov	r8, QWORD PTR [rax]
	mov	eax, DWORD PTR -72[rbp]
	movsx	rcx, eax
	mov	rax, rcx
	sal	rax, 2
	add	rax, rcx
	add	rax, rax
	add	rax, rcx
	sal	rax, 2
	add	rax, r8
	mov	rcx, QWORD PTR [rdx]
	mov	rbx, QWORD PTR 8[rdx]
	mov	QWORD PTR [rax], rcx
	mov	QWORD PTR 8[rax], rbx
	mov	rcx, QWORD PTR 16[rdx]
	mov	rbx, QWORD PTR 24[rdx]
	mov	QWORD PTR 16[rax], rcx
	mov	QWORD PTR 24[rax], rbx
	mov	rcx, QWORD PTR 32[rdx]
	mov	QWORD PTR 32[rax], rcx
	mov	edx, DWORD PTR 40[rdx]
	mov	DWORD PTR 40[rax], edx
	jmp	.L2259
.L2250:
.L2253:
.L2257:
	nop
	jmp	.L2259
.L2258:
	nop
.L2254:
.L2259:
	nop
	add	rsp, 24
	pop	rbx
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO8TYPEINFOEE5CLEAREv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO8TYPEINFOEE5CLEAREv
_ZN5ArrayIN3TKO8TYPEINFOEE5CLEAREv:
	push	rbp
	.seh_pushreg	rbp
	push	rbx
	.seh_pushreg	rbx
	sub	rsp, 72
	.seh_stackalloc	72
	lea	rbp, 128[rsp]
	.seh_setframe	rbp, 128
	.seh_endprologue
	mov	QWORD PTR -32[rbp], rcx
.L2261:
	lea	rax, -128[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	QWORD PTR 24[rax], 0
	mov	QWORD PTR 32[rax], 0
	mov	DWORD PTR 40[rax], 0
	mov	DWORD PTR -68[rbp], 0
	mov	rax, QWORD PTR -32[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	sub	eax, 1
	mov	DWORD PTR -72[rbp], eax
	jmp	.L2262
.L2268:
	nop
.L2263:
	mov	rax, QWORD PTR -32[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	eax, DWORD PTR -68[rbp]
	movsx	rdx, eax
	mov	rax, rdx
	sal	rax, 2
	add	rax, rdx
	add	rax, rax
	add	rax, rdx
	sal	rax, 2
	lea	rdx, [rcx+rax]
	lea	rax, -128[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	rbx, QWORD PTR 8[rax]
	mov	QWORD PTR [rdx], rcx
	mov	QWORD PTR 8[rdx], rbx
	mov	rcx, QWORD PTR 16[rax]
	mov	rbx, QWORD PTR 24[rax]
	mov	QWORD PTR 16[rdx], rcx
	mov	QWORD PTR 24[rdx], rbx
	mov	rcx, QWORD PTR 32[rax]
	mov	QWORD PTR 32[rdx], rcx
	mov	eax, DWORD PTR 40[rax]
	mov	DWORD PTR 40[rdx], eax
.L2264:
	add	DWORD PTR -68[rbp], 1
.L2262:
	mov	eax, DWORD PTR -68[rbp]
	cmp	eax, DWORD PTR -72[rbp]
	jle	.L2268
	nop
.L2265:
	mov	rax, QWORD PTR -32[rbp]
	add	rax, 72
	mov	DWORD PTR [rax], 0
	nop
	add	rsp, 72
	pop	rbx
	pop	rbp
	ret
.L2266:
	.seh_endproc
	.def	_ZN5ArrayIN3TKO8TYPEINFOEE11GETITERATOREv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO8TYPEINFOEE11GETITERATOREv
_ZN5ArrayIN3TKO8TYPEINFOEE11GETITERATOREv:
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
.L2270:
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
.L2271:
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
	.def	_ZN13ArrayIteratorIxE7ISVALIDEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN13ArrayIteratorIxE7ISVALIDEv
_ZN13ArrayIteratorIxE7ISVALIDEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	BYTE PTR -9[rbp], 0
.L2274:
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
.L2275:
	movzx	eax, BYTE PTR -9[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN13ArrayIteratorIxE5VALUEEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN13ArrayIteratorIxE5VALUEEv
_ZN13ArrayIteratorIxE5VALUEEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR -16[rbp], 0
.L2278:
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
.L2279:
	mov	rax, QWORD PTR -16[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN13ArrayIteratorIxE8MOVENEXTEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN13ArrayIteratorIxE8MOVENEXTEv
_ZN13ArrayIteratorIxE8MOVENEXTEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
.L2282:
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
.L2283:
	.seh_endproc
	.def	_ZN5ArrayIxE5COUNTEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIxE5COUNTEv
_ZN5ArrayIxE5COUNTEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR -4[rbp], 0
.L2285:
	mov	rax, QWORD PTR 16[rbp]
	mov	eax, DWORD PTR 72[rax]
	mov	DWORD PTR -4[rbp], eax
	nop
.L2286:
	mov	eax, DWORD PTR -4[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIxE8CAPACITYEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIxE8CAPACITYEv
_ZN5ArrayIxE8CAPACITYEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 64
	.seh_stackalloc	64
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR -20[rbp], 0
.L2289:
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
.L2290:
	mov	eax, DWORD PTR -20[rbp]
	add	rsp, 64
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIxE7ISEMPTYEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIxE7ISEMPTYEv
_ZN5ArrayIxE7ISEMPTYEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	BYTE PTR -1[rbp], 0
.L2293:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	sete	al
	mov	BYTE PTR -1[rbp], al
	nop
.L2294:
	movzx	eax, BYTE PTR -1[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIxE7RESERVEEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIxE7RESERVEEi
_ZN5ArrayIxE7RESERVEEi:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 80
	.seh_stackalloc	80
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
.L2297:
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIxE8CAPACITYEv
	mov	DWORD PTR -8[rbp], eax
	mov	eax, DWORD PTR 24[rbp]
	cmp	eax, DWORD PTR -8[rbp]
	jle	.L2310
	nop
.L2299:
.L2301:
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIxE8CAPACITYEv
	mov	DWORD PTR -12[rbp], eax
	mov	eax, DWORD PTR -12[rbp]
	mov	DWORD PTR -4[rbp], eax
	cmp	DWORD PTR -4[rbp], 7
	jg	.L2311
	mov	DWORD PTR -4[rbp], 8
	jmp	.L2308
.L2303:
.L2304:
.L2311:
	nop
.L2305:
.L2308:
	mov	eax, DWORD PTR -4[rbp]
	cmp	eax, DWORD PTR 24[rbp]
	jge	.L2312
	mov	eax, DWORD PTR -4[rbp]
	cdqe
	add	rax, rax
	mov	DWORD PTR -4[rbp], eax
	jmp	.L2308
.L2312:
	nop
.L2307:
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
	jmp	.L2313
.L2310:
	nop
.L2300:
.L2313:
	nop
	add	rsp, 80
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIxE6SHRINKEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIxE6SHRINKEv
_ZN5ArrayIxE6SHRINKEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 80
	.seh_stackalloc	80
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
.L2315:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	jne	.L2324
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayErase
	jmp	.L2318
.L2317:
.L2324:
	nop
.L2319:
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIxE8CAPACITYEv
	mov	DWORD PTR -4[rbp], eax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR -4[rbp], eax
	je	.L2325
	nop
.L2321:
.L2322:
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
	jmp	.L2326
.L2325:
	nop
.L2318:
.L2326:
	nop
	add	rsp, 80
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIxEixEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIxEixEi
_ZN5ArrayIxEixEi:
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
.L2328:
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 24[rbp]
	movsx	rdx, edx
	sal	rdx, 3
	add	rax, rdx
	mov	QWORD PTR -8[rbp], rax
	nop
.L2329:
	mov	rax, QWORD PTR -8[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIxE2ATEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIxE2ATEi
_ZN5ArrayIxE2ATEi:
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
.L2332:
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 24[rbp]
	movsx	rdx, edx
	sal	rdx, 3
	add	rax, rdx
	mov	QWORD PTR -8[rbp], rax
	nop
.L2333:
	mov	rax, QWORD PTR -8[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIxE4PUSHERx;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIxE4PUSHERx
_ZN5ArrayIxE4PUSHERx:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
.L2336:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	add	eax, 1
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIxE7RESERVEEi
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
.L2337:
	.seh_endproc
	.def	_ZN5ArrayIxE3POPEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIxE3POPEv
_ZN5ArrayIxE3POPEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR -8[rbp], 0
.L2339:
	mov	QWORD PTR -16[rbp], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	jne	.L2346
	mov	rax, QWORD PTR -16[rbp]
	mov	QWORD PTR -8[rbp], rax
	jmp	.L2342
.L2341:
.L2346:
	nop
.L2343:
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
.L2342:
	mov	rax, QWORD PTR -8[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIxE6INSERTEiRx;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIxE6INSERTEiRx
_ZN5ArrayIxE6INSERTEiRx:
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
.L2348:
	cmp	DWORD PTR 24[rbp], 0
	js	.L2362
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR 24[rbp], eax
	setg	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -8[rbp], rax
	jmp	.L2351
.L2362:
	nop
.L2350:
	mov	QWORD PTR -8[rbp], -1
.L2351:
	cmp	QWORD PTR -8[rbp], 0
	jne	.L2363
	nop
.L2353:
.L2355:
	mov	rax, QWORD PTR 32[rbp]
	mov	rax, QWORD PTR [rax]
	mov	QWORD PTR -24[rbp], rax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	add	eax, 1
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIxE7RESERVEEi
	mov	rax, QWORD PTR 16[rbp]
	mov	eax, DWORD PTR 72[rax]
	mov	DWORD PTR -12[rbp], eax
	mov	eax, DWORD PTR 24[rbp]
	add	eax, 1
	mov	DWORD PTR -28[rbp], eax
	jmp	.L2356
.L2364:
	nop
.L2357:
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
.L2358:
	sub	DWORD PTR -12[rbp], 1
.L2356:
	mov	eax, DWORD PTR -12[rbp]
	cmp	eax, DWORD PTR -28[rbp]
	jge	.L2364
	nop
.L2359:
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
	jmp	.L2365
.L2363:
	nop
.L2354:
.L2365:
	nop
	add	rsp, 64
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIxE6REMOVEEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIxE6REMOVEEi
_ZN5ArrayIxE6REMOVEEi:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
.L2367:
	cmp	DWORD PTR 24[rbp], 0
	js	.L2381
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR 24[rbp], eax
	setge	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -8[rbp], rax
	jmp	.L2370
.L2381:
	nop
.L2369:
	mov	QWORD PTR -8[rbp], -1
.L2370:
	cmp	QWORD PTR -8[rbp], 0
	jne	.L2382
	nop
.L2372:
.L2374:
	mov	eax, DWORD PTR 24[rbp]
	mov	DWORD PTR -12[rbp], eax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	sub	eax, 2
	mov	DWORD PTR -16[rbp], eax
	jmp	.L2375
.L2383:
	nop
.L2376:
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
.L2377:
	add	DWORD PTR -12[rbp], 1
.L2375:
	mov	eax, DWORD PTR -12[rbp]
	cmp	eax, DWORD PTR -16[rbp]
	jle	.L2383
	nop
.L2378:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	sub	edx, 1
	mov	DWORD PTR [rax], edx
	jmp	.L2384
.L2382:
	nop
.L2373:
.L2384:
	nop
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIxE10REMOVESWAPEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIxE10REMOVESWAPEi
_ZN5ArrayIxE10REMOVESWAPEi:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
.L2386:
	cmp	DWORD PTR 24[rbp], 0
	js	.L2398
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR 24[rbp], eax
	setge	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -8[rbp], rax
	jmp	.L2389
.L2398:
	nop
.L2388:
	mov	QWORD PTR -8[rbp], -1
.L2389:
	cmp	QWORD PTR -8[rbp], 0
	jne	.L2399
	nop
.L2391:
.L2393:
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
	je	.L2400
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
	jmp	.L2401
.L2392:
.L2395:
.L2399:
	nop
	jmp	.L2401
.L2400:
	nop
.L2396:
.L2401:
	nop
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIxE5CLEAREv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIxE5CLEAREv
_ZN5ArrayIxE5CLEAREv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
.L2403:
	mov	QWORD PTR -16[rbp], 0
	mov	DWORD PTR -4[rbp], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	sub	eax, 1
	mov	DWORD PTR -8[rbp], eax
	jmp	.L2404
.L2410:
	nop
.L2405:
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR -4[rbp]
	movsx	rdx, edx
	sal	rdx, 3
	add	rdx, rax
	mov	rax, QWORD PTR -16[rbp]
	mov	QWORD PTR [rdx], rax
.L2406:
	add	DWORD PTR -4[rbp], 1
.L2404:
	mov	eax, DWORD PTR -4[rbp]
	cmp	eax, DWORD PTR -8[rbp]
	jle	.L2410
	nop
.L2407:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	DWORD PTR [rax], 0
	nop
	add	rsp, 16
	pop	rbp
	ret
.L2408:
	.seh_endproc
	.def	_ZN5ArrayIxE11GETITERATOREv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIxE11GETITERATOREv
_ZN5ArrayIxE11GETITERATOREv:
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
.L2412:
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
.L2413:
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
	.def	_ZN13ArrayIteratorIN3TKO6SYMBOLEE7ISVALIDEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN13ArrayIteratorIN3TKO6SYMBOLEE7ISVALIDEv
_ZN13ArrayIteratorIN3TKO6SYMBOLEE7ISVALIDEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	BYTE PTR -9[rbp], 0
.L2416:
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
.L2417:
	movzx	eax, BYTE PTR -9[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN13ArrayIteratorIN3TKO6SYMBOLEE5VALUEEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN13ArrayIteratorIN3TKO6SYMBOLEE5VALUEEv
_ZN13ArrayIteratorIN3TKO6SYMBOLEE5VALUEEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR -16[rbp], 0
.L2420:
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	QWORD PTR -8[rbp], rax
	mov	rax, QWORD PTR -8[rbp]
	mov	rax, QWORD PTR [rax]
	mov	rdx, QWORD PTR 16[rbp]
	add	rdx, 8
	mov	edx, DWORD PTR [rdx]
	movsx	rdx, edx
	sal	rdx, 6
	add	rax, rdx
	mov	QWORD PTR -16[rbp], rax
	nop
.L2421:
	mov	rax, QWORD PTR -16[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN13ArrayIteratorIN3TKO6SYMBOLEE8MOVENEXTEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN13ArrayIteratorIN3TKO6SYMBOLEE8MOVENEXTEv
_ZN13ArrayIteratorIN3TKO6SYMBOLEE8MOVENEXTEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
.L2424:
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
.L2425:
	.seh_endproc
	.def	_ZN5ArrayIN3TKO6SYMBOLEE5COUNTEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO6SYMBOLEE5COUNTEv
_ZN5ArrayIN3TKO6SYMBOLEE5COUNTEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR -4[rbp], 0
.L2427:
	mov	rax, QWORD PTR 16[rbp]
	mov	eax, DWORD PTR 72[rax]
	mov	DWORD PTR -4[rbp], eax
	nop
.L2428:
	mov	eax, DWORD PTR -4[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO6SYMBOLEE8CAPACITYEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO6SYMBOLEE8CAPACITYEv
_ZN5ArrayIN3TKO6SYMBOLEE8CAPACITYEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 64
	.seh_stackalloc	64
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR -20[rbp], 0
.L2431:
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
.L2432:
	mov	eax, DWORD PTR -20[rbp]
	add	rsp, 64
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO6SYMBOLEE7ISEMPTYEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO6SYMBOLEE7ISEMPTYEv
_ZN5ArrayIN3TKO6SYMBOLEE7ISEMPTYEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	BYTE PTR -1[rbp], 0
.L2435:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	sete	al
	mov	BYTE PTR -1[rbp], al
	nop
.L2436:
	movzx	eax, BYTE PTR -1[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO6SYMBOLEE7RESERVEEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO6SYMBOLEE7RESERVEEi
_ZN5ArrayIN3TKO6SYMBOLEE7RESERVEEi:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 80
	.seh_stackalloc	80
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
.L2439:
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIN3TKO6SYMBOLEE8CAPACITYEv
	mov	DWORD PTR -8[rbp], eax
	mov	eax, DWORD PTR 24[rbp]
	cmp	eax, DWORD PTR -8[rbp]
	jle	.L2452
	nop
.L2441:
.L2443:
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIN3TKO6SYMBOLEE8CAPACITYEv
	mov	DWORD PTR -12[rbp], eax
	mov	eax, DWORD PTR -12[rbp]
	mov	DWORD PTR -4[rbp], eax
	cmp	DWORD PTR -4[rbp], 7
	jg	.L2453
	mov	DWORD PTR -4[rbp], 8
	jmp	.L2450
.L2445:
.L2446:
.L2453:
	nop
.L2447:
.L2450:
	mov	eax, DWORD PTR -4[rbp]
	cmp	eax, DWORD PTR 24[rbp]
	jge	.L2454
	mov	eax, DWORD PTR -4[rbp]
	cdqe
	add	rax, rax
	mov	DWORD PTR -4[rbp], eax
	jmp	.L2450
.L2454:
	nop
.L2449:
	mov	eax, DWORD PTR -4[rbp]
	cdqe
	sub	rax, 1
	mov	QWORD PTR 48[rsp], rax
	mov	QWORD PTR 40[rsp], 0
	mov	QWORD PTR 32[rsp], 1
	mov	r9d, 0
	mov	r8d, -1
	mov	edx, 64
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayRedimPresvEx
	jmp	.L2455
.L2452:
	nop
.L2442:
.L2455:
	nop
	add	rsp, 80
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO6SYMBOLEE6SHRINKEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO6SYMBOLEE6SHRINKEv
_ZN5ArrayIN3TKO6SYMBOLEE6SHRINKEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 80
	.seh_stackalloc	80
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
.L2457:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	jne	.L2466
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayErase
	jmp	.L2460
.L2459:
.L2466:
	nop
.L2461:
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIN3TKO6SYMBOLEE8CAPACITYEv
	mov	DWORD PTR -4[rbp], eax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR -4[rbp], eax
	je	.L2467
	nop
.L2463:
.L2464:
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
	mov	edx, 64
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayRedimPresvEx
	jmp	.L2468
.L2467:
	nop
.L2460:
.L2468:
	nop
	add	rsp, 80
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO6SYMBOLEEixEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO6SYMBOLEEixEi
_ZN5ArrayIN3TKO6SYMBOLEEixEi:
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
.L2470:
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 24[rbp]
	movsx	rdx, edx
	sal	rdx, 6
	add	rax, rdx
	mov	QWORD PTR -8[rbp], rax
	nop
.L2471:
	mov	rax, QWORD PTR -8[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO6SYMBOLEE2ATEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO6SYMBOLEE2ATEi
_ZN5ArrayIN3TKO6SYMBOLEE2ATEi:
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
.L2474:
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 24[rbp]
	movsx	rdx, edx
	sal	rdx, 6
	add	rax, rdx
	mov	QWORD PTR -8[rbp], rax
	nop
.L2475:
	mov	rax, QWORD PTR -8[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO6SYMBOLEE4PUSHERS1_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO6SYMBOLEE4PUSHERS1_
_ZN5ArrayIN3TKO6SYMBOLEE4PUSHERS1_:
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
.L2478:
	mov	rax, QWORD PTR -64[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	add	eax, 1
	mov	edx, eax
	mov	rcx, QWORD PTR -64[rbp]
	call	_ZN5ArrayIN3TKO6SYMBOLEE7RESERVEEi
	mov	rax, QWORD PTR -64[rbp]
	mov	rax, QWORD PTR [rax]
	mov	rdx, QWORD PTR -64[rbp]
	add	rdx, 72
	mov	edx, DWORD PTR [rdx]
	movsx	rdx, edx
	sal	rdx, 6
	add	rdx, rax
	mov	rax, QWORD PTR -56[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	rbx, QWORD PTR 8[rax]
	mov	QWORD PTR [rdx], rcx
	mov	QWORD PTR 8[rdx], rbx
	mov	rcx, QWORD PTR 16[rax]
	mov	rbx, QWORD PTR 24[rax]
	mov	QWORD PTR 16[rdx], rcx
	mov	QWORD PTR 24[rdx], rbx
	mov	rcx, QWORD PTR 32[rax]
	mov	rbx, QWORD PTR 40[rax]
	mov	QWORD PTR 32[rdx], rcx
	mov	QWORD PTR 40[rdx], rbx
	mov	rcx, QWORD PTR 48[rax]
	mov	rbx, QWORD PTR 56[rax]
	mov	QWORD PTR 48[rdx], rcx
	mov	QWORD PTR 56[rdx], rbx
	mov	rax, QWORD PTR -64[rbp]
	add	rax, 72
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR -64[rbp]
	add	rax, 72
	add	edx, 1
	mov	DWORD PTR [rax], edx
	nop
	add	rsp, 40
	pop	rbx
	pop	rbp
	ret
.L2479:
	.seh_endproc
	.def	_ZN5ArrayIN3TKO6SYMBOLEE3POPEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO6SYMBOLEE3POPEv
_ZN5ArrayIN3TKO6SYMBOLEE3POPEv:
	push	rbp
	.seh_pushreg	rbp
	push	rbx
	.seh_pushreg	rbx
	sub	rsp, 136
	.seh_stackalloc	136
	lea	rbp, 128[rsp]
	.seh_setframe	rbp, 128
	.seh_endprologue
	mov	QWORD PTR 32[rbp], rcx
	mov	QWORD PTR 40[rbp], rdx
	lea	rax, -64[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	QWORD PTR 24[rax], 0
	mov	QWORD PTR 32[rax], 0
	mov	QWORD PTR 40[rax], 0
	mov	QWORD PTR 48[rax], 0
	mov	QWORD PTR 56[rax], 0
.L2481:
	lea	rax, -128[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	QWORD PTR 24[rax], 0
	mov	QWORD PTR 32[rax], 0
	mov	QWORD PTR 40[rax], 0
	mov	QWORD PTR 48[rax], 0
	mov	QWORD PTR 56[rax], 0
	mov	rax, QWORD PTR 40[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	jne	.L2488
	mov	rax, QWORD PTR -128[rbp]
	mov	rdx, QWORD PTR -120[rbp]
	mov	QWORD PTR -64[rbp], rax
	mov	QWORD PTR -56[rbp], rdx
	mov	rax, QWORD PTR -112[rbp]
	mov	rdx, QWORD PTR -104[rbp]
	mov	QWORD PTR -48[rbp], rax
	mov	QWORD PTR -40[rbp], rdx
	mov	rax, QWORD PTR -96[rbp]
	mov	rdx, QWORD PTR -88[rbp]
	mov	QWORD PTR -32[rbp], rax
	mov	QWORD PTR -24[rbp], rdx
	mov	rax, QWORD PTR -80[rbp]
	mov	rdx, QWORD PTR -72[rbp]
	mov	QWORD PTR -16[rbp], rax
	mov	QWORD PTR -8[rbp], rdx
	jmp	.L2484
.L2483:
.L2488:
	nop
.L2485:
	mov	rax, QWORD PTR 40[rbp]
	add	rax, 72
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 40[rbp]
	add	rax, 72
	sub	edx, 1
	mov	DWORD PTR [rax], edx
	mov	rax, QWORD PTR 40[rbp]
	mov	rax, QWORD PTR [rax]
	mov	rdx, QWORD PTR 40[rbp]
	add	rdx, 72
	mov	edx, DWORD PTR [rdx]
	movsx	rdx, edx
	sal	rdx, 6
	add	rdx, rax
	lea	rax, -128[rbp]
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
	mov	rcx, QWORD PTR 48[rdx]
	mov	rbx, QWORD PTR 56[rdx]
	mov	QWORD PTR 48[rax], rcx
	mov	QWORD PTR 56[rax], rbx
	mov	rax, QWORD PTR -128[rbp]
	mov	rdx, QWORD PTR -120[rbp]
	mov	QWORD PTR -64[rbp], rax
	mov	QWORD PTR -56[rbp], rdx
	mov	rax, QWORD PTR -112[rbp]
	mov	rdx, QWORD PTR -104[rbp]
	mov	QWORD PTR -48[rbp], rax
	mov	QWORD PTR -40[rbp], rdx
	mov	rax, QWORD PTR -96[rbp]
	mov	rdx, QWORD PTR -88[rbp]
	mov	QWORD PTR -32[rbp], rax
	mov	QWORD PTR -24[rbp], rdx
	mov	rax, QWORD PTR -80[rbp]
	mov	rdx, QWORD PTR -72[rbp]
	mov	QWORD PTR -16[rbp], rax
	mov	QWORD PTR -8[rbp], rdx
	nop
.L2484:
	mov	rax, QWORD PTR 32[rbp]
	mov	rcx, QWORD PTR -64[rbp]
	mov	rbx, QWORD PTR -56[rbp]
	mov	QWORD PTR [rax], rcx
	mov	QWORD PTR 8[rax], rbx
	mov	rcx, QWORD PTR -48[rbp]
	mov	rbx, QWORD PTR -40[rbp]
	mov	QWORD PTR 16[rax], rcx
	mov	QWORD PTR 24[rax], rbx
	mov	rcx, QWORD PTR -32[rbp]
	mov	rbx, QWORD PTR -24[rbp]
	mov	QWORD PTR 32[rax], rcx
	mov	QWORD PTR 40[rax], rbx
	mov	rcx, QWORD PTR -16[rbp]
	mov	rbx, QWORD PTR -8[rbp]
	mov	QWORD PTR 48[rax], rcx
	mov	QWORD PTR 56[rax], rbx
	mov	rax, QWORD PTR 32[rbp]
	add	rsp, 136
	pop	rbx
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO6SYMBOLEE6INSERTEiRS1_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO6SYMBOLEE6INSERTEiRS1_
_ZN5ArrayIN3TKO6SYMBOLEE6INSERTEiRS1_:
	push	rbp
	.seh_pushreg	rbp
	push	rbx
	.seh_pushreg	rbx
	sub	rsp, 120
	.seh_stackalloc	120
	lea	rbp, 128[rsp]
	.seh_setframe	rbp, 128
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
	mov	QWORD PTR 32[rbp], r8
.L2490:
	cmp	DWORD PTR 24[rbp], 0
	js	.L2504
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR 24[rbp], eax
	setg	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -24[rbp], rax
	jmp	.L2493
.L2504:
	nop
.L2492:
	mov	QWORD PTR -24[rbp], -1
.L2493:
	cmp	QWORD PTR -24[rbp], 0
	jne	.L2505
	nop
.L2495:
.L2497:
	lea	rax, -96[rbp]
	mov	rdx, QWORD PTR 32[rbp]
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
	mov	rcx, QWORD PTR 48[rdx]
	mov	rbx, QWORD PTR 56[rdx]
	mov	QWORD PTR 48[rax], rcx
	mov	QWORD PTR 56[rax], rbx
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	add	eax, 1
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIN3TKO6SYMBOLEE7RESERVEEi
	mov	rax, QWORD PTR 16[rbp]
	mov	eax, DWORD PTR 72[rax]
	mov	DWORD PTR -28[rbp], eax
	mov	eax, DWORD PTR 24[rbp]
	add	eax, 1
	mov	DWORD PTR -32[rbp], eax
	jmp	.L2498
.L2506:
	nop
.L2499:
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR -28[rbp]
	movsx	rdx, edx
	sal	rdx, 6
	sub	rdx, 64
	add	rdx, rax
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	ecx, DWORD PTR -28[rbp]
	movsx	rcx, ecx
	sal	rcx, 6
	add	rax, rcx
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
	mov	rcx, QWORD PTR 48[rdx]
	mov	rbx, QWORD PTR 56[rdx]
	mov	QWORD PTR 48[rax], rcx
	mov	QWORD PTR 56[rax], rbx
.L2500:
	sub	DWORD PTR -28[rbp], 1
.L2498:
	mov	eax, DWORD PTR -28[rbp]
	cmp	eax, DWORD PTR -32[rbp]
	jge	.L2506
	nop
.L2501:
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 24[rbp]
	movsx	rdx, edx
	sal	rdx, 6
	add	rdx, rax
	lea	rax, -96[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	rbx, QWORD PTR 8[rax]
	mov	QWORD PTR [rdx], rcx
	mov	QWORD PTR 8[rdx], rbx
	mov	rcx, QWORD PTR 16[rax]
	mov	rbx, QWORD PTR 24[rax]
	mov	QWORD PTR 16[rdx], rcx
	mov	QWORD PTR 24[rdx], rbx
	mov	rcx, QWORD PTR 32[rax]
	mov	rbx, QWORD PTR 40[rax]
	mov	QWORD PTR 32[rdx], rcx
	mov	QWORD PTR 40[rdx], rbx
	mov	rcx, QWORD PTR 48[rax]
	mov	rbx, QWORD PTR 56[rax]
	mov	QWORD PTR 48[rdx], rcx
	mov	QWORD PTR 56[rdx], rbx
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	add	edx, 1
	mov	DWORD PTR [rax], edx
	jmp	.L2507
.L2505:
	nop
.L2496:
.L2507:
	nop
	add	rsp, 120
	pop	rbx
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO6SYMBOLEE6REMOVEEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO6SYMBOLEE6REMOVEEi
_ZN5ArrayIN3TKO6SYMBOLEE6REMOVEEi:
	push	rbp
	.seh_pushreg	rbp
	push	rbx
	.seh_pushreg	rbx
	sub	rsp, 24
	.seh_stackalloc	24
	lea	rbp, 128[rsp]
	.seh_setframe	rbp, 128
	.seh_endprologue
	mov	QWORD PTR -80[rbp], rcx
	mov	DWORD PTR -72[rbp], edx
.L2509:
	cmp	DWORD PTR -72[rbp], 0
	js	.L2523
	mov	rax, QWORD PTR -80[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR -72[rbp], eax
	setge	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -120[rbp], rax
	jmp	.L2512
.L2523:
	nop
.L2511:
	mov	QWORD PTR -120[rbp], -1
.L2512:
	cmp	QWORD PTR -120[rbp], 0
	jne	.L2524
	nop
.L2514:
.L2516:
	mov	eax, DWORD PTR -72[rbp]
	mov	DWORD PTR -124[rbp], eax
	mov	rax, QWORD PTR -80[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	sub	eax, 2
	mov	DWORD PTR -128[rbp], eax
	jmp	.L2517
.L2525:
	nop
.L2518:
	mov	rax, QWORD PTR -80[rbp]
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR -124[rbp]
	movsx	rdx, edx
	sal	rdx, 6
	add	rdx, 64
	add	rdx, rax
	mov	rax, QWORD PTR -80[rbp]
	mov	rax, QWORD PTR [rax]
	mov	ecx, DWORD PTR -124[rbp]
	movsx	rcx, ecx
	sal	rcx, 6
	add	rax, rcx
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
	mov	rcx, QWORD PTR 48[rdx]
	mov	rbx, QWORD PTR 56[rdx]
	mov	QWORD PTR 48[rax], rcx
	mov	QWORD PTR 56[rax], rbx
.L2519:
	add	DWORD PTR -124[rbp], 1
.L2517:
	mov	eax, DWORD PTR -124[rbp]
	cmp	eax, DWORD PTR -128[rbp]
	jle	.L2525
	nop
.L2520:
	mov	rax, QWORD PTR -80[rbp]
	add	rax, 72
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR -80[rbp]
	add	rax, 72
	sub	edx, 1
	mov	DWORD PTR [rax], edx
	jmp	.L2526
.L2524:
	nop
.L2515:
.L2526:
	nop
	add	rsp, 24
	pop	rbx
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO6SYMBOLEE10REMOVESWAPEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO6SYMBOLEE10REMOVESWAPEi
_ZN5ArrayIN3TKO6SYMBOLEE10REMOVESWAPEi:
	push	rbp
	.seh_pushreg	rbp
	push	rbx
	.seh_pushreg	rbx
	sub	rsp, 24
	.seh_stackalloc	24
	lea	rbp, 128[rsp]
	.seh_setframe	rbp, 128
	.seh_endprologue
	mov	QWORD PTR -80[rbp], rcx
	mov	DWORD PTR -72[rbp], edx
.L2528:
	cmp	DWORD PTR -72[rbp], 0
	js	.L2540
	mov	rax, QWORD PTR -80[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR -72[rbp], eax
	setge	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -120[rbp], rax
	jmp	.L2531
.L2540:
	nop
.L2530:
	mov	QWORD PTR -120[rbp], -1
.L2531:
	cmp	QWORD PTR -120[rbp], 0
	jne	.L2541
	nop
.L2533:
.L2535:
	mov	rax, QWORD PTR -80[rbp]
	add	rax, 72
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR -80[rbp]
	add	rax, 72
	sub	edx, 1
	mov	DWORD PTR [rax], edx
	mov	rax, QWORD PTR -80[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR -72[rbp], eax
	je	.L2542
	mov	rax, QWORD PTR -80[rbp]
	mov	rax, QWORD PTR [rax]
	mov	rdx, QWORD PTR -80[rbp]
	add	rdx, 72
	mov	edx, DWORD PTR [rdx]
	movsx	rdx, edx
	sal	rdx, 6
	add	rdx, rax
	mov	rax, QWORD PTR -80[rbp]
	mov	rax, QWORD PTR [rax]
	mov	ecx, DWORD PTR -72[rbp]
	movsx	rcx, ecx
	sal	rcx, 6
	add	rax, rcx
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
	mov	rcx, QWORD PTR 48[rdx]
	mov	rbx, QWORD PTR 56[rdx]
	mov	QWORD PTR 48[rax], rcx
	mov	QWORD PTR 56[rax], rbx
	jmp	.L2543
.L2534:
.L2537:
.L2541:
	nop
	jmp	.L2543
.L2542:
	nop
.L2538:
.L2543:
	nop
	add	rsp, 24
	pop	rbx
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO6SYMBOLEE5CLEAREv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO6SYMBOLEE5CLEAREv
_ZN5ArrayIN3TKO6SYMBOLEE5CLEAREv:
	push	rbp
	.seh_pushreg	rbp
	push	rbx
	.seh_pushreg	rbx
	sub	rsp, 88
	.seh_stackalloc	88
	lea	rbp, 128[rsp]
	.seh_setframe	rbp, 128
	.seh_endprologue
	mov	QWORD PTR -16[rbp], rcx
.L2545:
	lea	rax, -128[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	QWORD PTR 24[rax], 0
	mov	QWORD PTR 32[rax], 0
	mov	QWORD PTR 40[rax], 0
	mov	QWORD PTR 48[rax], 0
	mov	QWORD PTR 56[rax], 0
	mov	DWORD PTR -52[rbp], 0
	mov	rax, QWORD PTR -16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	sub	eax, 1
	mov	DWORD PTR -56[rbp], eax
	jmp	.L2546
.L2552:
	nop
.L2547:
	mov	rax, QWORD PTR -16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR -52[rbp]
	movsx	rdx, edx
	sal	rdx, 6
	add	rdx, rax
	lea	rax, -128[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	rbx, QWORD PTR 8[rax]
	mov	QWORD PTR [rdx], rcx
	mov	QWORD PTR 8[rdx], rbx
	mov	rcx, QWORD PTR 16[rax]
	mov	rbx, QWORD PTR 24[rax]
	mov	QWORD PTR 16[rdx], rcx
	mov	QWORD PTR 24[rdx], rbx
	mov	rcx, QWORD PTR 32[rax]
	mov	rbx, QWORD PTR 40[rax]
	mov	QWORD PTR 32[rdx], rcx
	mov	QWORD PTR 40[rdx], rbx
	mov	rcx, QWORD PTR 48[rax]
	mov	rbx, QWORD PTR 56[rax]
	mov	QWORD PTR 48[rdx], rcx
	mov	QWORD PTR 56[rdx], rbx
.L2548:
	add	DWORD PTR -52[rbp], 1
.L2546:
	mov	eax, DWORD PTR -52[rbp]
	cmp	eax, DWORD PTR -56[rbp]
	jle	.L2552
	nop
.L2549:
	mov	rax, QWORD PTR -16[rbp]
	add	rax, 72
	mov	DWORD PTR [rax], 0
	nop
	add	rsp, 88
	pop	rbx
	pop	rbp
	ret
.L2550:
	.seh_endproc
	.def	_ZN5ArrayIN3TKO6SYMBOLEE11GETITERATOREv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO6SYMBOLEE11GETITERATOREv
_ZN5ArrayIN3TKO6SYMBOLEE11GETITERATOREv:
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
.L2554:
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
.L2555:
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
	.def	_ZN13ArrayIteratorIN3TKO8SYMSCOPEEE7ISVALIDEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN13ArrayIteratorIN3TKO8SYMSCOPEEE7ISVALIDEv
_ZN13ArrayIteratorIN3TKO8SYMSCOPEEE7ISVALIDEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	BYTE PTR -9[rbp], 0
.L2558:
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
.L2559:
	movzx	eax, BYTE PTR -9[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN13ArrayIteratorIN3TKO8SYMSCOPEEE5VALUEEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN13ArrayIteratorIN3TKO8SYMSCOPEEE5VALUEEv
_ZN13ArrayIteratorIN3TKO8SYMSCOPEEE5VALUEEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR -16[rbp], 0
.L2562:
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
.L2563:
	mov	rax, QWORD PTR -16[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN13ArrayIteratorIN3TKO8SYMSCOPEEE8MOVENEXTEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN13ArrayIteratorIN3TKO8SYMSCOPEEE8MOVENEXTEv
_ZN13ArrayIteratorIN3TKO8SYMSCOPEEE8MOVENEXTEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
.L2566:
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
.L2567:
	.seh_endproc
	.def	_ZN5ArrayIN3TKO8SYMSCOPEEE5COUNTEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO8SYMSCOPEEE5COUNTEv
_ZN5ArrayIN3TKO8SYMSCOPEEE5COUNTEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR -4[rbp], 0
.L2569:
	mov	rax, QWORD PTR 16[rbp]
	mov	eax, DWORD PTR 72[rax]
	mov	DWORD PTR -4[rbp], eax
	nop
.L2570:
	mov	eax, DWORD PTR -4[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO8SYMSCOPEEE8CAPACITYEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO8SYMSCOPEEE8CAPACITYEv
_ZN5ArrayIN3TKO8SYMSCOPEEE8CAPACITYEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 64
	.seh_stackalloc	64
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR -20[rbp], 0
.L2573:
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
.L2574:
	mov	eax, DWORD PTR -20[rbp]
	add	rsp, 64
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO8SYMSCOPEEE7ISEMPTYEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO8SYMSCOPEEE7ISEMPTYEv
_ZN5ArrayIN3TKO8SYMSCOPEEE7ISEMPTYEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	BYTE PTR -1[rbp], 0
.L2577:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	sete	al
	mov	BYTE PTR -1[rbp], al
	nop
.L2578:
	movzx	eax, BYTE PTR -1[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO8SYMSCOPEEE7RESERVEEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO8SYMSCOPEEE7RESERVEEi
_ZN5ArrayIN3TKO8SYMSCOPEEE7RESERVEEi:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 80
	.seh_stackalloc	80
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
.L2581:
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIN3TKO8SYMSCOPEEE8CAPACITYEv
	mov	DWORD PTR -8[rbp], eax
	mov	eax, DWORD PTR 24[rbp]
	cmp	eax, DWORD PTR -8[rbp]
	jle	.L2594
	nop
.L2583:
.L2585:
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIN3TKO8SYMSCOPEEE8CAPACITYEv
	mov	DWORD PTR -12[rbp], eax
	mov	eax, DWORD PTR -12[rbp]
	mov	DWORD PTR -4[rbp], eax
	cmp	DWORD PTR -4[rbp], 7
	jg	.L2595
	mov	DWORD PTR -4[rbp], 8
	jmp	.L2592
.L2587:
.L2588:
.L2595:
	nop
.L2589:
.L2592:
	mov	eax, DWORD PTR -4[rbp]
	cmp	eax, DWORD PTR 24[rbp]
	jge	.L2596
	mov	eax, DWORD PTR -4[rbp]
	cdqe
	add	rax, rax
	mov	DWORD PTR -4[rbp], eax
	jmp	.L2592
.L2596:
	nop
.L2591:
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
	jmp	.L2597
.L2594:
	nop
.L2584:
.L2597:
	nop
	add	rsp, 80
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO8SYMSCOPEEE6SHRINKEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO8SYMSCOPEEE6SHRINKEv
_ZN5ArrayIN3TKO8SYMSCOPEEE6SHRINKEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 80
	.seh_stackalloc	80
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
.L2599:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	jne	.L2608
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayErase
	jmp	.L2602
.L2601:
.L2608:
	nop
.L2603:
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIN3TKO8SYMSCOPEEE8CAPACITYEv
	mov	DWORD PTR -4[rbp], eax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR -4[rbp], eax
	je	.L2609
	nop
.L2605:
.L2606:
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
	jmp	.L2610
.L2609:
	nop
.L2602:
.L2610:
	nop
	add	rsp, 80
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO8SYMSCOPEEEixEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO8SYMSCOPEEEixEi
_ZN5ArrayIN3TKO8SYMSCOPEEEixEi:
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
.L2612:
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
.L2613:
	mov	rax, QWORD PTR -8[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO8SYMSCOPEEE2ATEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO8SYMSCOPEEE2ATEi
_ZN5ArrayIN3TKO8SYMSCOPEEE2ATEi:
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
.L2616:
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
.L2617:
	mov	rax, QWORD PTR -8[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO8SYMSCOPEEE4PUSHERS1_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO8SYMSCOPEEE4PUSHERS1_
_ZN5ArrayIN3TKO8SYMSCOPEEE4PUSHERS1_:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
.L2620:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	add	eax, 1
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIN3TKO8SYMSCOPEEE7RESERVEEi
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
.L2621:
	.seh_endproc
	.def	_ZN5ArrayIN3TKO8SYMSCOPEEE3POPEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO8SYMSCOPEEE3POPEv
_ZN5ArrayIN3TKO8SYMSCOPEEE3POPEv:
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
.L2623:
	lea	rax, -64[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	rax, QWORD PTR 24[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	jne	.L2630
	mov	rax, QWORD PTR -64[rbp]
	mov	rdx, QWORD PTR -56[rbp]
	mov	QWORD PTR -32[rbp], rax
	mov	QWORD PTR -24[rbp], rdx
	mov	rax, QWORD PTR -48[rbp]
	mov	QWORD PTR -16[rbp], rax
	jmp	.L2626
.L2625:
.L2630:
	nop
.L2627:
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
.L2626:
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
	.def	_ZN5ArrayIN3TKO8SYMSCOPEEE6INSERTEiRS1_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO8SYMSCOPEEE6INSERTEiRS1_
_ZN5ArrayIN3TKO8SYMSCOPEEE6INSERTEiRS1_:
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
.L2632:
	cmp	DWORD PTR 24[rbp], 0
	js	.L2646
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR 24[rbp], eax
	setg	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -8[rbp], rax
	jmp	.L2635
.L2646:
	nop
.L2634:
	mov	QWORD PTR -8[rbp], -1
.L2635:
	cmp	QWORD PTR -8[rbp], 0
	jne	.L2647
	nop
.L2637:
.L2639:
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
	call	_ZN5ArrayIN3TKO8SYMSCOPEEE7RESERVEEi
	mov	rax, QWORD PTR 16[rbp]
	mov	eax, DWORD PTR 72[rax]
	mov	DWORD PTR -12[rbp], eax
	mov	eax, DWORD PTR 24[rbp]
	add	eax, 1
	mov	DWORD PTR -16[rbp], eax
	jmp	.L2640
.L2648:
	nop
.L2641:
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
.L2642:
	sub	DWORD PTR -12[rbp], 1
.L2640:
	mov	eax, DWORD PTR -12[rbp]
	cmp	eax, DWORD PTR -16[rbp]
	jge	.L2648
	nop
.L2643:
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
	jmp	.L2649
.L2647:
	nop
.L2638:
.L2649:
	nop
	add	rsp, 80
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO8SYMSCOPEEE6REMOVEEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO8SYMSCOPEEE6REMOVEEi
_ZN5ArrayIN3TKO8SYMSCOPEEE6REMOVEEi:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
.L2651:
	cmp	DWORD PTR 24[rbp], 0
	js	.L2665
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR 24[rbp], eax
	setge	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -8[rbp], rax
	jmp	.L2654
.L2665:
	nop
.L2653:
	mov	QWORD PTR -8[rbp], -1
.L2654:
	cmp	QWORD PTR -8[rbp], 0
	jne	.L2666
	nop
.L2656:
.L2658:
	mov	eax, DWORD PTR 24[rbp]
	mov	DWORD PTR -12[rbp], eax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	sub	eax, 2
	mov	DWORD PTR -16[rbp], eax
	jmp	.L2659
.L2667:
	nop
.L2660:
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
.L2661:
	add	DWORD PTR -12[rbp], 1
.L2659:
	mov	eax, DWORD PTR -12[rbp]
	cmp	eax, DWORD PTR -16[rbp]
	jle	.L2667
	nop
.L2662:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	sub	edx, 1
	mov	DWORD PTR [rax], edx
	jmp	.L2668
.L2666:
	nop
.L2657:
.L2668:
	nop
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO8SYMSCOPEEE10REMOVESWAPEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO8SYMSCOPEEE10REMOVESWAPEi
_ZN5ArrayIN3TKO8SYMSCOPEEE10REMOVESWAPEi:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
.L2670:
	cmp	DWORD PTR 24[rbp], 0
	js	.L2682
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR 24[rbp], eax
	setge	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -8[rbp], rax
	jmp	.L2673
.L2682:
	nop
.L2672:
	mov	QWORD PTR -8[rbp], -1
.L2673:
	cmp	QWORD PTR -8[rbp], 0
	jne	.L2683
	nop
.L2675:
.L2677:
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
	je	.L2684
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
	jmp	.L2685
.L2676:
.L2679:
.L2683:
	nop
	jmp	.L2685
.L2684:
	nop
.L2680:
.L2685:
	nop
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO8SYMSCOPEEE5CLEAREv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO8SYMSCOPEEE5CLEAREv
_ZN5ArrayIN3TKO8SYMSCOPEEE5CLEAREv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
.L2687:
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
	jmp	.L2688
.L2694:
	nop
.L2689:
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
.L2690:
	add	DWORD PTR -4[rbp], 1
.L2688:
	mov	eax, DWORD PTR -4[rbp]
	cmp	eax, DWORD PTR -8[rbp]
	jle	.L2694
	nop
.L2691:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	DWORD PTR [rax], 0
	nop
	add	rsp, 32
	pop	rbp
	ret
.L2692:
	.seh_endproc
	.def	_ZN5ArrayIN3TKO8SYMSCOPEEE11GETITERATOREv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO8SYMSCOPEEE11GETITERATOREv
_ZN5ArrayIN3TKO8SYMSCOPEEE11GETITERATOREv:
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
.L2696:
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
.L2697:
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
	.def	_ZN13ArrayIteratorIN3TKO8DIAGNOTEEE7ISVALIDEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN13ArrayIteratorIN3TKO8DIAGNOTEEE7ISVALIDEv
_ZN13ArrayIteratorIN3TKO8DIAGNOTEEE7ISVALIDEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	BYTE PTR -9[rbp], 0
.L2700:
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
.L2701:
	movzx	eax, BYTE PTR -9[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN13ArrayIteratorIN3TKO8DIAGNOTEEE5VALUEEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN13ArrayIteratorIN3TKO8DIAGNOTEEE5VALUEEv
_ZN13ArrayIteratorIN3TKO8DIAGNOTEEE5VALUEEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR -16[rbp], 0
.L2704:
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
	sal	rax, 3
	add	rax, rcx
	mov	QWORD PTR -16[rbp], rax
	nop
.L2705:
	mov	rax, QWORD PTR -16[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN13ArrayIteratorIN3TKO8DIAGNOTEEE8MOVENEXTEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN13ArrayIteratorIN3TKO8DIAGNOTEEE8MOVENEXTEv
_ZN13ArrayIteratorIN3TKO8DIAGNOTEEE8MOVENEXTEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
.L2708:
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
.L2709:
	.seh_endproc
	.def	_ZN5ArrayIN3TKO8DIAGNOTEEE5COUNTEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO8DIAGNOTEEE5COUNTEv
_ZN5ArrayIN3TKO8DIAGNOTEEE5COUNTEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR -4[rbp], 0
.L2711:
	mov	rax, QWORD PTR 16[rbp]
	mov	eax, DWORD PTR 72[rax]
	mov	DWORD PTR -4[rbp], eax
	nop
.L2712:
	mov	eax, DWORD PTR -4[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO8DIAGNOTEEE8CAPACITYEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO8DIAGNOTEEE8CAPACITYEv
_ZN5ArrayIN3TKO8DIAGNOTEEE8CAPACITYEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 64
	.seh_stackalloc	64
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR -20[rbp], 0
.L2715:
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
.L2716:
	mov	eax, DWORD PTR -20[rbp]
	add	rsp, 64
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO8DIAGNOTEEE7ISEMPTYEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO8DIAGNOTEEE7ISEMPTYEv
_ZN5ArrayIN3TKO8DIAGNOTEEE7ISEMPTYEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	BYTE PTR -1[rbp], 0
.L2719:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	sete	al
	mov	BYTE PTR -1[rbp], al
	nop
.L2720:
	movzx	eax, BYTE PTR -1[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO8DIAGNOTEEE7RESERVEEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO8DIAGNOTEEE7RESERVEEi
_ZN5ArrayIN3TKO8DIAGNOTEEE7RESERVEEi:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 80
	.seh_stackalloc	80
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
.L2723:
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIN3TKO8DIAGNOTEEE8CAPACITYEv
	mov	DWORD PTR -8[rbp], eax
	mov	eax, DWORD PTR 24[rbp]
	cmp	eax, DWORD PTR -8[rbp]
	jle	.L2736
	nop
.L2725:
.L2727:
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIN3TKO8DIAGNOTEEE8CAPACITYEv
	mov	DWORD PTR -12[rbp], eax
	mov	eax, DWORD PTR -12[rbp]
	mov	DWORD PTR -4[rbp], eax
	cmp	DWORD PTR -4[rbp], 7
	jg	.L2737
	mov	DWORD PTR -4[rbp], 8
	jmp	.L2734
.L2729:
.L2730:
.L2737:
	nop
.L2731:
.L2734:
	mov	eax, DWORD PTR -4[rbp]
	cmp	eax, DWORD PTR 24[rbp]
	jge	.L2738
	mov	eax, DWORD PTR -4[rbp]
	cdqe
	add	rax, rax
	mov	DWORD PTR -4[rbp], eax
	jmp	.L2734
.L2738:
	nop
.L2733:
	mov	eax, DWORD PTR -4[rbp]
	cdqe
	sub	rax, 1
	mov	QWORD PTR 48[rsp], rax
	mov	QWORD PTR 40[rsp], 0
	mov	QWORD PTR 32[rsp], 1
	lea	r9, _ZN3TKO8DIAGNOTED1Ev[rip]
	lea	r8, _ZN3TKO8DIAGNOTEC1Ev[rip]
	mov	edx, 40
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayRedimPresvObj
	jmp	.L2739
.L2736:
	nop
.L2726:
.L2739:
	nop
	add	rsp, 80
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO8DIAGNOTEEE6SHRINKEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO8DIAGNOTEEE6SHRINKEv
_ZN5ArrayIN3TKO8DIAGNOTEEE6SHRINKEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 80
	.seh_stackalloc	80
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
.L2741:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	jne	.L2750
	lea	r8, _ZN3TKO8DIAGNOTED1Ev[rip]
	lea	rdx, _ZN3TKO8DIAGNOTEC1Ev[rip]
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayEraseObj
	jmp	.L2744
.L2743:
.L2750:
	nop
.L2745:
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIN3TKO8DIAGNOTEEE8CAPACITYEv
	mov	DWORD PTR -4[rbp], eax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR -4[rbp], eax
	je	.L2751
	nop
.L2747:
.L2748:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cdqe
	sub	rax, 1
	mov	QWORD PTR 48[rsp], rax
	mov	QWORD PTR 40[rsp], 0
	mov	QWORD PTR 32[rsp], 1
	lea	r9, _ZN3TKO8DIAGNOTED1Ev[rip]
	lea	r8, _ZN3TKO8DIAGNOTEC1Ev[rip]
	mov	edx, 40
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayRedimPresvObj
	jmp	.L2752
.L2751:
	nop
.L2744:
.L2752:
	nop
	add	rsp, 80
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO8DIAGNOTEEEixEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO8DIAGNOTEEEixEi
_ZN5ArrayIN3TKO8DIAGNOTEEEixEi:
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
.L2754:
	mov	rax, QWORD PTR 16[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	eax, DWORD PTR 24[rbp]
	movsx	rdx, eax
	mov	rax, rdx
	sal	rax, 2
	add	rax, rdx
	sal	rax, 3
	add	rax, rcx
	mov	QWORD PTR -8[rbp], rax
	nop
.L2755:
	mov	rax, QWORD PTR -8[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO8DIAGNOTEEE2ATEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO8DIAGNOTEEE2ATEi
_ZN5ArrayIN3TKO8DIAGNOTEEE2ATEi:
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
.L2758:
	mov	rax, QWORD PTR 16[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	eax, DWORD PTR 24[rbp]
	movsx	rdx, eax
	mov	rax, rdx
	sal	rax, 2
	add	rax, rdx
	sal	rax, 3
	add	rax, rcx
	mov	QWORD PTR -8[rbp], rax
	nop
.L2759:
	mov	rax, QWORD PTR -8[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO8DIAGNOTEEE4PUSHERS1_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO8DIAGNOTEEE4PUSHERS1_
_ZN5ArrayIN3TKO8DIAGNOTEEE4PUSHERS1_:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
.L2762:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	add	eax, 1
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIN3TKO8DIAGNOTEEE7RESERVEEi
	mov	rax, QWORD PTR 16[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	movsx	rdx, eax
	mov	rax, rdx
	sal	rax, 2
	add	rax, rdx
	sal	rax, 3
	add	rcx, rax
	mov	rax, QWORD PTR 24[rbp]
	mov	rdx, rax
	call	_ZN3TKO8DIAGNOTEaSERKS0_
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
.L2763:
	.seh_endproc
	.def	_ZN5ArrayIN3TKO8DIAGNOTEEE3POPEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO8DIAGNOTEEE3POPEv
_ZN5ArrayIN3TKO8DIAGNOTEEE3POPEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 80
	.seh_stackalloc	80
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
.L2765:
	lea	rax, -48[rbp]
	mov	rcx, rax
	call	_ZN3TKO8DIAGNOTEC1Ev
	mov	rax, QWORD PTR 24[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	jne	.L2772
	lea	rax, -48[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN3TKO8DIAGNOTEC1ERKS0_
	lea	rax, -48[rbp]
	mov	rcx, rax
	call	_ZN3TKO8DIAGNOTED1Ev
	jmp	.L2768
.L2767:
.L2772:
	nop
.L2769:
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
	sal	rax, 3
	lea	rdx, [rcx+rax]
	lea	rax, -48[rbp]
	mov	rcx, rax
	call	_ZN3TKO8DIAGNOTEaSERKS0_
	lea	rax, -48[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN3TKO8DIAGNOTEC1ERKS0_
	lea	rax, -48[rbp]
	mov	rcx, rax
	call	_ZN3TKO8DIAGNOTED1Ev
	nop
.L2768:
	mov	rax, QWORD PTR 16[rbp]
	add	rsp, 80
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO8DIAGNOTEEE6INSERTEiRS1_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO8DIAGNOTEEE6INSERTEiRS1_
_ZN5ArrayIN3TKO8DIAGNOTEEE6INSERTEiRS1_:
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
.L2774:
	cmp	DWORD PTR 24[rbp], 0
	js	.L2788
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR 24[rbp], eax
	setg	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -8[rbp], rax
	jmp	.L2777
.L2788:
	nop
.L2776:
	mov	QWORD PTR -8[rbp], -1
.L2777:
	cmp	QWORD PTR -8[rbp], 0
	jne	.L2789
	nop
.L2779:
.L2781:
	mov	rdx, QWORD PTR 32[rbp]
	lea	rax, -64[rbp]
	mov	rcx, rax
	call	_ZN3TKO8DIAGNOTEC1ERKS0_
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	add	eax, 1
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIN3TKO8DIAGNOTEEE7RESERVEEi
	mov	rax, QWORD PTR 16[rbp]
	mov	eax, DWORD PTR 72[rax]
	mov	DWORD PTR -12[rbp], eax
	mov	eax, DWORD PTR 24[rbp]
	add	eax, 1
	mov	DWORD PTR -16[rbp], eax
	jmp	.L2782
.L2790:
	nop
.L2783:
	mov	rax, QWORD PTR 16[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	eax, DWORD PTR -12[rbp]
	movsx	rdx, eax
	mov	rax, rdx
	sal	rax, 2
	add	rax, rdx
	sal	rax, 3
	sub	rax, 40
	add	rcx, rax
	mov	rax, QWORD PTR 16[rbp]
	mov	r8, QWORD PTR [rax]
	mov	eax, DWORD PTR -12[rbp]
	movsx	rdx, eax
	mov	rax, rdx
	sal	rax, 2
	add	rax, rdx
	sal	rax, 3
	add	rax, r8
	mov	rdx, rcx
	mov	rcx, rax
	call	_ZN3TKO8DIAGNOTEaSERKS0_
.L2784:
	sub	DWORD PTR -12[rbp], 1
.L2782:
	mov	eax, DWORD PTR -12[rbp]
	cmp	eax, DWORD PTR -16[rbp]
	jge	.L2790
	nop
.L2785:
	mov	rax, QWORD PTR 16[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	eax, DWORD PTR 24[rbp]
	movsx	rdx, eax
	mov	rax, rdx
	sal	rax, 2
	add	rax, rdx
	sal	rax, 3
	add	rcx, rax
	lea	rax, -64[rbp]
	mov	rdx, rax
	call	_ZN3TKO8DIAGNOTEaSERKS0_
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	add	edx, 1
	mov	DWORD PTR [rax], edx
	lea	rax, -64[rbp]
	mov	rcx, rax
	call	_ZN3TKO8DIAGNOTED1Ev
	jmp	.L2791
.L2789:
	nop
.L2780:
.L2791:
	nop
	add	rsp, 96
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO8DIAGNOTEEE6REMOVEEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO8DIAGNOTEEE6REMOVEEi
_ZN5ArrayIN3TKO8DIAGNOTEEE6REMOVEEi:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 48
	.seh_stackalloc	48
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
.L2793:
	cmp	DWORD PTR 24[rbp], 0
	js	.L2807
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR 24[rbp], eax
	setge	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -8[rbp], rax
	jmp	.L2796
.L2807:
	nop
.L2795:
	mov	QWORD PTR -8[rbp], -1
.L2796:
	cmp	QWORD PTR -8[rbp], 0
	jne	.L2808
	nop
.L2798:
.L2800:
	mov	eax, DWORD PTR 24[rbp]
	mov	DWORD PTR -12[rbp], eax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	sub	eax, 2
	mov	DWORD PTR -16[rbp], eax
	jmp	.L2801
.L2809:
	nop
.L2802:
	mov	rax, QWORD PTR 16[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	eax, DWORD PTR -12[rbp]
	movsx	rdx, eax
	mov	rax, rdx
	sal	rax, 2
	add	rax, rdx
	sal	rax, 3
	add	rax, 40
	add	rcx, rax
	mov	rax, QWORD PTR 16[rbp]
	mov	r8, QWORD PTR [rax]
	mov	eax, DWORD PTR -12[rbp]
	movsx	rdx, eax
	mov	rax, rdx
	sal	rax, 2
	add	rax, rdx
	sal	rax, 3
	add	rax, r8
	mov	rdx, rcx
	mov	rcx, rax
	call	_ZN3TKO8DIAGNOTEaSERKS0_
.L2803:
	add	DWORD PTR -12[rbp], 1
.L2801:
	mov	eax, DWORD PTR -12[rbp]
	cmp	eax, DWORD PTR -16[rbp]
	jle	.L2809
	nop
.L2804:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	sub	edx, 1
	mov	DWORD PTR [rax], edx
	jmp	.L2810
.L2808:
	nop
.L2799:
.L2810:
	nop
	add	rsp, 48
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO8DIAGNOTEEE10REMOVESWAPEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO8DIAGNOTEEE10REMOVESWAPEi
_ZN5ArrayIN3TKO8DIAGNOTEEE10REMOVESWAPEi:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 48
	.seh_stackalloc	48
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
.L2812:
	cmp	DWORD PTR 24[rbp], 0
	js	.L2824
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR 24[rbp], eax
	setge	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -8[rbp], rax
	jmp	.L2815
.L2824:
	nop
.L2814:
	mov	QWORD PTR -8[rbp], -1
.L2815:
	cmp	QWORD PTR -8[rbp], 0
	jne	.L2825
	nop
.L2817:
.L2819:
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
	je	.L2826
	mov	rax, QWORD PTR 16[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	movsx	rdx, eax
	mov	rax, rdx
	sal	rax, 2
	add	rax, rdx
	sal	rax, 3
	add	rcx, rax
	mov	rax, QWORD PTR 16[rbp]
	mov	r8, QWORD PTR [rax]
	mov	eax, DWORD PTR 24[rbp]
	movsx	rdx, eax
	mov	rax, rdx
	sal	rax, 2
	add	rax, rdx
	sal	rax, 3
	add	rax, r8
	mov	rdx, rcx
	mov	rcx, rax
	call	_ZN3TKO8DIAGNOTEaSERKS0_
	jmp	.L2827
.L2818:
.L2821:
.L2825:
	nop
	jmp	.L2827
.L2826:
	nop
.L2822:
.L2827:
	nop
	add	rsp, 48
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO8DIAGNOTEEE5CLEAREv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO8DIAGNOTEEE5CLEAREv
_ZN5ArrayIN3TKO8DIAGNOTEEE5CLEAREv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 80
	.seh_stackalloc	80
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
.L2829:
	lea	rax, -48[rbp]
	mov	rcx, rax
	call	_ZN3TKO8DIAGNOTEC1Ev
	mov	DWORD PTR -4[rbp], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	sub	eax, 1
	mov	DWORD PTR -8[rbp], eax
	jmp	.L2830
.L2836:
	nop
.L2831:
	mov	rax, QWORD PTR 16[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	eax, DWORD PTR -4[rbp]
	movsx	rdx, eax
	mov	rax, rdx
	sal	rax, 2
	add	rax, rdx
	sal	rax, 3
	add	rcx, rax
	lea	rax, -48[rbp]
	mov	rdx, rax
	call	_ZN3TKO8DIAGNOTEaSERKS0_
.L2832:
	add	DWORD PTR -4[rbp], 1
.L2830:
	mov	eax, DWORD PTR -4[rbp]
	cmp	eax, DWORD PTR -8[rbp]
	jle	.L2836
	nop
.L2833:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	DWORD PTR [rax], 0
	lea	rax, -48[rbp]
	mov	rcx, rax
	call	_ZN3TKO8DIAGNOTED1Ev
	nop
	add	rsp, 80
	pop	rbp
	ret
.L2834:
	.seh_endproc
	.def	_ZN5ArrayIN3TKO8DIAGNOTEEE11GETITERATOREv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO8DIAGNOTEEE11GETITERATOREv
_ZN5ArrayIN3TKO8DIAGNOTEEE11GETITERATOREv:
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
.L2838:
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
.L2839:
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
	.def	_ZN13ArrayIteratorIN3TKO10DIAGNOSTICEE7ISVALIDEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN13ArrayIteratorIN3TKO10DIAGNOSTICEE7ISVALIDEv
_ZN13ArrayIteratorIN3TKO10DIAGNOSTICEE7ISVALIDEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	BYTE PTR -9[rbp], 0
.L2842:
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
.L2843:
	movzx	eax, BYTE PTR -9[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN13ArrayIteratorIN3TKO10DIAGNOSTICEE5VALUEEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN13ArrayIteratorIN3TKO10DIAGNOSTICEE5VALUEEv
_ZN13ArrayIteratorIN3TKO10DIAGNOSTICEE5VALUEEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR -16[rbp], 0
.L2846:
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
	sal	rax, 4
	add	rax, rdx
	sal	rax, 3
	add	rax, rcx
	mov	QWORD PTR -16[rbp], rax
	nop
.L2847:
	mov	rax, QWORD PTR -16[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN13ArrayIteratorIN3TKO10DIAGNOSTICEE8MOVENEXTEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN13ArrayIteratorIN3TKO10DIAGNOSTICEE8MOVENEXTEv
_ZN13ArrayIteratorIN3TKO10DIAGNOSTICEE8MOVENEXTEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
.L2850:
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
.L2851:
	.seh_endproc
	.def	_ZN5ArrayIN3TKO10DIAGNOSTICEE5COUNTEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO10DIAGNOSTICEE5COUNTEv
_ZN5ArrayIN3TKO10DIAGNOSTICEE5COUNTEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR -4[rbp], 0
.L2853:
	mov	rax, QWORD PTR 16[rbp]
	mov	eax, DWORD PTR 72[rax]
	mov	DWORD PTR -4[rbp], eax
	nop
.L2854:
	mov	eax, DWORD PTR -4[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO10DIAGNOSTICEE8CAPACITYEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO10DIAGNOSTICEE8CAPACITYEv
_ZN5ArrayIN3TKO10DIAGNOSTICEE8CAPACITYEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 64
	.seh_stackalloc	64
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR -20[rbp], 0
.L2857:
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
.L2858:
	mov	eax, DWORD PTR -20[rbp]
	add	rsp, 64
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO10DIAGNOSTICEE7ISEMPTYEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO10DIAGNOSTICEE7ISEMPTYEv
_ZN5ArrayIN3TKO10DIAGNOSTICEE7ISEMPTYEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	BYTE PTR -1[rbp], 0
.L2861:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	sete	al
	mov	BYTE PTR -1[rbp], al
	nop
.L2862:
	movzx	eax, BYTE PTR -1[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO10DIAGNOSTICEE7RESERVEEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO10DIAGNOSTICEE7RESERVEEi
_ZN5ArrayIN3TKO10DIAGNOSTICEE7RESERVEEi:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 80
	.seh_stackalloc	80
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
.L2865:
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIN3TKO10DIAGNOSTICEE8CAPACITYEv
	mov	DWORD PTR -8[rbp], eax
	mov	eax, DWORD PTR 24[rbp]
	cmp	eax, DWORD PTR -8[rbp]
	jle	.L2878
	nop
.L2867:
.L2869:
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIN3TKO10DIAGNOSTICEE8CAPACITYEv
	mov	DWORD PTR -12[rbp], eax
	mov	eax, DWORD PTR -12[rbp]
	mov	DWORD PTR -4[rbp], eax
	cmp	DWORD PTR -4[rbp], 7
	jg	.L2879
	mov	DWORD PTR -4[rbp], 8
	jmp	.L2876
.L2871:
.L2872:
.L2879:
	nop
.L2873:
.L2876:
	mov	eax, DWORD PTR -4[rbp]
	cmp	eax, DWORD PTR 24[rbp]
	jge	.L2880
	mov	eax, DWORD PTR -4[rbp]
	cdqe
	add	rax, rax
	mov	DWORD PTR -4[rbp], eax
	jmp	.L2876
.L2880:
	nop
.L2875:
	mov	eax, DWORD PTR -4[rbp]
	cdqe
	sub	rax, 1
	mov	QWORD PTR 48[rsp], rax
	mov	QWORD PTR 40[rsp], 0
	mov	QWORD PTR 32[rsp], 1
	lea	r9, _ZN3TKO10DIAGNOSTICD1Ev[rip]
	lea	r8, _ZN3TKO10DIAGNOSTICC1Ev[rip]
	mov	edx, 136
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayRedimPresvObj
	jmp	.L2881
.L2878:
	nop
.L2868:
.L2881:
	nop
	add	rsp, 80
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO10DIAGNOSTICEE6SHRINKEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO10DIAGNOSTICEE6SHRINKEv
_ZN5ArrayIN3TKO10DIAGNOSTICEE6SHRINKEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 80
	.seh_stackalloc	80
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
.L2883:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	jne	.L2892
	lea	r8, _ZN3TKO10DIAGNOSTICD1Ev[rip]
	lea	rdx, _ZN3TKO10DIAGNOSTICC1Ev[rip]
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayEraseObj
	jmp	.L2886
.L2885:
.L2892:
	nop
.L2887:
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIN3TKO10DIAGNOSTICEE8CAPACITYEv
	mov	DWORD PTR -4[rbp], eax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR -4[rbp], eax
	je	.L2893
	nop
.L2889:
.L2890:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cdqe
	sub	rax, 1
	mov	QWORD PTR 48[rsp], rax
	mov	QWORD PTR 40[rsp], 0
	mov	QWORD PTR 32[rsp], 1
	lea	r9, _ZN3TKO10DIAGNOSTICD1Ev[rip]
	lea	r8, _ZN3TKO10DIAGNOSTICC1Ev[rip]
	mov	edx, 136
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayRedimPresvObj
	jmp	.L2894
.L2893:
	nop
.L2886:
.L2894:
	nop
	add	rsp, 80
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO10DIAGNOSTICEEixEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO10DIAGNOSTICEEixEi
_ZN5ArrayIN3TKO10DIAGNOSTICEEixEi:
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
.L2896:
	mov	rax, QWORD PTR 16[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	eax, DWORD PTR 24[rbp]
	movsx	rdx, eax
	mov	rax, rdx
	sal	rax, 4
	add	rax, rdx
	sal	rax, 3
	add	rax, rcx
	mov	QWORD PTR -8[rbp], rax
	nop
.L2897:
	mov	rax, QWORD PTR -8[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO10DIAGNOSTICEE2ATEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO10DIAGNOSTICEE2ATEi
_ZN5ArrayIN3TKO10DIAGNOSTICEE2ATEi:
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
.L2900:
	mov	rax, QWORD PTR 16[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	eax, DWORD PTR 24[rbp]
	movsx	rdx, eax
	mov	rax, rdx
	sal	rax, 4
	add	rax, rdx
	sal	rax, 3
	add	rax, rcx
	mov	QWORD PTR -8[rbp], rax
	nop
.L2901:
	mov	rax, QWORD PTR -8[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO10DIAGNOSTICEE4PUSHERS1_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO10DIAGNOSTICEE4PUSHERS1_
_ZN5ArrayIN3TKO10DIAGNOSTICEE4PUSHERS1_:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
.L2904:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	add	eax, 1
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIN3TKO10DIAGNOSTICEE7RESERVEEi
	mov	rax, QWORD PTR 16[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	movsx	rdx, eax
	mov	rax, rdx
	sal	rax, 4
	add	rax, rdx
	sal	rax, 3
	add	rcx, rax
	mov	rax, QWORD PTR 24[rbp]
	mov	rdx, rax
	call	_ZN3TKO10DIAGNOSTICaSERKS0_
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
.L2905:
	.seh_endproc
	.def	_ZN5ArrayIN3TKO10DIAGNOSTICEE3POPEv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO10DIAGNOSTICEE3POPEv
_ZN5ArrayIN3TKO10DIAGNOSTICEE3POPEv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 176
	.seh_stackalloc	176
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
.L2907:
	lea	rax, -144[rbp]
	mov	rcx, rax
	call	_ZN3TKO10DIAGNOSTICC1Ev
	mov	rax, QWORD PTR 24[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	jne	.L2914
	lea	rax, -144[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN3TKO10DIAGNOSTICC1ERKS0_
	lea	rax, -144[rbp]
	mov	rcx, rax
	call	_ZN3TKO10DIAGNOSTICD1Ev
	jmp	.L2910
.L2909:
.L2914:
	nop
.L2911:
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
	sal	rax, 4
	add	rax, rdx
	sal	rax, 3
	lea	rdx, [rcx+rax]
	lea	rax, -144[rbp]
	mov	rcx, rax
	call	_ZN3TKO10DIAGNOSTICaSERKS0_
	lea	rax, -144[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN3TKO10DIAGNOSTICC1ERKS0_
	lea	rax, -144[rbp]
	mov	rcx, rax
	call	_ZN3TKO10DIAGNOSTICD1Ev
	nop
.L2910:
	mov	rax, QWORD PTR 16[rbp]
	add	rsp, 176
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO10DIAGNOSTICEE6INSERTEiRS1_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO10DIAGNOSTICEE6INSERTEiRS1_
_ZN5ArrayIN3TKO10DIAGNOSTICEE6INSERTEiRS1_:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 192
	.seh_stackalloc	192
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
	mov	QWORD PTR 32[rbp], r8
.L2916:
	cmp	DWORD PTR 24[rbp], 0
	js	.L2930
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR 24[rbp], eax
	setg	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -8[rbp], rax
	jmp	.L2919
.L2930:
	nop
.L2918:
	mov	QWORD PTR -8[rbp], -1
.L2919:
	cmp	QWORD PTR -8[rbp], 0
	jne	.L2931
	nop
.L2921:
.L2923:
	mov	rdx, QWORD PTR 32[rbp]
	lea	rax, -160[rbp]
	mov	rcx, rax
	call	_ZN3TKO10DIAGNOSTICC1ERKS0_
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	add	eax, 1
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIN3TKO10DIAGNOSTICEE7RESERVEEi
	mov	rax, QWORD PTR 16[rbp]
	mov	eax, DWORD PTR 72[rax]
	mov	DWORD PTR -12[rbp], eax
	mov	eax, DWORD PTR 24[rbp]
	add	eax, 1
	mov	DWORD PTR -16[rbp], eax
	jmp	.L2924
.L2932:
	nop
.L2925:
	mov	rax, QWORD PTR 16[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	eax, DWORD PTR -12[rbp]
	movsx	rdx, eax
	mov	rax, rdx
	sal	rax, 4
	add	rax, rdx
	sal	rax, 3
	sub	rax, 136
	add	rcx, rax
	mov	rax, QWORD PTR 16[rbp]
	mov	r8, QWORD PTR [rax]
	mov	eax, DWORD PTR -12[rbp]
	movsx	rdx, eax
	mov	rax, rdx
	sal	rax, 4
	add	rax, rdx
	sal	rax, 3
	add	rax, r8
	mov	rdx, rcx
	mov	rcx, rax
	call	_ZN3TKO10DIAGNOSTICaSERKS0_
.L2926:
	sub	DWORD PTR -12[rbp], 1
.L2924:
	mov	eax, DWORD PTR -12[rbp]
	cmp	eax, DWORD PTR -16[rbp]
	jge	.L2932
	nop
.L2927:
	mov	rax, QWORD PTR 16[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	eax, DWORD PTR 24[rbp]
	movsx	rdx, eax
	mov	rax, rdx
	sal	rax, 4
	add	rax, rdx
	sal	rax, 3
	add	rcx, rax
	lea	rax, -160[rbp]
	mov	rdx, rax
	call	_ZN3TKO10DIAGNOSTICaSERKS0_
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	add	edx, 1
	mov	DWORD PTR [rax], edx
	lea	rax, -160[rbp]
	mov	rcx, rax
	call	_ZN3TKO10DIAGNOSTICD1Ev
	jmp	.L2933
.L2931:
	nop
.L2922:
.L2933:
	nop
	add	rsp, 192
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO10DIAGNOSTICEE6REMOVEEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO10DIAGNOSTICEE6REMOVEEi
_ZN5ArrayIN3TKO10DIAGNOSTICEE6REMOVEEi:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 48
	.seh_stackalloc	48
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
.L2935:
	cmp	DWORD PTR 24[rbp], 0
	js	.L2949
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR 24[rbp], eax
	setge	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -8[rbp], rax
	jmp	.L2938
.L2949:
	nop
.L2937:
	mov	QWORD PTR -8[rbp], -1
.L2938:
	cmp	QWORD PTR -8[rbp], 0
	jne	.L2950
	nop
.L2940:
.L2942:
	mov	eax, DWORD PTR 24[rbp]
	mov	DWORD PTR -12[rbp], eax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	sub	eax, 2
	mov	DWORD PTR -16[rbp], eax
	jmp	.L2943
.L2951:
	nop
.L2944:
	mov	rax, QWORD PTR 16[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	eax, DWORD PTR -12[rbp]
	movsx	rdx, eax
	mov	rax, rdx
	sal	rax, 4
	add	rax, rdx
	sal	rax, 3
	add	rax, 136
	add	rcx, rax
	mov	rax, QWORD PTR 16[rbp]
	mov	r8, QWORD PTR [rax]
	mov	eax, DWORD PTR -12[rbp]
	movsx	rdx, eax
	mov	rax, rdx
	sal	rax, 4
	add	rax, rdx
	sal	rax, 3
	add	rax, r8
	mov	rdx, rcx
	mov	rcx, rax
	call	_ZN3TKO10DIAGNOSTICaSERKS0_
.L2945:
	add	DWORD PTR -12[rbp], 1
.L2943:
	mov	eax, DWORD PTR -12[rbp]
	cmp	eax, DWORD PTR -16[rbp]
	jle	.L2951
	nop
.L2946:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	sub	edx, 1
	mov	DWORD PTR [rax], edx
	jmp	.L2952
.L2950:
	nop
.L2941:
.L2952:
	nop
	add	rsp, 48
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO10DIAGNOSTICEE10REMOVESWAPEi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO10DIAGNOSTICEE10REMOVESWAPEi
_ZN5ArrayIN3TKO10DIAGNOSTICEE10REMOVESWAPEi:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 48
	.seh_stackalloc	48
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
.L2954:
	cmp	DWORD PTR 24[rbp], 0
	js	.L2966
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR 24[rbp], eax
	setge	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -8[rbp], rax
	jmp	.L2957
.L2966:
	nop
.L2956:
	mov	QWORD PTR -8[rbp], -1
.L2957:
	cmp	QWORD PTR -8[rbp], 0
	jne	.L2967
	nop
.L2959:
.L2961:
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
	je	.L2968
	mov	rax, QWORD PTR 16[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	movsx	rdx, eax
	mov	rax, rdx
	sal	rax, 4
	add	rax, rdx
	sal	rax, 3
	add	rcx, rax
	mov	rax, QWORD PTR 16[rbp]
	mov	r8, QWORD PTR [rax]
	mov	eax, DWORD PTR 24[rbp]
	movsx	rdx, eax
	mov	rax, rdx
	sal	rax, 4
	add	rax, rdx
	sal	rax, 3
	add	rax, r8
	mov	rdx, rcx
	mov	rcx, rax
	call	_ZN3TKO10DIAGNOSTICaSERKS0_
	jmp	.L2969
.L2960:
.L2963:
.L2967:
	nop
	jmp	.L2969
.L2968:
	nop
.L2964:
.L2969:
	nop
	add	rsp, 48
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO10DIAGNOSTICEE5CLEAREv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO10DIAGNOSTICEE5CLEAREv
_ZN5ArrayIN3TKO10DIAGNOSTICEE5CLEAREv:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 176
	.seh_stackalloc	176
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
.L2971:
	lea	rax, -144[rbp]
	mov	rcx, rax
	call	_ZN3TKO10DIAGNOSTICC1Ev
	mov	DWORD PTR -4[rbp], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	sub	eax, 1
	mov	DWORD PTR -8[rbp], eax
	jmp	.L2972
.L2978:
	nop
.L2973:
	mov	rax, QWORD PTR 16[rbp]
	mov	rcx, QWORD PTR [rax]
	mov	eax, DWORD PTR -4[rbp]
	movsx	rdx, eax
	mov	rax, rdx
	sal	rax, 4
	add	rax, rdx
	sal	rax, 3
	add	rcx, rax
	lea	rax, -144[rbp]
	mov	rdx, rax
	call	_ZN3TKO10DIAGNOSTICaSERKS0_
.L2974:
	add	DWORD PTR -4[rbp], 1
.L2972:
	mov	eax, DWORD PTR -4[rbp]
	cmp	eax, DWORD PTR -8[rbp]
	jle	.L2978
	nop
.L2975:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	DWORD PTR [rax], 0
	lea	rax, -144[rbp]
	mov	rcx, rax
	call	_ZN3TKO10DIAGNOSTICD1Ev
	nop
	add	rsp, 176
	pop	rbp
	ret
.L2976:
	.seh_endproc
	.def	_ZN5ArrayIN3TKO10DIAGNOSTICEE11GETITERATOREv;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO10DIAGNOSTICEE11GETITERATOREv
_ZN5ArrayIN3TKO10DIAGNOSTICEE11GETITERATOREv:
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
.L2980:
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
.L2981:
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
.L2984:
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
.L2985:
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
.L2988:
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
.L2989:
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
.L2992:
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
.L2993:
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
.L2995:
	mov	rax, QWORD PTR 16[rbp]
	mov	eax, DWORD PTR 72[rax]
	mov	DWORD PTR -4[rbp], eax
	nop
.L2996:
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
.L2999:
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
.L3000:
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
.L3003:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	sete	al
	mov	BYTE PTR -1[rbp], al
	nop
.L3004:
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
.L3007:
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIiE8CAPACITYEv
	mov	DWORD PTR -8[rbp], eax
	mov	eax, DWORD PTR 24[rbp]
	cmp	eax, DWORD PTR -8[rbp]
	jle	.L3020
	nop
.L3009:
.L3011:
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIiE8CAPACITYEv
	mov	DWORD PTR -12[rbp], eax
	mov	eax, DWORD PTR -12[rbp]
	mov	DWORD PTR -4[rbp], eax
	cmp	DWORD PTR -4[rbp], 7
	jg	.L3021
	mov	DWORD PTR -4[rbp], 8
	jmp	.L3018
.L3013:
.L3014:
.L3021:
	nop
.L3015:
.L3018:
	mov	eax, DWORD PTR -4[rbp]
	cmp	eax, DWORD PTR 24[rbp]
	jge	.L3022
	mov	eax, DWORD PTR -4[rbp]
	cdqe
	add	rax, rax
	mov	DWORD PTR -4[rbp], eax
	jmp	.L3018
.L3022:
	nop
.L3017:
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
	jmp	.L3023
.L3020:
	nop
.L3010:
.L3023:
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
.L3025:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	jne	.L3034
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayErase
	jmp	.L3028
.L3027:
.L3034:
	nop
.L3029:
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIiE8CAPACITYEv
	mov	DWORD PTR -4[rbp], eax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR -4[rbp], eax
	je	.L3035
	nop
.L3031:
.L3032:
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
	jmp	.L3036
.L3035:
	nop
.L3028:
.L3036:
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
.L3038:
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 24[rbp]
	movsx	rdx, edx
	sal	rdx, 2
	add	rax, rdx
	mov	QWORD PTR -8[rbp], rax
	nop
.L3039:
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
.L3042:
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 24[rbp]
	movsx	rdx, edx
	sal	rdx, 2
	add	rax, rdx
	mov	QWORD PTR -8[rbp], rax
	nop
.L3043:
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
.L3046:
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
.L3047:
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
.L3049:
	mov	DWORD PTR -8[rbp], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	jne	.L3056
	mov	eax, DWORD PTR -8[rbp]
	mov	DWORD PTR -4[rbp], eax
	jmp	.L3052
.L3051:
.L3056:
	nop
.L3053:
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
.L3052:
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
.L3058:
	cmp	DWORD PTR 24[rbp], 0
	js	.L3072
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR 24[rbp], eax
	setg	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -8[rbp], rax
	jmp	.L3061
.L3072:
	nop
.L3060:
	mov	QWORD PTR -8[rbp], -1
.L3061:
	cmp	QWORD PTR -8[rbp], 0
	jne	.L3073
	nop
.L3063:
.L3065:
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
	jmp	.L3066
.L3074:
	nop
.L3067:
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
.L3068:
	sub	DWORD PTR -12[rbp], 1
.L3066:
	mov	eax, DWORD PTR -12[rbp]
	cmp	eax, DWORD PTR -20[rbp]
	jge	.L3074
	nop
.L3069:
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
	jmp	.L3075
.L3073:
	nop
.L3064:
.L3075:
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
.L3077:
	cmp	DWORD PTR 24[rbp], 0
	js	.L3091
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR 24[rbp], eax
	setge	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -8[rbp], rax
	jmp	.L3080
.L3091:
	nop
.L3079:
	mov	QWORD PTR -8[rbp], -1
.L3080:
	cmp	QWORD PTR -8[rbp], 0
	jne	.L3092
	nop
.L3082:
.L3084:
	mov	eax, DWORD PTR 24[rbp]
	mov	DWORD PTR -12[rbp], eax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	sub	eax, 2
	mov	DWORD PTR -16[rbp], eax
	jmp	.L3085
.L3093:
	nop
.L3086:
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
.L3087:
	add	DWORD PTR -12[rbp], 1
.L3085:
	mov	eax, DWORD PTR -12[rbp]
	cmp	eax, DWORD PTR -16[rbp]
	jle	.L3093
	nop
.L3088:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	sub	edx, 1
	mov	DWORD PTR [rax], edx
	jmp	.L3094
.L3092:
	nop
.L3083:
.L3094:
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
.L3096:
	cmp	DWORD PTR 24[rbp], 0
	js	.L3108
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR 24[rbp], eax
	setge	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -8[rbp], rax
	jmp	.L3099
.L3108:
	nop
.L3098:
	mov	QWORD PTR -8[rbp], -1
.L3099:
	cmp	QWORD PTR -8[rbp], 0
	jne	.L3109
	nop
.L3101:
.L3103:
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
	je	.L3110
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
	jmp	.L3111
.L3102:
.L3105:
.L3109:
	nop
	jmp	.L3111
.L3110:
	nop
.L3106:
.L3111:
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
.L3113:
	mov	DWORD PTR -12[rbp], 0
	mov	DWORD PTR -4[rbp], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	sub	eax, 1
	mov	DWORD PTR -8[rbp], eax
	jmp	.L3114
.L3120:
	nop
.L3115:
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR -4[rbp]
	movsx	rdx, edx
	sal	rdx, 2
	add	rdx, rax
	mov	eax, DWORD PTR -12[rbp]
	mov	DWORD PTR [rdx], eax
.L3116:
	add	DWORD PTR -4[rbp], 1
.L3114:
	mov	eax, DWORD PTR -4[rbp]
	cmp	eax, DWORD PTR -8[rbp]
	jle	.L3120
	nop
.L3117:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	DWORD PTR [rax], 0
	nop
	add	rsp, 16
	pop	rbp
	ret
.L3118:
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
.L3122:
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
.L3123:
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
.L3126:
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
.L3127:
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
.L3130:
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
.L3131:
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
.L3134:
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
.L3135:
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
.L3137:
	mov	rax, QWORD PTR 16[rbp]
	mov	eax, DWORD PTR 72[rax]
	mov	DWORD PTR -4[rbp], eax
	nop
.L3138:
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
.L3141:
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
.L3142:
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
.L3145:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	sete	al
	mov	BYTE PTR -1[rbp], al
	nop
.L3146:
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
.L3149:
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIN3TKO8LINEMARKEE8CAPACITYEv
	mov	DWORD PTR -8[rbp], eax
	mov	eax, DWORD PTR 24[rbp]
	cmp	eax, DWORD PTR -8[rbp]
	jle	.L3162
	nop
.L3151:
.L3153:
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIN3TKO8LINEMARKEE8CAPACITYEv
	mov	DWORD PTR -12[rbp], eax
	mov	eax, DWORD PTR -12[rbp]
	mov	DWORD PTR -4[rbp], eax
	cmp	DWORD PTR -4[rbp], 7
	jg	.L3163
	mov	DWORD PTR -4[rbp], 8
	jmp	.L3160
.L3155:
.L3156:
.L3163:
	nop
.L3157:
.L3160:
	mov	eax, DWORD PTR -4[rbp]
	cmp	eax, DWORD PTR 24[rbp]
	jge	.L3164
	mov	eax, DWORD PTR -4[rbp]
	cdqe
	add	rax, rax
	mov	DWORD PTR -4[rbp], eax
	jmp	.L3160
.L3164:
	nop
.L3159:
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
	jmp	.L3165
.L3162:
	nop
.L3152:
.L3165:
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
.L3167:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	jne	.L3176
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayErase
	jmp	.L3170
.L3169:
.L3176:
	nop
.L3171:
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIN3TKO8LINEMARKEE8CAPACITYEv
	mov	DWORD PTR -4[rbp], eax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR -4[rbp], eax
	je	.L3177
	nop
.L3173:
.L3174:
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
	jmp	.L3178
.L3177:
	nop
.L3170:
.L3178:
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
.L3180:
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
.L3181:
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
.L3184:
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
.L3185:
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
.L3188:
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
.L3189:
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
.L3191:
	lea	rax, -24[rbp]
	mov	QWORD PTR [rax], 0
	mov	DWORD PTR 8[rax], 0
	mov	rax, QWORD PTR 24[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	jne	.L3198
	mov	rax, QWORD PTR -24[rbp]
	mov	QWORD PTR -12[rbp], rax
	mov	eax, DWORD PTR -16[rbp]
	mov	DWORD PTR -4[rbp], eax
	jmp	.L3194
.L3193:
.L3198:
	nop
.L3195:
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
.L3194:
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
.L3200:
	cmp	DWORD PTR 24[rbp], 0
	js	.L3214
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR 24[rbp], eax
	setg	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -8[rbp], rax
	jmp	.L3203
.L3214:
	nop
.L3202:
	mov	QWORD PTR -8[rbp], -1
.L3203:
	cmp	QWORD PTR -8[rbp], 0
	jne	.L3215
	nop
.L3205:
.L3207:
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
	jmp	.L3208
.L3216:
	nop
.L3209:
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
.L3210:
	sub	DWORD PTR -12[rbp], 1
.L3208:
	mov	eax, DWORD PTR -12[rbp]
	cmp	eax, DWORD PTR -16[rbp]
	jge	.L3216
	nop
.L3211:
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
	jmp	.L3217
.L3215:
	nop
.L3206:
.L3217:
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
.L3219:
	cmp	DWORD PTR 24[rbp], 0
	js	.L3233
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR 24[rbp], eax
	setge	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -8[rbp], rax
	jmp	.L3222
.L3233:
	nop
.L3221:
	mov	QWORD PTR -8[rbp], -1
.L3222:
	cmp	QWORD PTR -8[rbp], 0
	jne	.L3234
	nop
.L3224:
.L3226:
	mov	eax, DWORD PTR 24[rbp]
	mov	DWORD PTR -12[rbp], eax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	sub	eax, 2
	mov	DWORD PTR -16[rbp], eax
	jmp	.L3227
.L3235:
	nop
.L3228:
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
.L3229:
	add	DWORD PTR -12[rbp], 1
.L3227:
	mov	eax, DWORD PTR -12[rbp]
	cmp	eax, DWORD PTR -16[rbp]
	jle	.L3235
	nop
.L3230:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	sub	edx, 1
	mov	DWORD PTR [rax], edx
	jmp	.L3236
.L3234:
	nop
.L3225:
.L3236:
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
.L3238:
	cmp	DWORD PTR 24[rbp], 0
	js	.L3250
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR 24[rbp], eax
	setge	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -8[rbp], rax
	jmp	.L3241
.L3250:
	nop
.L3240:
	mov	QWORD PTR -8[rbp], -1
.L3241:
	cmp	QWORD PTR -8[rbp], 0
	jne	.L3251
	nop
.L3243:
.L3245:
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
	je	.L3252
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
	jmp	.L3253
.L3244:
.L3247:
.L3251:
	nop
	jmp	.L3253
.L3252:
	nop
.L3248:
.L3253:
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
.L3255:
	lea	rax, -20[rbp]
	mov	QWORD PTR [rax], 0
	mov	DWORD PTR 8[rax], 0
	mov	DWORD PTR -4[rbp], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	sub	eax, 1
	mov	DWORD PTR -8[rbp], eax
	jmp	.L3256
.L3262:
	nop
.L3257:
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
.L3258:
	add	DWORD PTR -4[rbp], 1
.L3256:
	mov	eax, DWORD PTR -4[rbp]
	cmp	eax, DWORD PTR -8[rbp]
	jle	.L3262
	nop
.L3259:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	DWORD PTR [rax], 0
	nop
	add	rsp, 32
	pop	rbp
	ret
.L3260:
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
.L3264:
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
.L3265:
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
.L3268:
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
.L3269:
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
.L3272:
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
.L3273:
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
.L3276:
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
.L3277:
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
.L3279:
	mov	rax, QWORD PTR 16[rbp]
	mov	eax, DWORD PTR 72[rax]
	mov	DWORD PTR -4[rbp], eax
	nop
.L3280:
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
.L3283:
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
.L3284:
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
.L3287:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	sete	al
	mov	BYTE PTR -1[rbp], al
	nop
.L3288:
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
.L3291:
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIPN3TKO10SOURCEFILEEE8CAPACITYEv
	mov	DWORD PTR -8[rbp], eax
	mov	eax, DWORD PTR 24[rbp]
	cmp	eax, DWORD PTR -8[rbp]
	jle	.L3304
	nop
.L3293:
.L3295:
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIPN3TKO10SOURCEFILEEE8CAPACITYEv
	mov	DWORD PTR -12[rbp], eax
	mov	eax, DWORD PTR -12[rbp]
	mov	DWORD PTR -4[rbp], eax
	cmp	DWORD PTR -4[rbp], 7
	jg	.L3305
	mov	DWORD PTR -4[rbp], 8
	jmp	.L3302
.L3297:
.L3298:
.L3305:
	nop
.L3299:
.L3302:
	mov	eax, DWORD PTR -4[rbp]
	cmp	eax, DWORD PTR 24[rbp]
	jge	.L3306
	mov	eax, DWORD PTR -4[rbp]
	cdqe
	add	rax, rax
	mov	DWORD PTR -4[rbp], eax
	jmp	.L3302
.L3306:
	nop
.L3301:
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
	jmp	.L3307
.L3304:
	nop
.L3294:
.L3307:
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
.L3309:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	jne	.L3318
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayErase
	jmp	.L3312
.L3311:
.L3318:
	nop
.L3313:
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIPN3TKO10SOURCEFILEEE8CAPACITYEv
	mov	DWORD PTR -4[rbp], eax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR -4[rbp], eax
	je	.L3319
	nop
.L3315:
.L3316:
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
	jmp	.L3320
.L3319:
	nop
.L3312:
.L3320:
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
.L3322:
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 24[rbp]
	movsx	rdx, edx
	sal	rdx, 3
	add	rax, rdx
	mov	QWORD PTR -8[rbp], rax
	nop
.L3323:
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
.L3326:
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 24[rbp]
	movsx	rdx, edx
	sal	rdx, 3
	add	rax, rdx
	mov	QWORD PTR -8[rbp], rax
	nop
.L3327:
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
.L3330:
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
.L3331:
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
.L3333:
	mov	QWORD PTR -16[rbp], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	jne	.L3340
	mov	rax, QWORD PTR -16[rbp]
	mov	QWORD PTR -8[rbp], rax
	jmp	.L3336
.L3335:
.L3340:
	nop
.L3337:
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
.L3336:
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
.L3342:
	cmp	DWORD PTR 24[rbp], 0
	js	.L3356
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR 24[rbp], eax
	setg	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -8[rbp], rax
	jmp	.L3345
.L3356:
	nop
.L3344:
	mov	QWORD PTR -8[rbp], -1
.L3345:
	cmp	QWORD PTR -8[rbp], 0
	jne	.L3357
	nop
.L3347:
.L3349:
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
	jmp	.L3350
.L3358:
	nop
.L3351:
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
.L3352:
	sub	DWORD PTR -12[rbp], 1
.L3350:
	mov	eax, DWORD PTR -12[rbp]
	cmp	eax, DWORD PTR -28[rbp]
	jge	.L3358
	nop
.L3353:
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
	jmp	.L3359
.L3357:
	nop
.L3348:
.L3359:
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
.L3361:
	cmp	DWORD PTR 24[rbp], 0
	js	.L3375
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR 24[rbp], eax
	setge	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -8[rbp], rax
	jmp	.L3364
.L3375:
	nop
.L3363:
	mov	QWORD PTR -8[rbp], -1
.L3364:
	cmp	QWORD PTR -8[rbp], 0
	jne	.L3376
	nop
.L3366:
.L3368:
	mov	eax, DWORD PTR 24[rbp]
	mov	DWORD PTR -12[rbp], eax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	sub	eax, 2
	mov	DWORD PTR -16[rbp], eax
	jmp	.L3369
.L3377:
	nop
.L3370:
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
.L3371:
	add	DWORD PTR -12[rbp], 1
.L3369:
	mov	eax, DWORD PTR -12[rbp]
	cmp	eax, DWORD PTR -16[rbp]
	jle	.L3377
	nop
.L3372:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	sub	edx, 1
	mov	DWORD PTR [rax], edx
	jmp	.L3378
.L3376:
	nop
.L3367:
.L3378:
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
.L3380:
	cmp	DWORD PTR 24[rbp], 0
	js	.L3392
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR 24[rbp], eax
	setge	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -8[rbp], rax
	jmp	.L3383
.L3392:
	nop
.L3382:
	mov	QWORD PTR -8[rbp], -1
.L3383:
	cmp	QWORD PTR -8[rbp], 0
	jne	.L3393
	nop
.L3385:
.L3387:
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
	je	.L3394
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
	jmp	.L3395
.L3386:
.L3389:
.L3393:
	nop
	jmp	.L3395
.L3394:
	nop
.L3390:
.L3395:
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
.L3397:
	mov	QWORD PTR -16[rbp], 0
	mov	DWORD PTR -4[rbp], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	eax, DWORD PTR [rax]
	sub	eax, 1
	mov	DWORD PTR -8[rbp], eax
	jmp	.L3398
.L3404:
	nop
.L3399:
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR -4[rbp]
	movsx	rdx, edx
	sal	rdx, 3
	add	rdx, rax
	mov	rax, QWORD PTR -16[rbp]
	mov	QWORD PTR [rdx], rax
.L3400:
	add	DWORD PTR -4[rbp], 1
.L3398:
	mov	eax, DWORD PTR -4[rbp]
	cmp	eax, DWORD PTR -8[rbp]
	jle	.L3404
	nop
.L3401:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	DWORD PTR [rax], 0
	nop
	add	rsp, 16
	pop	rbp
	ret
.L3402:
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
.L3406:
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
.L3407:
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
	.section .rdata,"dr"
.LC0:
	.ascii "\0"
.LC1:
	.ascii "$\0"
.LC2:
	.ascii "__ctor\0"
.LC3:
	.ascii "__dtor\0"
.LC4:
	.ascii ".\0"
.LC5:
	.ascii "this\0"
	.text
	.globl	_ZN3TKO7COLLECT8WALKNODEERNS0_6WALKEREjj
	.def	_ZN3TKO7COLLECT8WALKNODEERNS0_6WALKEREjj;	.scl	2;	.type	32;	.endef
	.seh_proc	_ZN3TKO7COLLECT8WALKNODEERNS0_6WALKEREjj
_ZN3TKO7COLLECT8WALKNODEERNS0_6WALKEREjj:
	push	rbp
	.seh_pushreg	rbp
	sub	rsp, 2112
	.seh_stackalloc	2112
	lea	rbp, 128[rsp]
	.seh_setframe	rbp, 128
	.seh_endprologue
	mov	QWORD PTR 2000[rbp], rcx
	mov	DWORD PTR 2008[rbp], edx
	mov	DWORD PTR 2016[rbp], r8d
.L3410:
	cmp	DWORD PTR 2008[rbp], 0
	je	.L3877
	nop
.L3412:
	mov	rax, QWORD PTR 2000[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 2008[rbp]
	mov	rcx, rax
	call	_ZN3TKO8ASTARENA4KINDEj
	mov	QWORD PTR 1784[rbp], rax
	mov	rax, QWORD PTR 1784[rbp]
	mov	QWORD PTR 1776[rbp], rax
	mov	edx, DWORD PTR 2008[rbp]
	mov	rax, QWORD PTR 2000[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN5ArrayIN3TKO7ASTNODEEEixEi
	mov	QWORD PTR 1768[rbp], rax
	mov	rax, QWORD PTR 1768[rbp]
	mov	QWORD PTR 1760[rbp], rax
	mov	rax, QWORD PTR 2000[rbp]
	add	rax, 48
	mov	rax, QWORD PTR [rax]
	mov	ecx, DWORD PTR 2016[rbp]
	mov	edx, DWORD PTR 2008[rbp]
	mov	r8d, ecx
	mov	rcx, rax
	call	_ZN3TKO12SEMANTICINFO8SETSCOPEEjj
	cmp	QWORD PTR 1776[rbp], 56
	je	.L3878
	nop
.L3414:
	cmp	QWORD PTR 1776[rbp], 29
	jne	.L3879
	jmp	.L3415
.L3878:
	nop
.L3415:
	mov	eax, DWORD PTR 2008[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 2000[rbp]
	call	_ZN3TKO7COLLECT6LISTOFERNS0_6WALKEREj
	mov	QWORD PTR 504[rbp], rax
	mov	rax, QWORD PTR 504[rbp]
	mov	QWORD PTR 496[rbp], rax
	mov	rax, QWORD PTR 496[rbp]
	add	rax, 8
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 496[rbp]
	add	rax, 4
	mov	eax, DWORD PTR [rax]
	mov	ecx, DWORD PTR 2016[rbp]
	mov	r9d, ecx
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 2000[rbp]
	call	_ZN3TKO7COLLECT12WALKCHILDRENERNS0_6WALKEREiij
	jmp	.L3825
.L3879:
	nop
.L3416:
	cmp	QWORD PTR 1776[rbp], 57
	je	.L3880
	nop
.L3417:
	cmp	QWORD PTR 1776[rbp], 59
	jne	.L3881
	jmp	.L3418
.L3880:
	nop
.L3418:
	mov	eax, DWORD PTR 2008[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 2000[rbp]
	call	_ZN3TKO7COLLECT6STMTOFERNS0_6WALKEREj
	mov	QWORD PTR 864[rbp], rax
	mov	rax, QWORD PTR 864[rbp]
	mov	QWORD PTR 856[rbp], rax
	mov	rax, QWORD PTR 856[rbp]
	add	rax, 24
	movzx	eax, WORD PTR [rax]
	cmp	ax, 227
	jne	.L3882
	mov	BYTE PTR 1983[rbp], 0
	mov	DWORD PTR 1976[rbp], 0
	mov	rax, QWORD PTR 856[rbp]
	add	rax, 20
	mov	eax, DWORD PTR [rax]
	sub	eax, 1
	mov	DWORD PTR 852[rbp], eax
	jmp	.L3422
.L3885:
	nop
.L3423:
	mov	rax, QWORD PTR 856[rbp]
	add	rax, 16
	mov	edx, DWORD PTR [rax]
	mov	eax, DWORD PTR 1976[rbp]
	add	edx, eax
	mov	rax, QWORD PTR 2000[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	add	rax, 560
	mov	rcx, rax
	call	_ZN5ArrayIjEixEi
	mov	QWORD PTR 840[rbp], rax
	mov	rax, QWORD PTR 840[rbp]
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR 836[rbp], eax
	mov	rax, QWORD PTR 2000[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 836[rbp]
	mov	rcx, rax
	call	_ZN3TKO8ASTARENA4KINDEj
	mov	QWORD PTR 824[rbp], rax
	cmp	QWORD PTR 824[rbp], 58
	jne	.L3883
	nop
.L3425:
	mov	eax, DWORD PTR 836[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 2000[rbp]
	call	_ZN3TKO7COLLECT6STMTOFERNS0_6WALKEREj
	mov	QWORD PTR 816[rbp], rax
	mov	rax, QWORD PTR 816[rbp]
	add	rax, 4
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	je	.L3884
	mov	BYTE PTR 1983[rbp], 1
	jmp	.L3428
.L3426:
.L3883:
	nop
	jmp	.L3428
.L3884:
	nop
.L3428:
	add	DWORD PTR 1976[rbp], 1
.L3422:
	mov	eax, DWORD PTR 1976[rbp]
	cmp	eax, DWORD PTR 852[rbp]
	jle	.L3885
	nop
.L3429:
	cmp	BYTE PTR 1983[rbp], 0
	je	.L3886
	jmp	.L3432
.L3421:
.L3431:
.L3882:
	nop
.L3432:
	mov	DWORD PTR 1972[rbp], 0
	mov	rax, QWORD PTR 856[rbp]
	add	rax, 20
	mov	eax, DWORD PTR [rax]
	sub	eax, 1
	mov	DWORD PTR 812[rbp], eax
	jmp	.L3433
.L3932:
	nop
.L3434:
	mov	rax, QWORD PTR 856[rbp]
	add	rax, 16
	mov	edx, DWORD PTR [rax]
	mov	eax, DWORD PTR 1972[rbp]
	add	edx, eax
	mov	rax, QWORD PTR 2000[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	add	rax, 560
	mov	rcx, rax
	call	_ZN5ArrayIjEixEi
	mov	QWORD PTR 800[rbp], rax
	mov	rax, QWORD PTR 800[rbp]
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR 796[rbp], eax
	mov	rax, QWORD PTR 2000[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 796[rbp]
	mov	rcx, rax
	call	_ZN3TKO8ASTARENA4KINDEj
	mov	QWORD PTR 784[rbp], rax
	cmp	QWORD PTR 784[rbp], 58
	jne	.L3887
	nop
.L3436:
	mov	edx, DWORD PTR 796[rbp]
	mov	rax, QWORD PTR 2000[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN5ArrayIN3TKO7ASTNODEEEixEi
	mov	QWORD PTR 776[rbp], rax
	mov	rax, QWORD PTR 776[rbp]
	mov	QWORD PTR 768[rbp], rax
	mov	rax, QWORD PTR 768[rbp]
	add	rax, 2
	movzx	eax, WORD PTR [rax]
	test	ax, ax
	js	.L3888
	nop
.L3439:
	mov	eax, DWORD PTR 796[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 2000[rbp]
	call	_ZN3TKO7COLLECT6STMTOFERNS0_6WALKEREj
	mov	QWORD PTR 760[rbp], rax
	mov	rax, QWORD PTR 760[rbp]
	mov	QWORD PTR 752[rbp], rax
	mov	QWORD PTR 1952[rbp], 1
	cmp	QWORD PTR 1776[rbp], 59
	jne	.L3889
	mov	QWORD PTR 1952[rbp], 3
	jmp	.L3441
.L3889:
	nop
.L3441:
	cmp	QWORD PTR 1952[rbp], 3
	jne	.L3890
	mov	rax, QWORD PTR 752[rbp]
	mov	ecx, DWORD PTR [rax]
	mov	rax, QWORD PTR 2000[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 2016[rbp]
	mov	r9d, 0
	mov	r8d, ecx
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE16LOOKUPLOCALTYPEDEjjb
	mov	DWORD PTR 748[rbp], eax
	mov	eax, DWORD PTR 748[rbp]
	mov	DWORD PTR 744[rbp], eax
	mov	rax, QWORD PTR 2000[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 744[rbp]
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE8SYMBOLATEj
	mov	QWORD PTR 736[rbp], rax
	mov	rax, QWORD PTR 736[rbp]
	mov	QWORD PTR 728[rbp], rax
	cmp	QWORD PTR 728[rbp], 0
	je	.L3891
	mov	rax, QWORD PTR 728[rbp]
	movzx	eax, BYTE PTR [rax]
	cmp	al, 3
	jne	.L3892
	mov	rax, QWORD PTR 728[rbp]
	add	rax, 40
	mov	rax, QWORD PTR [rax]
	mov	DWORD PTR 724[rbp], eax
	mov	edx, DWORD PTR 796[rbp]
	mov	eax, DWORD PTR 724[rbp]
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 2000[rbp]
	call	_ZN3TKO7COLLECT14SAMEDECLSHAPE_ERNS0_6WALKEREjj
	mov	BYTE PTR 723[rbp], al
	cmp	BYTE PTR 723[rbp], 0
	je	.L3893
	mov	edx, DWORD PTR 796[rbp]
	mov	eax, DWORD PTR 724[rbp]
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 2000[rbp]
	call	_ZN3TKO7COLLECT15SAMECONSTVALUE_ERNS0_6WALKEREjj
	mov	BYTE PTR 722[rbp], al
	cmp	BYTE PTR 722[rbp], 0
	jne	.L3894
	jmp	.L3455
.L3443:
.L3448:
.L3449:
.L3450:
.L3451:
.L3452:
.L3453:
.L3454:
.L3890:
	nop
	jmp	.L3455
.L3891:
	nop
	jmp	.L3455
.L3892:
	nop
	jmp	.L3455
.L3893:
	nop
.L3455:
	mov	rax, QWORD PTR 856[rbp]
	add	rax, 24
	movzx	eax, WORD PTR [rax]
	cmp	ax, 227
	sete	al
	mov	BYTE PTR 1951[rbp], al
	cmp	BYTE PTR 1951[rbp], 0
	jne	.L3895
	mov	eax, DWORD PTR 796[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 2000[rbp]
	call	_ZN3TKO7COLLECT15ISDYNARRAYITEM_ERNS0_6WALKEREj
	mov	BYTE PTR 721[rbp], al
	movzx	eax, BYTE PTR 721[rbp]
	mov	BYTE PTR 1951[rbp], al
	jmp	.L3457
.L3895:
	nop
.L3457:
	mov	rax, QWORD PTR 752[rbp]
	add	rax, 8
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	setne	al
	mov	BYTE PTR 720[rbp], al
	cmp	BYTE PTR 1951[rbp], 0
	je	.L3896
	cmp	BYTE PTR 720[rbp], 0
	setne	al
	mov	BYTE PTR 1971[rbp], al
	jmp	.L3460
.L3896:
	nop
.L3459:
	mov	BYTE PTR 1971[rbp], 0
.L3460:
	cmp	BYTE PTR 1971[rbp], 0
	je	.L3897
	lea	rax, 400[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	lea	rax, 400[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9d, 1
	lea	r8, .LC0[rip]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrAssign
	lea	rax, 432[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	lea	rax, 432[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9d, 1
	lea	r8, .LC0[rip]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrAssign
	lea	rax, 464[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	rax, QWORD PTR 752[rbp]
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 2000[rbp]
	add	rax, 32
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN3TKO8INTERNER8SPELLINGEj
	mov	QWORD PTR 712[rbp], rax
	mov	rdx, QWORD PTR 712[rbp]
	lea	rax, 464[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrAssign
	mov	rax, QWORD PTR 2000[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 796[rbp]
	mov	rcx, rax
	call	_ZN3TKO8ASTARENA3LOCEj
	mov	DWORD PTR 708[rbp], eax
	mov	eax, DWORD PTR 708[rbp]
	mov	ecx, eax
	call	_ZN3TKO10POINTRANGEEj
	mov	QWORD PTR 392[rbp], rax
	mov	rax, QWORD PTR 2000[rbp]
	add	rax, 24
	mov	rax, QWORD PTR [rax]
	lea	r8, 464[rbp]
	mov	rcx, QWORD PTR 392[rbp]
	lea	rdx, 400[rbp]
	mov	QWORD PTR 40[rsp], rdx
	lea	rdx, 432[rbp]
	mov	QWORD PTR 32[rsp], rdx
	mov	r9, r8
	mov	r8, rcx
	mov	edx, 86
	mov	rcx, rax
	call	_ZN3TKO16DIAGNOSTICENGINE6REPORTENS_6DIAGIDENS_11SOURCERANGEE8FBSTRINGS3_S3_
	lea	rax, 400[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	lea	rax, 432[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	lea	rax, 464[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	jmp	.L3463
.L3462:
.L3897:
	nop
.L3463:
	mov	rax, QWORD PTR 856[rbp]
	add	rax, 24
	movzx	eax, WORD PTR [rax]
	cmp	ax, 227
	sete	al
	mov	BYTE PTR 1950[rbp], al
	cmp	BYTE PTR 1950[rbp], 0
	jne	.L3898
	mov	rax, QWORD PTR 856[rbp]
	add	rax, 24
	movzx	eax, WORD PTR [rax]
	cmp	ax, 129
	jne	.L3899
	mov	rax, QWORD PTR 752[rbp]
	mov	ecx, DWORD PTR [rax]
	mov	rax, QWORD PTR 2000[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 2016[rbp]
	mov	r9d, 0
	mov	r8d, ecx
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE16LOOKUPLOCALTYPEDEjjb
	mov	DWORD PTR 704[rbp], eax
	mov	eax, DWORD PTR 704[rbp]
	mov	DWORD PTR 700[rbp], eax
	mov	rax, QWORD PTR 2000[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 700[rbp]
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE8SYMBOLATEj
	mov	QWORD PTR 688[rbp], rax
	mov	rax, QWORD PTR 688[rbp]
	mov	QWORD PTR 680[rbp], rax
	cmp	QWORD PTR 680[rbp], 0
	je	.L3900
	mov	rax, QWORD PTR 680[rbp]
	add	rax, 4
	mov	eax, DWORD PTR [rax]
	mov	eax, eax
	and	eax, 32768
	test	rax, rax
	setne	al
	mov	BYTE PTR 1950[rbp], al
	mov	edx, DWORD PTR 796[rbp]
	mov	rax, QWORD PTR 2000[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN5ArrayIN3TKO7ASTNODEEEixEi
	mov	QWORD PTR 672[rbp], rax
	mov	rax, QWORD PTR 672[rbp]
	add	rax, 2
	movzx	eax, WORD PTR [rax]
	movzx	eax, ax
	and	eax, 64
	test	rax, rax
	setne	al
	mov	BYTE PTR 671[rbp], al
	cmp	BYTE PTR 1950[rbp], 0
	je	.L3901
	cmp	BYTE PTR 671[rbp], 0
	setne	al
	mov	BYTE PTR 1949[rbp], al
	jmp	.L3470
.L3901:
	nop
.L3469:
	mov	BYTE PTR 1949[rbp], 0
.L3470:
	cmp	BYTE PTR 1949[rbp], 0
	je	.L3902
	mov	rax, QWORD PTR 856[rbp]
	add	rax, 24
	mov	WORD PTR [rax], 227
	jmp	.L3473
.L3472:
.L3902:
	nop
.L3473:
	cmp	BYTE PTR 671[rbp], 0
	jne	.L3903
	mov	BYTE PTR 1950[rbp], 0
	jmp	.L3480
.L3465:
.L3475:
.L3476:
.L3477:
.L3478:
.L3479:
.L3898:
	nop
	jmp	.L3480
.L3899:
	nop
	jmp	.L3480
.L3900:
	nop
	jmp	.L3480
.L3903:
	nop
.L3480:
	cmp	QWORD PTR 1952[rbp], 1
	jne	.L3904
	movsx	eax, BYTE PTR 1950[rbp]
	neg	eax
	test	eax, eax
	setne	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR 1960[rbp], rax
	jmp	.L3483
.L3904:
	nop
.L3482:
	mov	QWORD PTR 1960[rbp], 0
.L3483:
	cmp	QWORD PTR 1960[rbp], 0
	je	.L3905
	mov	rax, QWORD PTR 752[rbp]
	mov	ecx, DWORD PTR [rax]
	mov	rax, QWORD PTR 2000[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 2016[rbp]
	mov	r9d, 0
	mov	r8d, ecx
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE11LOOKUPTYPEDEjjb
	mov	DWORD PTR 664[rbp], eax
	mov	eax, DWORD PTR 664[rbp]
	mov	DWORD PTR 660[rbp], eax
	mov	rax, QWORD PTR 2000[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 660[rbp]
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE8SYMBOLATEj
	mov	QWORD PTR 648[rbp], rax
	mov	rax, QWORD PTR 648[rbp]
	mov	QWORD PTR 640[rbp], rax
	cmp	QWORD PTR 640[rbp], 0
	je	.L3906
	mov	rax, QWORD PTR 640[rbp]
	movzx	eax, BYTE PTR [rax]
	cmp	al, 1
	jne	.L3907
	mov	rax, QWORD PTR 640[rbp]
	add	rax, 40
	mov	rax, QWORD PTR [rax]
	mov	DWORD PTR 636[rbp], eax
	mov	rax, QWORD PTR 640[rbp]
	add	rax, 4
	mov	eax, DWORD PTR [rax]
	mov	eax, eax
	and	eax, 65536
	test	rax, rax
	setne	al
	mov	BYTE PTR 635[rbp], al
	mov	eax, DWORD PTR 636[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 2000[rbp]
	call	_ZN3TKO7COLLECT15ISDYNARRAYITEM_ERNS0_6WALKEREj
	mov	BYTE PTR 634[rbp], al
	cmp	BYTE PTR 634[rbp], 0
	jne	.L3908
	cmp	BYTE PTR 635[rbp], 0
	setne	al
	mov	BYTE PTR 1948[rbp], al
	jmp	.L3490
.L3908:
	nop
.L3489:
	mov	BYTE PTR 1948[rbp], 1
.L3490:
	cmp	BYTE PTR 1948[rbp], 0
	je	.L3909
	mov	eax, DWORD PTR 636[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 2000[rbp]
	call	_ZN3TKO7COLLECT6STMTOFERNS0_6WALKEREj
	mov	QWORD PTR 624[rbp], rax
	mov	rax, QWORD PTR 624[rbp]
	mov	QWORD PTR 616[rbp], rax
	mov	rax, QWORD PTR 752[rbp]
	add	rax, 4
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 616[rbp]
	add	rax, 4
	mov	eax, DWORD PTR [rax]
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 2000[rbp]
	call	_ZN3TKO7COLLECT12SAMETYPEREF_ERNS0_6WALKEREjj
	mov	BYTE PTR 615[rbp], al
	cmp	BYTE PTR 615[rbp], 0
	jne	.L3910
	jmp	.L3500
.L3485:
.L3493:
.L3494:
.L3495:
.L3496:
.L3497:
.L3498:
.L3499:
.L3905:
	nop
	jmp	.L3500
.L3906:
	nop
	jmp	.L3500
.L3907:
	nop
	jmp	.L3500
.L3909:
	nop
.L3500:
	mov	rax, QWORD PTR 856[rbp]
	add	rax, 24
	movzx	eax, WORD PTR [rax]
	cmp	ax, 149
	sete	al
	mov	BYTE PTR 614[rbp], al
	mov	rax, QWORD PTR 856[rbp]
	add	rax, 24
	movzx	eax, WORD PTR [rax]
	cmp	ax, 86
	sete	al
	mov	BYTE PTR 613[rbp], al
	cmp	QWORD PTR 1952[rbp], 1
	jne	.L3911
	mov	rax, QWORD PTR 752[rbp]
	mov	ecx, DWORD PTR [rax]
	mov	rax, QWORD PTR 2000[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 2016[rbp]
	mov	r9d, 0
	mov	r8d, ecx
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE16LOOKUPLOCALTYPEDEjjb
	mov	DWORD PTR 608[rbp], eax
	mov	eax, DWORD PTR 608[rbp]
	mov	DWORD PTR 604[rbp], eax
	mov	rax, QWORD PTR 2000[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 604[rbp]
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE8SYMBOLATEj
	mov	QWORD PTR 592[rbp], rax
	mov	rax, QWORD PTR 592[rbp]
	mov	QWORD PTR 584[rbp], rax
	cmp	QWORD PTR 584[rbp], 0
	je	.L3912
	mov	rax, QWORD PTR 584[rbp]
	add	rax, 4
	mov	eax, DWORD PTR [rax]
	mov	eax, eax
	and	eax, 8
	test	rax, rax
	setne	al
	mov	BYTE PTR 583[rbp], al
	mov	rax, QWORD PTR 584[rbp]
	movzx	eax, BYTE PTR [rax]
	cmp	al, 1
	jne	.L3913
	cmp	BYTE PTR 614[rbp], 0
	jne	.L3914
	cmp	BYTE PTR 583[rbp], 0
	setne	al
	mov	BYTE PTR 1947[rbp], al
	jmp	.L3508
.L3914:
	nop
.L3507:
	mov	BYTE PTR 1947[rbp], 1
.L3508:
	movsx	eax, BYTE PTR 1947[rbp]
	neg	eax
	test	eax, eax
	setne	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR 1936[rbp], rax
	jmp	.L3509
.L3913:
	nop
.L3505:
	mov	QWORD PTR 1936[rbp], 0
.L3509:
	cmp	QWORD PTR 1936[rbp], 0
	setne	al
	mov	BYTE PTR 1935[rbp], al
	mov	rax, QWORD PTR 584[rbp]
	add	rax, 4
	mov	eax, DWORD PTR [rax]
	mov	eax, eax
	and	eax, 2048
	test	rax, rax
	setne	al
	mov	BYTE PTR 582[rbp], al
	mov	rax, QWORD PTR 1760[rbp]
	add	rax, 2
	movzx	eax, WORD PTR [rax]
	movzx	eax, ax
	and	eax, 16
	test	rax, rax
	setne	al
	mov	BYTE PTR 581[rbp], al
	movzx	eax, BYTE PTR 582[rbp]
	cmp	al, BYTE PTR 581[rbp]
	je	.L3915
	mov	BYTE PTR 1935[rbp], 0
	jmp	.L3511
.L3915:
	nop
.L3511:
	cmp	BYTE PTR 1935[rbp], 0
	je	.L3916
	mov	rax, QWORD PTR 584[rbp]
	add	rax, 40
	mov	rax, QWORD PTR [rax]
	mov	edx, eax
	mov	eax, DWORD PTR 796[rbp]
	mov	r8d, eax
	mov	rcx, QWORD PTR 2000[rbp]
	call	_ZN3TKO7COLLECT14SAMEDECLSHAPE_ERNS0_6WALKEREjj
	mov	BYTE PTR 580[rbp], al
	cmp	BYTE PTR 580[rbp], 0
	je	.L3917
	mov	rax, QWORD PTR 1760[rbp]
	add	rax, 2
	movzx	eax, WORD PTR [rax]
	movzx	eax, ax
	and	eax, 1024
	test	rax, rax
	je	.L3918
	mov	rax, QWORD PTR 584[rbp]
	add	rax, 4
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 584[rbp]
	add	rax, 4
	or	edx, 1
	mov	DWORD PTR [rax], edx
	jmp	.L3516
.L3515:
.L3918:
	nop
.L3516:
	cmp	BYTE PTR 614[rbp], 0
	jne	.L3919
	mov	rax, QWORD PTR 584[rbp]
	add	rax, 4
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 584[rbp]
	add	rax, 4
	and	edx, -9
	mov	DWORD PTR [rax], edx
	mov	eax, DWORD PTR 796[rbp]
	mov	rdx, QWORD PTR 584[rbp]
	add	rdx, 40
	cdqe
	mov	QWORD PTR [rdx], rax
	jmp	.L3556
.L3518:
.L3919:
	nop
.L3519:
	jmp	.L3556
.L3502:
.L3520:
.L3521:
.L3522:
.L3523:
.L3524:
.L3525:
.L3911:
	nop
	jmp	.L3526
.L3912:
	nop
	jmp	.L3526
.L3916:
	nop
	jmp	.L3526
.L3917:
	nop
.L3526:
	mov	rax, QWORD PTR 2000[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 796[rbp]
	mov	rcx, rax
	call	_ZN3TKO8ASTARENA3LOCEj
	mov	DWORD PTR 576[rbp], eax
	mov	rax, QWORD PTR 752[rbp]
	mov	ecx, DWORD PTR [rax]
	mov	r8, QWORD PTR 1952[rbp]
	mov	eax, DWORD PTR 2016[rbp]
	mov	edx, DWORD PTR 576[rbp]
	mov	DWORD PTR 32[rsp], edx
	mov	r9, r8
	mov	r8d, ecx
	mov	edx, eax
	mov	rcx, QWORD PTR 2000[rbp]
	call	_ZN3TKO7COLLECT8DECLARE_ERNS0_6WALKEREjjNS_10SYMBOLKINDEj
	mov	DWORD PTR 572[rbp], eax
	mov	eax, DWORD PTR 572[rbp]
	mov	DWORD PTR 568[rbp], eax
	mov	rax, QWORD PTR 2000[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 568[rbp]
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE8SYMBOLATEj
	mov	QWORD PTR 560[rbp], rax
	mov	rax, QWORD PTR 560[rbp]
	mov	QWORD PTR 552[rbp], rax
	cmp	QWORD PTR 552[rbp], 0
	je	.L3920
	mov	rax, QWORD PTR 1760[rbp]
	add	rax, 2
	movzx	eax, WORD PTR [rax]
	movzx	eax, ax
	and	eax, 1024
	test	rax, rax
	je	.L3921
	mov	rax, QWORD PTR 552[rbp]
	add	rax, 4
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 552[rbp]
	add	rax, 4
	or	edx, 1
	mov	DWORD PTR [rax], edx
	jmp	.L3529
.L3921:
	nop
.L3529:
	mov	rax, QWORD PTR 1760[rbp]
	add	rax, 2
	movzx	eax, WORD PTR [rax]
	movzx	eax, ax
	and	eax, 2048
	test	rax, rax
	je	.L3922
	mov	rax, QWORD PTR 552[rbp]
	add	rax, 4
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 552[rbp]
	add	rax, 4
	or	edx, 2
	mov	DWORD PTR [rax], edx
	jmp	.L3531
.L3922:
	nop
.L3531:
	mov	edx, DWORD PTR 796[rbp]
	mov	rax, QWORD PTR 2000[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN5ArrayIN3TKO7ASTNODEEEixEi
	mov	QWORD PTR 544[rbp], rax
	mov	rax, QWORD PTR 1760[rbp]
	add	rax, 2
	movzx	edx, WORD PTR [rax]
	mov	rax, QWORD PTR 544[rbp]
	add	rax, 2
	movzx	eax, WORD PTR [rax]
	or	eax, edx
	movzx	eax, ax
	and	eax, 16
	test	rax, rax
	je	.L3923
	mov	rax, QWORD PTR 552[rbp]
	add	rax, 4
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 552[rbp]
	add	rax, 4
	or	dh, 8
	mov	DWORD PTR [rax], edx
	jmp	.L3533
.L3923:
	nop
.L3533:
	cmp	BYTE PTR 614[rbp], 0
	je	.L3924
	mov	rax, QWORD PTR 552[rbp]
	add	rax, 4
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 552[rbp]
	add	rax, 4
	or	edx, 8
	mov	DWORD PTR [rax], edx
	mov	rax, QWORD PTR 856[rbp]
	add	rax, 28
	mov	eax, DWORD PTR [rax]
	mov	eax, eax
	and	eax, 32
	test	rax, rax
	je	.L3925
	mov	rax, QWORD PTR 552[rbp]
	lea	rdx, 52[rax]
	mov	rax, QWORD PTR 752[rbp]
	mov	eax, DWORD PTR 40[rax]
	mov	DWORD PTR [rdx], eax
	mov	rax, QWORD PTR 552[rbp]
	add	rax, 52
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	jne	.L3926
	mov	rax, QWORD PTR 552[rbp]
	lea	rdx, 52[rax]
	mov	rax, QWORD PTR 752[rbp]
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR [rdx], eax
	jmp	.L3541
.L3926:
	nop
.L3539:
	jmp	.L3541
.L3925:
	nop
.L3537:
	lea	rax, 304[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	lea	rax, 368[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	rax, QWORD PTR 752[rbp]
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 2000[rbp]
	add	rax, 32
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN3TKO8INTERNER8SPELLINGEj
	mov	QWORD PTR 536[rbp], rax
	mov	rdx, QWORD PTR 536[rbp]
	lea	rax, 368[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrAssign
	lea	rax, 368[rbp]
	mov	rcx, rax
	call	_ZN3TKO4TEXT10UPPERASCIIE8FBSTRING
	mov	QWORD PTR 528[rbp], rax
	lea	rax, 336[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	rdx, QWORD PTR 528[rbp]
	lea	rax, 336[rbp]
	mov	QWORD PTR 32[rsp], 2
	lea	r9, .LC1[rip]
	mov	r8, -1
	mov	rcx, rax
	call	fb_StrConcat
	mov	QWORD PTR 520[rbp], rax
	mov	rdx, QWORD PTR 520[rbp]
	lea	rax, 304[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrAssign
	mov	rax, QWORD PTR 2000[rbp]
	add	rax, 32
	mov	rax, QWORD PTR [rax]
	lea	rdx, 304[rbp]
	mov	rcx, rax
	call	_ZN3TKO8INTERNER9GETSTRINGE8FBSTRING
	mov	DWORD PTR 516[rbp], eax
	mov	rax, QWORD PTR 552[rbp]
	lea	rdx, 52[rax]
	mov	eax, DWORD PTR 516[rbp]
	mov	DWORD PTR [rdx], eax
	lea	rax, 304[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	lea	rax, 368[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	jmp	.L3541
.L3535:
.L3540:
.L3924:
	nop
.L3541:
	cmp	BYTE PTR 613[rbp], 0
	je	.L3927
	mov	rax, QWORD PTR 552[rbp]
	add	rax, 4
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 552[rbp]
	add	rax, 4
	or	dh, -128
	mov	DWORD PTR [rax], edx
	jmp	.L3543
.L3927:
	nop
.L3543:
	cmp	QWORD PTR 1776[rbp], 59
	jne	.L3928
	mov	rax, QWORD PTR 552[rbp]
	add	rax, 4
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 552[rbp]
	add	rax, 4
	or	edx, 4
	mov	DWORD PTR [rax], edx
	jmp	.L3545
.L3928:
	nop
.L3545:
	mov	rax, QWORD PTR 856[rbp]
	add	rax, 28
	mov	eax, DWORD PTR [rax]
	mov	eax, eax
	and	eax, 1024
	test	rax, rax
	je	.L3929
	mov	rax, QWORD PTR 552[rbp]
	add	rax, 4
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 552[rbp]
	add	rax, 4
	or	edx, 131072
	mov	DWORD PTR [rax], edx
	jmp	.L3548
.L3547:
.L3929:
	nop
.L3548:
	mov	rax, QWORD PTR 856[rbp]
	add	rax, 28
	mov	eax, DWORD PTR [rax]
	mov	eax, eax
	and	eax, 2048
	test	rax, rax
	je	.L3930
	mov	rax, QWORD PTR 552[rbp]
	add	rax, 4
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 552[rbp]
	add	rax, 4
	or	edx, 262144
	mov	DWORD PTR [rax], edx
	jmp	.L3551
.L3550:
.L3930:
	nop
.L3551:
	mov	rax, QWORD PTR 856[rbp]
	add	rax, 24
	movzx	eax, WORD PTR [rax]
	cmp	ax, 227
	jne	.L3931
	mov	rax, QWORD PTR 552[rbp]
	add	rax, 4
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 552[rbp]
	add	rax, 4
	or	edx, 65536
	mov	DWORD PTR [rax], edx
	jmp	.L3554
.L3553:
.L3931:
	nop
.L3554:
	mov	eax, DWORD PTR 796[rbp]
	mov	rdx, QWORD PTR 552[rbp]
	add	rdx, 40
	cdqe
	mov	QWORD PTR [rdx], rax
	jmp	.L3556
.L3437:
.L3555:
.L3887:
	nop
	jmp	.L3556
.L3888:
	nop
	jmp	.L3556
.L3894:
	nop
	jmp	.L3556
.L3910:
	nop
	jmp	.L3556
.L3920:
	nop
.L3556:
	add	DWORD PTR 1972[rbp], 1
.L3433:
	mov	eax, DWORD PTR 1972[rbp]
	cmp	eax, DWORD PTR 812[rbp]
	jle	.L3932
	nop
.L3557:
	jmp	.L3825
.L3881:
	nop
.L3419:
	cmp	QWORD PTR 1776[rbp], 60
	jne	.L3933
	nop
.L3558:
	mov	eax, DWORD PTR 2008[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 2000[rbp]
	call	_ZN3TKO7COLLECT6STMTOFERNS0_6WALKEREj
	mov	QWORD PTR 1752[rbp], rax
	mov	rax, QWORD PTR 1752[rbp]
	mov	QWORD PTR 1744[rbp], rax
	mov	rax, QWORD PTR 1744[rbp]
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	jne	.L3934
	mov	r8, QWORD PTR 1744[rbp]
	mov	rcx, QWORD PTR 1760[rbp]
	mov	eax, DWORD PTR 2008[rbp]
	mov	edx, DWORD PTR 2016[rbp]
	mov	DWORD PTR 32[rsp], edx
	mov	r9, r8
	mov	r8, rcx
	mov	edx, eax
	mov	rcx, QWORD PTR 2000[rbp]
	call	_ZN3TKO7COLLECT21COLLECTANONAGGREGATE_ERNS0_6WALKEREjPNS_7ASTNODEEPNS_11STMTPAYLOADEj
	jmp	.L3825
.L3561:
.L3934:
	nop
.L3562:
	mov	rax, QWORD PTR 2000[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 2008[rbp]
	mov	rcx, rax
	call	_ZN3TKO8ASTARENA3LOCEj
	mov	DWORD PTR 1740[rbp], eax
	mov	rax, QWORD PTR 1744[rbp]
	mov	ecx, DWORD PTR [rax]
	mov	eax, DWORD PTR 2016[rbp]
	mov	edx, DWORD PTR 1740[rbp]
	mov	DWORD PTR 32[rsp], edx
	mov	r9d, 6
	mov	r8d, ecx
	mov	edx, eax
	mov	rcx, QWORD PTR 2000[rbp]
	call	_ZN3TKO7COLLECT8DECLARE_ERNS0_6WALKEREjjNS_10SYMBOLKINDEj
	mov	DWORD PTR 1736[rbp], eax
	mov	eax, DWORD PTR 1736[rbp]
	mov	DWORD PTR 1732[rbp], eax
	mov	rax, QWORD PTR 2000[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	ecx, DWORD PTR 1732[rbp]
	mov	edx, DWORD PTR 2016[rbp]
	mov	r9d, ecx
	mov	r8d, edx
	mov	edx, 3
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE9OPENSCOPEENS_9SCOPEKINDEjj
	mov	DWORD PTR 1728[rbp], eax
	mov	eax, DWORD PTR 1728[rbp]
	mov	DWORD PTR 1724[rbp], eax
	mov	rax, QWORD PTR 2000[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 1732[rbp]
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE8SYMBOLATEj
	mov	QWORD PTR 1712[rbp], rax
	mov	rax, QWORD PTR 1712[rbp]
	mov	QWORD PTR 1704[rbp], rax
	cmp	QWORD PTR 1704[rbp], 0
	je	.L3935
	mov	rax, QWORD PTR 1704[rbp]
	lea	rdx, 36[rax]
	mov	eax, DWORD PTR 1724[rbp]
	mov	DWORD PTR [rdx], eax
	mov	rax, QWORD PTR 1760[rbp]
	add	rax, 2
	movzx	eax, WORD PTR [rax]
	movzx	eax, ax
	and	eax, 512
	test	rax, rax
	je	.L3936
	mov	rax, QWORD PTR 1704[rbp]
	add	rax, 4
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 1704[rbp]
	add	rax, 4
	or	dh, 32
	mov	DWORD PTR [rax], edx
	jmp	.L3566
.L3936:
	nop
.L3566:
	mov	DWORD PTR 1928[rbp], 0
	mov	rax, QWORD PTR 1744[rbp]
	add	rax, 28
	mov	eax, DWORD PTR [rax]
	mov	eax, eax
	and	eax, 524320
	test	rax, rax
	je	.L3937
	mov	rax, QWORD PTR 1744[rbp]
	mov	eax, DWORD PTR 40[rax]
	mov	DWORD PTR 1928[rbp], eax
	jmp	.L3569
.L3568:
.L3937:
	nop
.L3569:
	mov	rax, QWORD PTR 1744[rbp]
	mov	ecx, DWORD PTR [rax]
	mov	rax, QWORD PTR 2000[rbp]
	add	rax, 40
	mov	rax, QWORD PTR [rax]
	mov	r8d, DWORD PTR 2016[rbp]
	mov	edx, DWORD PTR 1928[rbp]
	mov	DWORD PTR 32[rsp], edx
	mov	r9d, r8d
	mov	r8d, ecx
	mov	edx, 6
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT9NAMEDTYPEENS_8TYPEKINDEjjj
	mov	DWORD PTR 1700[rbp], eax
	mov	rax, QWORD PTR 1704[rbp]
	lea	rdx, 16[rax]
	mov	eax, DWORD PTR 1700[rbp]
	mov	DWORD PTR [rdx], eax
	mov	eax, DWORD PTR 2008[rbp]
	mov	rdx, QWORD PTR 1704[rbp]
	add	rdx, 40
	cdqe
	mov	QWORD PTR [rdx], rax
	mov	rax, QWORD PTR 2000[rbp]
	add	rax, 48
	mov	rax, QWORD PTR [rax]
	mov	ecx, DWORD PTR 1732[rbp]
	mov	edx, DWORD PTR 2008[rbp]
	mov	r8d, ecx
	mov	rcx, rax
	call	_ZN3TKO12SEMANTICINFO6SETREFEjj
	mov	rax, QWORD PTR 1744[rbp]
	add	rax, 28
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	je	.L3938
	mov	rax, QWORD PTR 1744[rbp]
	add	rax, 28
	mov	ecx, DWORD PTR [rax]
	mov	rax, QWORD PTR 1704[rbp]
	add	rax, 16
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 2000[rbp]
	add	rax, 40
	mov	rax, QWORD PTR [rax]
	mov	r8d, ecx
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT10SETPACKINGEji
	jmp	.L3573
.L3564:
.L3571:
.L3572:
.L3935:
	nop
	jmp	.L3573
.L3938:
	nop
.L3573:
	mov	rax, QWORD PTR 2000[rbp]
	add	rax, 48
	mov	rax, QWORD PTR [rax]
	mov	ecx, DWORD PTR 1724[rbp]
	mov	edx, DWORD PTR 2008[rbp]
	mov	r8d, ecx
	mov	rcx, rax
	call	_ZN3TKO12SEMANTICINFO8SETSCOPEEjj
	mov	rax, QWORD PTR 2000[rbp]
	movzx	eax, BYTE PTR 56[rax]
	mov	BYTE PTR 1699[rbp], al
	mov	rax, QWORD PTR 2000[rbp]
	movzx	eax, BYTE PTR 57[rax]
	mov	BYTE PTR 1698[rbp], al
	mov	rax, QWORD PTR 2000[rbp]
	mov	eax, DWORD PTR 60[rax]
	mov	DWORD PTR 1692[rbp], eax
	mov	rax, QWORD PTR 1760[rbp]
	add	rax, 2
	movzx	eax, WORD PTR [rax]
	movzx	eax, ax
	and	eax, 512
	test	rax, rax
	setne	dl
	mov	rax, QWORD PTR 2000[rbp]
	add	rax, 56
	mov	BYTE PTR [rax], dl
	mov	rax, QWORD PTR 2000[rbp]
	add	rax, 57
	mov	BYTE PTR [rax], 0
	mov	rax, QWORD PTR 2000[rbp]
	add	rax, 60
	mov	DWORD PTR [rax], 0
	mov	rax, QWORD PTR 2000[rbp]
	mov	eax, DWORD PTR 64[rax]
	mov	DWORD PTR 1688[rbp], eax
	mov	rax, QWORD PTR 2000[rbp]
	movzx	eax, WORD PTR 68[rax]
	mov	WORD PTR 1686[rbp], ax
	mov	rax, QWORD PTR 2000[rbp]
	add	rax, 64
	mov	DWORD PTR [rax], 0
	mov	rax, QWORD PTR 2000[rbp]
	add	rax, 68
	mov	WORD PTR [rax], 0
	mov	rax, QWORD PTR 1744[rbp]
	add	rax, 20
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 1744[rbp]
	add	rax, 16
	mov	eax, DWORD PTR [rax]
	mov	ecx, DWORD PTR 1724[rbp]
	mov	r9d, ecx
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 2000[rbp]
	call	_ZN3TKO7COLLECT12WALKCHILDRENERNS0_6WALKEREiij
	mov	rax, QWORD PTR 2000[rbp]
	lea	rdx, 56[rax]
	movzx	eax, BYTE PTR 1699[rbp]
	mov	BYTE PTR [rdx], al
	mov	rax, QWORD PTR 2000[rbp]
	lea	rdx, 57[rax]
	movzx	eax, BYTE PTR 1698[rbp]
	mov	BYTE PTR [rdx], al
	mov	rax, QWORD PTR 2000[rbp]
	lea	rdx, 60[rax]
	mov	eax, DWORD PTR 1692[rbp]
	mov	DWORD PTR [rdx], eax
	mov	rax, QWORD PTR 2000[rbp]
	lea	rdx, 64[rax]
	mov	eax, DWORD PTR 1688[rbp]
	mov	DWORD PTR [rdx], eax
	mov	rax, QWORD PTR 2000[rbp]
	lea	rdx, 68[rax]
	movzx	eax, WORD PTR 1686[rbp]
	mov	WORD PTR [rdx], ax
	jmp	.L3825
.L3933:
	nop
.L3559:
	cmp	QWORD PTR 1776[rbp], 61
	jne	.L3939
	nop
.L3574:
	mov	eax, DWORD PTR 2008[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 2000[rbp]
	call	_ZN3TKO7COLLECT6STMTOFERNS0_6WALKEREj
	mov	QWORD PTR 1672[rbp], rax
	mov	rax, QWORD PTR 1672[rbp]
	mov	QWORD PTR 1664[rbp], rax
	mov	rax, QWORD PTR 2000[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 2008[rbp]
	mov	rcx, rax
	call	_ZN3TKO8ASTARENA3LOCEj
	mov	DWORD PTR 1660[rbp], eax
	mov	rax, QWORD PTR 1664[rbp]
	mov	ecx, DWORD PTR [rax]
	mov	eax, DWORD PTR 2016[rbp]
	mov	edx, DWORD PTR 1660[rbp]
	mov	DWORD PTR 32[rsp], edx
	mov	r9d, 4
	mov	r8d, ecx
	mov	edx, eax
	mov	rcx, QWORD PTR 2000[rbp]
	call	_ZN3TKO7COLLECT8DECLARE_ERNS0_6WALKEREjjNS_10SYMBOLKINDEj
	mov	DWORD PTR 1656[rbp], eax
	mov	eax, DWORD PTR 1656[rbp]
	mov	DWORD PTR 1652[rbp], eax
	mov	rax, QWORD PTR 2000[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 1652[rbp]
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE8SYMBOLATEj
	mov	QWORD PTR 1640[rbp], rax
	mov	rax, QWORD PTR 1640[rbp]
	mov	QWORD PTR 1632[rbp], rax
	cmp	QWORD PTR 1632[rbp], 0
	je	.L3940
	mov	eax, DWORD PTR 2008[rbp]
	mov	rdx, QWORD PTR 1632[rbp]
	add	rdx, 40
	cdqe
	mov	QWORD PTR [rdx], rax
	mov	rax, QWORD PTR 2000[rbp]
	add	rax, 60
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 1632[rbp]
	add	rax, 48
	mov	BYTE PTR [rax], dl
	mov	rax, QWORD PTR 2000[rbp]
	add	rax, 64
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 1632[rbp]
	add	rax, 49
	mov	BYTE PTR [rax], dl
	mov	rax, QWORD PTR 1632[rbp]
	lea	rdx, 50[rax]
	mov	rax, QWORD PTR 2000[rbp]
	movzx	eax, WORD PTR 68[rax]
	mov	WORD PTR [rdx], ax
	mov	rax, QWORD PTR 2000[rbp]
	add	rax, 56
	movzx	eax, BYTE PTR [rax]
	test	al, al
	je	.L3941
	mov	rax, QWORD PTR 1632[rbp]
	add	rax, 4
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 1632[rbp]
	add	rax, 4
	or	dh, 1
	mov	DWORD PTR [rax], edx
	jmp	.L3579
.L3941:
	nop
.L3579:
	mov	rax, QWORD PTR 2000[rbp]
	add	rax, 57
	movzx	eax, BYTE PTR [rax]
	test	al, al
	je	.L3942
	mov	rax, QWORD PTR 1632[rbp]
	add	rax, 4
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 1632[rbp]
	add	rax, 4
	or	dh, 16
	mov	DWORD PTR [rax], edx
	jmp	.L3581
.L3942:
	nop
.L3581:
	mov	rax, QWORD PTR 1664[rbp]
	add	rax, 28
	mov	eax, DWORD PTR [rax]
	mov	eax, eax
	and	eax, 1024
	test	rax, rax
	je	.L3943
	mov	rax, QWORD PTR 1632[rbp]
	add	rax, 4
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 1632[rbp]
	add	rax, 4
	or	edx, 131072
	mov	DWORD PTR [rax], edx
	jmp	.L3584
.L3583:
.L3943:
	nop
.L3584:
	mov	rax, QWORD PTR 1664[rbp]
	add	rax, 28
	mov	eax, DWORD PTR [rax]
	mov	eax, eax
	and	eax, 2048
	test	rax, rax
	je	.L3944
	mov	rax, QWORD PTR 1632[rbp]
	add	rax, 4
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 1632[rbp]
	add	rax, 4
	or	edx, 262144
	mov	DWORD PTR [rax], edx
	jmp	.L3588
.L3577:
.L3586:
.L3587:
.L3940:
	nop
	jmp	.L3588
.L3944:
	nop
.L3588:
	mov	rax, QWORD PTR 2000[rbp]
	add	rax, 57
	mov	BYTE PTR [rax], 0
	mov	rax, QWORD PTR 2000[rbp]
	add	rax, 64
	mov	DWORD PTR [rax], 0
	jmp	.L3825
.L3939:
	nop
.L3575:
	cmp	QWORD PTR 1776[rbp], 62
	jne	.L3945
	nop
.L3589:
	mov	eax, DWORD PTR 2008[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 2000[rbp]
	call	_ZN3TKO7COLLECT6STMTOFERNS0_6WALKEREj
	mov	QWORD PTR 1624[rbp], rax
	mov	rax, QWORD PTR 1624[rbp]
	mov	QWORD PTR 1616[rbp], rax
	mov	rax, QWORD PTR 2000[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 2008[rbp]
	mov	rcx, rax
	call	_ZN3TKO8ASTARENA3LOCEj
	mov	DWORD PTR 1612[rbp], eax
	mov	rax, QWORD PTR 1616[rbp]
	mov	ecx, DWORD PTR [rax]
	mov	eax, DWORD PTR 2016[rbp]
	mov	edx, DWORD PTR 1612[rbp]
	mov	DWORD PTR 32[rsp], edx
	mov	r9d, 7
	mov	r8d, ecx
	mov	edx, eax
	mov	rcx, QWORD PTR 2000[rbp]
	call	_ZN3TKO7COLLECT8DECLARE_ERNS0_6WALKEREjjNS_10SYMBOLKINDEj
	mov	DWORD PTR 1608[rbp], eax
	mov	eax, DWORD PTR 1608[rbp]
	mov	DWORD PTR 1604[rbp], eax
	mov	rax, QWORD PTR 2000[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 1604[rbp]
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE8SYMBOLATEj
	mov	QWORD PTR 1592[rbp], rax
	mov	rax, QWORD PTR 1592[rbp]
	mov	QWORD PTR 1584[rbp], rax
	cmp	QWORD PTR 1584[rbp], 0
	je	.L3946
	mov	rax, QWORD PTR 1616[rbp]
	add	rax, 28
	mov	eax, DWORD PTR [rax]
	mov	eax, eax
	and	eax, 1024
	test	rax, rax
	je	.L3947
	mov	rax, QWORD PTR 1584[rbp]
	add	rax, 4
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 1584[rbp]
	add	rax, 4
	or	edx, 131072
	mov	DWORD PTR [rax], edx
	jmp	.L3595
.L3594:
.L3947:
	nop
.L3595:
	mov	rax, QWORD PTR 1616[rbp]
	add	rax, 28
	mov	eax, DWORD PTR [rax]
	mov	eax, eax
	and	eax, 2048
	test	rax, rax
	je	.L3948
	mov	rax, QWORD PTR 1584[rbp]
	add	rax, 4
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 1584[rbp]
	add	rax, 4
	or	edx, 262144
	mov	DWORD PTR [rax], edx
	jmp	.L3599
.L3592:
.L3597:
.L3598:
.L3946:
	nop
	jmp	.L3599
.L3948:
	nop
.L3599:
	mov	rax, QWORD PTR 2000[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 1604[rbp]
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE8SYMBOLATEj
	mov	QWORD PTR 1576[rbp], rax
	mov	rax, QWORD PTR 1576[rbp]
	mov	QWORD PTR 1568[rbp], rax
	mov	rax, QWORD PTR 2000[rbp]
	mov	eax, DWORD PTR 76[rax]
	mov	DWORD PTR 1564[rbp], eax
	mov	rax, QWORD PTR 2000[rbp]
	movzx	eax, BYTE PTR 80[rax]
	mov	BYTE PTR 1563[rbp], al
	mov	rax, QWORD PTR 2000[rbp]
	movzx	eax, WORD PTR 82[rax]
	mov	WORD PTR 1560[rbp], ax
	mov	rax, QWORD PTR 1616[rbp]
	add	rax, 28
	mov	eax, DWORD PTR [rax]
	mov	edx, eax
	mov	rax, QWORD PTR 2000[rbp]
	add	rax, 82
	and	dx, 3072
	mov	WORD PTR [rax], dx
	mov	rax, QWORD PTR 2000[rbp]
	add	rax, 76
	mov	DWORD PTR [rax], 0
	mov	rax, QWORD PTR 1616[rbp]
	add	rax, 28
	mov	eax, DWORD PTR [rax]
	mov	eax, eax
	and	eax, 1
	test	rax, rax
	setne	dl
	mov	rax, QWORD PTR 2000[rbp]
	add	rax, 80
	mov	BYTE PTR [rax], dl
	cmp	QWORD PTR 1568[rbp], 0
	je	.L3949
	mov	rax, QWORD PTR 2000[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	ecx, DWORD PTR 1604[rbp]
	mov	edx, DWORD PTR 2016[rbp]
	mov	r9d, ecx
	mov	r8d, edx
	mov	edx, 2
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE9OPENSCOPEENS_9SCOPEKINDEjj
	mov	DWORD PTR 1556[rbp], eax
	mov	rax, QWORD PTR 1568[rbp]
	lea	rdx, 36[rax]
	mov	eax, DWORD PTR 1556[rbp]
	mov	DWORD PTR [rdx], eax
	mov	rax, QWORD PTR 2000[rbp]
	lea	rdx, 76[rax]
	mov	rax, QWORD PTR 1568[rbp]
	mov	eax, DWORD PTR 36[rax]
	mov	DWORD PTR [rdx], eax
	mov	rax, QWORD PTR 1616[rbp]
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 2000[rbp]
	add	rax, 40
	mov	rax, QWORD PTR [rax]
	mov	ecx, DWORD PTR 2016[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9d, ecx
	mov	r8d, edx
	mov	edx, 7
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT9NAMEDTYPEENS_8TYPEKINDEjjj
	mov	DWORD PTR 1552[rbp], eax
	mov	rax, QWORD PTR 1568[rbp]
	lea	rdx, 16[rax]
	mov	eax, DWORD PTR 1552[rbp]
	mov	DWORD PTR [rdx], eax
	jmp	.L3602
.L3601:
.L3949:
	nop
.L3602:
	mov	rax, QWORD PTR 1616[rbp]
	add	rax, 20
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 1616[rbp]
	add	rax, 16
	mov	eax, DWORD PTR [rax]
	mov	ecx, DWORD PTR 2016[rbp]
	mov	r9d, ecx
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 2000[rbp]
	call	_ZN3TKO7COLLECT12WALKCHILDRENERNS0_6WALKEREiij
	mov	rax, QWORD PTR 2000[rbp]
	lea	rdx, 76[rax]
	mov	eax, DWORD PTR 1564[rbp]
	mov	DWORD PTR [rdx], eax
	mov	rax, QWORD PTR 2000[rbp]
	lea	rdx, 80[rax]
	movzx	eax, BYTE PTR 1563[rbp]
	mov	BYTE PTR [rdx], al
	mov	rax, QWORD PTR 2000[rbp]
	lea	rdx, 82[rax]
	movzx	eax, WORD PTR 1560[rbp]
	mov	WORD PTR [rdx], ax
	jmp	.L3825
.L3945:
	nop
.L3590:
	cmp	QWORD PTR 1776[rbp], 63
	jne	.L3950
	nop
.L3603:
	mov	eax, DWORD PTR 2008[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 2000[rbp]
	call	_ZN3TKO7COLLECT6STMTOFERNS0_6WALKEREj
	mov	QWORD PTR 1544[rbp], rax
	mov	rax, QWORD PTR 1544[rbp]
	mov	QWORD PTR 1536[rbp], rax
	mov	rax, QWORD PTR 2000[rbp]
	add	rax, 76
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	je	.L3951
	mov	rax, QWORD PTR 2000[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 2008[rbp]
	mov	rcx, rax
	call	_ZN3TKO8ASTARENA3LOCEj
	mov	DWORD PTR 1532[rbp], eax
	mov	rax, QWORD PTR 1536[rbp]
	mov	ecx, DWORD PTR [rax]
	mov	rax, QWORD PTR 2000[rbp]
	add	rax, 76
	mov	eax, DWORD PTR [rax]
	mov	edx, DWORD PTR 1532[rbp]
	mov	DWORD PTR 32[rsp], edx
	mov	r9d, 8
	mov	r8d, ecx
	mov	edx, eax
	mov	rcx, QWORD PTR 2000[rbp]
	call	_ZN3TKO7COLLECT8DECLARE_ERNS0_6WALKEREjjNS_10SYMBOLKINDEj
	mov	DWORD PTR 1528[rbp], eax
	mov	eax, DWORD PTR 1528[rbp]
	mov	DWORD PTR 1524[rbp], eax
	mov	rax, QWORD PTR 2000[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 1524[rbp]
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE8SYMBOLATEj
	mov	QWORD PTR 1512[rbp], rax
	mov	rax, QWORD PTR 1512[rbp]
	mov	QWORD PTR 1504[rbp], rax
	cmp	QWORD PTR 1504[rbp], 0
	je	.L3952
	mov	rax, QWORD PTR 2000[rbp]
	add	rax, 82
	movzx	eax, WORD PTR [rax]
	movzx	eax, ax
	mov	ecx, eax
	call	_ZN3TKO7COLLECT13ENUMVISFLAGS_Et
	mov	DWORD PTR 1500[rbp], eax
	mov	rax, QWORD PTR 1504[rbp]
	add	rax, 4
	mov	eax, DWORD PTR [rax]
	mov	rdx, QWORD PTR 1504[rbp]
	add	rdx, 4
	or	eax, DWORD PTR 1500[rbp]
	mov	DWORD PTR [rdx], eax
	jmp	.L3609
.L3606:
.L3608:
.L3951:
	nop
	jmp	.L3609
.L3952:
	nop
.L3609:
	mov	rax, QWORD PTR 2000[rbp]
	add	rax, 80
	movzx	eax, BYTE PTR [rax]
	movsx	eax, al
	neg	eax
	test	eax, eax
	je	.L3953
	mov	rax, QWORD PTR 2000[rbp]
	add	rax, 76
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	setne	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR 1920[rbp], rax
	jmp	.L3612
.L3953:
	nop
.L3611:
	mov	QWORD PTR 1920[rbp], 0
.L3612:
	cmp	QWORD PTR 1920[rbp], 0
	jne	.L3954
	nop
.L3614:
	mov	rax, QWORD PTR 1536[rbp]
	mov	ecx, DWORD PTR [rax]
	mov	rax, QWORD PTR 2000[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 2016[rbp]
	mov	r8d, ecx
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE11LOOKUPLOCALEjj
	mov	DWORD PTR 1496[rbp], eax
	cmp	DWORD PTR 1496[rbp], 0
	jne	.L3955
	nop
.L3616:
	mov	rax, QWORD PTR 2000[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 2008[rbp]
	mov	rcx, rax
	call	_ZN3TKO8ASTARENA3LOCEj
	mov	DWORD PTR 1492[rbp], eax
	mov	rax, QWORD PTR 1536[rbp]
	mov	ecx, DWORD PTR [rax]
	mov	eax, DWORD PTR 2016[rbp]
	mov	edx, DWORD PTR 1492[rbp]
	mov	DWORD PTR 32[rsp], edx
	mov	r9d, 8
	mov	r8d, ecx
	mov	edx, eax
	mov	rcx, QWORD PTR 2000[rbp]
	call	_ZN3TKO7COLLECT8DECLARE_ERNS0_6WALKEREjjNS_10SYMBOLKINDEj
	mov	DWORD PTR 1488[rbp], eax
	mov	eax, DWORD PTR 1488[rbp]
	mov	DWORD PTR 1484[rbp], eax
	mov	rax, QWORD PTR 2000[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 1484[rbp]
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE8SYMBOLATEj
	mov	QWORD PTR 1472[rbp], rax
	mov	rax, QWORD PTR 1472[rbp]
	mov	QWORD PTR 1464[rbp], rax
	cmp	QWORD PTR 1464[rbp], 0
	je	.L3956
	mov	rax, QWORD PTR 2000[rbp]
	add	rax, 82
	movzx	eax, WORD PTR [rax]
	movzx	eax, ax
	mov	ecx, eax
	call	_ZN3TKO7COLLECT13ENUMVISFLAGS_Et
	mov	DWORD PTR 1460[rbp], eax
	mov	rax, QWORD PTR 1464[rbp]
	add	rax, 4
	mov	eax, DWORD PTR [rax]
	mov	rdx, QWORD PTR 1464[rbp]
	add	rdx, 4
	or	eax, DWORD PTR 1460[rbp]
	mov	DWORD PTR [rdx], eax
	jmp	.L3825
.L3956:
	nop
.L3618:
	jmp	.L3825
.L3950:
	nop
.L3604:
	cmp	QWORD PTR 1776[rbp], 64
	jne	.L3957
	nop
.L3619:
	mov	eax, DWORD PTR 2008[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 2000[rbp]
	call	_ZN3TKO7COLLECT6STMTOFERNS0_6WALKEREj
	mov	QWORD PTR 1448[rbp], rax
	mov	rax, QWORD PTR 1448[rbp]
	mov	QWORD PTR 1440[rbp], rax
	mov	rax, QWORD PTR 1440[rbp]
	mov	ecx, DWORD PTR [rax]
	mov	rax, QWORD PTR 2000[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 2016[rbp]
	mov	r9d, 1
	mov	r8d, ecx
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE16LOOKUPLOCALTYPEDEjjb
	mov	DWORD PTR 1436[rbp], eax
	mov	eax, DWORD PTR 1436[rbp]
	mov	DWORD PTR 1432[rbp], eax
	mov	rax, QWORD PTR 2000[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 1432[rbp]
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE8SYMBOLATEj
	mov	QWORD PTR 1424[rbp], rax
	mov	rax, QWORD PTR 1424[rbp]
	mov	QWORD PTR 1416[rbp], rax
	cmp	QWORD PTR 1416[rbp], 0
	je	.L3958
	mov	rax, QWORD PTR 1416[rbp]
	movzx	eax, BYTE PTR [rax]
	cmp	al, 9
	jne	.L3959
	mov	rax, QWORD PTR 1440[rbp]
	add	rax, 4
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 1416[rbp]
	add	rax, 40
	mov	rax, QWORD PTR [rax]
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 2000[rbp]
	call	_ZN3TKO7COLLECT12SAMETYPEREF_ERNS0_6WALKEREjj
	mov	BYTE PTR 1415[rbp], al
	cmp	BYTE PTR 1415[rbp], 0
	je	.L3960
	mov	DWORD PTR 1916[rbp], 0
	mov	rax, QWORD PTR 1440[rbp]
	add	rax, 20
	mov	eax, DWORD PTR [rax]
	sub	eax, 1
	mov	DWORD PTR 1408[rbp], eax
	jmp	.L3625
.L3961:
	nop
.L3626:
	mov	rax, QWORD PTR 1440[rbp]
	add	rax, 16
	mov	edx, DWORD PTR [rax]
	mov	eax, DWORD PTR 1916[rbp]
	add	edx, eax
	mov	rax, QWORD PTR 2000[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	add	rax, 560
	mov	rcx, rax
	call	_ZN5ArrayIjEixEi
	mov	QWORD PTR 1400[rbp], rax
	mov	rax, QWORD PTR 1400[rbp]
	mov	eax, DWORD PTR [rax]
	mov	edx, DWORD PTR 2016[rbp]
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 2000[rbp]
	call	_ZN3TKO7COLLECT8WALKNODEERNS0_6WALKEREjj
.L3627:
	add	DWORD PTR 1916[rbp], 1
.L3625:
	mov	eax, DWORD PTR 1916[rbp]
	cmp	eax, DWORD PTR 1408[rbp]
	jle	.L3961
	nop
.L3628:
	jmp	.L3825
.L3622:
.L3629:
.L3630:
.L3631:
.L3632:
.L3958:
	nop
	jmp	.L3633
.L3959:
	nop
	jmp	.L3633
.L3960:
	nop
.L3633:
	mov	rax, QWORD PTR 2000[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 2008[rbp]
	mov	rcx, rax
	call	_ZN3TKO8ASTARENA3LOCEj
	mov	DWORD PTR 1396[rbp], eax
	mov	rax, QWORD PTR 1440[rbp]
	mov	ecx, DWORD PTR [rax]
	mov	eax, DWORD PTR 2016[rbp]
	mov	edx, DWORD PTR 1396[rbp]
	mov	DWORD PTR 32[rsp], edx
	mov	r9d, 9
	mov	r8d, ecx
	mov	edx, eax
	mov	rcx, QWORD PTR 2000[rbp]
	call	_ZN3TKO7COLLECT8DECLARE_ERNS0_6WALKEREjjNS_10SYMBOLKINDEj
	mov	DWORD PTR 1392[rbp], eax
	mov	eax, DWORD PTR 1392[rbp]
	mov	DWORD PTR 1388[rbp], eax
	mov	rax, QWORD PTR 2000[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 1388[rbp]
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE8SYMBOLATEj
	mov	QWORD PTR 1376[rbp], rax
	mov	rax, QWORD PTR 1376[rbp]
	mov	QWORD PTR 1368[rbp], rax
	cmp	QWORD PTR 1368[rbp], 0
	je	.L3962
	mov	rax, QWORD PTR 1440[rbp]
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 2000[rbp]
	add	rax, 40
	mov	rax, QWORD PTR [rax]
	mov	ecx, DWORD PTR 2016[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9d, ecx
	mov	r8d, edx
	mov	edx, 8
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT9NAMEDTYPEENS_8TYPEKINDEjjj
	mov	DWORD PTR 1364[rbp], eax
	mov	rax, QWORD PTR 1368[rbp]
	lea	rdx, 16[rax]
	mov	eax, DWORD PTR 1364[rbp]
	mov	DWORD PTR [rdx], eax
	mov	rax, QWORD PTR 1440[rbp]
	add	rax, 4
	mov	eax, DWORD PTR [rax]
	mov	rdx, QWORD PTR 1368[rbp]
	add	rdx, 40
	cdqe
	mov	QWORD PTR [rdx], rax
	jmp	.L3636
.L3635:
.L3962:
	nop
.L3636:
	mov	DWORD PTR 1912[rbp], 0
	mov	rax, QWORD PTR 1440[rbp]
	add	rax, 20
	mov	eax, DWORD PTR [rax]
	sub	eax, 1
	mov	DWORD PTR 1360[rbp], eax
	jmp	.L3637
.L3963:
	nop
.L3638:
	mov	rax, QWORD PTR 1440[rbp]
	add	rax, 16
	mov	edx, DWORD PTR [rax]
	mov	eax, DWORD PTR 1912[rbp]
	add	edx, eax
	mov	rax, QWORD PTR 2000[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	add	rax, 560
	mov	rcx, rax
	call	_ZN5ArrayIjEixEi
	mov	QWORD PTR 1352[rbp], rax
	mov	rax, QWORD PTR 1352[rbp]
	mov	eax, DWORD PTR [rax]
	mov	edx, DWORD PTR 2016[rbp]
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 2000[rbp]
	call	_ZN3TKO7COLLECT8WALKNODEERNS0_6WALKEREjj
.L3639:
	add	DWORD PTR 1912[rbp], 1
.L3637:
	mov	eax, DWORD PTR 1912[rbp]
	cmp	eax, DWORD PTR 1360[rbp]
	jle	.L3963
	nop
.L3640:
	jmp	.L3825
.L3957:
	nop
.L3620:
	cmp	QWORD PTR 1776[rbp], 65
	jne	.L3964
	nop
.L3641:
	mov	eax, DWORD PTR 2008[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 2000[rbp]
	call	_ZN3TKO7COLLECT6STMTOFERNS0_6WALKEREj
	mov	QWORD PTR 1344[rbp], rax
	mov	rax, QWORD PTR 1344[rbp]
	mov	QWORD PTR 1336[rbp], rax
	mov	rax, QWORD PTR 1336[rbp]
	add	rax, 24
	movzx	eax, WORD PTR [rax]
	cmp	ax, 88
	je	.L3965
	mov	rax, QWORD PTR 1336[rbp]
	add	rax, 24
	movzx	eax, WORD PTR [rax]
	cmp	ax, 128
	sete	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR 1904[rbp], rax
	jmp	.L3645
.L3965:
	nop
.L3644:
	mov	QWORD PTR 1904[rbp], -1
.L3645:
	cmp	QWORD PTR 1904[rbp], 0
	setne	al
	mov	BYTE PTR 1335[rbp], al
	mov	rax, QWORD PTR 1760[rbp]
	add	rax, 2
	movzx	eax, WORD PTR [rax]
	test	ax, ax
	js	.L3966
	movsx	eax, BYTE PTR 1335[rbp]
	neg	eax
	test	eax, eax
	setne	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR 1896[rbp], rax
	jmp	.L3648
.L3966:
	nop
.L3647:
	mov	QWORD PTR 1896[rbp], -1
.L3648:
	cmp	QWORD PTR 1896[rbp], 0
	setne	al
	mov	BYTE PTR 1334[rbp], al
	mov	rax, QWORD PTR 1336[rbp]
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR 1876[rbp], eax
	cmp	BYTE PTR 1335[rbp], 0
	je	.L3967
	mov	rax, QWORD PTR 1336[rbp]
	add	rax, 24
	movzx	eax, WORD PTR [rax]
	cmp	ax, 88
	jne	.L3968
	lea	rax, 272[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	lea	rax, 272[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9d, 7
	lea	r8, .LC2[rip]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrAssign
	mov	rax, QWORD PTR 2000[rbp]
	add	rax, 32
	mov	rax, QWORD PTR [rax]
	lea	rdx, 272[rbp]
	mov	rcx, rax
	call	_ZN3TKO8INTERNER9GETSTRINGE8FBSTRING
	mov	DWORD PTR 1328[rbp], eax
	mov	rax, QWORD PTR 2000[rbp]
	add	rax, 32
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 1328[rbp]
	mov	rcx, rax
	call	_ZN3TKO8INTERNER4FOLDEj
	mov	DWORD PTR 1324[rbp], eax
	mov	eax, DWORD PTR 1324[rbp]
	mov	DWORD PTR 1876[rbp], eax
	lea	rax, 272[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	jmp	.L3654
.L3968:
	nop
.L3652:
	lea	rax, 240[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	lea	rax, 240[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9d, 7
	lea	r8, .LC3[rip]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrAssign
	mov	rax, QWORD PTR 2000[rbp]
	add	rax, 32
	mov	rax, QWORD PTR [rax]
	lea	rdx, 240[rbp]
	mov	rcx, rax
	call	_ZN3TKO8INTERNER9GETSTRINGE8FBSTRING
	mov	DWORD PTR 1320[rbp], eax
	mov	rax, QWORD PTR 2000[rbp]
	add	rax, 32
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 1320[rbp]
	mov	rcx, rax
	call	_ZN3TKO8INTERNER4FOLDEj
	mov	DWORD PTR 1316[rbp], eax
	mov	eax, DWORD PTR 1316[rbp]
	mov	DWORD PTR 1876[rbp], eax
	lea	rax, 240[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	jmp	.L3654
.L3650:
.L3653:
.L3967:
	nop
.L3654:
	mov	DWORD PTR 1872[rbp], 0
	cmp	BYTE PTR 1334[rbp], 0
	jne	.L3969
	mov	rax, QWORD PTR 1336[rbp]
	add	rax, 8
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	je	.L3970
	mov	rax, QWORD PTR 1336[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 2000[rbp]
	call	_ZN3TKO7COLLECT9PROCARITYERNS0_6WALKEREPNS_11STMTPAYLOADE
	mov	DWORD PTR 1312[rbp], eax
	mov	ecx, DWORD PTR 1312[rbp]
	mov	edx, DWORD PTR 1876[rbp]
	mov	eax, DWORD PTR 2016[rbp]
	mov	r9d, ecx
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 2000[rbp]
	call	_ZN3TKO7COLLECT22UNDEFINEDPROCWITHARITYERNS0_6WALKEREjji
	mov	DWORD PTR 1308[rbp], eax
	mov	eax, DWORD PTR 1308[rbp]
	mov	DWORD PTR 1872[rbp], eax
	jmp	.L3659
.L3658:
.L3970:
	nop
.L3659:
	cmp	DWORD PTR 1872[rbp], 0
	jne	.L3971
	mov	rax, QWORD PTR 2000[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 2008[rbp]
	mov	rcx, rax
	call	_ZN3TKO8ASTARENA3LOCEj
	mov	DWORD PTR 1304[rbp], eax
	mov	ecx, DWORD PTR 1876[rbp]
	mov	eax, DWORD PTR 2016[rbp]
	mov	edx, DWORD PTR 1304[rbp]
	mov	DWORD PTR 32[rsp], edx
	mov	r9d, 5
	mov	r8d, ecx
	mov	edx, eax
	mov	rcx, QWORD PTR 2000[rbp]
	call	_ZN3TKO7COLLECT8DECLARE_ERNS0_6WALKEREjjNS_10SYMBOLKINDEj
	mov	DWORD PTR 1300[rbp], eax
	mov	eax, DWORD PTR 1300[rbp]
	mov	DWORD PTR 1872[rbp], eax
	jmp	.L3663
.L3656:
.L3661:
.L3662:
.L3969:
	nop
	jmp	.L3663
.L3971:
	nop
.L3663:
	mov	ecx, DWORD PTR 2008[rbp]
	mov	edx, DWORD PTR 1876[rbp]
	mov	eax, DWORD PTR 2016[rbp]
	mov	r9d, ecx
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 2000[rbp]
	call	_ZN3TKO7COLLECT19SPREADOVERLOADFLAG_ERNS0_6WALKEREjjj
	mov	rax, QWORD PTR 2000[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 1872[rbp]
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE8SYMBOLATEj
	mov	QWORD PTR 1288[rbp], rax
	mov	rax, QWORD PTR 1288[rbp]
	mov	QWORD PTR 1864[rbp], rax
	cmp	QWORD PTR 1864[rbp], 0
	je	.L3972
	mov	rax, QWORD PTR 1336[rbp]
	add	rax, 8
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	jne	.L3973
	mov	rax, QWORD PTR 1864[rbp]
	add	rax, 4
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 1864[rbp]
	add	rax, 4
	or	edx, 16
	mov	DWORD PTR [rax], edx
	jmp	.L3668
.L3973:
	nop
.L3667:
	mov	rax, QWORD PTR 1864[rbp]
	add	rax, 4
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 1864[rbp]
	add	rax, 4
	or	edx, 32
	mov	DWORD PTR [rax], edx
.L3668:
	mov	rax, QWORD PTR 1864[rbp]
	add	rax, 40
	mov	rax, QWORD PTR [rax]
	test	rax, rax
	sete	al
	mov	BYTE PTR 1287[rbp], al
	cmp	BYTE PTR 1287[rbp], 0
	je	.L3974
	mov	eax, DWORD PTR 2008[rbp]
	mov	rdx, QWORD PTR 1864[rbp]
	add	rdx, 40
	cdqe
	mov	QWORD PTR [rdx], rax
	jmp	.L3670
.L3974:
	nop
.L3670:
	movsx	edx, BYTE PTR 1287[rbp]
	mov	r8d, DWORD PTR 2008[rbp]
	mov	rcx, QWORD PTR 1336[rbp]
	mov	rax, QWORD PTR 1864[rbp]
	mov	DWORD PTR 32[rsp], edx
	mov	r9d, r8d
	mov	r8, rcx
	mov	rdx, rax
	mov	rcx, QWORD PTR 2000[rbp]
	call	_ZN3TKO7COLLECT12BINDCALLCONVERNS0_6WALKEREPNS_6SYMBOLEPNS_11STMTPAYLOADEjb
	mov	rax, QWORD PTR 1336[rbp]
	add	rax, 28
	mov	eax, DWORD PTR [rax]
	mov	eax, eax
	and	eax, 1024
	test	rax, rax
	je	.L3975
	mov	rax, QWORD PTR 1864[rbp]
	add	rax, 4
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 1864[rbp]
	add	rax, 4
	or	edx, 131072
	mov	DWORD PTR [rax], edx
	jmp	.L3673
.L3672:
.L3975:
	nop
.L3673:
	mov	rax, QWORD PTR 1336[rbp]
	add	rax, 28
	mov	eax, DWORD PTR [rax]
	mov	eax, eax
	and	eax, 2048
	test	rax, rax
	je	.L3976
	mov	rax, QWORD PTR 1864[rbp]
	add	rax, 4
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 1864[rbp]
	add	rax, 4
	or	edx, 262144
	mov	DWORD PTR [rax], edx
	jmp	.L3677
.L3665:
.L3675:
.L3676:
.L3972:
	nop
	jmp	.L3677
.L3976:
	nop
.L3677:
	mov	eax, DWORD PTR 2016[rbp]
	mov	DWORD PTR 1860[rbp], eax
	cmp	BYTE PTR 1334[rbp], 0
	je	.L3977
	mov	rax, QWORD PTR 1336[rbp]
	mov	eax, DWORD PTR 36[rax]
	mov	DWORD PTR 1856[rbp], eax
	cmp	BYTE PTR 1335[rbp], 0
	je	.L3978
	mov	rax, QWORD PTR 1336[rbp]
	add	rax, 36
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	jne	.L3979
	mov	rax, QWORD PTR 1336[rbp]
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR 1856[rbp], eax
	jmp	.L3685
.L3979:
	nop
.L3683:
	lea	rax, 144[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	rax, QWORD PTR 1336[rbp]
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 2000[rbp]
	add	rax, 32
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN3TKO8INTERNER8SPELLINGEj
	mov	QWORD PTR 1272[rbp], rax
	mov	rax, QWORD PTR 1336[rbp]
	add	rax, 36
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 2000[rbp]
	add	rax, 32
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN3TKO8INTERNER8SPELLINGEj
	mov	QWORD PTR 1264[rbp], rax
	lea	rax, 208[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	rdx, QWORD PTR 1264[rbp]
	lea	rax, 208[rbp]
	mov	QWORD PTR 32[rsp], 2
	lea	r9, .LC4[rip]
	mov	r8, -1
	mov	rcx, rax
	call	fb_StrConcat
	mov	QWORD PTR 1256[rbp], rax
	lea	rax, 176[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	rcx, QWORD PTR 1272[rbp]
	mov	rdx, QWORD PTR 1256[rbp]
	lea	rax, 176[rbp]
	mov	QWORD PTR 32[rsp], -1
	mov	r9, rcx
	mov	r8, -1
	mov	rcx, rax
	call	fb_StrConcat
	mov	QWORD PTR 1248[rbp], rax
	mov	rdx, QWORD PTR 1248[rbp]
	lea	rax, 144[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrAssign
	mov	rax, QWORD PTR 2000[rbp]
	add	rax, 32
	mov	rax, QWORD PTR [rax]
	lea	rdx, 144[rbp]
	mov	rcx, rax
	call	_ZN3TKO8INTERNER9GETSTRINGE8FBSTRING
	mov	DWORD PTR 1244[rbp], eax
	mov	eax, DWORD PTR 1244[rbp]
	mov	DWORD PTR 1856[rbp], eax
	lea	rax, 144[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	jmp	.L3685
.L3681:
.L3684:
.L3978:
	nop
.L3685:
	cmp	DWORD PTR 1856[rbp], 0
	je	.L3980
	mov	edx, DWORD PTR 1856[rbp]
	mov	eax, DWORD PTR 2016[rbp]
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 2000[rbp]
	call	_ZN3TKO7COLLECT18LOOKUPDOTTEDOWNER_ERNS0_6WALKEREjj
	mov	DWORD PTR 1240[rbp], eax
	mov	eax, DWORD PTR 1240[rbp]
	mov	DWORD PTR 1236[rbp], eax
	mov	rax, QWORD PTR 2000[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 1236[rbp]
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE8SYMBOLATEj
	mov	QWORD PTR 1224[rbp], rax
	mov	rax, QWORD PTR 1224[rbp]
	mov	QWORD PTR 1216[rbp], rax
	mov	BYTE PTR 1853[rbp], 0
	cmp	QWORD PTR 1216[rbp], 0
	je	.L3981
	mov	rax, QWORD PTR 1216[rbp]
	movzx	eax, BYTE PTR [rax]
	cmp	al, 6
	sete	al
	mov	BYTE PTR 1853[rbp], al
	jmp	.L3689
.L3688:
.L3981:
	nop
.L3689:
	cmp	QWORD PTR 1216[rbp], 0
	setne	al
	movzx	eax, al
	neg	eax
	test	eax, eax
	setne	al
	mov	BYTE PTR 1215[rbp], al
	cmp	BYTE PTR 1215[rbp], 0
	je	.L3982
	cmp	BYTE PTR 1335[rbp], 0
	setne	al
	mov	BYTE PTR 1855[rbp], al
	jmp	.L3692
.L3982:
	nop
.L3691:
	mov	BYTE PTR 1855[rbp], 0
.L3692:
	cmp	BYTE PTR 1855[rbp], 0
	je	.L3983
	cmp	BYTE PTR 1853[rbp], 0
	sete	al
	mov	BYTE PTR 1854[rbp], al
	jmp	.L3695
.L3983:
	nop
.L3694:
	mov	BYTE PTR 1854[rbp], 0
.L3695:
	movzx	eax, BYTE PTR 1854[rbp]
	mov	BYTE PTR 1214[rbp], al
	cmp	BYTE PTR 1214[rbp], 0
	je	.L3984
	lea	rax, 48[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	lea	rax, 48[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9d, 1
	lea	r8, .LC0[rip]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrAssign
	lea	rax, 80[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	lea	rax, 80[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9d, 1
	lea	r8, .LC0[rip]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrAssign
	lea	rax, 112[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	rax, QWORD PTR 2000[rbp]
	add	rax, 32
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 1856[rbp]
	mov	rcx, rax
	call	_ZN3TKO8INTERNER8SPELLINGEj
	mov	QWORD PTR 1200[rbp], rax
	mov	rdx, QWORD PTR 1200[rbp]
	lea	rax, 112[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrAssign
	mov	rax, QWORD PTR 2000[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 2008[rbp]
	mov	rcx, rax
	call	_ZN3TKO8ASTARENA3LOCEj
	mov	DWORD PTR 1196[rbp], eax
	mov	eax, DWORD PTR 1196[rbp]
	mov	ecx, eax
	call	_ZN3TKO10POINTRANGEEj
	mov	QWORD PTR 40[rbp], rax
	mov	rax, QWORD PTR 2000[rbp]
	add	rax, 24
	mov	rax, QWORD PTR [rax]
	lea	r8, 112[rbp]
	mov	rcx, QWORD PTR 40[rbp]
	lea	rdx, 48[rbp]
	mov	QWORD PTR 40[rsp], rdx
	lea	rdx, 80[rbp]
	mov	QWORD PTR 32[rsp], rdx
	mov	r9, r8
	mov	r8, rcx
	mov	edx, 44
	mov	rcx, rax
	call	_ZN3TKO16DIAGNOSTICENGINE6REPORTENS_6DIAGIDENS_11SOURCERANGEE8FBSTRINGS3_S3_
	lea	rax, 48[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	lea	rax, 80[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	lea	rax, 112[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	jmp	.L3707
.L3984:
	nop
.L3697:
	cmp	BYTE PTR 1215[rbp], 0
	je	.L3985
	mov	rax, QWORD PTR 1216[rbp]
	add	rax, 36
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	je	.L3986
	mov	rax, QWORD PTR 1216[rbp]
	mov	eax, DWORD PTR 36[rax]
	mov	DWORD PTR 1860[rbp], eax
	jmp	.L3707
.L3986:
	nop
.L3701:
	jmp	.L3707
.L3985:
	nop
.L3699:
	cmp	BYTE PTR 1335[rbp], 0
	je	.L3987
	lea	rax, -48[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	lea	rax, -48[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9d, 1
	lea	r8, .LC0[rip]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrAssign
	lea	rax, -16[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	lea	rax, -16[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9d, 1
	lea	r8, .LC0[rip]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrAssign
	lea	rax, 16[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	rax, QWORD PTR 2000[rbp]
	add	rax, 32
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 1856[rbp]
	mov	rcx, rax
	call	_ZN3TKO8INTERNER8SPELLINGEj
	mov	QWORD PTR 1184[rbp], rax
	mov	rdx, QWORD PTR 1184[rbp]
	lea	rax, 16[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrAssign
	mov	rax, QWORD PTR 2000[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 2008[rbp]
	mov	rcx, rax
	call	_ZN3TKO8ASTARENA3LOCEj
	mov	DWORD PTR 1180[rbp], eax
	mov	eax, DWORD PTR 1180[rbp]
	mov	ecx, eax
	call	_ZN3TKO10POINTRANGEEj
	mov	QWORD PTR -56[rbp], rax
	mov	rax, QWORD PTR 2000[rbp]
	add	rax, 24
	mov	rax, QWORD PTR [rax]
	lea	r8, 16[rbp]
	mov	rcx, QWORD PTR -56[rbp]
	lea	rdx, -48[rbp]
	mov	QWORD PTR 40[rsp], rdx
	lea	rdx, -16[rbp]
	mov	QWORD PTR 32[rsp], rdx
	mov	r9, r8
	mov	r8, rcx
	mov	edx, 44
	mov	rcx, rax
	call	_ZN3TKO16DIAGNOSTICENGINE6REPORTENS_6DIAGIDENS_11SOURCERANGEE8FBSTRINGS3_S3_
	lea	rax, -48[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	lea	rax, -16[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	lea	rax, 16[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	jmp	.L3707
.L3679:
.L3703:
.L3704:
.L3705:
.L3706:
.L3977:
	nop
	jmp	.L3707
.L3980:
	nop
	jmp	.L3707
.L3987:
	nop
.L3707:
	movsx	eax, BYTE PTR 1335[rbp]
	neg	eax
	test	eax, eax
	je	.L3988
	cmp	DWORD PTR 1872[rbp], 0
	sete	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR 1888[rbp], rax
	jmp	.L3710
.L3988:
	nop
.L3709:
	mov	QWORD PTR 1888[rbp], 0
.L3710:
	cmp	QWORD PTR 1888[rbp], 0
	je	.L3989
	mov	rax, QWORD PTR 1336[rbp]
	add	rax, 8
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	jne	.L3990
	mov	rax, QWORD PTR 2000[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 2008[rbp]
	mov	rcx, rax
	call	_ZN3TKO8ASTARENA3LOCEj
	mov	DWORD PTR 1176[rbp], eax
	mov	ecx, DWORD PTR 1876[rbp]
	mov	eax, DWORD PTR 1860[rbp]
	mov	edx, DWORD PTR 1176[rbp]
	mov	DWORD PTR 32[rsp], edx
	mov	r9d, 5
	mov	r8d, ecx
	mov	edx, eax
	mov	rcx, QWORD PTR 2000[rbp]
	call	_ZN3TKO7COLLECT8DECLARE_ERNS0_6WALKEREjjNS_10SYMBOLKINDEj
	mov	DWORD PTR 1172[rbp], eax
	mov	eax, DWORD PTR 1172[rbp]
	mov	DWORD PTR 1872[rbp], eax
	jmp	.L3718
.L3990:
	nop
.L3714:
	mov	rcx, QWORD PTR 1336[rbp]
	mov	edx, DWORD PTR 1876[rbp]
	mov	eax, DWORD PTR 1860[rbp]
	mov	r9, rcx
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 2000[rbp]
	call	_ZN3TKO7COLLECT17MEMBERDECLFORDEF_ERNS0_6WALKEREjjPNS_11STMTPAYLOADE
	mov	DWORD PTR 1168[rbp], eax
	mov	eax, DWORD PTR 1168[rbp]
	mov	DWORD PTR 1872[rbp], eax
	cmp	DWORD PTR 1872[rbp], 0
	jne	.L3991
	mov	rax, QWORD PTR 2000[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 2008[rbp]
	mov	rcx, rax
	call	_ZN3TKO8ASTARENA3LOCEj
	mov	DWORD PTR 1164[rbp], eax
	mov	ecx, DWORD PTR 1876[rbp]
	mov	eax, DWORD PTR 1860[rbp]
	mov	edx, DWORD PTR 1164[rbp]
	mov	DWORD PTR 32[rsp], edx
	mov	r9d, 5
	mov	r8d, ecx
	mov	edx, eax
	mov	rcx, QWORD PTR 2000[rbp]
	call	_ZN3TKO7COLLECT8DECLARE_ERNS0_6WALKEREjjNS_10SYMBOLKINDEj
	mov	DWORD PTR 1160[rbp], eax
	mov	eax, DWORD PTR 1160[rbp]
	mov	DWORD PTR 1872[rbp], eax
	jmp	.L3718
.L3715:
.L3717:
.L3991:
	nop
.L3718:
	mov	rax, QWORD PTR 2000[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 1872[rbp]
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE8SYMBOLATEj
	mov	QWORD PTR 1152[rbp], rax
	mov	rax, QWORD PTR 1152[rbp]
	mov	QWORD PTR 1864[rbp], rax
	cmp	QWORD PTR 1864[rbp], 0
	je	.L3992
	mov	rax, QWORD PTR 1864[rbp]
	add	rax, 40
	mov	rax, QWORD PTR [rax]
	test	rax, rax
	sete	al
	movzx	edx, al
	mov	r8d, DWORD PTR 2008[rbp]
	mov	rcx, QWORD PTR 1336[rbp]
	mov	rax, QWORD PTR 1864[rbp]
	mov	DWORD PTR 32[rsp], edx
	mov	r9d, r8d
	mov	r8, rcx
	mov	rdx, rax
	mov	rcx, QWORD PTR 2000[rbp]
	call	_ZN3TKO7COLLECT12BINDCALLCONVERNS0_6WALKEREPNS_6SYMBOLEPNS_11STMTPAYLOADEjb
	mov	rax, QWORD PTR 1864[rbp]
	add	rax, 4
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 1864[rbp]
	add	rax, 4
	or	edx, 32
	mov	DWORD PTR [rax], edx
	mov	rax, QWORD PTR 1336[rbp]
	add	rax, 28
	mov	eax, DWORD PTR [rax]
	mov	eax, eax
	and	eax, 1024
	test	rax, rax
	je	.L3993
	mov	rax, QWORD PTR 1864[rbp]
	add	rax, 4
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 1864[rbp]
	add	rax, 4
	or	edx, 131072
	mov	DWORD PTR [rax], edx
	jmp	.L3722
.L3721:
.L3993:
	nop
.L3722:
	mov	rax, QWORD PTR 1336[rbp]
	add	rax, 28
	mov	eax, DWORD PTR [rax]
	mov	eax, eax
	and	eax, 2048
	test	rax, rax
	je	.L3994
	mov	rax, QWORD PTR 1864[rbp]
	add	rax, 4
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 1864[rbp]
	add	rax, 4
	or	edx, 262144
	mov	DWORD PTR [rax], edx
	jmp	.L3725
.L3724:
.L3994:
	nop
.L3725:
	mov	rax, QWORD PTR 1864[rbp]
	add	rax, 40
	mov	rax, QWORD PTR [rax]
	test	rax, rax
	jne	.L3995
	mov	eax, DWORD PTR 2008[rbp]
	mov	rdx, QWORD PTR 1864[rbp]
	add	rdx, 40
	cdqe
	mov	QWORD PTR [rdx], rax
	jmp	.L3730
.L3712:
.L3727:
.L3728:
.L3729:
.L3989:
	nop
	jmp	.L3730
.L3992:
	nop
	jmp	.L3730
.L3995:
	nop
.L3730:
	mov	eax, DWORD PTR 1872[rbp]
	mov	DWORD PTR 1848[rbp], eax
	cmp	DWORD PTR 1848[rbp], 0
	jne	.L3996
	cmp	DWORD PTR 1876[rbp], 0
	setne	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR 1880[rbp], rax
	jmp	.L3733
.L3996:
	nop
.L3732:
	mov	QWORD PTR 1880[rbp], 0
.L3733:
	cmp	QWORD PTR 1880[rbp], 0
	je	.L3997
	mov	rcx, QWORD PTR 1336[rbp]
	mov	edx, DWORD PTR 1876[rbp]
	mov	eax, DWORD PTR 1860[rbp]
	mov	r9, rcx
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 2000[rbp]
	call	_ZN3TKO7COLLECT17MEMBERDECLFORDEF_ERNS0_6WALKEREjjPNS_11STMTPAYLOADE
	mov	DWORD PTR 1148[rbp], eax
	mov	eax, DWORD PTR 1148[rbp]
	mov	DWORD PTR 1848[rbp], eax
	jmp	.L3736
.L3735:
.L3997:
	nop
.L3736:
	mov	rax, QWORD PTR 2000[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	ecx, DWORD PTR 1848[rbp]
	mov	edx, DWORD PTR 1860[rbp]
	mov	r9d, ecx
	mov	r8d, edx
	mov	edx, 4
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE9OPENSCOPEENS_9SCOPEKINDEjj
	mov	DWORD PTR 1144[rbp], eax
	mov	eax, DWORD PTR 1144[rbp]
	mov	DWORD PTR 1140[rbp], eax
	cmp	QWORD PTR 1864[rbp], 0
	je	.L3998
	mov	rax, QWORD PTR 1864[rbp]
	lea	rdx, 36[rax]
	mov	eax, DWORD PTR 1140[rbp]
	mov	DWORD PTR [rdx], eax
	jmp	.L3743
.L3998:
	nop
.L3738:
	cmp	DWORD PTR 1848[rbp], 0
	je	.L3999
	mov	rax, QWORD PTR 2000[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 1848[rbp]
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE8SYMBOLATEj
	mov	QWORD PTR 1128[rbp], rax
	mov	rax, QWORD PTR 1128[rbp]
	mov	QWORD PTR 1120[rbp], rax
	cmp	QWORD PTR 1120[rbp], 0
	je	.L4000
	mov	rax, QWORD PTR 1120[rbp]
	lea	rdx, 36[rax]
	mov	eax, DWORD PTR 1140[rbp]
	mov	DWORD PTR [rdx], eax
	jmp	.L3743
.L3739:
.L3742:
.L3999:
	nop
	jmp	.L3743
.L4000:
	nop
.L3743:
	cmp	BYTE PTR 1334[rbp], 0
	je	.L4001
	mov	rax, QWORD PTR 2000[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 2008[rbp]
	mov	rcx, rax
	call	_ZN3TKO8ASTARENA3LOCEj
	mov	DWORD PTR 1116[rbp], eax
	lea	rax, -80[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	lea	rax, -80[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9d, 5
	lea	r8, .LC5[rip]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrAssign
	mov	rax, QWORD PTR 2000[rbp]
	add	rax, 32
	mov	rax, QWORD PTR [rax]
	lea	rdx, -80[rbp]
	mov	rcx, rax
	call	_ZN3TKO8INTERNER9GETSTRINGE8FBSTRING
	mov	DWORD PTR 1112[rbp], eax
	mov	rax, QWORD PTR 2000[rbp]
	add	rax, 32
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 1112[rbp]
	mov	rcx, rax
	call	_ZN3TKO8INTERNER4FOLDEj
	mov	DWORD PTR 1108[rbp], eax
	mov	ecx, DWORD PTR 1108[rbp]
	mov	eax, DWORD PTR 1140[rbp]
	mov	edx, DWORD PTR 1116[rbp]
	mov	DWORD PTR 32[rsp], edx
	mov	r9d, 2
	mov	r8d, ecx
	mov	edx, eax
	mov	rcx, QWORD PTR 2000[rbp]
	call	_ZN3TKO7COLLECT8DECLARE_ERNS0_6WALKEREjjNS_10SYMBOLKINDEj
	lea	rax, -80[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	jmp	.L3746
.L3745:
.L4001:
	nop
.L3746:
	mov	rax, QWORD PTR 2000[rbp]
	add	rax, 48
	mov	rax, QWORD PTR [rax]
	mov	ecx, DWORD PTR 1140[rbp]
	mov	edx, DWORD PTR 2008[rbp]
	mov	r8d, ecx
	mov	rcx, rax
	call	_ZN3TKO12SEMANTICINFO8SETSCOPEEjj
	cmp	DWORD PTR 1848[rbp], 0
	je	.L4002
	mov	rax, QWORD PTR 2000[rbp]
	add	rax, 48
	mov	rax, QWORD PTR [rax]
	mov	ecx, DWORD PTR 1848[rbp]
	mov	edx, DWORD PTR 2008[rbp]
	mov	r8d, ecx
	mov	rcx, rax
	call	_ZN3TKO12SEMANTICINFO6SETREFEjj
	jmp	.L3748
.L4002:
	nop
.L3748:
	mov	rax, QWORD PTR 2000[rbp]
	movzx	eax, BYTE PTR 70[rax]
	mov	BYTE PTR 1107[rbp], al
	mov	rax, QWORD PTR 1336[rbp]
	add	rax, 8
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	sete	dl
	mov	rax, QWORD PTR 2000[rbp]
	add	rax, 70
	mov	BYTE PTR [rax], dl
	mov	rax, QWORD PTR 1336[rbp]
	add	rax, 20
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 1336[rbp]
	add	rax, 16
	mov	eax, DWORD PTR [rax]
	mov	ecx, DWORD PTR 1140[rbp]
	mov	r9d, ecx
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 2000[rbp]
	call	_ZN3TKO7COLLECT12WALKCHILDRENERNS0_6WALKEREiij
	mov	rax, QWORD PTR 2000[rbp]
	lea	rdx, 70[rax]
	movzx	eax, BYTE PTR 1107[rbp]
	mov	BYTE PTR [rdx], al
	mov	rax, QWORD PTR 1336[rbp]
	add	rax, 8
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	je	.L4003
	mov	rax, QWORD PTR 1336[rbp]
	add	rax, 8
	mov	eax, DWORD PTR [rax]
	mov	edx, DWORD PTR 1140[rbp]
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 2000[rbp]
	call	_ZN3TKO7COLLECT8WALKNODEERNS0_6WALKEREjj
	jmp	.L3825
.L4003:
	nop
.L3750:
	jmp	.L3825
.L3964:
	nop
.L3642:
	cmp	QWORD PTR 1776[rbp], 66
	jne	.L4004
	nop
.L3751:
	mov	eax, DWORD PTR 2008[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 2000[rbp]
	call	_ZN3TKO7COLLECT6STMTOFERNS0_6WALKEREj
	mov	QWORD PTR 1096[rbp], rax
	mov	rax, QWORD PTR 1096[rbp]
	mov	QWORD PTR 1088[rbp], rax
	mov	DWORD PTR 1844[rbp], 0
	mov	rax, QWORD PTR 2000[rbp]
	add	rax, 70
	movzx	eax, BYTE PTR [rax]
	test	al, al
	je	.L4005
	mov	rax, QWORD PTR 1088[rbp]
	mov	ecx, DWORD PTR [rax]
	mov	rax, QWORD PTR 2000[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 2016[rbp]
	mov	r9d, 0
	mov	r8d, ecx
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE16LOOKUPLOCALTYPEDEjjb
	mov	DWORD PTR 1084[rbp], eax
	mov	eax, DWORD PTR 1084[rbp]
	mov	DWORD PTR 1844[rbp], eax
	jmp	.L3755
.L3754:
.L4005:
	nop
.L3755:
	cmp	DWORD PTR 1844[rbp], 0
	je	.L4006
	mov	rax, QWORD PTR 2000[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 1844[rbp]
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE8SYMBOLATEj
	mov	QWORD PTR 1072[rbp], rax
	mov	rax, QWORD PTR 1072[rbp]
	mov	QWORD PTR 1064[rbp], rax
	cmp	QWORD PTR 1064[rbp], 0
	je	.L4007
	mov	rax, QWORD PTR 1064[rbp]
	movzx	eax, BYTE PTR [rax]
	cmp	al, 2
	jne	.L4008
	mov	eax, DWORD PTR 2008[rbp]
	mov	rdx, QWORD PTR 1064[rbp]
	add	rdx, 40
	cdqe
	mov	QWORD PTR [rdx], rax
	mov	rax, QWORD PTR 2000[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 2008[rbp]
	mov	rcx, rax
	call	_ZN3TKO8ASTARENA3LOCEj
	mov	DWORD PTR 1060[rbp], eax
	mov	rax, QWORD PTR 1064[rbp]
	lea	rdx, 20[rax]
	mov	eax, DWORD PTR 1060[rbp]
	mov	DWORD PTR [rdx], eax
	jmp	.L3825
.L3757:
.L3760:
.L3761:
.L3762:
.L3763:
.L4006:
	nop
	jmp	.L3764
.L4007:
	nop
	jmp	.L3764
.L4008:
	nop
.L3764:
	mov	rax, QWORD PTR 2000[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 2008[rbp]
	mov	rcx, rax
	call	_ZN3TKO8ASTARENA3LOCEj
	mov	DWORD PTR 1056[rbp], eax
	mov	rax, QWORD PTR 1088[rbp]
	mov	ecx, DWORD PTR [rax]
	mov	eax, DWORD PTR 2016[rbp]
	mov	edx, DWORD PTR 1056[rbp]
	mov	DWORD PTR 32[rsp], edx
	mov	r9d, 2
	mov	r8d, ecx
	mov	edx, eax
	mov	rcx, QWORD PTR 2000[rbp]
	call	_ZN3TKO7COLLECT8DECLARE_ERNS0_6WALKEREjjNS_10SYMBOLKINDEj
	jmp	.L3825
.L4004:
	nop
.L3752:
	cmp	QWORD PTR 1776[rbp], 67
	jne	.L4009
	nop
.L3765:
	mov	eax, DWORD PTR 2008[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 2000[rbp]
	call	_ZN3TKO7COLLECT6STMTOFERNS0_6WALKEREj
	mov	QWORD PTR 1048[rbp], rax
	mov	rax, QWORD PTR 1048[rbp]
	mov	QWORD PTR 1040[rbp], rax
	mov	rax, QWORD PTR 1040[rbp]
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	jne	.L4010
	mov	rax, QWORD PTR 2000[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 2016[rbp]
	mov	r9d, 0
	mov	r8d, edx
	mov	edx, 2
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE9OPENSCOPEENS_9SCOPEKINDEjj
	mov	DWORD PTR 1036[rbp], eax
	mov	eax, DWORD PTR 1036[rbp]
	mov	DWORD PTR 1032[rbp], eax
	mov	rax, QWORD PTR 2000[rbp]
	add	rax, 48
	mov	rax, QWORD PTR [rax]
	mov	ecx, DWORD PTR 1032[rbp]
	mov	edx, DWORD PTR 2008[rbp]
	mov	r8d, ecx
	mov	rcx, rax
	call	_ZN3TKO12SEMANTICINFO8SETSCOPEEjj
	mov	rax, QWORD PTR 1040[rbp]
	add	rax, 20
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 1040[rbp]
	add	rax, 16
	mov	eax, DWORD PTR [rax]
	mov	ecx, DWORD PTR 1032[rbp]
	mov	r9d, ecx
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 2000[rbp]
	call	_ZN3TKO7COLLECT12WALKCHILDRENERNS0_6WALKEREiij
	jmp	.L3825
.L3768:
.L4010:
	nop
.L3769:
	mov	rax, QWORD PTR 1040[rbp]
	mov	ecx, DWORD PTR [rax]
	mov	rax, QWORD PTR 2000[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 2016[rbp]
	mov	r8d, ecx
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE11LOOKUPLOCALEjj
	mov	DWORD PTR 1028[rbp], eax
	mov	eax, DWORD PTR 1028[rbp]
	mov	DWORD PTR 1024[rbp], eax
	mov	rax, QWORD PTR 2000[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 1024[rbp]
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE8SYMBOLATEj
	mov	QWORD PTR 1016[rbp], rax
	mov	rax, QWORD PTR 1016[rbp]
	mov	QWORD PTR 1824[rbp], rax
	cmp	QWORD PTR 1824[rbp], 0
	je	.L4011
	mov	rax, QWORD PTR 1824[rbp]
	movzx	eax, BYTE PTR [rax]
	cmp	al, 10
	sete	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR 1832[rbp], rax
	jmp	.L3772
.L4011:
	nop
.L3771:
	mov	QWORD PTR 1832[rbp], 0
.L3772:
	cmp	QWORD PTR 1832[rbp], 0
	setne	al
	mov	BYTE PTR 1015[rbp], al
	cmp	BYTE PTR 1015[rbp], 0
	jne	.L4012
	mov	rax, QWORD PTR 2000[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 2008[rbp]
	mov	rcx, rax
	call	_ZN3TKO8ASTARENA3LOCEj
	mov	DWORD PTR 1008[rbp], eax
	mov	rax, QWORD PTR 1040[rbp]
	mov	ecx, DWORD PTR [rax]
	mov	eax, DWORD PTR 2016[rbp]
	mov	edx, DWORD PTR 1008[rbp]
	mov	DWORD PTR 32[rsp], edx
	mov	r9d, 10
	mov	r8d, ecx
	mov	edx, eax
	mov	rcx, QWORD PTR 2000[rbp]
	call	_ZN3TKO7COLLECT8DECLARE_ERNS0_6WALKEREjjNS_10SYMBOLKINDEj
	mov	DWORD PTR 1004[rbp], eax
	mov	eax, DWORD PTR 1004[rbp]
	mov	DWORD PTR 1024[rbp], eax
	mov	rax, QWORD PTR 2000[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 1024[rbp]
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE8SYMBOLATEj
	mov	QWORD PTR 992[rbp], rax
	mov	rax, QWORD PTR 992[rbp]
	mov	QWORD PTR 1824[rbp], rax
	cmp	QWORD PTR 1824[rbp], 0
	je	.L4013
	mov	rax, QWORD PTR 2000[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	ecx, DWORD PTR 1024[rbp]
	mov	edx, DWORD PTR 2016[rbp]
	mov	r9d, ecx
	mov	r8d, edx
	mov	edx, 2
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE9OPENSCOPEENS_9SCOPEKINDEjj
	mov	DWORD PTR 988[rbp], eax
	mov	rax, QWORD PTR 1824[rbp]
	lea	rdx, 36[rax]
	mov	eax, DWORD PTR 988[rbp]
	mov	DWORD PTR [rdx], eax
	jmp	.L3778
.L3774:
.L3776:
.L3777:
.L4012:
	nop
	jmp	.L3778
.L4013:
	nop
.L3778:
	cmp	QWORD PTR 1824[rbp], 0
	je	.L4014
	mov	rax, QWORD PTR 1040[rbp]
	add	rax, 32
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	je	.L4015
	mov	rax, QWORD PTR 1040[rbp]
	add	rax, 32
	mov	eax, DWORD PTR [rax]
	mov	rdx, QWORD PTR 1824[rbp]
	add	rdx, 40
	cdqe
	mov	QWORD PTR [rdx], rax
	jmp	.L3782
.L4015:
	nop
.L3782:
	mov	rax, QWORD PTR 1040[rbp]
	add	rax, 32
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	jne	.L4016
	mov	rax, QWORD PTR 1040[rbp]
	add	rax, 40
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	setne	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR 1816[rbp], rax
	jmp	.L3785
.L4016:
	nop
.L3784:
	mov	QWORD PTR 1816[rbp], 0
.L3785:
	cmp	QWORD PTR 1816[rbp], 0
	je	.L4017
	mov	rax, QWORD PTR 1040[rbp]
	add	rax, 28
	mov	eax, DWORD PTR [rax]
	mov	eax, eax
	and	eax, 524288
	test	rax, rax
	setne	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR 1808[rbp], rax
	jmp	.L3788
.L4017:
	nop
.L3787:
	mov	QWORD PTR 1808[rbp], 0
.L3788:
	cmp	QWORD PTR 1808[rbp], 0
	je	.L4018
	mov	rax, QWORD PTR 1040[rbp]
	add	rax, 40
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 1824[rbp]
	add	rax, 40
	mov	edx, edx
	mov	QWORD PTR [rax], rdx
	jmp	.L3791
.L3790:
.L4018:
	nop
.L3791:
	mov	rax, QWORD PTR 1824[rbp]
	add	rax, 36
	mov	ecx, DWORD PTR [rax]
	mov	rax, QWORD PTR 2000[rbp]
	add	rax, 48
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 2008[rbp]
	mov	r8d, ecx
	mov	rcx, rax
	call	_ZN3TKO12SEMANTICINFO8SETSCOPEEjj
	mov	rax, QWORD PTR 1824[rbp]
	add	rax, 36
	mov	ecx, DWORD PTR [rax]
	mov	rax, QWORD PTR 1040[rbp]
	add	rax, 20
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 1040[rbp]
	add	rax, 16
	mov	eax, DWORD PTR [rax]
	mov	r9d, ecx
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 2000[rbp]
	call	_ZN3TKO7COLLECT12WALKCHILDRENERNS0_6WALKEREiij
	jmp	.L3825
.L3780:
.L4014:
	nop
.L3792:
	jmp	.L3825
.L4009:
	nop
.L3766:
	cmp	QWORD PTR 1776[rbp], 70
	jne	.L4019
	nop
.L3793:
	mov	eax, DWORD PTR 2008[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 2000[rbp]
	call	_ZN3TKO7COLLECT6STMTOFERNS0_6WALKEREj
	mov	QWORD PTR 976[rbp], rax
	mov	rax, QWORD PTR 976[rbp]
	mov	QWORD PTR 968[rbp], rax
	mov	rax, QWORD PTR 968[rbp]
	add	rax, 20
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 968[rbp]
	add	rax, 16
	mov	eax, DWORD PTR [rax]
	mov	ecx, DWORD PTR 2016[rbp]
	mov	r9d, ecx
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 2000[rbp]
	call	_ZN3TKO7COLLECT12WALKCHILDRENERNS0_6WALKEREiij
	jmp	.L3825
.L4019:
	nop
.L3794:
	cmp	QWORD PTR 1776[rbp], 50
	jne	.L4020
	nop
.L3795:
	mov	eax, DWORD PTR 2008[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 2000[rbp]
	call	_ZN3TKO7COLLECT6STMTOFERNS0_6WALKEREj
	mov	QWORD PTR 960[rbp], rax
	mov	rax, QWORD PTR 960[rbp]
	mov	QWORD PTR 952[rbp], rax
	mov	rax, QWORD PTR 2000[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 2008[rbp]
	mov	rcx, rax
	call	_ZN3TKO8ASTARENA3LOCEj
	mov	DWORD PTR 948[rbp], eax
	mov	rax, QWORD PTR 952[rbp]
	mov	ecx, DWORD PTR [rax]
	mov	eax, DWORD PTR 2016[rbp]
	mov	edx, DWORD PTR 948[rbp]
	mov	DWORD PTR 32[rsp], edx
	mov	r9d, 11
	mov	r8d, ecx
	mov	edx, eax
	mov	rcx, QWORD PTR 2000[rbp]
	call	_ZN3TKO7COLLECT8DECLARE_ERNS0_6WALKEREjjNS_10SYMBOLKINDEj
	jmp	.L3825
.L4020:
	nop
.L3796:
	cmp	QWORD PTR 1776[rbp], 42
	je	.L4021
	nop
.L3797:
	cmp	QWORD PTR 1776[rbp], 31
	je	.L4022
	nop
.L3799:
	cmp	QWORD PTR 1776[rbp], 32
	je	.L4023
	nop
.L3800:
	cmp	QWORD PTR 1776[rbp], 37
	je	.L4024
	nop
.L3801:
	cmp	QWORD PTR 1776[rbp], 38
	je	.L4025
	nop
.L3802:
	cmp	QWORD PTR 1776[rbp], 39
	je	.L4026
	nop
.L3803:
	cmp	QWORD PTR 1776[rbp], 40
	je	.L4027
	nop
.L3804:
	cmp	QWORD PTR 1776[rbp], 41
	je	.L4028
	nop
.L3805:
	cmp	QWORD PTR 1776[rbp], 33
	je	.L4029
	nop
.L3806:
	cmp	QWORD PTR 1776[rbp], 34
	je	.L4030
	nop
.L3807:
	cmp	QWORD PTR 1776[rbp], 44
	jne	.L4031
	jmp	.L3798
.L4021:
	nop
	jmp	.L3798
.L4022:
	nop
	jmp	.L3798
.L4023:
	nop
	jmp	.L3798
.L4024:
	nop
	jmp	.L3798
.L4025:
	nop
	jmp	.L3798
.L4026:
	nop
	jmp	.L3798
.L4027:
	nop
	jmp	.L3798
.L4028:
	nop
	jmp	.L3798
.L4029:
	nop
	jmp	.L3798
.L4030:
	nop
.L3798:
	mov	eax, DWORD PTR 2008[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 2000[rbp]
	call	_ZN3TKO7COLLECT6STMTOFERNS0_6WALKEREj
	mov	QWORD PTR 936[rbp], rax
	mov	rax, QWORD PTR 936[rbp]
	mov	QWORD PTR 928[rbp], rax
	mov	rax, QWORD PTR 2000[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 2016[rbp]
	mov	r9d, 0
	mov	r8d, edx
	mov	edx, 5
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE9OPENSCOPEENS_9SCOPEKINDEjj
	mov	DWORD PTR 924[rbp], eax
	mov	eax, DWORD PTR 924[rbp]
	mov	DWORD PTR 920[rbp], eax
	mov	rax, QWORD PTR 2000[rbp]
	add	rax, 48
	mov	rax, QWORD PTR [rax]
	mov	ecx, DWORD PTR 920[rbp]
	mov	edx, DWORD PTR 2008[rbp]
	mov	r8d, ecx
	mov	rcx, rax
	call	_ZN3TKO12SEMANTICINFO8SETSCOPEEjj
	mov	rax, QWORD PTR 928[rbp]
	add	rax, 12
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	setne	al
	mov	BYTE PTR 1797[rbp], al
	cmp	QWORD PTR 1776[rbp], 38
	jne	.L4032
	mov	BYTE PTR 1797[rbp], 1
	jmp	.L3809
.L4032:
	nop
.L3809:
	cmp	QWORD PTR 1776[rbp], 37
	je	.L4033
	cmp	QWORD PTR 1776[rbp], 38
	sete	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR 1800[rbp], rax
	jmp	.L3812
.L4033:
	nop
.L3811:
	mov	QWORD PTR 1800[rbp], -1
.L3812:
	cmp	QWORD PTR 1800[rbp], 0
	setne	al
	mov	BYTE PTR 919[rbp], al
	mov	rax, QWORD PTR 928[rbp]
	add	rax, 4
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	setne	al
	mov	BYTE PTR 1796[rbp], al
	cmp	BYTE PTR 1796[rbp], 0
	je	.L4034
	mov	rax, QWORD PTR 928[rbp]
	add	rax, 4
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 2000[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN3TKO8ASTARENA4KINDEj
	mov	QWORD PTR 904[rbp], rax
	cmp	QWORD PTR 904[rbp], 6
	sete	al
	mov	BYTE PTR 1796[rbp], al
	jmp	.L3814
.L4034:
	nop
.L3814:
	cmp	BYTE PTR 919[rbp], 0
	je	.L4035
	cmp	BYTE PTR 1797[rbp], 0
	setne	al
	mov	BYTE PTR 1799[rbp], al
	jmp	.L3817
.L4035:
	nop
.L3816:
	mov	BYTE PTR 1799[rbp], 0
.L3817:
	cmp	BYTE PTR 1799[rbp], 0
	je	.L4036
	cmp	BYTE PTR 1796[rbp], 0
	setne	al
	mov	BYTE PTR 1798[rbp], al
	jmp	.L3820
.L4036:
	nop
.L3819:
	mov	BYTE PTR 1798[rbp], 0
.L3820:
	cmp	BYTE PTR 1798[rbp], 0
	je	.L4037
	mov	rax, QWORD PTR 928[rbp]
	add	rax, 4
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 2000[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN5ArrayIN3TKO7ASTNODEEEixEi
	mov	QWORD PTR 896[rbp], rax
	mov	rax, QWORD PTR 896[rbp]
	add	rax, 8
	mov	eax, DWORD PTR [rax]
	mov	rdx, QWORD PTR 2000[rbp]
	add	rdx, 8
	mov	rdx, QWORD PTR [rdx]
	lea	rcx, 320[rdx]
	mov	edx, eax
	call	_ZN5ArrayIN3TKO12IDENTPAYLOADEEixEi
	mov	QWORD PTR 888[rbp], rax
	mov	rax, QWORD PTR 888[rbp]
	mov	QWORD PTR 880[rbp], rax
	mov	rax, QWORD PTR 928[rbp]
	add	rax, 4
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 2000[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN3TKO8ASTARENA3LOCEj
	mov	DWORD PTR 876[rbp], eax
	mov	rax, QWORD PTR 880[rbp]
	mov	ecx, DWORD PTR [rax]
	mov	eax, DWORD PTR 920[rbp]
	mov	edx, DWORD PTR 876[rbp]
	mov	DWORD PTR 32[rsp], edx
	mov	r9d, 1
	mov	r8d, ecx
	mov	edx, eax
	mov	rcx, QWORD PTR 2000[rbp]
	call	_ZN3TKO7COLLECT8DECLARE_ERNS0_6WALKEREjjNS_10SYMBOLKINDEj
	jmp	.L3823
.L3822:
.L4037:
	nop
.L3823:
	mov	rax, QWORD PTR 928[rbp]
	add	rax, 4
	mov	eax, DWORD PTR [rax]
	mov	edx, DWORD PTR 920[rbp]
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 2000[rbp]
	call	_ZN3TKO7COLLECT8WALKNODEERNS0_6WALKEREjj
	mov	rax, QWORD PTR 928[rbp]
	add	rax, 8
	mov	eax, DWORD PTR [rax]
	mov	edx, DWORD PTR 920[rbp]
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 2000[rbp]
	call	_ZN3TKO7COLLECT8WALKNODEERNS0_6WALKEREjj
	mov	rax, QWORD PTR 928[rbp]
	add	rax, 12
	mov	eax, DWORD PTR [rax]
	mov	edx, DWORD PTR 920[rbp]
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 2000[rbp]
	call	_ZN3TKO7COLLECT8WALKNODEERNS0_6WALKEREjj
	mov	rax, QWORD PTR 928[rbp]
	add	rax, 20
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 928[rbp]
	add	rax, 16
	mov	eax, DWORD PTR [rax]
	mov	ecx, DWORD PTR 920[rbp]
	mov	r9d, ecx
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 2000[rbp]
	call	_ZN3TKO7COLLECT12WALKCHILDRENERNS0_6WALKEREiij
	jmp	.L4038
.L3413:
.L3824:
.L3877:
	nop
	jmp	.L4038
.L3886:
	nop
	jmp	.L4038
.L3954:
	nop
	jmp	.L4038
.L3955:
	nop
	jmp	.L4038
.L4031:
	nop
.L3825:
.L4038:
	nop
	add	rsp, 2112
	pop	rbp
	ret
	.seh_endproc
	.section .rdata,"dr"
.LC6:
	.ascii "true\0"
.LC7:
	.ascii "false\0"
.LC8:
	.ascii "__function__\0"
.LC9:
	.ascii "__function_nq__\0"
	.text
	.globl	_ZN3TKO7COLLECT3RUNERNS_8ASTARENAEjRNS_11SYMBOLTABLEERNS_8INTERNERERNS_11TYPECONTEXTERNS_16DIAGNOSTICENGINEERNS_12SEMANTICINFOEPNS_13SOURCEMANAGERE
	.def	_ZN3TKO7COLLECT3RUNERNS_8ASTARENAEjRNS_11SYMBOLTABLEERNS_8INTERNERERNS_11TYPECONTEXTERNS_16DIAGNOSTICENGINEERNS_12SEMANTICINFOEPNS_13SOURCEMANAGERE;	.scl	2;	.type	32;	.endef
	.seh_proc	_ZN3TKO7COLLECT3RUNERNS_8ASTARENAEjRNS_11SYMBOLTABLEERNS_8INTERNERERNS_11TYPECONTEXTERNS_16DIAGNOSTICENGINEERNS_12SEMANTICINFOEPNS_13SOURCEMANAGERE
_ZN3TKO7COLLECT3RUNERNS_8ASTARENAEjRNS_11SYMBOLTABLEERNS_8INTERNERERNS_11TYPECONTEXTERNS_16DIAGNOSTICENGINEERNS_12SEMANTICINFOEPNS_13SOURCEMANAGERE:
	push	rbp
	.seh_pushreg	rbp
	push	rdi
	.seh_pushreg	rdi
	sub	rsp, 296
	.seh_stackalloc	296
	lea	rbp, 128[rsp]
	.seh_setframe	rbp, 128
	.seh_endprologue
	mov	QWORD PTR 192[rbp], rcx
	mov	DWORD PTR 200[rbp], edx
	mov	QWORD PTR 208[rbp], r8
	mov	QWORD PTR 216[rbp], r9
	mov	DWORD PTR 12[rbp], 0
.L4040:
	lea	rax, -80[rbp]
	mov	r8, rax
	mov	eax, 0
	mov	edx, 11
	mov	rdi, r8
	mov	rcx, rdx
	rep stosq
	lea	rax, -80[rbp]
	mov	rdx, QWORD PTR 248[rbp]
	mov	QWORD PTR [rax], rdx
	lea	rax, -80[rbp]
	add	rax, 40
	mov	rdx, QWORD PTR 224[rbp]
	mov	QWORD PTR [rax], rdx
	lea	rax, -80[rbp]
	add	rax, 8
	mov	rdx, QWORD PTR 192[rbp]
	mov	QWORD PTR [rax], rdx
	lea	rax, -80[rbp]
	add	rax, 16
	mov	rdx, QWORD PTR 208[rbp]
	mov	QWORD PTR [rax], rdx
	lea	rax, -80[rbp]
	add	rax, 24
	mov	rdx, QWORD PTR 232[rbp]
	mov	QWORD PTR [rax], rdx
	lea	rax, -80[rbp]
	add	rax, 32
	mov	rdx, QWORD PTR 216[rbp]
	mov	QWORD PTR [rax], rdx
	lea	rax, -80[rbp]
	add	rax, 48
	mov	rdx, QWORD PTR 240[rbp]
	mov	QWORD PTR [rax], rdx
	lea	rax, -80[rbp]
	add	rax, 72
	mov	DWORD PTR [rax], 0
	mov	rcx, QWORD PTR 192[rbp]
	call	_ZN3TKO8ASTARENA5COUNTEv
	mov	DWORD PTR 156[rbp], eax
	mov	edx, DWORD PTR 156[rbp]
	mov	rax, QWORD PTR 240[rbp]
	mov	rcx, rax
	call	_ZN3TKO12SEMANTICINFO6RESIZEEi
	lea	rax, 112[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	lea	rax, 112[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9d, 5
	lea	r8, .LC6[rip]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrAssign
	mov	r9, QWORD PTR 232[rbp]
	mov	r8, QWORD PTR 224[rbp]
	mov	rdx, QWORD PTR 216[rbp]
	mov	rax, QWORD PTR 208[rbp]
	mov	DWORD PTR 40[rsp], -1
	lea	rcx, 112[rbp]
	mov	QWORD PTR 32[rsp], rcx
	mov	rcx, rax
	call	_ZN3TKO7COLLECT19DECLAREBUILTINCONSTERNS_11SYMBOLTABLEERNS_8INTERNERERNS_11TYPECONTEXTERNS_16DIAGNOSTICENGINEE8FBSTRINGi
	lea	rax, 112[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	lea	rax, 80[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	lea	rax, 80[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9d, 6
	lea	r8, .LC7[rip]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrAssign
	mov	r9, QWORD PTR 232[rbp]
	mov	r8, QWORD PTR 224[rbp]
	mov	rdx, QWORD PTR 216[rbp]
	mov	rax, QWORD PTR 208[rbp]
	mov	DWORD PTR 40[rsp], 0
	lea	rcx, 80[rbp]
	mov	QWORD PTR 32[rsp], rcx
	mov	rcx, rax
	call	_ZN3TKO7COLLECT19DECLAREBUILTINCONSTERNS_11SYMBOLTABLEERNS_8INTERNERERNS_11TYPECONTEXTERNS_16DIAGNOSTICENGINEE8FBSTRINGi
	lea	rax, 80[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	lea	rax, 48[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	lea	rax, 48[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9d, 13
	lea	r8, .LC8[rip]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrAssign
	lea	r8, 48[rbp]
	mov	rcx, QWORD PTR 232[rbp]
	mov	rdx, QWORD PTR 216[rbp]
	mov	rax, QWORD PTR 208[rbp]
	mov	r9, r8
	mov	r8, rcx
	mov	rcx, rax
	call	_ZN3TKO7COLLECT15DECLAREFUNCNAMEERNS_11SYMBOLTABLEERNS_8INTERNERERNS_16DIAGNOSTICENGINEE8FBSTRING
	lea	rax, 48[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	lea	rax, 16[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	lea	rax, 16[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9d, 16
	lea	r8, .LC9[rip]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrAssign
	lea	r8, 16[rbp]
	mov	rcx, QWORD PTR 232[rbp]
	mov	rdx, QWORD PTR 216[rbp]
	mov	rax, QWORD PTR 208[rbp]
	mov	r9, r8
	mov	r8, rcx
	mov	rcx, rax
	call	_ZN3TKO7COLLECT13DECLAREGLOBALERNS_11SYMBOLTABLEERNS_8INTERNERERNS_16DIAGNOSTICENGINEE8FBSTRING
	lea	rax, 16[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	mov	rax, QWORD PTR 208[rbp]
	mov	r9d, 0
	mov	r8d, 1
	mov	edx, 1
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE9OPENSCOPEENS_9SCOPEKINDEjj
	mov	DWORD PTR 152[rbp], eax
	mov	eax, DWORD PTR 152[rbp]
	mov	DWORD PTR 148[rbp], eax
	mov	ecx, DWORD PTR 148[rbp]
	mov	edx, DWORD PTR 200[rbp]
	lea	rax, -80[rbp]
	mov	r8d, ecx
	mov	rcx, rax
	call	_ZN3TKO7COLLECT8WALKNODEERNS0_6WALKEREjj
	mov	eax, DWORD PTR -8[rbp]
	mov	DWORD PTR 12[rbp], eax
	nop
.L4041:
	mov	eax, DWORD PTR 12[rbp]
	add	rsp, 296
	pop	rdi
	pop	rbp
	ret
	.seh_endproc
	.globl	_ZN3TKO7COLLECT3ONEERNS_8ASTARENAEjjRNS_11SYMBOLTABLEERNS_8INTERNERERNS_11TYPECONTEXTERNS_16DIAGNOSTICENGINEERNS_12SEMANTICINFOE
	.def	_ZN3TKO7COLLECT3ONEERNS_8ASTARENAEjjRNS_11SYMBOLTABLEERNS_8INTERNERERNS_11TYPECONTEXTERNS_16DIAGNOSTICENGINEERNS_12SEMANTICINFOE;	.scl	2;	.type	32;	.endef
	.seh_proc	_ZN3TKO7COLLECT3ONEERNS_8ASTARENAEjjRNS_11SYMBOLTABLEERNS_8INTERNERERNS_11TYPECONTEXTERNS_16DIAGNOSTICENGINEERNS_12SEMANTICINFOE
_ZN3TKO7COLLECT3ONEERNS_8ASTARENAEjjRNS_11SYMBOLTABLEERNS_8INTERNERERNS_11TYPECONTEXTERNS_16DIAGNOSTICENGINEERNS_12SEMANTICINFOE:
	push	rbp
	.seh_pushreg	rbp
	push	rdi
	.seh_pushreg	rdi
	sub	rsp, 136
	.seh_stackalloc	136
	lea	rbp, 128[rsp]
	.seh_setframe	rbp, 128
	.seh_endprologue
	mov	QWORD PTR 32[rbp], rcx
	mov	DWORD PTR 40[rbp], edx
	mov	DWORD PTR 48[rbp], r8d
	mov	QWORD PTR 56[rbp], r9
	mov	DWORD PTR -8[rbp], 0
.L4044:
	lea	rax, -96[rbp]
	mov	r8, rax
	mov	eax, 0
	mov	edx, 11
	mov	rdi, r8
	mov	rcx, rdx
	rep stosq
	lea	rax, -96[rbp]
	add	rax, 40
	mov	rdx, QWORD PTR 72[rbp]
	mov	QWORD PTR [rax], rdx
	lea	rax, -96[rbp]
	add	rax, 8
	mov	rdx, QWORD PTR 32[rbp]
	mov	QWORD PTR [rax], rdx
	lea	rax, -96[rbp]
	add	rax, 16
	mov	rdx, QWORD PTR 56[rbp]
	mov	QWORD PTR [rax], rdx
	lea	rax, -96[rbp]
	add	rax, 24
	mov	rdx, QWORD PTR 80[rbp]
	mov	QWORD PTR [rax], rdx
	lea	rax, -96[rbp]
	add	rax, 32
	mov	rdx, QWORD PTR 64[rbp]
	mov	QWORD PTR [rax], rdx
	lea	rax, -96[rbp]
	add	rax, 48
	mov	rdx, QWORD PTR 88[rbp]
	mov	QWORD PTR [rax], rdx
	lea	rax, -96[rbp]
	add	rax, 72
	mov	DWORD PTR [rax], 0
	mov	rcx, QWORD PTR 32[rbp]
	call	_ZN3TKO8ASTARENA5COUNTEv
	mov	DWORD PTR -4[rbp], eax
	mov	edx, DWORD PTR -4[rbp]
	mov	rax, QWORD PTR 88[rbp]
	mov	rcx, rax
	call	_ZN3TKO12SEMANTICINFO6RESIZEEi
	mov	ecx, DWORD PTR 48[rbp]
	mov	edx, DWORD PTR 40[rbp]
	lea	rax, -96[rbp]
	mov	r8d, ecx
	mov	rcx, rax
	call	_ZN3TKO7COLLECT8WALKNODEERNS0_6WALKEREjj
	mov	eax, DWORD PTR -24[rbp]
	mov	DWORD PTR -8[rbp], eax
	nop
.L4045:
	mov	eax, DWORD PTR -8[rbp]
	add	rsp, 136
	pop	rdi
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
.L4048:
.L4049:
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
.L4051:
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
.L4052:
	mov	rax, QWORD PTR -16[rbp]
	cmp	rax, QWORD PTR -24[rbp]
	jnb	.L4057
	mov	rax, QWORD PTR -16[rbp]
	movzx	edx, BYTE PTR [rax]
	mov	rax, QWORD PTR -8[rbp]
	mov	BYTE PTR [rax], dl
	add	QWORD PTR -8[rbp], 1
	add	QWORD PTR -16[rbp], 1
	jmp	.L4052
.L4057:
	nop
.L4054:
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 72[rax]
	mov	rax, QWORD PTR 24[rbp]
	mov	eax, DWORD PTR 72[rax]
	mov	DWORD PTR [rdx], eax
	nop
	add	rsp, 80
	pop	rbp
	ret
.L4055:
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
.L4059:
.L4060:
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
.L4062:
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
.L4063:
	mov	rax, QWORD PTR -16[rbp]
	cmp	rax, QWORD PTR -24[rbp]
	jnb	.L4068
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
	jmp	.L4063
.L4068:
	nop
.L4065:
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 72[rax]
	mov	rax, QWORD PTR 24[rbp]
	mov	eax, DWORD PTR 72[rax]
	mov	DWORD PTR [rdx], eax
	nop
	add	rsp, 80
	pop	rbp
	ret
.L4066:
	.seh_endproc
	.def	_ZN5ArrayIN3TKO5TOKENEEaSERKS2_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO5TOKENEEaSERKS2_
_ZN5ArrayIN3TKO5TOKENEEaSERKS2_:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 80
	.seh_stackalloc	80
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
.L4070:
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
.L4071:
	mov	rax, QWORD PTR -16[rbp]
	cmp	rax, QWORD PTR -24[rbp]
	jnb	.L4076
	mov	rax, QWORD PTR -16[rbp]
	mov	rdx, QWORD PTR 8[rax]
	mov	rax, QWORD PTR [rax]
	mov	rcx, QWORD PTR -8[rbp]
	mov	QWORD PTR [rcx], rax
	mov	QWORD PTR 8[rcx], rdx
	add	QWORD PTR -8[rbp], 16
	add	QWORD PTR -16[rbp], 16
	jmp	.L4071
.L4076:
	nop
.L4073:
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 72[rax]
	mov	rax, QWORD PTR 24[rbp]
	mov	eax, DWORD PTR 72[rax]
	mov	DWORD PTR [rdx], eax
	nop
	add	rsp, 80
	pop	rbp
	ret
.L4074:
	.seh_endproc
	.def	_ZN5ArrayIN3TKO7LITERALEEaSERKS2_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO7LITERALEEaSERKS2_
_ZN5ArrayIN3TKO7LITERALEEaSERKS2_:
	push	rbp
	.seh_pushreg	rbp
	push	rbx
	.seh_pushreg	rbx
	sub	rsp, 88
	.seh_stackalloc	88
	lea	rbp, 128[rsp]
	.seh_setframe	rbp, 128
	.seh_endprologue
	mov	QWORD PTR -16[rbp], rcx
	mov	QWORD PTR -8[rbp], rdx
.L4078:
	mov	rax, QWORD PTR -8[rbp]
	mov	QWORD PTR 32[rsp], 0
	mov	r9d, 0
	mov	r8d, 0
	mov	rdx, rax
	mov	rcx, QWORD PTR -16[rbp]
	call	fb_ArrayRedimTo
	mov	rax, QWORD PTR -16[rbp]
	mov	rax, QWORD PTR 8[rax]
	mov	QWORD PTR -56[rbp], rax
	mov	rax, QWORD PTR -8[rbp]
	mov	rax, QWORD PTR 8[rax]
	mov	QWORD PTR -64[rbp], rax
	mov	rax, QWORD PTR -8[rbp]
	add	rax, 16
	mov	rdx, QWORD PTR [rax]
	mov	rax, QWORD PTR -64[rbp]
	add	rax, rdx
	mov	QWORD PTR -72[rbp], rax
.L4079:
	mov	rax, QWORD PTR -64[rbp]
	cmp	rax, QWORD PTR -72[rbp]
	jnb	.L4084
	mov	rax, QWORD PTR -56[rbp]
	mov	rdx, QWORD PTR -64[rbp]
	mov	rcx, QWORD PTR [rdx]
	mov	rbx, QWORD PTR 8[rdx]
	mov	QWORD PTR [rax], rcx
	mov	QWORD PTR 8[rax], rbx
	mov	rcx, QWORD PTR 16[rdx]
	mov	rbx, QWORD PTR 24[rdx]
	mov	QWORD PTR 16[rax], rcx
	mov	QWORD PTR 24[rax], rbx
	mov	rdx, QWORD PTR 32[rdx]
	mov	QWORD PTR 32[rax], rdx
	add	QWORD PTR -56[rbp], 40
	add	QWORD PTR -64[rbp], 40
	jmp	.L4079
.L4084:
	nop
.L4081:
	mov	rax, QWORD PTR -16[rbp]
	lea	rdx, 72[rax]
	mov	rax, QWORD PTR -8[rbp]
	mov	eax, DWORD PTR 72[rax]
	mov	DWORD PTR [rdx], eax
	nop
	add	rsp, 88
	pop	rbx
	pop	rbp
	ret
.L4082:
	.seh_endproc
	.def	_ZN5ArrayItEC1Ev;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayItEC1Ev
_ZN5ArrayItEC1Ev:
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
	mov	QWORD PTR [rax], 2
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
.L4086:
.L4087:
	.seh_endproc
	.def	_ZN5ArrayItEaSERKS0_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayItEaSERKS0_
_ZN5ArrayItEaSERKS0_:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 80
	.seh_stackalloc	80
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
.L4089:
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
.L4090:
	mov	rax, QWORD PTR -16[rbp]
	cmp	rax, QWORD PTR -24[rbp]
	jnb	.L4095
	mov	rax, QWORD PTR -16[rbp]
	movzx	edx, WORD PTR [rax]
	mov	rax, QWORD PTR -8[rbp]
	mov	WORD PTR [rax], dx
	add	QWORD PTR -8[rbp], 2
	add	QWORD PTR -16[rbp], 2
	jmp	.L4090
.L4095:
	nop
.L4092:
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 72[rax]
	mov	rax, QWORD PTR 24[rbp]
	mov	eax, DWORD PTR 72[rax]
	mov	DWORD PTR [rdx], eax
	nop
	add	rsp, 80
	pop	rbp
	ret
.L4093:
	.seh_endproc
	.def	_ZN5ArrayItED1Ev;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayItED1Ev
_ZN5ArrayItED1Ev:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
.L4097:
.L4098:
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayErase
	nop
	add	rsp, 32
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN3TKO10KEYWORDMAPaSERKS0_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN3TKO10KEYWORDMAPaSERKS0_
_ZN3TKO10KEYWORDMAPaSERKS0_:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
.L4100:
	mov	rax, QWORD PTR 24[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayItEaSERKS0_
	mov	rax, QWORD PTR 24[rbp]
	lea	rdx, 80[rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 80
	mov	rcx, rax
	call	_ZN5ArrayIhEaSERKS0_
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 160[rax]
	mov	rax, QWORD PTR 24[rbp]
	mov	eax, DWORD PTR 160[rax]
	mov	DWORD PTR [rdx], eax
	nop
	add	rsp, 32
	pop	rbp
	ret
.L4101:
	.seh_endproc
	.def	_ZN5ArrayIN3TKO7ASTNODEEEC1Ev;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO7ASTNODEEEC1Ev
_ZN5ArrayIN3TKO7ASTNODEEEC1Ev:
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
.L4103:
.L4104:
	.seh_endproc
	.def	_ZN5ArrayIN3TKO7ASTNODEEEaSERKS2_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO7ASTNODEEEaSERKS2_
_ZN5ArrayIN3TKO7ASTNODEEEaSERKS2_:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 80
	.seh_stackalloc	80
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
.L4106:
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
.L4107:
	mov	rax, QWORD PTR -16[rbp]
	cmp	rax, QWORD PTR -24[rbp]
	jnb	.L4112
	mov	rax, QWORD PTR -8[rbp]
	mov	rdx, QWORD PTR -16[rbp]
	mov	rcx, QWORD PTR [rdx]
	mov	QWORD PTR [rax], rcx
	mov	edx, DWORD PTR 8[rdx]
	mov	DWORD PTR 8[rax], edx
	add	QWORD PTR -8[rbp], 12
	add	QWORD PTR -16[rbp], 12
	jmp	.L4107
.L4112:
	nop
.L4109:
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 72[rax]
	mov	rax, QWORD PTR 24[rbp]
	mov	eax, DWORD PTR 72[rax]
	mov	DWORD PTR [rdx], eax
	nop
	add	rsp, 80
	pop	rbp
	ret
.L4110:
	.seh_endproc
	.def	_ZN5ArrayIN3TKO7ASTNODEEED1Ev;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO7ASTNODEEED1Ev
_ZN5ArrayIN3TKO7ASTNODEEED1Ev:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
.L4114:
.L4115:
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayErase
	nop
	add	rsp, 32
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO12UNARYPAYLOADEEC1Ev;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO12UNARYPAYLOADEEC1Ev
_ZN5ArrayIN3TKO12UNARYPAYLOADEEC1Ev:
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
.L4117:
.L4118:
	.seh_endproc
	.def	_ZN5ArrayIN3TKO12UNARYPAYLOADEEaSERKS2_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO12UNARYPAYLOADEEaSERKS2_
_ZN5ArrayIN3TKO12UNARYPAYLOADEEaSERKS2_:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 80
	.seh_stackalloc	80
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
.L4120:
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
.L4121:
	mov	rax, QWORD PTR -16[rbp]
	cmp	rax, QWORD PTR -24[rbp]
	jnb	.L4126
	mov	rax, QWORD PTR -16[rbp]
	mov	rdx, QWORD PTR [rax]
	mov	rax, QWORD PTR -8[rbp]
	mov	QWORD PTR [rax], rdx
	add	QWORD PTR -8[rbp], 8
	add	QWORD PTR -16[rbp], 8
	jmp	.L4121
.L4126:
	nop
.L4123:
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 72[rax]
	mov	rax, QWORD PTR 24[rbp]
	mov	eax, DWORD PTR 72[rax]
	mov	DWORD PTR [rdx], eax
	nop
	add	rsp, 80
	pop	rbp
	ret
.L4124:
	.seh_endproc
	.def	_ZN5ArrayIN3TKO12UNARYPAYLOADEED1Ev;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO12UNARYPAYLOADEED1Ev
_ZN5ArrayIN3TKO12UNARYPAYLOADEED1Ev:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
.L4128:
.L4129:
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayErase
	nop
	add	rsp, 32
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO13BINARYPAYLOADEEC1Ev;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO13BINARYPAYLOADEEC1Ev
_ZN5ArrayIN3TKO13BINARYPAYLOADEEC1Ev:
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
.L4131:
.L4132:
	.seh_endproc
	.def	_ZN5ArrayIN3TKO13BINARYPAYLOADEEaSERKS2_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO13BINARYPAYLOADEEaSERKS2_
_ZN5ArrayIN3TKO13BINARYPAYLOADEEaSERKS2_:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 80
	.seh_stackalloc	80
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
.L4134:
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
.L4135:
	mov	rax, QWORD PTR -16[rbp]
	cmp	rax, QWORD PTR -24[rbp]
	jnb	.L4140
	mov	rax, QWORD PTR -8[rbp]
	mov	rdx, QWORD PTR -16[rbp]
	mov	rcx, QWORD PTR [rdx]
	mov	QWORD PTR [rax], rcx
	mov	edx, DWORD PTR 8[rdx]
	mov	DWORD PTR 8[rax], edx
	add	QWORD PTR -8[rbp], 12
	add	QWORD PTR -16[rbp], 12
	jmp	.L4135
.L4140:
	nop
.L4137:
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 72[rax]
	mov	rax, QWORD PTR 24[rbp]
	mov	eax, DWORD PTR 72[rax]
	mov	DWORD PTR [rdx], eax
	nop
	add	rsp, 80
	pop	rbp
	ret
.L4138:
	.seh_endproc
	.def	_ZN5ArrayIN3TKO13BINARYPAYLOADEED1Ev;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO13BINARYPAYLOADEED1Ev
_ZN5ArrayIN3TKO13BINARYPAYLOADEED1Ev:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
.L4142:
.L4143:
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayErase
	nop
	add	rsp, 32
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO14LITERALPAYLOADEEC1Ev;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO14LITERALPAYLOADEEC1Ev
_ZN5ArrayIN3TKO14LITERALPAYLOADEEC1Ev:
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
	mov	QWORD PTR [rax], 32
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
.L4145:
.L4146:
	.seh_endproc
	.def	_ZN5ArrayIN3TKO14LITERALPAYLOADEEaSERKS2_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO14LITERALPAYLOADEEaSERKS2_
_ZN5ArrayIN3TKO14LITERALPAYLOADEEaSERKS2_:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 80
	.seh_stackalloc	80
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
.L4148:
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
.L4149:
	mov	rax, QWORD PTR -16[rbp]
	cmp	rax, QWORD PTR -24[rbp]
	jnb	.L4154
	mov	rcx, QWORD PTR -8[rbp]
	mov	r8, QWORD PTR -16[rbp]
	mov	rax, QWORD PTR [r8]
	mov	rdx, QWORD PTR 8[r8]
	mov	QWORD PTR [rcx], rax
	mov	QWORD PTR 8[rcx], rdx
	mov	rax, QWORD PTR 16[r8]
	mov	rdx, QWORD PTR 24[r8]
	mov	QWORD PTR 16[rcx], rax
	mov	QWORD PTR 24[rcx], rdx
	add	QWORD PTR -8[rbp], 32
	add	QWORD PTR -16[rbp], 32
	jmp	.L4149
.L4154:
	nop
.L4151:
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 72[rax]
	mov	rax, QWORD PTR 24[rbp]
	mov	eax, DWORD PTR 72[rax]
	mov	DWORD PTR [rdx], eax
	nop
	add	rsp, 80
	pop	rbp
	ret
.L4152:
	.seh_endproc
	.def	_ZN5ArrayIN3TKO14LITERALPAYLOADEED1Ev;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO14LITERALPAYLOADEED1Ev
_ZN5ArrayIN3TKO14LITERALPAYLOADEED1Ev:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
.L4156:
.L4157:
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayErase
	nop
	add	rsp, 32
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO12IDENTPAYLOADEEC1Ev;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO12IDENTPAYLOADEEC1Ev
_ZN5ArrayIN3TKO12IDENTPAYLOADEEC1Ev:
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
.L4159:
.L4160:
	.seh_endproc
	.def	_ZN5ArrayIN3TKO12IDENTPAYLOADEEaSERKS2_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO12IDENTPAYLOADEEaSERKS2_
_ZN5ArrayIN3TKO12IDENTPAYLOADEEaSERKS2_:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 80
	.seh_stackalloc	80
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
.L4162:
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
.L4163:
	mov	rax, QWORD PTR -16[rbp]
	cmp	rax, QWORD PTR -24[rbp]
	jnb	.L4168
	mov	rax, QWORD PTR -8[rbp]
	mov	rdx, QWORD PTR -16[rbp]
	mov	rcx, QWORD PTR [rdx]
	mov	QWORD PTR [rax], rcx
	mov	edx, DWORD PTR 8[rdx]
	mov	DWORD PTR 8[rax], edx
	add	QWORD PTR -8[rbp], 12
	add	QWORD PTR -16[rbp], 12
	jmp	.L4163
.L4168:
	nop
.L4165:
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 72[rax]
	mov	rax, QWORD PTR 24[rbp]
	mov	eax, DWORD PTR 72[rax]
	mov	DWORD PTR [rdx], eax
	nop
	add	rsp, 80
	pop	rbp
	ret
.L4166:
	.seh_endproc
	.def	_ZN5ArrayIN3TKO12IDENTPAYLOADEED1Ev;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO12IDENTPAYLOADEED1Ev
_ZN5ArrayIN3TKO12IDENTPAYLOADEED1Ev:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
.L4170:
.L4171:
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayErase
	nop
	add	rsp, 32
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO11LISTPAYLOADEEC1Ev;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO11LISTPAYLOADEEC1Ev
_ZN5ArrayIN3TKO11LISTPAYLOADEEC1Ev:
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
.L4173:
.L4174:
	.seh_endproc
	.def	_ZN5ArrayIN3TKO11LISTPAYLOADEEaSERKS2_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO11LISTPAYLOADEEaSERKS2_
_ZN5ArrayIN3TKO11LISTPAYLOADEEaSERKS2_:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 80
	.seh_stackalloc	80
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
.L4176:
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
.L4177:
	mov	rax, QWORD PTR -16[rbp]
	cmp	rax, QWORD PTR -24[rbp]
	jnb	.L4182
	mov	rax, QWORD PTR -8[rbp]
	mov	rdx, QWORD PTR -16[rbp]
	mov	rcx, QWORD PTR [rdx]
	mov	QWORD PTR [rax], rcx
	mov	edx, DWORD PTR 8[rdx]
	mov	DWORD PTR 8[rax], edx
	add	QWORD PTR -8[rbp], 12
	add	QWORD PTR -16[rbp], 12
	jmp	.L4177
.L4182:
	nop
.L4179:
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 72[rax]
	mov	rax, QWORD PTR 24[rbp]
	mov	eax, DWORD PTR 72[rax]
	mov	DWORD PTR [rdx], eax
	nop
	add	rsp, 80
	pop	rbp
	ret
.L4180:
	.seh_endproc
	.def	_ZN5ArrayIN3TKO11LISTPAYLOADEED1Ev;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO11LISTPAYLOADEED1Ev
_ZN5ArrayIN3TKO11LISTPAYLOADEED1Ev:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
.L4184:
.L4185:
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayErase
	nop
	add	rsp, 32
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO11STMTPAYLOADEEC1Ev;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO11STMTPAYLOADEEC1Ev
_ZN5ArrayIN3TKO11STMTPAYLOADEEC1Ev:
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
	mov	QWORD PTR [rax], 44
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
.L4187:
.L4188:
	.seh_endproc
	.def	_ZN5ArrayIN3TKO11STMTPAYLOADEEaSERKS2_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO11STMTPAYLOADEEaSERKS2_
_ZN5ArrayIN3TKO11STMTPAYLOADEEaSERKS2_:
	push	rbp
	.seh_pushreg	rbp
	push	rbx
	.seh_pushreg	rbx
	sub	rsp, 88
	.seh_stackalloc	88
	lea	rbp, 128[rsp]
	.seh_setframe	rbp, 128
	.seh_endprologue
	mov	QWORD PTR -16[rbp], rcx
	mov	QWORD PTR -8[rbp], rdx
.L4190:
	mov	rax, QWORD PTR -8[rbp]
	mov	QWORD PTR 32[rsp], 0
	mov	r9d, 0
	mov	r8d, 0
	mov	rdx, rax
	mov	rcx, QWORD PTR -16[rbp]
	call	fb_ArrayRedimTo
	mov	rax, QWORD PTR -16[rbp]
	mov	rax, QWORD PTR 8[rax]
	mov	QWORD PTR -56[rbp], rax
	mov	rax, QWORD PTR -8[rbp]
	mov	rax, QWORD PTR 8[rax]
	mov	QWORD PTR -64[rbp], rax
	mov	rax, QWORD PTR -8[rbp]
	add	rax, 16
	mov	rdx, QWORD PTR [rax]
	mov	rax, QWORD PTR -64[rbp]
	add	rax, rdx
	mov	QWORD PTR -72[rbp], rax
.L4191:
	mov	rax, QWORD PTR -64[rbp]
	cmp	rax, QWORD PTR -72[rbp]
	jnb	.L4196
	mov	rax, QWORD PTR -56[rbp]
	mov	rdx, QWORD PTR -64[rbp]
	mov	rcx, QWORD PTR [rdx]
	mov	rbx, QWORD PTR 8[rdx]
	mov	QWORD PTR [rax], rcx
	mov	QWORD PTR 8[rax], rbx
	mov	rcx, QWORD PTR 16[rdx]
	mov	rbx, QWORD PTR 24[rdx]
	mov	QWORD PTR 16[rax], rcx
	mov	QWORD PTR 24[rax], rbx
	mov	rcx, QWORD PTR 32[rdx]
	mov	QWORD PTR 32[rax], rcx
	mov	edx, DWORD PTR 40[rdx]
	mov	DWORD PTR 40[rax], edx
	add	QWORD PTR -56[rbp], 44
	add	QWORD PTR -64[rbp], 44
	jmp	.L4191
.L4196:
	nop
.L4193:
	mov	rax, QWORD PTR -16[rbp]
	lea	rdx, 72[rax]
	mov	rax, QWORD PTR -8[rbp]
	mov	eax, DWORD PTR 72[rax]
	mov	DWORD PTR [rdx], eax
	nop
	add	rsp, 88
	pop	rbx
	pop	rbp
	ret
.L4194:
	.seh_endproc
	.def	_ZN5ArrayIN3TKO11STMTPAYLOADEED1Ev;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO11STMTPAYLOADEED1Ev
_ZN5ArrayIN3TKO11STMTPAYLOADEED1Ev:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
.L4198:
.L4199:
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
.L4201:
.L4202:
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
.L4204:
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
.L4205:
	mov	rax, QWORD PTR -16[rbp]
	cmp	rax, QWORD PTR -24[rbp]
	jnb	.L4210
	mov	rax, QWORD PTR -16[rbp]
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR -8[rbp]
	mov	DWORD PTR [rax], edx
	add	QWORD PTR -8[rbp], 4
	add	QWORD PTR -16[rbp], 4
	jmp	.L4205
.L4210:
	nop
.L4207:
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 72[rax]
	mov	rax, QWORD PTR 24[rbp]
	mov	eax, DWORD PTR 72[rax]
	mov	DWORD PTR [rdx], eax
	nop
	add	rsp, 80
	pop	rbp
	ret
.L4208:
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
.L4212:
.L4213:
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayErase
	nop
	add	rsp, 32
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN3TKO8ASTARENAaSERKS0_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN3TKO8ASTARENAaSERKS0_
_ZN3TKO8ASTARENAaSERKS0_:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
.L4215:
	mov	rax, QWORD PTR 24[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIN3TKO7ASTNODEEEaSERKS2_
	mov	rax, QWORD PTR 24[rbp]
	lea	rdx, 80[rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 80
	mov	rcx, rax
	call	_ZN5ArrayIN3TKO12UNARYPAYLOADEEaSERKS2_
	mov	rax, QWORD PTR 24[rbp]
	lea	rdx, 160[rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 160
	mov	rcx, rax
	call	_ZN5ArrayIN3TKO13BINARYPAYLOADEEaSERKS2_
	mov	rax, QWORD PTR 24[rbp]
	lea	rdx, 240[rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 240
	mov	rcx, rax
	call	_ZN5ArrayIN3TKO14LITERALPAYLOADEEaSERKS2_
	mov	rax, QWORD PTR 24[rbp]
	lea	rdx, 320[rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 320
	mov	rcx, rax
	call	_ZN5ArrayIN3TKO12IDENTPAYLOADEEaSERKS2_
	mov	rax, QWORD PTR 24[rbp]
	lea	rdx, 400[rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 400
	mov	rcx, rax
	call	_ZN5ArrayIN3TKO11LISTPAYLOADEEaSERKS2_
	mov	rax, QWORD PTR 24[rbp]
	lea	rdx, 480[rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 480
	mov	rcx, rax
	call	_ZN5ArrayIN3TKO11STMTPAYLOADEEaSERKS2_
	mov	rax, QWORD PTR 24[rbp]
	lea	rdx, 560[rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 560
	mov	rcx, rax
	call	_ZN5ArrayIjEaSERKS0_
	mov	rax, QWORD PTR 24[rbp]
	lea	rdx, 640[rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 640
	mov	rcx, rax
	call	_ZN5ArrayIjEaSERKS0_
	mov	rax, QWORD PTR 24[rbp]
	lea	rdx, 720[rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 720
	mov	rcx, rax
	call	_ZN5ArrayIjEaSERKS0_
	mov	rax, QWORD PTR 24[rbp]
	lea	rdx, 800[rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 800
	mov	rcx, rax
	call	_ZN5ArrayIjEaSERKS0_
	nop
	add	rsp, 32
	pop	rbp
	ret
.L4216:
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
.L4218:
.L4219:
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
.L4221:
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
.L4222:
	mov	rax, QWORD PTR -16[rbp]
	cmp	rax, QWORD PTR -24[rbp]
	jnb	.L4227
	mov	rax, QWORD PTR -16[rbp]
	mov	rdx, QWORD PTR [rax]
	mov	rax, QWORD PTR -8[rbp]
	mov	QWORD PTR [rax], rdx
	add	QWORD PTR -8[rbp], 8
	add	QWORD PTR -16[rbp], 8
	jmp	.L4222
.L4227:
	nop
.L4224:
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 72[rax]
	mov	rax, QWORD PTR 24[rbp]
	mov	eax, DWORD PTR 72[rax]
	mov	DWORD PTR [rdx], eax
	nop
	add	rsp, 80
	pop	rbp
	ret
.L4225:
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
.L4229:
.L4230:
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
.L4232:
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
.L4233:
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
.L4235:
.L4236:
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
.L4238:
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
.L4239:
	mov	rax, QWORD PTR -16[rbp]
	cmp	rax, QWORD PTR -24[rbp]
	jnb	.L4244
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
	jmp	.L4239
.L4244:
	nop
.L4241:
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 72[rax]
	mov	rax, QWORD PTR 24[rbp]
	mov	eax, DWORD PTR 72[rax]
	mov	DWORD PTR [rdx], eax
	nop
	add	rsp, 80
	pop	rbp
	ret
.L4242:
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
.L4246:
.L4247:
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
.L4249:
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
.L4250:
	.seh_endproc
	.def	_ZN5ArrayIN3TKO8TYPEINFOEEC1Ev;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO8TYPEINFOEEC1Ev
_ZN5ArrayIN3TKO8TYPEINFOEEC1Ev:
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
	mov	QWORD PTR [rax], 44
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
.L4252:
.L4253:
	.seh_endproc
	.def	_ZN5ArrayIN3TKO8TYPEINFOEEaSERKS2_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO8TYPEINFOEEaSERKS2_
_ZN5ArrayIN3TKO8TYPEINFOEEaSERKS2_:
	push	rbp
	.seh_pushreg	rbp
	push	rbx
	.seh_pushreg	rbx
	sub	rsp, 88
	.seh_stackalloc	88
	lea	rbp, 128[rsp]
	.seh_setframe	rbp, 128
	.seh_endprologue
	mov	QWORD PTR -16[rbp], rcx
	mov	QWORD PTR -8[rbp], rdx
.L4255:
	mov	rax, QWORD PTR -8[rbp]
	mov	QWORD PTR 32[rsp], 0
	mov	r9d, 0
	mov	r8d, 0
	mov	rdx, rax
	mov	rcx, QWORD PTR -16[rbp]
	call	fb_ArrayRedimTo
	mov	rax, QWORD PTR -16[rbp]
	mov	rax, QWORD PTR 8[rax]
	mov	QWORD PTR -56[rbp], rax
	mov	rax, QWORD PTR -8[rbp]
	mov	rax, QWORD PTR 8[rax]
	mov	QWORD PTR -64[rbp], rax
	mov	rax, QWORD PTR -8[rbp]
	add	rax, 16
	mov	rdx, QWORD PTR [rax]
	mov	rax, QWORD PTR -64[rbp]
	add	rax, rdx
	mov	QWORD PTR -72[rbp], rax
.L4256:
	mov	rax, QWORD PTR -64[rbp]
	cmp	rax, QWORD PTR -72[rbp]
	jnb	.L4261
	mov	rax, QWORD PTR -56[rbp]
	mov	rdx, QWORD PTR -64[rbp]
	mov	rcx, QWORD PTR [rdx]
	mov	rbx, QWORD PTR 8[rdx]
	mov	QWORD PTR [rax], rcx
	mov	QWORD PTR 8[rax], rbx
	mov	rcx, QWORD PTR 16[rdx]
	mov	rbx, QWORD PTR 24[rdx]
	mov	QWORD PTR 16[rax], rcx
	mov	QWORD PTR 24[rax], rbx
	mov	rcx, QWORD PTR 32[rdx]
	mov	QWORD PTR 32[rax], rcx
	mov	edx, DWORD PTR 40[rdx]
	mov	DWORD PTR 40[rax], edx
	add	QWORD PTR -56[rbp], 44
	add	QWORD PTR -64[rbp], 44
	jmp	.L4256
.L4261:
	nop
.L4258:
	mov	rax, QWORD PTR -16[rbp]
	lea	rdx, 72[rax]
	mov	rax, QWORD PTR -8[rbp]
	mov	eax, DWORD PTR 72[rax]
	mov	DWORD PTR [rdx], eax
	nop
	add	rsp, 88
	pop	rbx
	pop	rbp
	ret
.L4259:
	.seh_endproc
	.def	_ZN5ArrayIN3TKO8TYPEINFOEED1Ev;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO8TYPEINFOEED1Ev
_ZN5ArrayIN3TKO8TYPEINFOEED1Ev:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
.L4263:
.L4264:
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayErase
	nop
	add	rsp, 32
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIxEC1Ev;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIxEC1Ev
_ZN5ArrayIxEC1Ev:
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
.L4266:
.L4267:
	.seh_endproc
	.def	_ZN5ArrayIxEaSERKS0_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIxEaSERKS0_
_ZN5ArrayIxEaSERKS0_:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 80
	.seh_stackalloc	80
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
.L4269:
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
.L4270:
	mov	rax, QWORD PTR -16[rbp]
	cmp	rax, QWORD PTR -24[rbp]
	jnb	.L4275
	mov	rax, QWORD PTR -16[rbp]
	mov	rdx, QWORD PTR [rax]
	mov	rax, QWORD PTR -8[rbp]
	mov	QWORD PTR [rax], rdx
	add	QWORD PTR -8[rbp], 8
	add	QWORD PTR -16[rbp], 8
	jmp	.L4270
.L4275:
	nop
.L4272:
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 72[rax]
	mov	rax, QWORD PTR 24[rbp]
	mov	eax, DWORD PTR 72[rax]
	mov	DWORD PTR [rdx], eax
	nop
	add	rsp, 80
	pop	rbp
	ret
.L4273:
	.seh_endproc
	.def	_ZN5ArrayIxED1Ev;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIxED1Ev
_ZN5ArrayIxED1Ev:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
.L4277:
.L4278:
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayErase
	nop
	add	rsp, 32
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN3TKO11TYPECONTEXTaSERKS0_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN3TKO11TYPECONTEXTaSERKS0_
_ZN3TKO11TYPECONTEXTaSERKS0_:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
.L4280:
	mov	rax, QWORD PTR 24[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIN3TKO8TYPEINFOEEaSERKS2_
	mov	rax, QWORD PTR 24[rbp]
	lea	rdx, 80[rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 80
	mov	rcx, rax
	call	_ZN5ArrayIjEaSERKS0_
	mov	rax, QWORD PTR 24[rbp]
	lea	rdx, 160[rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 160
	mov	rcx, rax
	call	_ZN5ArrayIxEaSERKS0_
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 240[rax]
	mov	rax, QWORD PTR 24[rbp]
	mov	rax, QWORD PTR 240[rax]
	mov	QWORD PTR [rdx], rax
	mov	rax, QWORD PTR 24[rbp]
	lea	r8, 248[rax]
	mov	rax, QWORD PTR 16[rbp]
	lea	rcx, 248[rax]
	mov	rax, QWORD PTR [r8]
	mov	rdx, QWORD PTR 8[r8]
	mov	QWORD PTR [rcx], rax
	mov	QWORD PTR 8[rcx], rdx
	mov	rax, QWORD PTR 16[r8]
	mov	rdx, QWORD PTR 24[r8]
	mov	QWORD PTR 16[rcx], rax
	mov	QWORD PTR 24[rcx], rdx
	nop
	add	rsp, 32
	pop	rbp
	ret
.L4281:
	.seh_endproc
	.def	_ZN5ArrayIN3TKO6SYMBOLEEC1Ev;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO6SYMBOLEEC1Ev
_ZN5ArrayIN3TKO6SYMBOLEEC1Ev:
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
	mov	QWORD PTR [rax], 64
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
.L4283:
.L4284:
	.seh_endproc
	.def	_ZN5ArrayIN3TKO6SYMBOLEEaSERKS2_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO6SYMBOLEEaSERKS2_
_ZN5ArrayIN3TKO6SYMBOLEEaSERKS2_:
	push	rbp
	.seh_pushreg	rbp
	push	rbx
	.seh_pushreg	rbx
	sub	rsp, 88
	.seh_stackalloc	88
	lea	rbp, 128[rsp]
	.seh_setframe	rbp, 128
	.seh_endprologue
	mov	QWORD PTR -16[rbp], rcx
	mov	QWORD PTR -8[rbp], rdx
.L4286:
	mov	rax, QWORD PTR -8[rbp]
	mov	QWORD PTR 32[rsp], 0
	mov	r9d, 0
	mov	r8d, 0
	mov	rdx, rax
	mov	rcx, QWORD PTR -16[rbp]
	call	fb_ArrayRedimTo
	mov	rax, QWORD PTR -16[rbp]
	mov	rax, QWORD PTR 8[rax]
	mov	QWORD PTR -56[rbp], rax
	mov	rax, QWORD PTR -8[rbp]
	mov	rax, QWORD PTR 8[rax]
	mov	QWORD PTR -64[rbp], rax
	mov	rax, QWORD PTR -8[rbp]
	add	rax, 16
	mov	rdx, QWORD PTR [rax]
	mov	rax, QWORD PTR -64[rbp]
	add	rax, rdx
	mov	QWORD PTR -72[rbp], rax
.L4287:
	mov	rax, QWORD PTR -64[rbp]
	cmp	rax, QWORD PTR -72[rbp]
	jnb	.L4292
	mov	rax, QWORD PTR -56[rbp]
	mov	rdx, QWORD PTR -64[rbp]
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
	mov	rcx, QWORD PTR 48[rdx]
	mov	rbx, QWORD PTR 56[rdx]
	mov	QWORD PTR 48[rax], rcx
	mov	QWORD PTR 56[rax], rbx
	add	QWORD PTR -56[rbp], 64
	add	QWORD PTR -64[rbp], 64
	jmp	.L4287
.L4292:
	nop
.L4289:
	mov	rax, QWORD PTR -16[rbp]
	lea	rdx, 72[rax]
	mov	rax, QWORD PTR -8[rbp]
	mov	eax, DWORD PTR 72[rax]
	mov	DWORD PTR [rdx], eax
	nop
	add	rsp, 88
	pop	rbx
	pop	rbp
	ret
.L4290:
	.seh_endproc
	.def	_ZN5ArrayIN3TKO6SYMBOLEED1Ev;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO6SYMBOLEED1Ev
_ZN5ArrayIN3TKO6SYMBOLEED1Ev:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
.L4294:
.L4295:
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayErase
	nop
	add	rsp, 32
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO8SYMSCOPEEEC1Ev;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO8SYMSCOPEEEC1Ev
_ZN5ArrayIN3TKO8SYMSCOPEEEC1Ev:
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
.L4297:
.L4298:
	.seh_endproc
	.def	_ZN5ArrayIN3TKO8SYMSCOPEEEaSERKS2_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO8SYMSCOPEEEaSERKS2_
_ZN5ArrayIN3TKO8SYMSCOPEEEaSERKS2_:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 80
	.seh_stackalloc	80
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
.L4300:
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
.L4301:
	mov	rax, QWORD PTR -16[rbp]
	cmp	rax, QWORD PTR -24[rbp]
	jnb	.L4306
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
	jmp	.L4301
.L4306:
	nop
.L4303:
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 72[rax]
	mov	rax, QWORD PTR 24[rbp]
	mov	eax, DWORD PTR 72[rax]
	mov	DWORD PTR [rdx], eax
	nop
	add	rsp, 80
	pop	rbp
	ret
.L4304:
	.seh_endproc
	.def	_ZN5ArrayIN3TKO8SYMSCOPEEED1Ev;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO8SYMSCOPEEED1Ev
_ZN5ArrayIN3TKO8SYMSCOPEEED1Ev:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
.L4308:
.L4309:
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayErase
	nop
	add	rsp, 32
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN3TKO11SYMBOLTABLEaSERKS0_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN3TKO11SYMBOLTABLEaSERKS0_
_ZN3TKO11SYMBOLTABLEaSERKS0_:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
.L4311:
	mov	rax, QWORD PTR 24[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIN3TKO6SYMBOLEEaSERKS2_
	mov	rax, QWORD PTR 24[rbp]
	lea	rdx, 80[rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 80
	mov	rcx, rax
	call	_ZN5ArrayIN3TKO8SYMSCOPEEEaSERKS2_
	mov	rax, QWORD PTR 24[rbp]
	lea	rdx, 160[rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 160
	mov	rcx, rax
	call	_ZN5ArrayIjEaSERKS0_
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 240[rax]
	mov	rax, QWORD PTR 24[rbp]
	mov	eax, DWORD PTR 240[rax]
	mov	DWORD PTR [rdx], eax
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 244[rax]
	mov	rax, QWORD PTR 24[rbp]
	mov	eax, DWORD PTR 244[rax]
	mov	DWORD PTR [rdx], eax
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 248[rax]
	mov	rax, QWORD PTR 24[rbp]
	mov	rax, QWORD PTR 248[rax]
	mov	QWORD PTR [rdx], rax
	mov	rax, QWORD PTR 24[rbp]
	lea	rdx, 256[rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 256
	mov	rcx, rax
	call	_ZN5ArrayIjEaSERKS0_
	mov	rax, QWORD PTR 24[rbp]
	lea	rdx, 336[rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 336
	mov	rcx, rax
	call	_ZN5ArrayIjEaSERKS0_
	nop
	add	rsp, 32
	pop	rbp
	ret
.L4312:
	.seh_endproc
	.def	_ZN3TKO8DIAGNOTEC1Ev;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN3TKO8DIAGNOTEC1Ev
_ZN3TKO8DIAGNOTEC1Ev:
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
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	nop
	pop	rbp
	ret
.L4314:
.L4315:
	.seh_endproc
	.def	_ZN3TKO8DIAGNOTEaSERKS0_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN3TKO8DIAGNOTEaSERKS0_
_ZN3TKO8DIAGNOTEaSERKS0_:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 48
	.seh_stackalloc	48
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
.L4317:
	mov	rax, QWORD PTR 24[rbp]
	mov	rdx, QWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	mov	QWORD PTR [rax], rdx
	mov	rax, QWORD PTR 24[rbp]
	add	rax, 8
	mov	rdx, QWORD PTR 16[rbp]
	add	rdx, 8
	mov	rax, QWORD PTR [rax]
	mov	QWORD PTR [rdx], rax
	mov	rax, QWORD PTR 24[rbp]
	lea	rdx, 16[rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 16
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrAssign
	nop
	add	rsp, 48
	pop	rbp
	ret
.L4318:
	.seh_endproc
	.def	_ZN3TKO8DIAGNOTEC1ERKS0_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN3TKO8DIAGNOTEC1ERKS0_
_ZN3TKO8DIAGNOTEC1ERKS0_:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
.L4320:
	mov	rax, QWORD PTR 16[rbp]
	mov	QWORD PTR [rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	QWORD PTR [rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 16
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	rax, QWORD PTR 24[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN3TKO8DIAGNOTEaSERKS0_
	nop
	add	rsp, 32
	pop	rbp
	ret
.L4321:
	.seh_endproc
	.def	_ZN3TKO8DIAGNOTED1Ev;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN3TKO8DIAGNOTED1Ev
_ZN3TKO8DIAGNOTED1Ev:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
.L4323:
.L4324:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 16
	mov	rcx, rax
	call	fb_StrDelete
	nop
	add	rsp, 32
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO8DIAGNOTEEEC1Ev;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO8DIAGNOTEEEC1Ev
_ZN5ArrayIN3TKO8DIAGNOTEEEC1Ev:
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
	mov	QWORD PTR [rax], 40
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
.L4326:
.L4327:
	.seh_endproc
	.def	_ZN5ArrayIN3TKO8DIAGNOTEEEaSERKS2_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO8DIAGNOTEEEaSERKS2_
_ZN5ArrayIN3TKO8DIAGNOTEEEaSERKS2_:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 80
	.seh_stackalloc	80
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
.L4329:
	mov	rax, QWORD PTR 24[rbp]
	lea	rdx, _ZN3TKO8DIAGNOTED1Ev[rip]
	mov	QWORD PTR 32[rsp], rdx
	lea	r9, _ZN3TKO8DIAGNOTEC1Ev[rip]
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
.L4330:
	mov	rax, QWORD PTR -16[rbp]
	cmp	rax, QWORD PTR -24[rbp]
	jnb	.L4335
	mov	rdx, QWORD PTR -16[rbp]
	mov	rax, QWORD PTR -8[rbp]
	mov	rcx, rax
	call	_ZN3TKO8DIAGNOTEaSERKS0_
	add	QWORD PTR -8[rbp], 40
	add	QWORD PTR -16[rbp], 40
	jmp	.L4330
.L4335:
	nop
.L4332:
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 72[rax]
	mov	rax, QWORD PTR 24[rbp]
	mov	eax, DWORD PTR 72[rax]
	mov	DWORD PTR [rdx], eax
	nop
	add	rsp, 80
	pop	rbp
	ret
.L4333:
	.seh_endproc
	.def	_ZN5ArrayIN3TKO8DIAGNOTEEED1Ev;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO8DIAGNOTEEED1Ev
_ZN5ArrayIN3TKO8DIAGNOTEEED1Ev:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
.L4337:
.L4338:
	lea	r8, _ZN3TKO8DIAGNOTED1Ev[rip]
	lea	rdx, _ZN3TKO8DIAGNOTEC1Ev[rip]
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayEraseObj
	nop
	add	rsp, 32
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN3TKO10DIAGNOSTICC1Ev;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN3TKO10DIAGNOSTICC1Ev
_ZN3TKO10DIAGNOSTICC1Ev:
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
	mov	QWORD PTR [rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 16
	mov	QWORD PTR [rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 24
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 48
	mov	rcx, rax
	call	_ZN5ArrayIN3TKO8DIAGNOTEEEC1Ev
	mov	rax, QWORD PTR 16[rbp]
	sub	rax, -128
	mov	BYTE PTR [rax], 0
	nop
	add	rsp, 32
	pop	rbp
	ret
.L4340:
.L4341:
	.seh_endproc
	.def	_ZN3TKO10DIAGNOSTICaSERKS0_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN3TKO10DIAGNOSTICaSERKS0_
_ZN3TKO10DIAGNOSTICaSERKS0_:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 48
	.seh_stackalloc	48
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
.L4343:
	mov	rax, QWORD PTR 24[rbp]
	mov	rdx, QWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	mov	QWORD PTR [rax], rdx
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 8[rax]
	mov	rax, QWORD PTR 24[rbp]
	mov	rax, QWORD PTR 8[rax]
	mov	QWORD PTR [rdx], rax
	mov	rax, QWORD PTR 24[rbp]
	add	rax, 16
	mov	rdx, QWORD PTR 16[rbp]
	add	rdx, 16
	mov	rax, QWORD PTR [rax]
	mov	QWORD PTR [rdx], rax
	mov	rax, QWORD PTR 24[rbp]
	lea	rdx, 24[rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 24
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrAssign
	mov	rax, QWORD PTR 24[rbp]
	lea	rdx, 48[rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 48
	mov	rcx, rax
	call	_ZN5ArrayIN3TKO8DIAGNOTEEEaSERKS2_
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 128[rax]
	mov	rax, QWORD PTR 24[rbp]
	movzx	eax, BYTE PTR 128[rax]
	mov	BYTE PTR [rdx], al
	nop
	add	rsp, 48
	pop	rbp
	ret
.L4344:
	.seh_endproc
	.def	_ZN3TKO10DIAGNOSTICC1ERKS0_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN3TKO10DIAGNOSTICC1ERKS0_
_ZN3TKO10DIAGNOSTICC1ERKS0_:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
.L4346:
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
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 48
	mov	rcx, rax
	call	_ZN5ArrayIN3TKO8DIAGNOTEEEC1Ev
	mov	rax, QWORD PTR 16[rbp]
	sub	rax, -128
	mov	BYTE PTR [rax], 0
	mov	rax, QWORD PTR 24[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN3TKO10DIAGNOSTICaSERKS0_
	nop
	add	rsp, 32
	pop	rbp
	ret
.L4347:
	.seh_endproc
	.def	_ZN3TKO10DIAGNOSTICD1Ev;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN3TKO10DIAGNOSTICD1Ev
_ZN3TKO10DIAGNOSTICD1Ev:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
.L4349:
.L4350:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 48
	mov	rcx, rax
	call	_ZN5ArrayIN3TKO8DIAGNOTEEED1Ev
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 24
	mov	rcx, rax
	call	fb_StrDelete
	nop
	add	rsp, 32
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayIN3TKO10DIAGNOSTICEEC1Ev;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO10DIAGNOSTICEEC1Ev
_ZN5ArrayIN3TKO10DIAGNOSTICEEC1Ev:
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
	mov	QWORD PTR [rax], 136
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
.L4352:
.L4353:
	.seh_endproc
	.def	_ZN5ArrayIN3TKO10DIAGNOSTICEEaSERKS2_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO10DIAGNOSTICEEaSERKS2_
_ZN5ArrayIN3TKO10DIAGNOSTICEEaSERKS2_:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 80
	.seh_stackalloc	80
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
.L4355:
	mov	rax, QWORD PTR 24[rbp]
	lea	rdx, _ZN3TKO10DIAGNOSTICD1Ev[rip]
	mov	QWORD PTR 32[rsp], rdx
	lea	r9, _ZN3TKO10DIAGNOSTICC1Ev[rip]
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
.L4356:
	mov	rax, QWORD PTR -16[rbp]
	cmp	rax, QWORD PTR -24[rbp]
	jnb	.L4361
	mov	rdx, QWORD PTR -16[rbp]
	mov	rax, QWORD PTR -8[rbp]
	mov	rcx, rax
	call	_ZN3TKO10DIAGNOSTICaSERKS0_
	add	QWORD PTR -8[rbp], 136
	add	QWORD PTR -16[rbp], 136
	jmp	.L4356
.L4361:
	nop
.L4358:
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 72[rax]
	mov	rax, QWORD PTR 24[rbp]
	mov	eax, DWORD PTR 72[rax]
	mov	DWORD PTR [rdx], eax
	nop
	add	rsp, 80
	pop	rbp
	ret
.L4359:
	.seh_endproc
	.def	_ZN5ArrayIN3TKO10DIAGNOSTICEED1Ev;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayIN3TKO10DIAGNOSTICEED1Ev
_ZN5ArrayIN3TKO10DIAGNOSTICEED1Ev:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
.L4363:
.L4364:
	lea	r8, _ZN3TKO10DIAGNOSTICD1Ev[rip]
	lea	rdx, _ZN3TKO10DIAGNOSTICC1Ev[rip]
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayEraseObj
	nop
	add	rsp, 32
	pop	rbp
	ret
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
.L4366:
.L4367:
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
.L4369:
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
.L4370:
	mov	rax, QWORD PTR -16[rbp]
	cmp	rax, QWORD PTR -24[rbp]
	jnb	.L4375
	mov	rax, QWORD PTR -16[rbp]
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR -8[rbp]
	mov	DWORD PTR [rax], edx
	add	QWORD PTR -8[rbp], 4
	add	QWORD PTR -16[rbp], 4
	jmp	.L4370
.L4375:
	nop
.L4372:
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 72[rax]
	mov	rax, QWORD PTR 24[rbp]
	mov	eax, DWORD PTR 72[rax]
	mov	DWORD PTR [rdx], eax
	nop
	add	rsp, 80
	pop	rbp
	ret
.L4373:
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
.L4377:
.L4378:
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
.L4380:
.L4381:
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
.L4383:
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
.L4384:
	mov	rax, QWORD PTR -16[rbp]
	cmp	rax, QWORD PTR -24[rbp]
	jnb	.L4389
	mov	rax, QWORD PTR -8[rbp]
	mov	rdx, QWORD PTR -16[rbp]
	mov	rcx, QWORD PTR [rdx]
	mov	QWORD PTR [rax], rcx
	mov	edx, DWORD PTR 8[rdx]
	mov	DWORD PTR 8[rax], edx
	add	QWORD PTR -8[rbp], 12
	add	QWORD PTR -16[rbp], 12
	jmp	.L4384
.L4389:
	nop
.L4386:
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 72[rax]
	mov	rax, QWORD PTR 24[rbp]
	mov	eax, DWORD PTR 72[rax]
	mov	DWORD PTR [rdx], eax
	nop
	add	rsp, 80
	pop	rbp
	ret
.L4387:
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
.L4391:
.L4392:
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayErase
	nop
	add	rsp, 32
	pop	rbp
	ret
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
.L4394:
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
.L4395:
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
.L4397:
.L4398:
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
.L4400:
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
.L4401:
	mov	rax, QWORD PTR -16[rbp]
	cmp	rax, QWORD PTR -24[rbp]
	jnb	.L4406
	mov	rax, QWORD PTR -16[rbp]
	mov	rdx, QWORD PTR [rax]
	mov	rax, QWORD PTR -8[rbp]
	mov	QWORD PTR [rax], rdx
	add	QWORD PTR -8[rbp], 8
	add	QWORD PTR -16[rbp], 8
	jmp	.L4401
.L4406:
	nop
.L4403:
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 72[rax]
	mov	rax, QWORD PTR 24[rbp]
	mov	eax, DWORD PTR 72[rax]
	mov	DWORD PTR [rdx], eax
	nop
	add	rsp, 80
	pop	rbp
	ret
.L4404:
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
.L4408:
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
.L4409:
	.seh_endproc
	.def	_ZN3TKO16DIAGNOSTICENGINEaSERKS0_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN3TKO16DIAGNOSTICENGINEaSERKS0_
_ZN3TKO16DIAGNOSTICENGINEaSERKS0_:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
.L4411:
	mov	rax, QWORD PTR 24[rbp]
	mov	rdx, QWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	mov	QWORD PTR [rax], rdx
	mov	rax, QWORD PTR 24[rbp]
	lea	rdx, 8[rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	rcx, rax
	call	_ZN5ArrayIN3TKO10DIAGNOSTICEEaSERKS2_
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 88[rax]
	mov	rax, QWORD PTR 24[rbp]
	mov	eax, DWORD PTR 88[rax]
	mov	DWORD PTR [rdx], eax
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 92[rax]
	mov	rax, QWORD PTR 24[rbp]
	mov	eax, DWORD PTR 92[rax]
	mov	DWORD PTR [rdx], eax
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 96[rax]
	mov	rax, QWORD PTR 24[rbp]
	mov	eax, DWORD PTR 96[rax]
	mov	DWORD PTR [rdx], eax
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 100[rax]
	mov	rax, QWORD PTR 24[rbp]
	mov	eax, DWORD PTR 100[rax]
	mov	DWORD PTR [rdx], eax
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 104[rax]
	mov	rax, QWORD PTR 24[rbp]
	movzx	eax, BYTE PTR 104[rax]
	mov	BYTE PTR [rdx], al
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 105[rax]
	mov	rax, QWORD PTR 24[rbp]
	movzx	eax, BYTE PTR 105[rax]
	mov	BYTE PTR [rdx], al
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 112[rax]
	mov	rax, QWORD PTR 24[rbp]
	mov	rax, QWORD PTR 112[rax]
	mov	QWORD PTR [rdx], rax
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 120[rax]
	mov	rax, QWORD PTR 24[rbp]
	mov	rax, QWORD PTR 120[rax]
	mov	QWORD PTR [rdx], rax
	mov	rax, QWORD PTR 24[rbp]
	lea	rdx, 128[rax]
	mov	rax, QWORD PTR 16[rbp]
	sub	rax, -128
	mov	rcx, rax
	call	_ZN5ArrayIiEaSERKS0_
	nop
	add	rsp, 32
	pop	rbp
	ret
.L4412:
	.seh_endproc
	.def	_ZN3TKO12SEMANTICINFOaSERKS0_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN3TKO12SEMANTICINFOaSERKS0_
_ZN3TKO12SEMANTICINFOaSERKS0_:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
.L4414:
	mov	rax, QWORD PTR 24[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIjEaSERKS0_
	mov	rax, QWORD PTR 24[rbp]
	lea	rdx, 80[rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 80
	mov	rcx, rax
	call	_ZN5ArrayIjEaSERKS0_
	mov	rax, QWORD PTR 24[rbp]
	lea	rdx, 160[rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 160
	mov	rcx, rax
	call	_ZN5ArrayIjEaSERKS0_
	mov	rax, QWORD PTR 24[rbp]
	lea	rdx, 240[rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 240
	mov	rcx, rax
	call	_ZN5ArrayIhEaSERKS0_
	nop
	add	rsp, 32
	pop	rbp
	ret
.L4415:
	.seh_endproc
	.def	_ZN3TKO7RESOLVE5STATSaSERKS1_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN3TKO7RESOLVE5STATSaSERKS1_
_ZN3TKO7RESOLVE5STATSaSERKS1_:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
.L4417:
	mov	rax, QWORD PTR 24[rbp]
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	mov	DWORD PTR [rax], edx
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 4[rax]
	mov	rax, QWORD PTR 24[rbp]
	mov	eax, DWORD PTR 4[rax]
	mov	DWORD PTR [rdx], eax
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 8[rax]
	mov	rax, QWORD PTR 24[rbp]
	mov	eax, DWORD PTR 8[rax]
	mov	DWORD PTR [rdx], eax
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 12[rax]
	mov	rax, QWORD PTR 24[rbp]
	mov	eax, DWORD PTR 12[rax]
	mov	DWORD PTR [rdx], eax
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 16[rax]
	mov	rax, QWORD PTR 24[rbp]
	mov	eax, DWORD PTR 16[rax]
	mov	DWORD PTR [rdx], eax
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 20[rax]
	mov	rax, QWORD PTR 24[rbp]
	mov	eax, DWORD PTR 20[rax]
	mov	DWORD PTR [rdx], eax
	mov	rax, QWORD PTR 24[rbp]
	lea	rdx, 24[rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 24
	mov	rcx, rax
	call	_ZN5ArrayIjEaSERKS0_
	nop
	add	rsp, 32
	pop	rbp
	ret
.L4418:
	.seh_endproc
	.def	_ZN3TKO7COLLECT13ENUMVISFLAGS_Et;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN3TKO7COLLECT13ENUMVISFLAGS_Et
_ZN3TKO7COLLECT13ENUMVISFLAGS_Et:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	eax, ecx
	mov	WORD PTR 16[rbp], ax
	mov	DWORD PTR -8[rbp], 0
.L4420:
	mov	DWORD PTR -4[rbp], 0
	movzx	eax, WORD PTR 16[rbp]
	and	eax, 1024
	test	rax, rax
	je	.L4427
	or	DWORD PTR -4[rbp], 131072
	jmp	.L4422
.L4427:
	nop
.L4422:
	movzx	eax, WORD PTR 16[rbp]
	and	eax, 2048
	test	rax, rax
	je	.L4428
	or	DWORD PTR -4[rbp], 262144
	jmp	.L4424
.L4428:
	nop
.L4424:
	mov	eax, DWORD PTR -4[rbp]
	mov	DWORD PTR -8[rbp], eax
	nop
.L4425:
	mov	eax, DWORD PTR -8[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN3TKO7COLLECT6STMTOFERNS0_6WALKEREj;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN3TKO7COLLECT6STMTOFERNS0_6WALKEREj
_ZN3TKO7COLLECT6STMTOFERNS0_6WALKEREj:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 64
	.seh_stackalloc	64
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
	mov	QWORD PTR -32[rbp], 0
.L4430:
	cmp	DWORD PTR 24[rbp], 0
	jne	.L4436
	mov	QWORD PTR -32[rbp], 0
	jmp	.L4433
.L4436:
	nop
.L4432:
	mov	edx, DWORD PTR 24[rbp]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN5ArrayIN3TKO7ASTNODEEEixEi
	mov	QWORD PTR -8[rbp], rax
	mov	rax, QWORD PTR -8[rbp]
	mov	QWORD PTR -16[rbp], rax
	mov	rax, QWORD PTR -16[rbp]
	add	rax, 8
	mov	eax, DWORD PTR [rax]
	mov	rdx, QWORD PTR 16[rbp]
	add	rdx, 8
	mov	rdx, QWORD PTR [rdx]
	lea	rcx, 480[rdx]
	mov	edx, eax
	call	_ZN5ArrayIN3TKO11STMTPAYLOADEEixEi
	mov	QWORD PTR -24[rbp], rax
	mov	rax, QWORD PTR -24[rbp]
	mov	QWORD PTR -32[rbp], rax
	nop
.L4433:
	mov	rax, QWORD PTR -32[rbp]
	add	rsp, 64
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN3TKO7COLLECT6LISTOFERNS0_6WALKEREj;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN3TKO7COLLECT6LISTOFERNS0_6WALKEREj
_ZN3TKO7COLLECT6LISTOFERNS0_6WALKEREj:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 64
	.seh_stackalloc	64
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
	mov	QWORD PTR -32[rbp], 0
.L4438:
	cmp	DWORD PTR 24[rbp], 0
	jne	.L4444
	mov	QWORD PTR -32[rbp], 0
	jmp	.L4441
.L4444:
	nop
.L4440:
	mov	edx, DWORD PTR 24[rbp]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN5ArrayIN3TKO7ASTNODEEEixEi
	mov	QWORD PTR -8[rbp], rax
	mov	rax, QWORD PTR -8[rbp]
	mov	QWORD PTR -16[rbp], rax
	mov	rax, QWORD PTR -16[rbp]
	add	rax, 8
	mov	eax, DWORD PTR [rax]
	mov	rdx, QWORD PTR 16[rbp]
	add	rdx, 8
	mov	rdx, QWORD PTR [rdx]
	lea	rcx, 400[rdx]
	mov	edx, eax
	call	_ZN5ArrayIN3TKO11LISTPAYLOADEEixEi
	mov	QWORD PTR -24[rbp], rax
	mov	rax, QWORD PTR -24[rbp]
	mov	QWORD PTR -32[rbp], rax
	nop
.L4441:
	mov	rax, QWORD PTR -32[rbp]
	add	rsp, 64
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN3TKO7COLLECT8DECLARE_ERNS0_6WALKEREjjNS_10SYMBOLKINDEj;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN3TKO7COLLECT8DECLARE_ERNS0_6WALKEREjjNS_10SYMBOLKINDEj
_ZN3TKO7COLLECT8DECLARE_ERNS0_6WALKEREjjNS_10SYMBOLKINDEj:
	push	rbp
	.seh_pushreg	rbp
	sub	rsp, 352
	.seh_stackalloc	352
	lea	rbp, 128[rsp]
	.seh_setframe	rbp, 128
	.seh_endprologue
	mov	QWORD PTR 240[rbp], rcx
	mov	DWORD PTR 248[rbp], edx
	mov	DWORD PTR 256[rbp], r8d
	mov	QWORD PTR 264[rbp], r9
	mov	DWORD PTR 148[rbp], 0
.L4446:
	cmp	DWORD PTR 256[rbp], 0
	jne	.L4481
	mov	DWORD PTR 148[rbp], 0
	jmp	.L4449
.L4481:
	nop
.L4448:
	mov	BYTE PTR 147[rbp], 0
	mov	rax, QWORD PTR 240[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	r9, QWORD PTR 264[rbp]
	mov	r8d, DWORD PTR 256[rbp]
	mov	edx, DWORD PTR 248[rbp]
	lea	rcx, 147[rbp]
	mov	QWORD PTR 40[rsp], rcx
	mov	ecx, DWORD PTR 272[rbp]
	mov	DWORD PTR 32[rsp], ecx
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE10DECLARESYMEjjNS_10SYMBOLKINDEjRb
	mov	DWORD PTR 208[rbp], eax
	mov	eax, DWORD PTR 208[rbp]
	mov	DWORD PTR 204[rbp], eax
	movzx	eax, BYTE PTR 147[rbp]
	test	al, al
	je	.L4482
	mov	rax, QWORD PTR 240[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 204[rbp]
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE8SYMBOLATEj
	mov	QWORD PTR 192[rbp], rax
	mov	rax, QWORD PTR 192[rbp]
	mov	QWORD PTR 184[rbp], rax
	cmp	QWORD PTR 184[rbp], 0
	je	.L4483
	mov	rax, QWORD PTR 240[rbp]
	mov	rax, QWORD PTR [rax]
	test	rax, rax
	setne	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR 216[rbp], rax
	jmp	.L4454
.L4483:
	nop
.L4453:
	mov	QWORD PTR 216[rbp], 0
.L4454:
	cmp	QWORD PTR 216[rbp], 0
	je	.L4484
	mov	rax, QWORD PTR 184[rbp]
	add	rax, 20
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 240[rbp]
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN3TKO13SOURCEMANAGER9ISBUILTINEj
	mov	BYTE PTR 183[rbp], al
	movzx	eax, BYTE PTR 183[rbp]
	mov	BYTE PTR 182[rbp], al
	mov	rax, QWORD PTR 240[rbp]
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 272[rbp]
	mov	rcx, rax
	call	_ZN3TKO13SOURCEMANAGER9ISBUILTINEj
	mov	BYTE PTR 181[rbp], al
	movzx	eax, BYTE PTR 181[rbp]
	mov	BYTE PTR 180[rbp], al
	cmp	BYTE PTR 180[rbp], 0
	je	.L4485
	cmp	BYTE PTR 182[rbp], 0
	sete	al
	mov	BYTE PTR 215[rbp], al
	jmp	.L4459
.L4485:
	nop
.L4458:
	mov	BYTE PTR 215[rbp], 0
.L4459:
	cmp	BYTE PTR 215[rbp], 0
	je	.L4486
	mov	DWORD PTR 148[rbp], 0
	jmp	.L4449
.L4461:
.L4486:
	nop
.L4463:
	cmp	BYTE PTR 182[rbp], 0
	je	.L4487
	cmp	BYTE PTR 180[rbp], 0
	sete	al
	mov	BYTE PTR 214[rbp], al
	jmp	.L4466
.L4487:
	nop
.L4465:
	mov	BYTE PTR 214[rbp], 0
.L4466:
	cmp	BYTE PTR 214[rbp], 0
	je	.L4488
	mov	rax, QWORD PTR 264[rbp]
	mov	edx, eax
	mov	rax, QWORD PTR 184[rbp]
	mov	BYTE PTR [rax], dl
	mov	rax, QWORD PTR 184[rbp]
	lea	rdx, 20[rax]
	mov	eax, DWORD PTR 272[rbp]
	mov	DWORD PTR [rdx], eax
	mov	rax, QWORD PTR 184[rbp]
	add	rax, 40
	mov	QWORD PTR [rax], 0
	mov	rax, QWORD PTR 184[rbp]
	add	rax, 16
	mov	DWORD PTR [rax], 0
	mov	rax, QWORD PTR 184[rbp]
	add	rax, 36
	mov	DWORD PTR [rax], 0
	mov	rax, QWORD PTR 184[rbp]
	add	rax, 24
	mov	DWORD PTR [rax], 0
	mov	rax, QWORD PTR 184[rbp]
	add	rax, 4
	mov	DWORD PTR [rax], 0
	mov	eax, DWORD PTR 204[rbp]
	mov	DWORD PTR 148[rbp], eax
	jmp	.L4449
.L4456:
.L4468:
.L4469:
.L4484:
	nop
	jmp	.L4470
.L4488:
	nop
.L4470:
	mov	rax, QWORD PTR 240[rbp]
	add	rax, 72
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 240[rbp]
	add	rax, 72
	add	edx, 1
	mov	DWORD PTR [rax], edx
	mov	eax, DWORD PTR 272[rbp]
	mov	ecx, eax
	call	_ZN3TKO10POINTRANGEEj
	mov	QWORD PTR 32[rbp], rax
	mov	rax, QWORD PTR 32[rbp]
	mov	QWORD PTR 40[rbp], rax
	lea	rax, 48[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	lea	rax, 48[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9d, 1
	lea	r8, .LC0[rip]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrAssign
	lea	rax, 80[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	lea	rax, 80[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9d, 1
	lea	r8, .LC0[rip]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrAssign
	lea	rax, 112[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	rax, QWORD PTR 240[rbp]
	add	rax, 32
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 256[rbp]
	mov	rcx, rax
	call	_ZN3TKO8INTERNER8SPELLINGEj
	mov	QWORD PTR 168[rbp], rax
	mov	rdx, QWORD PTR 168[rbp]
	lea	rax, 112[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrAssign
	mov	rax, QWORD PTR 240[rbp]
	add	rax, 24
	mov	rax, QWORD PTR [rax]
	lea	r8, 112[rbp]
	mov	rcx, QWORD PTR 40[rbp]
	lea	rdx, 48[rbp]
	mov	QWORD PTR 40[rsp], rdx
	lea	rdx, 80[rbp]
	mov	QWORD PTR 32[rsp], rdx
	mov	r9, r8
	mov	r8, rcx
	mov	edx, 74
	mov	rcx, rax
	call	_ZN3TKO16DIAGNOSTICENGINE6REPORTENS_6DIAGIDENS_11SOURCERANGEE8FBSTRINGS3_S3_
	lea	rax, 48[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	lea	rax, 80[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	lea	rax, 112[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	mov	rax, QWORD PTR 240[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 204[rbp]
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE8SYMBOLATEj
	mov	QWORD PTR 160[rbp], rax
	mov	rax, QWORD PTR 160[rbp]
	mov	QWORD PTR 152[rbp], rax
	cmp	QWORD PTR 152[rbp], 0
	je	.L4489
	lea	rax, -64[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	lea	rax, -64[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9d, 1
	lea	r8, .LC0[rip]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrAssign
	lea	rax, -32[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	lea	rax, -32[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9d, 1
	lea	r8, .LC0[rip]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrAssign
	mov	rax, rbp
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	rax, rbp
	mov	DWORD PTR 32[rsp], 0
	mov	r9d, 1
	lea	r8, .LC0[rip]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrAssign
	mov	rax, QWORD PTR 152[rbp]
	add	rax, 20
	mov	eax, DWORD PTR [rax]
	mov	ecx, eax
	call	_ZN3TKO10POINTRANGEEj
	mov	QWORD PTR -72[rbp], rax
	mov	rax, QWORD PTR 240[rbp]
	add	rax, 24
	mov	rax, QWORD PTR [rax]
	mov	r8, rbp
	mov	rcx, QWORD PTR -72[rbp]
	lea	rdx, -64[rbp]
	mov	QWORD PTR 40[rsp], rdx
	lea	rdx, -32[rbp]
	mov	QWORD PTR 32[rsp], rdx
	mov	r9, r8
	mov	r8, rcx
	mov	edx, 245
	mov	rcx, rax
	call	_ZN3TKO16DIAGNOSTICENGINE7ADDNOTEENS_6DIAGIDENS_11SOURCERANGEE8FBSTRINGS3_S3_
	lea	rax, -64[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	lea	rax, -32[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	mov	rax, rbp
	mov	rcx, rax
	call	fb_StrDelete
.L4472:
.L4473:
	jmp	.L4474
.L4451:
.L4482:
	nop
	jmp	.L4474
.L4489:
	nop
.L4474:
	mov	eax, DWORD PTR 204[rbp]
	mov	DWORD PTR 148[rbp], eax
	nop
.L4449:
	mov	eax, DWORD PTR 148[rbp]
	add	rsp, 352
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN3TKO7COLLECT15ISDYNARRAYITEM_ERNS0_6WALKEREj;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN3TKO7COLLECT15ISDYNARRAYITEM_ERNS0_6WALKEREj
_ZN3TKO7COLLECT15ISDYNARRAYITEM_ERNS0_6WALKEREj:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	add	rsp, -128
	.seh_stackalloc	128
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
	mov	BYTE PTR -89[rbp], 0
.L4491:
	cmp	DWORD PTR 24[rbp], 0
	jne	.L4523
	mov	BYTE PTR -89[rbp], 0
	jmp	.L4494
.L4523:
	nop
.L4493:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN5ArrayIN3TKO7ASTNODEEE5COUNTEv
	mov	DWORD PTR -8[rbp], eax
	mov	eax, DWORD PTR 24[rbp]
	cmp	DWORD PTR -8[rbp], eax
	jg	.L4524
	mov	BYTE PTR -89[rbp], 0
	jmp	.L4494
.L4524:
	nop
.L4496:
	mov	edx, DWORD PTR 24[rbp]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN5ArrayIN3TKO7ASTNODEEEixEi
	mov	QWORD PTR -16[rbp], rax
	mov	rax, QWORD PTR -16[rbp]
	add	rax, 2
	movzx	eax, WORD PTR [rax]
	movzx	eax, ax
	and	eax, 64
	test	rax, rax
	jne	.L4525
	mov	BYTE PTR -89[rbp], 0
	jmp	.L4494
.L4525:
	nop
.L4498:
	mov	eax, DWORD PTR 24[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN3TKO7COLLECT6STMTOFERNS0_6WALKEREj
	mov	QWORD PTR -24[rbp], rax
	mov	rax, QWORD PTR -24[rbp]
	mov	QWORD PTR -32[rbp], rax
	cmp	QWORD PTR -32[rbp], 0
	jne	.L4526
	mov	BYTE PTR -89[rbp], 0
	jmp	.L4494
.L4526:
	nop
.L4500:
	mov	rax, QWORD PTR -32[rbp]
	add	rax, 12
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	jne	.L4527
	mov	BYTE PTR -89[rbp], 1
	jmp	.L4494
.L4527:
	nop
.L4502:
	mov	rax, QWORD PTR -32[rbp]
	add	rax, 12
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN3TKO8ASTARENA4KINDEj
	mov	QWORD PTR -40[rbp], rax
	cmp	QWORD PTR -40[rbp], 29
	je	.L4528
	mov	BYTE PTR -89[rbp], 0
	jmp	.L4494
.L4528:
	nop
.L4504:
	mov	rax, QWORD PTR -32[rbp]
	add	rax, 12
	mov	eax, DWORD PTR [rax]
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN3TKO7COLLECT6LISTOFERNS0_6WALKEREj
	mov	QWORD PTR -48[rbp], rax
	mov	rax, QWORD PTR -48[rbp]
	mov	QWORD PTR -56[rbp], rax
	cmp	QWORD PTR -56[rbp], 0
	jne	.L4529
	mov	BYTE PTR -89[rbp], 0
	jmp	.L4494
.L4529:
	nop
.L4506:
	mov	DWORD PTR -4[rbp], 0
	mov	rax, QWORD PTR -56[rbp]
	add	rax, 8
	mov	eax, DWORD PTR [rax]
	sub	eax, 1
	mov	DWORD PTR -60[rbp], eax
	jmp	.L4507
.L4531:
	nop
.L4508:
	mov	rax, QWORD PTR -56[rbp]
	add	rax, 4
	mov	edx, DWORD PTR [rax]
	mov	eax, DWORD PTR -4[rbp]
	add	edx, eax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	add	rax, 560
	mov	rcx, rax
	call	_ZN5ArrayIjEixEi
	mov	QWORD PTR -72[rbp], rax
	mov	rax, QWORD PTR -72[rbp]
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR -76[rbp], eax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR -76[rbp]
	mov	rcx, rax
	call	_ZN3TKO8ASTARENA4KINDEj
	mov	QWORD PTR -88[rbp], rax
	cmp	QWORD PTR -88[rbp], 6
	je	.L4530
	mov	BYTE PTR -89[rbp], 0
	jmp	.L4494
.L4510:
.L4530:
	nop
.L4511:
	add	DWORD PTR -4[rbp], 1
.L4507:
	mov	eax, DWORD PTR -4[rbp]
	cmp	eax, DWORD PTR -60[rbp]
	jle	.L4531
	nop
.L4512:
	mov	BYTE PTR -89[rbp], 1
	nop
.L4494:
	movzx	eax, BYTE PTR -89[rbp]
	sub	rsp, -128
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN3TKO7COLLECT14SAMEDECLSHAPE_ERNS0_6WALKEREjj;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN3TKO7COLLECT14SAMEDECLSHAPE_ERNS0_6WALKEREjj
_ZN3TKO7COLLECT14SAMEDECLSHAPE_ERNS0_6WALKEREjj:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 144
	.seh_stackalloc	144
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
	mov	DWORD PTR 32[rbp], r8d
	mov	BYTE PTR -99[rbp], 0
.L4533:
	cmp	DWORD PTR 24[rbp], 0
	je	.L4556
	cmp	DWORD PTR 32[rbp], 0
	sete	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -8[rbp], rax
	jmp	.L4536
.L4556:
	nop
.L4535:
	mov	QWORD PTR -8[rbp], -1
.L4536:
	cmp	QWORD PTR -8[rbp], 0
	je	.L4557
	mov	BYTE PTR -99[rbp], 1
	jmp	.L4539
.L4557:
	nop
.L4538:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN5ArrayIN3TKO7ASTNODEEE5COUNTEv
	mov	DWORD PTR -20[rbp], eax
	mov	eax, DWORD PTR 24[rbp]
	cmp	DWORD PTR -20[rbp], eax
	jle	.L4558
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN5ArrayIN3TKO7ASTNODEEE5COUNTEv
	mov	DWORD PTR -24[rbp], eax
	mov	eax, DWORD PTR 32[rbp]
	cmp	DWORD PTR -24[rbp], eax
	setle	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -16[rbp], rax
	jmp	.L4542
.L4558:
	nop
.L4541:
	mov	QWORD PTR -16[rbp], -1
.L4542:
	cmp	QWORD PTR -16[rbp], 0
	je	.L4559
	mov	BYTE PTR -99[rbp], 1
	jmp	.L4539
.L4559:
	nop
.L4544:
	mov	edx, DWORD PTR 24[rbp]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN5ArrayIN3TKO7ASTNODEEEixEi
	mov	QWORD PTR -32[rbp], rax
	mov	rax, QWORD PTR -32[rbp]
	mov	QWORD PTR -40[rbp], rax
	mov	edx, DWORD PTR 32[rbp]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN5ArrayIN3TKO7ASTNODEEEixEi
	mov	QWORD PTR -48[rbp], rax
	mov	rax, QWORD PTR -48[rbp]
	mov	QWORD PTR -56[rbp], rax
	mov	rax, QWORD PTR -40[rbp]
	add	rax, 2
	movzx	eax, WORD PTR [rax]
	movzx	eax, ax
	and	eax, 64
	test	rax, rax
	setne	al
	mov	BYTE PTR -57[rbp], al
	mov	rax, QWORD PTR -56[rbp]
	add	rax, 2
	movzx	eax, WORD PTR [rax]
	movzx	eax, ax
	and	eax, 64
	test	rax, rax
	setne	al
	mov	BYTE PTR -58[rbp], al
	movzx	eax, BYTE PTR -57[rbp]
	cmp	al, BYTE PTR -58[rbp]
	je	.L4560
	mov	BYTE PTR -99[rbp], 0
	jmp	.L4539
.L4560:
	nop
.L4546:
	mov	eax, DWORD PTR 24[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN3TKO7COLLECT6STMTOFERNS0_6WALKEREj
	mov	QWORD PTR -72[rbp], rax
	mov	rax, QWORD PTR -72[rbp]
	mov	QWORD PTR -80[rbp], rax
	mov	eax, DWORD PTR 32[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN3TKO7COLLECT6STMTOFERNS0_6WALKEREj
	mov	QWORD PTR -88[rbp], rax
	mov	rax, QWORD PTR -88[rbp]
	mov	QWORD PTR -96[rbp], rax
	mov	rax, QWORD PTR -96[rbp]
	add	rax, 12
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR -80[rbp]
	add	rax, 12
	mov	eax, DWORD PTR [rax]
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN3TKO7COLLECT11SAMEBOUNDS_ERNS0_6WALKEREjj
	mov	BYTE PTR -97[rbp], al
	cmp	BYTE PTR -97[rbp], 0
	jne	.L4561
	mov	BYTE PTR -99[rbp], 0
	jmp	.L4539
.L4561:
	nop
.L4548:
	mov	rax, QWORD PTR -96[rbp]
	add	rax, 4
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR -80[rbp]
	add	rax, 4
	mov	eax, DWORD PTR [rax]
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN3TKO7COLLECT12SAMETYPEREF_ERNS0_6WALKEREjj
	mov	BYTE PTR -98[rbp], al
	movzx	eax, BYTE PTR -98[rbp]
	mov	BYTE PTR -99[rbp], al
	nop
.L4539:
	movzx	eax, BYTE PTR -99[rbp]
	add	rsp, 144
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN3TKO7COLLECT9DIMCOUNT_ERNS0_6WALKEREj;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN3TKO7COLLECT9DIMCOUNT_ERNS0_6WALKEREj
_ZN3TKO7COLLECT9DIMCOUNT_ERNS0_6WALKEREj:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 64
	.seh_stackalloc	64
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
	mov	DWORD PTR -28[rbp], 0
.L4563:
	cmp	DWORD PTR 24[rbp], 0
	jne	.L4572
	mov	DWORD PTR -28[rbp], 0
	jmp	.L4566
.L4572:
	nop
.L4565:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 24[rbp]
	mov	rcx, rax
	call	_ZN3TKO8ASTARENA4KINDEj
	mov	QWORD PTR -8[rbp], rax
	cmp	QWORD PTR -8[rbp], 29
	je	.L4573
	mov	DWORD PTR -28[rbp], 0
	jmp	.L4566
.L4573:
	nop
.L4568:
	mov	edx, DWORD PTR 24[rbp]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN5ArrayIN3TKO7ASTNODEEEixEi
	mov	QWORD PTR -16[rbp], rax
	mov	rax, QWORD PTR -16[rbp]
	add	rax, 8
	mov	eax, DWORD PTR [rax]
	mov	rdx, QWORD PTR 16[rbp]
	add	rdx, 8
	mov	rdx, QWORD PTR [rdx]
	lea	rcx, 400[rdx]
	mov	edx, eax
	call	_ZN5ArrayIN3TKO11LISTPAYLOADEEixEi
	mov	QWORD PTR -24[rbp], rax
	mov	rax, QWORD PTR -24[rbp]
	mov	eax, DWORD PTR 8[rax]
	mov	DWORD PTR -28[rbp], eax
	nop
.L4566:
	mov	eax, DWORD PTR -28[rbp]
	add	rsp, 64
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN3TKO7COLLECT11SAMEBOUNDS_ERNS0_6WALKEREjj;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN3TKO7COLLECT11SAMEBOUNDS_ERNS0_6WALKEREjj
_ZN3TKO7COLLECT11SAMEBOUNDS_ERNS0_6WALKEREjj:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 224
	.seh_stackalloc	224
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
	mov	DWORD PTR 32[rbp], r8d
	mov	BYTE PTR -188[rbp], 0
.L4575:
	mov	eax, DWORD PTR 24[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN3TKO7COLLECT9DIMCOUNT_ERNS0_6WALKEREj
	mov	DWORD PTR -16[rbp], eax
	mov	eax, DWORD PTR -16[rbp]
	mov	DWORD PTR -20[rbp], eax
	mov	eax, DWORD PTR 32[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN3TKO7COLLECT9DIMCOUNT_ERNS0_6WALKEREj
	mov	DWORD PTR -24[rbp], eax
	mov	eax, DWORD PTR -24[rbp]
	mov	DWORD PTR -28[rbp], eax
	mov	eax, DWORD PTR 24[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN3TKO7COLLECT15ISVARLENBOUNDS_ERNS0_6WALKEREj
	mov	BYTE PTR -29[rbp], al
	movzx	eax, BYTE PTR -29[rbp]
	mov	BYTE PTR -30[rbp], al
	mov	eax, DWORD PTR 32[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN3TKO7COLLECT15ISVARLENBOUNDS_ERNS0_6WALKEREj
	mov	BYTE PTR -31[rbp], al
	movzx	eax, BYTE PTR -31[rbp]
	mov	BYTE PTR -32[rbp], al
	movzx	eax, BYTE PTR -30[rbp]
	cmp	al, BYTE PTR -32[rbp]
	je	.L4619
	mov	BYTE PTR -188[rbp], 0
	jmp	.L4578
.L4619:
	nop
.L4577:
	cmp	BYTE PTR -30[rbp], 0
	je	.L4620
	cmp	DWORD PTR -20[rbp], 0
	je	.L4621
	cmp	DWORD PTR -28[rbp], 0
	sete	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -8[rbp], rax
	jmp	.L4583
.L4621:
	nop
.L4582:
	mov	QWORD PTR -8[rbp], -1
.L4583:
	cmp	QWORD PTR -8[rbp], 0
	je	.L4622
	mov	BYTE PTR -188[rbp], 1
	jmp	.L4578
.L4622:
	nop
.L4585:
	mov	eax, DWORD PTR -20[rbp]
	cmp	eax, DWORD PTR -28[rbp]
	sete	al
	mov	BYTE PTR -188[rbp], al
	jmp	.L4578
.L4580:
.L4620:
	nop
.L4586:
	mov	eax, DWORD PTR -20[rbp]
	cmp	eax, DWORD PTR -28[rbp]
	je	.L4623
	mov	BYTE PTR -188[rbp], 0
	jmp	.L4578
.L4623:
	nop
.L4588:
	mov	edx, DWORD PTR 24[rbp]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN5ArrayIN3TKO7ASTNODEEEixEi
	mov	QWORD PTR -40[rbp], rax
	mov	rax, QWORD PTR -40[rbp]
	add	rax, 8
	mov	eax, DWORD PTR [rax]
	mov	rdx, QWORD PTR 16[rbp]
	add	rdx, 8
	mov	rdx, QWORD PTR [rdx]
	lea	rcx, 400[rdx]
	mov	edx, eax
	call	_ZN5ArrayIN3TKO11LISTPAYLOADEEixEi
	mov	QWORD PTR -48[rbp], rax
	mov	rax, QWORD PTR -48[rbp]
	mov	QWORD PTR -56[rbp], rax
	mov	edx, DWORD PTR 32[rbp]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN5ArrayIN3TKO7ASTNODEEEixEi
	mov	QWORD PTR -64[rbp], rax
	mov	rax, QWORD PTR -64[rbp]
	add	rax, 8
	mov	eax, DWORD PTR [rax]
	mov	rdx, QWORD PTR 16[rbp]
	add	rdx, 8
	mov	rdx, QWORD PTR [rdx]
	lea	rcx, 400[rdx]
	mov	edx, eax
	call	_ZN5ArrayIN3TKO11LISTPAYLOADEEixEi
	mov	QWORD PTR -72[rbp], rax
	mov	rax, QWORD PTR -72[rbp]
	mov	QWORD PTR -80[rbp], rax
	mov	DWORD PTR -12[rbp], 0
	mov	eax, DWORD PTR -20[rbp]
	sub	eax, 1
	mov	DWORD PTR -84[rbp], eax
	jmp	.L4589
.L4631:
	nop
.L4590:
	mov	rax, QWORD PTR -56[rbp]
	add	rax, 4
	mov	edx, DWORD PTR [rax]
	mov	eax, DWORD PTR -12[rbp]
	add	edx, eax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	add	rax, 560
	mov	rcx, rax
	call	_ZN5ArrayIjEixEi
	mov	QWORD PTR -96[rbp], rax
	mov	rax, QWORD PTR -96[rbp]
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR -100[rbp], eax
	mov	rax, QWORD PTR -80[rbp]
	add	rax, 4
	mov	edx, DWORD PTR [rax]
	mov	eax, DWORD PTR -12[rbp]
	add	edx, eax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	add	rax, 560
	mov	rcx, rax
	call	_ZN5ArrayIjEixEi
	mov	QWORD PTR -112[rbp], rax
	mov	rax, QWORD PTR -112[rbp]
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR -116[rbp], eax
	mov	eax, DWORD PTR -100[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN3TKO7COLLECT11ISANYBOUND_ERNS0_6WALKEREj
	mov	BYTE PTR -117[rbp], al
	movzx	eax, BYTE PTR -117[rbp]
	mov	BYTE PTR -118[rbp], al
	mov	eax, DWORD PTR -116[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN3TKO7COLLECT11ISANYBOUND_ERNS0_6WALKEREj
	mov	BYTE PTR -119[rbp], al
	movzx	eax, BYTE PTR -119[rbp]
	mov	BYTE PTR -120[rbp], al
	movzx	eax, BYTE PTR -118[rbp]
	cmp	al, BYTE PTR -120[rbp]
	je	.L4624
	mov	BYTE PTR -188[rbp], 0
	jmp	.L4578
.L4624:
	nop
.L4592:
	cmp	BYTE PTR -118[rbp], 0
	jne	.L4625
	nop
.L4594:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR -100[rbp]
	mov	rcx, rax
	call	_ZN3TKO8ASTARENA4KINDEj
	mov	QWORD PTR -128[rbp], rax
	cmp	QWORD PTR -128[rbp], 35
	sete	al
	mov	BYTE PTR -129[rbp], al
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR -116[rbp]
	mov	rcx, rax
	call	_ZN3TKO8ASTARENA4KINDEj
	mov	QWORD PTR -144[rbp], rax
	cmp	QWORD PTR -144[rbp], 35
	sete	al
	mov	BYTE PTR -145[rbp], al
	movzx	eax, BYTE PTR -129[rbp]
	cmp	al, BYTE PTR -145[rbp]
	jne	.L4626
	nop
.L4597:
	cmp	BYTE PTR -129[rbp], 0
	je	.L4627
	mov	eax, DWORD PTR -100[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN3TKO7COLLECT6STMTOFERNS0_6WALKEREj
	mov	QWORD PTR -160[rbp], rax
	mov	rax, QWORD PTR -160[rbp]
	mov	QWORD PTR -168[rbp], rax
	mov	eax, DWORD PTR -116[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN3TKO7COLLECT6STMTOFERNS0_6WALKEREj
	mov	QWORD PTR -176[rbp], rax
	mov	rax, QWORD PTR -176[rbp]
	mov	QWORD PTR -184[rbp], rax
	mov	rax, QWORD PTR -184[rbp]
	add	rax, 4
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR -168[rbp]
	add	rax, 4
	mov	eax, DWORD PTR [rax]
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN3TKO7COLLECT12SAMELITERAL_ERNS0_6WALKEREjj
	mov	BYTE PTR -185[rbp], al
	cmp	BYTE PTR -185[rbp], 0
	jne	.L4628
	mov	BYTE PTR -188[rbp], 0
	jmp	.L4578
.L4628:
	nop
.L4601:
	mov	rax, QWORD PTR -184[rbp]
	add	rax, 8
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR -168[rbp]
	add	rax, 8
	mov	eax, DWORD PTR [rax]
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN3TKO7COLLECT12SAMELITERAL_ERNS0_6WALKEREjj
	mov	BYTE PTR -186[rbp], al
	cmp	BYTE PTR -186[rbp], 0
	jne	.L4629
	mov	BYTE PTR -188[rbp], 0
	jmp	.L4578
.L4629:
	nop
.L4603:
	jmp	.L4606
.L4627:
	nop
.L4599:
	mov	edx, DWORD PTR -116[rbp]
	mov	eax, DWORD PTR -100[rbp]
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN3TKO7COLLECT12SAMELITERAL_ERNS0_6WALKEREjj
	mov	BYTE PTR -187[rbp], al
	cmp	BYTE PTR -187[rbp], 0
	jne	.L4630
	mov	BYTE PTR -188[rbp], 0
	jmp	.L4578
.L4595:
.L4605:
.L4625:
	nop
	jmp	.L4606
.L4626:
	nop
	jmp	.L4606
.L4630:
	nop
.L4606:
	add	DWORD PTR -12[rbp], 1
.L4589:
	mov	eax, DWORD PTR -12[rbp]
	cmp	eax, DWORD PTR -84[rbp]
	jle	.L4631
	nop
.L4607:
	mov	BYTE PTR -188[rbp], 1
	nop
.L4578:
	movzx	eax, BYTE PTR -188[rbp]
	add	rsp, 224
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN3TKO7COLLECT15SAMECONSTVALUE_ERNS0_6WALKEREjj;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN3TKO7COLLECT15SAMECONSTVALUE_ERNS0_6WALKEREjj
_ZN3TKO7COLLECT15SAMECONSTVALUE_ERNS0_6WALKEREjj:
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
	mov	BYTE PTR -42[rbp], 0
.L4633:
	cmp	DWORD PTR 24[rbp], 0
	je	.L4643
	cmp	DWORD PTR 32[rbp], 0
	sete	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -8[rbp], rax
	jmp	.L4636
.L4643:
	nop
.L4635:
	mov	QWORD PTR -8[rbp], -1
.L4636:
	cmp	QWORD PTR -8[rbp], 0
	je	.L4644
	mov	BYTE PTR -42[rbp], 1
	jmp	.L4639
.L4644:
	nop
.L4638:
	mov	eax, DWORD PTR 24[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN3TKO7COLLECT6STMTOFERNS0_6WALKEREj
	mov	QWORD PTR -16[rbp], rax
	mov	rax, QWORD PTR -16[rbp]
	mov	QWORD PTR -24[rbp], rax
	mov	eax, DWORD PTR 32[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN3TKO7COLLECT6STMTOFERNS0_6WALKEREj
	mov	QWORD PTR -32[rbp], rax
	mov	rax, QWORD PTR -32[rbp]
	mov	QWORD PTR -40[rbp], rax
	mov	rax, QWORD PTR -40[rbp]
	add	rax, 8
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR -24[rbp]
	add	rax, 8
	mov	eax, DWORD PTR [rax]
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN3TKO7COLLECT12SAMELITERAL_ERNS0_6WALKEREjj
	mov	BYTE PTR -41[rbp], al
	movzx	eax, BYTE PTR -41[rbp]
	mov	BYTE PTR -42[rbp], al
	nop
.L4639:
	movzx	eax, BYTE PTR -42[rbp]
	add	rsp, 80
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN3TKO7COLLECT15ISVARLENBOUNDS_ERNS0_6WALKEREj;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN3TKO7COLLECT15ISVARLENBOUNDS_ERNS0_6WALKEREj
_ZN3TKO7COLLECT15ISVARLENBOUNDS_ERNS0_6WALKEREj:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 96
	.seh_stackalloc	96
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
	mov	BYTE PTR -58[rbp], 0
.L4646:
	mov	eax, DWORD PTR 24[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN3TKO7COLLECT9DIMCOUNT_ERNS0_6WALKEREj
	mov	DWORD PTR -8[rbp], eax
	mov	eax, DWORD PTR -8[rbp]
	mov	DWORD PTR -12[rbp], eax
	cmp	DWORD PTR -12[rbp], 0
	jne	.L4661
	mov	BYTE PTR -58[rbp], 1
	jmp	.L4649
.L4661:
	nop
.L4648:
	mov	edx, DWORD PTR 24[rbp]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN5ArrayIN3TKO7ASTNODEEEixEi
	mov	QWORD PTR -24[rbp], rax
	mov	rax, QWORD PTR -24[rbp]
	add	rax, 8
	mov	eax, DWORD PTR [rax]
	mov	rdx, QWORD PTR 16[rbp]
	add	rdx, 8
	mov	rdx, QWORD PTR [rdx]
	lea	rcx, 400[rdx]
	mov	edx, eax
	call	_ZN5ArrayIN3TKO11LISTPAYLOADEEixEi
	mov	QWORD PTR -32[rbp], rax
	mov	rax, QWORD PTR -32[rbp]
	mov	QWORD PTR -40[rbp], rax
	mov	DWORD PTR -4[rbp], 0
	mov	eax, DWORD PTR -12[rbp]
	sub	eax, 1
	mov	DWORD PTR -44[rbp], eax
	jmp	.L4650
.L4663:
	nop
.L4651:
	mov	rax, QWORD PTR -40[rbp]
	add	rax, 4
	mov	edx, DWORD PTR [rax]
	mov	eax, DWORD PTR -4[rbp]
	add	edx, eax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	add	rax, 560
	mov	rcx, rax
	call	_ZN5ArrayIjEixEi
	mov	QWORD PTR -56[rbp], rax
	mov	rax, QWORD PTR -56[rbp]
	mov	eax, DWORD PTR [rax]
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN3TKO7COLLECT11ISANYBOUND_ERNS0_6WALKEREj
	mov	BYTE PTR -57[rbp], al
	cmp	BYTE PTR -57[rbp], 0
	jne	.L4662
	mov	BYTE PTR -58[rbp], 0
	jmp	.L4649
.L4653:
.L4654:
.L4662:
	nop
.L4655:
	add	DWORD PTR -4[rbp], 1
.L4650:
	mov	eax, DWORD PTR -4[rbp]
	cmp	eax, DWORD PTR -44[rbp]
	jle	.L4663
	nop
.L4656:
	mov	BYTE PTR -58[rbp], 1
	nop
.L4649:
	movzx	eax, BYTE PTR -58[rbp]
	add	rsp, 96
	pop	rbp
	ret
	.seh_endproc
	.section .rdata,"dr"
.LC10:
	.ascii "any\0"
	.text
	.def	_ZN3TKO7COLLECT11ISANYBOUND_ERNS0_6WALKEREj;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN3TKO7COLLECT11ISANYBOUND_ERNS0_6WALKEREj
_ZN3TKO7COLLECT11ISANYBOUND_ERNS0_6WALKEREj:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 80
	.seh_stackalloc	80
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
	mov	BYTE PTR -45[rbp], 0
.L4665:
	cmp	DWORD PTR 24[rbp], 0
	jne	.L4674
	mov	BYTE PTR -45[rbp], 0
	jmp	.L4668
.L4674:
	nop
.L4667:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 24[rbp]
	mov	rcx, rax
	call	_ZN3TKO8ASTARENA4KINDEj
	mov	QWORD PTR -8[rbp], rax
	cmp	QWORD PTR -8[rbp], 6
	je	.L4675
	mov	BYTE PTR -45[rbp], 0
	jmp	.L4668
.L4675:
	nop
.L4670:
	mov	edx, DWORD PTR 24[rbp]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN5ArrayIN3TKO7ASTNODEEEixEi
	mov	QWORD PTR -16[rbp], rax
	mov	rax, QWORD PTR -16[rbp]
	add	rax, 8
	mov	eax, DWORD PTR [rax]
	mov	rdx, QWORD PTR 16[rbp]
	add	rdx, 8
	mov	rdx, QWORD PTR [rdx]
	lea	rcx, 320[rdx]
	mov	edx, eax
	call	_ZN5ArrayIN3TKO12IDENTPAYLOADEEixEi
	mov	QWORD PTR -24[rbp], rax
	mov	rax, QWORD PTR -24[rbp]
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR -28[rbp], eax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 32
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR -28[rbp]
	mov	rcx, rax
	call	_ZN3TKO8INTERNER8SPELLINGEj
	mov	QWORD PTR -40[rbp], rax
	mov	rax, QWORD PTR -40[rbp]
	mov	r9d, 4
	lea	r8, .LC10[rip]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrCompare
	mov	DWORD PTR -44[rbp], eax
	cmp	DWORD PTR -44[rbp], 0
	sete	al
	mov	BYTE PTR -45[rbp], al
	nop
.L4668:
	movzx	eax, BYTE PTR -45[rbp]
	add	rsp, 80
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN3TKO7COLLECT12SAMELITERAL_ERNS0_6WALKEREjj;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN3TKO7COLLECT12SAMELITERAL_ERNS0_6WALKEREjj
_ZN3TKO7COLLECT12SAMELITERAL_ERNS0_6WALKEREjj:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 144
	.seh_stackalloc	144
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
	mov	DWORD PTR 32[rbp], r8d
	mov	BYTE PTR -83[rbp], 0
.L4677:
	cmp	DWORD PTR 24[rbp], 0
	je	.L4700
	cmp	DWORD PTR 32[rbp], 0
	setne	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -8[rbp], rax
	jmp	.L4680
.L4700:
	nop
.L4679:
	mov	QWORD PTR -8[rbp], 0
.L4680:
	cmp	QWORD PTR -8[rbp], 0
	je	.L4701
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 24[rbp]
	mov	rcx, rax
	call	_ZN3TKO8ASTARENA4KINDEj
	mov	QWORD PTR -24[rbp], rax
	cmp	QWORD PTR -24[rbp], 3
	jne	.L4702
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 32[rbp]
	mov	rcx, rax
	call	_ZN3TKO8ASTARENA4KINDEj
	mov	QWORD PTR -32[rbp], rax
	cmp	QWORD PTR -32[rbp], 3
	sete	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -16[rbp], rax
	jmp	.L4685
.L4702:
	nop
.L4684:
	mov	QWORD PTR -16[rbp], 0
.L4685:
	cmp	QWORD PTR -16[rbp], 0
	je	.L4703
	mov	edx, DWORD PTR 24[rbp]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN5ArrayIN3TKO7ASTNODEEEixEi
	mov	QWORD PTR -40[rbp], rax
	mov	rax, QWORD PTR -40[rbp]
	add	rax, 8
	mov	eax, DWORD PTR [rax]
	mov	rdx, QWORD PTR 16[rbp]
	add	rdx, 8
	mov	rdx, QWORD PTR [rdx]
	lea	rcx, 240[rdx]
	mov	edx, eax
	call	_ZN5ArrayIN3TKO14LITERALPAYLOADEEixEi
	mov	QWORD PTR -48[rbp], rax
	mov	rax, QWORD PTR -48[rbp]
	movsd	xmm0, QWORD PTR 8[rax]
	movsd	QWORD PTR -56[rbp], xmm0
	mov	edx, DWORD PTR 32[rbp]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN5ArrayIN3TKO7ASTNODEEEixEi
	mov	QWORD PTR -64[rbp], rax
	mov	rax, QWORD PTR -64[rbp]
	add	rax, 8
	mov	eax, DWORD PTR [rax]
	mov	rdx, QWORD PTR 16[rbp]
	add	rdx, 8
	mov	rdx, QWORD PTR [rdx]
	lea	rcx, 240[rdx]
	mov	edx, eax
	call	_ZN5ArrayIN3TKO14LITERALPAYLOADEEixEi
	mov	QWORD PTR -72[rbp], rax
	mov	rax, QWORD PTR -72[rbp]
	movsd	xmm0, QWORD PTR 8[rax]
	movsd	QWORD PTR -80[rbp], xmm0
	movsd	xmm0, QWORD PTR -56[rbp]
	ucomisd	xmm0, QWORD PTR -80[rbp]
	setnp	al
	mov	edx, 0
	movsd	xmm0, QWORD PTR -56[rbp]
	ucomisd	xmm0, QWORD PTR -80[rbp]
	cmovne	eax, edx
	movzx	eax, al
	neg	eax
	test	eax, eax
	setne	al
	mov	BYTE PTR -83[rbp], al
	jmp	.L4687
.L4682:
.L4688:
.L4689:
.L4701:
	nop
	jmp	.L4690
.L4703:
	nop
.L4690:
	mov	QWORD PTR -96[rbp], 0
	mov	QWORD PTR -104[rbp], 0
	lea	rdx, -96[rbp]
	mov	eax, DWORD PTR 24[rbp]
	mov	r8, rdx
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN3TKO7COLLECT11LITERALLEN_ERNS0_6WALKEREjRx
	mov	BYTE PTR -81[rbp], al
	cmp	BYTE PTR -81[rbp], 0
	jne	.L4704
	mov	BYTE PTR -83[rbp], 1
	jmp	.L4687
.L4704:
	nop
.L4692:
	lea	rdx, -104[rbp]
	mov	eax, DWORD PTR 32[rbp]
	mov	r8, rdx
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN3TKO7COLLECT11LITERALLEN_ERNS0_6WALKEREjRx
	mov	BYTE PTR -82[rbp], al
	cmp	BYTE PTR -82[rbp], 0
	jne	.L4705
	mov	BYTE PTR -83[rbp], 1
	jmp	.L4687
.L4705:
	nop
.L4694:
	mov	rdx, QWORD PTR -96[rbp]
	mov	rax, QWORD PTR -104[rbp]
	cmp	rdx, rax
	sete	al
	mov	BYTE PTR -83[rbp], al
	nop
.L4687:
	movzx	eax, BYTE PTR -83[rbp]
	add	rsp, 144
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN3TKO7COLLECT12SAMETYPEREF_ERNS0_6WALKEREjj;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN3TKO7COLLECT12SAMETYPEREF_ERNS0_6WALKEREjj
_ZN3TKO7COLLECT12SAMETYPEREF_ERNS0_6WALKEREjj:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 176
	.seh_stackalloc	176
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
	mov	DWORD PTR 32[rbp], r8d
	mov	BYTE PTR -113[rbp], 0
.L4707:
	cmp	DWORD PTR 24[rbp], 0
	je	.L4751
	cmp	DWORD PTR 32[rbp], 0
	sete	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -8[rbp], rax
	jmp	.L4710
.L4751:
	nop
.L4709:
	mov	QWORD PTR -8[rbp], -1
.L4710:
	cmp	QWORD PTR -8[rbp], 0
	je	.L4752
	mov	BYTE PTR -113[rbp], 1
	jmp	.L4713
.L4752:
	nop
.L4712:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 24[rbp]
	mov	rcx, rax
	call	_ZN3TKO8ASTARENA4KINDEj
	mov	QWORD PTR -40[rbp], rax
	cmp	QWORD PTR -40[rbp], 28
	jne	.L4753
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 32[rbp]
	mov	rcx, rax
	call	_ZN3TKO8ASTARENA4KINDEj
	mov	QWORD PTR -48[rbp], rax
	cmp	QWORD PTR -48[rbp], 28
	setne	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -16[rbp], rax
	jmp	.L4716
.L4753:
	nop
.L4715:
	mov	QWORD PTR -16[rbp], -1
.L4716:
	cmp	QWORD PTR -16[rbp], 0
	je	.L4754
	mov	BYTE PTR -113[rbp], 1
	jmp	.L4713
.L4718:
.L4754:
	nop
.L4719:
	mov	eax, DWORD PTR 24[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN3TKO7COLLECT6STMTOFERNS0_6WALKEREj
	mov	QWORD PTR -56[rbp], rax
	mov	rax, QWORD PTR -56[rbp]
	mov	QWORD PTR -64[rbp], rax
	mov	eax, DWORD PTR 32[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN3TKO7COLLECT6STMTOFERNS0_6WALKEREj
	mov	QWORD PTR -72[rbp], rax
	mov	rax, QWORD PTR -72[rbp]
	mov	QWORD PTR -80[rbp], rax
	mov	edx, DWORD PTR 24[rbp]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN5ArrayIN3TKO7ASTNODEEEixEi
	mov	QWORD PTR -88[rbp], rax
	mov	rax, QWORD PTR -88[rbp]
	add	rax, 2
	movzx	eax, WORD PTR [rax]
	movzx	eax, ax
	and	eax, 8192
	test	rax, rax
	setne	al
	mov	BYTE PTR -89[rbp], al
	mov	edx, DWORD PTR 32[rbp]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN5ArrayIN3TKO7ASTNODEEEixEi
	mov	QWORD PTR -104[rbp], rax
	mov	rax, QWORD PTR -104[rbp]
	add	rax, 2
	movzx	eax, WORD PTR [rax]
	movzx	eax, ax
	and	eax, 8192
	test	rax, rax
	setne	al
	mov	BYTE PTR -105[rbp], al
	movzx	eax, BYTE PTR -89[rbp]
	cmp	al, BYTE PTR -105[rbp]
	je	.L4755
	mov	BYTE PTR -113[rbp], 0
	jmp	.L4713
.L4755:
	nop
.L4721:
	mov	rax, QWORD PTR -64[rbp]
	add	rax, 24
	movzx	eax, WORD PTR [rax]
	cmp	ax, 3
	sete	al
	mov	BYTE PTR -106[rbp], al
	mov	rax, QWORD PTR -80[rbp]
	add	rax, 24
	movzx	eax, WORD PTR [rax]
	cmp	ax, 3
	sete	al
	mov	BYTE PTR -107[rbp], al
	cmp	BYTE PTR -106[rbp], 0
	jne	.L4756
	cmp	BYTE PTR -107[rbp], 0
	sete	al
	mov	BYTE PTR -17[rbp], al
	jmp	.L4724
.L4756:
	nop
.L4723:
	mov	BYTE PTR -17[rbp], 0
.L4724:
	cmp	BYTE PTR -17[rbp], 0
	je	.L4757
	mov	rax, QWORD PTR -64[rbp]
	add	rax, 24
	movzx	edx, WORD PTR [rax]
	mov	rax, QWORD PTR -80[rbp]
	add	rax, 24
	movzx	eax, WORD PTR [rax]
	cmp	dx, ax
	je	.L4758
	mov	BYTE PTR -113[rbp], 0
	jmp	.L4713
.L4726:
.L4728:
.L4757:
	nop
	jmp	.L4729
.L4758:
	nop
.L4729:
	mov	QWORD PTR -128[rbp], 0
	mov	QWORD PTR -136[rbp], 0
	mov	rax, QWORD PTR -64[rbp]
	add	rax, 12
	mov	eax, DWORD PTR [rax]
	lea	rdx, -128[rbp]
	mov	r8, rdx
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN3TKO7COLLECT11LITERALLEN_ERNS0_6WALKEREjRx
	mov	BYTE PTR -108[rbp], al
	movzx	eax, BYTE PTR -108[rbp]
	mov	BYTE PTR -109[rbp], al
	mov	rax, QWORD PTR -80[rbp]
	add	rax, 12
	mov	eax, DWORD PTR [rax]
	lea	rdx, -136[rbp]
	mov	r8, rdx
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN3TKO7COLLECT11LITERALLEN_ERNS0_6WALKEREjRx
	mov	BYTE PTR -110[rbp], al
	movzx	eax, BYTE PTR -110[rbp]
	mov	BYTE PTR -111[rbp], al
	cmp	BYTE PTR -109[rbp], 0
	je	.L4759
	cmp	BYTE PTR -111[rbp], 0
	setne	al
	mov	BYTE PTR -18[rbp], al
	jmp	.L4732
.L4759:
	nop
.L4731:
	mov	BYTE PTR -18[rbp], 0
.L4732:
	movsx	eax, BYTE PTR -18[rbp]
	neg	eax
	test	eax, eax
	je	.L4760
	mov	rdx, QWORD PTR -128[rbp]
	mov	rax, QWORD PTR -136[rbp]
	cmp	rdx, rax
	setne	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -32[rbp], rax
	jmp	.L4735
.L4760:
	nop
.L4734:
	mov	QWORD PTR -32[rbp], 0
.L4735:
	cmp	QWORD PTR -32[rbp], 0
	je	.L4761
	mov	BYTE PTR -113[rbp], 0
	jmp	.L4713
.L4761:
	nop
.L4737:
	movzx	eax, BYTE PTR -109[rbp]
	cmp	al, BYTE PTR -111[rbp]
	je	.L4762
	mov	BYTE PTR -113[rbp], 0
	jmp	.L4713
.L4762:
	nop
.L4739:
	mov	rax, QWORD PTR -80[rbp]
	add	rax, 4
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR -64[rbp]
	add	rax, 4
	mov	eax, DWORD PTR [rax]
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN3TKO7COLLECT12SAMETYPEREF_ERNS0_6WALKEREjj
	mov	BYTE PTR -112[rbp], al
	movzx	eax, BYTE PTR -112[rbp]
	mov	BYTE PTR -113[rbp], al
	nop
.L4713:
	movzx	eax, BYTE PTR -113[rbp]
	add	rsp, 176
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN3TKO7COLLECT11LITERALLEN_ERNS0_6WALKEREjRx;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN3TKO7COLLECT11LITERALLEN_ERNS0_6WALKEREjRx
_ZN3TKO7COLLECT11LITERALLEN_ERNS0_6WALKEREjRx:
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
	mov	BYTE PTR -25[rbp], 0
.L4764:
	cmp	DWORD PTR 24[rbp], 0
	jne	.L4773
	mov	BYTE PTR -25[rbp], 0
	jmp	.L4767
.L4773:
	nop
.L4766:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 24[rbp]
	mov	rcx, rax
	call	_ZN3TKO8ASTARENA4KINDEj
	mov	QWORD PTR -8[rbp], rax
	cmp	QWORD PTR -8[rbp], 2
	je	.L4774
	mov	BYTE PTR -25[rbp], 0
	jmp	.L4767
.L4774:
	nop
.L4769:
	mov	edx, DWORD PTR 24[rbp]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN5ArrayIN3TKO7ASTNODEEEixEi
	mov	QWORD PTR -16[rbp], rax
	mov	rax, QWORD PTR -16[rbp]
	add	rax, 8
	mov	eax, DWORD PTR [rax]
	mov	rdx, QWORD PTR 16[rbp]
	add	rdx, 8
	mov	rdx, QWORD PTR [rdx]
	lea	rcx, 240[rdx]
	mov	edx, eax
	call	_ZN5ArrayIN3TKO14LITERALPAYLOADEEixEi
	mov	QWORD PTR -24[rbp], rax
	mov	rax, QWORD PTR -24[rbp]
	mov	rdx, QWORD PTR [rax]
	mov	rax, QWORD PTR 32[rbp]
	mov	QWORD PTR [rax], rdx
	mov	BYTE PTR -25[rbp], 1
	nop
.L4767:
	movzx	eax, BYTE PTR -25[rbp]
	add	rsp, 64
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN3TKO7COLLECT18LOOKUPDOTTEDOWNER_ERNS0_6WALKEREjj;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN3TKO7COLLECT18LOOKUPDOTTEDOWNER_ERNS0_6WALKEREjj
_ZN3TKO7COLLECT18LOOKUPDOTTEDOWNER_ERNS0_6WALKEREjj:
	push	rbp
	.seh_pushreg	rbp
	sub	rsp, 320
	.seh_stackalloc	320
	lea	rbp, 128[rsp]
	.seh_setframe	rbp, 128
	.seh_endprologue
	mov	QWORD PTR 208[rbp], rcx
	mov	DWORD PTR 216[rbp], edx
	mov	DWORD PTR 224[rbp], r8d
	mov	DWORD PTR 36[rbp], 0
.L4776:
	mov	rax, QWORD PTR 208[rbp]
	add	rax, 32
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 224[rbp]
	mov	rcx, rax
	call	_ZN3TKO8INTERNER8SPELLINGEj
	mov	QWORD PTR 160[rbp], rax
	mov	rdx, QWORD PTR 160[rbp]
	mov	rax, rbp
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrInit
	mov	edx, 1
	lea	rcx, .LC4[rip]
	call	fb_StrAllocTempDescZEx
	mov	QWORD PTR 152[rbp], rax
	mov	rdx, QWORD PTR 152[rbp]
	mov	rax, rbp
	mov	r8, rdx
	mov	rdx, rax
	mov	ecx, 1
	call	fb_StrInstr
	mov	QWORD PTR 144[rbp], rax
	cmp	QWORD PTR 144[rbp], 0
	jne	.L4805
	mov	rax, QWORD PTR 208[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	ecx, DWORD PTR 224[rbp]
	mov	edx, DWORD PTR 216[rbp]
	mov	r9d, 1
	mov	r8d, ecx
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE11LOOKUPTYPEDEjjb
	mov	DWORD PTR 140[rbp], eax
	mov	eax, DWORD PTR 140[rbp]
	mov	DWORD PTR 36[rbp], eax
	mov	rax, rbp
	mov	rcx, rax
	call	fb_StrDelete
	jmp	.L4779
.L4778:
.L4805:
	nop
.L4780:
	mov	eax, DWORD PTR 216[rbp]
	mov	DWORD PTR 188[rbp], eax
	mov	BYTE PTR 187[rbp], 1
	mov	DWORD PTR 180[rbp], 0
	mov	DWORD PTR 176[rbp], 0
.L4781:
	mov	rax, rbp
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrLen
	mov	QWORD PTR 128[rbp], rax
	mov	eax, DWORD PTR 180[rbp]
	cdqe
	cmp	QWORD PTR 128[rbp], rax
	jl	.L4806
	mov	edx, 1
	lea	rcx, .LC4[rip]
	call	fb_StrAllocTempDescZEx
	mov	QWORD PTR 120[rbp], rax
	mov	eax, DWORD PTR 180[rbp]
	cdqe
	lea	rcx, 1[rax]
	mov	rdx, QWORD PTR 120[rbp]
	mov	rax, rbp
	mov	r8, rdx
	mov	rdx, rax
	call	fb_StrInstr
	mov	QWORD PTR 112[rbp], rax
	mov	rax, QWORD PTR 112[rbp]
	mov	DWORD PTR 108[rbp], eax
	mov	eax, DWORD PTR 108[rbp]
	mov	DWORD PTR 172[rbp], eax
	cmp	DWORD PTR 172[rbp], 0
	jne	.L4807
	mov	rax, rbp
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrLen
	mov	QWORD PTR 96[rbp], rax
	mov	rax, QWORD PTR 96[rbp]
	add	eax, 1
	mov	DWORD PTR 172[rbp], eax
	jmp	.L4785
.L4807:
	nop
.L4785:
	mov	eax, DWORD PTR 172[rbp]
	movsx	rdx, eax
	mov	eax, DWORD PTR 180[rbp]
	cdqe
	sub	rdx, rax
	mov	rax, rdx
	lea	rcx, -1[rax]
	mov	eax, DWORD PTR 180[rbp]
	cdqe
	lea	rdx, 1[rax]
	mov	rax, rbp
	mov	r8, rcx
	mov	rcx, rax
	call	fb_StrMid
	mov	QWORD PTR 88[rbp], rax
	mov	rdx, QWORD PTR 88[rbp]
	lea	rax, -64[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrInit
	lea	rax, -64[rbp]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrLen
	mov	QWORD PTR 80[rbp], rax
	cmp	QWORD PTR 80[rbp], 0
	jne	.L4808
	mov	DWORD PTR 36[rbp], 0
	lea	rax, -64[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	mov	rax, rbp
	mov	rcx, rax
	call	fb_StrDelete
	jmp	.L4779
.L4808:
	nop
.L4787:
	lea	rax, -32[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	lea	rdx, -64[rbp]
	lea	rax, -32[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrAssign
	mov	rax, QWORD PTR 208[rbp]
	add	rax, 32
	mov	rax, QWORD PTR [rax]
	lea	rdx, -32[rbp]
	mov	rcx, rax
	call	_ZN3TKO8INTERNER9GETSTRINGE8FBSTRING
	mov	DWORD PTR 76[rbp], eax
	mov	rax, QWORD PTR 208[rbp]
	add	rax, 32
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 76[rbp]
	mov	rcx, rax
	call	_ZN3TKO8INTERNER4FOLDEj
	mov	DWORD PTR 72[rbp], eax
	mov	eax, DWORD PTR 72[rbp]
	mov	DWORD PTR 68[rbp], eax
	lea	rax, -32[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	mov	DWORD PTR -68[rbp], 0
	cmp	BYTE PTR 187[rbp], 0
	je	.L4809
	mov	rax, QWORD PTR 208[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	ecx, DWORD PTR 68[rbp]
	mov	edx, DWORD PTR 188[rbp]
	mov	r9d, 1
	mov	r8d, ecx
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE11LOOKUPTYPEDEjjb
	mov	DWORD PTR 64[rbp], eax
	mov	eax, DWORD PTR 64[rbp]
	mov	DWORD PTR -68[rbp], eax
	jmp	.L4791
.L4809:
	nop
.L4790:
	mov	rax, QWORD PTR 208[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	ecx, DWORD PTR 68[rbp]
	mov	edx, DWORD PTR 188[rbp]
	mov	r9d, 1
	mov	r8d, ecx
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE16LOOKUPLOCALTYPEDEjjb
	mov	DWORD PTR 60[rbp], eax
	mov	eax, DWORD PTR 60[rbp]
	mov	DWORD PTR -68[rbp], eax
.L4791:
	mov	edx, DWORD PTR -68[rbp]
	mov	rax, QWORD PTR 208[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE8SYMBOLATEj
	mov	QWORD PTR 48[rbp], rax
	mov	rax, QWORD PTR 48[rbp]
	mov	QWORD PTR 40[rbp], rax
	cmp	QWORD PTR 40[rbp], 0
	jne	.L4810
	mov	DWORD PTR 36[rbp], 0
	lea	rax, -64[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	mov	rax, rbp
	mov	rcx, rax
	call	fb_StrDelete
	jmp	.L4779
.L4810:
	nop
.L4793:
	mov	eax, DWORD PTR -68[rbp]
	mov	DWORD PTR 176[rbp], eax
	mov	BYTE PTR 187[rbp], 0
	cmp	DWORD PTR 108[rbp], 0
	jne	.L4811
	lea	rax, -64[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	jmp	.L4783
.L4811:
	nop
.L4795:
	mov	rax, QWORD PTR 40[rbp]
	add	rax, 36
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	jne	.L4812
	mov	DWORD PTR 36[rbp], 0
	lea	rax, -64[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	mov	rax, rbp
	mov	rcx, rax
	call	fb_StrDelete
	jmp	.L4779
.L4812:
	nop
.L4797:
	mov	rax, QWORD PTR 40[rbp]
	mov	eax, DWORD PTR 36[rax]
	mov	DWORD PTR 188[rbp], eax
	mov	eax, DWORD PTR 108[rbp]
	mov	DWORD PTR 180[rbp], eax
	lea	rax, -64[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	jmp	.L4781
.L4806:
	nop
.L4783:
	mov	eax, DWORD PTR 176[rbp]
	mov	DWORD PTR 36[rbp], eax
	mov	rax, rbp
	mov	rcx, rax
	call	fb_StrDelete
	nop
.L4779:
	mov	eax, DWORD PTR 36[rbp]
	add	rsp, 320
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN3TKO7COLLECT12WALKCHILDRENERNS0_6WALKEREiij;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN3TKO7COLLECT12WALKCHILDRENERNS0_6WALKEREiij
_ZN3TKO7COLLECT12WALKCHILDRENERNS0_6WALKEREiij:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 48
	.seh_stackalloc	48
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
	mov	DWORD PTR 32[rbp], r8d
	mov	DWORD PTR 40[rbp], r9d
.L4814:
	mov	DWORD PTR -4[rbp], 0
	mov	eax, DWORD PTR 32[rbp]
	sub	eax, 1
	mov	DWORD PTR -8[rbp], eax
	jmp	.L4815
.L4821:
	nop
.L4816:
	mov	edx, DWORD PTR 24[rbp]
	mov	eax, DWORD PTR -4[rbp]
	add	edx, eax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	add	rax, 560
	mov	rcx, rax
	call	_ZN5ArrayIjEixEi
	mov	QWORD PTR -16[rbp], rax
	mov	rax, QWORD PTR -16[rbp]
	mov	eax, DWORD PTR [rax]
	mov	edx, DWORD PTR 40[rbp]
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN3TKO7COLLECT8WALKNODEERNS0_6WALKEREjj
.L4817:
	add	DWORD PTR -4[rbp], 1
.L4815:
	mov	eax, DWORD PTR -4[rbp]
	cmp	eax, DWORD PTR -8[rbp]
	jle	.L4821
.L4818:
	nop
.L4819:
	nop
	add	rsp, 48
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN3TKO7COLLECT21COLLECTANONAGGREGATE_ERNS0_6WALKEREjPNS_7ASTNODEEPNS_11STMTPAYLOADEj;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN3TKO7COLLECT21COLLECTANONAGGREGATE_ERNS0_6WALKEREjPNS_7ASTNODEEPNS_11STMTPAYLOADEj
_ZN3TKO7COLLECT21COLLECTANONAGGREGATE_ERNS0_6WALKEREjPNS_7ASTNODEEPNS_11STMTPAYLOADEj:
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
	mov	QWORD PTR 40[rbp], r9
.L4823:
	mov	rax, QWORD PTR 16[rbp]
	movzx	eax, BYTE PTR 56[rax]
	mov	BYTE PTR -9[rbp], al
	mov	rax, QWORD PTR 16[rbp]
	movzx	eax, BYTE PTR 57[rax]
	mov	BYTE PTR -10[rbp], al
	mov	rax, QWORD PTR 16[rbp]
	mov	eax, DWORD PTR 60[rax]
	mov	DWORD PTR -16[rbp], eax
	mov	rax, QWORD PTR 16[rbp]
	movzx	eax, WORD PTR 68[rax]
	mov	WORD PTR -18[rbp], ax
	mov	rax, QWORD PTR 32[rbp]
	add	rax, 2
	movzx	eax, WORD PTR [rax]
	movzx	eax, ax
	and	eax, 512
	test	rax, rax
	setne	al
	mov	BYTE PTR -19[rbp], al
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 56[rax]
	movzx	eax, BYTE PTR -19[rbp]
	mov	BYTE PTR [rdx], al
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 60
	mov	edx, DWORD PTR -16[rbp]
	add	edx, 1
	mov	DWORD PTR [rax], edx
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 64
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 64
	add	edx, 1
	mov	DWORD PTR [rax], edx
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 60
	mov	eax, DWORD PTR [rax]
	cmp	eax, 16
	jg	.L4836
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 60
	mov	eax, DWORD PTR [rax]
	sub	eax, 1
	and	eax, 63
	mov	edx, 1
	mov	ecx, eax
	sal	rdx, cl
	mov	rax, rdx
	mov	WORD PTR -22[rbp], ax
	cmp	BYTE PTR -19[rbp], 0
	je	.L4837
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 68
	movzx	eax, WORD PTR [rax]
	mov	rdx, QWORD PTR 16[rbp]
	add	rdx, 68
	or	ax, WORD PTR -22[rbp]
	mov	WORD PTR [rdx], ax
	jmp	.L4829
.L4837:
	nop
.L4827:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 68
	movzx	edx, WORD PTR [rax]
	movzx	eax, WORD PTR -22[rbp]
	not	eax
	mov	ecx, eax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 68
	and	edx, ecx
	mov	WORD PTR [rax], dx
	jmp	.L4829
.L4825:
.L4828:
.L4836:
	nop
.L4829:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 57
	mov	BYTE PTR [rax], 1
	mov	rax, QWORD PTR 40[rbp]
	add	rax, 20
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 40[rbp]
	add	rax, 16
	mov	eax, DWORD PTR [rax]
	mov	ecx, DWORD PTR 48[rbp]
	mov	r9d, ecx
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN3TKO7COLLECT12WALKCHILDRENERNS0_6WALKEREiij
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 56[rax]
	movzx	eax, BYTE PTR -9[rbp]
	mov	BYTE PTR [rdx], al
	movsx	eax, BYTE PTR -10[rbp]
	neg	eax
	test	eax, eax
	je	.L4838
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 64
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	setg	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -8[rbp], rax
	jmp	.L4832
.L4838:
	nop
.L4831:
	mov	QWORD PTR -8[rbp], 0
.L4832:
	cmp	QWORD PTR -8[rbp], 0
	setne	dl
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 57
	mov	BYTE PTR [rax], dl
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 60[rax]
	mov	eax, DWORD PTR -16[rbp]
	mov	DWORD PTR [rdx], eax
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 68[rax]
	movzx	eax, WORD PTR -18[rbp]
	mov	WORD PTR [rdx], ax
	nop
	add	rsp, 64
	pop	rbp
	ret
.L4833:
	.seh_endproc
	.def	_ZN3TKO7COLLECT9PROCARITYERNS0_6WALKEREPNS_11STMTPAYLOADE;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN3TKO7COLLECT9PROCARITYERNS0_6WALKEREPNS_11STMTPAYLOADE
_ZN3TKO7COLLECT9PROCARITYERNS0_6WALKEREPNS_11STMTPAYLOADE:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 80
	.seh_stackalloc	80
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
	mov	DWORD PTR -44[rbp], 0
.L4840:
	mov	DWORD PTR -4[rbp], 0
	mov	DWORD PTR -8[rbp], 0
	mov	rax, QWORD PTR 24[rbp]
	add	rax, 20
	mov	eax, DWORD PTR [rax]
	sub	eax, 1
	mov	DWORD PTR -12[rbp], eax
	jmp	.L4841
.L4851:
	nop
.L4842:
	mov	rax, QWORD PTR 24[rbp]
	add	rax, 16
	mov	edx, DWORD PTR [rax]
	mov	eax, DWORD PTR -8[rbp]
	add	edx, eax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	add	rax, 560
	mov	rcx, rax
	call	_ZN5ArrayIjEixEi
	mov	QWORD PTR -24[rbp], rax
	mov	rax, QWORD PTR -24[rbp]
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR -28[rbp], eax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR -28[rbp]
	mov	rcx, rax
	call	_ZN3TKO8ASTARENA4KINDEj
	mov	QWORD PTR -40[rbp], rax
	cmp	QWORD PTR -40[rbp], 66
	jne	.L4850
	add	DWORD PTR -4[rbp], 1
	jmp	.L4845
.L4844:
.L4850:
	nop
.L4845:
	add	DWORD PTR -8[rbp], 1
.L4841:
	mov	eax, DWORD PTR -8[rbp]
	cmp	eax, DWORD PTR -12[rbp]
	jle	.L4851
	nop
.L4846:
	mov	eax, DWORD PTR -4[rbp]
	mov	DWORD PTR -44[rbp], eax
	nop
.L4847:
	mov	eax, DWORD PTR -44[rbp]
	add	rsp, 80
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN3TKO7COLLECT19SPREADOVERLOADFLAG_ERNS0_6WALKEREjjj;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN3TKO7COLLECT19SPREADOVERLOADFLAG_ERNS0_6WALKEREjjj
_ZN3TKO7COLLECT19SPREADOVERLOADFLAG_ERNS0_6WALKEREjjj:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 208
	.seh_stackalloc	208
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
	mov	DWORD PTR 32[rbp], r8d
	mov	DWORD PTR 40[rbp], r9d
.L4853:
	cmp	DWORD PTR 32[rbp], 0
	je	.L4903
	nop
.L4855:
	mov	eax, DWORD PTR 40[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN3TKO7COLLECT6STMTOFERNS0_6WALKEREj
	mov	QWORD PTR -56[rbp], rax
	mov	rax, QWORD PTR -56[rbp]
	add	rax, 28
	mov	eax, DWORD PTR [rax]
	mov	eax, eax
	and	eax, 1
	test	rax, rax
	setne	al
	mov	BYTE PTR -17[rbp], al
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	ecx, DWORD PTR 32[rbp]
	mov	edx, DWORD PTR 24[rbp]
	mov	r8d, ecx
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE11LOOKUPLOCALEjj
	mov	DWORD PTR -60[rbp], eax
	mov	eax, DWORD PTR -60[rbp]
	mov	DWORD PTR -24[rbp], eax
	mov	DWORD PTR -28[rbp], 0
.L4857:
	cmp	DWORD PTR -24[rbp], 0
	je	.L4904
	cmp	DWORD PTR -28[rbp], 99999
	setle	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -8[rbp], rax
	jmp	.L4860
.L4904:
	nop
.L4859:
	mov	QWORD PTR -8[rbp], 0
.L4860:
	cmp	QWORD PTR -8[rbp], 0
	je	.L4905
	add	DWORD PTR -28[rbp], 1
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR -24[rbp]
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE8SYMBOLATEj
	mov	QWORD PTR -72[rbp], rax
	mov	rax, QWORD PTR -72[rbp]
	mov	QWORD PTR -80[rbp], rax
	cmp	QWORD PTR -80[rbp], 0
	je	.L4906
	nop
.L4864:
	mov	rax, QWORD PTR -80[rbp]
	movzx	eax, BYTE PTR [rax]
	cmp	al, 5
	jne	.L4907
	nop
.L4866:
	mov	rax, QWORD PTR -80[rbp]
	add	rax, 40
	mov	rax, QWORD PTR [rax]
	mov	DWORD PTR -84[rbp], eax
	cmp	DWORD PTR -84[rbp], 0
	je	.L4908
	cmp	DWORD PTR -84[rbp], 0
	setne	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -40[rbp], rax
	jmp	.L4869
.L4908:
	nop
.L4868:
	mov	QWORD PTR -40[rbp], 0
.L4869:
	cmp	QWORD PTR -40[rbp], 0
	je	.L4909
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR -84[rbp]
	mov	rcx, rax
	call	_ZN3TKO8ASTARENA4KINDEj
	mov	QWORD PTR -96[rbp], rax
	cmp	QWORD PTR -96[rbp], 65
	jne	.L4910
	mov	eax, DWORD PTR -84[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN3TKO7COLLECT6STMTOFERNS0_6WALKEREj
	mov	QWORD PTR -104[rbp], rax
	mov	rax, QWORD PTR -104[rbp]
	add	rax, 28
	mov	eax, DWORD PTR [rax]
	mov	eax, eax
	and	eax, 1
	test	rax, rax
	je	.L4911
	mov	BYTE PTR -17[rbp], 1
	jmp	.L4877
.L4871:
.L4874:
.L4875:
.L4876:
.L4909:
	nop
	jmp	.L4877
.L4910:
	nop
	jmp	.L4877
.L4911:
	nop
.L4877:
	mov	rax, QWORD PTR -80[rbp]
	mov	eax, DWORD PTR 24[rax]
	mov	DWORD PTR -24[rbp], eax
	jmp	.L4857
.L4905:
	nop
	jmp	.L4862
.L4906:
	nop
	jmp	.L4862
.L4907:
	nop
.L4862:
	cmp	BYTE PTR -17[rbp], 0
	je	.L4912
	nop
.L4879:
	mov	eax, DWORD PTR 40[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN3TKO7COLLECT6STMTOFERNS0_6WALKEREj
	mov	QWORD PTR -112[rbp], rax
	mov	rax, QWORD PTR -112[rbp]
	add	rax, 28
	mov	QWORD PTR -120[rbp], rax
	mov	rax, QWORD PTR -120[rbp]
	mov	eax, DWORD PTR [rax]
	or	eax, 1
	mov	edx, eax
	mov	rax, QWORD PTR -120[rbp]
	mov	DWORD PTR [rax], edx
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	ecx, DWORD PTR 32[rbp]
	mov	edx, DWORD PTR 24[rbp]
	mov	r8d, ecx
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE11LOOKUPLOCALEjj
	mov	DWORD PTR -124[rbp], eax
	mov	eax, DWORD PTR -124[rbp]
	mov	DWORD PTR -24[rbp], eax
	mov	DWORD PTR -28[rbp], 0
.L4880:
	cmp	DWORD PTR -24[rbp], 0
	je	.L4913
	cmp	DWORD PTR -28[rbp], 99999
	setle	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -16[rbp], rax
	jmp	.L4883
.L4913:
	nop
.L4882:
	mov	QWORD PTR -16[rbp], 0
.L4883:
	cmp	QWORD PTR -16[rbp], 0
	je	.L4914
	add	DWORD PTR -28[rbp], 1
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR -24[rbp]
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE8SYMBOLATEj
	mov	QWORD PTR -136[rbp], rax
	mov	rax, QWORD PTR -136[rbp]
	mov	QWORD PTR -144[rbp], rax
	cmp	QWORD PTR -144[rbp], 0
	je	.L4915
	nop
.L4886:
	mov	rax, QWORD PTR -144[rbp]
	movzx	eax, BYTE PTR [rax]
	cmp	al, 5
	jne	.L4916
	nop
.L4888:
	mov	rax, QWORD PTR -144[rbp]
	add	rax, 40
	mov	rax, QWORD PTR [rax]
	mov	DWORD PTR -148[rbp], eax
	cmp	DWORD PTR -148[rbp], 0
	je	.L4917
	cmp	DWORD PTR -148[rbp], 0
	setne	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -48[rbp], rax
	jmp	.L4891
.L4917:
	nop
.L4890:
	mov	QWORD PTR -48[rbp], 0
.L4891:
	cmp	QWORD PTR -48[rbp], 0
	je	.L4918
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR -148[rbp]
	mov	rcx, rax
	call	_ZN3TKO8ASTARENA4KINDEj
	mov	QWORD PTR -160[rbp], rax
	cmp	QWORD PTR -160[rbp], 65
	jne	.L4919
	mov	eax, DWORD PTR -148[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN3TKO7COLLECT6STMTOFERNS0_6WALKEREj
	mov	QWORD PTR -168[rbp], rax
	mov	rax, QWORD PTR -168[rbp]
	add	rax, 28
	mov	QWORD PTR -176[rbp], rax
	mov	rax, QWORD PTR -176[rbp]
	mov	eax, DWORD PTR [rax]
	or	eax, 1
	mov	edx, eax
	mov	rax, QWORD PTR -176[rbp]
	mov	DWORD PTR [rax], edx
	jmp	.L4897
.L4893:
.L4895:
.L4896:
.L4918:
	nop
	jmp	.L4897
.L4919:
	nop
.L4897:
	mov	rax, QWORD PTR -144[rbp]
	mov	eax, DWORD PTR 24[rax]
	mov	DWORD PTR -24[rbp], eax
	jmp	.L4880
.L4856:
.L4903:
	nop
	jmp	.L4920
.L4912:
	nop
	jmp	.L4920
.L4914:
	nop
	jmp	.L4920
.L4915:
	nop
	jmp	.L4920
.L4916:
	nop
.L4898:
.L4920:
	nop
	add	rsp, 208
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN3TKO7COLLECT16SAMEWRITTENTYPE_ERNS0_6WALKEREjj;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN3TKO7COLLECT16SAMEWRITTENTYPE_ERNS0_6WALKEREjj
_ZN3TKO7COLLECT16SAMEWRITTENTYPE_ERNS0_6WALKEREjj:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 144
	.seh_stackalloc	144
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
	mov	DWORD PTR 32[rbp], r8d
	mov	BYTE PTR -98[rbp], 0
.L4922:
	cmp	DWORD PTR 24[rbp], 0
	jne	.L4956
	cmp	DWORD PTR 32[rbp], 0
	sete	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -8[rbp], rax
	jmp	.L4925
.L4956:
	nop
.L4924:
	mov	QWORD PTR -8[rbp], 0
.L4925:
	cmp	QWORD PTR -8[rbp], 0
	je	.L4957
	mov	BYTE PTR -98[rbp], 1
	jmp	.L4928
.L4957:
	nop
.L4927:
	cmp	DWORD PTR 24[rbp], 0
	je	.L4958
	cmp	DWORD PTR 32[rbp], 0
	sete	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -16[rbp], rax
	jmp	.L4931
.L4958:
	nop
.L4930:
	mov	QWORD PTR -16[rbp], -1
.L4931:
	cmp	QWORD PTR -16[rbp], 0
	je	.L4959
	mov	BYTE PTR -98[rbp], 0
	jmp	.L4928
.L4959:
	nop
.L4933:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 24[rbp]
	mov	rcx, rax
	call	_ZN3TKO8ASTARENA4KINDEj
	mov	QWORD PTR -24[rbp], rax
	cmp	QWORD PTR -24[rbp], 28
	je	.L4960
	mov	BYTE PTR -98[rbp], 0
	jmp	.L4928
.L4960:
	nop
.L4935:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 32[rbp]
	mov	rcx, rax
	call	_ZN3TKO8ASTARENA4KINDEj
	mov	QWORD PTR -32[rbp], rax
	cmp	QWORD PTR -32[rbp], 28
	je	.L4961
	mov	BYTE PTR -98[rbp], 0
	jmp	.L4928
.L4961:
	nop
.L4937:
	mov	edx, DWORD PTR 24[rbp]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN5ArrayIN3TKO7ASTNODEEEixEi
	mov	QWORD PTR -40[rbp], rax
	mov	rax, QWORD PTR -40[rbp]
	movzx	eax, WORD PTR 2[rax]
	mov	WORD PTR -42[rbp], ax
	mov	edx, DWORD PTR 32[rbp]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN5ArrayIN3TKO7ASTNODEEEixEi
	mov	QWORD PTR -56[rbp], rax
	mov	rax, QWORD PTR -56[rbp]
	movzx	eax, WORD PTR 2[rax]
	mov	WORD PTR -58[rbp], ax
	mov	WORD PTR -60[rbp], 24608
	movzx	eax, WORD PTR -42[rbp]
	xor	ax, WORD PTR -58[rbp]
	and	ax, WORD PTR -60[rbp]
	test	ax, ax
	je	.L4962
	mov	BYTE PTR -98[rbp], 0
	jmp	.L4928
.L4962:
	nop
.L4939:
	mov	eax, DWORD PTR 24[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN3TKO7COLLECT6STMTOFERNS0_6WALKEREj
	mov	QWORD PTR -72[rbp], rax
	mov	rax, QWORD PTR -72[rbp]
	mov	QWORD PTR -80[rbp], rax
	mov	eax, DWORD PTR 32[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN3TKO7COLLECT6STMTOFERNS0_6WALKEREj
	mov	QWORD PTR -88[rbp], rax
	mov	rax, QWORD PTR -88[rbp]
	mov	QWORD PTR -96[rbp], rax
	mov	rax, QWORD PTR -80[rbp]
	add	rax, 24
	movzx	edx, WORD PTR [rax]
	mov	rax, QWORD PTR -96[rbp]
	add	rax, 24
	movzx	eax, WORD PTR [rax]
	cmp	dx, ax
	je	.L4963
	mov	BYTE PTR -98[rbp], 0
	jmp	.L4928
.L4963:
	nop
.L4941:
	mov	rax, QWORD PTR -80[rbp]
	add	rax, 24
	movzx	eax, WORD PTR [rax]
	cmp	ax, 3
	jne	.L4964
	mov	rax, QWORD PTR -80[rbp]
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR -96[rbp]
	mov	eax, DWORD PTR [rax]
	cmp	edx, eax
	je	.L4965
	mov	BYTE PTR -98[rbp], 0
	jmp	.L4928
.L4943:
.L4945:
.L4964:
	nop
	jmp	.L4946
.L4965:
	nop
.L4946:
	mov	rax, QWORD PTR -96[rbp]
	add	rax, 4
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR -80[rbp]
	add	rax, 4
	mov	eax, DWORD PTR [rax]
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN3TKO7COLLECT16SAMEWRITTENTYPE_ERNS0_6WALKEREjj
	mov	BYTE PTR -97[rbp], al
	movzx	eax, BYTE PTR -97[rbp]
	mov	BYTE PTR -98[rbp], al
	nop
.L4928:
	movzx	eax, BYTE PTR -98[rbp]
	add	rsp, 144
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN3TKO7COLLECT14SAMESIGNATURE_ERNS0_6WALKEREPNS_11STMTPAYLOADES4_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN3TKO7COLLECT14SAMESIGNATURE_ERNS0_6WALKEREPNS_11STMTPAYLOADES4_
_ZN3TKO7COLLECT14SAMESIGNATURE_ERNS0_6WALKEREPNS_11STMTPAYLOADES4_:
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
	mov	BYTE PTR -90[rbp], 0
.L4967:
	mov	rax, QWORD PTR 32[rbp]
	add	rax, 4
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 24[rbp]
	add	rax, 4
	mov	eax, DWORD PTR [rax]
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN3TKO7COLLECT16SAMEWRITTENTYPE_ERNS0_6WALKEREjj
	mov	BYTE PTR -17[rbp], al
	cmp	BYTE PTR -17[rbp], 0
	jne	.L4992
	mov	BYTE PTR -90[rbp], 0
	jmp	.L4970
.L4992:
	nop
.L4969:
	mov	rax, QWORD PTR 24[rbp]
	add	rax, 20
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 32[rbp]
	add	rax, 20
	mov	eax, DWORD PTR [rax]
	cmp	edx, eax
	je	.L4993
	mov	BYTE PTR -90[rbp], 0
	jmp	.L4970
.L4993:
	nop
.L4972:
	mov	DWORD PTR -4[rbp], 0
	mov	rax, QWORD PTR 24[rbp]
	add	rax, 20
	mov	eax, DWORD PTR [rax]
	sub	eax, 1
	mov	DWORD PTR -24[rbp], eax
	jmp	.L4973
.L4997:
	nop
.L4974:
	mov	rax, QWORD PTR 24[rbp]
	add	rax, 16
	mov	edx, DWORD PTR [rax]
	mov	eax, DWORD PTR -4[rbp]
	add	edx, eax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	add	rax, 560
	mov	rcx, rax
	call	_ZN5ArrayIjEixEi
	mov	QWORD PTR -32[rbp], rax
	mov	rax, QWORD PTR -32[rbp]
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR -36[rbp], eax
	mov	rax, QWORD PTR 32[rbp]
	add	rax, 16
	mov	edx, DWORD PTR [rax]
	mov	eax, DWORD PTR -4[rbp]
	add	edx, eax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	add	rax, 560
	mov	rcx, rax
	call	_ZN5ArrayIjEixEi
	mov	QWORD PTR -48[rbp], rax
	mov	rax, QWORD PTR -48[rbp]
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR -52[rbp], eax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR -36[rbp]
	mov	rcx, rax
	call	_ZN3TKO8ASTARENA4KINDEj
	mov	QWORD PTR -64[rbp], rax
	cmp	QWORD PTR -64[rbp], 66
	jne	.L4994
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR -52[rbp]
	mov	rcx, rax
	call	_ZN3TKO8ASTARENA4KINDEj
	mov	QWORD PTR -72[rbp], rax
	cmp	QWORD PTR -72[rbp], 66
	setne	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -16[rbp], rax
	jmp	.L4977
.L4994:
	nop
.L4976:
	mov	QWORD PTR -16[rbp], -1
.L4977:
	cmp	QWORD PTR -16[rbp], 0
	je	.L4995
	mov	BYTE PTR -90[rbp], 0
	jmp	.L4970
.L4995:
	nop
.L4979:
	mov	eax, DWORD PTR -52[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN3TKO7COLLECT6STMTOFERNS0_6WALKEREj
	mov	QWORD PTR -80[rbp], rax
	mov	eax, DWORD PTR -36[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN3TKO7COLLECT6STMTOFERNS0_6WALKEREj
	mov	QWORD PTR -88[rbp], rax
	mov	rax, QWORD PTR -80[rbp]
	add	rax, 4
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR -88[rbp]
	add	rax, 4
	mov	eax, DWORD PTR [rax]
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN3TKO7COLLECT16SAMEWRITTENTYPE_ERNS0_6WALKEREjj
	mov	BYTE PTR -89[rbp], al
	cmp	BYTE PTR -89[rbp], 0
	jne	.L4996
	mov	BYTE PTR -90[rbp], 0
	jmp	.L4970
.L4981:
.L4982:
.L4996:
	nop
.L4983:
	add	DWORD PTR -4[rbp], 1
.L4973:
	mov	eax, DWORD PTR -4[rbp]
	cmp	eax, DWORD PTR -24[rbp]
	jle	.L4997
	nop
.L4984:
	mov	BYTE PTR -90[rbp], 1
	nop
.L4970:
	movzx	eax, BYTE PTR -90[rbp]
	sub	rsp, -128
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN3TKO7COLLECT17MEMBERDECLFORDEF_ERNS0_6WALKEREjjPNS_11STMTPAYLOADE;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN3TKO7COLLECT17MEMBERDECLFORDEF_ERNS0_6WALKEREjjPNS_11STMTPAYLOADE
_ZN3TKO7COLLECT17MEMBERDECLFORDEF_ERNS0_6WALKEREjjPNS_11STMTPAYLOADE:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 144
	.seh_stackalloc	144
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
	mov	DWORD PTR 32[rbp], r8d
	mov	QWORD PTR 40[rbp], r9
	mov	DWORD PTR -108[rbp], 0
.L4999:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	ecx, DWORD PTR 32[rbp]
	mov	edx, DWORD PTR 24[rbp]
	mov	r8d, ecx
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE11LOOKUPLOCALEjj
	mov	DWORD PTR -36[rbp], eax
	mov	eax, DWORD PTR -36[rbp]
	mov	DWORD PTR -40[rbp], eax
	cmp	DWORD PTR -40[rbp], 0
	jne	.L5032
	mov	eax, DWORD PTR -40[rbp]
	mov	DWORD PTR -108[rbp], eax
	jmp	.L5002
.L5032:
	nop
.L5001:
	mov	rax, QWORD PTR 40[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN3TKO7COLLECT9PROCARITYERNS0_6WALKEREPNS_11STMTPAYLOADE
	mov	DWORD PTR -44[rbp], eax
	mov	eax, DWORD PTR -44[rbp]
	mov	DWORD PTR -48[rbp], eax
	mov	DWORD PTR -12[rbp], 0
	mov	DWORD PTR -16[rbp], 0
	mov	eax, DWORD PTR -40[rbp]
	mov	DWORD PTR -20[rbp], eax
	mov	DWORD PTR -24[rbp], 0
.L5003:
	cmp	DWORD PTR -20[rbp], 0
	je	.L5033
	cmp	DWORD PTR -24[rbp], 99999
	setle	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -8[rbp], rax
	jmp	.L5006
.L5033:
	nop
.L5005:
	mov	QWORD PTR -8[rbp], 0
.L5006:
	cmp	QWORD PTR -8[rbp], 0
	je	.L5034
	add	DWORD PTR -24[rbp], 1
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR -20[rbp]
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE8SYMBOLATEj
	mov	QWORD PTR -56[rbp], rax
	mov	rax, QWORD PTR -56[rbp]
	mov	QWORD PTR -64[rbp], rax
	cmp	QWORD PTR -64[rbp], 0
	je	.L5035
	nop
.L5010:
	mov	rax, QWORD PTR -64[rbp]
	movzx	eax, BYTE PTR [rax]
	cmp	al, 5
	jne	.L5036
	nop
.L5012:
	mov	rax, QWORD PTR -64[rbp]
	add	rax, 40
	mov	rax, QWORD PTR [rax]
	mov	DWORD PTR -68[rbp], eax
	cmp	DWORD PTR -68[rbp], 0
	je	.L5037
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR -68[rbp]
	mov	rcx, rax
	call	_ZN3TKO8ASTARENA4KINDEj
	mov	QWORD PTR -80[rbp], rax
	cmp	QWORD PTR -80[rbp], 65
	sete	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -32[rbp], rax
	jmp	.L5015
.L5037:
	nop
.L5014:
	mov	QWORD PTR -32[rbp], 0
.L5015:
	cmp	QWORD PTR -32[rbp], 0
	je	.L5038
	mov	eax, DWORD PTR -68[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN3TKO7COLLECT6STMTOFERNS0_6WALKEREj
	mov	QWORD PTR -88[rbp], rax
	mov	rax, QWORD PTR -88[rbp]
	mov	QWORD PTR -96[rbp], rax
	mov	rax, QWORD PTR -96[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN3TKO7COLLECT9PROCARITYERNS0_6WALKEREPNS_11STMTPAYLOADE
	mov	DWORD PTR -100[rbp], eax
	mov	eax, DWORD PTR -100[rbp]
	cmp	eax, DWORD PTR -48[rbp]
	jne	.L5039
	mov	rdx, QWORD PTR 40[rbp]
	mov	rax, QWORD PTR -96[rbp]
	mov	r8, rdx
	mov	rdx, rax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN3TKO7COLLECT14SAMESIGNATURE_ERNS0_6WALKEREPNS_11STMTPAYLOADES4_
	mov	BYTE PTR -101[rbp], al
	cmp	BYTE PTR -101[rbp], 0
	je	.L5040
	mov	eax, DWORD PTR -20[rbp]
	mov	DWORD PTR -12[rbp], eax
	add	DWORD PTR -16[rbp], 1
	jmp	.L5024
.L5017:
.L5020:
.L5021:
.L5022:
.L5023:
.L5038:
	nop
	jmp	.L5024
.L5039:
	nop
	jmp	.L5024
.L5040:
	nop
.L5024:
	mov	rax, QWORD PTR -64[rbp]
	mov	eax, DWORD PTR 24[rax]
	mov	DWORD PTR -20[rbp], eax
	jmp	.L5003
.L5034:
	nop
	jmp	.L5008
.L5035:
	nop
	jmp	.L5008
.L5036:
	nop
.L5008:
	cmp	DWORD PTR -16[rbp], 1
	jne	.L5041
	mov	eax, DWORD PTR -12[rbp]
	mov	DWORD PTR -108[rbp], eax
	jmp	.L5002
.L5041:
	nop
.L5026:
	mov	eax, DWORD PTR -40[rbp]
	mov	DWORD PTR -108[rbp], eax
	nop
.L5002:
	mov	eax, DWORD PTR -108[rbp]
	add	rsp, 144
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN3TKO7COLLECT22UNDEFINEDPROCWITHARITYERNS0_6WALKEREjji;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN3TKO7COLLECT22UNDEFINEDPROCWITHARITYERNS0_6WALKEREjji
_ZN3TKO7COLLECT22UNDEFINEDPROCWITHARITYERNS0_6WALKEREjji:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 112
	.seh_stackalloc	112
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
	mov	DWORD PTR 32[rbp], r8d
	mov	DWORD PTR 40[rbp], r9d
	mov	DWORD PTR -80[rbp], 0
.L5043:
	mov	DWORD PTR -4[rbp], 0
	mov	DWORD PTR -8[rbp], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	ecx, DWORD PTR 32[rbp]
	mov	edx, DWORD PTR 24[rbp]
	mov	r8d, ecx
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE11LOOKUPLOCALEjj
	mov	DWORD PTR -28[rbp], eax
	mov	eax, DWORD PTR -28[rbp]
	mov	DWORD PTR -12[rbp], eax
.L5044:
	cmp	DWORD PTR -12[rbp], 0
	je	.L5069
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR -12[rbp]
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE8SYMBOLATEj
	mov	QWORD PTR -40[rbp], rax
	mov	rax, QWORD PTR -40[rbp]
	mov	QWORD PTR -48[rbp], rax
	cmp	QWORD PTR -48[rbp], 0
	je	.L5070
	nop
.L5048:
	mov	rax, QWORD PTR -48[rbp]
	movzx	eax, BYTE PTR [rax]
	cmp	al, 5
	jne	.L5071
	nop
.L5050:
	mov	rax, QWORD PTR -48[rbp]
	add	rax, 4
	mov	eax, DWORD PTR [rax]
	mov	eax, eax
	and	eax, 32
	test	rax, rax
	jne	.L5072
	mov	rax, QWORD PTR -48[rbp]
	add	rax, 40
	mov	rax, QWORD PTR [rax]
	mov	DWORD PTR -52[rbp], eax
	cmp	DWORD PTR -52[rbp], 0
	je	.L5073
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR -52[rbp]
	mov	rcx, rax
	call	_ZN3TKO8ASTARENA4KINDEj
	mov	QWORD PTR -64[rbp], rax
	cmp	QWORD PTR -64[rbp], 65
	sete	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -24[rbp], rax
	jmp	.L5055
.L5073:
	nop
.L5054:
	mov	QWORD PTR -24[rbp], 0
.L5055:
	cmp	QWORD PTR -24[rbp], 0
	je	.L5074
	mov	eax, DWORD PTR -52[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN3TKO7COLLECT6STMTOFERNS0_6WALKEREj
	mov	QWORD PTR -72[rbp], rax
	mov	rax, QWORD PTR -72[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN3TKO7COLLECT9PROCARITYERNS0_6WALKEREPNS_11STMTPAYLOADE
	mov	DWORD PTR -76[rbp], eax
	mov	eax, DWORD PTR -76[rbp]
	cmp	eax, DWORD PTR 40[rbp]
	jne	.L5075
	mov	eax, DWORD PTR -12[rbp]
	mov	DWORD PTR -4[rbp], eax
	add	DWORD PTR -8[rbp], 1
	jmp	.L5062
.L5052:
.L5058:
.L5059:
.L5060:
.L5061:
.L5072:
	nop
	jmp	.L5062
.L5074:
	nop
	jmp	.L5062
.L5075:
	nop
.L5062:
	mov	rax, QWORD PTR -48[rbp]
	mov	eax, DWORD PTR 24[rax]
	mov	DWORD PTR -12[rbp], eax
	jmp	.L5044
.L5069:
	nop
	jmp	.L5046
.L5070:
	nop
	jmp	.L5046
.L5071:
	nop
.L5046:
	cmp	DWORD PTR -8[rbp], 1
	jne	.L5076
	mov	eax, DWORD PTR -4[rbp]
	mov	DWORD PTR -80[rbp], eax
	jmp	.L5065
.L5076:
	nop
.L5064:
	mov	DWORD PTR -80[rbp], 0
	nop
.L5065:
	mov	eax, DWORD PTR -80[rbp]
	add	rsp, 112
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN3TKO7COLLECT10EFFECTIVE_ENS_8CALLCONVE;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN3TKO7COLLECT10EFFECTIVE_ENS_8CALLCONVE
_ZN3TKO7COLLECT10EFFECTIVE_ENS_8CALLCONVE:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR -8[rbp], 0
.L5078:
	cmp	QWORD PTR 16[rbp], 0
	jne	.L5084
	mov	QWORD PTR -8[rbp], 2
	jmp	.L5081
.L5084:
	nop
.L5080:
	mov	rax, QWORD PTR 16[rbp]
	mov	QWORD PTR -8[rbp], rax
	nop
.L5081:
	mov	rax, QWORD PTR -8[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN3TKO7COLLECT12BINDCALLCONVERNS0_6WALKEREPNS_6SYMBOLEPNS_11STMTPAYLOADEjb;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN3TKO7COLLECT12BINDCALLCONVERNS0_6WALKEREPNS_6SYMBOLEPNS_11STMTPAYLOADEjb
_ZN3TKO7COLLECT12BINDCALLCONVERNS0_6WALKEREPNS_6SYMBOLEPNS_11STMTPAYLOADEjb:
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
	mov	DWORD PTR 248[rbp], r9d
	mov	eax, DWORD PTR 256[rbp]
	mov	BYTE PTR -68[rbp], al
.L5086:
	mov	rax, QWORD PTR 240[rbp]
	add	rax, 28
	mov	eax, DWORD PTR [rax]
	movzx	eax, ax
	mov	ecx, eax
	call	_ZN3TKO10CALLCONVOFEt
	mov	QWORD PTR 200[rbp], rax
	mov	rax, QWORD PTR 200[rbp]
	mov	QWORD PTR 192[rbp], rax
	cmp	QWORD PTR 192[rbp], 0
	je	.L5098
	nop
.L5088:
	cmp	BYTE PTR -68[rbp], 0
	je	.L5099
	mov	rax, QWORD PTR 232[rbp]
	add	rax, 56
	mov	rdx, QWORD PTR 192[rbp]
	mov	BYTE PTR [rax], dl
	jmp	.L5089
.L5091:
.L5099:
	nop
.L5092:
	mov	rax, QWORD PTR 232[rbp]
	add	rax, 56
	movzx	eax, BYTE PTR [rax]
	movzx	eax, al
	mov	QWORD PTR 184[rbp], rax
	mov	rax, QWORD PTR 184[rbp]
	mov	rcx, rax
	call	_ZN3TKO7COLLECT10EFFECTIVE_ENS_8CALLCONVE
	mov	QWORD PTR 176[rbp], rax
	mov	rax, QWORD PTR 176[rbp]
	cmp	rax, QWORD PTR 192[rbp]
	jne	.L5100
	mov	rax, QWORD PTR 232[rbp]
	add	rax, 56
	mov	rdx, QWORD PTR 192[rbp]
	mov	BYTE PTR [rax], dl
	jmp	.L5089
.L5094:
.L5100:
	nop
.L5095:
	mov	rax, QWORD PTR 224[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 248[rbp]
	mov	rcx, rax
	call	_ZN3TKO8ASTARENA3LOCEj
	mov	DWORD PTR 172[rbp], eax
	mov	eax, DWORD PTR 172[rbp]
	mov	ecx, eax
	call	_ZN3TKO10POINTRANGEEj
	mov	QWORD PTR -48[rbp], rax
	mov	rax, QWORD PTR -48[rbp]
	mov	QWORD PTR -40[rbp], rax
	lea	rax, 64[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	lea	rax, 64[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9d, 1
	lea	r8, .LC0[rip]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrAssign
	lea	rax, 96[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	lea	rax, 96[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9d, 1
	lea	r8, .LC0[rip]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrAssign
	lea	rax, 128[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	rax, QWORD PTR 232[rbp]
	add	rax, 8
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 224[rbp]
	add	rax, 32
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN3TKO8INTERNER8SPELLINGEj
	mov	QWORD PTR 160[rbp], rax
	mov	rdx, QWORD PTR 160[rbp]
	lea	rax, 128[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrAssign
	mov	rax, QWORD PTR 224[rbp]
	add	rax, 24
	mov	rax, QWORD PTR [rax]
	lea	r8, 128[rbp]
	mov	rcx, QWORD PTR -40[rbp]
	lea	rdx, 64[rbp]
	mov	QWORD PTR 40[rsp], rdx
	lea	rdx, 96[rbp]
	mov	QWORD PTR 32[rsp], rdx
	mov	r9, r8
	mov	r8, rcx
	mov	edx, 77
	mov	rcx, rax
	call	_ZN3TKO16DIAGNOSTICENGINE6REPORTENS_6DIAGIDENS_11SOURCERANGEE8FBSTRINGS3_S3_
	lea	rax, 64[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	lea	rax, 96[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	lea	rax, 128[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	lea	rax, -32[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	lea	rax, -32[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9d, 1
	lea	r8, .LC0[rip]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrAssign
	mov	rax, rbp
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	rax, rbp
	mov	DWORD PTR 32[rsp], 0
	mov	r9d, 1
	lea	r8, .LC0[rip]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrAssign
	lea	rax, 32[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	lea	rax, 32[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9d, 1
	lea	r8, .LC0[rip]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrAssign
	mov	rax, QWORD PTR 232[rbp]
	add	rax, 20
	mov	eax, DWORD PTR [rax]
	mov	ecx, eax
	call	_ZN3TKO10POINTRANGEEj
	mov	QWORD PTR -56[rbp], rax
	mov	rax, QWORD PTR 224[rbp]
	add	rax, 24
	mov	rax, QWORD PTR [rax]
	lea	r8, 32[rbp]
	mov	rcx, QWORD PTR -56[rbp]
	lea	rdx, -32[rbp]
	mov	QWORD PTR 40[rsp], rdx
	mov	rdx, rbp
	mov	QWORD PTR 32[rsp], rdx
	mov	r9, r8
	mov	r8, rcx
	mov	edx, 245
	mov	rcx, rax
	call	_ZN3TKO16DIAGNOSTICENGINE7ADDNOTEENS_6DIAGIDENS_11SOURCERANGEE8FBSTRINGS3_S3_
	lea	rax, -32[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	mov	rax, rbp
	mov	rcx, rax
	call	fb_StrDelete
	lea	rax, 32[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	jmp	.L5101
.L5098:
	nop
.L5089:
.L5101:
	nop
	add	rsp, 336
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN3TKO7COLLECT13DECLAREGLOBALERNS_11SYMBOLTABLEERNS_8INTERNERERNS_16DIAGNOSTICENGINEE8FBSTRING;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN3TKO7COLLECT13DECLAREGLOBALERNS_11SYMBOLTABLEERNS_8INTERNERERNS_16DIAGNOSTICENGINEE8FBSTRING
_ZN3TKO7COLLECT13DECLAREGLOBALERNS_11SYMBOLTABLEERNS_8INTERNERERNS_16DIAGNOSTICENGINEE8FBSTRING:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 112
	.seh_stackalloc	112
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
	mov	QWORD PTR 32[rbp], r8
	mov	QWORD PTR 40[rbp], r9
	mov	DWORD PTR -52[rbp], 0
.L5103:
	mov	BYTE PTR -53[rbp], 0
	lea	rax, -48[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	rdx, QWORD PTR 40[rbp]
	lea	rax, -48[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrAssign
	lea	rdx, -48[rbp]
	mov	rax, QWORD PTR 24[rbp]
	mov	rcx, rax
	call	_ZN3TKO8INTERNER9GETSTRINGE8FBSTRING
	mov	DWORD PTR -4[rbp], eax
	mov	edx, DWORD PTR -4[rbp]
	mov	rax, QWORD PTR 24[rbp]
	mov	rcx, rax
	call	_ZN3TKO8INTERNER4FOLDEj
	mov	DWORD PTR -8[rbp], eax
	mov	edx, DWORD PTR -8[rbp]
	lea	rax, -53[rbp]
	mov	QWORD PTR 40[rsp], rax
	mov	DWORD PTR 32[rsp], 0
	mov	r9d, 3
	mov	r8d, edx
	mov	edx, 1
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN3TKO11SYMBOLTABLE10DECLARESYMEjjNS_10SYMBOLKINDEjRb
	mov	DWORD PTR -12[rbp], eax
	mov	eax, DWORD PTR -12[rbp]
	mov	DWORD PTR -52[rbp], eax
	lea	rax, -48[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	nop
.L5104:
	mov	eax, DWORD PTR -52[rbp]
	add	rsp, 112
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN3TKO7COLLECT15DECLAREFUNCNAMEERNS_11SYMBOLTABLEERNS_8INTERNERERNS_16DIAGNOSTICENGINEE8FBSTRING;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN3TKO7COLLECT15DECLAREFUNCNAMEERNS_11SYMBOLTABLEERNS_8INTERNERERNS_16DIAGNOSTICENGINEE8FBSTRING
_ZN3TKO7COLLECT15DECLAREFUNCNAMEERNS_11SYMBOLTABLEERNS_8INTERNERERNS_16DIAGNOSTICENGINEE8FBSTRING:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 96
	.seh_stackalloc	96
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
	mov	QWORD PTR 32[rbp], r8
	mov	QWORD PTR 40[rbp], r9
.L5107:
	lea	rax, -48[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	rdx, QWORD PTR 40[rbp]
	lea	rax, -48[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrAssign
	lea	rcx, -48[rbp]
	mov	rdx, QWORD PTR 32[rbp]
	mov	rax, QWORD PTR 24[rbp]
	mov	r9, rcx
	mov	r8, rdx
	mov	rdx, rax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN3TKO7COLLECT13DECLAREGLOBALERNS_11SYMBOLTABLEERNS_8INTERNERERNS_16DIAGNOSTICENGINEE8FBSTRING
	mov	DWORD PTR -4[rbp], eax
	mov	eax, DWORD PTR -4[rbp]
	mov	DWORD PTR -8[rbp], eax
	lea	rax, -48[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	mov	eax, DWORD PTR -8[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN3TKO11SYMBOLTABLE8SYMBOLATEj
	mov	QWORD PTR -16[rbp], rax
	mov	rax, QWORD PTR -16[rbp]
	mov	QWORD PTR -24[rbp], rax
	cmp	QWORD PTR -24[rbp], 0
	je	.L5111
	mov	rax, QWORD PTR -24[rbp]
	add	rax, 4
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR -24[rbp]
	add	rax, 4
	or	dh, 4
	mov	DWORD PTR [rax], edx
	jmp	.L5112
.L5109:
.L5111:
	nop
.L5110:
.L5112:
	nop
	add	rsp, 96
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN3TKO7COLLECT19DECLAREBUILTINCONSTERNS_11SYMBOLTABLEERNS_8INTERNERERNS_11TYPECONTEXTERNS_16DIAGNOSTICENGINEE8FBSTRINGi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN3TKO7COLLECT19DECLAREBUILTINCONSTERNS_11SYMBOLTABLEERNS_8INTERNERERNS_11TYPECONTEXTERNS_16DIAGNOSTICENGINEE8FBSTRINGi
_ZN3TKO7COLLECT19DECLAREBUILTINCONSTERNS_11SYMBOLTABLEERNS_8INTERNERERNS_11TYPECONTEXTERNS_16DIAGNOSTICENGINEE8FBSTRINGi:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 112
	.seh_stackalloc	112
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
	mov	QWORD PTR 32[rbp], r8
	mov	QWORD PTR 40[rbp], r9
.L5114:
	lea	rax, -64[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	rdx, QWORD PTR 48[rbp]
	lea	rax, -64[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrAssign
	lea	rcx, -64[rbp]
	mov	rdx, QWORD PTR 40[rbp]
	mov	rax, QWORD PTR 24[rbp]
	mov	r9, rcx
	mov	r8, rdx
	mov	rdx, rax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN3TKO7COLLECT13DECLAREGLOBALERNS_11SYMBOLTABLEERNS_8INTERNERERNS_16DIAGNOSTICENGINEE8FBSTRING
	mov	DWORD PTR -4[rbp], eax
	mov	eax, DWORD PTR -4[rbp]
	mov	DWORD PTR -8[rbp], eax
	lea	rax, -64[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	mov	eax, DWORD PTR -8[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN3TKO11SYMBOLTABLE8SYMBOLATEj
	mov	QWORD PTR -16[rbp], rax
	mov	rax, QWORD PTR -16[rbp]
	mov	QWORD PTR -24[rbp], rax
	cmp	QWORD PTR -24[rbp], 0
	je	.L5118
	nop
.L5116:
	mov	rax, QWORD PTR -24[rbp]
	add	rax, 4
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR -24[rbp]
	add	rax, 4
	or	dh, 2
	mov	DWORD PTR [rax], edx
	mov	rax, QWORD PTR 32[rbp]
	mov	edx, 14
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT7BUILTINENS_11BUILTINTYPEE
	mov	DWORD PTR -28[rbp], eax
	mov	rax, QWORD PTR -24[rbp]
	lea	rdx, 16[rax]
	mov	eax, DWORD PTR -28[rbp]
	mov	DWORD PTR [rdx], eax
	mov	rax, QWORD PTR -24[rbp]
	lea	rdx, 40[rax]
	mov	eax, DWORD PTR 56[rbp]
	cdqe
	mov	QWORD PTR [rdx], rax
	jmp	.L5119
.L5118:
	nop
.L5117:
.L5119:
	nop
	add	rsp, 112
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
	.def	fb_ArrayRedimPresvObj;	.scl	2;	.type	32;	.endef
	.def	fb_ArrayEraseObj;	.scl	2;	.type	32;	.endef
	.def	_ZN3TKO8ASTARENA4KINDEj;	.scl	2;	.type	32;	.endef
	.def	_ZN3TKO12SEMANTICINFO8SETSCOPEEjj;	.scl	2;	.type	32;	.endef
	.def	_ZN3TKO11SYMBOLTABLE16LOOKUPLOCALTYPEDEjjb;	.scl	2;	.type	32;	.endef
	.def	_ZN3TKO11SYMBOLTABLE8SYMBOLATEj;	.scl	2;	.type	32;	.endef
	.def	_ZN3TKO8INTERNER8SPELLINGEj;	.scl	2;	.type	32;	.endef
	.def	_ZN3TKO8ASTARENA3LOCEj;	.scl	2;	.type	32;	.endef
	.def	_ZN3TKO10POINTRANGEEj;	.scl	2;	.type	32;	.endef
	.def	_ZN3TKO16DIAGNOSTICENGINE6REPORTENS_6DIAGIDENS_11SOURCERANGEE8FBSTRINGS3_S3_;	.scl	2;	.type	32;	.endef
	.def	_ZN3TKO11SYMBOLTABLE11LOOKUPTYPEDEjjb;	.scl	2;	.type	32;	.endef
	.def	_ZN3TKO4TEXT10UPPERASCIIE8FBSTRING;	.scl	2;	.type	32;	.endef
	.def	fb_StrConcat;	.scl	2;	.type	32;	.endef
	.def	_ZN3TKO8INTERNER9GETSTRINGE8FBSTRING;	.scl	2;	.type	32;	.endef
	.def	_ZN3TKO11SYMBOLTABLE9OPENSCOPEENS_9SCOPEKINDEjj;	.scl	2;	.type	32;	.endef
	.def	_ZN3TKO11TYPECONTEXT9NAMEDTYPEENS_8TYPEKINDEjjj;	.scl	2;	.type	32;	.endef
	.def	_ZN3TKO12SEMANTICINFO6SETREFEjj;	.scl	2;	.type	32;	.endef
	.def	_ZN3TKO11TYPECONTEXT10SETPACKINGEji;	.scl	2;	.type	32;	.endef
	.def	_ZN3TKO11SYMBOLTABLE11LOOKUPLOCALEjj;	.scl	2;	.type	32;	.endef
	.def	_ZN3TKO8INTERNER4FOLDEj;	.scl	2;	.type	32;	.endef
	.def	_ZN3TKO8ASTARENA5COUNTEv;	.scl	2;	.type	32;	.endef
	.def	_ZN3TKO12SEMANTICINFO6RESIZEEi;	.scl	2;	.type	32;	.endef
	.def	fb_ArrayRedimTo;	.scl	2;	.type	32;	.endef
	.def	_ZN3TKO11SYMBOLTABLE10DECLARESYMEjjNS_10SYMBOLKINDEjRb;	.scl	2;	.type	32;	.endef
	.def	_ZN3TKO13SOURCEMANAGER9ISBUILTINEj;	.scl	2;	.type	32;	.endef
	.def	_ZN3TKO16DIAGNOSTICENGINE7ADDNOTEENS_6DIAGIDENS_11SOURCERANGEE8FBSTRINGS3_S3_;	.scl	2;	.type	32;	.endef
	.def	fb_StrCompare;	.scl	2;	.type	32;	.endef
	.def	fb_StrAllocTempDescZEx;	.scl	2;	.type	32;	.endef
	.def	fb_StrInstr;	.scl	2;	.type	32;	.endef
	.def	fb_StrLen;	.scl	2;	.type	32;	.endef
	.def	fb_StrMid;	.scl	2;	.type	32;	.endef
	.def	_ZN3TKO10CALLCONVOFEt;	.scl	2;	.type	32;	.endef
	.def	_ZN3TKO11TYPECONTEXT7BUILTINENS_11BUILTINTYPEE;	.scl	2;	.type	32;	.endef
