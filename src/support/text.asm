	.file	"text.c"
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
	.globl	_ZN3TKO4TEXT14DETECTENCODINGEPKhi
	.def	_ZN3TKO4TEXT14DETECTENCODINGEPKhi;	.scl	2;	.type	32;	.endef
	.seh_proc	_ZN3TKO4TEXT14DETECTENCODINGEPKhi
_ZN3TKO4TEXT14DETECTENCODINGEPKhi:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	add	rsp, -128
	.seh_stackalloc	128
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
	mov	QWORD PTR -96[rbp], 0
.L286:
	cmp	DWORD PTR 24[rbp], 2
	jle	.L355
	mov	rax, QWORD PTR 16[rbp]
	movzx	eax, BYTE PTR [rax]
	cmp	al, -17
	jne	.L356
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 1
	movzx	eax, BYTE PTR [rax]
	cmp	al, -69
	sete	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -8[rbp], rax
	jmp	.L291
.L356:
	nop
.L290:
	mov	QWORD PTR -8[rbp], 0
.L291:
	cmp	QWORD PTR -8[rbp], 0
	je	.L357
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 2
	movzx	eax, BYTE PTR [rax]
	cmp	al, -65
	sete	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -16[rbp], rax
	jmp	.L294
.L357:
	nop
.L293:
	mov	QWORD PTR -16[rbp], 0
.L294:
	cmp	QWORD PTR -16[rbp], 0
	setne	al
	mov	BYTE PTR -81[rbp], al
	cmp	BYTE PTR -81[rbp], 0
	je	.L358
	mov	QWORD PTR -96[rbp], 1
	jmp	.L296
.L288:
.L297:
.L355:
	nop
	jmp	.L298
.L358:
	nop
.L298:
	cmp	DWORD PTR 24[rbp], 3
	jle	.L359
	mov	rax, QWORD PTR 16[rbp]
	movzx	eax, BYTE PTR [rax]
	cmp	al, -1
	jne	.L360
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 1
	movzx	eax, BYTE PTR [rax]
	cmp	al, -2
	sete	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -24[rbp], rax
	jmp	.L303
.L360:
	nop
.L302:
	mov	QWORD PTR -24[rbp], 0
.L303:
	cmp	QWORD PTR -24[rbp], 0
	je	.L361
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 2
	movzx	eax, BYTE PTR [rax]
	test	al, al
	sete	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -32[rbp], rax
	jmp	.L306
.L361:
	nop
.L305:
	mov	QWORD PTR -32[rbp], 0
.L306:
	cmp	QWORD PTR -32[rbp], 0
	je	.L362
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 3
	movzx	eax, BYTE PTR [rax]
	test	al, al
	sete	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -40[rbp], rax
	jmp	.L309
.L362:
	nop
.L308:
	mov	QWORD PTR -40[rbp], 0
.L309:
	cmp	QWORD PTR -40[rbp], 0
	je	.L363
	mov	QWORD PTR -96[rbp], 4
	jmp	.L296
.L311:
.L363:
	nop
.L312:
	mov	rax, QWORD PTR 16[rbp]
	movzx	eax, BYTE PTR [rax]
	test	al, al
	jne	.L364
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 1
	movzx	eax, BYTE PTR [rax]
	test	al, al
	sete	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -48[rbp], rax
	jmp	.L315
.L364:
	nop
.L314:
	mov	QWORD PTR -48[rbp], 0
.L315:
	cmp	QWORD PTR -48[rbp], 0
	je	.L365
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 2
	movzx	eax, BYTE PTR [rax]
	cmp	al, -2
	sete	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -56[rbp], rax
	jmp	.L318
.L365:
	nop
.L317:
	mov	QWORD PTR -56[rbp], 0
.L318:
	cmp	QWORD PTR -56[rbp], 0
	je	.L366
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 3
	movzx	eax, BYTE PTR [rax]
	cmp	al, -1
	sete	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -64[rbp], rax
	jmp	.L321
.L366:
	nop
.L320:
	mov	QWORD PTR -64[rbp], 0
.L321:
	cmp	QWORD PTR -64[rbp], 0
	je	.L367
	mov	QWORD PTR -96[rbp], 5
	jmp	.L296
.L300:
.L323:
.L324:
.L359:
	nop
	jmp	.L325
.L367:
	nop
.L325:
	cmp	DWORD PTR 24[rbp], 1
	jle	.L368
	mov	rax, QWORD PTR 16[rbp]
	movzx	eax, BYTE PTR [rax]
	cmp	al, -1
	jne	.L369
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 1
	movzx	eax, BYTE PTR [rax]
	cmp	al, -2
	sete	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -72[rbp], rax
	jmp	.L330
.L369:
	nop
.L329:
	mov	QWORD PTR -72[rbp], 0
.L330:
	cmp	QWORD PTR -72[rbp], 0
	je	.L370
	mov	QWORD PTR -96[rbp], 2
	jmp	.L296
.L370:
	nop
.L332:
	mov	rax, QWORD PTR 16[rbp]
	movzx	eax, BYTE PTR [rax]
	cmp	al, -2
	jne	.L371
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 1
	movzx	eax, BYTE PTR [rax]
	cmp	al, -1
	sete	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -80[rbp], rax
	jmp	.L335
.L371:
	nop
.L334:
	mov	QWORD PTR -80[rbp], 0
.L335:
	cmp	QWORD PTR -80[rbp], 0
	je	.L372
	mov	QWORD PTR -96[rbp], 3
	jmp	.L296
.L327:
.L337:
.L368:
	nop
	jmp	.L338
.L372:
	nop
