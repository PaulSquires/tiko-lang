	.file	"fbstr.c"
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
	.globl	_ZN3TKO4TEXT11STROFDOUBLEEd
	.def	_ZN3TKO4TEXT11STROFDOUBLEEd;	.scl	2;	.type	32;	.endef
	.seh_proc	_ZN3TKO4TEXT11STROFDOUBLEEd
_ZN3TKO4TEXT11STROFDOUBLEEd:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 96
	.seh_stackalloc	96
	.seh_endprologue
	movsd	QWORD PTR 16[rbp], xmm0
	lea	rax, -48[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
.L286:
	lea	rax, 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	r9d, 16
	mov	r8d, 11
	mov	edx, 52
	mov	rcx, rax
	call	_ZN3TKO4TEXT11FORMATFLOATEyiii
	mov	QWORD PTR -8[rbp], rax
	mov	rdx, QWORD PTR -8[rbp]
	lea	rax, -48[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrInit
	nop
.L287:
	lea	rax, -48[rbp]
	mov	rcx, rax
	call	fb_StrAllocTempResult
	mov	QWORD PTR -16[rbp], rax
	mov	rax, QWORD PTR -16[rbp]
	add	rsp, 96
	pop	rbp
	ret
	.seh_endproc
	.globl	_ZN3TKO4TEXT11STROFSINGLEEf
	.def	_ZN3TKO4TEXT11STROFSINGLEEf;	.scl	2;	.type	32;	.endef
	.seh_proc	_ZN3TKO4TEXT11STROFSINGLEEf
_ZN3TKO4TEXT11STROFSINGLEEf:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 96
	.seh_stackalloc	96
	.seh_endprologue
	movss	DWORD PTR 16[rbp], xmm0
	lea	rax, -48[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
.L290:
	lea	rax, 16[rbp]
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR -4[rbp], eax
	mov	eax, DWORD PTR -4[rbp]
	mov	r9d, 7
	mov	r8d, 8
	mov	edx, 23
	mov	rcx, rax
	call	_ZN3TKO4TEXT11FORMATFLOATEyiii
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
.L291:
	lea	rax, -48[rbp]
	mov	rcx, rax
	call	fb_StrAllocTempResult
	mov	QWORD PTR -24[rbp], rax
	mov	rax, QWORD PTR -24[rbp]
	add	rsp, 96
	pop	rbp
	ret
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
.L294:
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
.L295:
	mov	rax, QWORD PTR -16[rbp]
	cmp	rax, QWORD PTR -24[rbp]
	jnb	.L300
	mov	rax, QWORD PTR -16[rbp]
	movzx	edx, BYTE PTR [rax]
	mov	rax, QWORD PTR -8[rbp]
	mov	BYTE PTR [rax], dl
	add	QWORD PTR -8[rbp], 1
	add	QWORD PTR -16[rbp], 1
	jmp	.L295
.L300:
	nop
.L297:
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 72[rax]
	mov	rax, QWORD PTR 24[rbp]
	mov	eax, DWORD PTR 72[rax]
	mov	DWORD PTR [rdx], eax
	nop
	add	rsp, 80
	pop	rbp
	ret
.L298:
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
.L302:
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
.L303:
	mov	rax, QWORD PTR -16[rbp]
	cmp	rax, QWORD PTR -24[rbp]
	jnb	.L308
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
	jmp	.L303
.L308:
	nop
.L305:
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 72[rax]
	mov	rax, QWORD PTR 24[rbp]
	mov	eax, DWORD PTR 72[rax]
	mov	DWORD PTR [rdx], eax
	nop
	add	rsp, 80
	pop	rbp
	ret
.L306:
	.seh_endproc
	.def	_ZN3TKO4TEXT10DECFROMU64ERNS0_6DECBUFEy;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN3TKO4TEXT10DECFROMU64ERNS0_6DECBUFEy
_ZN3TKO4TEXT10DECFROMU64ERNS0_6DECBUFEy:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
.L310:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 384
	mov	DWORD PTR [rax], 0
.L311:
	mov	rcx, QWORD PTR 24[rbp]
	mov	rax, rcx
	shr	rax, 9
	movabs	rdx, 19342813113834067
	mul	rdx
	mov	rax, rdx
	shr	rax, 11
	imul	rax, rax, 1000000000
	sub	rcx, rax
	mov	rax, rcx
	mov	rdx, QWORD PTR 16[rbp]
	add	rdx, 384
	mov	edx, DWORD PTR [rdx]
	movsx	rdx, edx
	sal	rdx, 2
	mov	rcx, rdx
	mov	rdx, QWORD PTR 16[rbp]
	add	rdx, rcx
	mov	DWORD PTR [rdx], eax
	mov	rax, QWORD PTR 24[rbp]
	shr	rax, 9
	movabs	rdx, 19342813113834067
	mul	rdx
	mov	rax, rdx
	shr	rax, 11
	mov	QWORD PTR 24[rbp], rax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 384
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 384
	add	edx, 1
	mov	DWORD PTR [rax], edx
.L312:
	cmp	QWORD PTR 24[rbp], 0
	je	.L315
	jmp	.L311
.L313:
.L315:
	nop
.L314:
	nop
	pop	rbp
	ret
	.seh_endproc
	.section .rdata,"dr"
	.align 8
.LC0:
	.ascii "tiko-lang: internal error: decimal buffer overflow in StrOf*\0"
	.text
	.def	_ZN3TKO4TEXT6DECMULERNS0_6DECBUFEy;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN3TKO4TEXT6DECMULERNS0_6DECBUFEy
_ZN3TKO4TEXT6DECMULERNS0_6DECBUFEy:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 64
	.seh_stackalloc	64
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
.L317:
	mov	QWORD PTR -8[rbp], 0
	mov	DWORD PTR -12[rbp], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 384
	mov	eax, DWORD PTR [rax]
	sub	eax, 1
	mov	DWORD PTR -16[rbp], eax
	jmp	.L318
.L331:
	nop
.L319:
	mov	eax, DWORD PTR -12[rbp]
	cdqe
	sal	rax, 2
	mov	rdx, rax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, rdx
	mov	eax, DWORD PTR [rax]
	mov	eax, eax
	imul	rax, QWORD PTR 24[rbp]
	mov	rdx, rax
	mov	rax, QWORD PTR -8[rbp]
	add	rax, rdx
	mov	QWORD PTR -32[rbp], rax
	mov	rcx, QWORD PTR -32[rbp]
	mov	rax, rcx
	shr	rax, 9
	movabs	rdx, 19342813113834067
	mul	rdx
	mov	rax, rdx
	shr	rax, 11
	imul	rax, rax, 1000000000
	sub	rcx, rax
	mov	rax, rcx
	mov	edx, DWORD PTR -12[rbp]
	movsx	rdx, edx
	sal	rdx, 2
	mov	rcx, rdx
	mov	rdx, QWORD PTR 16[rbp]
	add	rdx, rcx
	mov	DWORD PTR [rdx], eax
	mov	rax, QWORD PTR -32[rbp]
	shr	rax, 9
	movabs	rdx, 19342813113834067
	mul	rdx
	mov	rax, rdx
	shr	rax, 11
	mov	QWORD PTR -8[rbp], rax
.L320:
	add	DWORD PTR -12[rbp], 1
.L318:
	mov	eax, DWORD PTR -12[rbp]
	cmp	eax, DWORD PTR -16[rbp]
	jle	.L331
	nop
.L321:
.L322:
	cmp	QWORD PTR -8[rbp], 0
	je	.L332
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 384
	mov	eax, DWORD PTR [rax]
	cmp	eax, 95
	jle	.L333
	mov	edx, 60
	lea	rcx, .LC0[rip]
	call	fb_StrAllocTempDescZEx
	mov	QWORD PTR -24[rbp], rax
	mov	rax, QWORD PTR -24[rbp]
	mov	r8d, 1
	mov	rdx, rax
	mov	ecx, 0
	call	fb_PrintString
	mov	ecx, 4
	call	fb_End
	jmp	.L327
.L326:
.L333:
	nop
.L327:
	mov	rcx, QWORD PTR -8[rbp]
	mov	rax, rcx
	shr	rax, 9
	movabs	rdx, 19342813113834067
	mul	rdx
	mov	rax, rdx
	shr	rax, 11
	imul	rax, rax, 1000000000
	sub	rcx, rax
	mov	rax, rcx
	mov	rdx, QWORD PTR 16[rbp]
	add	rdx, 384
	mov	edx, DWORD PTR [rdx]
	movsx	rdx, edx
	sal	rdx, 2
	mov	rcx, rdx
	mov	rdx, QWORD PTR 16[rbp]
	add	rdx, rcx
	mov	DWORD PTR [rdx], eax
	mov	rax, QWORD PTR -8[rbp]
	shr	rax, 9
	movabs	rdx, 19342813113834067
	mul	rdx
	mov	rax, rdx
	shr	rax, 11
	mov	QWORD PTR -8[rbp], rax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 384
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 384
	add	edx, 1
	mov	DWORD PTR [rax], edx
	jmp	.L321
.L324:
.L332:
	nop
.L328:
	nop
	add	rsp, 64
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN3TKO4TEXT11DECTOSTRINGERNS0_6DECBUFE;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN3TKO4TEXT11DECTOSTRINGERNS0_6DECBUFE
_ZN3TKO4TEXT11DECTOSTRINGERNS0_6DECBUFE:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 192
	.seh_stackalloc	192
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	lea	rax, -80[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
.L335:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 384
	mov	eax, DWORD PTR [rax]
	cdqe
	sal	rax, 2
	lea	rdx, -4[rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, rdx
	mov	eax, DWORD PTR [rax]
	mov	ecx, eax
	call	fb_UIntToStr
	mov	QWORD PTR -16[rbp], rax
	mov	rdx, QWORD PTR -16[rbp]
	lea	rax, -112[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrInit
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 384
	mov	eax, DWORD PTR [rax]
	sub	eax, 2
	mov	DWORD PTR -4[rbp], eax
	jmp	.L336
.L343:
	nop
.L337:
	mov	eax, DWORD PTR -4[rbp]
	cdqe
	sal	rax, 2
	mov	rdx, rax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, rdx
	mov	eax, DWORD PTR [rax]
	mov	ecx, eax
	call	fb_UIntToStr
	mov	QWORD PTR -32[rbp], rax
	mov	rdx, QWORD PTR -32[rbp]
	lea	rax, -144[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrInit
	lea	rax, -144[rbp]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrLen
	mov	QWORD PTR -40[rbp], rax
	mov	eax, 9
	sub	rax, QWORD PTR -40[rbp]
	mov	edx, 48
	mov	rcx, rax
	call	fb_StrFill1
	mov	QWORD PTR -48[rbp], rax
	mov	rdx, QWORD PTR -48[rbp]
	lea	rax, -112[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrConcatAssign
	lea	rdx, -144[rbp]
	lea	rax, -112[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrConcatAssign
	lea	rax, -144[rbp]
	mov	rcx, rax
	call	fb_StrDelete
.L338:
	sub	DWORD PTR -4[rbp], 1
.L336:
	cmp	DWORD PTR -4[rbp], 0
	jns	.L343
	nop
.L339:
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
.L340:
	lea	rax, -80[rbp]
	mov	rcx, rax
	call	fb_StrAllocTempResult
	mov	QWORD PTR -24[rbp], rax
	mov	rax, QWORD PTR -24[rbp]
	add	rsp, 192
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN3TKO4TEXT8DECSCALEERNS0_6DECBUFEyi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN3TKO4TEXT8DECSCALEERNS0_6DECBUFEyi
_ZN3TKO4TEXT8DECSCALEERNS0_6DECBUFEyi:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 96
	.seh_stackalloc	96
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
	mov	DWORD PTR 32[rbp], r8d
.L345:
	cmp	DWORD PTR 32[rbp], 0
	jle	.L365
	nop
.L347:
	mov	DWORD PTR -4[rbp], 0
	mov	QWORD PTR -16[rbp], 1
.L349:
	mov	rax, QWORD PTR -16[rbp]
	imul	rax, QWORD PTR 24[rbp]
	mov	QWORD PTR -48[rbp], rax
	cmp	QWORD PTR -48[rbp], 1073741823
	ja	.L366
	nop
.L351:
	mov	rax, QWORD PTR -48[rbp]
	mov	QWORD PTR -16[rbp], rax
	add	DWORD PTR -4[rbp], 1
.L353:
	jmp	.L349
.L366:
	nop
.L352:
	mov	eax, DWORD PTR 32[rbp]
	mov	DWORD PTR -20[rbp], eax
.L354:
	mov	eax, DWORD PTR -20[rbp]
	cmp	eax, DWORD PTR -4[rbp]
	jl	.L367
	mov	rax, QWORD PTR -16[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN3TKO4TEXT6DECMULERNS0_6DECBUFEy
	mov	eax, DWORD PTR -4[rbp]
	sub	DWORD PTR -20[rbp], eax
	jmp	.L354
.L367:
	nop
.L356:
	mov	QWORD PTR -32[rbp], 1
	mov	DWORD PTR -36[rbp], 1
	mov	eax, DWORD PTR -20[rbp]
	mov	DWORD PTR -52[rbp], eax
	jmp	.L357
.L368:
	nop
.L358:
	mov	rax, QWORD PTR -32[rbp]
	imul	rax, QWORD PTR 24[rbp]
	mov	QWORD PTR -32[rbp], rax
.L359:
	add	DWORD PTR -36[rbp], 1
.L357:
	mov	eax, DWORD PTR -36[rbp]
	cmp	eax, DWORD PTR -52[rbp]
	jle	.L368
	nop
.L360:
	cmp	QWORD PTR -32[rbp], 1
	jbe	.L369
	mov	rax, QWORD PTR -32[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN3TKO4TEXT6DECMULERNS0_6DECBUFEy
	jmp	.L370
.L348:
.L365:
	nop
	jmp	.L370
.L369:
	nop
.L362:
.L370:
	nop
	add	rsp, 96
	pop	rbp
	ret
	.seh_endproc
	.section .rdata,"dr"
.LC1:
	.ascii "0\0"
.LC2:
	.ascii "1\0"
	.text
	.def	_ZN3TKO4TEXT11ROUNDDIGITSE8FBSTRINGiRi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN3TKO4TEXT11ROUNDDIGITSE8FBSTRINGiRi
_ZN3TKO4TEXT11ROUNDDIGITSE8FBSTRINGiRi:
	push	rbp
	.seh_pushreg	rbp
	sub	rsp, 256
	.seh_stackalloc	256
	lea	rbp, 128[rsp]
	.seh_setframe	rbp, 128
	.seh_endprologue
	mov	QWORD PTR 144[rbp], rcx
	mov	DWORD PTR 152[rbp], edx
	mov	QWORD PTR 160[rbp], r8
	lea	rax, -48[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
.L372:
	mov	rdx, -1
	mov	rcx, QWORD PTR 144[rbp]
	call	fb_StrLen
	mov	QWORD PTR 104[rbp], rax
	mov	eax, DWORD PTR 152[rbp]
	cdqe
	cmp	QWORD PTR 104[rbp], rax
	jg	.L405
	lea	rax, -48[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, QWORD PTR 144[rbp]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrInit
	jmp	.L375
.L405:
	nop
.L374:
	mov	eax, DWORD PTR 152[rbp]
	cdqe
	mov	rdx, rax
	mov	rcx, QWORD PTR 144[rbp]
	call	fb_LEFT
	mov	QWORD PTR 96[rbp], rax
	mov	rdx, QWORD PTR 96[rbp]
	lea	rax, -80[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrInit
	mov	eax, DWORD PTR 152[rbp]
	cdqe
	add	rax, 1
	mov	rdx, rax
	mov	rcx, QWORD PTR 144[rbp]
	call	fb_ASC
	mov	DWORD PTR 92[rbp], eax
	mov	eax, DWORD PTR 92[rbp]
	sub	eax, 48
	mov	DWORD PTR 88[rbp], eax
	cmp	DWORD PTR 88[rbp], 5
	setg	al
	mov	BYTE PTR 127[rbp], al
	cmp	DWORD PTR 88[rbp], 5
	jne	.L406
	mov	BYTE PTR 125[rbp], 0
	mov	eax, DWORD PTR 152[rbp]
	add	eax, 2
	mov	DWORD PTR 120[rbp], eax
	mov	rdx, -1
	mov	rcx, QWORD PTR 144[rbp]
	call	fb_StrLen
	mov	QWORD PTR 80[rbp], rax
	mov	rax, QWORD PTR 80[rbp]
	mov	DWORD PTR 76[rbp], eax
	jmp	.L378
.L408:
	nop
.L379:
	mov	eax, DWORD PTR 120[rbp]
	cdqe
	mov	rdx, rax
	mov	rcx, QWORD PTR 144[rbp]
	call	fb_ASC
	mov	DWORD PTR 72[rbp], eax
	cmp	DWORD PTR 72[rbp], 48
	je	.L407
	mov	BYTE PTR 125[rbp], 1
	jmp	.L382
.L381:
.L383:
.L407:
	nop
.L384:
	add	DWORD PTR 120[rbp], 1
.L378:
	mov	eax, DWORD PTR 120[rbp]
	cmp	eax, DWORD PTR 76[rbp]
	jle	.L408
	nop
.L382:
	mov	eax, DWORD PTR 152[rbp]
	movsx	rdx, eax
	lea	rax, -80[rbp]
	mov	rcx, rax
	call	fb_ASC
	mov	DWORD PTR 68[rbp], eax
	mov	eax, DWORD PTR 68[rbp]
	and	eax, 1
	test	rax, rax
	setne	al
	mov	BYTE PTR 67[rbp], al
	cmp	BYTE PTR 125[rbp], 0
	jne	.L409
	cmp	BYTE PTR 67[rbp], 0
	setne	al
	mov	BYTE PTR 126[rbp], al
	jmp	.L387
.L409:
	nop
.L386:
	mov	BYTE PTR 126[rbp], 1
.L387:
	movzx	eax, BYTE PTR 126[rbp]
	mov	BYTE PTR 127[rbp], al
	jmp	.L388
.L377:
.L406:
	nop
.L388:
	cmp	BYTE PTR 127[rbp], 0
	jne	.L410
	lea	rdx, -80[rbp]
	lea	rax, -48[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrInit
	lea	rax, -80[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	jmp	.L375
.L410:
	nop
.L390:
	mov	eax, DWORD PTR 152[rbp]
	mov	DWORD PTR 116[rbp], eax
.L391:
	cmp	DWORD PTR 116[rbp], 0
	jle	.L411
	mov	eax, DWORD PTR 116[rbp]
	movsx	rdx, eax
	lea	rax, -80[rbp]
	mov	rcx, rax
	call	fb_ASC
	mov	DWORD PTR 60[rbp], eax
	mov	eax, DWORD PTR 60[rbp]
	sub	eax, 47
	mov	DWORD PTR 56[rbp], eax
	cmp	DWORD PTR 56[rbp], 9
	jg	.L412
	mov	eax, DWORD PTR 56[rbp]
	cdqe
	add	rax, 48
	mov	rdx, rax
	mov	ecx, 1
	call	fb_CHR
	mov	QWORD PTR 48[rbp], rax
	mov	eax, DWORD PTR 116[rbp]
	movsx	rdx, eax
	mov	rcx, QWORD PTR 48[rbp]
	lea	rax, -80[rbp]
	mov	r9, rcx
	mov	r8d, 1
	mov	rcx, rax
	call	fb_StrAssignMid
	lea	rdx, -80[rbp]
	lea	rax, -48[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrInit
	lea	rax, -80[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	jmp	.L375
.L395:
.L412:
	nop
.L396:
	mov	edx, 1
	lea	rcx, .LC1[rip]
	call	fb_StrAllocTempDescZEx
	mov	QWORD PTR 40[rbp], rax
	mov	eax, DWORD PTR 116[rbp]
	movsx	rdx, eax
	mov	rcx, QWORD PTR 40[rbp]
	lea	rax, -80[rbp]
	mov	r9, rcx
	mov	r8d, 1
	mov	rcx, rax
	call	fb_StrAssignMid
	sub	DWORD PTR 116[rbp], 1
	jmp	.L391
.L411:
	nop
.L393:
	mov	rax, QWORD PTR 160[rbp]
	mov	eax, DWORD PTR [rax]
	lea	edx, 1[rax]
	mov	rax, QWORD PTR 160[rbp]
	mov	DWORD PTR [rax], edx
	mov	eax, DWORD PTR 152[rbp]
	cdqe
	lea	rdx, -1[rax]
	lea	rax, -80[rbp]
	mov	rcx, rax
	call	fb_LEFT
	mov	QWORD PTR 32[rbp], rax
	lea	rax, -16[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	rdx, QWORD PTR 32[rbp]
	lea	rax, -16[rbp]
	mov	QWORD PTR 32[rsp], -1
	mov	r9, rdx
	mov	r8d, 2
	lea	rdx, .LC2[rip]
	mov	rcx, rax
	call	fb_StrConcat
	mov	QWORD PTR 24[rbp], rax
	mov	rdx, QWORD PTR 24[rbp]
	lea	rax, -48[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrInit
	lea	rax, -80[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	nop
.L375:
	lea	rax, -48[rbp]
	mov	rcx, rax
	call	fb_StrAllocTempResult
	mov	QWORD PTR 16[rbp], rax
	mov	rax, QWORD PTR 16[rbp]
	add	rsp, 256
	pop	rbp
	ret
	.seh_endproc
	.section .rdata,"dr"
.LC3:
	.ascii ".\0"
.LC4:
	.ascii "0.\0"
.LC5:
	.ascii "-\0"
.LC6:
	.ascii "+\0"
.LC7:
	.ascii "e\0"
	.text
	.def	_ZN3TKO4TEXT6LAYOUTE8FBSTRINGS1_ii;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN3TKO4TEXT6LAYOUTE8FBSTRINGS1_ii
_ZN3TKO4TEXT6LAYOUTE8FBSTRINGS1_ii:
	push	rbp
	.seh_pushreg	rbp
	sub	rsp, 880
	.seh_stackalloc	880
	lea	rbp, 128[rsp]
	.seh_setframe	rbp, 128
	.seh_endprologue
	mov	QWORD PTR 768[rbp], rcx
	mov	QWORD PTR 776[rbp], rdx
	mov	DWORD PTR 784[rbp], r8d
	mov	DWORD PTR 792[rbp], r9d
	lea	rax, 336[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
.L414:
	cmp	DWORD PTR 784[rbp], -4
	jl	.L443
	mov	eax, DWORD PTR 784[rbp]
	cmp	eax, DWORD PTR 792[rbp]
	setge	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR 744[rbp], rax
	jmp	.L417
.L443:
	nop
.L416:
	mov	QWORD PTR 744[rbp], -1
.L417:
	cmp	QWORD PTR 744[rbp], 0
	setne	al
	mov	BYTE PTR 743[rbp], al
	cmp	BYTE PTR 743[rbp], 0
	jne	.L444
	cmp	DWORD PTR 784[rbp], 0
	js	.L445
	mov	rax, QWORD PTR 776[rbp]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrLen
	mov	QWORD PTR 728[rbp], rax
	mov	eax, DWORD PTR 784[rbp]
	cdqe
	add	rax, 1
	cmp	QWORD PTR 728[rbp], rax
	jg	.L446
	mov	rax, QWORD PTR 776[rbp]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrLen
	mov	QWORD PTR 720[rbp], rax
	mov	eax, DWORD PTR 784[rbp]
	cdqe
	sub	rax, QWORD PTR 720[rbp]
	add	rax, 1
	mov	edx, 48
	mov	rcx, rax
	call	fb_StrFill1
	mov	QWORD PTR 712[rbp], rax
	lea	rax, 48[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	rdx, QWORD PTR 776[rbp]
	lea	rax, 48[rbp]
	mov	QWORD PTR 32[rsp], -1
	mov	r9, rdx
	mov	r8, -1
	mov	rdx, QWORD PTR 768[rbp]
	mov	rcx, rax
	call	fb_StrConcat
	mov	QWORD PTR 704[rbp], rax
	lea	rax, 16[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	rcx, QWORD PTR 712[rbp]
	mov	rdx, QWORD PTR 704[rbp]
	lea	rax, 16[rbp]
	mov	QWORD PTR 32[rsp], -1
	mov	r9, rcx
	mov	r8, -1
	mov	rcx, rax
	call	fb_StrConcat
	mov	QWORD PTR 696[rbp], rax
	mov	rdx, QWORD PTR 696[rbp]
	lea	rax, 336[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrInit
	jmp	.L428
.L423:
.L446:
	nop
.L425:
	mov	eax, DWORD PTR 784[rbp]
	cdqe
	lea	rdx, 2[rax]
	mov	rax, QWORD PTR 776[rbp]
	mov	r8, -1
	mov	rcx, rax
	call	fb_StrMid
	mov	QWORD PTR 688[rbp], rax
	mov	eax, DWORD PTR 784[rbp]
	cdqe
	lea	rdx, 1[rax]
	mov	rax, QWORD PTR 776[rbp]
	mov	rcx, rax
	call	fb_LEFT
	mov	QWORD PTR 680[rbp], rax
	lea	rax, 144[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	rdx, QWORD PTR 680[rbp]
	lea	rax, 144[rbp]
	mov	QWORD PTR 32[rsp], -1
	mov	r9, rdx
	mov	r8, -1
	mov	rdx, QWORD PTR 768[rbp]
	mov	rcx, rax
	call	fb_StrConcat
	mov	QWORD PTR 672[rbp], rax
	lea	rax, 112[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	rdx, QWORD PTR 672[rbp]
	lea	rax, 112[rbp]
	mov	QWORD PTR 32[rsp], 2
	lea	r9, .LC3[rip]
	mov	r8, -1
	mov	rcx, rax
	call	fb_StrConcat
	mov	QWORD PTR 664[rbp], rax
	lea	rax, 80[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	rcx, QWORD PTR 688[rbp]
	mov	rdx, QWORD PTR 664[rbp]
	lea	rax, 80[rbp]
	mov	QWORD PTR 32[rsp], -1
	mov	r9, rcx
	mov	r8, -1
	mov	rcx, rax
	call	fb_StrConcat
	mov	QWORD PTR 656[rbp], rax
	mov	rdx, QWORD PTR 656[rbp]
	lea	rax, 336[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrInit
	jmp	.L428
.L421:
.L445:
	nop
.L427:
	mov	eax, DWORD PTR 784[rbp]
	cdqe
	not	rax
	mov	edx, 48
	mov	rcx, rax
	call	fb_StrFill1
	mov	QWORD PTR 648[rbp], rax
	lea	rax, 240[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	lea	rax, 240[rbp]
	mov	QWORD PTR 32[rsp], 3
	lea	r9, .LC4[rip]
	mov	r8, -1
	mov	rdx, QWORD PTR 768[rbp]
	mov	rcx, rax
	call	fb_StrConcat
	mov	QWORD PTR 640[rbp], rax
	lea	rax, 208[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	rcx, QWORD PTR 648[rbp]
	mov	rdx, QWORD PTR 640[rbp]
	lea	rax, 208[rbp]
	mov	QWORD PTR 32[rsp], -1
	mov	r9, rcx
	mov	r8, -1
	mov	rcx, rax
	call	fb_StrConcat
	mov	QWORD PTR 632[rbp], rax
	lea	rax, 176[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	rcx, QWORD PTR 776[rbp]
	mov	rdx, QWORD PTR 632[rbp]
	lea	rax, 176[rbp]
	mov	QWORD PTR 32[rsp], -1
	mov	r9, rcx
	mov	r8, -1
	mov	rcx, rax
	call	fb_StrConcat
	mov	QWORD PTR 624[rbp], rax
	mov	rdx, QWORD PTR 624[rbp]
	lea	rax, 336[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrInit
	jmp	.L428
.L419:
.L444:
	nop
.L429:
	mov	rax, QWORD PTR 776[rbp]
	mov	edx, 1
	mov	rcx, rax
	call	fb_LEFT
	mov	QWORD PTR 616[rbp], rax
	mov	rdx, QWORD PTR 616[rbp]
	lea	rax, 304[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrInit
	mov	rax, QWORD PTR 776[rbp]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrLen
	mov	QWORD PTR 608[rbp], rax
	cmp	QWORD PTR 608[rbp], 1
	jle	.L447
	mov	rax, QWORD PTR 776[rbp]
	mov	r8, -1
	mov	edx, 2
	mov	rcx, rax
	call	fb_StrMid
	mov	QWORD PTR 600[rbp], rax
	lea	rax, -16[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	rdx, QWORD PTR 600[rbp]
	lea	rax, -16[rbp]
	mov	QWORD PTR 32[rsp], -1
	mov	r9, rdx
	mov	r8d, 2
	lea	rdx, .LC3[rip]
	mov	rcx, rax
	call	fb_StrConcat
	mov	QWORD PTR 592[rbp], rax
	lea	rax, -48[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	rcx, QWORD PTR 592[rbp]
	lea	rdx, 304[rbp]
	lea	rax, -48[rbp]
	mov	QWORD PTR 32[rsp], -1
	mov	r9, rcx
	mov	r8, -1
	mov	rcx, rax
	call	fb_StrConcat
	mov	QWORD PTR 584[rbp], rax
	mov	rdx, QWORD PTR 584[rbp]
	lea	rax, 304[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrAssign
	jmp	.L431
.L447:
	nop
.L431:
	mov	eax, DWORD PTR 784[rbp]
	cdq
	mov	eax, edx
	xor	eax, DWORD PTR 784[rbp]
	sub	eax, edx
	mov	eax, eax
	mov	rcx, rax
	call	fb_LongintToStr
	mov	QWORD PTR 576[rbp], rax
	mov	rdx, QWORD PTR 576[rbp]
	lea	rax, 272[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrInit
	lea	rax, 272[rbp]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrLen
	mov	QWORD PTR 568[rbp], rax
	cmp	QWORD PTR 568[rbp], 1
	jg	.L448
	lea	rax, -80[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	lea	rdx, 272[rbp]
	lea	rax, -80[rbp]
	mov	QWORD PTR 32[rsp], -1
	mov	r9, rdx
	mov	r8d, 2
	lea	rdx, .LC1[rip]
	mov	rcx, rax
	call	fb_StrConcat
	mov	QWORD PTR 560[rbp], rax
	mov	rdx, QWORD PTR 560[rbp]
	lea	rax, 272[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrAssign
	jmp	.L433
.L448:
	nop
.L433:
	cmp	DWORD PTR 784[rbp], 0
	jns	.L449
	lea	rax, 496[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9d, 2
	lea	r8, .LC5[rip]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrInit
	jmp	.L436
.L449:
	nop
.L435:
	lea	rax, 496[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9d, 2
	lea	r8, .LC6[rip]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrInit
.L436:
	lea	rax, 464[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	lea	rdx, 304[rbp]
	lea	rax, 464[rbp]
	mov	QWORD PTR 32[rsp], -1
	mov	r9, rdx
	mov	r8, -1
	mov	rdx, QWORD PTR 768[rbp]
	mov	rcx, rax
	call	fb_StrConcat
	mov	QWORD PTR 552[rbp], rax
	lea	rax, 432[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	rdx, QWORD PTR 552[rbp]
	lea	rax, 432[rbp]
	mov	QWORD PTR 32[rsp], 2
	lea	r9, .LC7[rip]
	mov	r8, -1
	mov	rcx, rax
	call	fb_StrConcat
	mov	QWORD PTR 544[rbp], rax
	lea	rax, 400[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	lea	rcx, 496[rbp]
	mov	rdx, QWORD PTR 544[rbp]
	lea	rax, 400[rbp]
	mov	QWORD PTR 32[rsp], -1
	mov	r9, rcx
	mov	r8, -1
	mov	rcx, rax
	call	fb_StrConcat
	mov	QWORD PTR 536[rbp], rax
	lea	rax, 368[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	lea	rcx, 272[rbp]
	mov	rdx, QWORD PTR 536[rbp]
	lea	rax, 368[rbp]
	mov	QWORD PTR 32[rsp], -1
	mov	r9, rcx
	mov	r8, -1
	mov	rcx, rax
	call	fb_StrConcat
	mov	QWORD PTR 528[rbp], rax
	mov	rdx, QWORD PTR 528[rbp]
	lea	rax, 336[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrInit
	lea	rax, 496[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	lea	rax, 272[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	lea	rax, 304[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	nop
.L428:
	lea	rax, 336[rbp]
	mov	rcx, rax
	call	fb_StrAllocTempResult
	mov	QWORD PTR 520[rbp], rax
	mov	rax, QWORD PTR 520[rbp]
	add	rsp, 880
	pop	rbp
	ret
	.seh_endproc
	.section .rdata,"dr"
.LC8:
	.ascii "nan\0"
.LC9:
	.ascii "-inf\0"
.LC10:
	.ascii "inf\0"
.LC11:
	.ascii "\0"
	.text
	.def	_ZN3TKO4TEXT11FORMATFLOATEyiii;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN3TKO4TEXT11FORMATFLOATEyiii
_ZN3TKO4TEXT11FORMATFLOATEyiii:
	push	rbp
	.seh_pushreg	rbp
	push	rdi
	.seh_pushreg	rdi
	sub	rsp, 856
	.seh_stackalloc	856
	lea	rbp, 128[rsp]
	.seh_setframe	rbp, 128
	.seh_endprologue
	mov	QWORD PTR 752[rbp], rcx
	mov	DWORD PTR 760[rbp], edx
	mov	DWORD PTR 768[rbp], r8d
	mov	DWORD PTR 776[rbp], r9d
	lea	rax, 448[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
.L451:
	mov	eax, DWORD PTR 760[rbp]
	and	eax, 63
	mov	edx, 1
	mov	ecx, eax
	sal	rdx, cl
	mov	rax, rdx
	sub	rax, 1
	mov	QWORD PTR 696[rbp], rax
	mov	eax, DWORD PTR 768[rbp]
	and	eax, 63
	mov	edx, 1
	mov	ecx, eax
	sal	rdx, cl
	mov	rax, rdx
	sub	eax, 1
	mov	DWORD PTR 692[rbp], eax
	mov	eax, DWORD PTR 768[rbp]
	sub	eax, 1
	and	eax, 63
	mov	edx, 1
	mov	ecx, eax
	sal	rdx, cl
	mov	rax, rdx
	sub	eax, 1
	mov	DWORD PTR 688[rbp], eax
	mov	edx, DWORD PTR 760[rbp]
	mov	eax, DWORD PTR 768[rbp]
	add	eax, edx
	and	eax, 63
	mov	rdx, QWORD PTR 752[rbp]
	mov	ecx, eax
	shr	rdx, cl
	mov	rax, rdx
	and	eax, 1
	mov	DWORD PTR 684[rbp], eax
	mov	eax, DWORD PTR 760[rbp]
	and	eax, 63
	mov	rdx, QWORD PTR 752[rbp]
	mov	ecx, eax
	shr	rdx, cl
	mov	rax, rdx
	mov	edx, eax
	mov	eax, DWORD PTR 692[rbp]
	and	eax, edx
	mov	DWORD PTR 680[rbp], eax
	mov	rax, QWORD PTR 752[rbp]
	and	rax, QWORD PTR 696[rbp]
	mov	QWORD PTR 672[rbp], rax
	mov	eax, DWORD PTR 680[rbp]
	cmp	eax, DWORD PTR 692[rbp]
	jne	.L489
	cmp	QWORD PTR 672[rbp], 0
	je	.L490
	lea	rax, 448[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9d, 4
	lea	r8, .LC8[rip]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrInit
	jmp	.L460
.L490:
	nop
.L455:
	cmp	DWORD PTR 684[rbp], 0
	je	.L491
	lea	rax, -48[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9d, 5
	lea	r8, .LC9[rip]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrInit
	jmp	.L459
.L491:
	nop
.L458:
	lea	rax, -48[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9d, 4
	lea	r8, .LC10[rip]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrInit
.L459:
	lea	rdx, -48[rbp]
	lea	rax, 448[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrInit
	lea	rax, -48[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	jmp	.L460
.L453:
.L489:
	nop
.L461:
	cmp	DWORD PTR 684[rbp], 0
	je	.L492
	lea	rax, 576[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9d, 2
	lea	r8, .LC5[rip]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrInit
	jmp	.L464
.L492:
	nop
.L463:
	lea	rax, 576[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9d, 1
	lea	r8, .LC11[rip]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrInit
.L464:
	lea	rdx, 576[rbp]
	lea	rax, 416[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrInit
	lea	rax, 576[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	mov	QWORD PTR 408[rbp], 0
	mov	DWORD PTR 404[rbp], 0
	cmp	DWORD PTR 680[rbp], 0
	jne	.L493
	cmp	QWORD PTR 672[rbp], 0
	jne	.L494
	lea	rax, -80[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	lea	rdx, 416[rbp]
	lea	rax, -80[rbp]
	mov	QWORD PTR 32[rsp], 2
	lea	r9, .LC1[rip]
	mov	r8, -1
	mov	rcx, rax
	call	fb_StrConcat
	mov	QWORD PTR 664[rbp], rax
	mov	rdx, QWORD PTR 664[rbp]
	lea	rax, 448[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrInit
	lea	rax, 416[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	jmp	.L460
.L494:
	nop
.L468:
	mov	rax, QWORD PTR 672[rbp]
	mov	QWORD PTR 408[rbp], rax
	mov	edx, DWORD PTR 688[rbp]
	mov	eax, DWORD PTR 760[rbp]
	add	eax, edx
	mov	edx, 1
	sub	edx, eax
	mov	eax, edx
	mov	DWORD PTR 404[rbp], eax
	jmp	.L469
.L493:
	nop
.L466:
	mov	eax, DWORD PTR 760[rbp]
	and	eax, 63
	mov	edx, 1
	mov	ecx, eax
	sal	rdx, cl
	mov	rax, rdx
	or	rax, QWORD PTR 672[rbp]
	mov	QWORD PTR 408[rbp], rax
	mov	eax, DWORD PTR 680[rbp]
	sub	eax, DWORD PTR 688[rbp]
	sub	eax, DWORD PTR 760[rbp]
	mov	DWORD PTR 404[rbp], eax
.L469:
	lea	rax, 16[rbp]
	mov	rdx, rax
	mov	eax, 0
	mov	ecx, 48
	mov	rdi, rdx
	rep stosq
	mov	rdx, rdi
	mov	DWORD PTR [rdx], eax
	add	rdx, 4
	mov	rdx, QWORD PTR 408[rbp]
	lea	rax, 16[rbp]
	mov	rcx, rax
	call	_ZN3TKO4TEXT10DECFROMU64ERNS0_6DECBUFEy
	mov	DWORD PTR 708[rbp], 0
	mov	eax, DWORD PTR 404[rbp]
	test	eax, eax
	js	.L495
	mov	edx, DWORD PTR 404[rbp]
	lea	rax, 16[rbp]
	mov	r8d, edx
	mov	edx, 2
	mov	rcx, rax
	call	_ZN3TKO4TEXT8DECSCALEERNS0_6DECBUFEyi
	jmp	.L472
.L495:
	nop
.L471:
	mov	eax, DWORD PTR 404[rbp]
	neg	eax
	mov	edx, eax
	lea	rax, 16[rbp]
	mov	r8d, edx
	mov	edx, 5
	mov	rcx, rax
	call	_ZN3TKO4TEXT8DECSCALEERNS0_6DECBUFEyi
	mov	eax, DWORD PTR 404[rbp]
	mov	DWORD PTR 708[rbp], eax
.L472:
	lea	rax, 16[rbp]
	mov	rcx, rax
	call	_ZN3TKO4TEXT11DECTOSTRINGERNS0_6DECBUFE
	mov	QWORD PTR 656[rbp], rax
	mov	rdx, QWORD PTR 656[rbp]
	lea	rax, -16[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrInit
	lea	rax, -16[rbp]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrLen
	mov	QWORD PTR 648[rbp], rax
	mov	rax, QWORD PTR 648[rbp]
	mov	edx, eax
	mov	eax, DWORD PTR 708[rbp]
	add	eax, edx
	sub	eax, 1
	mov	DWORD PTR -20[rbp], eax
	lea	rax, 544[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	lea	rdx, -16[rbp]
	lea	rax, 544[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrAssign
	lea	rcx, -20[rbp]
	mov	edx, DWORD PTR 776[rbp]
	lea	rax, 544[rbp]
	mov	r8, rcx
	mov	rcx, rax
	call	_ZN3TKO4TEXT11ROUNDDIGITSE8FBSTRINGiRi
	mov	QWORD PTR 640[rbp], rax
	mov	rdx, QWORD PTR 640[rbp]
	lea	rax, -16[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrAssign
	lea	rax, 544[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	lea	rax, -16[rbp]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrLen
	mov	QWORD PTR 632[rbp], rax
	mov	rax, QWORD PTR 632[rbp]
	mov	DWORD PTR 704[rbp], eax
.L473:
	cmp	DWORD PTR 704[rbp], 1
	jle	.L496
	mov	eax, DWORD PTR 704[rbp]
	movsx	rdx, eax
	lea	rax, -16[rbp]
	mov	rcx, rax
	call	fb_ASC
	mov	DWORD PTR 628[rbp], eax
	cmp	DWORD PTR 628[rbp], 48
	sete	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR 712[rbp], rax
	jmp	.L476
.L496:
	nop
.L475:
	mov	QWORD PTR 712[rbp], 0
.L476:
	cmp	QWORD PTR 712[rbp], 0
	je	.L497
	sub	DWORD PTR 704[rbp], 1
	jmp	.L473
.L497:
	nop
.L478:
	lea	rax, 480[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	eax, DWORD PTR 704[rbp]
	movsx	rdx, eax
	lea	rax, -16[rbp]
	mov	rcx, rax
	call	fb_LEFT
	mov	QWORD PTR 616[rbp], rax
	mov	rdx, QWORD PTR 616[rbp]
	lea	rax, 480[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrAssign
	lea	rax, 512[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	lea	rdx, 416[rbp]
	lea	rax, 512[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrAssign
	mov	ecx, DWORD PTR -20[rbp]
	mov	r8d, DWORD PTR 776[rbp]
	lea	rdx, 480[rbp]
	lea	rax, 512[rbp]
	mov	r9d, r8d
	mov	r8d, ecx
	mov	rcx, rax
	call	_ZN3TKO4TEXT6LAYOUTE8FBSTRINGS1_ii
	mov	QWORD PTR 608[rbp], rax
	mov	rdx, QWORD PTR 608[rbp]
	lea	rax, 448[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrInit
	lea	rax, 480[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	lea	rax, 512[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	lea	rax, -16[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	lea	rax, 416[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	nop
.L460:
	lea	rax, 448[rbp]
	mov	rcx, rax
	call	fb_StrAllocTempResult
	mov	QWORD PTR 600[rbp], rax
	mov	rax, QWORD PTR 600[rbp]
	add	rsp, 856
	pop	rdi
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
	.def	fb_ArrayRedimTo;	.scl	2;	.type	32;	.endef
	.def	fb_StrAllocTempDescZEx;	.scl	2;	.type	32;	.endef
	.def	fb_PrintString;	.scl	2;	.type	32;	.endef
	.def	fb_End;	.scl	2;	.type	32;	.endef
	.def	fb_UIntToStr;	.scl	2;	.type	32;	.endef
	.def	fb_StrLen;	.scl	2;	.type	32;	.endef
	.def	fb_StrFill1;	.scl	2;	.type	32;	.endef
	.def	fb_StrConcatAssign;	.scl	2;	.type	32;	.endef
	.def	fb_LEFT;	.scl	2;	.type	32;	.endef
	.def	fb_ASC;	.scl	2;	.type	32;	.endef
	.def	fb_CHR;	.scl	2;	.type	32;	.endef
	.def	fb_StrAssignMid;	.scl	2;	.type	32;	.endef
	.def	fb_StrConcat;	.scl	2;	.type	32;	.endef
	.def	fb_StrMid;	.scl	2;	.type	32;	.endef
	.def	fb_LongintToStr;	.scl	2;	.type	32;	.endef