.L338:
	mov	eax, DWORD PTR 24[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN3TKO4TEXT11ISVALIDUTF8EPKhi
	mov	BYTE PTR -82[rbp], al
	cmp	BYTE PTR -82[rbp], 0
	je	.L373
	mov	QWORD PTR -96[rbp], 0
	jmp	.L296
.L373:
	nop
.L340:
	mov	QWORD PTR -96[rbp], 6
	nop
.L296:
	mov	rax, QWORD PTR -96[rbp]
	sub	rsp, -128
	pop	rbp
	ret
	.seh_endproc
	.section .rdata,"dr"
.LC0:
	.ascii "utf-8\0"
.LC1:
	.ascii "utf-8 (bom)\0"
.LC2:
	.ascii "utf-16le\0"
.LC3:
	.ascii "utf-16be\0"
.LC4:
	.ascii "utf-32le\0"
.LC5:
	.ascii "utf-32be\0"
.LC6:
	.ascii "bytes\0"
	.text
	.globl	_ZN3TKO4TEXT12ENCODINGNAMEENS0_8ENCODINGE
	.def	_ZN3TKO4TEXT12ENCODINGNAMEENS0_8ENCODINGE;	.scl	2;	.type	32;	.endef
	.seh_proc	_ZN3TKO4TEXT12ENCODINGNAMEENS0_8ENCODINGE
_ZN3TKO4TEXT12ENCODINGNAMEENS0_8ENCODINGE:
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
.L375:
	cmp	QWORD PTR 16[rbp], 0
	jne	.L398
	nop
.L376:
	lea	rax, -32[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9d, 6
	lea	r8, .LC0[rip]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrInit
	jmp	.L390
.L398:
	nop
.L377:
	cmp	QWORD PTR 16[rbp], 1
	jne	.L399
	nop
.L379:
	lea	rax, -32[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9d, 12
	lea	r8, .LC1[rip]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrInit
	jmp	.L390
.L399:
	nop
.L380:
	cmp	QWORD PTR 16[rbp], 2
	jne	.L400
	nop
.L381:
	lea	rax, -32[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9d, 9
	lea	r8, .LC2[rip]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrInit
	jmp	.L390
.L400:
	nop
.L382:
	cmp	QWORD PTR 16[rbp], 3
	jne	.L401
	nop
.L383:
	lea	rax, -32[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9d, 9
	lea	r8, .LC3[rip]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrInit
	jmp	.L390
.L401:
	nop
.L384:
	cmp	QWORD PTR 16[rbp], 4
	jne	.L402
	nop
.L385:
	lea	rax, -32[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9d, 9
	lea	r8, .LC4[rip]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrInit
	jmp	.L390
.L402:
	nop
.L386:
	cmp	QWORD PTR 16[rbp], 5
	jne	.L403
	nop
.L387:
	lea	rax, -32[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9d, 9
	lea	r8, .LC5[rip]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrInit
	jmp	.L390
.L403:
	nop
.L388:
	lea	rax, -32[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9d, 6
	lea	r8, .LC6[rip]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrInit
.L378:
.L389:
	nop
.L390:
	lea	rax, -32[rbp]
	mov	rcx, rax
	call	fb_StrAllocTempResult
	mov	QWORD PTR -8[rbp], rax
	mov	rax, QWORD PTR -8[rbp]
	add	rsp, 80
	pop	rbp
	ret
	.seh_endproc
	.globl	_ZN3TKO4TEXT16FIRSTINVALIDUTF8EPKhi
	.def	_ZN3TKO4TEXT16FIRSTINVALIDUTF8EPKhi;	.scl	2;	.type	32;	.endef
	.seh_proc	_ZN3TKO4TEXT16FIRSTINVALIDUTF8EPKhi
_ZN3TKO4TEXT16FIRSTINVALIDUTF8EPKhi:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 48
	.seh_stackalloc	48
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
	mov	DWORD PTR -48[rbp], 0
.L405:
	mov	DWORD PTR -4[rbp], 0
.L406:
	mov	eax, DWORD PTR -4[rbp]
	cmp	eax, DWORD PTR 24[rbp]
	jge	.L465
	mov	eax, DWORD PTR -4[rbp]
	movsx	rdx, eax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, rdx
	movzx	eax, BYTE PTR [rax]
	mov	BYTE PTR -33[rbp], al
	movzx	eax, BYTE PTR -33[rbp]
	test	al, al
	js	.L466
	add	DWORD PTR -4[rbp], 1
	jmp	.L406
.L410:
.L466:
	nop
.L411:
	mov	DWORD PTR -24[rbp], 0
	mov	DWORD PTR -28[rbp], 0
	movzx	eax, BYTE PTR -33[rbp]
	and	eax, 224
	cmp	rax, 192
	jne	.L467
	mov	DWORD PTR -24[rbp], 1
	movzx	eax, BYTE PTR -33[rbp]
	and	eax, 31
	mov	DWORD PTR -28[rbp], eax
	jmp	.L414
.L467:
	nop
.L413:
	movzx	eax, BYTE PTR -33[rbp]
	and	eax, 240
	cmp	rax, 224
	jne	.L468
	mov	DWORD PTR -24[rbp], 2
	movzx	eax, BYTE PTR -33[rbp]
	and	eax, 15
	mov	DWORD PTR -28[rbp], eax
	jmp	.L414
.L468:
	nop
.L416:
	movzx	eax, BYTE PTR -33[rbp]
	and	eax, 248
	cmp	rax, 240
	jne	.L469
	mov	DWORD PTR -24[rbp], 3
	movzx	eax, BYTE PTR -33[rbp]
	and	eax, 7
	mov	DWORD PTR -28[rbp], eax
	jmp	.L414
.L469:
	nop
.L418:
	mov	eax, DWORD PTR -4[rbp]
	mov	DWORD PTR -48[rbp], eax
	jmp	.L419
.L414:
	mov	eax, DWORD PTR -4[rbp]
	movsx	rdx, eax
	mov	eax, DWORD PTR -24[rbp]
	cdqe
	add	rdx, rax
	mov	eax, DWORD PTR 24[rbp]
	cdqe
	cmp	rdx, rax
	jl	.L470
	mov	eax, DWORD PTR -4[rbp]
	mov	DWORD PTR -48[rbp], eax
	jmp	.L419
.L470:
	nop
.L421:
	mov	DWORD PTR -32[rbp], 1
	mov	eax, DWORD PTR -24[rbp]
	mov	DWORD PTR -40[rbp], eax
	jmp	.L422
.L472:
	nop
.L423:
	mov	eax, DWORD PTR -4[rbp]
	movsx	rdx, eax
	mov	eax, DWORD PTR -32[rbp]
	cdqe
	add	rax, rdx
	mov	rdx, rax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, rdx
	movzx	eax, BYTE PTR [rax]
	mov	BYTE PTR -43[rbp], al
	movzx	eax, BYTE PTR -43[rbp]
	and	eax, 192
	cmp	rax, 128
	je	.L471
	mov	eax, DWORD PTR -4[rbp]
	mov	DWORD PTR -48[rbp], eax
	jmp	.L419
.L471:
	nop
.L425:
	mov	eax, DWORD PTR -28[rbp]
	sal	rax, 6
	mov	edx, eax
	movzx	eax, BYTE PTR -43[rbp]
	and	eax, 63
	or	eax, edx
	mov	DWORD PTR -28[rbp], eax
.L426:
	add	DWORD PTR -32[rbp], 1
.L422:
	mov	eax, DWORD PTR -32[rbp]
	cmp	eax, DWORD PTR -40[rbp]
	jle	.L472
	nop
.L427:
	cmp	DWORD PTR -24[rbp], 1
	jne	.L473
	nop
.L428:
	cmp	DWORD PTR -28[rbp], 127
	ja	.L474
	mov	eax, DWORD PTR -4[rbp]
	mov	DWORD PTR -48[rbp], eax
	jmp	.L419
.L474:
	nop
.L431:
	jmp	.L440
.L473:
	nop
.L429:
	cmp	DWORD PTR -24[rbp], 2
	jne	.L475
	nop
.L433:
	cmp	DWORD PTR -28[rbp], 2047
	ja	.L476
	mov	eax, DWORD PTR -4[rbp]
	mov	DWORD PTR -48[rbp], eax
	jmp	.L419
.L476:
	nop
.L436:
	jmp	.L440
.L475:
	nop
.L434:
	cmp	DWORD PTR -24[rbp], 3
	jne	.L477
	nop
.L437:
	cmp	DWORD PTR -28[rbp], 65535
	ja	.L478
	mov	eax, DWORD PTR -4[rbp]
	mov	DWORD PTR -48[rbp], eax
	jmp	.L419
.L432:
.L439:
.L477:
	nop
	jmp	.L440
.L478:
	nop
.L440:
	cmp	DWORD PTR -28[rbp], 55295
	jbe	.L479
	cmp	DWORD PTR -28[rbp], 57343
	setbe	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -16[rbp], rax
	jmp	.L443
.L479:
	nop
.L442:
	mov	QWORD PTR -16[rbp], 0
.L443:
	cmp	QWORD PTR -16[rbp], 0
	setne	al
	mov	BYTE PTR -41[rbp], al
	cmp	DWORD PTR -28[rbp], 1114111
	seta	al
	mov	BYTE PTR -42[rbp], al
	cmp	BYTE PTR -41[rbp], 0
	jne	.L480
	cmp	BYTE PTR -42[rbp], 0
	setne	al
	mov	BYTE PTR -17[rbp], al
	jmp	.L446
.L480:
	nop
.L445:
	mov	BYTE PTR -17[rbp], 1
.L446:
	cmp	BYTE PTR -17[rbp], 0
	je	.L481
	mov	eax, DWORD PTR -4[rbp]
	mov	DWORD PTR -48[rbp], eax
	jmp	.L419
.L481:
	nop
.L448:
	mov	edx, DWORD PTR -4[rbp]
	mov	eax, DWORD PTR -24[rbp]
	add	eax, edx
	add	eax, 1
	mov	DWORD PTR -4[rbp], eax
	jmp	.L406
.L465:
	nop
.L408:
	mov	DWORD PTR -48[rbp], -1
	nop
.L419:
	mov	eax, DWORD PTR -48[rbp]
	add	rsp, 48
	pop	rbp
	ret
	.seh_endproc
	.globl	_ZN3TKO4TEXT11ISVALIDUTF8EPKhi
	.def	_ZN3TKO4TEXT11ISVALIDUTF8EPKhi;	.scl	2;	.type	32;	.endef
	.seh_proc	_ZN3TKO4TEXT11ISVALIDUTF8EPKhi
_ZN3TKO4TEXT11ISVALIDUTF8EPKhi:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 48
	.seh_stackalloc	48
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
	mov	BYTE PTR -5[rbp], 0
.L483:
	mov	eax, DWORD PTR 24[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN3TKO4TEXT16FIRSTINVALIDUTF8EPKhi
	mov	DWORD PTR -4[rbp], eax
	mov	eax, DWORD PTR -4[rbp]
	shr	eax, 31
	mov	BYTE PTR -5[rbp], al
	nop
.L484:
	movzx	eax, BYTE PTR -5[rbp]
	add	rsp, 48
	pop	rbp
	ret
	.seh_endproc
	.globl	_ZN3TKO4TEXT10UTF8SEQLENEPKhii
	.def	_ZN3TKO4TEXT10UTF8SEQLENEPKhii;	.scl	2;	.type	32;	.endef
	.seh_proc	_ZN3TKO4TEXT10UTF8SEQLENEPKhii
_ZN3TKO4TEXT10UTF8SEQLENEPKhii:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 16
	.seh_stackalloc	16
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
	mov	DWORD PTR 32[rbp], r8d
	mov	DWORD PTR -12[rbp], 0
.L487:
	mov	eax, DWORD PTR 32[rbp]
	cmp	eax, DWORD PTR 24[rbp]
	jl	.L504
	mov	DWORD PTR -12[rbp], 0
	jmp	.L490
.L504:
	nop
.L489:
	mov	eax, DWORD PTR 32[rbp]
	movsx	rdx, eax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, rdx
	movzx	eax, BYTE PTR [rax]
	mov	BYTE PTR -5[rbp], al
	mov	DWORD PTR -4[rbp], 1
	cmp	BYTE PTR -5[rbp], -17
	jbe	.L505
	mov	DWORD PTR -4[rbp], 4
	jmp	.L497
.L505:
	nop
.L492:
	cmp	BYTE PTR -5[rbp], -33
	jbe	.L506
	mov	DWORD PTR -4[rbp], 3
	jmp	.L497
.L506:
	nop
.L495:
	cmp	BYTE PTR -5[rbp], -65
	jbe	.L507
	mov	DWORD PTR -4[rbp], 2
	jmp	.L497
.L493:
.L507:
	nop
.L497:
	mov	eax, DWORD PTR 32[rbp]
	movsx	rdx, eax
	mov	eax, DWORD PTR -4[rbp]
	cdqe
	add	rdx, rax
	mov	eax, DWORD PTR 24[rbp]
	cdqe
	cmp	rdx, rax
	jle	.L508
	mov	eax, DWORD PTR 24[rbp]
	sub	eax, DWORD PTR 32[rbp]
	mov	DWORD PTR -4[rbp], eax
	jmp	.L499
.L508:
	nop
.L499:
	mov	eax, DWORD PTR -4[rbp]
	mov	DWORD PTR -12[rbp], eax
	nop
.L490:
	mov	eax, DWORD PTR -12[rbp]
	add	rsp, 16
	pop	rbp
	ret
	.seh_endproc
	.globl	_ZN3TKO4TEXT10DECODEUTF8EPKhiRi
	.def	_ZN3TKO4TEXT10DECODEUTF8EPKhiRi;	.scl	2;	.type	32;	.endef
	.seh_proc	_ZN3TKO4TEXT10DECODEUTF8EPKhiRi
_ZN3TKO4TEXT10DECODEUTF8EPKhiRi:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 48
	.seh_stackalloc	48
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
	mov	QWORD PTR 32[rbp], r8
	mov	DWORD PTR -44[rbp], 0
.L510:
	mov	rax, QWORD PTR 32[rbp]
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR 24[rbp], eax
	jg	.L554
	mov	DWORD PTR -44[rbp], 0
	jmp	.L513
.L554:
	nop
.L512:
	mov	rax, QWORD PTR 32[rbp]
	mov	eax, DWORD PTR [rax]
	movsx	rdx, eax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, rdx
	movzx	eax, BYTE PTR [rax]
	mov	BYTE PTR -29[rbp], al
	movzx	eax, BYTE PTR -29[rbp]
	test	al, al
	js	.L555
	mov	rax, QWORD PTR 32[rbp]
	mov	eax, DWORD PTR [rax]
	lea	edx, 1[rax]
	mov	rax, QWORD PTR 32[rbp]
	mov	DWORD PTR [rax], edx
	movzx	eax, BYTE PTR -29[rbp]
	mov	DWORD PTR -44[rbp], eax
	jmp	.L513
.L515:
.L555:
	nop
.L516:
	mov	DWORD PTR -20[rbp], 0
	mov	DWORD PTR -24[rbp], 0
	movzx	eax, BYTE PTR -29[rbp]
	and	eax, 224
	cmp	rax, 192
	jne	.L556
	mov	DWORD PTR -20[rbp], 1
	movzx	eax, BYTE PTR -29[rbp]
	and	eax, 31
	mov	DWORD PTR -24[rbp], eax
	jmp	.L519
.L556:
	nop
.L518:
	movzx	eax, BYTE PTR -29[rbp]
	and	eax, 240
	cmp	rax, 224
	jne	.L557
	mov	DWORD PTR -20[rbp], 2
	movzx	eax, BYTE PTR -29[rbp]
	and	eax, 15
	mov	DWORD PTR -24[rbp], eax
	jmp	.L519
.L557:
	nop
.L521:
	movzx	eax, BYTE PTR -29[rbp]
	and	eax, 248
	cmp	rax, 240
	jne	.L558
	mov	DWORD PTR -20[rbp], 3
	movzx	eax, BYTE PTR -29[rbp]
	and	eax, 7
	mov	DWORD PTR -24[rbp], eax
	jmp	.L519
.L558:
	nop
.L523:
	mov	rax, QWORD PTR 32[rbp]
	mov	eax, DWORD PTR [rax]
	lea	edx, 1[rax]
	mov	rax, QWORD PTR 32[rbp]
	mov	DWORD PTR [rax], edx
	mov	DWORD PTR -44[rbp], 65533
	jmp	.L513
.L519:
	mov	rax, QWORD PTR 32[rbp]
	mov	eax, DWORD PTR [rax]
	movsx	rdx, eax
	mov	eax, DWORD PTR -20[rbp]
	cdqe
	add	rdx, rax
	mov	eax, DWORD PTR 24[rbp]
	cdqe
	cmp	rdx, rax
	jl	.L559
	mov	rax, QWORD PTR 32[rbp]
	mov	eax, DWORD PTR [rax]
	lea	edx, 1[rax]
	mov	rax, QWORD PTR 32[rbp]
	mov	DWORD PTR [rax], edx
	mov	DWORD PTR -44[rbp], 65533
	jmp	.L513
.L525:
.L559:
	nop
.L526:
	mov	DWORD PTR -28[rbp], 1
	mov	eax, DWORD PTR -20[rbp]
	mov	DWORD PTR -36[rbp], eax
	jmp	.L527
.L561:
	nop
.L528:
	mov	rax, QWORD PTR 32[rbp]
	mov	eax, DWORD PTR [rax]
	movsx	rdx, eax
	mov	eax, DWORD PTR -28[rbp]
	cdqe
	add	rax, rdx
	mov	rdx, rax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, rdx
	movzx	eax, BYTE PTR [rax]
	mov	BYTE PTR -38[rbp], al
	movzx	eax, BYTE PTR -38[rbp]
	and	eax, 192
	cmp	rax, 128
	je	.L560
	mov	rax, QWORD PTR 32[rbp]
	mov	eax, DWORD PTR [rax]
	lea	edx, 1[rax]
	mov	rax, QWORD PTR 32[rbp]
	mov	DWORD PTR [rax], edx
	mov	DWORD PTR -44[rbp], 65533
	jmp	.L513
.L530:
.L560:
	nop
.L531:
	mov	eax, DWORD PTR -24[rbp]
	sal	rax, 6
	mov	edx, eax
	movzx	eax, BYTE PTR -38[rbp]
	and	eax, 63
	or	eax, edx
	mov	DWORD PTR -24[rbp], eax
.L532:
	add	DWORD PTR -28[rbp], 1
.L527:
	mov	eax, DWORD PTR -28[rbp]
	cmp	eax, DWORD PTR -36[rbp]
	jle	.L561
	nop
.L533:
	mov	rax, QWORD PTR 32[rbp]
	mov	edx, DWORD PTR [rax]
	mov	eax, DWORD PTR -20[rbp]
	add	eax, edx
	lea	edx, 1[rax]
	mov	rax, QWORD PTR 32[rbp]
	mov	DWORD PTR [rax], edx
	cmp	DWORD PTR -24[rbp], 55295
	jbe	.L562
	cmp	DWORD PTR -24[rbp], 57343
	setbe	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -8[rbp], rax
	jmp	.L536
.L562:
	nop
.L535:
	mov	QWORD PTR -8[rbp], 0
.L536:
	cmp	QWORD PTR -8[rbp], 0
	setne	al
	mov	BYTE PTR -37[rbp], al
	movsx	eax, BYTE PTR -37[rbp]
	neg	eax
	test	eax, eax
	jne	.L563
	cmp	DWORD PTR -24[rbp], 1114111
	seta	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -16[rbp], rax
	jmp	.L539
.L563:
	nop
.L538:
	mov	QWORD PTR -16[rbp], -1
.L539:
	cmp	QWORD PTR -16[rbp], 0
	je	.L564
	mov	DWORD PTR -44[rbp], 65533
	jmp	.L513
.L564:
	nop
.L541:
	mov	eax, DWORD PTR -24[rbp]
	mov	DWORD PTR -44[rbp], eax
	nop
.L513:
	mov	eax, DWORD PTR -44[rbp]
	add	rsp, 48
	pop	rbp
	ret
	.seh_endproc
	.globl	_ZN3TKO4TEXT10APPENDUTF8ER5ArrayIhEj
	.def	_ZN3TKO4TEXT10APPENDUTF8ER5ArrayIhEj;	.scl	2;	.type	32;	.endef
	.seh_proc	_ZN3TKO4TEXT10APPENDUTF8ER5ArrayIhEj
_ZN3TKO4TEXT10APPENDUTF8ER5ArrayIhEj:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 64
	.seh_stackalloc	64
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
.L566:
	cmp	DWORD PTR 24[rbp], 55295
	jbe	.L588
	cmp	DWORD PTR 24[rbp], 57343
	setbe	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -8[rbp], rax
	jmp	.L569
.L588:
	nop
.L568:
	mov	QWORD PTR -8[rbp], 0
.L569:
	cmp	QWORD PTR -8[rbp], 0
	setne	al
	mov	BYTE PTR -17[rbp], al
	movsx	eax, BYTE PTR -17[rbp]
	neg	eax
	test	eax, eax
	jne	.L589
	cmp	DWORD PTR 24[rbp], 1114111
	seta	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -16[rbp], rax
	jmp	.L572
.L589:
	nop
.L571:
	mov	QWORD PTR -16[rbp], -1
.L572:
	cmp	QWORD PTR -16[rbp], 0
	setne	al
	mov	BYTE PTR -18[rbp], al
	cmp	BYTE PTR -18[rbp], 0
	je	.L590
	mov	DWORD PTR 24[rbp], 65533
	jmp	.L574
.L590:
	nop
.L574:
	cmp	DWORD PTR 24[rbp], 127
	ja	.L591
	mov	eax, DWORD PTR 24[rbp]
	mov	BYTE PTR -19[rbp], al
	lea	rax, -19[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIhE4PUSHERh
	jmp	.L582
.L591:
	nop
.L576:
	cmp	DWORD PTR 24[rbp], 2047
	ja	.L592
	mov	eax, DWORD PTR 24[rbp]
	shr	eax, 6
	or	eax, -64
	mov	BYTE PTR -20[rbp], al
	lea	rax, -20[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIhE4PUSHERh
	mov	eax, DWORD PTR 24[rbp]
	and	eax, 63
	or	eax, -128
	mov	BYTE PTR -21[rbp], al
	lea	rax, -21[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIhE4PUSHERh
	jmp	.L582
.L592:
	nop
.L579:
	cmp	DWORD PTR 24[rbp], 65535
	ja	.L593
	mov	eax, DWORD PTR 24[rbp]
	shr	eax, 12
	or	eax, -32
	mov	BYTE PTR -22[rbp], al
	lea	rax, -22[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIhE4PUSHERh
	mov	eax, DWORD PTR 24[rbp]
	shr	eax, 6
	and	eax, 63
	or	eax, -128
	mov	BYTE PTR -23[rbp], al
	lea	rax, -23[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIhE4PUSHERh
	mov	eax, DWORD PTR 24[rbp]
	and	eax, 63
	or	eax, -128
	mov	BYTE PTR -24[rbp], al
	lea	rax, -24[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIhE4PUSHERh
	jmp	.L582
.L593:
	nop
.L581:
	mov	eax, DWORD PTR 24[rbp]
	shr	eax, 18
	or	eax, -16
	mov	BYTE PTR -25[rbp], al
	lea	rax, -25[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIhE4PUSHERh
	mov	eax, DWORD PTR 24[rbp]
	shr	eax, 12
	and	eax, 63
	or	eax, -128
	mov	BYTE PTR -26[rbp], al
	lea	rax, -26[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIhE4PUSHERh
	mov	eax, DWORD PTR 24[rbp]
	shr	eax, 6
	and	eax, 63
	or	eax, -128
	mov	BYTE PTR -27[rbp], al
	lea	rax, -27[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIhE4PUSHERh
	mov	eax, DWORD PTR 24[rbp]
	and	eax, 63
	or	eax, -128
	mov	BYTE PTR -28[rbp], al
	lea	rax, -28[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIhE4PUSHERh
.L577:
	nop
.L582:
	nop
	add	rsp, 64
	pop	rbp
	ret
	.seh_endproc
	.globl	_ZN3TKO4TEXT15NORMALIZETOUTF8ER5ArrayIhES3_NS0_8ENCODINGE
	.def	_ZN3TKO4TEXT15NORMALIZETOUTF8ER5ArrayIhES3_NS0_8ENCODINGE;	.scl	2;	.type	32;	.endef
	.seh_proc	_ZN3TKO4TEXT15NORMALIZETOUTF8ER5ArrayIhES3_NS0_8ENCODINGE
_ZN3TKO4TEXT15NORMALIZETOUTF8ER5ArrayIhES3_NS0_8ENCODINGE:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
	mov	QWORD PTR 32[rbp], r8
.L595:
	mov	rax, QWORD PTR 24[rbp]
	mov	rcx, rax
	call	_ZN5ArrayIhE5CLEAREv
	cmp	QWORD PTR 32[rbp], 2
	jne	.L614
	nop
.L596:
	mov	rax, QWORD PTR 24[rbp]
	mov	r8d, 0
	mov	rdx, rax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN3TKO4TEXT11UTF16TOUTF8ER5ArrayIhES3_b
	jmp	.L608
.L614:
	nop
.L597:
	cmp	QWORD PTR 32[rbp], 3
	jne	.L615
	nop
.L599:
	mov	rax, QWORD PTR 24[rbp]
	mov	r8d, 1
	mov	rdx, rax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN3TKO4TEXT11UTF16TOUTF8ER5ArrayIhES3_b
	jmp	.L608
.L615:
	nop
.L600:
	cmp	QWORD PTR 32[rbp], 4
	jne	.L616
	nop
.L601:
	mov	rax, QWORD PTR 24[rbp]
	mov	r8d, 0
	mov	rdx, rax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN3TKO4TEXT11UTF32TOUTF8ER5ArrayIhES3_b
	jmp	.L608
.L616:
	nop
.L602:
	cmp	QWORD PTR 32[rbp], 5
	jne	.L617
	nop
.L603:
	mov	rax, QWORD PTR 24[rbp]
	mov	r8d, 1
	mov	rdx, rax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN3TKO4TEXT11UTF32TOUTF8ER5ArrayIhES3_b
	jmp	.L608
.L617:
	nop
.L604:
	cmp	QWORD PTR 32[rbp], 1
	jne	.L618
	nop
.L605:
	mov	rax, QWORD PTR 24[rbp]
	mov	r8d, 3
	mov	rdx, rax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN3TKO4TEXT8COPYFROMER5ArrayIhES3_i
	jmp	.L608
.L618:
	nop
.L606:
	mov	rax, QWORD PTR 24[rbp]
	mov	r8d, 0
	mov	rdx, rax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN3TKO4TEXT8COPYFROMER5ArrayIhES3_i
.L598:
.L607:
	nop
.L608:
	nop
	add	rsp, 32
	pop	rbp
	ret
	.seh_endproc
	.globl	_ZN3TKO4TEXT12DISPLAYWIDTHEj
	.def	_ZN3TKO4TEXT12DISPLAYWIDTHEj;	.scl	2;	.type	32;	.endef
	.seh_proc	_ZN3TKO4TEXT12DISPLAYWIDTHEj
_ZN3TKO4TEXT12DISPLAYWIDTHEj:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 176
	.seh_stackalloc	176
	.seh_endprologue
	mov	DWORD PTR 16[rbp], ecx
	mov	DWORD PTR -172[rbp], 0
.L620:
	cmp	DWORD PTR 16[rbp], 0
	jne	.L720
	mov	DWORD PTR -172[rbp], 0
	jmp	.L623
.L720:
	nop
.L622:
	cmp	DWORD PTR 16[rbp], 767
	jbe	.L721
	cmp	DWORD PTR 16[rbp], 879
	setbe	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -8[rbp], rax
	jmp	.L626
.L721:
	nop
.L625:
	mov	QWORD PTR -8[rbp], 0
.L626:
	cmp	QWORD PTR -8[rbp], 0
	jne	.L722
	cmp	DWORD PTR 16[rbp], 8202
	jbe	.L723
	cmp	DWORD PTR 16[rbp], 8207
	setbe	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -16[rbp], rax
	jmp	.L631
.L723:
	nop
.L630:
	mov	QWORD PTR -16[rbp], 0
.L631:
	cmp	QWORD PTR -16[rbp], 0
	setne	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -24[rbp], rax
	jmp	.L632
.L722:
	nop
.L628:
	mov	QWORD PTR -24[rbp], -1
.L632:
	cmp	QWORD PTR -24[rbp], 0
	setne	al
	mov	BYTE PTR -163[rbp], al
	cmp	BYTE PTR -163[rbp], 0
	je	.L724
	mov	DWORD PTR -172[rbp], 0
	jmp	.L623
.L724:
	nop
.L634:
	cmp	DWORD PTR 16[rbp], 4351
	jbe	.L725
	cmp	DWORD PTR 16[rbp], 4447
	setbe	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -32[rbp], rax
	jmp	.L637
.L725:
	nop
.L636:
	mov	QWORD PTR -32[rbp], 0
.L637:
	cmp	QWORD PTR -32[rbp], 0
	jne	.L726
	cmp	DWORD PTR 16[rbp], 11903
	jbe	.L727
	cmp	DWORD PTR 16[rbp], 42191
	setbe	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -40[rbp], rax
	jmp	.L642
.L727:
	nop
.L641:
	mov	QWORD PTR -40[rbp], 0
.L642:
	cmp	QWORD PTR -40[rbp], 0
	setne	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -48[rbp], rax
	jmp	.L643
.L726:
	nop
.L639:
	mov	QWORD PTR -48[rbp], -1
.L643:
	cmp	QWORD PTR -48[rbp], 0
	jne	.L728
	cmp	DWORD PTR 16[rbp], 44031
	jbe	.L729
	cmp	DWORD PTR 16[rbp], 55203
	setbe	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -56[rbp], rax
	jmp	.L648
.L729:
	nop
.L647:
	mov	QWORD PTR -56[rbp], 0
.L648:
	cmp	QWORD PTR -56[rbp], 0
	setne	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -64[rbp], rax
	jmp	.L649
.L728:
	nop
.L645:
	mov	QWORD PTR -64[rbp], -1
.L649:
	cmp	QWORD PTR -64[rbp], 0
	setne	al
	mov	BYTE PTR -164[rbp], al
	cmp	DWORD PTR 16[rbp], 63743
	jbe	.L730
	cmp	DWORD PTR 16[rbp], 64255
	setbe	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -72[rbp], rax
	jmp	.L652
.L730:
	nop
.L651:
	mov	QWORD PTR -72[rbp], 0
.L652:
	cmp	QWORD PTR -72[rbp], 0
	jne	.L731
	cmp	DWORD PTR 16[rbp], 65071
	jbe	.L732
	cmp	DWORD PTR 16[rbp], 65135
	setbe	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -80[rbp], rax
	jmp	.L657
.L732:
	nop
.L656:
	mov	QWORD PTR -80[rbp], 0
.L657:
	cmp	QWORD PTR -80[rbp], 0
	setne	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -88[rbp], rax
	jmp	.L658
.L731:
	nop
.L654:
	mov	QWORD PTR -88[rbp], -1
.L658:
	cmp	QWORD PTR -88[rbp], 0
	jne	.L733
	cmp	DWORD PTR 16[rbp], 65279
	jbe	.L734
	cmp	DWORD PTR 16[rbp], 65376
	setbe	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -96[rbp], rax
	jmp	.L663
.L734:
	nop
.L662:
	mov	QWORD PTR -96[rbp], 0
.L663:
	cmp	QWORD PTR -96[rbp], 0
	setne	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -104[rbp], rax
	jmp	.L664
.L733:
	nop
.L660:
	mov	QWORD PTR -104[rbp], -1
.L664:
	cmp	QWORD PTR -104[rbp], 0
	jne	.L735
	cmp	DWORD PTR 16[rbp], 65503
	jbe	.L736
	cmp	DWORD PTR 16[rbp], 65510
	setbe	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -112[rbp], rax
	jmp	.L669
.L736:
	nop
.L668:
	mov	QWORD PTR -112[rbp], 0
.L669:
	cmp	QWORD PTR -112[rbp], 0
	setne	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -120[rbp], rax
	jmp	.L670
.L735:
	nop
.L666:
	mov	QWORD PTR -120[rbp], -1
.L670:
	cmp	QWORD PTR -120[rbp], 0
	setne	al
	mov	BYTE PTR -165[rbp], al
	cmp	DWORD PTR 16[rbp], 127743
	jbe	.L737
	cmp	DWORD PTR 16[rbp], 128591
	setbe	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -128[rbp], rax
	jmp	.L673
.L737:
	nop
.L672:
	mov	QWORD PTR -128[rbp], 0
.L673:
	cmp	QWORD PTR -128[rbp], 0
	jne	.L738
	cmp	DWORD PTR 16[rbp], 129279
	jbe	.L739
	cmp	DWORD PTR 16[rbp], 129535
	setbe	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -136[rbp], rax
	jmp	.L678
.L739:
	nop
.L677:
	mov	QWORD PTR -136[rbp], 0
.L678:
	cmp	QWORD PTR -136[rbp], 0
	setne	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -144[rbp], rax
	jmp	.L679
.L738:
	nop
.L675:
	mov	QWORD PTR -144[rbp], -1
.L679:
	cmp	QWORD PTR -144[rbp], 0
	jne	.L740
	cmp	DWORD PTR 16[rbp], 131071
	jbe	.L741
	cmp	DWORD PTR 16[rbp], 262141
	setbe	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -152[rbp], rax
	jmp	.L684
.L741:
	nop
.L683:
	mov	QWORD PTR -152[rbp], 0
.L684:
	cmp	QWORD PTR -152[rbp], 0
	setne	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -160[rbp], rax
	jmp	.L685
.L740:
	nop
.L681:
	mov	QWORD PTR -160[rbp], -1
.L685:
	cmp	QWORD PTR -160[rbp], 0
	setne	al
	mov	BYTE PTR -166[rbp], al
	cmp	BYTE PTR -164[rbp], 0
	jne	.L742
	cmp	BYTE PTR -165[rbp], 0
	setne	al
	mov	BYTE PTR -161[rbp], al
	jmp	.L688
.L742:
	nop
.L687:
	mov	BYTE PTR -161[rbp], 1
.L688:
	cmp	BYTE PTR -161[rbp], 0
	jne	.L743
	cmp	BYTE PTR -166[rbp], 0
	setne	al
	mov	BYTE PTR -162[rbp], al
	jmp	.L691
.L743:
	nop
.L690:
	mov	BYTE PTR -162[rbp], 1
.L691:
	movzx	eax, BYTE PTR -162[rbp]
	mov	BYTE PTR -167[rbp], al
	cmp	BYTE PTR -167[rbp], 0
	je	.L744
	mov	DWORD PTR -172[rbp], 2
	jmp	.L623
.L744:
	nop
.L693:
	mov	DWORD PTR -172[rbp], 1
	nop
.L623:
	mov	eax, DWORD PTR -172[rbp]
	add	rsp, 176
	pop	rbp
	ret
	.seh_endproc
	.globl	_ZN3TKO4TEXT8COLUMNOFEPKhiii
	.def	_ZN3TKO4TEXT8COLUMNOFEPKhiii;	.scl	2;	.type	32;	.endef
	.seh_proc	_ZN3TKO4TEXT8COLUMNOFEPKhiii
_ZN3TKO4TEXT8COLUMNOFEPKhiii:
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
	mov	DWORD PTR 40[rbp], r9d
	mov	DWORD PTR -20[rbp], 0
.L746:
	mov	DWORD PTR -4[rbp], 0
	mov	eax, DWORD PTR 24[rbp]
	mov	DWORD PTR -24[rbp], eax
.L747:
	mov	eax, DWORD PTR -24[rbp]
	cmp	DWORD PTR 32[rbp], eax
	jle	.L757
	mov	eax, DWORD PTR -24[rbp]
	movsx	rdx, eax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, rdx
	movzx	eax, BYTE PTR [rax]
	cmp	al, 9
	jne	.L758
	mov	eax, DWORD PTR -4[rbp]
	cdq
	idiv	DWORD PTR 40[rbp]
	lea	edx, 1[rax]
	mov	eax, DWORD PTR 40[rbp]
	imul	eax, edx
	mov	DWORD PTR -4[rbp], eax
	mov	eax, DWORD PTR -24[rbp]
	add	eax, 1
	mov	DWORD PTR -24[rbp], eax
	jmp	.L752
.L758:
	nop
.L751:
	lea	rdx, -24[rbp]
	mov	eax, DWORD PTR 32[rbp]
	mov	r8, rdx
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN3TKO4TEXT10DECODEUTF8EPKhiRi
	mov	DWORD PTR -8[rbp], eax
	mov	eax, DWORD PTR -8[rbp]
	mov	DWORD PTR -12[rbp], eax
	mov	eax, DWORD PTR -12[rbp]
	mov	ecx, eax
	call	_ZN3TKO4TEXT12DISPLAYWIDTHEj
	mov	DWORD PTR -16[rbp], eax
	mov	eax, DWORD PTR -16[rbp]
	add	DWORD PTR -4[rbp], eax
.L752:
	jmp	.L747
.L757:
	nop
.L749:
	mov	eax, DWORD PTR -4[rbp]
	add	eax, 1
	mov	DWORD PTR -20[rbp], eax
	nop
.L753:
	mov	eax, DWORD PTR -20[rbp]
	add	rsp, 64
	pop	rbp
	ret
	.seh_endproc
	.globl	_ZN3TKO4TEXT14LOWERASCIIINTOEPKhiPh
	.def	_ZN3TKO4TEXT14LOWERASCIIINTOEPKhiPh;	.scl	2;	.type	32;	.endef
	.seh_proc	_ZN3TKO4TEXT14LOWERASCIIINTOEPKhiPh
_ZN3TKO4TEXT14LOWERASCIIINTOEPKhiPh:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
	mov	QWORD PTR 32[rbp], r8
.L760:
	cmp	DWORD PTR 24[rbp], 0
	jle	.L777
	nop
.L762:
	mov	DWORD PTR -4[rbp], 0
	mov	eax, DWORD PTR 24[rbp]
	sub	eax, 1
	mov	DWORD PTR -20[rbp], eax
	jmp	.L764
.L780:
	nop
.L765:
	mov	eax, DWORD PTR -4[rbp]
	movsx	rdx, eax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, rdx
	movzx	eax, BYTE PTR [rax]
	mov	BYTE PTR -21[rbp], al
	cmp	BYTE PTR -21[rbp], 64
	jbe	.L778
	cmp	BYTE PTR -21[rbp], 90
	setbe	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -16[rbp], rax
	jmp	.L768
.L778:
	nop
.L767:
	mov	QWORD PTR -16[rbp], 0
.L768:
	cmp	QWORD PTR -16[rbp], 0
	setne	al
	mov	BYTE PTR -22[rbp], al
	cmp	BYTE PTR -22[rbp], 0
	je	.L779
	movzx	eax, BYTE PTR -21[rbp]
	lea	ecx, 32[rax]
	mov	eax, DWORD PTR -4[rbp]
	movsx	rdx, eax
	mov	rax, QWORD PTR 32[rbp]
	add	rax, rdx
	mov	edx, ecx
	mov	BYTE PTR [rax], dl
	jmp	.L772
.L779:
	nop
.L770:
	mov	eax, DWORD PTR -4[rbp]
	movsx	rdx, eax
	mov	rax, QWORD PTR 32[rbp]
	add	rdx, rax
	movzx	eax, BYTE PTR -21[rbp]
	mov	BYTE PTR [rdx], al
.L771:
.L772:
	add	DWORD PTR -4[rbp], 1
.L764:
	mov	eax, DWORD PTR -4[rbp]
	cmp	eax, DWORD PTR -20[rbp]
	jle	.L780
	jmp	.L773
.L763:
.L777:
	nop
.L773:
	nop
	add	rsp, 32
	pop	rbp
	ret
	.seh_endproc
	.globl	_ZN3TKO4TEXT10LOWERASCIIE8FBSTRING
	.def	_ZN3TKO4TEXT10LOWERASCIIE8FBSTRING;	.scl	2;	.type	32;	.endef
	.seh_proc	_ZN3TKO4TEXT10LOWERASCIIE8FBSTRING
_ZN3TKO4TEXT10LOWERASCIIE8FBSTRING:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	add	rsp, -128
	.seh_stackalloc	128
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	lea	rax, -48[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
.L782:
	lea	rax, -80[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, QWORD PTR 16[rbp]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrInit
	lea	rax, -80[rbp]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrLen
	mov	QWORD PTR -8[rbp], rax
	cmp	QWORD PTR -8[rbp], 0
	jne	.L788
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
	jmp	.L785
.L788:
	nop
.L784:
	lea	rax, -80[rbp]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrLen
	mov	QWORD PTR -16[rbp], rax
	lea	rax, -80[rbp]
	mov	rdx, QWORD PTR [rax]
	mov	rax, QWORD PTR -16[rbp]
	mov	ecx, eax
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	r8, rdx
	mov	edx, ecx
	mov	rcx, rax
	call	_ZN3TKO4TEXT14LOWERASCIIINTOEPKhiPh
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
	nop
.L785:
	lea	rax, -48[rbp]
	mov	rcx, rax
	call	fb_StrAllocTempResult
	mov	QWORD PTR -24[rbp], rax
	mov	rax, QWORD PTR -24[rbp]
	sub	rsp, -128
	pop	rbp
	ret
	.seh_endproc
	.globl	_ZN3TKO4TEXT10UPPERASCIIE8FBSTRING
	.def	_ZN3TKO4TEXT10UPPERASCIIE8FBSTRING;	.scl	2;	.type	32;	.endef
	.seh_proc	_ZN3TKO4TEXT10UPPERASCIIE8FBSTRING
_ZN3TKO4TEXT10UPPERASCIIE8FBSTRING:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 160
	.seh_stackalloc	160
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	lea	rax, -80[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
.L790:
	lea	rax, -112[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, QWORD PTR 16[rbp]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrInit
	lea	rax, -112[rbp]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrLen
	mov	QWORD PTR -24[rbp], rax
	cmp	QWORD PTR -24[rbp], 0
	jne	.L807
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
	jmp	.L793
.L807:
	nop
.L792:
	lea	rax, -112[rbp]
	mov	rax, QWORD PTR [rax]
	mov	QWORD PTR -32[rbp], rax
	mov	DWORD PTR -4[rbp], 0
	lea	rax, -112[rbp]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrLen
	mov	QWORD PTR -40[rbp], rax
	mov	rax, QWORD PTR -40[rbp]
	sub	eax, 1
	mov	DWORD PTR -44[rbp], eax
	jmp	.L794
.L810:
	nop
.L795:
	mov	eax, DWORD PTR -4[rbp]
	movsx	rdx, eax
	mov	rax, QWORD PTR -32[rbp]
	add	rax, rdx
	movzx	eax, BYTE PTR [rax]
	cmp	al, 96
	jbe	.L808
	mov	eax, DWORD PTR -4[rbp]
	movsx	rdx, eax
	mov	rax, QWORD PTR -32[rbp]
	add	rax, rdx
	movzx	eax, BYTE PTR [rax]
	cmp	al, 122
	setbe	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -16[rbp], rax
	jmp	.L798
.L808:
	nop
.L797:
	mov	QWORD PTR -16[rbp], 0
.L798:
	cmp	QWORD PTR -16[rbp], 0
	je	.L809
	mov	eax, DWORD PTR -4[rbp]
	movsx	rdx, eax
	mov	rax, QWORD PTR -32[rbp]
	add	rax, rdx
	movzx	eax, BYTE PTR [rax]
	lea	ecx, -32[rax]
	mov	eax, DWORD PTR -4[rbp]
	movsx	rdx, eax
	mov	rax, QWORD PTR -32[rbp]
	add	rax, rdx
	mov	edx, ecx
	mov	BYTE PTR [rax], dl
	jmp	.L801
.L800:
.L809:
	nop
.L801:
	add	DWORD PTR -4[rbp], 1
.L794:
	mov	eax, DWORD PTR -4[rbp]
	cmp	eax, DWORD PTR -44[rbp]
	jle	.L810
	nop
.L802:
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
.L793:
	lea	rax, -80[rbp]
	mov	rcx, rax
	call	fb_StrAllocTempResult
	mov	QWORD PTR -56[rbp], rax
	mov	rax, QWORD PTR -56[rbp]
	add	rsp, 160
	pop	rbp
	ret
	.seh_endproc
	.globl	_ZN3TKO4TEXT13UTF8TOUSTRINGEPKhi
	.def	_ZN3TKO4TEXT13UTF8TOUSTRINGEPKhi;	.scl	2;	.type	32;	.endef
	.seh_proc	_ZN3TKO4TEXT13UTF8TOUSTRINGEPKhi
_ZN3TKO4TEXT13UTF8TOUSTRINGEPKhi:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 144
	.seh_stackalloc	144
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
	lea	rax, -48[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
.L812:
	cmp	DWORD PTR 24[rbp], 0
	jg	.L818
	mov	WORD PTR -82[rbp], 0
	lea	rdx, -82[rbp]
	lea	rax, -48[rbp]
	mov	DWORD PTR 32[rsp], 0
	movabs	r9, -9223372036854775808
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrInit
	jmp	.L815
.L818:
	nop
.L814:
	mov	eax, DWORD PTR 24[rbp]
	cdqe
	mov	rcx, rax
	call	fb_SPACE
	mov	QWORD PTR -8[rbp], rax
	mov	rdx, QWORD PTR -8[rbp]
	lea	rax, -80[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrInit
	mov	eax, DWORD PTR 24[rbp]
	movsx	rdx, eax
	lea	rax, -80[rbp]
	mov	rax, QWORD PTR [rax]
	mov	r8, rdx
	mov	rdx, QWORD PTR 16[rbp]
	mov	rcx, rax
	call	memcpy
	lea	rdx, -80[rbp]
	lea	rax, -48[rbp]
	mov	DWORD PTR 40[rsp], -1
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrAssignFromA
	lea	rax, -80[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	nop
.L815:
	lea	rax, -48[rbp]
	mov	rcx, rax
	call	fb_UStrAllocTempResult
	mov	QWORD PTR -16[rbp], rax
	mov	rax, QWORD PTR -16[rbp]
	add	rsp, 144
	pop	rbp
	ret
	.seh_endproc
	.globl	_ZN3TKO4TEXT13USTRINGTOUTF8E9FBUSTRING
	.def	_ZN3TKO4TEXT13USTRINGTOUTF8E9FBUSTRING;	.scl	2;	.type	32;	.endef
	.seh_proc	_ZN3TKO4TEXT13USTRINGTOUTF8E9FBUSTRING
_ZN3TKO4TEXT13USTRINGTOUTF8E9FBUSTRING:
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
.L820:
	lea	rax, -32[rbp]
	mov	DWORD PTR 40[rsp], -1
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, QWORD PTR 16[rbp]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_UStrAssignToA
	nop
.L821:
	lea	rax, -32[rbp]
	mov	rcx, rax
	call	fb_StrAllocTempResult
	mov	QWORD PTR -8[rbp], rax
	mov	rax, QWORD PTR -8[rbp]
	add	rsp, 80
	pop	rbp
	ret
	.seh_endproc
	.globl	_ZN3TKO4TEXT12ESCAPEBYTEATER8FBSTRINGRi
	.def	_ZN3TKO4TEXT12ESCAPEBYTEATER8FBSTRINGRi;	.scl	2;	.type	32;	.endef
	.seh_proc	_ZN3TKO4TEXT12ESCAPEBYTEATER8FBSTRINGRi
_ZN3TKO4TEXT12ESCAPEBYTEATER8FBSTRINGRi:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 176
	.seh_stackalloc	176
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
	mov	DWORD PTR -136[rbp], 0
.L824:
	mov	rax, QWORD PTR 24[rbp]
	mov	eax, DWORD PTR [rax]
	lea	edx, 1[rax]
	mov	rax, QWORD PTR 24[rbp]
	mov	DWORD PTR [rax], edx
	mov	rdx, -1
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_StrLen
	mov	QWORD PTR -48[rbp], rax
	mov	rax, QWORD PTR 24[rbp]
	mov	eax, DWORD PTR [rax]
	cdqe
	cmp	QWORD PTR -48[rbp], rax
	jge	.L911
	mov	DWORD PTR -136[rbp], 92
	jmp	.L827
.L911:
	nop
.L826:
	mov	rax, QWORD PTR 24[rbp]
	mov	eax, DWORD PTR [rax]
	cdqe
	mov	r8d, 1
	mov	rdx, rax
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_StrMid
	mov	QWORD PTR -56[rbp], rax
	mov	rax, QWORD PTR -56[rbp]
	mov	edx, 1
	mov	rcx, rax
	call	fb_ASC
	mov	DWORD PTR -60[rbp], eax
	mov	eax, DWORD PTR -60[rbp]
	mov	DWORD PTR -64[rbp], eax
	cmp	DWORD PTR -64[rbp], 97
	jne	.L912
	nop
.L828:
	mov	rax, QWORD PTR 24[rbp]
	mov	eax, DWORD PTR [rax]
	lea	edx, 1[rax]
	mov	rax, QWORD PTR 24[rbp]
	mov	DWORD PTR [rax], edx
	mov	DWORD PTR -136[rbp], 7
	jmp	.L827
.L912:
	nop
.L829:
	cmp	DWORD PTR -64[rbp], 98
	jne	.L913
	nop
.L830:
	mov	rax, QWORD PTR 24[rbp]
	mov	eax, DWORD PTR [rax]
	lea	edx, 1[rax]
	mov	rax, QWORD PTR 24[rbp]
	mov	DWORD PTR [rax], edx
	mov	DWORD PTR -136[rbp], 8
	jmp	.L827
.L913:
	nop
.L831:
	cmp	DWORD PTR -64[rbp], 102
	jne	.L914
	nop
.L832:
	mov	rax, QWORD PTR 24[rbp]
	mov	eax, DWORD PTR [rax]
	lea	edx, 1[rax]
	mov	rax, QWORD PTR 24[rbp]
	mov	DWORD PTR [rax], edx
	mov	DWORD PTR -136[rbp], 12
	jmp	.L827
.L914:
	nop
.L833:
	cmp	DWORD PTR -64[rbp], 110
	jne	.L915
	nop
.L834:
	mov	rax, QWORD PTR 24[rbp]
	mov	eax, DWORD PTR [rax]
	lea	edx, 1[rax]
	mov	rax, QWORD PTR 24[rbp]
	mov	DWORD PTR [rax], edx
	mov	DWORD PTR -136[rbp], 10
	jmp	.L827
.L915:
	nop
.L835:
	cmp	DWORD PTR -64[rbp], 114
	jne	.L916
	nop
.L836:
	mov	rax, QWORD PTR 24[rbp]
	mov	eax, DWORD PTR [rax]
	lea	edx, 1[rax]
	mov	rax, QWORD PTR 24[rbp]
	mov	DWORD PTR [rax], edx
	mov	DWORD PTR -136[rbp], 13
	jmp	.L827
.L916:
	nop
.L837:
	cmp	DWORD PTR -64[rbp], 116
	jne	.L917
	nop
.L838:
	mov	rax, QWORD PTR 24[rbp]
	mov	eax, DWORD PTR [rax]
	lea	edx, 1[rax]
	mov	rax, QWORD PTR 24[rbp]
	mov	DWORD PTR [rax], edx
	mov	DWORD PTR -136[rbp], 9
	jmp	.L827
.L917:
	nop
.L839:
	cmp	DWORD PTR -64[rbp], 118
	jne	.L918
	nop
.L840:
	mov	rax, QWORD PTR 24[rbp]
	mov	eax, DWORD PTR [rax]
	lea	edx, 1[rax]
	mov	rax, QWORD PTR 24[rbp]
	mov	DWORD PTR [rax], edx
	mov	DWORD PTR -136[rbp], 11
	jmp	.L827
.L918:
	nop
.L841:
	cmp	DWORD PTR -64[rbp], 92
	jne	.L919
	nop
.L842:
	mov	rax, QWORD PTR 24[rbp]
	mov	eax, DWORD PTR [rax]
	lea	edx, 1[rax]
	mov	rax, QWORD PTR 24[rbp]
	mov	DWORD PTR [rax], edx
	mov	DWORD PTR -136[rbp], 92
	jmp	.L827
.L919:
	nop
.L843:
	cmp	DWORD PTR -64[rbp], 34
	jne	.L920
	nop
.L844:
	mov	rax, QWORD PTR 24[rbp]
	mov	eax, DWORD PTR [rax]
	lea	edx, 1[rax]
	mov	rax, QWORD PTR 24[rbp]
	mov	DWORD PTR [rax], edx
	mov	DWORD PTR -136[rbp], 34
	jmp	.L827
.L920:
	nop
.L845:
	cmp	DWORD PTR -64[rbp], 39
	jne	.L921
	nop
.L846:
	mov	rax, QWORD PTR 24[rbp]
	mov	eax, DWORD PTR [rax]
	lea	edx, 1[rax]
	mov	rax, QWORD PTR 24[rbp]
	mov	DWORD PTR [rax], edx
	mov	DWORD PTR -136[rbp], 39
	jmp	.L827
.L847:
.L921:
	nop
.L848:
	cmp	DWORD PTR -64[rbp], 47
	jle	.L922
	cmp	DWORD PTR -64[rbp], 57
	setle	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -8[rbp], rax
	jmp	.L851
.L922:
	nop
.L850:
	mov	QWORD PTR -8[rbp], 0
.L851:
	cmp	QWORD PTR -8[rbp], 0
	je	.L923
	mov	DWORD PTR -28[rbp], 0
	mov	DWORD PTR -32[rbp], 0
.L854:
	cmp	DWORD PTR -32[rbp], 2
	jg	.L924
	mov	rdx, -1
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_StrLen
	mov	QWORD PTR -72[rbp], rax
	mov	rax, QWORD PTR 24[rbp]
	mov	eax, DWORD PTR [rax]
	cdqe
	cmp	QWORD PTR -72[rbp], rax
	setge	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -24[rbp], rax
	jmp	.L857
.L924:
	nop
.L856:
	mov	QWORD PTR -24[rbp], 0
.L857:
	cmp	QWORD PTR -24[rbp], 0
	je	.L925
	mov	rax, QWORD PTR 24[rbp]
	mov	eax, DWORD PTR [rax]
	cdqe
	mov	r8d, 1
	mov	rdx, rax
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_StrMid
	mov	QWORD PTR -80[rbp], rax
	mov	rax, QWORD PTR -80[rbp]
	mov	edx, 1
	mov	rcx, rax
	call	fb_ASC
	mov	DWORD PTR -84[rbp], eax
	mov	eax, DWORD PTR -84[rbp]
	mov	DWORD PTR -88[rbp], eax
	cmp	DWORD PTR -88[rbp], 47
	jle	.L926
	cmp	DWORD PTR -88[rbp], 57
	setg	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -40[rbp], rax
	jmp	.L862
.L926:
	nop
.L861:
	mov	QWORD PTR -40[rbp], -1
.L862:
	cmp	QWORD PTR -40[rbp], 0
	jne	.L927
	nop
.L864:
	mov	edx, DWORD PTR -28[rbp]
	mov	eax, edx
	sal	eax, 2
	add	eax, edx
	add	eax, eax
	mov	edx, eax
	mov	eax, DWORD PTR -88[rbp]
	add	eax, edx
	sub	eax, 48
	mov	DWORD PTR -28[rbp], eax
	mov	rax, QWORD PTR 24[rbp]
	mov	eax, DWORD PTR [rax]
	lea	edx, 1[rax]
	mov	rax, QWORD PTR 24[rbp]
	mov	DWORD PTR [rax], edx
	add	DWORD PTR -32[rbp], 1
	jmp	.L854
.L925:
	nop
	jmp	.L859
.L927:
	nop
.L859:
	cmp	DWORD PTR -28[rbp], 255
	jle	.L928
	mov	DWORD PTR -28[rbp], 255
	jmp	.L866
.L928:
	nop
.L866:
	mov	eax, DWORD PTR -28[rbp]
	mov	DWORD PTR -136[rbp], eax
	jmp	.L827
.L853:
.L923:
	nop
.L867:
	cmp	DWORD PTR -64[rbp], 120
	je	.L929
	cmp	DWORD PTR -64[rbp], 88
	sete	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -16[rbp], rax
	jmp	.L870
.L929:
	nop
.L869:
	mov	QWORD PTR -16[rbp], -1
.L870:
	cmp	QWORD PTR -16[rbp], 0
	je	.L930
	mov	rax, QWORD PTR 24[rbp]
	mov	eax, DWORD PTR [rax]
	lea	edx, 1[rax]
	mov	rax, QWORD PTR 24[rbp]
	mov	DWORD PTR [rax], edx
	mov	rax, QWORD PTR 24[rbp]
	mov	r9d, 2
	mov	r8d, 16
	mov	rdx, rax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN3TKO4TEXT12READRADIXIN_ER8FBSTRINGRiii
	mov	DWORD PTR -92[rbp], eax
	mov	eax, DWORD PTR -92[rbp]
	mov	DWORD PTR -136[rbp], eax
	jmp	.L827
.L872:
.L930:
	nop
.L873:
	cmp	DWORD PTR -64[rbp], 38
	jne	.L931
	mov	rdx, -1
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_StrLen
	mov	QWORD PTR -104[rbp], rax
	mov	rax, QWORD PTR 24[rbp]
	mov	eax, DWORD PTR [rax]
	cdqe
	add	rax, 1
	cmp	QWORD PTR -104[rbp], rax
	jl	.L932
	mov	rax, QWORD PTR 24[rbp]
	mov	eax, DWORD PTR [rax]
	cdqe
	add	rax, 1
	mov	r8d, 1
	mov	rdx, rax
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_StrMid
	mov	QWORD PTR -112[rbp], rax
	mov	rax, QWORD PTR -112[rbp]
	mov	edx, 1
	mov	rcx, rax
	call	fb_ASC
	mov	DWORD PTR -116[rbp], eax
	mov	eax, DWORD PTR -116[rbp]
	mov	DWORD PTR -120[rbp], eax
	cmp	DWORD PTR -120[rbp], 104
	je	.L933
	nop
.L878:
	cmp	DWORD PTR -120[rbp], 72
	jne	.L934
	jmp	.L879
.L933:
	nop
.L879:
	mov	rax, QWORD PTR 24[rbp]
	mov	eax, DWORD PTR [rax]
	lea	edx, 2[rax]
	mov	rax, QWORD PTR 24[rbp]
	mov	DWORD PTR [rax], edx
	mov	rax, QWORD PTR 24[rbp]
	mov	r9d, 2
	mov	r8d, 16
	mov	rdx, rax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN3TKO4TEXT12READRADIXIN_ER8FBSTRINGRiii
	mov	DWORD PTR -132[rbp], eax
	mov	eax, DWORD PTR -132[rbp]
	mov	DWORD PTR -136[rbp], eax
	jmp	.L827
.L934:
	nop
.L880:
	cmp	DWORD PTR -120[rbp], 111
	je	.L935
	nop
.L881:
	cmp	DWORD PTR -120[rbp], 79
	jne	.L936
	jmp	.L882
.L935:
	nop
.L882:
	mov	rax, QWORD PTR 24[rbp]
	mov	eax, DWORD PTR [rax]
	lea	edx, 2[rax]
	mov	rax, QWORD PTR 24[rbp]
	mov	DWORD PTR [rax], edx
	mov	rax, QWORD PTR 24[rbp]
	mov	r9d, 3
	mov	r8d, 8
	mov	rdx, rax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN3TKO4TEXT12READRADIXIN_ER8FBSTRINGRiii
	mov	DWORD PTR -128[rbp], eax
	mov	eax, DWORD PTR -128[rbp]
	mov	DWORD PTR -136[rbp], eax
	jmp	.L827
.L936:
	nop
.L883:
	cmp	DWORD PTR -120[rbp], 98
	je	.L937
	nop
.L884:
	cmp	DWORD PTR -120[rbp], 66
	jne	.L938
	jmp	.L885
.L937:
	nop
.L885:
	mov	rax, QWORD PTR 24[rbp]
	mov	eax, DWORD PTR [rax]
	lea	edx, 2[rax]
	mov	rax, QWORD PTR 24[rbp]
	mov	DWORD PTR [rax], edx
	mov	rax, QWORD PTR 24[rbp]
	mov	r9d, 8
	mov	r8d, 2
	mov	rdx, rax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN3TKO4TEXT12READRADIXIN_ER8FBSTRINGRiii
	mov	DWORD PTR -124[rbp], eax
	mov	eax, DWORD PTR -124[rbp]
	mov	DWORD PTR -136[rbp], eax
	jmp	.L827
.L877:
.L886:
.L887:
.L932:
	nop
	jmp	.L888
.L938:
	nop
.L888:
	mov	rax, QWORD PTR 24[rbp]
	mov	eax, DWORD PTR [rax]
	lea	edx, 1[rax]
	mov	rax, QWORD PTR 24[rbp]
	mov	DWORD PTR [rax], edx
	mov	DWORD PTR -136[rbp], -1
	jmp	.L827
.L875:
.L931:
	nop
.L889:
	mov	rax, QWORD PTR 24[rbp]
	mov	eax, DWORD PTR [rax]
	lea	edx, 1[rax]
	mov	rax, QWORD PTR 24[rbp]
	mov	DWORD PTR [rax], edx
	mov	eax, DWORD PTR -64[rbp]
	mov	DWORD PTR -136[rbp], eax
	nop
.L827:
	mov	eax, DWORD PTR -136[rbp]
	add	rsp, 176
	pop	rbp
	ret
	.seh_endproc
	.section .rdata,"dr"
.LC7:
	.ascii "\0"
	.text
	.globl	_ZN3TKO4TEXT17DECODEESCAPEDBODYER8FBSTRINGRb
	.def	_ZN3TKO4TEXT17DECODEESCAPEDBODYER8FBSTRINGRb;	.scl	2;	.type	32;	.endef
	.seh_proc	_ZN3TKO4TEXT17DECODEESCAPEDBODYER8FBSTRINGRb
_ZN3TKO4TEXT17DECODEESCAPEDBODYER8FBSTRINGRb:
	push	rbp
	.seh_pushreg	rbp
	sub	rsp, 256
	.seh_stackalloc	256
	lea	rbp, 128[rsp]
	.seh_setframe	rbp, 128
	.seh_endprologue
	mov	QWORD PTR 144[rbp], rcx
	mov	QWORD PTR 152[rbp], rdx
	lea	rax, -16[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
.L940:
	mov	rax, QWORD PTR 152[rbp]
	mov	BYTE PTR [rax], 0
	mov	rdx, -1
	mov	rcx, QWORD PTR 144[rbp]
	call	fb_StrLen
	mov	QWORD PTR 104[rbp], rax
	mov	rax, QWORD PTR 104[rbp]
	mov	DWORD PTR 100[rbp], eax
	mov	DWORD PTR 124[rbp], 1
	mov	eax, DWORD PTR 100[rbp]
	sub	eax, 1
	mov	DWORD PTR 96[rbp], eax
	jmp	.L941
.L972:
	nop
.L942:
	mov	eax, DWORD PTR 124[rbp]
	cdqe
	mov	r8d, 1
	mov	rdx, rax
	mov	rcx, QWORD PTR 144[rbp]
	call	fb_StrMid
	mov	QWORD PTR 40[rbp], rax
	mov	rax, QWORD PTR 40[rbp]
	mov	edx, 1
	mov	rcx, rax
	call	fb_ASC
	mov	DWORD PTR 36[rbp], eax
	cmp	DWORD PTR 36[rbp], 92
	jne	.L969
	mov	eax, DWORD PTR 124[rbp]
	cdqe
	add	rax, 1
	mov	r8d, 1
	mov	rdx, rax
	mov	rcx, QWORD PTR 144[rbp]
	call	fb_StrMid
	mov	QWORD PTR 24[rbp], rax
	mov	rax, QWORD PTR 24[rbp]
	mov	edx, 1
	mov	rcx, rax
	call	fb_ASC
	mov	DWORD PTR 20[rbp], eax
	mov	eax, DWORD PTR 20[rbp]
	mov	DWORD PTR 16[rbp], eax
	cmp	DWORD PTR 16[rbp], 117
	je	.L970
	cmp	DWORD PTR 16[rbp], 85
	sete	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR 112[rbp], rax
	jmp	.L947
.L970:
	nop
.L946:
	mov	QWORD PTR 112[rbp], -1
.L947:
	cmp	QWORD PTR 112[rbp], 0
	je	.L971
	mov	rax, QWORD PTR 152[rbp]
	mov	BYTE PTR [rax], 1
	lea	rax, -16[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9d, 1
	lea	r8, .LC7[rip]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrInit
	jmp	.L949
.L944:
.L950:
.L951:
.L952:
.L969:
	nop
	jmp	.L953
.L971:
	nop
.L953:
	add	DWORD PTR 124[rbp], 1
.L941:
	mov	eax, DWORD PTR 124[rbp]
	cmp	eax, DWORD PTR 96[rbp]
	jle	.L972
	nop
.L954:
	lea	rax, -48[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9d, 1
	lea	r8, .LC7[rip]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrInit
	mov	DWORD PTR -52[rbp], 1
.L955:
	mov	eax, DWORD PTR -52[rbp]
	cmp	DWORD PTR 100[rbp], eax
	jl	.L973
	mov	eax, DWORD PTR -52[rbp]
	cdqe
	mov	r8d, 1
	mov	rdx, rax
	mov	rcx, QWORD PTR 144[rbp]
	call	fb_StrMid
	mov	QWORD PTR 88[rbp], rax
	mov	rax, QWORD PTR 88[rbp]
	mov	edx, 1
	mov	rcx, rax
	call	fb_ASC
	mov	DWORD PTR 84[rbp], eax
	cmp	DWORD PTR 84[rbp], 92
	jne	.L974
	lea	rax, -52[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 144[rbp]
	call	_ZN3TKO4TEXT12ESCAPEBYTEATER8FBSTRINGRi
	mov	DWORD PTR 80[rbp], eax
	mov	eax, DWORD PTR 80[rbp]
	mov	DWORD PTR 76[rbp], eax
	cmp	DWORD PTR 76[rbp], 0
	js	.L975
	mov	eax, DWORD PTR 76[rbp]
	cdqe
	mov	rdx, rax
	mov	ecx, 1
	call	fb_CHR
	mov	QWORD PTR 64[rbp], rax
	mov	rdx, QWORD PTR 64[rbp]
	lea	rax, -48[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrConcatAssign
	jmp	.L962
.L975:
	nop
.L961:
	jmp	.L962
.L974:
	nop
.L959:
	mov	eax, DWORD PTR -52[rbp]
	cdqe
	mov	r8d, 1
	mov	rdx, rax
	mov	rcx, QWORD PTR 144[rbp]
	call	fb_StrMid
	mov	QWORD PTR 56[rbp], rax
	lea	rax, -80[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	rcx, QWORD PTR 56[rbp]
	lea	rdx, -48[rbp]
	lea	rax, -80[rbp]
	mov	QWORD PTR 32[rsp], -1
	mov	r9, rcx
	mov	r8, -1
	mov	rcx, rax
	call	fb_StrConcat
	mov	QWORD PTR 48[rbp], rax
	mov	rdx, QWORD PTR 48[rbp]
	lea	rax, -48[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrAssign
	mov	eax, DWORD PTR -52[rbp]
	add	eax, 1
	mov	DWORD PTR -52[rbp], eax
.L962:
	jmp	.L955
.L973:
	nop
.L957:
	lea	rdx, -48[rbp]
	lea	rax, -16[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrInit
	lea	rax, -48[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	nop
.L949:
	lea	rax, -16[rbp]
	mov	rcx, rax
	call	fb_StrAllocTempResult
	mov	QWORD PTR 8[rbp], rax
	mov	rax, QWORD PTR 8[rbp]
	add	rsp, 256
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
.L977:
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
.L978:
	mov	rax, QWORD PTR -16[rbp]
	cmp	rax, QWORD PTR -24[rbp]
	jnb	.L983
	mov	rax, QWORD PTR -16[rbp]
	movzx	edx, BYTE PTR [rax]
	mov	rax, QWORD PTR -8[rbp]
	mov	BYTE PTR [rax], dl
	add	QWORD PTR -8[rbp], 1
	add	QWORD PTR -16[rbp], 1
	jmp	.L978
.L983:
	nop
.L980:
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 72[rax]
	mov	rax, QWORD PTR 24[rbp]
	mov	eax, DWORD PTR 72[rax]
	mov	DWORD PTR [rdx], eax
	nop
	add	rsp, 80
	pop	rbp
	ret
.L981:
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
.L985:
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
.L986:
	mov	rax, QWORD PTR -16[rbp]
	cmp	rax, QWORD PTR -24[rbp]
	jnb	.L991
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
	jmp	.L986
.L991:
	nop
.L988:
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 72[rax]
	mov	rax, QWORD PTR 24[rbp]
	mov	eax, DWORD PTR 72[rax]
	mov	DWORD PTR [rdx], eax
	nop
	add	rsp, 80
	pop	rbp
	ret
.L989:
	.seh_endproc
	.def	_ZN3TKO4TEXT11UTF16TOUTF8ER5ArrayIhES3_b;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN3TKO4TEXT11UTF16TOUTF8ER5ArrayIhES3_b
_ZN3TKO4TEXT11UTF16TOUTF8ER5ArrayIhES3_b:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 176
	.seh_stackalloc	176
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
	mov	eax, r8d
	mov	BYTE PTR 32[rbp], al
.L993:
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIhE5COUNTEv
	mov	DWORD PTR -48[rbp], eax
	mov	eax, DWORD PTR -48[rbp]
	mov	DWORD PTR -52[rbp], eax
	mov	DWORD PTR -4[rbp], 2
.L994:
	mov	eax, DWORD PTR -4[rbp]
	cdqe
	lea	rdx, 1[rax]
	mov	eax, DWORD PTR -52[rbp]
	cdqe
	cmp	rdx, rax
	jge	.L1025
	mov	DWORD PTR -28[rbp], 0
	cmp	BYTE PTR 32[rbp], 0
	je	.L1026
	mov	eax, DWORD PTR -4[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIhEixEi
	mov	QWORD PTR -64[rbp], rax
	mov	eax, DWORD PTR -4[rbp]
	add	eax, 1
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIhEixEi
	mov	QWORD PTR -72[rbp], rax
	mov	rax, QWORD PTR -64[rbp]
	movzx	eax, BYTE PTR [rax]
	movzx	eax, al
	sal	rax, 8
	mov	edx, eax
	mov	rax, QWORD PTR -72[rbp]
	movzx	eax, BYTE PTR [rax]
	movzx	eax, al
	or	eax, edx
	mov	DWORD PTR -28[rbp], eax
	jmp	.L999
.L1026:
	nop
.L998:
	mov	eax, DWORD PTR -4[rbp]
	add	eax, 1
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIhEixEi
	mov	QWORD PTR -80[rbp], rax
	mov	eax, DWORD PTR -4[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIhEixEi
	mov	QWORD PTR -88[rbp], rax
	mov	rax, QWORD PTR -80[rbp]
	movzx	eax, BYTE PTR [rax]
	movzx	eax, al
	sal	rax, 8
	mov	edx, eax
	mov	rax, QWORD PTR -88[rbp]
	movzx	eax, BYTE PTR [rax]
	movzx	eax, al
	or	eax, edx
	mov	DWORD PTR -28[rbp], eax
.L999:
	add	DWORD PTR -4[rbp], 2
	cmp	DWORD PTR -28[rbp], 55295
	jbe	.L1027
	cmp	DWORD PTR -28[rbp], 56319
	setbe	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -16[rbp], rax
	jmp	.L1002
.L1027:
	nop
.L1001:
	mov	QWORD PTR -16[rbp], 0
.L1002:
	cmp	QWORD PTR -16[rbp], 0
	setne	al
	mov	BYTE PTR -89[rbp], al
	movsx	eax, BYTE PTR -89[rbp]
	neg	eax
	test	eax, eax
	je	.L1028
	mov	eax, DWORD PTR -4[rbp]
	cdqe
	lea	rdx, 1[rax]
	mov	eax, DWORD PTR -52[rbp]
	cdqe
	cmp	rdx, rax
	setl	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -24[rbp], rax
	jmp	.L1005
.L1028:
	nop
.L1004:
	mov	QWORD PTR -24[rbp], 0
.L1005:
	cmp	QWORD PTR -24[rbp], 0
	setne	al
	mov	BYTE PTR -90[rbp], al
	cmp	BYTE PTR -90[rbp], 0
	je	.L1029
	mov	DWORD PTR -44[rbp], 0
	cmp	BYTE PTR 32[rbp], 0
	je	.L1030
	mov	eax, DWORD PTR -4[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIhEixEi
	mov	QWORD PTR -104[rbp], rax
	mov	eax, DWORD PTR -4[rbp]
	add	eax, 1
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIhEixEi
	mov	QWORD PTR -112[rbp], rax
	mov	rax, QWORD PTR -104[rbp]
	movzx	eax, BYTE PTR [rax]
	movzx	eax, al
	sal	rax, 8
	mov	edx, eax
	mov	rax, QWORD PTR -112[rbp]
	movzx	eax, BYTE PTR [rax]
	movzx	eax, al
	or	eax, edx
	mov	DWORD PTR -44[rbp], eax
	jmp	.L1010
.L1030:
	nop
.L1009:
	mov	eax, DWORD PTR -4[rbp]
	add	eax, 1
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIhEixEi
	mov	QWORD PTR -120[rbp], rax
	mov	eax, DWORD PTR -4[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIhEixEi
	mov	QWORD PTR -128[rbp], rax
	mov	rax, QWORD PTR -120[rbp]
	movzx	eax, BYTE PTR [rax]
	movzx	eax, al
	sal	rax, 8
	mov	edx, eax
	mov	rax, QWORD PTR -128[rbp]
	movzx	eax, BYTE PTR [rax]
	movzx	eax, al
	or	eax, edx
	mov	DWORD PTR -44[rbp], eax
.L1010:
	cmp	DWORD PTR -44[rbp], 56319
	jbe	.L1031
	cmp	DWORD PTR -44[rbp], 57343
	setbe	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -40[rbp], rax
	jmp	.L1013
.L1031:
	nop
.L1012:
	mov	QWORD PTR -40[rbp], 0
.L1013:
	cmp	QWORD PTR -40[rbp], 0
	setne	al
	mov	BYTE PTR -129[rbp], al
	cmp	BYTE PTR -129[rbp], 0
	je	.L1032
	add	DWORD PTR -4[rbp], 2
	mov	eax, DWORD PTR -28[rbp]
	sub	rax, 55296
	sal	rax, 10
	mov	edx, eax
	mov	eax, DWORD PTR -44[rbp]
	add	eax, edx
	add	eax, 9216
	mov	DWORD PTR -28[rbp], eax
	jmp	.L1017
.L1007:
.L1015:
.L1016:
.L1029:
	nop
	jmp	.L1017
.L1032:
	nop
.L1017:
	mov	edx, DWORD PTR -28[rbp]
	mov	rax, QWORD PTR 24[rbp]
	mov	rcx, rax
	call	_ZN3TKO4TEXT10APPENDUTF8ER5ArrayIhEj
	jmp	.L994
.L996:
.L1025:
	nop
.L1018:
	nop
	add	rsp, 176
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN3TKO4TEXT8COPYFROMER5ArrayIhES3_i;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN3TKO4TEXT8COPYFROMER5ArrayIhES3_i
_ZN3TKO4TEXT8COPYFROMER5ArrayIhES3_i:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 64
	.seh_stackalloc	64
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
	mov	DWORD PTR 32[rbp], r8d
.L1034:
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIhE5COUNTEv
	mov	DWORD PTR -8[rbp], eax
	mov	eax, DWORD PTR -8[rbp]
	mov	DWORD PTR -12[rbp], eax
	mov	eax, DWORD PTR 32[rbp]
	cmp	eax, DWORD PTR -12[rbp]
	jge	.L1043
	nop
.L1036:
	mov	eax, DWORD PTR -12[rbp]
	sub	eax, DWORD PTR 32[rbp]
	mov	edx, eax
	mov	rax, QWORD PTR 24[rbp]
	mov	rcx, rax
	call	_ZN5ArrayIhE7RESERVEEi
	mov	eax, DWORD PTR 32[rbp]
	mov	DWORD PTR -4[rbp], eax
	mov	eax, DWORD PTR -12[rbp]
	sub	eax, 1
	mov	DWORD PTR -16[rbp], eax
	jmp	.L1038
.L1044:
	nop
.L1039:
	mov	eax, DWORD PTR -4[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIhEixEi
	mov	QWORD PTR -24[rbp], rax
	mov	rdx, QWORD PTR -24[rbp]
	mov	rax, QWORD PTR 24[rbp]
	mov	rcx, rax
	call	_ZN5ArrayIhE4PUSHERh
.L1040:
	add	DWORD PTR -4[rbp], 1
.L1038:
	mov	eax, DWORD PTR -4[rbp]
	cmp	eax, DWORD PTR -16[rbp]
	jle	.L1044
	jmp	.L1041
.L1037:
.L1043:
	nop
.L1041:
	nop
	add	rsp, 64
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN3TKO4TEXT11UTF32TOUTF8ER5ArrayIhES3_b;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN3TKO4TEXT11UTF32TOUTF8ER5ArrayIhES3_b
_ZN3TKO4TEXT11UTF32TOUTF8ER5ArrayIhES3_b:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 144
	.seh_stackalloc	144
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
	mov	eax, r8d
	mov	BYTE PTR 32[rbp], al
.L1046:
	mov	DWORD PTR -4[rbp], 0
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIhE5COUNTEv
	mov	DWORD PTR -32[rbp], eax
	mov	eax, DWORD PTR -32[rbp]
	mov	DWORD PTR -36[rbp], eax
.L1047:
	mov	eax, DWORD PTR -4[rbp]
	cdqe
	lea	rdx, 3[rax]
	mov	eax, DWORD PTR -36[rbp]
	cdqe
	cmp	rdx, rax
	jge	.L1071
	mov	DWORD PTR -108[rbp], 0
	cmp	BYTE PTR 32[rbp], 0
	je	.L1072
	mov	eax, DWORD PTR -4[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIhE2ATEi
	mov	QWORD PTR -48[rbp], rax
	mov	eax, DWORD PTR -4[rbp]
	add	eax, 1
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIhE2ATEi
	mov	QWORD PTR -56[rbp], rax
	mov	eax, DWORD PTR -4[rbp]
	add	eax, 2
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIhE2ATEi
	mov	QWORD PTR -64[rbp], rax
	mov	eax, DWORD PTR -4[rbp]
	add	eax, 3
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIhE2ATEi
	mov	QWORD PTR -72[rbp], rax
	mov	rax, QWORD PTR -48[rbp]
	movzx	eax, BYTE PTR [rax]
	movzx	eax, al
	sal	rax, 24
	mov	edx, eax
	mov	rax, QWORD PTR -56[rbp]
	movzx	eax, BYTE PTR [rax]
	movzx	eax, al
	sal	rax, 16
	or	edx, eax
	mov	rax, QWORD PTR -64[rbp]
	movzx	eax, BYTE PTR [rax]
	movzx	eax, al
	sal	rax, 8
	or	edx, eax
	mov	rax, QWORD PTR -72[rbp]
	movzx	eax, BYTE PTR [rax]
	movzx	eax, al
	or	eax, edx
	mov	DWORD PTR -108[rbp], eax
	jmp	.L1052
.L1072:
	nop
.L1051:
	mov	eax, DWORD PTR -4[rbp]
	add	eax, 3
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIhE2ATEi
	mov	QWORD PTR -80[rbp], rax
	mov	eax, DWORD PTR -4[rbp]
	add	eax, 2
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIhE2ATEi
	mov	QWORD PTR -88[rbp], rax
	mov	eax, DWORD PTR -4[rbp]
	add	eax, 1
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIhE2ATEi
	mov	QWORD PTR -96[rbp], rax
	mov	eax, DWORD PTR -4[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIhE2ATEi
	mov	QWORD PTR -104[rbp], rax
	mov	rax, QWORD PTR -80[rbp]
	movzx	eax, BYTE PTR [rax]
	movzx	eax, al
	sal	rax, 24
	mov	edx, eax
	mov	rax, QWORD PTR -88[rbp]
	movzx	eax, BYTE PTR [rax]
	movzx	eax, al
	sal	rax, 16
	or	edx, eax
	mov	rax, QWORD PTR -96[rbp]
	movzx	eax, BYTE PTR [rax]
	movzx	eax, al
	sal	rax, 8
	or	edx, eax
	mov	rax, QWORD PTR -104[rbp]
	movzx	eax, BYTE PTR [rax]
	movzx	eax, al
	or	eax, edx
	mov	DWORD PTR -108[rbp], eax
.L1052:
	add	DWORD PTR -4[rbp], 4
	cmp	DWORD PTR -4[rbp], 4
	jne	.L1073
	mov	eax, DWORD PTR -108[rbp]
	cmp	eax, 65279
	sete	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -16[rbp], rax
	jmp	.L1055
.L1073:
	nop
.L1054:
	mov	QWORD PTR -16[rbp], 0
.L1055:
	cmp	QWORD PTR -16[rbp], 0
	je	.L1074
	jmp	.L1047
.L1074:
	nop
.L1057:
	mov	eax, DWORD PTR -108[rbp]
	cmp	eax, 1114111
	seta	al
	mov	BYTE PTR -25[rbp], al
	mov	eax, DWORD PTR -108[rbp]
	cmp	eax, 55295
	jbe	.L1075
	mov	eax, DWORD PTR -108[rbp]
	cmp	eax, 57343
	setbe	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -24[rbp], rax
	jmp	.L1060
.L1075:
	nop
.L1059:
	mov	QWORD PTR -24[rbp], 0
.L1060:
	cmp	QWORD PTR -24[rbp], 0
	je	.L1076
	mov	BYTE PTR -25[rbp], 1
	jmp	.L1062
.L1076:
	nop
.L1062:
	cmp	BYTE PTR -25[rbp], 0
	je	.L1077
	mov	DWORD PTR -108[rbp], 65533
	jmp	.L1064
.L1077:
	nop
.L1064:
	mov	edx, DWORD PTR -108[rbp]
	mov	rax, QWORD PTR 24[rbp]
	mov	rcx, rax
	call	_ZN3TKO4TEXT10APPENDUTF8ER5ArrayIhEj
	jmp	.L1047
.L1049:
.L1071:
	nop
.L1065:
	nop
	add	rsp, 144
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN3TKO4TEXT12READRADIXIN_ER8FBSTRINGRiii;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN3TKO4TEXT12READRADIXIN_ER8FBSTRINGRiii
_ZN3TKO4TEXT12READRADIXIN_ER8FBSTRINGRiii:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	add	rsp, -128
	.seh_stackalloc	128
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
	mov	DWORD PTR 32[rbp], r8d
	mov	DWORD PTR 40[rbp], r9d
	mov	DWORD PTR -84[rbp], 0
.L1079:
	mov	DWORD PTR -12[rbp], 0
	mov	DWORD PTR -16[rbp], 0
.L1080:
	mov	eax, DWORD PTR -16[rbp]
	cmp	eax, DWORD PTR 40[rbp]
	jge	.L1115
	mov	rdx, -1
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_StrLen
	mov	QWORD PTR -64[rbp], rax
	mov	rax, QWORD PTR 24[rbp]
	mov	eax, DWORD PTR [rax]
	cdqe
	cmp	QWORD PTR -64[rbp], rax
	setge	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -8[rbp], rax
	jmp	.L1083
.L1115:
	nop
.L1082:
	mov	QWORD PTR -8[rbp], 0
.L1083:
	cmp	QWORD PTR -8[rbp], 0
	je	.L1116
	mov	rax, QWORD PTR 24[rbp]
	mov	eax, DWORD PTR [rax]
	cdqe
	mov	r8d, 1
	mov	rdx, rax
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_StrMid
	mov	QWORD PTR -72[rbp], rax
	mov	rax, QWORD PTR -72[rbp]
	mov	edx, 1
	mov	rcx, rax
	call	fb_ASC
	mov	DWORD PTR -76[rbp], eax
	mov	eax, DWORD PTR -76[rbp]
	mov	DWORD PTR -80[rbp], eax
	mov	DWORD PTR -52[rbp], -1
	cmp	DWORD PTR -80[rbp], 47
	jle	.L1117
	cmp	DWORD PTR -80[rbp], 57
	setle	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -24[rbp], rax
	jmp	.L1088
.L1117:
	nop
.L1087:
	mov	QWORD PTR -24[rbp], 0
.L1088:
	cmp	QWORD PTR -24[rbp], 0
	je	.L1118
	mov	eax, DWORD PTR -80[rbp]
	sub	eax, 48
	mov	DWORD PTR -52[rbp], eax
	jmp	.L1090
.L1118:
	nop
.L1090:
	cmp	DWORD PTR -80[rbp], 96
	jle	.L1119
	cmp	DWORD PTR -80[rbp], 102
	setle	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -32[rbp], rax
	jmp	.L1093
.L1119:
	nop
.L1092:
	mov	QWORD PTR -32[rbp], 0
.L1093:
	cmp	QWORD PTR -32[rbp], 0
	je	.L1120
	mov	eax, DWORD PTR -80[rbp]
	sub	eax, 87
	mov	DWORD PTR -52[rbp], eax
	jmp	.L1095
.L1120:
	nop
.L1095:
	cmp	DWORD PTR -80[rbp], 64
	jle	.L1121
	cmp	DWORD PTR -80[rbp], 70
	setle	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -40[rbp], rax
	jmp	.L1098
.L1121:
	nop
.L1097:
	mov	QWORD PTR -40[rbp], 0
.L1098:
	cmp	QWORD PTR -40[rbp], 0
	je	.L1122
	mov	eax, DWORD PTR -80[rbp]
	sub	eax, 55
	mov	DWORD PTR -52[rbp], eax
	jmp	.L1100
.L1122:
	nop
.L1100:
	cmp	DWORD PTR -52[rbp], 0
	js	.L1123
	mov	eax, DWORD PTR -52[rbp]
	cmp	eax, DWORD PTR 32[rbp]
	setge	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -48[rbp], rax
	jmp	.L1103
.L1123:
	nop
.L1102:
	mov	QWORD PTR -48[rbp], -1
.L1103:
	cmp	QWORD PTR -48[rbp], 0
	jne	.L1124
	nop
.L1105:
	mov	eax, DWORD PTR -12[rbp]
	imul	eax, DWORD PTR 32[rbp]
	mov	edx, eax
	mov	eax, DWORD PTR -52[rbp]
	add	eax, edx
	mov	DWORD PTR -12[rbp], eax
	mov	rax, QWORD PTR 24[rbp]
	mov	eax, DWORD PTR [rax]
	lea	edx, 1[rax]
	mov	rax, QWORD PTR 24[rbp]
	mov	DWORD PTR [rax], edx
	add	DWORD PTR -16[rbp], 1
	jmp	.L1080
.L1116:
	nop
	jmp	.L1085
.L1124:
	nop
.L1085:
	cmp	DWORD PTR -12[rbp], 255
	jle	.L1125
	mov	DWORD PTR -12[rbp], 255
	jmp	.L1107
.L1125:
	nop
.L1107:
	mov	eax, DWORD PTR -12[rbp]
	mov	DWORD PTR -84[rbp], eax
	nop
.L1108:
	mov	eax, DWORD PTR -84[rbp]
	sub	rsp, -128
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
	.def	fb_StrLen;	.scl	2;	.type	32;	.endef
	.def	fb_UStrInit;	.scl	2;	.type	32;	.endef
	.def	fb_SPACE;	.scl	2;	.type	32;	.endef
	.def	memcpy;	.scl	2;	.type	32;	.endef
	.def	fb_UStrAssignFromA;	.scl	2;	.type	32;	.endef
	.def	fb_UStrAllocTempResult;	.scl	2;	.type	32;	.endef
	.def	fb_UStrAssignToA;	.scl	2;	.type	32;	.endef
	.def	fb_StrMid;	.scl	2;	.type	32;	.endef
	.def	fb_ASC;	.scl	2;	.type	32;	.endef
	.def	fb_CHR;	.scl	2;	.type	32;	.endef
	.def	fb_StrConcatAssign;	.scl	2;	.type	32;	.endef
	.def	fb_StrConcat;	.scl	2;	.type	32;	.endef
	.def	fb_ArrayRedimTo;	.scl	2;	.type	32;	.endef
