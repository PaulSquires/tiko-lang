	.file	"resolve.c"
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
	.globl	_ZN3TKO12SEMANTICINFO6RESIZEEi
	.def	_ZN3TKO12SEMANTICINFO6RESIZEEi;	.scl	2;	.type	32;	.endef
	.seh_proc	_ZN3TKO12SEMANTICINFO6RESIZEEi
_ZN3TKO12SEMANTICINFO6RESIZEEi:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 64
	.seh_stackalloc	64
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
.L3410:
	mov	eax, DWORD PTR 24[rbp]
	add	eax, 1
	mov	DWORD PTR -4[rbp], eax
.L3411:
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIjE5COUNTEv
	mov	DWORD PTR -8[rbp], eax
	mov	eax, DWORD PTR -8[rbp]
	cmp	eax, DWORD PTR -4[rbp]
	jge	.L3416
	mov	DWORD PTR -12[rbp], 0
	lea	rax, -12[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIjE4PUSHERj
	mov	DWORD PTR -16[rbp], 0
	mov	rax, QWORD PTR 16[rbp]
	lea	rcx, 80[rax]
	lea	rax, -16[rbp]
	mov	rdx, rax
	call	_ZN5ArrayIjE4PUSHERj
	mov	DWORD PTR -20[rbp], 0
	mov	rax, QWORD PTR 16[rbp]
	lea	rcx, 160[rax]
	lea	rax, -20[rbp]
	mov	rdx, rax
	call	_ZN5ArrayIjE4PUSHERj
	mov	BYTE PTR -21[rbp], 0
	mov	rax, QWORD PTR 16[rbp]
	lea	rcx, 240[rax]
	lea	rax, -21[rbp]
	mov	rdx, rax
	call	_ZN5ArrayIhE4PUSHERh
	jmp	.L3411
.L3413:
.L3416:
	nop
.L3414:
	nop
	add	rsp, 64
	pop	rbp
	ret
	.seh_endproc
	.globl	_ZN3TKO12SEMANTICINFO6SETREFEjj
	.def	_ZN3TKO12SEMANTICINFO6SETREFEjj;	.scl	2;	.type	32;	.endef
	.seh_proc	_ZN3TKO12SEMANTICINFO6SETREFEjj
_ZN3TKO12SEMANTICINFO6SETREFEjj:
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
.L3418:
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIjE5COUNTEv
	mov	DWORD PTR -4[rbp], eax
	mov	eax, DWORD PTR 24[rbp]
	cmp	DWORD PTR -4[rbp], eax
	jle	.L3423
	mov	eax, DWORD PTR 24[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIjEixEi
	mov	QWORD PTR -16[rbp], rax
	mov	rax, QWORD PTR -16[rbp]
	mov	edx, DWORD PTR 32[rbp]
	mov	DWORD PTR [rax], edx
	jmp	.L3424
.L3420:
.L3421:
.L3423:
	nop
.L3422:
.L3424:
	nop
	add	rsp, 48
	pop	rbp
	ret
	.seh_endproc
	.globl	_ZN3TKO12SEMANTICINFO5REFOFEj
	.def	_ZN3TKO12SEMANTICINFO5REFOFEj;	.scl	2;	.type	32;	.endef
	.seh_proc	_ZN3TKO12SEMANTICINFO5REFOFEj
_ZN3TKO12SEMANTICINFO5REFOFEj:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 64
	.seh_stackalloc	64
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
	mov	DWORD PTR -20[rbp], 0
.L3426:
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIjE5COUNTEv
	mov	DWORD PTR -4[rbp], eax
	mov	eax, DWORD PTR 24[rbp]
	cmp	DWORD PTR -4[rbp], eax
	jg	.L3432
	mov	DWORD PTR -20[rbp], 0
	jmp	.L3429
.L3432:
	nop
.L3428:
	mov	eax, DWORD PTR 24[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayIjEixEi
	mov	QWORD PTR -16[rbp], rax
	mov	rax, QWORD PTR -16[rbp]
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR -20[rbp], eax
	nop
.L3429:
	mov	eax, DWORD PTR -20[rbp]
	add	rsp, 64
	pop	rbp
	ret
	.seh_endproc
	.globl	_ZN3TKO12SEMANTICINFO7SETTYPEEjj
	.def	_ZN3TKO12SEMANTICINFO7SETTYPEEjj;	.scl	2;	.type	32;	.endef
	.seh_proc	_ZN3TKO12SEMANTICINFO7SETTYPEEjj
_ZN3TKO12SEMANTICINFO7SETTYPEEjj:
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
.L3434:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 80
	mov	rcx, rax
	call	_ZN5ArrayIjE5COUNTEv
	mov	DWORD PTR -4[rbp], eax
	mov	eax, DWORD PTR 24[rbp]
	cmp	DWORD PTR -4[rbp], eax
	jle	.L3439
	mov	eax, DWORD PTR 24[rbp]
	mov	rdx, QWORD PTR 16[rbp]
	lea	rcx, 80[rdx]
	mov	edx, eax
	call	_ZN5ArrayIjEixEi
	mov	QWORD PTR -16[rbp], rax
	mov	rax, QWORD PTR -16[rbp]
	mov	edx, DWORD PTR 32[rbp]
	mov	DWORD PTR [rax], edx
	jmp	.L3440
.L3436:
.L3437:
.L3439:
	nop
.L3438:
.L3440:
	nop
	add	rsp, 48
	pop	rbp
	ret
	.seh_endproc
	.globl	_ZN3TKO12SEMANTICINFO7TYPEOF_Ej
	.def	_ZN3TKO12SEMANTICINFO7TYPEOF_Ej;	.scl	2;	.type	32;	.endef
	.seh_proc	_ZN3TKO12SEMANTICINFO7TYPEOF_Ej
_ZN3TKO12SEMANTICINFO7TYPEOF_Ej:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 64
	.seh_stackalloc	64
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
	mov	DWORD PTR -20[rbp], 0
.L3442:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 80
	mov	rcx, rax
	call	_ZN5ArrayIjE5COUNTEv
	mov	DWORD PTR -4[rbp], eax
	mov	eax, DWORD PTR 24[rbp]
	cmp	DWORD PTR -4[rbp], eax
	jg	.L3448
	mov	DWORD PTR -20[rbp], 0
	jmp	.L3445
.L3448:
	nop
.L3444:
	mov	eax, DWORD PTR 24[rbp]
	mov	rdx, QWORD PTR 16[rbp]
	lea	rcx, 80[rdx]
	mov	edx, eax
	call	_ZN5ArrayIjEixEi
	mov	QWORD PTR -16[rbp], rax
	mov	rax, QWORD PTR -16[rbp]
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR -20[rbp], eax
	nop
.L3445:
	mov	eax, DWORD PTR -20[rbp]
	add	rsp, 64
	pop	rbp
	ret
	.seh_endproc
	.globl	_ZN3TKO12SEMANTICINFO8SETSCOPEEjj
	.def	_ZN3TKO12SEMANTICINFO8SETSCOPEEjj;	.scl	2;	.type	32;	.endef
	.seh_proc	_ZN3TKO12SEMANTICINFO8SETSCOPEEjj
_ZN3TKO12SEMANTICINFO8SETSCOPEEjj:
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
.L3450:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 160
	mov	rcx, rax
	call	_ZN5ArrayIjE5COUNTEv
	mov	DWORD PTR -4[rbp], eax
	mov	eax, DWORD PTR 24[rbp]
	cmp	DWORD PTR -4[rbp], eax
	jle	.L3455
	mov	eax, DWORD PTR 24[rbp]
	mov	rdx, QWORD PTR 16[rbp]
	lea	rcx, 160[rdx]
	mov	edx, eax
	call	_ZN5ArrayIjEixEi
	mov	QWORD PTR -16[rbp], rax
	mov	rax, QWORD PTR -16[rbp]
	mov	edx, DWORD PTR 32[rbp]
	mov	DWORD PTR [rax], edx
	jmp	.L3456
.L3452:
.L3453:
.L3455:
	nop
.L3454:
.L3456:
	nop
	add	rsp, 48
	pop	rbp
	ret
	.seh_endproc
	.globl	_ZN3TKO12SEMANTICINFO7SCOPEOFEj
	.def	_ZN3TKO12SEMANTICINFO7SCOPEOFEj;	.scl	2;	.type	32;	.endef
	.seh_proc	_ZN3TKO12SEMANTICINFO7SCOPEOFEj
_ZN3TKO12SEMANTICINFO7SCOPEOFEj:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 64
	.seh_stackalloc	64
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
	mov	DWORD PTR -20[rbp], 0
.L3458:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 160
	mov	rcx, rax
	call	_ZN5ArrayIjE5COUNTEv
	mov	DWORD PTR -4[rbp], eax
	mov	eax, DWORD PTR 24[rbp]
	cmp	DWORD PTR -4[rbp], eax
	jg	.L3464
	mov	DWORD PTR -20[rbp], 0
	jmp	.L3461
.L3464:
	nop
.L3460:
	mov	eax, DWORD PTR 24[rbp]
	mov	rdx, QWORD PTR 16[rbp]
	lea	rcx, 160[rdx]
	mov	edx, eax
	call	_ZN5ArrayIjEixEi
	mov	QWORD PTR -16[rbp], rax
	mov	rax, QWORD PTR -16[rbp]
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR -20[rbp], eax
	nop
.L3461:
	mov	eax, DWORD PTR -20[rbp]
	add	rsp, 64
	pop	rbp
	ret
	.seh_endproc
	.globl	_ZN3TKO12SEMANTICINFO12SETAMBIGUOUSEjNS_19AMBIGUOUSRESOLUTIONE
	.def	_ZN3TKO12SEMANTICINFO12SETAMBIGUOUSEjNS_19AMBIGUOUSRESOLUTIONE;	.scl	2;	.type	32;	.endef
	.seh_proc	_ZN3TKO12SEMANTICINFO12SETAMBIGUOUSEjNS_19AMBIGUOUSRESOLUTIONE
_ZN3TKO12SEMANTICINFO12SETAMBIGUOUSEjNS_19AMBIGUOUSRESOLUTIONE:
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
.L3466:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 240
	mov	rcx, rax
	call	_ZN5ArrayIhE5COUNTEv
	mov	DWORD PTR -4[rbp], eax
	mov	eax, DWORD PTR 24[rbp]
	cmp	DWORD PTR -4[rbp], eax
	jle	.L3471
	mov	eax, DWORD PTR 24[rbp]
	mov	rdx, QWORD PTR 16[rbp]
	lea	rcx, 240[rdx]
	mov	edx, eax
	call	_ZN5ArrayIhEixEi
	mov	QWORD PTR -16[rbp], rax
	mov	rax, QWORD PTR 32[rbp]
	mov	edx, eax
	mov	rax, QWORD PTR -16[rbp]
	mov	BYTE PTR [rax], dl
	jmp	.L3472
.L3468:
.L3469:
.L3471:
	nop
.L3470:
.L3472:
	nop
	add	rsp, 48
	pop	rbp
	ret
	.seh_endproc
	.globl	_ZN3TKO12SEMANTICINFO11AMBIGUOUSOFEj
	.def	_ZN3TKO12SEMANTICINFO11AMBIGUOUSOFEj;	.scl	2;	.type	32;	.endef
	.seh_proc	_ZN3TKO12SEMANTICINFO11AMBIGUOUSOFEj
_ZN3TKO12SEMANTICINFO11AMBIGUOUSOFEj:
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
.L3474:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 240
	mov	rcx, rax
	call	_ZN5ArrayIhE5COUNTEv
	mov	DWORD PTR -4[rbp], eax
	mov	eax, DWORD PTR 24[rbp]
	cmp	DWORD PTR -4[rbp], eax
	jg	.L3480
	mov	QWORD PTR -24[rbp], 0
	jmp	.L3477
.L3480:
	nop
.L3476:
	mov	eax, DWORD PTR 24[rbp]
	mov	rdx, QWORD PTR 16[rbp]
	lea	rcx, 240[rdx]
	mov	edx, eax
	call	_ZN5ArrayIhEixEi
	mov	QWORD PTR -16[rbp], rax
	mov	rax, QWORD PTR -16[rbp]
	movzx	eax, BYTE PTR [rax]
	movzx	eax, al
	mov	QWORD PTR -24[rbp], rax
	nop
.L3477:
	mov	rax, QWORD PTR -24[rbp]
	add	rsp, 64
	pop	rbp
	ret
	.seh_endproc
	.globl	_ZN3TKO7RESOLVE6STMTOFERNS0_3CTXEj
	.def	_ZN3TKO7RESOLVE6STMTOFERNS0_3CTXEj;	.scl	2;	.type	32;	.endef
	.seh_proc	_ZN3TKO7RESOLVE6STMTOFERNS0_3CTXEj
_ZN3TKO7RESOLVE6STMTOFERNS0_3CTXEj:
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
.L3482:
	cmp	DWORD PTR 24[rbp], 0
	jne	.L3488
	mov	QWORD PTR -24[rbp], 0
	jmp	.L3485
.L3488:
	nop
.L3484:
	mov	edx, DWORD PTR 24[rbp]
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN5ArrayIN3TKO7ASTNODEEEixEi
	mov	QWORD PTR -8[rbp], rax
	mov	rax, QWORD PTR -8[rbp]
	add	rax, 8
	mov	eax, DWORD PTR [rax]
	mov	rdx, QWORD PTR 16[rbp]
	mov	rdx, QWORD PTR [rdx]
	lea	rcx, 480[rdx]
	mov	edx, eax
	call	_ZN5ArrayIN3TKO11STMTPAYLOADEEixEi
	mov	QWORD PTR -16[rbp], rax
	mov	rax, QWORD PTR -16[rbp]
	mov	QWORD PTR -24[rbp], rax
	nop
.L3485:
	mov	rax, QWORD PTR -24[rbp]
	add	rsp, 64
	pop	rbp
	ret
	.seh_endproc
	.globl	_ZN3TKO7RESOLVE6LISTOFERNS0_3CTXEj
	.def	_ZN3TKO7RESOLVE6LISTOFERNS0_3CTXEj;	.scl	2;	.type	32;	.endef
	.seh_proc	_ZN3TKO7RESOLVE6LISTOFERNS0_3CTXEj
_ZN3TKO7RESOLVE6LISTOFERNS0_3CTXEj:
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
.L3490:
	cmp	DWORD PTR 24[rbp], 0
	jne	.L3496
	mov	QWORD PTR -24[rbp], 0
	jmp	.L3493
.L3496:
	nop
.L3492:
	mov	edx, DWORD PTR 24[rbp]
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN5ArrayIN3TKO7ASTNODEEEixEi
	mov	QWORD PTR -8[rbp], rax
	mov	rax, QWORD PTR -8[rbp]
	add	rax, 8
	mov	eax, DWORD PTR [rax]
	mov	rdx, QWORD PTR 16[rbp]
	mov	rdx, QWORD PTR [rdx]
	lea	rcx, 400[rdx]
	mov	edx, eax
	call	_ZN5ArrayIN3TKO11LISTPAYLOADEEixEi
	mov	QWORD PTR -16[rbp], rax
	mov	rax, QWORD PTR -16[rbp]
	mov	QWORD PTR -24[rbp], rax
	nop
.L3493:
	mov	rax, QWORD PTR -24[rbp]
	add	rsp, 64
	pop	rbp
	ret
	.seh_endproc
	.globl	_ZN3TKO7RESOLVE11IDENTNAMEOFERNS0_3CTXEj
	.def	_ZN3TKO7RESOLVE11IDENTNAMEOFERNS0_3CTXEj;	.scl	2;	.type	32;	.endef
	.seh_proc	_ZN3TKO7RESOLVE11IDENTNAMEOFERNS0_3CTXEj
_ZN3TKO7RESOLVE11IDENTNAMEOFERNS0_3CTXEj:
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
.L3498:
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 24[rbp]
	mov	rcx, rax
	call	_ZN3TKO8ASTARENA4KINDEj
	mov	QWORD PTR -8[rbp], rax
	cmp	QWORD PTR -8[rbp], 6
	je	.L3504
	mov	DWORD PTR -28[rbp], 0
	jmp	.L3501
.L3504:
	nop
.L3500:
	mov	edx, DWORD PTR 24[rbp]
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN5ArrayIN3TKO7ASTNODEEEixEi
	mov	QWORD PTR -16[rbp], rax
	mov	rax, QWORD PTR -16[rbp]
	add	rax, 8
	mov	eax, DWORD PTR [rax]
	mov	rdx, QWORD PTR 16[rbp]
	mov	rdx, QWORD PTR [rdx]
	lea	rcx, 320[rdx]
	mov	edx, eax
	call	_ZN5ArrayIN3TKO12IDENTPAYLOADEEixEi
	mov	QWORD PTR -24[rbp], rax
	mov	rax, QWORD PTR -24[rbp]
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR -28[rbp], eax
	nop
.L3501:
	mov	eax, DWORD PTR -28[rbp]
	add	rsp, 64
	pop	rbp
	ret
	.seh_endproc
	.section .rdata,"dr"
.LC0:
	.ascii "$tup\0"
.LC1:
	.ascii ":\0"
.LC2:
	.ascii "cva_list\0"
.LC3:
	.ascii ".\0"
.LC4:
	.ascii "\0"
	.text
	.globl	_ZN3TKO7RESOLVE14RESOLVETYPEREFERNS0_3CTXEjj
	.def	_ZN3TKO7RESOLVE14RESOLVETYPEREFERNS0_3CTXEjj;	.scl	2;	.type	32;	.endef
	.seh_proc	_ZN3TKO7RESOLVE14RESOLVETYPEREFERNS0_3CTXEjj
_ZN3TKO7RESOLVE14RESOLVETYPEREFERNS0_3CTXEjj:
	push	rbp
	.seh_pushreg	rbp
	push	rsi
	.seh_pushreg	rsi
	push	rbx
	.seh_pushreg	rbx
	sub	rsp, 1312
	.seh_stackalloc	1312
	lea	rbp, 128[rsp]
	.seh_setframe	rbp, 128
	.seh_endprologue
	mov	QWORD PTR 1216[rbp], rcx
	mov	DWORD PTR 1224[rbp], edx
	mov	DWORD PTR 1232[rbp], r8d
	mov	DWORD PTR 272[rbp], 0
.L3506:
	cmp	DWORD PTR 1224[rbp], 0
	jne	.L3847
	mov	DWORD PTR 272[rbp], 0
	jmp	.L3509
.L3847:
	nop
.L3508:
	mov	rax, QWORD PTR 1216[rbp]
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 1224[rbp]
	mov	rcx, rax
	call	_ZN3TKO8ASTARENA4KINDEj
	mov	QWORD PTR 1048[rbp], rax
	cmp	QWORD PTR 1048[rbp], 28
	je	.L3848
	mov	DWORD PTR 272[rbp], 0
	jmp	.L3509
.L3848:
	nop
.L3511:
	mov	edx, DWORD PTR 1224[rbp]
	mov	rax, QWORD PTR 1216[rbp]
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN5ArrayIN3TKO7ASTNODEEEixEi
	mov	QWORD PTR 1040[rbp], rax
	mov	rax, QWORD PTR 1040[rbp]
	mov	QWORD PTR 1032[rbp], rax
	mov	eax, DWORD PTR 1224[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 1216[rbp]
	call	_ZN3TKO7RESOLVE6STMTOFERNS0_3CTXEj
	mov	QWORD PTR 1024[rbp], rax
	mov	rax, QWORD PTR 1024[rbp]
	mov	QWORD PTR 1016[rbp], rax
	mov	rax, QWORD PTR 1216[rbp]
	add	rax, 56
	mov	rax, QWORD PTR [rax]
	add	rax, 12
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 1216[rbp]
	add	rax, 56
	mov	rax, QWORD PTR [rax]
	add	rax, 12
	add	edx, 1
	mov	DWORD PTR [rax], edx
	mov	rax, QWORD PTR 1032[rbp]
	add	rax, 2
	movzx	eax, WORD PTR [rax]
	movzx	eax, ax
	and	eax, 32
	test	rax, rax
	je	.L3849
	mov	rax, QWORD PTR 1016[rbp]
	add	rax, 4
	mov	eax, DWORD PTR [rax]
	mov	edx, DWORD PTR 1232[rbp]
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 1216[rbp]
	call	_ZN3TKO7RESOLVE14RESOLVETYPEREFERNS0_3CTXEjj
	mov	DWORD PTR 1012[rbp], eax
	mov	eax, DWORD PTR 1012[rbp]
	mov	DWORD PTR 1008[rbp], eax
	mov	rax, QWORD PTR 1216[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 1008[rbp]
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT8POINTER_Ej
	mov	DWORD PTR 1004[rbp], eax
	mov	eax, DWORD PTR 1004[rbp]
	mov	DWORD PTR 1164[rbp], eax
	mov	rax, QWORD PTR 1032[rbp]
	add	rax, 2
	movzx	eax, WORD PTR [rax]
	movzx	eax, ax
	and	eax, 8192
	test	rax, rax
	je	.L3850
	mov	rax, QWORD PTR 1216[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 1164[rbp]
	mov	r8d, 1
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT7QUALIFYEjt
	mov	DWORD PTR 1000[rbp], eax
	mov	eax, DWORD PTR 1000[rbp]
	mov	DWORD PTR 1164[rbp], eax
	jmp	.L3515
.L3850:
	nop
.L3515:
	mov	rax, QWORD PTR 1216[rbp]
	add	rax, 48
	mov	rax, QWORD PTR [rax]
	mov	ecx, DWORD PTR 1164[rbp]
	mov	edx, DWORD PTR 1224[rbp]
	mov	r8d, ecx
	mov	rcx, rax
	call	_ZN3TKO12SEMANTICINFO7SETTYPEEjj
	mov	eax, DWORD PTR 1164[rbp]
	mov	DWORD PTR 272[rbp], eax
	jmp	.L3509
.L3513:
.L3849:
	nop
.L3516:
	mov	rax, QWORD PTR 1032[rbp]
	add	rax, 2
	movzx	eax, WORD PTR [rax]
	movzx	eax, ax
	and	eax, 16384
	test	rax, rax
	je	.L3851
	mov	DWORD PTR 1160[rbp], 0
	mov	rax, QWORD PTR 1016[rbp]
	add	rax, 4
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	je	.L3852
	mov	rax, QWORD PTR 1016[rbp]
	add	rax, 4
	mov	eax, DWORD PTR [rax]
	mov	edx, DWORD PTR 1232[rbp]
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 1216[rbp]
	call	_ZN3TKO7RESOLVE14RESOLVETYPEREFERNS0_3CTXEjj
	mov	DWORD PTR 996[rbp], eax
	mov	eax, DWORD PTR 996[rbp]
	mov	DWORD PTR 1160[rbp], eax
	jmp	.L3521
.L3852:
	nop
.L3520:
	mov	rax, QWORD PTR 1216[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, 1
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT7BUILTINENS_11BUILTINTYPEE
	mov	DWORD PTR 992[rbp], eax
	mov	eax, DWORD PTR 992[rbp]
	mov	DWORD PTR 1160[rbp], eax
.L3521:
	mov	rax, QWORD PTR 1016[rbp]
	add	rax, 28
	mov	eax, DWORD PTR [rax]
	mov	eax, eax
	and	eax, 8192
	test	rax, rax
	je	.L3853
	cmp	DWORD PTR 1160[rbp], 0
	je	.L3854
	mov	rax, QWORD PTR 1216[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 1160[rbp]
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT9REFERENCEEj
	mov	DWORD PTR 988[rbp], eax
	mov	eax, DWORD PTR 988[rbp]
	mov	DWORD PTR 1160[rbp], eax
	jmp	.L3526
.L3523:
.L3525:
.L3853:
	nop
	jmp	.L3526
.L3854:
	nop
.L3526:
	lea	rax, -32[rbp]
	mov	rcx, rax
	call	_ZN5ArrayIjEC1Ev
	mov	BYTE PTR 1159[rbp], 0
	mov	DWORD PTR 1152[rbp], 0
	mov	rax, QWORD PTR 1016[rbp]
	add	rax, 20
	mov	eax, DWORD PTR [rax]
	sub	eax, 1
	mov	DWORD PTR 984[rbp], eax
	jmp	.L3527
.L3872:
	nop
.L3528:
	mov	rax, QWORD PTR 1016[rbp]
	add	rax, 16
	mov	edx, DWORD PTR [rax]
	mov	eax, DWORD PTR 1152[rbp]
	add	edx, eax
	mov	rax, QWORD PTR 1216[rbp]
	mov	rax, QWORD PTR [rax]
	add	rax, 560
	mov	rcx, rax
	call	_ZN5ArrayIjEixEi
	mov	QWORD PTR 960[rbp], rax
	mov	rax, QWORD PTR 960[rbp]
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR 956[rbp], eax
	mov	rax, QWORD PTR 1216[rbp]
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 956[rbp]
	mov	rcx, rax
	call	_ZN3TKO8ASTARENA4KINDEj
	mov	QWORD PTR 944[rbp], rax
	cmp	QWORD PTR 944[rbp], 66
	jne	.L3855
	nop
.L3530:
	mov	eax, DWORD PTR 956[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 1216[rbp]
	call	_ZN3TKO7RESOLVE6STMTOFERNS0_3CTXEj
	mov	QWORD PTR 936[rbp], rax
	mov	rax, QWORD PTR 936[rbp]
	add	rax, 24
	movzx	eax, WORD PTR [rax]
	cmp	ax, 18
	jne	.L3856
	mov	BYTE PTR 1159[rbp], 1
	jmp	.L3570
.L3533:
.L3856:
	nop
.L3534:
	mov	eax, DWORD PTR 956[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 1216[rbp]
	call	_ZN3TKO7RESOLVE6STMTOFERNS0_3CTXEj
	mov	QWORD PTR 928[rbp], rax
	mov	rax, QWORD PTR 928[rbp]
	mov	QWORD PTR 920[rbp], rax
	mov	rax, QWORD PTR 920[rbp]
	add	rax, 4
	mov	eax, DWORD PTR [rax]
	mov	edx, DWORD PTR 1232[rbp]
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 1216[rbp]
	call	_ZN3TKO7RESOLVE14RESOLVETYPEREFERNS0_3CTXEjj
	mov	DWORD PTR 916[rbp], eax
	mov	eax, DWORD PTR 916[rbp]
	mov	DWORD PTR 264[rbp], eax
	mov	edx, DWORD PTR 956[rbp]
	mov	rax, QWORD PTR 1216[rbp]
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN5ArrayIN3TKO7ASTNODEEEixEi
	mov	QWORD PTR 904[rbp], rax
	mov	rax, QWORD PTR 904[rbp]
	movzx	eax, WORD PTR 2[rax]
	mov	WORD PTR 902[rbp], ax
	movzx	eax, WORD PTR 902[rbp]
	and	eax, 16
	test	rax, rax
	setne	al
	mov	BYTE PTR 1135[rbp], al
	movzx	eax, BYTE PTR 1135[rbp]
	mov	BYTE PTR 1134[rbp], al
	cmp	BYTE PTR 1134[rbp], 0
	jne	.L3857
	movzx	eax, WORD PTR 902[rbp]
	and	eax, 256
	test	rax, rax
	setne	al
	mov	BYTE PTR 1134[rbp], al
	jmp	.L3536
.L3857:
	nop
.L3536:
	cmp	BYTE PTR 1134[rbp], 0
	jne	.L3858
	movzx	eax, WORD PTR 902[rbp]
	and	eax, 64
	test	rax, rax
	setne	al
	mov	BYTE PTR 1134[rbp], al
	jmp	.L3538
.L3858:
	nop
.L3538:
	cmp	BYTE PTR 1134[rbp], 0
	jne	.L3859
	mov	eax, DWORD PTR 264[rbp]
	test	eax, eax
	setne	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR 1144[rbp], rax
	jmp	.L3541
.L3859:
	nop
.L3540:
	mov	QWORD PTR 1144[rbp], 0
.L3541:
	cmp	QWORD PTR 1144[rbp], 0
	je	.L3860
	mov	edx, DWORD PTR 264[rbp]
	mov	rax, QWORD PTR 1216[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT9UNQUALIFYEj
	mov	DWORD PTR 896[rbp], eax
	mov	eax, DWORD PTR 896[rbp]
	mov	DWORD PTR 892[rbp], eax
	mov	rax, QWORD PTR 1216[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 892[rbp]
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT4KINDEj
	mov	QWORD PTR 880[rbp], rax
	cmp	QWORD PTR 880[rbp], 6
	sete	al
	mov	BYTE PTR 1135[rbp], al
	cmp	BYTE PTR 1135[rbp], 0
	jne	.L3861
	mov	rax, QWORD PTR 1216[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 892[rbp]
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT4KINDEj
	mov	QWORD PTR 872[rbp], rax
	cmp	QWORD PTR 872[rbp], 10
	sete	al
	mov	BYTE PTR 1135[rbp], al
	jmp	.L3545
.L3861:
	nop
.L3545:
	cmp	BYTE PTR 1135[rbp], 0
	jne	.L3862
	mov	rax, QWORD PTR 1216[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 892[rbp]
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT4KINDEj
	mov	QWORD PTR 864[rbp], rax
	cmp	QWORD PTR 864[rbp], 1
	jne	.L3863
	mov	rax, QWORD PTR 1216[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 892[rbp]
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT9BUILTINOFEj
	mov	QWORD PTR 856[rbp], rax
	mov	rax, QWORD PTR 856[rbp]
	mov	QWORD PTR 848[rbp], rax
	cmp	QWORD PTR 848[rbp], 15
	je	.L3864
	nop
.L3549:
	cmp	QWORD PTR 848[rbp], 16
	je	.L3865
	nop
.L3551:
	cmp	QWORD PTR 848[rbp], 17
	je	.L3866
	nop
.L3552:
	cmp	QWORD PTR 848[rbp], 18
	jne	.L3867
	jmp	.L3550
.L3864:
	nop
	jmp	.L3550
.L3865:
	nop
	jmp	.L3550
.L3866:
	nop
.L3550:
	mov	BYTE PTR 1135[rbp], 1
	jmp	.L3557
.L3547:
.L3553:
.L3554:
.L3555:
.L3556:
.L3862:
	nop
	jmp	.L3557
.L3863:
	nop
	jmp	.L3557
.L3867:
	nop
.L3557:
	cmp	BYTE PTR 1135[rbp], 0
	je	.L3868
	mov	edx, DWORD PTR 956[rbp]
	mov	rax, QWORD PTR 1216[rbp]
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN5ArrayIN3TKO7ASTNODEEEixEi
	mov	QWORD PTR 840[rbp], rax
	mov	rax, QWORD PTR 840[rbp]
	add	rax, 2
	mov	QWORD PTR 832[rbp], rax
	mov	rax, QWORD PTR 832[rbp]
	movzx	eax, WORD PTR [rax]
	or	eax, 16
	mov	edx, eax
	mov	rax, QWORD PTR 832[rbp]
	mov	WORD PTR [rax], dx
	jmp	.L3561
.L3543:
.L3559:
.L3560:
.L3860:
	nop
	jmp	.L3561
.L3868:
	nop
.L3561:
	movzx	eax, WORD PTR 902[rbp]
	and	eax, 64
	test	rax, rax
	je	.L3869
	mov	eax, DWORD PTR 264[rbp]
	test	eax, eax
	setne	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR 1136[rbp], rax
	jmp	.L3564
.L3869:
	nop
.L3563:
	mov	QWORD PTR 1136[rbp], 0
.L3564:
	cmp	QWORD PTR 1136[rbp], 0
	je	.L3870
	mov	rax, QWORD PTR 920[rbp]
	add	rax, 28
	mov	ecx, DWORD PTR [rax]
	mov	edx, DWORD PTR 264[rbp]
	mov	rax, QWORD PTR 1216[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	r8d, ecx
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT10DYNARRAYOFEji
	mov	DWORD PTR 828[rbp], eax
	mov	rax, QWORD PTR 1216[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 828[rbp]
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT9REFERENCEEj
	mov	DWORD PTR 824[rbp], eax
	mov	eax, DWORD PTR 824[rbp]
	mov	DWORD PTR 264[rbp], eax
	jmp	.L3569
.L3870:
	nop
.L3566:
	cmp	BYTE PTR 1135[rbp], 0
	je	.L3871
	mov	edx, DWORD PTR 264[rbp]
	mov	rax, QWORD PTR 1216[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT9REFERENCEEj
	mov	DWORD PTR 820[rbp], eax
	mov	eax, DWORD PTR 820[rbp]
	mov	DWORD PTR 264[rbp], eax
	jmp	.L3569
.L3567:
.L3871:
	nop
.L3569:
	lea	rdx, 264[rbp]
	lea	rax, -32[rbp]
	mov	rcx, rax
	call	_ZN5ArrayIjE4PUSHERj
	jmp	.L3570
.L3855:
	nop
.L3570:
	add	DWORD PTR 1152[rbp], 1
.L3527:
	mov	eax, DWORD PTR 1152[rbp]
	cmp	eax, DWORD PTR 984[rbp]
	jle	.L3872
	nop
.L3571:
	movsx	r8d, BYTE PTR 1159[rbp]
	mov	rax, QWORD PTR 1216[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	lea	rcx, -32[rbp]
	mov	edx, DWORD PTR 1160[rbp]
	mov	r9d, r8d
	mov	r8, rcx
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT8PROCTYPEEjR5ArrayIjEb
	mov	DWORD PTR 980[rbp], eax
	mov	rax, QWORD PTR 1216[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 980[rbp]
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT8POINTER_Ej
	mov	DWORD PTR 976[rbp], eax
	mov	eax, DWORD PTR 976[rbp]
	mov	DWORD PTR 1128[rbp], eax
	mov	rax, QWORD PTR 1032[rbp]
	add	rax, 2
	movzx	eax, WORD PTR [rax]
	movzx	eax, ax
	and	eax, 8192
	test	rax, rax
	je	.L3873
	mov	rax, QWORD PTR 1216[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 1128[rbp]
	mov	r8d, 1
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT7QUALIFYEjt
	mov	DWORD PTR 972[rbp], eax
	mov	eax, DWORD PTR 972[rbp]
	mov	DWORD PTR 1128[rbp], eax
	jmp	.L3574
.L3573:
.L3873:
	nop
.L3574:
	mov	rax, QWORD PTR 1216[rbp]
	add	rax, 48
	mov	rax, QWORD PTR [rax]
	mov	ecx, DWORD PTR 1128[rbp]
	mov	edx, DWORD PTR 1224[rbp]
	mov	r8d, ecx
	mov	rcx, rax
	call	_ZN3TKO12SEMANTICINFO7SETTYPEEjj
	mov	eax, DWORD PTR 1128[rbp]
	mov	DWORD PTR 272[rbp], eax
	lea	rax, -32[rbp]
	mov	rcx, rax
	call	_ZN5ArrayIjED1Ev
	jmp	.L3509
.L3518:
.L3851:
	nop
.L3575:
	mov	rax, QWORD PTR 1016[rbp]
	add	rax, 24
	movzx	eax, WORD PTR [rax]
	cmp	ax, 8
	jne	.L3874
	lea	rax, 240[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9d, 5
	lea	r8, .LC0[rip]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrInit
	lea	rax, -32[rbp]
	mov	rcx, rax
	call	_ZN5ArrayIjEC1Ev
	mov	DWORD PTR 1124[rbp], 0
	mov	rax, QWORD PTR 1016[rbp]
	add	rax, 20
	mov	eax, DWORD PTR [rax]
	sub	eax, 1
	mov	DWORD PTR 816[rbp], eax
	jmp	.L3578
.L3876:
	nop
.L3579:
	mov	rax, QWORD PTR 1016[rbp]
	add	rax, 16
	mov	edx, DWORD PTR [rax]
	mov	eax, DWORD PTR 1124[rbp]
	add	edx, eax
	mov	rax, QWORD PTR 1216[rbp]
	mov	rax, QWORD PTR [rax]
	add	rax, 560
	mov	rcx, rax
	call	_ZN5ArrayIjEixEi
	mov	QWORD PTR 792[rbp], rax
	mov	rax, QWORD PTR 792[rbp]
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR 788[rbp], eax
	mov	edx, DWORD PTR 1232[rbp]
	mov	eax, DWORD PTR 788[rbp]
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 1216[rbp]
	call	_ZN3TKO7RESOLVE14RESOLVETYPEREFERNS0_3CTXEjj
	mov	DWORD PTR 784[rbp], eax
	mov	eax, DWORD PTR 784[rbp]
	mov	DWORD PTR 236[rbp], eax
	mov	eax, DWORD PTR 236[rbp]
	test	eax, eax
	jne	.L3875
	mov	DWORD PTR 272[rbp], 0
	lea	rax, -32[rbp]
	mov	rcx, rax
	call	_ZN5ArrayIjED1Ev
	lea	rax, 240[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	jmp	.L3509
.L3581:
.L3875:
	nop
.L3583:
	lea	rdx, 236[rbp]
	lea	rax, -32[rbp]
	mov	rcx, rax
	call	_ZN5ArrayIjE4PUSHERj
	lea	rax, 240[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9d, 2
	lea	r8, .LC1[rip]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrConcatAssign
	mov	eax, DWORD PTR 236[rbp]
	mov	ecx, eax
	call	fb_IntToStr
	mov	QWORD PTR 776[rbp], rax
	mov	rdx, QWORD PTR 776[rbp]
	lea	rax, 240[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrConcatAssign
.L3584:
	add	DWORD PTR 1124[rbp], 1
.L3578:
	mov	eax, DWORD PTR 1124[rbp]
	cmp	eax, DWORD PTR 816[rbp]
	jle	.L3876
	nop
.L3585:
	mov	rax, QWORD PTR 1216[rbp]
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 1224[rbp]
	mov	rcx, rax
	call	_ZN3TKO8ASTARENA3LOCEj
	mov	DWORD PTR 812[rbp], eax
	mov	rax, QWORD PTR 1216[rbp]
	add	rax, 24
	mov	r8, QWORD PTR [rax]
	mov	rax, QWORD PTR 1216[rbp]
	add	rax, 16
	mov	rdx, QWORD PTR [rax]
	mov	rax, QWORD PTR 1216[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	lea	r9, -32[rbp]
	mov	ecx, DWORD PTR 812[rbp]
	mov	DWORD PTR 32[rsp], ecx
	mov	rcx, rax
	call	_ZN3TKO11TUPLEUDTFORERNS_11SYMBOLTABLEERNS_11TYPECONTEXTERNS_8INTERNERER5ArrayIjEj
	mov	DWORD PTR 808[rbp], eax
	mov	eax, DWORD PTR 808[rbp]
	mov	DWORD PTR 804[rbp], eax
	cmp	DWORD PTR 804[rbp], 0
	jne	.L3877
	mov	DWORD PTR 272[rbp], 0
	lea	rax, -32[rbp]
	mov	rcx, rax
	call	_ZN5ArrayIjED1Ev
	lea	rax, 240[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	jmp	.L3509
.L3877:
	nop
.L3587:
	mov	rax, QWORD PTR 1216[rbp]
	add	rax, 48
	mov	rax, QWORD PTR [rax]
	mov	ecx, DWORD PTR 804[rbp]
	mov	edx, DWORD PTR 1224[rbp]
	mov	r8d, ecx
	mov	rcx, rax
	call	_ZN3TKO12SEMANTICINFO7SETTYPEEjj
	mov	eax, DWORD PTR 804[rbp]
	mov	DWORD PTR 272[rbp], eax
	lea	rax, -32[rbp]
	mov	rcx, rax
	call	_ZN5ArrayIjED1Ev
	lea	rax, 240[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	jmp	.L3509
.L3577:
.L3874:
	nop
.L3588:
	mov	DWORD PTR 268[rbp], 0
	mov	rax, QWORD PTR 1016[rbp]
	add	rax, 24
	movzx	eax, WORD PTR [rax]
	movzx	eax, ax
	mov	QWORD PTR 768[rbp], rax
	cmp	QWORD PTR 768[rbp], 69
	jne	.L3878
	nop
.L3589:
	mov	rax, QWORD PTR 1216[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, 2
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT7BUILTINENS_11BUILTINTYPEE
	mov	DWORD PTR 764[rbp], eax
	mov	eax, DWORD PTR 764[rbp]
	mov	DWORD PTR 268[rbp], eax
	jmp	.L3754
.L3878:
	nop
.L3590:
	cmp	QWORD PTR 768[rbp], 266
	jne	.L3879
	nop
.L3592:
	mov	rax, QWORD PTR 1216[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, 3
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT7BUILTINENS_11BUILTINTYPEE
	mov	DWORD PTR 760[rbp], eax
	mov	eax, DWORD PTR 760[rbp]
	mov	DWORD PTR 268[rbp], eax
	jmp	.L3754
.L3879:
	nop
.L3593:
	cmp	QWORD PTR 768[rbp], 242
	jne	.L3880
	nop
.L3594:
	mov	rax, QWORD PTR 1216[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, 4
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT7BUILTINENS_11BUILTINTYPEE
	mov	DWORD PTR 756[rbp], eax
	mov	eax, DWORD PTR 756[rbp]
	mov	DWORD PTR 268[rbp], eax
	jmp	.L3754
.L3880:
	nop
.L3595:
	cmp	QWORD PTR 768[rbp], 275
	jne	.L3881
	nop
.L3596:
	mov	rax, QWORD PTR 1216[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, 5
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT7BUILTINENS_11BUILTINTYPEE
	mov	DWORD PTR 752[rbp], eax
	mov	eax, DWORD PTR 752[rbp]
	mov	DWORD PTR 268[rbp], eax
	jmp	.L3754
.L3881:
	nop
.L3597:
	cmp	QWORD PTR 768[rbp], 180
	jne	.L3882
	nop
.L3598:
	mov	rax, QWORD PTR 1216[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, 6
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT7BUILTINENS_11BUILTINTYPEE
	mov	DWORD PTR 748[rbp], eax
	mov	eax, DWORD PTR 748[rbp]
	mov	DWORD PTR 268[rbp], eax
	jmp	.L3754
.L3882:
	nop
.L3599:
	cmp	QWORD PTR 768[rbp], 269
	jne	.L3883
	nop
.L3600:
	mov	rax, QWORD PTR 1216[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, 7
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT7BUILTINENS_11BUILTINTYPEE
	mov	DWORD PTR 744[rbp], eax
	mov	eax, DWORD PTR 744[rbp]
	mov	DWORD PTR 268[rbp], eax
	jmp	.L3754
.L3883:
	nop
.L3601:
	cmp	QWORD PTR 768[rbp], 169
	jne	.L3884
	nop
.L3602:
	mov	rax, QWORD PTR 1216[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, 8
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT7BUILTINENS_11BUILTINTYPEE
	mov	DWORD PTR 740[rbp], eax
	mov	eax, DWORD PTR 740[rbp]
	mov	DWORD PTR 268[rbp], eax
	jmp	.L3754
.L3884:
	nop
.L3603:
	cmp	QWORD PTR 768[rbp], 268
	jne	.L3885
	nop
.L3604:
	mov	rax, QWORD PTR 1216[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, 9
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT7BUILTINENS_11BUILTINTYPEE
	mov	DWORD PTR 736[rbp], eax
	mov	eax, DWORD PTR 736[rbp]
	mov	DWORD PTR 268[rbp], eax
	jmp	.L3754
.L3885:
	nop
.L3605:
	cmp	QWORD PTR 768[rbp], 181
	jne	.L3886
	nop
.L3606:
	mov	rax, QWORD PTR 1216[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, 10
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT7BUILTINENS_11BUILTINTYPEE
	mov	DWORD PTR 732[rbp], eax
	mov	eax, DWORD PTR 732[rbp]
	mov	DWORD PTR 268[rbp], eax
	jmp	.L3754
.L3886:
	nop
.L3607:
	cmp	QWORD PTR 768[rbp], 270
	jne	.L3887
	nop
.L3608:
	mov	rax, QWORD PTR 1216[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, 11
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT7BUILTINENS_11BUILTINTYPEE
	mov	DWORD PTR 728[rbp], eax
	mov	eax, DWORD PTR 728[rbp]
	mov	DWORD PTR 268[rbp], eax
	jmp	.L3754
.L3887:
	nop
.L3609:
	cmp	QWORD PTR 768[rbp], 245
	jne	.L3888
	nop
.L3610:
	mov	rax, QWORD PTR 1216[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, 12
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT7BUILTINENS_11BUILTINTYPEE
	mov	DWORD PTR 724[rbp], eax
	mov	eax, DWORD PTR 724[rbp]
	mov	DWORD PTR 268[rbp], eax
	jmp	.L3754
.L3888:
	nop
.L3611:
	cmp	QWORD PTR 768[rbp], 131
	jne	.L3889
	nop
.L3612:
	mov	rax, QWORD PTR 1216[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, 13
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT7BUILTINENS_11BUILTINTYPEE
	mov	DWORD PTR 720[rbp], eax
	mov	eax, DWORD PTR 720[rbp]
	mov	DWORD PTR 268[rbp], eax
	jmp	.L3754
.L3889:
	nop
.L3613:
	cmp	QWORD PTR 768[rbp], 67
	jne	.L3890
	nop
.L3614:
	mov	rax, QWORD PTR 1216[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, 14
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT7BUILTINENS_11BUILTINTYPEE
	mov	DWORD PTR 716[rbp], eax
	mov	eax, DWORD PTR 716[rbp]
	mov	DWORD PTR 268[rbp], eax
	jmp	.L3754
.L3890:
	nop
.L3615:
	cmp	QWORD PTR 768[rbp], 253
	jne	.L3891
	nop
.L3616:
	mov	rax, QWORD PTR 1216[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, 15
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT7BUILTINENS_11BUILTINTYPEE
	mov	DWORD PTR 712[rbp], eax
	mov	eax, DWORD PTR 712[rbp]
	mov	DWORD PTR 268[rbp], eax
	jmp	.L3754
.L3891:
	nop
.L3617:
	cmp	QWORD PTR 768[rbp], 294
	jne	.L3892
	nop
.L3618:
	mov	rax, QWORD PTR 1216[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, 16
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT7BUILTINENS_11BUILTINTYPEE
	mov	DWORD PTR 708[rbp], eax
	mov	eax, DWORD PTR 708[rbp]
	mov	DWORD PTR 268[rbp], eax
	jmp	.L3754
.L3892:
	nop
.L3619:
	cmp	QWORD PTR 768[rbp], 292
	jne	.L3893
	nop
.L3620:
	mov	rax, QWORD PTR 1216[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, 17
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT7BUILTINENS_11BUILTINTYPEE
	mov	DWORD PTR 704[rbp], eax
	mov	eax, DWORD PTR 704[rbp]
	mov	DWORD PTR 268[rbp], eax
	jmp	.L3754
.L3893:
	nop
.L3621:
	cmp	QWORD PTR 768[rbp], 277
	jne	.L3894
	nop
.L3622:
	mov	rax, QWORD PTR 1216[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, 18
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT7BUILTINENS_11BUILTINTYPEE
	mov	DWORD PTR 700[rbp], eax
	mov	eax, DWORD PTR 700[rbp]
	mov	DWORD PTR 268[rbp], eax
	jmp	.L3754
.L3894:
	nop
.L3623:
	cmp	QWORD PTR 768[rbp], 57
	jne	.L3895
	nop
.L3624:
	mov	rax, QWORD PTR 1216[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, 21
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT7BUILTINENS_11BUILTINTYPEE
	mov	DWORD PTR 696[rbp], eax
	mov	eax, DWORD PTR 696[rbp]
	mov	DWORD PTR 268[rbp], eax
	jmp	.L3754
.L3895:
	nop
.L3625:
	cmp	QWORD PTR 768[rbp], 273
	jne	.L3896
	nop
.L3626:
	mov	rax, QWORD PTR 1016[rbp]
	mov	ecx, DWORD PTR [rax]
	mov	rax, QWORD PTR 1216[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 1232[rbp]
	mov	r9d, 1
	mov	r8d, ecx
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE11LOOKUPTYPEDEjjb
	mov	DWORD PTR 692[rbp], eax
	mov	eax, DWORD PTR 692[rbp]
	mov	DWORD PTR 688[rbp], eax
	cmp	DWORD PTR 688[rbp], 0
	je	.L3897
	mov	rax, QWORD PTR 1216[rbp]
	add	rax, 48
	mov	rax, QWORD PTR [rax]
	mov	ecx, DWORD PTR 688[rbp]
	mov	edx, DWORD PTR 1224[rbp]
	mov	r8d, ecx
	mov	rcx, rax
	call	_ZN3TKO12SEMANTICINFO6SETREFEjj
	mov	rax, QWORD PTR 1216[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 688[rbp]
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE8SYMBOLATEj
	mov	QWORD PTR 680[rbp], rax
	mov	rax, QWORD PTR 680[rbp]
	mov	QWORD PTR 672[rbp], rax
	mov	rax, QWORD PTR 672[rbp]
	add	rax, 16
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	je	.L3898
	mov	rax, QWORD PTR 672[rbp]
	add	rax, 16
	mov	eax, DWORD PTR [rax]
	mov	edx, eax
	mov	rcx, QWORD PTR 1216[rbp]
	call	_ZN3TKO7RESOLVE19UNSIGNEDCOUNTERPARTERNS0_3CTXEj
	mov	DWORD PTR 668[rbp], eax
	mov	eax, DWORD PTR 668[rbp]
	mov	DWORD PTR 268[rbp], eax
	jmp	.L3754
.L3629:
.L3631:
.L3632:
.L3897:
	nop
	jmp	.L3754
.L3898:
	nop
.L3633:
	jmp	.L3754
.L3896:
	nop
.L3627:
	cmp	QWORD PTR 768[rbp], 264
	jne	.L3899
	nop
.L3634:
	mov	rax, QWORD PTR 1016[rbp]
	add	rax, 8
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	je	.L3900
	mov	rax, QWORD PTR 1016[rbp]
	add	rax, 8
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 1216[rbp]
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN3TKO8ASTARENA4KINDEj
	mov	QWORD PTR 656[rbp], rax
	cmp	QWORD PTR 656[rbp], 28
	jne	.L3901
	mov	rax, QWORD PTR 1016[rbp]
	add	rax, 8
	mov	eax, DWORD PTR [rax]
	mov	edx, DWORD PTR 1232[rbp]
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 1216[rbp]
	call	_ZN3TKO7RESOLVE14RESOLVETYPEREFERNS0_3CTXEjj
	mov	DWORD PTR 652[rbp], eax
	mov	eax, DWORD PTR 652[rbp]
	mov	DWORD PTR 1120[rbp], eax
	cmp	DWORD PTR 1120[rbp], 0
	je	.L3902
	mov	rax, QWORD PTR 1216[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 1120[rbp]
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT4KINDEj
	mov	QWORD PTR 640[rbp], rax
	cmp	QWORD PTR 640[rbp], 3
	jne	.L3903
	mov	rax, QWORD PTR 1216[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 1120[rbp]
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT5INNEREj
	mov	DWORD PTR 636[rbp], eax
	mov	eax, DWORD PTR 636[rbp]
	mov	DWORD PTR 1120[rbp], eax
	jmp	.L3644
.L3643:
.L3903:
	nop
.L3644:
	mov	eax, DWORD PTR 1120[rbp]
	mov	DWORD PTR 268[rbp], eax
	jmp	.L3649
.L3641:
.L3902:
	nop
.L3645:
	jmp	.L3649
.L3901:
	nop
.L3639:
	mov	rax, QWORD PTR 1016[rbp]
	add	rax, 8
	mov	eax, DWORD PTR [rax]
	lea	rcx, 268[rbp]
	mov	edx, DWORD PTR 1232[rbp]
	mov	r9, rcx
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 1216[rbp]
	call	_ZN3TKO7RESOLVE18TYPELITTARGETTYPE_ERNS0_3CTXEjjRj
	mov	BYTE PTR 635[rbp], al
	cmp	BYTE PTR 635[rbp], 0
	jne	.L3904
	nop
.L3647:
	mov	rax, QWORD PTR 1016[rbp]
	add	rax, 8
	mov	eax, DWORD PTR [rax]
	mov	edx, DWORD PTR 1232[rbp]
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 1216[rbp]
	call	_ZN3TKO7RESOLVE8WALKEXPRERNS0_3CTXEjj
	jmp	.L3649
.L3637:
.L3648:
.L3900:
	nop
	jmp	.L3649
.L3904:
	nop
.L3649:
	mov	rax, QWORD PTR 1016[rbp]
	add	rax, 40
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	je	.L3905
	mov	rax, QWORD PTR 1016[rbp]
	add	rax, 40
	mov	ecx, DWORD PTR [rax]
	mov	rax, QWORD PTR 1216[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 1232[rbp]
	mov	r8d, ecx
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE6LOOKUPEjj
	mov	DWORD PTR 628[rbp], eax
	mov	eax, DWORD PTR 628[rbp]
	mov	DWORD PTR 624[rbp], eax
	cmp	DWORD PTR 624[rbp], 0
	je	.L3906
	mov	rax, QWORD PTR 1216[rbp]
	add	rax, 48
	mov	rax, QWORD PTR [rax]
	mov	ecx, DWORD PTR 624[rbp]
	mov	edx, DWORD PTR 1224[rbp]
	mov	r8d, ecx
	mov	rcx, rax
	call	_ZN3TKO12SEMANTICINFO6SETREFEjj
	jmp	.L3653
.L3906:
	nop
.L3653:
	mov	rax, QWORD PTR 1216[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 624[rbp]
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE8SYMBOLATEj
	mov	QWORD PTR 616[rbp], rax
	mov	rax, QWORD PTR 616[rbp]
	mov	QWORD PTR 608[rbp], rax
	cmp	QWORD PTR 608[rbp], 0
	je	.L3907
	mov	rax, QWORD PTR 608[rbp]
	add	rax, 16
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	jne	.L3908
	mov	rax, QWORD PTR 608[rbp]
	movzx	eax, BYTE PTR [rax]
	cmp	al, 1
	jne	.L3909
	mov	rax, QWORD PTR 608[rbp]
	add	rax, 40
	mov	rax, QWORD PTR [rax]
	mov	DWORD PTR 604[rbp], eax
	cmp	DWORD PTR 604[rbp], 0
	je	.L3910
	mov	rax, QWORD PTR 1216[rbp]
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 604[rbp]
	mov	rcx, rax
	call	_ZN3TKO8ASTARENA4KINDEj
	mov	QWORD PTR 592[rbp], rax
	cmp	QWORD PTR 592[rbp], 58
	jne	.L3911
	mov	eax, DWORD PTR 604[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 1216[rbp]
	call	_ZN3TKO7RESOLVE6STMTOFERNS0_3CTXEj
	mov	QWORD PTR 584[rbp], rax
	mov	rax, QWORD PTR 584[rbp]
	mov	eax, DWORD PTR 8[rax]
	mov	DWORD PTR 580[rbp], eax
	cmp	DWORD PTR 580[rbp], 0
	je	.L3912
	mov	rax, QWORD PTR 1216[rbp]
	add	rax, 48
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 580[rbp]
	mov	rcx, rax
	call	_ZN3TKO12SEMANTICINFO7TYPEOF_Ej
	mov	DWORD PTR 576[rbp], eax
	mov	eax, DWORD PTR 576[rbp]
	mov	DWORD PTR 572[rbp], eax
	cmp	DWORD PTR 572[rbp], 0
	je	.L3913
	mov	rax, QWORD PTR 608[rbp]
	lea	rdx, 16[rax]
	mov	eax, DWORD PTR 572[rbp]
	mov	DWORD PTR [rdx], eax
	jmp	.L3671
.L3656:
.L3662:
.L3663:
.L3664:
.L3665:
.L3666:
.L3667:
.L3668:
.L3669:
.L3670:
.L3908:
	nop
	jmp	.L3671
.L3909:
	nop
	jmp	.L3671
.L3910:
	nop
	jmp	.L3671
.L3911:
	nop
	jmp	.L3671
.L3912:
	nop
	jmp	.L3671
.L3913:
	nop
.L3671:
	mov	rax, QWORD PTR 608[rbp]
	add	rax, 16
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	je	.L3914
	mov	rax, QWORD PTR 608[rbp]
	mov	eax, DWORD PTR 16[rax]
	mov	DWORD PTR 268[rbp], eax
	mov	edx, DWORD PTR 268[rbp]
	mov	rax, QWORD PTR 1216[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT4KINDEj
	mov	QWORD PTR 560[rbp], rax
	cmp	QWORD PTR 560[rbp], 3
	jne	.L3915
	mov	edx, DWORD PTR 268[rbp]
	mov	rax, QWORD PTR 1216[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT5INNEREj
	mov	DWORD PTR 556[rbp], eax
	mov	eax, DWORD PTR 556[rbp]
	mov	DWORD PTR 268[rbp], eax
	jmp	.L3754
.L3651:
.L3674:
.L3675:
.L3676:
.L3677:
.L3678:
.L3679:
.L3905:
	nop
	jmp	.L3754
.L3907:
	nop
	jmp	.L3754
.L3914:
	nop
	jmp	.L3754
.L3915:
	nop
.L3680:
	jmp	.L3754
.L3899:
	nop
.L3635:
	mov	rax, QWORD PTR 1016[rbp]
	add	rax, 36
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	jne	.L3916
	mov	rax, QWORD PTR 1016[rbp]
	mov	ecx, DWORD PTR [rax]
	mov	rax, QWORD PTR 1216[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 1232[rbp]
	mov	r9d, 1
	mov	r8d, ecx
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE11LOOKUPTYPEDEjjb
	mov	DWORD PTR 552[rbp], eax
	cmp	DWORD PTR 552[rbp], 0
	jne	.L3917
	lea	rax, 208[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	rax, QWORD PTR 1016[rbp]
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 1216[rbp]
	add	rax, 24
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN3TKO8INTERNER8SPELLINGEj
	mov	QWORD PTR 544[rbp], rax
	mov	rdx, QWORD PTR 544[rbp]
	lea	rax, 208[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrAssign
	lea	rax, 208[rbp]
	mov	rcx, rax
	call	_ZN3TKO4TEXT10LOWERASCIIE8FBSTRING
	mov	QWORD PTR 536[rbp], rax
	mov	rax, QWORD PTR 536[rbp]
	mov	r9d, 9
	lea	r8, .LC2[rip]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrCompare
	mov	DWORD PTR 532[rbp], eax
	cmp	DWORD PTR 532[rbp], 0
	sete	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR 520[rbp], rax
	lea	rax, 208[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	cmp	QWORD PTR 520[rbp], 0
	je	.L3918
	mov	rax, QWORD PTR 1216[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, 20
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT7BUILTINENS_11BUILTINTYPEE
	mov	DWORD PTR 516[rbp], eax
	mov	eax, DWORD PTR 516[rbp]
	mov	DWORD PTR 268[rbp], eax
	jmp	.L3689
.L3685:
.L3686:
.L3682:
.L3687:
.L3688:
.L3916:
	nop
	jmp	.L3689
.L3917:
	nop
	jmp	.L3689
.L3918:
	nop
.L3689:
	mov	rax, QWORD PTR 1216[rbp]
	add	rax, 792
	mov	rcx, rax
	call	_ZN5ArrayIjE5COUNTEv
	mov	DWORD PTR 512[rbp], eax
	mov	eax, DWORD PTR 512[rbp]
	sub	eax, 1
	mov	DWORD PTR 1116[rbp], eax
	jmp	.L3690
.L3920:
	nop
.L3691:
	mov	rax, QWORD PTR 1216[rbp]
	lea	rcx, 792[rax]
	mov	eax, DWORD PTR 1116[rbp]
	mov	edx, eax
	call	_ZN5ArrayIjEixEi
	mov	QWORD PTR 328[rbp], rax
	mov	rax, QWORD PTR 328[rbp]
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 1016[rbp]
	mov	eax, DWORD PTR [rax]
	cmp	edx, eax
	jne	.L3919
	mov	rax, QWORD PTR 1216[rbp]
	lea	rcx, 872[rax]
	mov	eax, DWORD PTR 1116[rbp]
	mov	edx, eax
	call	_ZN5ArrayIjEixEi
	mov	QWORD PTR 320[rbp], rax
	mov	rax, QWORD PTR 320[rbp]
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR 268[rbp], eax
	mov	ecx, DWORD PTR 268[rbp]
	mov	rax, QWORD PTR 1216[rbp]
	add	rax, 48
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 1224[rbp]
	mov	r8d, ecx
	mov	rcx, rax
	call	_ZN3TKO12SEMANTICINFO7SETTYPEEjj
	mov	eax, DWORD PTR 268[rbp]
	mov	DWORD PTR 272[rbp], eax
	jmp	.L3509
.L3693:
.L3694:
.L3919:
	nop
.L3695:
	sub	DWORD PTR 1116[rbp], 1
.L3690:
	cmp	DWORD PTR 1116[rbp], 0
	jns	.L3920
	nop
.L3696:
	mov	DWORD PTR 1112[rbp], 0
	mov	rax, QWORD PTR 1016[rbp]
	add	rax, 36
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	je	.L3921
	mov	rax, QWORD PTR 1016[rbp]
	add	rax, 36
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 1216[rbp]
	add	rax, 24
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN3TKO8INTERNER8SPELLINGEj
	mov	QWORD PTR 504[rbp], rax
	mov	rdx, QWORD PTR 504[rbp]
	lea	rax, 176[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrInit
	mov	eax, DWORD PTR 1232[rbp]
	mov	DWORD PTR 1104[rbp], eax
	mov	BYTE PTR 1103[rbp], 1
	mov	BYTE PTR 1102[rbp], 1
	mov	DWORD PTR 1096[rbp], 0
	lea	rax, 176[rbp]
	mov	edx, 1
	mov	rcx, rax
	call	fb_LEFT
	mov	QWORD PTR 496[rbp], rax
	mov	rax, QWORD PTR 496[rbp]
	mov	r9d, 2
	lea	r8, .LC3[rip]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrCompare
	mov	DWORD PTR 492[rbp], eax
	cmp	DWORD PTR 492[rbp], 0
	jne	.L3922
	mov	eax, DWORD PTR 1232[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 1216[rbp]
	call	_ZN3TKO7RESOLVE12FILESCOPEOF_ERNS0_3CTXEj
	mov	DWORD PTR 488[rbp], eax
	mov	eax, DWORD PTR 488[rbp]
	mov	DWORD PTR 1104[rbp], eax
	mov	DWORD PTR 1096[rbp], 1
	jmp	.L3730
.L3922:
	nop
.L3700:
	lea	rax, 176[rbp]
	mov	r9d, 1
	lea	r8, .LC4[rip]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrCompare
	mov	DWORD PTR 484[rbp], eax
	cmp	DWORD PTR 484[rbp], 0
	jne	.L3923
	mov	eax, DWORD PTR 1232[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 1216[rbp]
	call	_ZN3TKO7RESOLVE12FILESCOPEOF_ERNS0_3CTXEj
	mov	DWORD PTR 480[rbp], eax
	mov	eax, DWORD PTR 480[rbp]
	mov	DWORD PTR 1104[rbp], eax
	mov	BYTE PTR 1103[rbp], 0
	lea	rax, 176[rbp]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrLen
	mov	QWORD PTR 472[rbp], rax
	mov	rax, QWORD PTR 472[rbp]
	add	eax, 1
	mov	DWORD PTR 1096[rbp], eax
	jmp	.L3730
.L3701:
.L3703:
.L3923:
	nop
.L3704:
.L3730:
	lea	rax, 176[rbp]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrLen
	mov	QWORD PTR 464[rbp], rax
	mov	eax, DWORD PTR 1096[rbp]
	cdqe
	cmp	QWORD PTR 464[rbp], rax
	jl	.L3924
	mov	edx, 1
	lea	rcx, .LC3[rip]
	call	fb_StrAllocTempDescZEx
	mov	QWORD PTR 456[rbp], rax
	mov	eax, DWORD PTR 1096[rbp]
	cdqe
	lea	rcx, 1[rax]
	mov	rdx, QWORD PTR 456[rbp]
	lea	rax, 176[rbp]
	mov	r8, rdx
	mov	rdx, rax
	call	fb_StrInstr
	mov	QWORD PTR 448[rbp], rax
	mov	rax, QWORD PTR 448[rbp]
	mov	DWORD PTR 444[rbp], eax
	mov	eax, DWORD PTR 444[rbp]
	mov	DWORD PTR 1076[rbp], eax
	cmp	DWORD PTR 1076[rbp], 0
	jne	.L3925
	lea	rax, 176[rbp]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrLen
	mov	QWORD PTR 432[rbp], rax
	mov	rax, QWORD PTR 432[rbp]
	add	eax, 1
	mov	DWORD PTR 1076[rbp], eax
	jmp	.L3708
.L3925:
	nop
.L3708:
	mov	eax, DWORD PTR 1076[rbp]
	movsx	rdx, eax
	mov	eax, DWORD PTR 1096[rbp]
	cdqe
	sub	rdx, rax
	mov	rax, rdx
	lea	rcx, -1[rax]
	mov	eax, DWORD PTR 1096[rbp]
	cdqe
	lea	rdx, 1[rax]
	lea	rax, 176[rbp]
	mov	r8, rcx
	mov	rcx, rax
	call	fb_StrMid
	mov	QWORD PTR 424[rbp], rax
	mov	rdx, QWORD PTR 424[rbp]
	lea	rax, 112[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrInit
	lea	rax, 112[rbp]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrLen
	mov	QWORD PTR 416[rbp], rax
	cmp	QWORD PTR 416[rbp], 0
	jne	.L3926
	mov	BYTE PTR 1102[rbp], 0
	lea	rax, 112[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	jmp	.L3706
.L3710:
.L3926:
	nop
.L3712:
	lea	rax, 144[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	lea	rdx, 112[rbp]
	lea	rax, 144[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrAssign
	mov	rax, QWORD PTR 1216[rbp]
	add	rax, 24
	mov	rax, QWORD PTR [rax]
	lea	rdx, 144[rbp]
	mov	rcx, rax
	call	_ZN3TKO8INTERNER9GETSTRINGE8FBSTRING
	mov	DWORD PTR 412[rbp], eax
	mov	eax, DWORD PTR 412[rbp]
	mov	DWORD PTR 408[rbp], eax
	lea	rax, 144[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	mov	DWORD PTR 108[rbp], 0
	cmp	BYTE PTR 1103[rbp], 0
	je	.L3927
	mov	rax, QWORD PTR 1216[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	ecx, DWORD PTR 408[rbp]
	mov	edx, DWORD PTR 1104[rbp]
	mov	r8d, ecx
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE6LOOKUPEjj
	mov	DWORD PTR 404[rbp], eax
	mov	eax, DWORD PTR 404[rbp]
	mov	DWORD PTR 108[rbp], eax
	jmp	.L3715
.L3927:
	nop
.L3714:
	mov	rax, QWORD PTR 1216[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	ecx, DWORD PTR 408[rbp]
	mov	edx, DWORD PTR 1104[rbp]
	mov	r9d, 1
	mov	r8d, ecx
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE16LOOKUPLOCALTYPEDEjjb
	mov	DWORD PTR 400[rbp], eax
	mov	eax, DWORD PTR 400[rbp]
	mov	DWORD PTR 108[rbp], eax
.L3715:
	mov	edx, DWORD PTR 108[rbp]
	mov	rax, QWORD PTR 1216[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE8SYMBOLATEj
	mov	QWORD PTR 392[rbp], rax
	mov	rax, QWORD PTR 392[rbp]
	mov	QWORD PTR 384[rbp], rax
	cmp	QWORD PTR 384[rbp], 0
	jne	.L3928
	mov	BYTE PTR 1102[rbp], 0
	lea	rax, 112[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	jmp	.L3706
.L3717:
.L3928:
	nop
.L3718:
	mov	rax, QWORD PTR 384[rbp]
	movzx	eax, BYTE PTR [rax]
	cmp	al, 10
	je	.L3929
	mov	rax, QWORD PTR 384[rbp]
	movzx	eax, BYTE PTR [rax]
	cmp	al, 6
	sete	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR 1088[rbp], rax
	jmp	.L3721
.L3929:
	nop
.L3720:
	mov	QWORD PTR 1088[rbp], -1
.L3721:
	cmp	QWORD PTR 1088[rbp], 0
	setne	al
	mov	BYTE PTR 383[rbp], al
	cmp	BYTE PTR 383[rbp], 0
	je	.L3930
	mov	rax, QWORD PTR 384[rbp]
	add	rax, 36
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	sete	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR 1080[rbp], rax
	jmp	.L3724
.L3930:
	nop
.L3723:
	mov	QWORD PTR 1080[rbp], -1
.L3724:
	cmp	QWORD PTR 1080[rbp], 0
	je	.L3931
	mov	BYTE PTR 1102[rbp], 0
	lea	rax, 112[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	jmp	.L3706
.L3726:
.L3931:
	nop
.L3727:
	mov	rax, QWORD PTR 384[rbp]
	mov	eax, DWORD PTR 36[rax]
	mov	DWORD PTR 1104[rbp], eax
	mov	BYTE PTR 1103[rbp], 0
	cmp	DWORD PTR 444[rbp], 0
	jne	.L3932
	lea	rax, 112[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	jmp	.L3706
.L3932:
	nop
.L3729:
	mov	eax, DWORD PTR 444[rbp]
	mov	DWORD PTR 1096[rbp], eax
	lea	rax, 112[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	jmp	.L3730
.L3924:
	nop
.L3706:
	cmp	BYTE PTR 1102[rbp], 0
	je	.L3933
	cmp	BYTE PTR 1103[rbp], 0
	sete	al
	mov	BYTE PTR 1111[rbp], al
	jmp	.L3733
.L3933:
	nop
.L3732:
	mov	BYTE PTR 1111[rbp], 0
.L3733:
	cmp	BYTE PTR 1111[rbp], 0
	je	.L3934
	mov	rax, QWORD PTR 1016[rbp]
	mov	ecx, DWORD PTR [rax]
	mov	rax, QWORD PTR 1216[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 1104[rbp]
	mov	r9d, 1
	mov	r8d, ecx
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE16LOOKUPLOCALTYPEDEjjb
	mov	DWORD PTR 376[rbp], eax
	mov	eax, DWORD PTR 376[rbp]
	mov	DWORD PTR 1112[rbp], eax
	jmp	.L3736
.L3735:
.L3934:
	nop
.L3736:
	lea	rax, 176[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	jmp	.L3737
.L3698:
.L3921:
	nop
.L3737:
	cmp	DWORD PTR 1112[rbp], 0
	jne	.L3935
	mov	rax, QWORD PTR 1016[rbp]
	mov	edx, DWORD PTR [rax]
	mov	ecx, DWORD PTR 1224[rbp]
	mov	eax, DWORD PTR 1232[rbp]
	mov	r9d, ecx
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 1216[rbp]
	call	_ZN3TKO7RESOLVE18LOOKUPTYPEATPOINT_ERNS0_3CTXEjjj
	mov	DWORD PTR 372[rbp], eax
	mov	eax, DWORD PTR 372[rbp]
	mov	DWORD PTR 1112[rbp], eax
	jmp	.L3740
.L3739:
.L3935:
	nop
.L3740:
	mov	rax, QWORD PTR 1016[rbp]
	add	rax, 20
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	jle	.L3936
	mov	r8d, DWORD PTR 1232[rbp]
	mov	rcx, QWORD PTR 1016[rbp]
	mov	eax, DWORD PTR 1224[rbp]
	mov	edx, DWORD PTR 1112[rbp]
	mov	DWORD PTR 32[rsp], edx
	mov	r9d, r8d
	mov	r8, rcx
	mov	edx, eax
	mov	rcx, QWORD PTR 1216[rbp]
	call	_ZN3TKO7RESOLVE19INSTANTIATEGENERIC_ERNS0_3CTXEjPNS_11STMTPAYLOADEjj
	mov	DWORD PTR 368[rbp], eax
	mov	eax, DWORD PTR 368[rbp]
	mov	DWORD PTR 364[rbp], eax
	cmp	DWORD PTR 364[rbp], 0
	je	.L3937
	mov	rax, QWORD PTR 1216[rbp]
	add	rax, 48
	mov	rax, QWORD PTR [rax]
	mov	ecx, DWORD PTR 364[rbp]
	mov	edx, DWORD PTR 1224[rbp]
	mov	r8d, ecx
	mov	rcx, rax
	call	_ZN3TKO12SEMANTICINFO7SETTYPEEjj
	mov	eax, DWORD PTR 364[rbp]
	mov	DWORD PTR 272[rbp], eax
	jmp	.L3509
.L3742:
.L3744:
.L3745:
.L3936:
	nop
	jmp	.L3746
.L3937:
	nop
.L3746:
	cmp	DWORD PTR 1112[rbp], 0
	je	.L3938
	mov	rax, QWORD PTR 1216[rbp]
	add	rax, 48
	mov	rax, QWORD PTR [rax]
	mov	ecx, DWORD PTR 1112[rbp]
	mov	edx, DWORD PTR 1224[rbp]
	mov	r8d, ecx
	mov	rcx, rax
	call	_ZN3TKO12SEMANTICINFO6SETREFEjj
	mov	rax, QWORD PTR 1216[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 1112[rbp]
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE8SYMBOLATEj
	mov	QWORD PTR 352[rbp], rax
	mov	rax, QWORD PTR 352[rbp]
	mov	QWORD PTR 344[rbp], rax
	mov	rax, QWORD PTR 344[rbp]
	add	rax, 16
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	setne	al
	mov	BYTE PTR 1075[rbp], al
	cmp	BYTE PTR 1075[rbp], 0
	je	.L3939
	mov	rax, QWORD PTR 344[rbp]
	add	rax, 16
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 1216[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT4KINDEj
	mov	QWORD PTR 336[rbp], rax
	cmp	QWORD PTR 336[rbp], 8
	setne	al
	mov	BYTE PTR 1075[rbp], al
	jmp	.L3749
.L3939:
	nop
.L3749:
	cmp	BYTE PTR 1075[rbp], 0
	je	.L3940
	mov	rax, QWORD PTR 344[rbp]
	mov	eax, DWORD PTR 16[rax]
	mov	DWORD PTR 268[rbp], eax
	jmp	.L3754
.L3591:
.L3751:
.L3752:
.L3753:
.L3938:
	nop
	jmp	.L3754
.L3940:
	nop
.L3754:
	cmp	QWORD PTR 768[rbp], 264
	jne	.L3941
	mov	eax, DWORD PTR 268[rbp]
	test	eax, eax
	setne	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR 1176[rbp], rax
	jmp	.L3757
.L3941:
	nop
.L3756:
	mov	QWORD PTR 1176[rbp], 0
.L3757:
	cmp	QWORD PTR 1176[rbp], 0
	je	.L3942
	mov	edx, DWORD PTR 268[rbp]
	mov	rax, QWORD PTR 1216[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT4KINDEj
	mov	QWORD PTR 312[rbp], rax
	cmp	QWORD PTR 312[rbp], 1
	jne	.L3943
	mov	edx, DWORD PTR 268[rbp]
	mov	rax, QWORD PTR 1216[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT9BUILTINOFEj
	mov	QWORD PTR 304[rbp], rax
	mov	rax, QWORD PTR 304[rbp]
	mov	QWORD PTR 296[rbp], rax
	cmp	QWORD PTR 296[rbp], 16
	je	.L3944
	cmp	QWORD PTR 296[rbp], 17
	sete	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR 1064[rbp], rax
	jmp	.L3763
.L3944:
	nop
.L3762:
	mov	QWORD PTR 1064[rbp], -1
.L3763:
	cmp	QWORD PTR 1064[rbp], 0
	je	.L3945
	mov	edx, DWORD PTR 268[rbp]
	mov	rax, QWORD PTR 1216[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	QWORD PTR 32[rsp], 0
	mov	r9d, 1
	mov	r8d, 1
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT7ARRAYOFEjiiP5ArrayIxE
	mov	DWORD PTR 292[rbp], eax
	mov	eax, DWORD PTR 292[rbp]
	mov	DWORD PTR 268[rbp], eax
	jmp	.L3769
.L3759:
.L3765:
.L3766:
.L3767:
.L3768:
.L3942:
	nop
	jmp	.L3769
.L3943:
	nop
	jmp	.L3769
.L3945:
	nop
.L3769:
	mov	rax, QWORD PTR 1016[rbp]
	add	rax, 12
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	je	.L3946
	mov	eax, DWORD PTR 268[rbp]
	test	eax, eax
	setne	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR 1168[rbp], rax
	jmp	.L3772
.L3946:
	nop
.L3771:
	mov	QWORD PTR 1168[rbp], 0
.L3772:
	cmp	QWORD PTR 1168[rbp], 0
	je	.L3947
	cmp	QWORD PTR 768[rbp], 294
	je	.L3948
	nop
.L3775:
	cmp	QWORD PTR 768[rbp], 292
	je	.L3949
	nop
.L3777:
	cmp	QWORD PTR 768[rbp], 277
	je	.L3950
	nop
.L3778:
	cmp	QWORD PTR 768[rbp], 253
	jne	.L3951
	jmp	.L3776
.L3948:
	nop
	jmp	.L3776
.L3949:
	nop
	jmp	.L3776
.L3950:
	nop
.L3776:
	mov	rax, QWORD PTR 1216[rbp]
	add	rax, 48
	mov	r11, QWORD PTR [rax]
	mov	rax, QWORD PTR 1216[rbp]
	add	rax, 16
	mov	r10, QWORD PTR [rax]
	mov	rax, QWORD PTR 1216[rbp]
	add	rax, 8
	mov	r9, QWORD PTR [rax]
	mov	rax, QWORD PTR 1216[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	add	rax, 248
	mov	r8d, DWORD PTR [rax]
	mov	rax, QWORD PTR 1216[rbp]
	add	rax, 24
	mov	rcx, QWORD PTR [rax]
	mov	rax, QWORD PTR 1216[rbp]
	add	rax, 32
	mov	rsi, QWORD PTR [rax]
	mov	rax, QWORD PTR 1016[rbp]
	add	rax, 12
	mov	ebx, DWORD PTR [rax]
	mov	rax, QWORD PTR 1216[rbp]
	mov	rdx, QWORD PTR [rax]
	lea	rax, 48[rbp]
	mov	QWORD PTR 80[rsp], r11
	mov	QWORD PTR 72[rsp], r10
	mov	DWORD PTR 64[rsp], 0
	mov	r10d, DWORD PTR 1232[rbp]
	mov	DWORD PTR 56[rsp], r10d
	mov	QWORD PTR 48[rsp], r9
	mov	DWORD PTR 40[rsp], r8d
	mov	QWORD PTR 32[rsp], rcx
	mov	r9, rsi
	mov	r8d, ebx
	mov	rcx, rax
	call	_ZN3TKO5CHECK7CONSTOFERNS_8ASTARENAEjRNS_13SOURCEMANAGERERNS_8INTERNEREiPNS_11SYMBOLTABLEEjiPNS_11TYPECONTEXTEPNS_12SEMANTICINFOE
	mov	rax, QWORD PTR 48[rbp]
	mov	rdx, QWORD PTR 56[rbp]
	mov	QWORD PTR 80[rbp], rax
	mov	QWORD PTR 88[rbp], rdx
	mov	rax, QWORD PTR 64[rbp]
	mov	QWORD PTR 96[rbp], rax
	lea	rax, 80[rbp]
	movzx	eax, BYTE PTR [rax]
	movsx	eax, al
	neg	eax
	test	eax, eax
	je	.L3952
	lea	rax, 80[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	test	rax, rax
	setg	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR 1056[rbp], rax
	jmp	.L3781
.L3952:
	nop
.L3780:
	mov	QWORD PTR 1056[rbp], 0
.L3781:
	cmp	QWORD PTR 1056[rbp], 0
	je	.L3953
	cmp	QWORD PTR 768[rbp], 253
	jne	.L3954
	mov	rax, QWORD PTR 1216[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, 19
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT7BUILTINENS_11BUILTINTYPEE
	mov	DWORD PTR 288[rbp], eax
	mov	eax, DWORD PTR 288[rbp]
	mov	DWORD PTR 268[rbp], eax
	jmp	.L3785
.L3954:
	nop
.L3785:
	cmp	QWORD PTR 768[rbp], 277
	jne	.L3955
	mov	rax, QWORD PTR 1216[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, 22
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT7BUILTINENS_11BUILTINTYPEE
	mov	DWORD PTR 284[rbp], eax
	mov	eax, DWORD PTR 284[rbp]
	mov	DWORD PTR 268[rbp], eax
	jmp	.L3787
.L3955:
	nop
.L3787:
	lea	rax, 80[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	ecx, eax
	mov	edx, DWORD PTR 268[rbp]
	mov	rax, QWORD PTR 1216[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	QWORD PTR 32[rsp], 0
	mov	r9d, ecx
	mov	r8d, 1
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT7ARRAYOFEjiiP5ArrayIxE
	mov	DWORD PTR 280[rbp], eax
	mov	eax, DWORD PTR 280[rbp]
	mov	DWORD PTR 268[rbp], eax
	jmp	.L3791
.L3783:
.L3788:
.L3774:
.L3789:
.L3790:
.L3947:
	nop
	jmp	.L3791
.L3951:
	nop
	jmp	.L3791
.L3953:
	nop
.L3791:
	mov	rax, QWORD PTR 1032[rbp]
	add	rax, 2
	movzx	eax, WORD PTR [rax]
	movzx	eax, ax
	and	eax, 8192
	test	rax, rax
	je	.L3956
	mov	edx, DWORD PTR 268[rbp]
	mov	rax, QWORD PTR 1216[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	r8d, 1
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT7QUALIFYEjt
	mov	DWORD PTR 276[rbp], eax
	mov	eax, DWORD PTR 276[rbp]
	mov	DWORD PTR 268[rbp], eax
	jmp	.L3794
.L3793:
.L3956:
	nop
.L3794:
	mov	ecx, DWORD PTR 268[rbp]
	mov	rax, QWORD PTR 1216[rbp]
	add	rax, 48
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 1224[rbp]
	mov	r8d, ecx
	mov	rcx, rax
	call	_ZN3TKO12SEMANTICINFO7SETTYPEEjj
	mov	eax, DWORD PTR 268[rbp]
	mov	DWORD PTR 272[rbp], eax
	nop
.L3509:
	mov	eax, DWORD PTR 272[rbp]
	add	rsp, 1312
	pop	rbx
	pop	rsi
	pop	rbp
	ret
	.seh_endproc
	.globl	_ZN3TKO7RESOLVE14BINDPARAMTYPE_ERNS0_3CTXEjj
	.def	_ZN3TKO7RESOLVE14BINDPARAMTYPE_ERNS0_3CTXEjj;	.scl	2;	.type	32;	.endef
	.seh_proc	_ZN3TKO7RESOLVE14BINDPARAMTYPE_ERNS0_3CTXEjj
_ZN3TKO7RESOLVE14BINDPARAMTYPE_ERNS0_3CTXEjj:
	push	rbp
	.seh_pushreg	rbp
	sub	rsp, 368
	.seh_stackalloc	368
	lea	rbp, 128[rsp]
	.seh_setframe	rbp, 128
	.seh_endprologue
	mov	QWORD PTR 256[rbp], rcx
	mov	DWORD PTR 264[rbp], edx
	mov	DWORD PTR 272[rbp], r8d
	mov	DWORD PTR 32[rbp], 0
.L3958:
	mov	eax, DWORD PTR 264[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 256[rbp]
	call	_ZN3TKO7RESOLVE6STMTOFERNS0_3CTXEj
	mov	QWORD PTR 168[rbp], rax
	mov	rax, QWORD PTR 168[rbp]
	mov	QWORD PTR 160[rbp], rax
	mov	rax, QWORD PTR 160[rbp]
	add	rax, 4
	mov	eax, DWORD PTR [rax]
	mov	edx, DWORD PTR 272[rbp]
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 256[rbp]
	call	_ZN3TKO7RESOLVE14RESOLVETYPEREFERNS0_3CTXEjj
	mov	DWORD PTR 156[rbp], eax
	mov	eax, DWORD PTR 156[rbp]
	mov	DWORD PTR 204[rbp], eax
	cmp	DWORD PTR 204[rbp], 0
	je	.L4015
	mov	edx, DWORD PTR 264[rbp]
	mov	rax, QWORD PTR 256[rbp]
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN5ArrayIN3TKO7ASTNODEEEixEi
	mov	QWORD PTR 144[rbp], rax
	mov	rax, QWORD PTR 144[rbp]
	add	rax, 2
	movzx	eax, WORD PTR [rax]
	movzx	eax, ax
	and	eax, 64
	test	rax, rax
	setne	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR 232[rbp], rax
	jmp	.L3961
.L4015:
	nop
.L3960:
	mov	QWORD PTR 232[rbp], 0
.L3961:
	cmp	QWORD PTR 232[rbp], 0
	je	.L4016
	mov	rax, QWORD PTR 160[rbp]
	add	rax, 28
	mov	ecx, DWORD PTR [rax]
	mov	rax, QWORD PTR 256[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 204[rbp]
	mov	r8d, ecx
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT10DYNARRAYOFEji
	mov	DWORD PTR 140[rbp], eax
	mov	eax, DWORD PTR 140[rbp]
	mov	DWORD PTR 204[rbp], eax
	jmp	.L3964
.L3963:
.L4016:
	nop
.L3964:
	cmp	DWORD PTR 204[rbp], 0
	je	.L4017
	mov	edx, DWORD PTR 264[rbp]
	mov	rax, QWORD PTR 256[rbp]
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN5ArrayIN3TKO7ASTNODEEEixEi
	mov	QWORD PTR 128[rbp], rax
	mov	rax, QWORD PTR 128[rbp]
	movzx	eax, WORD PTR 2[rax]
	mov	WORD PTR 126[rbp], ax
	movzx	eax, WORD PTR 126[rbp]
	and	eax, 16
	test	rax, rax
	setne	al
	mov	BYTE PTR 125[rbp], al
	movsx	eax, BYTE PTR 125[rbp]
	neg	eax
	test	eax, eax
	jne	.L4018
	movzx	eax, WORD PTR 126[rbp]
	and	eax, 256
	test	rax, rax
	setne	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR 192[rbp], rax
	jmp	.L3969
.L4018:
	nop
.L3968:
	mov	QWORD PTR 192[rbp], -1
.L3969:
	cmp	QWORD PTR 192[rbp], 0
	setne	al
	mov	BYTE PTR 125[rbp], al
	movsx	eax, BYTE PTR 125[rbp]
	neg	eax
	test	eax, eax
	jne	.L4019
	movzx	eax, WORD PTR 126[rbp]
	and	eax, 64
	test	rax, rax
	setne	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR 184[rbp], rax
	jmp	.L3972
.L4019:
	nop
.L3971:
	mov	QWORD PTR 184[rbp], -1
.L3972:
	cmp	QWORD PTR 184[rbp], 0
	setne	al
	mov	BYTE PTR 125[rbp], al
	cmp	BYTE PTR 125[rbp], 0
	jne	.L4020
	mov	rax, QWORD PTR 256[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 204[rbp]
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT9UNQUALIFYEj
	mov	DWORD PTR 120[rbp], eax
	mov	eax, DWORD PTR 120[rbp]
	mov	DWORD PTR 116[rbp], eax
	mov	rax, QWORD PTR 256[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 116[rbp]
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT4KINDEj
	mov	QWORD PTR 104[rbp], rax
	cmp	QWORD PTR 104[rbp], 6
	sete	al
	mov	BYTE PTR 183[rbp], al
	cmp	BYTE PTR 183[rbp], 0
	jne	.L4021
	mov	rax, QWORD PTR 256[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 116[rbp]
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT4KINDEj
	mov	QWORD PTR 96[rbp], rax
	cmp	QWORD PTR 96[rbp], 1
	jne	.L4022
	mov	rax, QWORD PTR 256[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 116[rbp]
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT9BUILTINOFEj
	mov	QWORD PTR 88[rbp], rax
	mov	rax, QWORD PTR 88[rbp]
	mov	QWORD PTR 80[rbp], rax
	cmp	QWORD PTR 80[rbp], 15
	je	.L4023
	nop
.L3977:
	cmp	QWORD PTR 80[rbp], 16
	je	.L4024
	nop
.L3979:
	cmp	QWORD PTR 80[rbp], 17
	je	.L4025
	nop
.L3980:
	cmp	QWORD PTR 80[rbp], 18
	jne	.L4026
	jmp	.L3978
.L4023:
	nop
	jmp	.L3978
.L4024:
	nop
	jmp	.L3978
.L4025:
	nop
.L3978:
	mov	BYTE PTR 183[rbp], 1
	jmp	.L3985
.L3975:
.L3981:
.L3982:
.L3983:
.L3984:
.L4021:
	nop
	jmp	.L3985
.L4022:
	nop
	jmp	.L3985
.L4026:
	nop
.L3985:
	cmp	BYTE PTR 183[rbp], 0
	je	.L4027
	mov	edx, DWORD PTR 264[rbp]
	mov	rax, QWORD PTR 256[rbp]
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN5ArrayIN3TKO7ASTNODEEEixEi
	mov	QWORD PTR 72[rbp], rax
	mov	rax, QWORD PTR 72[rbp]
	add	rax, 2
	mov	QWORD PTR 64[rbp], rax
	mov	rax, QWORD PTR 64[rbp]
	movzx	eax, WORD PTR [rax]
	or	eax, 16
	mov	edx, eax
	mov	rax, QWORD PTR 64[rbp]
	mov	WORD PTR [rax], dx
	jmp	.L3991
.L3966:
.L3987:
.L3988:
.L3989:
.L3990:
.L4017:
	nop
	jmp	.L3991
.L4020:
	nop
	jmp	.L3991
.L4027:
	nop
.L3991:
	cmp	DWORD PTR 204[rbp], 0
	jne	.L4028
	mov	rax, QWORD PTR 160[rbp]
	add	rax, 4
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	sete	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR 224[rbp], rax
	jmp	.L3994
.L4028:
	nop
.L3993:
	mov	QWORD PTR 224[rbp], 0
.L3994:
	cmp	QWORD PTR 224[rbp], 0
	je	.L4029
	mov	rax, QWORD PTR 160[rbp]
	add	rax, 24
	movzx	eax, WORD PTR [rax]
	cmp	ax, 18
	setne	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR 216[rbp], rax
	jmp	.L3997
.L4029:
	nop
.L3996:
	mov	QWORD PTR 216[rbp], 0
.L3997:
	cmp	QWORD PTR 216[rbp], 0
	je	.L4030
	lea	rax, -64[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	lea	rax, -64[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9d, 1
	lea	r8, .LC4[rip]
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
	lea	r8, .LC4[rip]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrAssign
	mov	rax, rbp
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	rax, QWORD PTR 160[rbp]
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 256[rbp]
	add	rax, 24
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN3TKO8INTERNER8SPELLINGEj
	mov	QWORD PTR 56[rbp], rax
	mov	rdx, QWORD PTR 56[rbp]
	mov	rax, rbp
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrAssign
	mov	rax, QWORD PTR 256[rbp]
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 264[rbp]
	mov	rcx, rax
	call	_ZN3TKO8ASTARENA3LOCEj
	mov	DWORD PTR 52[rbp], eax
	mov	eax, DWORD PTR 52[rbp]
	mov	ecx, eax
	call	_ZN3TKO10POINTRANGEEj
	mov	QWORD PTR -72[rbp], rax
	mov	rax, QWORD PTR 256[rbp]
	add	rax, 40
	mov	rax, QWORD PTR [rax]
	mov	r8, rbp
	mov	rcx, QWORD PTR -72[rbp]
	lea	rdx, -64[rbp]
	mov	QWORD PTR 40[rsp], rdx
	lea	rdx, -32[rbp]
	mov	QWORD PTR 32[rsp], rdx
	mov	r9, r8
	mov	r8, rcx
	mov	edx, 41
	mov	rcx, rax
	call	_ZN3TKO16DIAGNOSTICENGINE6REPORTENS_6DIAGIDENS_11SOURCERANGEE8FBSTRINGS3_S3_
	lea	rax, -64[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	lea	rax, -32[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	mov	rax, rbp
	mov	rcx, rax
	call	fb_StrDelete
	jmp	.L4000
.L3999:
.L4030:
	nop
.L4000:
	cmp	DWORD PTR 204[rbp], 0
	je	.L4031
	mov	edx, DWORD PTR 264[rbp]
	mov	rax, QWORD PTR 256[rbp]
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN5ArrayIN3TKO7ASTNODEEEixEi
	mov	QWORD PTR 40[rbp], rax
	mov	rax, QWORD PTR 40[rbp]
	add	rax, 2
	movzx	eax, WORD PTR [rax]
	movzx	eax, ax
	and	eax, 16
	test	rax, rax
	setne	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR 208[rbp], rax
	jmp	.L4003
.L4031:
	nop
.L4002:
	mov	QWORD PTR 208[rbp], 0
.L4003:
	cmp	QWORD PTR 208[rbp], 0
	je	.L4032
	mov	rax, QWORD PTR 256[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 204[rbp]
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT9REFERENCEEj
	mov	DWORD PTR 36[rbp], eax
	mov	eax, DWORD PTR 36[rbp]
	mov	DWORD PTR 204[rbp], eax
	jmp	.L4006
.L4005:
.L4032:
	nop
.L4006:
	mov	rax, QWORD PTR 160[rbp]
	mov	edx, DWORD PTR [rax]
	mov	ecx, DWORD PTR 204[rbp]
	mov	eax, DWORD PTR 272[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9d, ecx
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 256[rbp]
	call	_ZN3TKO7RESOLVE12BINDDECLTYPEERNS0_3CTXEjjjb
	mov	eax, DWORD PTR 204[rbp]
	mov	DWORD PTR 32[rbp], eax
	nop
.L4007:
	mov	eax, DWORD PTR 32[rbp]
	add	rsp, 368
	pop	rbp
	ret
	.seh_endproc
	.globl	_ZN3TKO7RESOLVE12SLOTSOFTYPE_ERNS0_3CTXEji
	.def	_ZN3TKO7RESOLVE12SLOTSOFTYPE_ERNS0_3CTXEji;	.scl	2;	.type	32;	.endef
	.seh_proc	_ZN3TKO7RESOLVE12SLOTSOFTYPE_ERNS0_3CTXEji
_ZN3TKO7RESOLVE12SLOTSOFTYPE_ERNS0_3CTXEji:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 96
	.seh_stackalloc	96
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
	mov	DWORD PTR 32[rbp], r8d
	mov	DWORD PTR -52[rbp], 0
.L4034:
	cmp	DWORD PTR 24[rbp], 0
	jne	.L4061
	mov	DWORD PTR -52[rbp], -1
	jmp	.L4037
.L4061:
	nop
.L4036:
	cmp	DWORD PTR 32[rbp], 16
	jle	.L4062
	mov	DWORD PTR -52[rbp], -1
	jmp	.L4037
.L4062:
	nop
.L4039:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 24[rbp]
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT9UNQUALIFYEj
	mov	DWORD PTR -4[rbp], eax
	mov	eax, DWORD PTR -4[rbp]
	mov	DWORD PTR -8[rbp], eax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR -8[rbp]
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT4KINDEj
	mov	QWORD PTR -16[rbp], rax
	mov	rax, QWORD PTR -16[rbp]
	mov	QWORD PTR -24[rbp], rax
	cmp	QWORD PTR -24[rbp], 6
	jne	.L4063
	nop
.L4040:
	mov	edx, DWORD PTR 32[rbp]
	mov	eax, DWORD PTR -8[rbp]
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN3TKO7RESOLVE11SLOTSOFUDT_ERNS0_3CTXEji
	mov	DWORD PTR -28[rbp], eax
	mov	eax, DWORD PTR -28[rbp]
	mov	DWORD PTR -52[rbp], eax
	jmp	.L4037
.L4063:
	nop
.L4041:
	cmp	QWORD PTR -24[rbp], 2
	je	.L4064
	nop
.L4042:
	cmp	QWORD PTR -24[rbp], 7
	jne	.L4065
	jmp	.L4043
.L4064:
	nop
.L4043:
	mov	DWORD PTR -52[rbp], 1
	jmp	.L4037
.L4065:
	nop
.L4044:
	cmp	QWORD PTR -24[rbp], 1
	jne	.L4066
	nop
.L4045:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR -8[rbp]
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT9BUILTINOFEj
	mov	QWORD PTR -40[rbp], rax
	mov	rax, QWORD PTR -40[rbp]
	mov	QWORD PTR -48[rbp], rax
	cmp	QWORD PTR -48[rbp], 15
	je	.L4067
	nop
.L4047:
	cmp	QWORD PTR -48[rbp], 16
	je	.L4068
	nop
.L4049:
	cmp	QWORD PTR -48[rbp], 17
	je	.L4069
	nop
.L4050:
	cmp	QWORD PTR -48[rbp], 18
	jne	.L4070
	jmp	.L4048
.L4067:
	nop
	jmp	.L4048
.L4068:
	nop
	jmp	.L4048
.L4069:
	nop
.L4048:
	mov	DWORD PTR -52[rbp], -1
	jmp	.L4037
.L4051:
.L4070:
	nop
.L4052:
	mov	DWORD PTR -52[rbp], 1
	jmp	.L4037
.L4046:
.L4066:
	nop
.L4053:
	mov	DWORD PTR -52[rbp], -1
	nop
.L4037:
	mov	eax, DWORD PTR -52[rbp]
	add	rsp, 96
	pop	rbp
	ret
	.seh_endproc
	.globl	_ZN3TKO7RESOLVE12UDTHASPROCS_ERNS0_3CTXEji
	.def	_ZN3TKO7RESOLVE12UDTHASPROCS_ERNS0_3CTXEji;	.scl	2;	.type	32;	.endef
	.seh_proc	_ZN3TKO7RESOLVE12UDTHASPROCS_ERNS0_3CTXEji
_ZN3TKO7RESOLVE12UDTHASPROCS_ERNS0_3CTXEji:
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
	mov	BYTE PTR -66[rbp], 0
.L4072:
	cmp	DWORD PTR 24[rbp], 0
	jne	.L4107
	mov	BYTE PTR -66[rbp], 0
	jmp	.L4075
.L4107:
	nop
.L4074:
	cmp	DWORD PTR 32[rbp], 16
	jle	.L4108
	mov	BYTE PTR -66[rbp], 0
	jmp	.L4075
.L4108:
	nop
.L4077:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 24[rbp]
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE8SYMBOLATEj
	mov	QWORD PTR -24[rbp], rax
	mov	rax, QWORD PTR -24[rbp]
	mov	QWORD PTR -32[rbp], rax
	cmp	QWORD PTR -32[rbp], 0
	jne	.L4109
	mov	BYTE PTR -66[rbp], 0
	jmp	.L4075
.L4109:
	nop
.L4079:
	mov	rax, QWORD PTR -32[rbp]
	add	rax, 36
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	jne	.L4110
	mov	BYTE PTR -66[rbp], 0
	jmp	.L4075
.L4110:
	nop
.L4081:
	mov	rax, QWORD PTR -32[rbp]
	add	rax, 36
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE7SCOPEATEj
	mov	QWORD PTR -40[rbp], rax
	mov	rax, QWORD PTR -40[rbp]
	mov	QWORD PTR -48[rbp], rax
	cmp	QWORD PTR -48[rbp], 0
	jne	.L4111
	mov	BYTE PTR -66[rbp], 0
	jmp	.L4075
.L4111:
	nop
.L4083:
	mov	rax, QWORD PTR -48[rbp]
	mov	eax, DWORD PTR 12[rax]
	mov	DWORD PTR -12[rbp], eax
	mov	DWORD PTR -16[rbp], 0
.L4084:
	cmp	DWORD PTR -12[rbp], 0
	je	.L4112
	cmp	DWORD PTR -16[rbp], 99999
	setle	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -8[rbp], rax
	jmp	.L4087
.L4112:
	nop
.L4086:
	mov	QWORD PTR -8[rbp], 0
.L4087:
	cmp	QWORD PTR -8[rbp], 0
	je	.L4113
	add	DWORD PTR -16[rbp], 1
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR -12[rbp]
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE8SYMBOLATEj
	mov	QWORD PTR -56[rbp], rax
	mov	rax, QWORD PTR -56[rbp]
	mov	QWORD PTR -64[rbp], rax
	cmp	QWORD PTR -64[rbp], 0
	je	.L4114
	nop
.L4091:
	mov	rax, QWORD PTR -64[rbp]
	movzx	eax, BYTE PTR [rax]
	cmp	al, 5
	jne	.L4115
	mov	BYTE PTR -66[rbp], 1
	jmp	.L4075
.L4115:
	nop
.L4093:
	mov	rax, QWORD PTR -64[rbp]
	movzx	eax, BYTE PTR [rax]
	cmp	al, 4
	jne	.L4116
	mov	rax, QWORD PTR -64[rbp]
	add	rax, 16
	mov	eax, DWORD PTR [rax]
	mov	edx, DWORD PTR 32[rbp]
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN3TKO7RESOLVE16TYPEBRINGSPROCS_ERNS0_3CTXEji
	mov	BYTE PTR -65[rbp], al
	cmp	BYTE PTR -65[rbp], 0
	je	.L4117
	mov	BYTE PTR -66[rbp], 1
	jmp	.L4075
.L4095:
.L4097:
.L4116:
	nop
	jmp	.L4098
.L4117:
	nop
.L4098:
	mov	rax, QWORD PTR -64[rbp]
	mov	eax, DWORD PTR 32[rax]
	mov	DWORD PTR -12[rbp], eax
	jmp	.L4084
.L4113:
	nop
	jmp	.L4089
.L4114:
	nop
.L4089:
	mov	BYTE PTR -66[rbp], 0
	nop
.L4075:
	movzx	eax, BYTE PTR -66[rbp]
	add	rsp, 112
	pop	rbp
	ret
	.seh_endproc
	.globl	_ZN3TKO7RESOLVE11INITCOUNTATERNS0_3CTXEji
	.def	_ZN3TKO7RESOLVE11INITCOUNTATERNS0_3CTXEji;	.scl	2;	.type	32;	.endef
	.seh_proc	_ZN3TKO7RESOLVE11INITCOUNTATERNS0_3CTXEji
_ZN3TKO7RESOLVE11INITCOUNTATERNS0_3CTXEji:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 96
	.seh_stackalloc	96
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
	mov	DWORD PTR 32[rbp], r8d
	mov	DWORD PTR -60[rbp], 0
.L4119:
	mov	eax, DWORD PTR 24[rbp]
	mov	DWORD PTR -4[rbp], eax
	mov	DWORD PTR -8[rbp], 0
	mov	eax, DWORD PTR 32[rbp]
	mov	DWORD PTR -12[rbp], eax
	jmp	.L4120
.L4143:
	nop
.L4121:
	cmp	DWORD PTR -4[rbp], 0
	jne	.L4139
	mov	DWORD PTR -60[rbp], -1
	jmp	.L4124
.L4139:
	nop
.L4123:
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR -4[rbp]
	mov	rcx, rax
	call	_ZN3TKO8ASTARENA4KINDEj
	mov	QWORD PTR -24[rbp], rax
	cmp	QWORD PTR -24[rbp], 20
	je	.L4140
	mov	DWORD PTR -60[rbp], -1
	jmp	.L4124
.L4140:
	nop
.L4126:
	mov	edx, DWORD PTR -4[rbp]
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN5ArrayIN3TKO7ASTNODEEEixEi
	mov	QWORD PTR -32[rbp], rax
	mov	rax, QWORD PTR -32[rbp]
	add	rax, 8
	mov	eax, DWORD PTR [rax]
	mov	rdx, QWORD PTR 16[rbp]
	mov	rdx, QWORD PTR [rdx]
	lea	rcx, 400[rdx]
	mov	edx, eax
	call	_ZN5ArrayIN3TKO11LISTPAYLOADEEixEi
	mov	QWORD PTR -40[rbp], rax
	mov	rax, QWORD PTR -40[rbp]
	mov	QWORD PTR -48[rbp], rax
	mov	eax, DWORD PTR -8[rbp]
	cmp	eax, DWORD PTR 32[rbp]
	jne	.L4141
	mov	rax, QWORD PTR -48[rbp]
	mov	eax, DWORD PTR 8[rax]
	mov	DWORD PTR -60[rbp], eax
	jmp	.L4124
.L4141:
	nop
.L4128:
	mov	rax, QWORD PTR -48[rbp]
	add	rax, 8
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	jne	.L4142
	mov	DWORD PTR -60[rbp], -1
	jmp	.L4124
.L4142:
	nop
.L4130:
	mov	rax, QWORD PTR -48[rbp]
	add	rax, 4
	mov	eax, DWORD PTR [rax]
	mov	rdx, QWORD PTR 16[rbp]
	mov	rdx, QWORD PTR [rdx]
	lea	rcx, 560[rdx]
	mov	edx, eax
	call	_ZN5ArrayIjEixEi
	mov	QWORD PTR -56[rbp], rax
	mov	rax, QWORD PTR -56[rbp]
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR -4[rbp], eax
.L4131:
	add	DWORD PTR -8[rbp], 1
.L4120:
	mov	eax, DWORD PTR -8[rbp]
	cmp	eax, DWORD PTR -12[rbp]
	jle	.L4143
	nop
.L4132:
	mov	DWORD PTR -60[rbp], -1
	nop
.L4124:
	mov	eax, DWORD PTR -60[rbp]
	add	rsp, 96
	pop	rbp
	ret
	.seh_endproc
	.globl	_ZN3TKO7RESOLVE15ARRAYFROMBOUNDSERNS0_3CTXEjiij
	.def	_ZN3TKO7RESOLVE15ARRAYFROMBOUNDSERNS0_3CTXEjiij;	.scl	2;	.type	32;	.endef
	.seh_proc	_ZN3TKO7RESOLVE15ARRAYFROMBOUNDSERNS0_3CTXEjiij
_ZN3TKO7RESOLVE15ARRAYFROMBOUNDSERNS0_3CTXEjiij:
	push	rbp
	.seh_pushreg	rbp
	sub	rsp, 272
	.seh_stackalloc	272
	lea	rbp, 128[rsp]
	.seh_setframe	rbp, 128
	.seh_endprologue
	mov	QWORD PTR 160[rbp], rcx
	mov	DWORD PTR 168[rbp], edx
	mov	DWORD PTR 176[rbp], r8d
	mov	DWORD PTR 184[rbp], r9d
	mov	DWORD PTR 104[rbp], 0
.L4145:
	lea	rax, 16[rbp]
	mov	rcx, rax
	call	_ZN5ArrayIjEC1Ev
	lea	rax, -64[rbp]
	mov	rcx, rax
	call	_ZN5ArrayIjEC1Ev
	mov	DWORD PTR 132[rbp], 0
.L4146:
	mov	eax, DWORD PTR 132[rbp]
	cdqe
	lea	rdx, 1[rax]
	mov	eax, DWORD PTR 184[rbp]
	cdqe
	add	rax, 1
	cmp	rdx, rax
	jge	.L4156
	mov	eax, DWORD PTR 132[rbp]
	cdqe
	lea	rdx, 1[rax]
	mov	eax, DWORD PTR 184[rbp]
	cdqe
	sub	rax, 1
	cmp	rdx, rax
	setle	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR 136[rbp], rax
	jmp	.L4149
.L4156:
	nop
.L4148:
	mov	QWORD PTR 136[rbp], 0
.L4149:
	cmp	QWORD PTR 136[rbp], 0
	je	.L4157
	mov	edx, DWORD PTR 176[rbp]
	mov	eax, DWORD PTR 132[rbp]
	add	edx, eax
	mov	rax, QWORD PTR 160[rbp]
	mov	rax, QWORD PTR [rax]
	add	rax, 560
	mov	rcx, rax
	call	_ZN5ArrayIjEixEi
	mov	QWORD PTR 120[rbp], rax
	mov	rdx, QWORD PTR 120[rbp]
	lea	rax, 16[rbp]
	mov	rcx, rax
	call	_ZN5ArrayIjE4PUSHERj
	mov	edx, DWORD PTR 176[rbp]
	mov	eax, DWORD PTR 132[rbp]
	add	eax, edx
	lea	edx, 1[rax]
	mov	rax, QWORD PTR 160[rbp]
	mov	rax, QWORD PTR [rax]
	add	rax, 560
	mov	rcx, rax
	call	_ZN5ArrayIjEixEi
	mov	QWORD PTR 112[rbp], rax
	mov	rdx, QWORD PTR 112[rbp]
	lea	rax, -64[rbp]
	mov	rcx, rax
	call	_ZN5ArrayIjE4PUSHERj
	add	DWORD PTR 132[rbp], 2
	jmp	.L4146
.L4157:
	nop
.L4151:
	lea	r8, -64[rbp]
	lea	rcx, 16[rbp]
	mov	eax, DWORD PTR 168[rbp]
	mov	edx, DWORD PTR 192[rbp]
	mov	DWORD PTR 48[rsp], edx
	mov	DWORD PTR 40[rsp], 0
	mov	DWORD PTR 32[rsp], 0
	mov	r9, r8
	mov	r8, rcx
	mov	edx, eax
	mov	rcx, QWORD PTR 160[rbp]
	call	_ZN3TKO7RESOLVE14ARRAYFROMPAIRSERNS0_3CTXEjR5ArrayIjES5_jbj
	mov	DWORD PTR 108[rbp], eax
	mov	eax, DWORD PTR 108[rbp]
	mov	DWORD PTR 104[rbp], eax
	lea	rax, -64[rbp]
	mov	rcx, rax
	call	_ZN5ArrayIjED1Ev
	lea	rax, 16[rbp]
	mov	rcx, rax
	call	_ZN5ArrayIjED1Ev
	nop
.L4152:
	mov	eax, DWORD PTR 104[rbp]
	add	rsp, 272
	pop	rbp
	ret
	.seh_endproc
	.globl	_ZN3TKO7RESOLVE12BINDDECLTYPEERNS0_3CTXEjjjb
	.def	_ZN3TKO7RESOLVE12BINDDECLTYPEERNS0_3CTXEjjjb;	.scl	2;	.type	32;	.endef
	.seh_proc	_ZN3TKO7RESOLVE12BINDDECLTYPEERNS0_3CTXEjjjb
_ZN3TKO7RESOLVE12BINDDECLTYPEERNS0_3CTXEjjjb:
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
	mov	DWORD PTR 40[rbp], r9d
	mov	eax, DWORD PTR 48[rbp]
	mov	BYTE PTR -36[rbp], al
.L4159:
	cmp	DWORD PTR 32[rbp], 0
	je	.L4175
	cmp	DWORD PTR 40[rbp], 0
	sete	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -8[rbp], rax
	jmp	.L4162
.L4175:
	nop
.L4161:
	mov	QWORD PTR -8[rbp], -1
.L4162:
	cmp	QWORD PTR -8[rbp], 0
	jne	.L4176
	nop
.L4164:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	ecx, DWORD PTR 32[rbp]
	mov	edx, DWORD PTR 24[rbp]
	mov	r9d, 0
	mov	r8d, ecx
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE16LOOKUPLOCALTYPEDEjjb
	mov	DWORD PTR -12[rbp], eax
	mov	eax, DWORD PTR -12[rbp]
	mov	DWORD PTR -16[rbp], eax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR -16[rbp]
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE8SYMBOLATEj
	mov	QWORD PTR -24[rbp], rax
	mov	rax, QWORD PTR -24[rbp]
	mov	QWORD PTR -32[rbp], rax
	cmp	QWORD PTR -32[rbp], 0
	je	.L4177
	nop
.L4167:
	cmp	BYTE PTR -36[rbp], 0
	je	.L4178
	mov	rax, QWORD PTR -32[rbp]
	lea	rdx, 16[rax]
	mov	eax, DWORD PTR 40[rbp]
	mov	DWORD PTR [rdx], eax
	jmp	.L4172
.L4178:
	nop
.L4169:
	mov	rax, QWORD PTR -32[rbp]
	add	rax, 16
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	jne	.L4179
	mov	rax, QWORD PTR -32[rbp]
	lea	rdx, 16[rax]
	mov	eax, DWORD PTR 40[rbp]
	mov	DWORD PTR [rdx], eax
	jmp	.L4180
.L4165:
.L4171:
.L4176:
	nop
	jmp	.L4180
.L4177:
	nop
	jmp	.L4180
.L4179:
	nop
.L4172:
.L4180:
	nop
	add	rsp, 80
	pop	rbp
	ret
	.seh_endproc
	.section .rdata,"dr"
.LC5:
	.ascii "TMP$\0"
.LC6:
	.ascii "base\0"
	.text
	.globl	_ZN3TKO7RESOLVE8WALKSTMTERNS0_3CTXEjj
	.def	_ZN3TKO7RESOLVE8WALKSTMTERNS0_3CTXEjj;	.scl	2;	.type	32;	.endef
	.seh_proc	_ZN3TKO7RESOLVE8WALKSTMTERNS0_3CTXEjj
_ZN3TKO7RESOLVE8WALKSTMTERNS0_3CTXEjj:
	push	rbp
	.seh_pushreg	rbp
	push	rbx
	.seh_pushreg	rbx
	sub	rsp, 2040
	.seh_stackalloc	2040
	lea	rbp, 128[rsp]
	.seh_setframe	rbp, 128
	.seh_endprologue
	mov	QWORD PTR 1936[rbp], rcx
	mov	DWORD PTR 1944[rbp], edx
	mov	DWORD PTR 1952[rbp], r8d
.L4182:
	mov	eax, DWORD PTR 1944[rbp]
	test	eax, eax
	je	.L4585
	nop
.L4184:
	mov	edx, DWORD PTR 1944[rbp]
	mov	rax, QWORD PTR 1936[rbp]
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN3TKO8ASTARENA4KINDEj
	mov	QWORD PTR 1672[rbp], rax
	mov	rax, QWORD PTR 1672[rbp]
	mov	QWORD PTR 1664[rbp], rax
	mov	rax, QWORD PTR 1664[rbp]
	mov	rcx, rax
	call	_ZN3TKO16NODEKINDCATEGORYENS_8NODEKINDE
	mov	QWORD PTR 1656[rbp], rax
	mov	rax, QWORD PTR 1656[rbp]
	mov	QWORD PTR 1648[rbp], rax
	mov	edx, DWORD PTR 1944[rbp]
	mov	rax, QWORD PTR 1936[rbp]
	add	rax, 48
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN3TKO12SEMANTICINFO7SCOPEOFEj
	mov	DWORD PTR 1644[rbp], eax
	mov	eax, DWORD PTR 1644[rbp]
	mov	DWORD PTR 444[rbp], eax
	mov	eax, DWORD PTR 444[rbp]
	test	eax, eax
	jne	.L4586
	mov	eax, DWORD PTR 1952[rbp]
	mov	DWORD PTR 444[rbp], eax
	jmp	.L4187
.L4586:
	nop
.L4187:
	cmp	QWORD PTR 1648[rbp], 0
	jne	.L4587
	mov	edx, DWORD PTR 444[rbp]
	mov	eax, DWORD PTR 1944[rbp]
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 1936[rbp]
	call	_ZN3TKO7RESOLVE8WALKEXPRERNS0_3CTXEjj
	jmp	.L4540
.L4189:
.L4587:
	nop
.L4190:
	cmp	QWORD PTR 1664[rbp], 33
	jne	.L4588
	mov	edx, DWORD PTR 444[rbp]
	mov	eax, DWORD PTR 1944[rbp]
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 1936[rbp]
	call	_ZN3TKO7RESOLVE17SELECTCONSTCHECK_ERNS0_3CTXEjj
	jmp	.L4192
.L4588:
	nop
.L4192:
	cmp	QWORD PTR 1664[rbp], 56
	je	.L4589
	nop
.L4193:
	cmp	QWORD PTR 1664[rbp], 29
	jne	.L4590
	jmp	.L4194
.L4589:
	nop
.L4194:
	mov	edx, DWORD PTR 444[rbp]
	mov	eax, DWORD PTR 1944[rbp]
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 1936[rbp]
	call	_ZN3TKO7RESOLVE10WALKBLOCK_ERNS0_3CTXEjj
	jmp	.L4540
.L4590:
	nop
.L4195:
	cmp	QWORD PTR 1664[rbp], 44
	jne	.L4591
	nop
.L4196:
	mov	edx, DWORD PTR 444[rbp]
	mov	eax, DWORD PTR 1944[rbp]
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 1936[rbp]
	call	_ZN3TKO7RESOLVE16BUILDSPAWNFRAME_ERNS0_3CTXEjj
	mov	eax, DWORD PTR 1944[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 1936[rbp]
	call	_ZN3TKO7RESOLVE6STMTOFERNS0_3CTXEj
	mov	QWORD PTR 1632[rbp], rax
	mov	edx, DWORD PTR 444[rbp]
	mov	rax, QWORD PTR 1632[rbp]
	add	rax, 8
	mov	eax, DWORD PTR [rax]
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 1936[rbp]
	call	_ZN3TKO7RESOLVE8WALKSTMTERNS0_3CTXEjj
	jmp	.L4540
.L4591:
	nop
.L4197:
	cmp	QWORD PTR 1664[rbp], 54
	jne	.L4592
	nop
.L4198:
	mov	eax, DWORD PTR 1944[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 1936[rbp]
	call	_ZN3TKO7RESOLVE6STMTOFERNS0_3CTXEj
	mov	QWORD PTR 1624[rbp], rax
	mov	rax, QWORD PTR 1624[rbp]
	mov	QWORD PTR 1616[rbp], rax
	mov	edx, DWORD PTR 444[rbp]
	mov	rax, QWORD PTR 1616[rbp]
	add	rax, 4
	mov	eax, DWORD PTR [rax]
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 1936[rbp]
	call	_ZN3TKO7RESOLVE8WALKEXPRERNS0_3CTXEjj
	mov	r10d, DWORD PTR 444[rbp]
	mov	rax, QWORD PTR 1936[rbp]
	add	rax, 8
	mov	r9, QWORD PTR [rax]
	mov	rax, QWORD PTR 1936[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	add	rax, 248
	mov	r8d, DWORD PTR [rax]
	mov	rax, QWORD PTR 1936[rbp]
	add	rax, 24
	mov	rcx, QWORD PTR [rax]
	mov	rax, QWORD PTR 1936[rbp]
	add	rax, 32
	mov	rbx, QWORD PTR [rax]
	mov	rax, QWORD PTR 1616[rbp]
	add	rax, 4
	mov	r11d, DWORD PTR [rax]
	mov	rax, QWORD PTR 1936[rbp]
	mov	rdx, QWORD PTR [rax]
	lea	rax, 384[rbp]
	mov	QWORD PTR 80[rsp], 0
	mov	QWORD PTR 72[rsp], 0
	mov	DWORD PTR 64[rsp], 0
	mov	DWORD PTR 56[rsp], r10d
	mov	QWORD PTR 48[rsp], r9
	mov	DWORD PTR 40[rsp], r8d
	mov	QWORD PTR 32[rsp], rcx
	mov	r9, rbx
	mov	r8d, r11d
	mov	rcx, rax
	call	_ZN3TKO5CHECK7CONSTOFERNS_8ASTARENAEjRNS_13SOURCEMANAGERERNS_8INTERNEREiPNS_11SYMBOLTABLEEjiPNS_11TYPECONTEXTEPNS_12SEMANTICINFOE
	mov	rax, QWORD PTR 384[rbp]
	mov	rdx, QWORD PTR 392[rbp]
	mov	QWORD PTR 416[rbp], rax
	mov	QWORD PTR 424[rbp], rdx
	mov	rax, QWORD PTR 400[rbp]
	mov	QWORD PTR 432[rbp], rax
	lea	rax, 416[rbp]
	movzx	eax, BYTE PTR [rax]
	movsx	eax, al
	neg	eax
	test	eax, eax
	je	.L4593
	lea	rax, 416[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	test	rax, rax
	sete	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR 1896[rbp], rax
	jmp	.L4202
.L4593:
	nop
.L4201:
	mov	QWORD PTR 1896[rbp], 0
.L4202:
	cmp	QWORD PTR 1896[rbp], 0
	je	.L4594
	lea	rax, 288[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	lea	rax, 288[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9d, 1
	lea	r8, .LC4[rip]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrAssign
	lea	rax, 320[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	lea	rax, 320[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9d, 1
	lea	r8, .LC4[rip]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrAssign
	lea	rax, 352[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	lea	rax, 352[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9d, 1
	lea	r8, .LC4[rip]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrAssign
	mov	edx, DWORD PTR 1944[rbp]
	mov	rax, QWORD PTR 1936[rbp]
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN3TKO8ASTARENA3LOCEj
	mov	DWORD PTR 1612[rbp], eax
	mov	eax, DWORD PTR 1612[rbp]
	mov	ecx, eax
	call	_ZN3TKO10POINTRANGEEj
	mov	QWORD PTR 280[rbp], rax
	mov	rax, QWORD PTR 1936[rbp]
	add	rax, 40
	mov	rax, QWORD PTR [rax]
	lea	r8, 352[rbp]
	mov	rcx, QWORD PTR 280[rbp]
	lea	rdx, 288[rbp]
	mov	QWORD PTR 40[rsp], rdx
	lea	rdx, 320[rbp]
	mov	QWORD PTR 32[rsp], rdx
	mov	r9, r8
	mov	r8, rcx
	mov	edx, 78
	mov	rcx, rax
	call	_ZN3TKO16DIAGNOSTICENGINE6REPORTENS_6DIAGIDENS_11SOURCERANGEE8FBSTRINGS3_S3_
	lea	rax, 288[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	lea	rax, 320[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	lea	rax, 352[rbp]
	mov	rcx, rax
	call	fb_StrDelete
.L4204:
.L4205:
	jmp	.L4720
.L4592:
	nop
.L4199:
	cmp	QWORD PTR 1664[rbp], 68
	jne	.L4595
	nop
.L4206:
	mov	eax, DWORD PTR 1944[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 1936[rbp]
	call	_ZN3TKO7RESOLVE6STMTOFERNS0_3CTXEj
	mov	QWORD PTR 1600[rbp], rax
	mov	rax, QWORD PTR 1600[rbp]
	mov	QWORD PTR 1592[rbp], rax
	mov	rax, QWORD PTR 1592[rbp]
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	je	.L4596
	mov	rax, QWORD PTR 1592[rbp]
	mov	edx, DWORD PTR [rax]
	mov	eax, DWORD PTR 444[rbp]
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 1936[rbp]
	call	_ZN3TKO7RESOLVE22LOOKUPDOTTEDNAMESPACE_ERNS0_3CTXEjj
	mov	DWORD PTR 1588[rbp], eax
	mov	eax, DWORD PTR 1588[rbp]
	mov	DWORD PTR 1584[rbp], eax
	mov	rax, QWORD PTR 1936[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 1584[rbp]
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE8SYMBOLATEj
	mov	QWORD PTR 1576[rbp], rax
	mov	rax, QWORD PTR 1576[rbp]
	mov	QWORD PTR 1568[rbp], rax
	cmp	QWORD PTR 1568[rbp], 0
	je	.L4597
	mov	rax, QWORD PTR 1568[rbp]
	movzx	eax, BYTE PTR [rax]
	cmp	al, 10
	jne	.L4598
	mov	rax, QWORD PTR 1568[rbp]
	add	rax, 36
	mov	ecx, DWORD PTR [rax]
	mov	edx, DWORD PTR 444[rbp]
	mov	rax, QWORD PTR 1936[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	r8d, ecx
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE8ADDUSINGEjj
	jmp	.L4540
.L4209:
.L4212:
.L4213:
.L4214:
.L4215:
.L4596:
	nop
	jmp	.L4540
.L4597:
	nop
	jmp	.L4540
.L4598:
	nop
.L4216:
	jmp	.L4540
.L4595:
	nop
.L4207:
	cmp	QWORD PTR 1664[rbp], 41
	jne	.L4599
	nop
.L4217:
	mov	eax, DWORD PTR 1944[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 1936[rbp]
	call	_ZN3TKO7RESOLVE6STMTOFERNS0_3CTXEj
	mov	QWORD PTR 1560[rbp], rax
	mov	rax, QWORD PTR 1560[rbp]
	mov	QWORD PTR 1552[rbp], rax
.L4219:
	mov	rax, QWORD PTR 1552[rbp]
	add	rax, 4
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 1936[rbp]
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN3TKO8ASTARENA4KINDEj
	mov	QWORD PTR 1544[rbp], rax
	cmp	QWORD PTR 1544[rbp], 18
	jne	.L4600
	mov	rax, QWORD PTR 1552[rbp]
	add	rax, 4
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 1936[rbp]
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN5ArrayIN3TKO7ASTNODEEEixEi
	mov	QWORD PTR 1536[rbp], rax
	mov	rax, QWORD PTR 1536[rbp]
	add	rax, 8
	mov	eax, DWORD PTR [rax]
	mov	rdx, QWORD PTR 1936[rbp]
	mov	rdx, QWORD PTR [rdx]
	lea	rcx, 400[rdx]
	mov	edx, eax
	call	_ZN5ArrayIN3TKO11LISTPAYLOADEEixEi
	mov	QWORD PTR 1528[rbp], rax
	mov	rax, QWORD PTR 1528[rbp]
	mov	QWORD PTR 1520[rbp], rax
	mov	rax, QWORD PTR 1520[rbp]
	add	rax, 8
	mov	eax, DWORD PTR [rax]
	cmp	eax, 1
	jne	.L4601
	nop
.L4223:
	mov	rax, QWORD PTR 1520[rbp]
	add	rax, 4
	mov	eax, DWORD PTR [rax]
	mov	rdx, QWORD PTR 1936[rbp]
	mov	rdx, QWORD PTR [rdx]
	lea	rcx, 560[rdx]
	mov	edx, eax
	call	_ZN5ArrayIjEixEi
	mov	QWORD PTR 1512[rbp], rax
	mov	rax, QWORD PTR 1552[rbp]
	lea	rdx, 4[rax]
	mov	rax, QWORD PTR 1512[rbp]
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR [rdx], eax
	jmp	.L4219
.L4600:
	nop
	jmp	.L4221
.L4601:
	nop
.L4221:
	mov	edx, DWORD PTR 444[rbp]
	mov	rax, QWORD PTR 1552[rbp]
	add	rax, 4
	mov	eax, DWORD PTR [rax]
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 1936[rbp]
	call	_ZN3TKO7RESOLVE8WALKEXPRERNS0_3CTXEjj
	mov	BYTE PTR 1895[rbp], 0
	mov	rax, QWORD PTR 1552[rbp]
	add	rax, 4
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	je	.L4602
	mov	rax, QWORD PTR 1552[rbp]
	add	rax, 4
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 1936[rbp]
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN3TKO8ASTARENA4KINDEj
	mov	QWORD PTR 1504[rbp], rax
	mov	rax, QWORD PTR 1504[rbp]
	mov	QWORD PTR 1496[rbp], rax
	cmp	QWORD PTR 1496[rbp], 6
	je	.L4603
	nop
.L4226:
	cmp	QWORD PTR 1496[rbp], 11
	je	.L4604
	nop
.L4228:
	cmp	QWORD PTR 1496[rbp], 12
	je	.L4605
	nop
.L4229:
	cmp	QWORD PTR 1496[rbp], 10
	je	.L4606
	nop
.L4230:
	cmp	QWORD PTR 1496[rbp], 9
	je	.L4607
	nop
.L4231:
	cmp	QWORD PTR 1496[rbp], 19
	jne	.L4608
	jmp	.L4227
.L4603:
	nop
	jmp	.L4227
.L4604:
	nop
	jmp	.L4227
.L4605:
	nop
	jmp	.L4227
.L4606:
	nop
	jmp	.L4227
.L4607:
	nop
.L4227:
	mov	rax, QWORD PTR 1552[rbp]
	lea	rdx, 4[rax]
	mov	rax, QWORD PTR 1936[rbp]
	add	rax, 72
	mov	rcx, rax
	call	_ZN5ArrayIjE4PUSHERj
	mov	BYTE PTR 1895[rbp], 1
	jmp	.L4234
.L4225:
.L4232:
.L4233:
.L4602:
	nop
	jmp	.L4234
.L4608:
	nop
.L4234:
	mov	edx, DWORD PTR 444[rbp]
	mov	rax, QWORD PTR 1552[rbp]
	add	rax, 8
	mov	eax, DWORD PTR [rax]
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 1936[rbp]
	call	_ZN3TKO7RESOLVE8WALKSTMTERNS0_3CTXEjj
	cmp	BYTE PTR 1895[rbp], 0
	je	.L4609
	mov	rax, QWORD PTR 1936[rbp]
	add	rax, 72
	mov	rcx, rax
	call	_ZN5ArrayIjE3POPEv
	jmp	.L4540
.L4609:
	nop
.L4236:
	jmp	.L4540
.L4599:
	nop
.L4218:
	cmp	QWORD PTR 1664[rbp], 30
	jne	.L4610
	nop
.L4237:
	mov	edx, DWORD PTR 444[rbp]
	mov	eax, DWORD PTR 1944[rbp]
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 1936[rbp]
	call	_ZN3TKO7RESOLVE16RESOLVEAMBIGUOUSERNS0_3CTXEjj
	jmp	.L4540
.L4610:
	nop
.L4238:
	cmp	QWORD PTR 1664[rbp], 28
	jne	.L4611
	nop
.L4239:
	mov	edx, DWORD PTR 444[rbp]
	mov	eax, DWORD PTR 1944[rbp]
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 1936[rbp]
	call	_ZN3TKO7RESOLVE14RESOLVETYPEREFERNS0_3CTXEjj
	jmp	.L4540
.L4611:
	nop
.L4240:
	cmp	QWORD PTR 1664[rbp], 62
	jne	.L4612
	nop
.L4241:
	mov	eax, DWORD PTR 1944[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 1936[rbp]
	call	_ZN3TKO7RESOLVE6STMTOFERNS0_3CTXEj
	mov	QWORD PTR 1488[rbp], rax
	mov	rax, QWORD PTR 1488[rbp]
	mov	QWORD PTR 1480[rbp], rax
	mov	rax, QWORD PTR 1480[rbp]
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR 1888[rbp], eax
	cmp	DWORD PTR 1888[rbp], 0
	jne	.L4613
	lea	rax, 224[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	eax, DWORD PTR 1944[rbp]
	mov	ecx, eax
	call	fb_IntToStr
	mov	QWORD PTR 1472[rbp], rax
	lea	rax, 256[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	rdx, QWORD PTR 1472[rbp]
	lea	rax, 256[rbp]
	mov	QWORD PTR 32[rsp], -1
	mov	r9, rdx
	mov	r8d, 5
	lea	rdx, .LC5[rip]
	mov	rcx, rax
	call	fb_StrConcat
	mov	QWORD PTR 1464[rbp], rax
	mov	rdx, QWORD PTR 1464[rbp]
	lea	rax, 224[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrAssign
	mov	rax, QWORD PTR 1936[rbp]
	add	rax, 24
	mov	rax, QWORD PTR [rax]
	lea	rdx, 224[rbp]
	mov	rcx, rax
	call	_ZN3TKO8INTERNER9GETSTRINGE8FBSTRING
	mov	DWORD PTR 1460[rbp], eax
	mov	rax, QWORD PTR 1936[rbp]
	add	rax, 24
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 1460[rbp]
	mov	rcx, rax
	call	_ZN3TKO8INTERNER4FOLDEj
	mov	DWORD PTR 1456[rbp], eax
	mov	eax, DWORD PTR 1456[rbp]
	mov	DWORD PTR 1888[rbp], eax
	lea	rax, 224[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	jmp	.L4245
.L4244:
.L4613:
	nop
.L4245:
	mov	DWORD PTR 1884[rbp], 0
	mov	rax, QWORD PTR 1480[rbp]
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	je	.L4614
	mov	rax, QWORD PTR 1480[rbp]
	mov	ecx, DWORD PTR [rax]
	mov	edx, DWORD PTR 444[rbp]
	mov	rax, QWORD PTR 1936[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	r8d, ecx
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE11LOOKUPLOCALEjj
	mov	DWORD PTR 1452[rbp], eax
	mov	rax, QWORD PTR 1936[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 1452[rbp]
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE8SYMBOLATEj
	mov	QWORD PTR 1440[rbp], rax
	mov	rax, QWORD PTR 1440[rbp]
	mov	QWORD PTR 1432[rbp], rax
	cmp	QWORD PTR 1432[rbp], 0
	je	.L4615
	mov	rax, QWORD PTR 1432[rbp]
	movzx	eax, BYTE PTR [rax]
	cmp	al, 7
	jne	.L4616
	mov	rax, QWORD PTR 1432[rbp]
	mov	eax, DWORD PTR 36[rax]
	mov	DWORD PTR 1884[rbp], eax
	jmp	.L4253
.L4247:
.L4250:
.L4251:
.L4252:
.L4614:
	nop
	jmp	.L4253
.L4615:
	nop
	jmp	.L4253
.L4616:
	nop
.L4253:
	mov	QWORD PTR 1872[rbp], 0
	mov	DWORD PTR 1868[rbp], 0
	mov	rax, QWORD PTR 1480[rbp]
	add	rax, 20
	mov	eax, DWORD PTR [rax]
	sub	eax, 1
	mov	DWORD PTR 1428[rbp], eax
	jmp	.L4254
.L4625:
	nop
.L4255:
	mov	rax, QWORD PTR 1480[rbp]
	add	rax, 16
	mov	edx, DWORD PTR [rax]
	mov	eax, DWORD PTR 1868[rbp]
	add	edx, eax
	mov	rax, QWORD PTR 1936[rbp]
	mov	rax, QWORD PTR [rax]
	add	rax, 560
	mov	rcx, rax
	call	_ZN5ArrayIjEixEi
	mov	QWORD PTR 1416[rbp], rax
	mov	rax, QWORD PTR 1416[rbp]
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR 1412[rbp], eax
	mov	rax, QWORD PTR 1936[rbp]
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 1412[rbp]
	mov	rcx, rax
	call	_ZN3TKO8ASTARENA4KINDEj
	mov	QWORD PTR 1400[rbp], rax
	cmp	QWORD PTR 1400[rbp], 63
	jne	.L4617
	nop
.L4257:
	mov	eax, DWORD PTR 1412[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 1936[rbp]
	call	_ZN3TKO7RESOLVE6STMTOFERNS0_3CTXEj
	mov	QWORD PTR 1392[rbp], rax
	mov	rax, QWORD PTR 1392[rbp]
	mov	QWORD PTR 1384[rbp], rax
	mov	rax, QWORD PTR 1384[rbp]
	add	rax, 8
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	je	.L4618
	mov	edx, DWORD PTR 444[rbp]
	mov	rax, QWORD PTR 1384[rbp]
	add	rax, 8
	mov	eax, DWORD PTR [rax]
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 1936[rbp]
	call	_ZN3TKO7RESOLVE8WALKEXPRERNS0_3CTXEjj
	mov	r9d, DWORD PTR 444[rbp]
	mov	rax, QWORD PTR 1936[rbp]
	add	rax, 8
	mov	r8, QWORD PTR [rax]
	mov	rax, QWORD PTR 1936[rbp]
	add	rax, 24
	mov	rcx, QWORD PTR [rax]
	mov	rax, QWORD PTR 1936[rbp]
	add	rax, 32
	mov	r11, QWORD PTR [rax]
	mov	rax, QWORD PTR 1384[rbp]
	add	rax, 8
	mov	r10d, DWORD PTR [rax]
	mov	rax, QWORD PTR 1936[rbp]
	mov	rdx, QWORD PTR [rax]
	lea	rax, 160[rbp]
	mov	QWORD PTR 80[rsp], 0
	mov	QWORD PTR 72[rsp], 0
	mov	DWORD PTR 64[rsp], 0
	mov	DWORD PTR 56[rsp], r9d
	mov	QWORD PTR 48[rsp], r8
	mov	DWORD PTR 40[rsp], 64
	mov	QWORD PTR 32[rsp], rcx
	mov	r9, r11
	mov	r8d, r10d
	mov	rcx, rax
	call	_ZN3TKO5CHECK7CONSTOFERNS_8ASTARENAEjRNS_13SOURCEMANAGERERNS_8INTERNEREiPNS_11SYMBOLTABLEEjiPNS_11TYPECONTEXTEPNS_12SEMANTICINFOE
	mov	rax, QWORD PTR 160[rbp]
	mov	rdx, QWORD PTR 168[rbp]
	mov	QWORD PTR 192[rbp], rax
	mov	QWORD PTR 200[rbp], rdx
	mov	rax, QWORD PTR 176[rbp]
	mov	QWORD PTR 208[rbp], rax
	lea	rax, 192[rbp]
	movzx	eax, BYTE PTR [rax]
	test	al, al
	je	.L4619
	mov	rax, QWORD PTR 200[rbp]
	mov	QWORD PTR 1872[rbp], rax
	jmp	.L4263
.L4262:
.L4260:
.L4618:
	nop
	jmp	.L4263
.L4619:
	nop
.L4263:
	mov	DWORD PTR 1864[rbp], 0
.L4264:
	mov	eax, DWORD PTR 444[rbp]
	mov	DWORD PTR 1860[rbp], eax
	cmp	DWORD PTR 1864[rbp], 1
	jne	.L4620
	mov	eax, DWORD PTR 1884[rbp]
	mov	DWORD PTR 1860[rbp], eax
	cmp	DWORD PTR 1860[rbp], 0
	je	.L4621
	jmp	.L4270
.L4266:
.L4269:
.L4620:
	nop
.L4270:
	mov	rax, QWORD PTR 1384[rbp]
	mov	ecx, DWORD PTR [rax]
	mov	rax, QWORD PTR 1936[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 1860[rbp]
	mov	r8d, ecx
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE11LOOKUPLOCALEjj
	mov	DWORD PTR 1380[rbp], eax
	mov	eax, DWORD PTR 1380[rbp]
	mov	DWORD PTR 1376[rbp], eax
	mov	rax, QWORD PTR 1936[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 1376[rbp]
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE8SYMBOLATEj
	mov	QWORD PTR 1368[rbp], rax
	mov	rax, QWORD PTR 1368[rbp]
	mov	QWORD PTR 1360[rbp], rax
	cmp	QWORD PTR 1360[rbp], 0
	je	.L4622
	mov	rax, QWORD PTR 1360[rbp]
	movzx	eax, BYTE PTR [rax]
	cmp	al, 8
	jne	.L4623
	mov	rax, QWORD PTR 1360[rbp]
	lea	rdx, 40[rax]
	mov	rax, QWORD PTR 1872[rbp]
	mov	QWORD PTR [rdx], rax
	mov	ecx, DWORD PTR 444[rbp]
	mov	rax, QWORD PTR 1936[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 1888[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9d, ecx
	mov	r8d, edx
	mov	edx, 7
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT9NAMEDTYPEENS_8TYPEKINDEjjj
	mov	DWORD PTR 1356[rbp], eax
	mov	rax, QWORD PTR 1360[rbp]
	lea	rdx, 16[rax]
	mov	eax, DWORD PTR 1356[rbp]
	mov	DWORD PTR [rdx], eax
	jmp	.L4276
.L4268:
.L4273:
.L4274:
.L4275:
.L4621:
	nop
	jmp	.L4276
.L4622:
	nop
	jmp	.L4276
.L4623:
	nop
.L4276:
	add	DWORD PTR 1864[rbp], 1
.L4277:
	cmp	DWORD PTR 1864[rbp], 1
	jg	.L4624
	jmp	.L4264
.L4624:
	nop
.L4278:
	add	QWORD PTR 1872[rbp], 1
	jmp	.L4258
.L4617:
	nop
.L4258:
	add	DWORD PTR 1868[rbp], 1
.L4254:
	mov	eax, DWORD PTR 1868[rbp]
	cmp	eax, DWORD PTR 1428[rbp]
	jle	.L4625
	nop
.L4279:
	jmp	.L4540
.L4612:
	nop
.L4242:
	cmp	QWORD PTR 1664[rbp], 57
	je	.L4626
	nop
.L4280:
	cmp	QWORD PTR 1664[rbp], 59
	jne	.L4627
	jmp	.L4281
.L4626:
	nop
.L4281:
	mov	eax, DWORD PTR 1944[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 1936[rbp]
	call	_ZN3TKO7RESOLVE6STMTOFERNS0_3CTXEj
	mov	QWORD PTR 800[rbp], rax
	mov	rax, QWORD PTR 800[rbp]
	mov	QWORD PTR 792[rbp], rax
	mov	rax, QWORD PTR 792[rbp]
	add	rax, 24
	movzx	eax, WORD PTR [rax]
	cmp	ax, 227
	jne	.L4628
	mov	BYTE PTR 791[rbp], 0
	mov	DWORD PTR 1856[rbp], 0
	mov	rax, QWORD PTR 792[rbp]
	add	rax, 20
	mov	eax, DWORD PTR [rax]
	sub	eax, 1
	mov	DWORD PTR 784[rbp], eax
	jmp	.L4285
.L4635:
	nop
.L4286:
	mov	rax, QWORD PTR 792[rbp]
	add	rax, 16
	mov	edx, DWORD PTR [rax]
	mov	eax, DWORD PTR 1856[rbp]
	add	edx, eax
	mov	rax, QWORD PTR 1936[rbp]
	mov	rax, QWORD PTR [rax]
	add	rax, 560
	mov	rcx, rax
	call	_ZN5ArrayIjEixEi
	mov	QWORD PTR 672[rbp], rax
	mov	rax, QWORD PTR 672[rbp]
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR 668[rbp], eax
	mov	rax, QWORD PTR 1936[rbp]
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 668[rbp]
	mov	rcx, rax
	call	_ZN3TKO8ASTARENA4KINDEj
	mov	QWORD PTR 656[rbp], rax
	cmp	QWORD PTR 656[rbp], 58
	jne	.L4629
	nop
.L4288:
	mov	eax, DWORD PTR 668[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 1936[rbp]
	call	_ZN3TKO7RESOLVE6STMTOFERNS0_3CTXEj
	mov	QWORD PTR 648[rbp], rax
	mov	rax, QWORD PTR 648[rbp]
	mov	QWORD PTR 640[rbp], rax
	mov	rax, QWORD PTR 640[rbp]
	add	rax, 4
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	je	.L4630
	nop
.L4291:
	mov	BYTE PTR 791[rbp], 1
	mov	edx, DWORD PTR 444[rbp]
	mov	rax, QWORD PTR 640[rbp]
	add	rax, 4
	mov	eax, DWORD PTR [rax]
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 1936[rbp]
	call	_ZN3TKO7RESOLVE14RESOLVETYPEREFERNS0_3CTXEjj
	mov	DWORD PTR 636[rbp], eax
	mov	eax, DWORD PTR 636[rbp]
	mov	DWORD PTR 632[rbp], eax
	cmp	DWORD PTR 632[rbp], 0
	je	.L4631
	nop
.L4293:
	mov	DWORD PTR 1852[rbp], 1
	mov	rax, QWORD PTR 640[rbp]
	add	rax, 12
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	je	.L4632
	mov	rax, QWORD PTR 640[rbp]
	add	rax, 12
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 1936[rbp]
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN3TKO8ASTARENA4KINDEj
	mov	QWORD PTR 624[rbp], rax
	cmp	QWORD PTR 624[rbp], 29
	jne	.L4633
	mov	rax, QWORD PTR 640[rbp]
	add	rax, 12
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 1936[rbp]
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN5ArrayIN3TKO7ASTNODEEEixEi
	mov	QWORD PTR 616[rbp], rax
	mov	rax, QWORD PTR 616[rbp]
	add	rax, 8
	mov	eax, DWORD PTR [rax]
	mov	rdx, QWORD PTR 1936[rbp]
	mov	rdx, QWORD PTR [rdx]
	lea	rcx, 400[rdx]
	mov	edx, eax
	call	_ZN5ArrayIN3TKO11LISTPAYLOADEEixEi
	mov	QWORD PTR 608[rbp], rax
	mov	rax, QWORD PTR 608[rbp]
	mov	eax, DWORD PTR 8[rax]
	mov	DWORD PTR 1852[rbp], eax
	jmp	.L4299
.L4295:
.L4297:
.L4298:
.L4632:
	nop
	jmp	.L4299
.L4633:
	nop
.L4299:
	cmp	DWORD PTR 1852[rbp], 0
	jns	.L4634
	mov	DWORD PTR 1852[rbp], 0
	jmp	.L4301
.L4634:
	nop
.L4301:
	mov	rax, QWORD PTR 1936[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	ecx, DWORD PTR 1852[rbp]
	mov	edx, DWORD PTR 632[rbp]
	mov	r8d, ecx
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT10DYNARRAYOFEji
	mov	DWORD PTR 604[rbp], eax
	mov	rax, QWORD PTR 640[rbp]
	mov	edx, DWORD PTR [rax]
	mov	eax, DWORD PTR 444[rbp]
	mov	ecx, DWORD PTR 604[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9d, ecx
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 1936[rbp]
	call	_ZN3TKO7RESOLVE12BINDDECLTYPEERNS0_3CTXEjjjb
	jmp	.L4289
.L4629:
	nop
	jmp	.L4289
.L4630:
	nop
	jmp	.L4289
.L4631:
	nop
.L4289:
	add	DWORD PTR 1856[rbp], 1
.L4285:
	mov	eax, DWORD PTR 1856[rbp]
	cmp	eax, DWORD PTR 784[rbp]
	jle	.L4635
	nop
.L4302:
	mov	DWORD PTR 1848[rbp], 0
	mov	rax, QWORD PTR 792[rbp]
	add	rax, 20
	mov	eax, DWORD PTR [rax]
	sub	eax, 1
	mov	DWORD PTR 780[rbp], eax
	jmp	.L4303
.L4644:
	nop
.L4304:
	mov	rax, QWORD PTR 792[rbp]
	add	rax, 16
	mov	edx, DWORD PTR [rax]
	mov	eax, DWORD PTR 1848[rbp]
	add	edx, eax
	mov	rax, QWORD PTR 1936[rbp]
	mov	rax, QWORD PTR [rax]
	add	rax, 560
	mov	rcx, rax
	call	_ZN5ArrayIjEixEi
	mov	QWORD PTR 768[rbp], rax
	mov	rax, QWORD PTR 768[rbp]
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR 764[rbp], eax
	mov	rax, QWORD PTR 1936[rbp]
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 764[rbp]
	mov	rcx, rax
	call	_ZN3TKO8ASTARENA4KINDEj
	mov	QWORD PTR 752[rbp], rax
	cmp	QWORD PTR 752[rbp], 58
	jne	.L4636
	nop
.L4306:
	mov	eax, DWORD PTR 764[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 1936[rbp]
	call	_ZN3TKO7RESOLVE6STMTOFERNS0_3CTXEj
	mov	QWORD PTR 744[rbp], rax
	mov	rax, QWORD PTR 744[rbp]
	mov	QWORD PTR 736[rbp], rax
	mov	rax, QWORD PTR 736[rbp]
	add	rax, 28
	mov	eax, DWORD PTR [rax]
	cmp	eax, 227
	jne	.L4637
	mov	rax, QWORD PTR 736[rbp]
	add	rax, 8
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	je	.L4638
	mov	edx, DWORD PTR 444[rbp]
	mov	rax, QWORD PTR 736[rbp]
	add	rax, 8
	mov	eax, DWORD PTR [rax]
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 1936[rbp]
	call	_ZN3TKO7RESOLVE8WALKSTMTERNS0_3CTXEjj
	jmp	.L4316
.L4638:
	nop
.L4311:
	jmp	.L4316
.L4637:
	nop
.L4309:
	mov	rax, QWORD PTR 736[rbp]
	add	rax, 4
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	jne	.L4639
	mov	rax, QWORD PTR 736[rbp]
	mov	ecx, DWORD PTR [rax]
	mov	edx, DWORD PTR 444[rbp]
	mov	rax, QWORD PTR 1936[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	r8d, ecx
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE6LOOKUPEjj
	mov	DWORD PTR 732[rbp], eax
	mov	eax, DWORD PTR 732[rbp]
	mov	DWORD PTR 728[rbp], eax
	cmp	DWORD PTR 728[rbp], 0
	je	.L4640
	mov	rax, QWORD PTR 1936[rbp]
	add	rax, 48
	mov	rax, QWORD PTR [rax]
	mov	ecx, DWORD PTR 728[rbp]
	mov	edx, DWORD PTR 764[rbp]
	mov	r8d, ecx
	mov	rcx, rax
	call	_ZN3TKO12SEMANTICINFO6SETREFEjj
	jmp	.L4316
.L4312:
.L4315:
.L4639:
	nop
	jmp	.L4316
.L4640:
	nop
.L4316:
	mov	rax, QWORD PTR 736[rbp]
	add	rax, 12
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	je	.L4641
	nop
.L4318:
	mov	rax, QWORD PTR 736[rbp]
	add	rax, 12
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 1936[rbp]
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN3TKO8ASTARENA4KINDEj
	mov	QWORD PTR 720[rbp], rax
	cmp	QWORD PTR 720[rbp], 29
	jne	.L4642
	nop
.L4320:
	mov	rax, QWORD PTR 736[rbp]
	add	rax, 12
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 1936[rbp]
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN5ArrayIN3TKO7ASTNODEEEixEi
	mov	QWORD PTR 712[rbp], rax
	mov	rax, QWORD PTR 712[rbp]
	add	rax, 8
	mov	eax, DWORD PTR [rax]
	mov	rdx, QWORD PTR 1936[rbp]
	mov	rdx, QWORD PTR [rdx]
	lea	rcx, 400[rdx]
	mov	edx, eax
	call	_ZN5ArrayIN3TKO11LISTPAYLOADEEixEi
	mov	QWORD PTR 704[rbp], rax
	mov	rax, QWORD PTR 704[rbp]
	mov	QWORD PTR 696[rbp], rax
	mov	DWORD PTR 1844[rbp], 0
	mov	rax, QWORD PTR 696[rbp]
	add	rax, 8
	mov	eax, DWORD PTR [rax]
	sub	eax, 1
	mov	DWORD PTR 692[rbp], eax
	jmp	.L4321
.L4643:
	nop
.L4322:
	mov	rax, QWORD PTR 696[rbp]
	add	rax, 4
	mov	edx, DWORD PTR [rax]
	mov	eax, DWORD PTR 1844[rbp]
	add	edx, eax
	mov	rax, QWORD PTR 1936[rbp]
	mov	rax, QWORD PTR [rax]
	add	rax, 560
	mov	rcx, rax
	call	_ZN5ArrayIjEixEi
	mov	QWORD PTR 680[rbp], rax
	mov	edx, DWORD PTR 444[rbp]
	mov	rax, QWORD PTR 680[rbp]
	mov	eax, DWORD PTR [rax]
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 1936[rbp]
	call	_ZN3TKO7RESOLVE8WALKSTMTERNS0_3CTXEjj
.L4323:
	add	DWORD PTR 1844[rbp], 1
.L4321:
	mov	eax, DWORD PTR 1844[rbp]
	cmp	eax, DWORD PTR 692[rbp]
	jle	.L4643
	jmp	.L4324
.L4307:
.L4636:
	nop
	jmp	.L4324
.L4641:
	nop
	jmp	.L4324
.L4642:
	nop
.L4324:
	add	DWORD PTR 1848[rbp], 1
.L4303:
	mov	eax, DWORD PTR 1848[rbp]
	cmp	eax, DWORD PTR 780[rbp]
	jle	.L4644
	nop
.L4325:
	jmp	.L4540
.L4284:
.L4628:
	nop
.L4326:
	mov	DWORD PTR 1840[rbp], 0
	mov	rax, QWORD PTR 792[rbp]
	add	rax, 20
	mov	eax, DWORD PTR [rax]
	sub	eax, 1
	mov	DWORD PTR 600[rbp], eax
	jmp	.L4327
.L4658:
	nop
.L4328:
	mov	rax, QWORD PTR 792[rbp]
	add	rax, 16
	mov	edx, DWORD PTR [rax]
	mov	eax, DWORD PTR 1840[rbp]
	add	edx, eax
	mov	rax, QWORD PTR 1936[rbp]
	mov	rax, QWORD PTR [rax]
	add	rax, 560
	mov	rcx, rax
	call	_ZN5ArrayIjEixEi
	mov	QWORD PTR 592[rbp], rax
	mov	rax, QWORD PTR 592[rbp]
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR 156[rbp], eax
	mov	edx, DWORD PTR 156[rbp]
	mov	rax, QWORD PTR 1936[rbp]
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN3TKO8ASTARENA4KINDEj
	mov	QWORD PTR 584[rbp], rax
	cmp	QWORD PTR 584[rbp], 58
	jne	.L4645
	nop
.L4330:
	mov	eax, DWORD PTR 156[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 1936[rbp]
	call	_ZN3TKO7RESOLVE6STMTOFERNS0_3CTXEj
	mov	QWORD PTR 576[rbp], rax
	mov	rax, QWORD PTR 576[rbp]
	mov	QWORD PTR 568[rbp], rax
	mov	edx, DWORD PTR 444[rbp]
	mov	rax, QWORD PTR 568[rbp]
	add	rax, 4
	mov	eax, DWORD PTR [rax]
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 1936[rbp]
	call	_ZN3TKO7RESOLVE14RESOLVETYPEREFERNS0_3CTXEjj
	mov	DWORD PTR 564[rbp], eax
	mov	eax, DWORD PTR 564[rbp]
	mov	DWORD PTR 1836[rbp], eax
	mov	edx, DWORD PTR 444[rbp]
	mov	rax, QWORD PTR 568[rbp]
	add	rax, 8
	mov	r8d, DWORD PTR [rax]
	mov	rax, QWORD PTR 568[rbp]
	add	rax, 12
	mov	ecx, DWORD PTR [rax]
	mov	eax, DWORD PTR 1836[rbp]
	mov	DWORD PTR 32[rsp], edx
	mov	r9d, r8d
	mov	r8d, ecx
	mov	edx, eax
	mov	rcx, QWORD PTR 1936[rbp]
	call	_ZN3TKO7RESOLVE19ARRAYFROMBOUNDSNODEERNS0_3CTXEjjjj
	mov	DWORD PTR 560[rbp], eax
	mov	eax, DWORD PTR 560[rbp]
	mov	DWORD PTR 1836[rbp], eax
	mov	rax, QWORD PTR 568[rbp]
	mov	ecx, DWORD PTR [rax]
	mov	edx, DWORD PTR 156[rbp]
	mov	eax, DWORD PTR 1836[rbp]
	mov	r9d, ecx
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 1936[rbp]
	call	_ZN3TKO7RESOLVE12ARRAYTOOBIG_ERNS0_3CTXEjjj
	mov	edx, DWORD PTR 1944[rbp]
	mov	rax, QWORD PTR 1936[rbp]
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN3TKO8ASTARENA4KINDEj
	mov	QWORD PTR 552[rbp], rax
	cmp	QWORD PTR 552[rbp], 59
	jne	.L4646
	mov	eax, DWORD PTR 156[rbp]
	mov	edx, DWORD PTR 1952[rbp]
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 1936[rbp]
	call	_ZN3TKO7RESOLVE16CONSTBOUNDCHECK_ERNS0_3CTXEjj
	jmp	.L4334
.L4333:
.L4646:
	nop
.L4334:
	mov	eax, DWORD PTR 156[rbp]
	mov	edx, eax
	mov	rax, QWORD PTR 1936[rbp]
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN5ArrayIN3TKO7ASTNODEEEixEi
	mov	QWORD PTR 544[rbp], rax
	mov	rax, QWORD PTR 544[rbp]
	add	rax, 2
	movzx	eax, WORD PTR [rax]
	test	ax, ax
	jns	.L4647
	mov	rax, QWORD PTR 568[rbp]
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 568[rbp]
	add	rax, 36
	mov	r8d, DWORD PTR [rax]
	mov	ecx, DWORD PTR 156[rbp]
	mov	eax, DWORD PTR 1952[rbp]
	mov	DWORD PTR 32[rsp], edx
	mov	r9d, r8d
	mov	r8d, ecx
	mov	edx, eax
	mov	rcx, QWORD PTR 1936[rbp]
	call	_ZN3TKO7RESOLVE21CHECKSTATICMEMBERVAR_ERNS0_3CTXEjjjj
	jmp	.L4337
.L4336:
.L4647:
	nop
.L4337:
	mov	eax, DWORD PTR 1944[rbp]
	mov	edx, eax
	mov	rax, QWORD PTR 1936[rbp]
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN5ArrayIN3TKO7ASTNODEEEixEi
	mov	QWORD PTR 536[rbp], rax
	mov	eax, DWORD PTR 156[rbp]
	mov	edx, eax
	mov	rax, QWORD PTR 1936[rbp]
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN5ArrayIN3TKO7ASTNODEEEixEi
	mov	QWORD PTR 528[rbp], rax
	mov	rax, QWORD PTR 536[rbp]
	add	rax, 2
	movzx	edx, WORD PTR [rax]
	mov	rax, QWORD PTR 528[rbp]
	add	rax, 2
	movzx	eax, WORD PTR [rax]
	or	eax, edx
	mov	WORD PTR 526[rbp], ax
	movzx	eax, WORD PTR 526[rbp]
	and	eax, 16
	test	rax, rax
	je	.L4648
	cmp	DWORD PTR 1836[rbp], 0
	je	.L4649
	mov	rax, QWORD PTR 1936[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 1836[rbp]
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT9REFERENCEEj
	mov	DWORD PTR 520[rbp], eax
	mov	eax, DWORD PTR 520[rbp]
	mov	DWORD PTR 1836[rbp], eax
	jmp	.L4342
.L4339:
.L4341:
.L4648:
	nop
	jmp	.L4342
.L4649:
	nop
.L4342:
	cmp	DWORD PTR 1836[rbp], 0
	sete	al
	mov	BYTE PTR 1835[rbp], al
	cmp	BYTE PTR 1835[rbp], 0
	jne	.L4650
	mov	eax, DWORD PTR 1836[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 1936[rbp]
	call	_ZN3TKO7RESOLVE17TYPEISINCOMPLETE_ERNS0_3CTXEj
	mov	BYTE PTR 519[rbp], al
	movzx	eax, BYTE PTR 519[rbp]
	mov	BYTE PTR 1835[rbp], al
	jmp	.L4344
.L4650:
	nop
.L4344:
	cmp	BYTE PTR 1835[rbp], 0
	je	.L4651
	mov	rax, QWORD PTR 568[rbp]
	add	rax, 4
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	jne	.L4652
	mov	rax, QWORD PTR 568[rbp]
	add	rax, 8
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	sete	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR 1824[rbp], rax
	jmp	.L4349
.L4652:
	nop
.L4348:
	mov	QWORD PTR 1824[rbp], 0
.L4349:
	cmp	QWORD PTR 1824[rbp], 0
	je	.L4653
	lea	rax, 64[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	lea	rax, 64[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9d, 1
	lea	r8, .LC4[rip]
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
	lea	r8, .LC4[rip]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrAssign
	lea	rax, 128[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	rax, QWORD PTR 568[rbp]
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 1936[rbp]
	add	rax, 24
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN3TKO8INTERNER8SPELLINGEj
	mov	QWORD PTR 504[rbp], rax
	mov	rdx, QWORD PTR 504[rbp]
	lea	rax, 128[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrAssign
	mov	edx, DWORD PTR 156[rbp]
	mov	rax, QWORD PTR 1936[rbp]
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN3TKO8ASTARENA3LOCEj
	mov	DWORD PTR 500[rbp], eax
	mov	eax, DWORD PTR 500[rbp]
	mov	ecx, eax
	call	_ZN3TKO10POINTRANGEEj
	mov	QWORD PTR 56[rbp], rax
	mov	rax, QWORD PTR 1936[rbp]
	add	rax, 40
	mov	rax, QWORD PTR [rax]
	lea	r8, 128[rbp]
	mov	rcx, QWORD PTR 56[rbp]
	lea	rdx, 64[rbp]
	mov	QWORD PTR 40[rsp], rdx
	lea	rdx, 96[rbp]
	mov	QWORD PTR 32[rsp], rdx
	mov	r9, r8
	mov	r8, rcx
	mov	edx, 41
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
	jmp	.L4352
.L4351:
.L4653:
	nop
.L4352:
	mov	rax, QWORD PTR 1936[rbp]
	lea	rcx, 632[rax]
	lea	rax, 156[rbp]
	mov	rdx, rax
	call	_ZN5ArrayIjE4PUSHERj
	mov	rax, QWORD PTR 1936[rbp]
	lea	rcx, 712[rax]
	lea	rax, 444[rbp]
	mov	rdx, rax
	call	_ZN5ArrayIjE4PUSHERj
	jmp	.L4353
.L4346:
.L4651:
	nop
.L4353:
	cmp	BYTE PTR 1835[rbp], 0
	jne	.L4654
	mov	edx, DWORD PTR 444[rbp]
	mov	rax, QWORD PTR 568[rbp]
	mov	r8d, DWORD PTR [rax]
	mov	rax, QWORD PTR 568[rbp]
	add	rax, 8
	mov	ecx, DWORD PTR [rax]
	mov	eax, DWORD PTR 1836[rbp]
	mov	DWORD PTR 32[rsp], edx
	mov	r9d, r8d
	mov	r8d, ecx
	mov	edx, eax
	mov	rcx, QWORD PTR 1936[rbp]
	call	_ZN3TKO7RESOLVE12INITTOOMANY_ERNS0_3CTXEjjjj
	jmp	.L4355
.L4654:
	nop
.L4355:
	mov	rax, QWORD PTR 568[rbp]
	mov	edx, DWORD PTR [rax]
	mov	eax, DWORD PTR 444[rbp]
	mov	ecx, DWORD PTR 1836[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9d, ecx
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 1936[rbp]
	call	_ZN3TKO7RESOLVE12BINDDECLTYPEERNS0_3CTXEjjjb
	mov	edx, DWORD PTR 444[rbp]
	mov	rax, QWORD PTR 568[rbp]
	add	rax, 8
	mov	eax, DWORD PTR [rax]
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 1936[rbp]
	call	_ZN3TKO7RESOLVE8WALKSTMTERNS0_3CTXEjj
	mov	rax, QWORD PTR 568[rbp]
	add	rax, 12
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	je	.L4655
	mov	rax, QWORD PTR 568[rbp]
	add	rax, 12
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 1936[rbp]
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN3TKO8ASTARENA4KINDEj
	mov	QWORD PTR 488[rbp], rax
	cmp	QWORD PTR 488[rbp], 29
	jne	.L4656
	mov	rax, QWORD PTR 568[rbp]
	add	rax, 12
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 1936[rbp]
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN5ArrayIN3TKO7ASTNODEEEixEi
	mov	QWORD PTR 480[rbp], rax
	mov	rax, QWORD PTR 480[rbp]
	add	rax, 8
	mov	eax, DWORD PTR [rax]
	mov	rdx, QWORD PTR 1936[rbp]
	mov	rdx, QWORD PTR [rdx]
	lea	rcx, 400[rdx]
	mov	edx, eax
	call	_ZN5ArrayIN3TKO11LISTPAYLOADEEixEi
	mov	QWORD PTR 472[rbp], rax
	mov	rax, QWORD PTR 472[rbp]
	mov	QWORD PTR 464[rbp], rax
	mov	DWORD PTR 1820[rbp], 0
	mov	rax, QWORD PTR 464[rbp]
	add	rax, 8
	mov	eax, DWORD PTR [rax]
	sub	eax, 1
	mov	DWORD PTR 460[rbp], eax
	jmp	.L4359
.L4657:
	nop
.L4360:
	mov	rax, QWORD PTR 464[rbp]
	add	rax, 4
	mov	edx, DWORD PTR [rax]
	mov	eax, DWORD PTR 1820[rbp]
	add	edx, eax
	mov	rax, QWORD PTR 1936[rbp]
	mov	rax, QWORD PTR [rax]
	add	rax, 560
	mov	rcx, rax
	call	_ZN5ArrayIjEixEi
	mov	QWORD PTR 448[rbp], rax
	mov	edx, DWORD PTR 444[rbp]
	mov	rax, QWORD PTR 448[rbp]
	mov	eax, DWORD PTR [rax]
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 1936[rbp]
	call	_ZN3TKO7RESOLVE8WALKSTMTERNS0_3CTXEjj
.L4361:
	add	DWORD PTR 1820[rbp], 1
.L4359:
	mov	eax, DWORD PTR 1820[rbp]
	cmp	eax, DWORD PTR 460[rbp]
	jle	.L4657
	jmp	.L4331
.L4357:
.L4362:
.L4363:
.L4364:
.L4365:
.L4645:
	nop
	jmp	.L4331
.L4655:
	nop
	jmp	.L4331
.L4656:
	nop
.L4331:
	add	DWORD PTR 1840[rbp], 1
.L4327:
	mov	eax, DWORD PTR 1840[rbp]
	cmp	eax, DWORD PTR 600[rbp]
	jle	.L4658
	nop
.L4366:
	jmp	.L4540
.L4627:
	nop
.L4282:
	cmp	QWORD PTR 1664[rbp], 66
	jne	.L4659
	nop
.L4367:
	mov	eax, DWORD PTR 1944[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 1936[rbp]
	call	_ZN3TKO7RESOLVE6STMTOFERNS0_3CTXEj
	mov	QWORD PTR 1344[rbp], rax
	mov	rax, QWORD PTR 1344[rbp]
	mov	QWORD PTR 1336[rbp], rax
	mov	edx, DWORD PTR 444[rbp]
	mov	eax, DWORD PTR 1944[rbp]
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 1936[rbp]
	call	_ZN3TKO7RESOLVE14BINDPARAMTYPE_ERNS0_3CTXEjj
	mov	DWORD PTR 1332[rbp], eax
	cmp	DWORD PTR 1332[rbp], 0
	jne	.L4660
	mov	rax, QWORD PTR 1336[rbp]
	add	rax, 4
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	je	.L4661
	mov	rax, QWORD PTR 1936[rbp]
	lea	rcx, 312[rax]
	lea	rax, 1944[rbp]
	mov	rdx, rax
	call	_ZN5ArrayIjE4PUSHERj
	mov	rax, QWORD PTR 1936[rbp]
	lea	rcx, 392[rax]
	lea	rax, 444[rbp]
	mov	rdx, rax
	call	_ZN5ArrayIjE4PUSHERj
	jmp	.L4374
.L4370:
.L4372:
.L4373:
.L4660:
	nop
	jmp	.L4374
.L4661:
	nop
.L4374:
	mov	edx, DWORD PTR 444[rbp]
	mov	rax, QWORD PTR 1336[rbp]
	add	rax, 8
	mov	eax, DWORD PTR [rax]
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 1936[rbp]
	call	_ZN3TKO7RESOLVE8WALKSTMTERNS0_3CTXEjj
	jmp	.L4540
.L4659:
	nop
.L4368:
	cmp	QWORD PTR 1664[rbp], 64
	jne	.L4662
	nop
.L4375:
	mov	eax, DWORD PTR 1944[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 1936[rbp]
	call	_ZN3TKO7RESOLVE6STMTOFERNS0_3CTXEj
	mov	QWORD PTR 1320[rbp], rax
	mov	rax, QWORD PTR 1320[rbp]
	mov	QWORD PTR 1312[rbp], rax
	mov	rax, QWORD PTR 1936[rbp]
	lea	rcx, 152[rax]
	lea	rax, 1944[rbp]
	mov	rdx, rax
	call	_ZN5ArrayIjE4PUSHERj
	mov	rax, QWORD PTR 1936[rbp]
	lea	rcx, 232[rax]
	lea	rax, 444[rbp]
	mov	rdx, rax
	call	_ZN5ArrayIjE4PUSHERj
	mov	edx, DWORD PTR 444[rbp]
	mov	rax, QWORD PTR 1312[rbp]
	add	rax, 4
	mov	eax, DWORD PTR [rax]
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 1936[rbp]
	call	_ZN3TKO7RESOLVE14RESOLVETYPEREFERNS0_3CTXEjj
	mov	DWORD PTR 1308[rbp], eax
	mov	eax, DWORD PTR 1308[rbp]
	mov	DWORD PTR 1804[rbp], eax
	cmp	DWORD PTR 1804[rbp], 0
	jne	.L4663
	mov	edx, DWORD PTR 444[rbp]
	mov	rax, QWORD PTR 1312[rbp]
	mov	r8d, edx
	mov	rdx, rax
	mov	rcx, QWORD PTR 1936[rbp]
	call	_ZN3TKO7RESOLVE21FORWARDTYPEDEFTARGET_ERNS0_3CTXEPNS_11STMTPAYLOADEj
	mov	DWORD PTR 1304[rbp], eax
	mov	eax, DWORD PTR 1304[rbp]
	mov	DWORD PTR 1804[rbp], eax
	jmp	.L4378
.L4663:
	nop
.L4378:
	cmp	DWORD PTR 1804[rbp], 0
	je	.L4664
	mov	rax, QWORD PTR 1312[rbp]
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	setne	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR 1808[rbp], rax
	jmp	.L4381
.L4664:
	nop
.L4380:
	mov	QWORD PTR 1808[rbp], 0
.L4381:
	cmp	QWORD PTR 1808[rbp], 0
	je	.L4665
	mov	rax, QWORD PTR 1312[rbp]
	mov	ecx, DWORD PTR [rax]
	mov	edx, DWORD PTR 444[rbp]
	mov	rax, QWORD PTR 1936[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	r9d, 1
	mov	r8d, ecx
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE16LOOKUPLOCALTYPEDEjjb
	mov	DWORD PTR 1300[rbp], eax
	mov	eax, DWORD PTR 1300[rbp]
	mov	DWORD PTR 1296[rbp], eax
	mov	rax, QWORD PTR 1936[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 1296[rbp]
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE8SYMBOLATEj
	mov	QWORD PTR 1288[rbp], rax
	mov	rax, QWORD PTR 1288[rbp]
	mov	QWORD PTR 1280[rbp], rax
	cmp	QWORD PTR 1280[rbp], 0
	je	.L4666
	mov	rax, QWORD PTR 1280[rbp]
	movzx	eax, BYTE PTR [rax]
	cmp	al, 9
	jne	.L4667
	mov	rax, QWORD PTR 1280[rbp]
	lea	rdx, 16[rax]
	mov	eax, DWORD PTR 1804[rbp]
	mov	DWORD PTR [rdx], eax
	jmp	.L4389
.L4383:
.L4386:
.L4387:
.L4388:
.L4665:
	nop
	jmp	.L4389
.L4666:
	nop
	jmp	.L4389
.L4667:
	nop
.L4389:
	mov	DWORD PTR 1800[rbp], 0
	mov	rax, QWORD PTR 1312[rbp]
	add	rax, 20
	mov	eax, DWORD PTR [rax]
	sub	eax, 1
	mov	DWORD PTR 1276[rbp], eax
	jmp	.L4390
.L4668:
	nop
.L4391:
	mov	rax, QWORD PTR 1312[rbp]
	add	rax, 16
	mov	edx, DWORD PTR [rax]
	mov	eax, DWORD PTR 1800[rbp]
	add	edx, eax
	mov	rax, QWORD PTR 1936[rbp]
	mov	rax, QWORD PTR [rax]
	add	rax, 560
	mov	rcx, rax
	call	_ZN5ArrayIjEixEi
	mov	QWORD PTR 1264[rbp], rax
	mov	edx, DWORD PTR 444[rbp]
	mov	rax, QWORD PTR 1264[rbp]
	mov	eax, DWORD PTR [rax]
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 1936[rbp]
	call	_ZN3TKO7RESOLVE8WALKSTMTERNS0_3CTXEjj
.L4392:
	add	DWORD PTR 1800[rbp], 1
.L4390:
	mov	eax, DWORD PTR 1800[rbp]
	cmp	eax, DWORD PTR 1276[rbp]
	jle	.L4668
	nop
.L4393:
	jmp	.L4540
.L4662:
	nop
.L4376:
	cmp	QWORD PTR 1664[rbp], 61
	jne	.L4669
	nop
.L4394:
	mov	eax, DWORD PTR 1944[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 1936[rbp]
	call	_ZN3TKO7RESOLVE6STMTOFERNS0_3CTXEj
	mov	QWORD PTR 1256[rbp], rax
	mov	rax, QWORD PTR 1256[rbp]
	mov	QWORD PTR 1248[rbp], rax
	mov	eax, DWORD PTR 444[rbp]
	mov	DWORD PTR 1788[rbp], eax
	lea	rax, 32[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	lea	rax, 32[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9d, 5
	lea	r8, .LC6[rip]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrAssign
	mov	rax, QWORD PTR 1936[rbp]
	add	rax, 24
	mov	rax, QWORD PTR [rax]
	lea	rdx, 32[rbp]
	mov	rcx, rax
	call	_ZN3TKO8INTERNER9GETSTRINGE8FBSTRING
	mov	DWORD PTR 1244[rbp], eax
	mov	rax, QWORD PTR 1936[rbp]
	add	rax, 24
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 1244[rbp]
	mov	rcx, rax
	call	_ZN3TKO8INTERNER4FOLDEj
	mov	DWORD PTR 1240[rbp], eax
	mov	rax, QWORD PTR 1248[rbp]
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR 1240[rbp], eax
	sete	al
	mov	BYTE PTR 1239[rbp], al
	lea	rax, 32[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	cmp	BYTE PTR 1239[rbp], 0
	je	.L4670
	mov	edx, DWORD PTR 444[rbp]
	mov	rax, QWORD PTR 1936[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE7SCOPEATEj
	mov	QWORD PTR 1224[rbp], rax
	mov	rax, QWORD PTR 1224[rbp]
	mov	QWORD PTR 1216[rbp], rax
	cmp	QWORD PTR 1216[rbp], 0
	je	.L4671
	mov	rax, QWORD PTR 1216[rbp]
	add	rax, 4
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	je	.L4672
	mov	rax, QWORD PTR 1216[rbp]
	mov	eax, DWORD PTR 4[rax]
	mov	DWORD PTR 1788[rbp], eax
	jmp	.L4403
.L4397:
.L4400:
.L4401:
.L4402:
.L4670:
	nop
	jmp	.L4403
.L4671:
	nop
	jmp	.L4403
.L4672:
	nop
.L4403:
	mov	rax, QWORD PTR 1248[rbp]
	add	rax, 4
	mov	eax, DWORD PTR [rax]
	mov	edx, DWORD PTR 1788[rbp]
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 1936[rbp]
	call	_ZN3TKO7RESOLVE14RESOLVETYPEREFERNS0_3CTXEjj
	mov	DWORD PTR 1212[rbp], eax
	mov	eax, DWORD PTR 1212[rbp]
	mov	DWORD PTR 1784[rbp], eax
	movsx	eax, BYTE PTR 1239[rbp]
	neg	eax
	test	eax, eax
	je	.L4673
	cmp	DWORD PTR 1784[rbp], 0
	setne	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR 1792[rbp], rax
	jmp	.L4406
.L4673:
	nop
.L4405:
	mov	QWORD PTR 1792[rbp], 0
.L4406:
	cmp	QWORD PTR 1792[rbp], 0
	je	.L4674
	mov	edx, DWORD PTR 444[rbp]
	mov	rax, QWORD PTR 1936[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE7SCOPEATEj
	mov	QWORD PTR 1200[rbp], rax
	mov	rax, QWORD PTR 1200[rbp]
	mov	QWORD PTR 1192[rbp], rax
	cmp	QWORD PTR 1192[rbp], 0
	je	.L4675
	mov	rax, QWORD PTR 1192[rbp]
	add	rax, 8
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 1936[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE8SYMBOLATEj
	mov	QWORD PTR 1184[rbp], rax
	mov	rax, QWORD PTR 1184[rbp]
	mov	QWORD PTR 1176[rbp], rax
	cmp	QWORD PTR 1176[rbp], 0
	je	.L4676
	mov	rax, QWORD PTR 1936[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 1784[rbp]
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT9UNQUALIFYEj
	mov	DWORD PTR 1172[rbp], eax
	mov	rax, QWORD PTR 1176[rbp]
	add	rax, 16
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 1936[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT9UNQUALIFYEj
	mov	DWORD PTR 1168[rbp], eax
	mov	eax, DWORD PTR 1172[rbp]
	cmp	eax, DWORD PTR 1168[rbp]
	jne	.L4677
	mov	rax, QWORD PTR 1936[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 1788[rbp]
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE7SCOPEATEj
	mov	QWORD PTR 1160[rbp], rax
	mov	rax, QWORD PTR 1160[rbp]
	mov	QWORD PTR 1152[rbp], rax
	cmp	QWORD PTR 1152[rbp], 0
	je	.L4678
	mov	rax, QWORD PTR 1152[rbp]
	add	rax, 4
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	je	.L4679
	mov	rax, QWORD PTR 1152[rbp]
	add	rax, 4
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 1248[rbp]
	add	rax, 4
	mov	eax, DWORD PTR [rax]
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 1936[rbp]
	call	_ZN3TKO7RESOLVE14RESOLVETYPEREFERNS0_3CTXEjj
	mov	DWORD PTR 1148[rbp], eax
	mov	eax, DWORD PTR 1148[rbp]
	mov	DWORD PTR 1784[rbp], eax
	jmp	.L4424
.L4408:
.L4414:
.L4415:
.L4416:
.L4417:
.L4418:
.L4419:
.L4420:
.L4421:
.L4422:
.L4423:
.L4674:
	nop
	jmp	.L4424
.L4675:
	nop
	jmp	.L4424
.L4676:
	nop
	jmp	.L4424
.L4677:
	nop
	jmp	.L4424
.L4678:
	nop
	jmp	.L4424
.L4679:
	nop
.L4424:
	mov	edx, DWORD PTR 444[rbp]
	mov	rax, QWORD PTR 1248[rbp]
	add	rax, 20
	mov	r8d, DWORD PTR [rax]
	mov	rax, QWORD PTR 1248[rbp]
	add	rax, 16
	mov	ecx, DWORD PTR [rax]
	mov	eax, DWORD PTR 1784[rbp]
	mov	DWORD PTR 32[rsp], edx
	mov	r9d, r8d
	mov	r8d, ecx
	mov	edx, eax
	mov	rcx, QWORD PTR 1936[rbp]
	call	_ZN3TKO7RESOLVE15ARRAYFROMBOUNDSERNS0_3CTXEjiij
	mov	DWORD PTR 1144[rbp], eax
	mov	eax, DWORD PTR 1144[rbp]
	mov	DWORD PTR 1784[rbp], eax
	mov	rax, QWORD PTR 1248[rbp]
	mov	ecx, DWORD PTR [rax]
	mov	edx, DWORD PTR 1944[rbp]
	mov	eax, DWORD PTR 1784[rbp]
	mov	r9d, ecx
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 1936[rbp]
	call	_ZN3TKO7RESOLVE12ARRAYTOOBIG_ERNS0_3CTXEjjj
	mov	rax, QWORD PTR 1248[rbp]
	mov	edx, DWORD PTR [rax]
	mov	eax, DWORD PTR 444[rbp]
	mov	ecx, DWORD PTR 1784[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9d, ecx
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 1936[rbp]
	call	_ZN3TKO7RESOLVE12BINDDECLTYPEERNS0_3CTXEjjjb
	mov	rax, QWORD PTR 1248[rbp]
	add	rax, 12
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	je	.L4680
	mov	edx, DWORD PTR 444[rbp]
	mov	rax, QWORD PTR 1248[rbp]
	add	rax, 12
	mov	eax, DWORD PTR [rax]
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 1936[rbp]
	call	_ZN3TKO7RESOLVE8WALKEXPRERNS0_3CTXEjj
	jmp	.L4426
.L4680:
	nop
.L4426:
	mov	rax, QWORD PTR 1248[rbp]
	add	rax, 8
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	je	.L4681
	mov	rax, QWORD PTR 1248[rbp]
	mov	ecx, DWORD PTR [rax]
	mov	edx, DWORD PTR 444[rbp]
	mov	rax, QWORD PTR 1936[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	r8d, ecx
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE11LOOKUPLOCALEjj
	mov	DWORD PTR 1140[rbp], eax
	mov	eax, DWORD PTR 1140[rbp]
	mov	DWORD PTR 1136[rbp], eax
	mov	rax, QWORD PTR 1936[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 1136[rbp]
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE8SYMBOLATEj
	mov	QWORD PTR 1128[rbp], rax
	mov	rax, QWORD PTR 1128[rbp]
	mov	QWORD PTR 1120[rbp], rax
	cmp	QWORD PTR 1120[rbp], 0
	je	.L4682
	mov	r9d, DWORD PTR 444[rbp]
	mov	rax, QWORD PTR 1936[rbp]
	add	rax, 8
	mov	r8, QWORD PTR [rax]
	mov	rax, QWORD PTR 1936[rbp]
	add	rax, 24
	mov	rcx, QWORD PTR [rax]
	mov	rax, QWORD PTR 1936[rbp]
	add	rax, 32
	mov	r11, QWORD PTR [rax]
	mov	rax, QWORD PTR 1248[rbp]
	add	rax, 8
	mov	r10d, DWORD PTR [rax]
	mov	rax, QWORD PTR 1936[rbp]
	mov	rdx, QWORD PTR [rax]
	lea	rax, -32[rbp]
	mov	QWORD PTR 80[rsp], 0
	mov	QWORD PTR 72[rsp], 0
	mov	DWORD PTR 64[rsp], 0
	mov	DWORD PTR 56[rsp], r9d
	mov	QWORD PTR 48[rsp], r8
	mov	DWORD PTR 40[rsp], 64
	mov	QWORD PTR 32[rsp], rcx
	mov	r9, r11
	mov	r8d, r10d
	mov	rcx, rax
	call	_ZN3TKO5CHECK7CONSTOFERNS_8ASTARENAEjRNS_13SOURCEMANAGERERNS_8INTERNEREiPNS_11SYMBOLTABLEEjiPNS_11TYPECONTEXTEPNS_12SEMANTICINFOE
	mov	rax, QWORD PTR -32[rbp]
	mov	rdx, QWORD PTR -24[rbp]
	mov	QWORD PTR 0[rbp], rax
	mov	QWORD PTR 8[rbp], rdx
	mov	rax, QWORD PTR -16[rbp]
	mov	QWORD PTR 16[rbp], rax
	mov	rax, rbp
	movzx	eax, BYTE PTR [rax]
	movsx	eax, al
	neg	eax
	test	eax, eax
	je	.L4683
	mov	rax, rbp
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	test	rax, rax
	setg	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR 1776[rbp], rax
	jmp	.L4432
.L4683:
	nop
.L4431:
	mov	QWORD PTR 1776[rbp], 0
.L4432:
	cmp	QWORD PTR 1776[rbp], 0
	je	.L4684
	mov	rax, rbp
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	cmp	rax, 64
	setle	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR 1768[rbp], rax
	jmp	.L4435
.L4684:
	nop
.L4434:
	mov	QWORD PTR 1768[rbp], 0
.L4435:
	cmp	QWORD PTR 1768[rbp], 0
	je	.L4685
	mov	rax, QWORD PTR 1120[rbp]
	add	rax, 4
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 1120[rbp]
	add	rax, 4
	or	dh, 64
	mov	DWORD PTR [rax], edx
	mov	rax, rbp
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	ecx, eax
	mov	rax, QWORD PTR 1120[rbp]
	lea	rdx, 40[rax]
	movsx	rax, ecx
	mov	QWORD PTR [rdx], rax
.L4437:
.L4438:
.L4428:
.L4439:
.L4440:
.L4441:
	jmp	.L4720
.L4669:
	nop
.L4395:
	cmp	QWORD PTR 1664[rbp], 37
	je	.L4686
	nop
.L4442:
	cmp	QWORD PTR 1664[rbp], 38
	jne	.L4687
	jmp	.L4443
.L4686:
	nop
.L4443:
	mov	eax, DWORD PTR 1944[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 1936[rbp]
	call	_ZN3TKO7RESOLVE6STMTOFERNS0_3CTXEj
	mov	QWORD PTR 1016[rbp], rax
	mov	rax, QWORD PTR 1016[rbp]
	mov	QWORD PTR 1008[rbp], rax
	mov	rax, QWORD PTR 1008[rbp]
	add	rax, 12
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	je	.L4688
	mov	edx, DWORD PTR 444[rbp]
	mov	rax, QWORD PTR 1008[rbp]
	add	rax, 12
	mov	eax, DWORD PTR [rax]
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 1936[rbp]
	call	_ZN3TKO7RESOLVE14RESOLVETYPEREFERNS0_3CTXEjj
	mov	DWORD PTR 1004[rbp], eax
	mov	eax, DWORD PTR 1004[rbp]
	mov	DWORD PTR 1724[rbp], eax
	cmp	QWORD PTR 1664[rbp], 38
	jne	.L4689
	cmp	DWORD PTR 1724[rbp], 0
	setne	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR 1736[rbp], rax
	jmp	.L4449
.L4689:
	nop
.L4448:
	mov	QWORD PTR 1736[rbp], 0
.L4449:
	cmp	QWORD PTR 1736[rbp], 0
	je	.L4690
	mov	rax, QWORD PTR 1008[rbp]
	add	rax, 24
	movzx	eax, WORD PTR [rax]
	cmp	ax, 68
	jne	.L4691
	mov	rax, QWORD PTR 1936[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 1724[rbp]
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT4KINDEj
	mov	QWORD PTR 992[rbp], rax
	cmp	QWORD PTR 992[rbp], 3
	je	.L4692
	mov	rax, QWORD PTR 1936[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 1724[rbp]
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT9REFERENCEEj
	mov	DWORD PTR 988[rbp], eax
	mov	eax, DWORD PTR 988[rbp]
	mov	DWORD PTR 1724[rbp], eax
	jmp	.L4458
.L4451:
.L4454:
.L4455:
.L4456:
.L4457:
.L4690:
	nop
	jmp	.L4458
.L4691:
	nop
	jmp	.L4458
.L4692:
	nop
.L4458:
	mov	rax, QWORD PTR 1008[rbp]
	add	rax, 4
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	je	.L4693
	mov	rax, QWORD PTR 1008[rbp]
	add	rax, 4
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 1936[rbp]
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN3TKO8ASTARENA4KINDEj
	mov	QWORD PTR 976[rbp], rax
	cmp	QWORD PTR 976[rbp], 6
	sete	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR 1728[rbp], rax
	jmp	.L4461
.L4693:
	nop
.L4460:
	mov	QWORD PTR 1728[rbp], 0
.L4461:
	cmp	QWORD PTR 1728[rbp], 0
	je	.L4694
	mov	rax, QWORD PTR 1008[rbp]
	add	rax, 4
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 1936[rbp]
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN5ArrayIN3TKO7ASTNODEEEixEi
	mov	QWORD PTR 968[rbp], rax
	mov	rax, QWORD PTR 968[rbp]
	add	rax, 8
	mov	eax, DWORD PTR [rax]
	mov	rdx, QWORD PTR 1936[rbp]
	mov	rdx, QWORD PTR [rdx]
	lea	rcx, 320[rdx]
	mov	edx, eax
	call	_ZN5ArrayIN3TKO12IDENTPAYLOADEEixEi
	mov	QWORD PTR 960[rbp], rax
	mov	rax, QWORD PTR 960[rbp]
	mov	QWORD PTR 952[rbp], rax
	mov	rax, QWORD PTR 952[rbp]
	mov	edx, DWORD PTR [rax]
	mov	eax, DWORD PTR 444[rbp]
	mov	ecx, DWORD PTR 1724[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9d, ecx
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 1936[rbp]
	call	_ZN3TKO7RESOLVE12BINDDECLTYPEERNS0_3CTXEjjjb
	jmp	.L4465
.L4446:
.L4463:
.L4464:
.L4688:
	nop
	jmp	.L4465
.L4694:
	nop
.L4465:
	mov	DWORD PTR 1720[rbp], 0
	mov	rax, QWORD PTR 1008[rbp]
	add	rax, 20
	mov	eax, DWORD PTR [rax]
	sub	eax, 1
	mov	DWORD PTR 948[rbp], eax
	jmp	.L4466
.L4695:
	nop
.L4467:
	mov	rax, QWORD PTR 1008[rbp]
	add	rax, 16
	mov	edx, DWORD PTR [rax]
	mov	eax, DWORD PTR 1720[rbp]
	add	edx, eax
	mov	rax, QWORD PTR 1936[rbp]
	mov	rax, QWORD PTR [rax]
	add	rax, 560
	mov	rcx, rax
	call	_ZN5ArrayIjEixEi
	mov	QWORD PTR 808[rbp], rax
	mov	edx, DWORD PTR 444[rbp]
	mov	rax, QWORD PTR 808[rbp]
	mov	eax, DWORD PTR [rax]
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 1936[rbp]
	call	_ZN3TKO7RESOLVE8WALKSTMTERNS0_3CTXEjj
.L4468:
	add	DWORD PTR 1720[rbp], 1
.L4466:
	mov	eax, DWORD PTR 1720[rbp]
	cmp	eax, DWORD PTR 948[rbp]
	jle	.L4695
	nop
.L4469:
	mov	edx, DWORD PTR 444[rbp]
	mov	rax, QWORD PTR 1008[rbp]
	add	rax, 4
	mov	eax, DWORD PTR [rax]
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 1936[rbp]
	call	_ZN3TKO7RESOLVE8WALKEXPRERNS0_3CTXEjj
	cmp	QWORD PTR 1664[rbp], 38
	jne	.L4696
	mov	rax, QWORD PTR 1008[rbp]
	add	rax, 12
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	sete	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR 1760[rbp], rax
	jmp	.L4472
.L4696:
	nop
.L4471:
	mov	QWORD PTR 1760[rbp], 0
.L4472:
	cmp	QWORD PTR 1760[rbp], 0
	je	.L4697
	mov	rax, QWORD PTR 1008[rbp]
	add	rax, 20
	mov	eax, DWORD PTR [rax]
	cmp	eax, 1
	sete	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR 1752[rbp], rax
	jmp	.L4475
.L4697:
	nop
.L4474:
	mov	QWORD PTR 1752[rbp], 0
.L4475:
	cmp	QWORD PTR 1752[rbp], 0
	je	.L4698
	mov	rax, QWORD PTR 1008[rbp]
	add	rax, 4
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	setne	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR 1744[rbp], rax
	jmp	.L4478
.L4698:
	nop
.L4477:
	mov	QWORD PTR 1744[rbp], 0
.L4478:
	cmp	QWORD PTR 1744[rbp], 0
	je	.L4699
	mov	rax, QWORD PTR 1008[rbp]
	add	rax, 4
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 1936[rbp]
	add	rax, 48
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN3TKO12SEMANTICINFO5REFOFEj
	mov	DWORD PTR 944[rbp], eax
	mov	eax, DWORD PTR 944[rbp]
	mov	DWORD PTR 940[rbp], eax
	mov	rax, QWORD PTR 1936[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 940[rbp]
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE8SYMBOLATEj
	mov	QWORD PTR 928[rbp], rax
	mov	rax, QWORD PTR 928[rbp]
	mov	QWORD PTR 920[rbp], rax
	cmp	QWORD PTR 920[rbp], 0
	je	.L4700
	mov	rax, QWORD PTR 920[rbp]
	add	rax, 16
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	jne	.L4701
	mov	rax, QWORD PTR 1008[rbp]
	add	rax, 16
	mov	eax, DWORD PTR [rax]
	mov	rdx, QWORD PTR 1936[rbp]
	mov	rdx, QWORD PTR [rdx]
	lea	rcx, 560[rdx]
	mov	edx, eax
	call	_ZN5ArrayIjEixEi
	mov	QWORD PTR 912[rbp], rax
	mov	rax, QWORD PTR 912[rbp]
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR 908[rbp], eax
	mov	DWORD PTR 1716[rbp], 0
	mov	rax, QWORD PTR 1936[rbp]
	add	rax, 48
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 908[rbp]
	mov	rcx, rax
	call	_ZN3TKO12SEMANTICINFO5REFOFEj
	mov	DWORD PTR 904[rbp], eax
	mov	rax, QWORD PTR 1936[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 904[rbp]
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE8SYMBOLATEj
	mov	QWORD PTR 896[rbp], rax
	mov	rax, QWORD PTR 896[rbp]
	mov	QWORD PTR 888[rbp], rax
	cmp	QWORD PTR 888[rbp], 0
	je	.L4702
	mov	rax, QWORD PTR 888[rbp]
	mov	eax, DWORD PTR 16[rax]
	mov	DWORD PTR 1716[rbp], eax
	jmp	.L4484
.L4702:
	nop
.L4484:
	cmp	DWORD PTR 1716[rbp], 0
	je	.L4703
	mov	rax, QWORD PTR 1936[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 1716[rbp]
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT9UNQUALIFYEj
	mov	DWORD PTR 884[rbp], eax
	mov	eax, DWORD PTR 884[rbp]
	mov	DWORD PTR 1716[rbp], eax
	mov	rax, QWORD PTR 1936[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 1716[rbp]
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT4KINDEj
	mov	QWORD PTR 872[rbp], rax
	cmp	QWORD PTR 872[rbp], 3
	jne	.L4704
	mov	rax, QWORD PTR 1936[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 1716[rbp]
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT5INNEREj
	mov	DWORD PTR 868[rbp], eax
	mov	rax, QWORD PTR 1936[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 868[rbp]
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT9UNQUALIFYEj
	mov	DWORD PTR 864[rbp], eax
	mov	eax, DWORD PTR 864[rbp]
	mov	DWORD PTR 1716[rbp], eax
	jmp	.L4490
.L4486:
.L4488:
.L4489:
.L4703:
	nop
	jmp	.L4490
.L4704:
	nop
.L4490:
	cmp	DWORD PTR 1716[rbp], 0
	je	.L4705
	mov	rax, QWORD PTR 1936[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 1716[rbp]
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT4KINDEj
	mov	QWORD PTR 856[rbp], rax
	cmp	QWORD PTR 856[rbp], 4
	jne	.L4706
	mov	rax, QWORD PTR 1936[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 1716[rbp]
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT5INNEREj
	mov	DWORD PTR 852[rbp], eax
	mov	rax, QWORD PTR 920[rbp]
	lea	rdx, 16[rax]
	mov	eax, DWORD PTR 852[rbp]
	mov	DWORD PTR [rdx], eax
	jmp	.L4498
.L4706:
	nop
.L4494:
	mov	rax, QWORD PTR 1936[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 1716[rbp]
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT4KINDEj
	mov	QWORD PTR 840[rbp], rax
	cmp	QWORD PTR 840[rbp], 6
	jne	.L4707
	mov	eax, DWORD PTR 1716[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 1936[rbp]
	call	_ZN3TKO7RESOLVE13ITERELEMTYPE_ERNS0_3CTXEj
	mov	DWORD PTR 836[rbp], eax
	mov	rax, QWORD PTR 920[rbp]
	lea	rdx, 16[rax]
	mov	eax, DWORD PTR 836[rbp]
	mov	DWORD PTR [rdx], eax
	jmp	.L4498
.L4492:
.L4496:
.L4497:
.L4705:
	nop
	jmp	.L4498
.L4707:
	nop
.L4498:
	mov	rax, QWORD PTR 1008[rbp]
	add	rax, 24
	movzx	eax, WORD PTR [rax]
	cmp	ax, 68
	jne	.L4708
	mov	rax, QWORD PTR 920[rbp]
	add	rax, 16
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	je	.L4709
	mov	rax, QWORD PTR 920[rbp]
	add	rax, 16
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 1936[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT4KINDEj
	mov	QWORD PTR 824[rbp], rax
	cmp	QWORD PTR 824[rbp], 3
	je	.L4710
	mov	rax, QWORD PTR 920[rbp]
	add	rax, 16
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 1936[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT9REFERENCEEj
	mov	DWORD PTR 820[rbp], eax
	mov	rax, QWORD PTR 920[rbp]
	lea	rdx, 16[rax]
	mov	eax, DWORD PTR 820[rbp]
	mov	DWORD PTR [rdx], eax
	jmp	.L4512
.L4480:
.L4502:
.L4503:
.L4504:
.L4505:
.L4506:
.L4507:
.L4508:
.L4509:
.L4510:
.L4511:
.L4699:
	nop
	jmp	.L4512
.L4700:
	nop
	jmp	.L4512
.L4701:
	nop
	jmp	.L4512
.L4708:
	nop
	jmp	.L4512
.L4709:
	nop
	jmp	.L4512
.L4710:
	nop
.L4512:
	mov	edx, DWORD PTR 444[rbp]
	mov	rax, QWORD PTR 1008[rbp]
	add	rax, 8
	mov	eax, DWORD PTR [rax]
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 1936[rbp]
	call	_ZN3TKO7RESOLVE8WALKSTMTERNS0_3CTXEjj
	jmp	.L4540
.L4687:
	nop
.L4444:
	cmp	QWORD PTR 1664[rbp], 65
	jne	.L4711
	nop
.L4513:
	mov	eax, DWORD PTR 1944[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 1936[rbp]
	call	_ZN3TKO7RESOLVE6STMTOFERNS0_3CTXEj
	mov	QWORD PTR 1112[rbp], rax
	mov	rax, QWORD PTR 1112[rbp]
	mov	QWORD PTR 1104[rbp], rax
	mov	rax, QWORD PTR 1936[rbp]
	mov	eax, DWORD PTR 64[rax]
	mov	DWORD PTR 1100[rbp], eax
	mov	edx, DWORD PTR 1944[rbp]
	mov	rax, QWORD PTR 1936[rbp]
	add	rax, 48
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN3TKO12SEMANTICINFO5REFOFEj
	mov	DWORD PTR 1096[rbp], eax
	mov	rax, QWORD PTR 1936[rbp]
	lea	rdx, 64[rax]
	mov	eax, DWORD PTR 1096[rbp]
	mov	DWORD PTR [rdx], eax
	mov	edx, DWORD PTR 444[rbp]
	mov	rax, QWORD PTR 1104[rbp]
	add	rax, 4
	mov	eax, DWORD PTR [rax]
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 1936[rbp]
	call	_ZN3TKO7RESOLVE14RESOLVETYPEREFERNS0_3CTXEjj
	mov	DWORD PTR 1092[rbp], eax
	mov	eax, DWORD PTR 1092[rbp]
	mov	DWORD PTR 1088[rbp], eax
	mov	rax, QWORD PTR 1936[rbp]
	add	rax, 64
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 1936[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE8SYMBOLATEj
	mov	QWORD PTR 1080[rbp], rax
	mov	rax, QWORD PTR 1080[rbp]
	mov	QWORD PTR 1072[rbp], rax
	cmp	QWORD PTR 1072[rbp], 0
	je	.L4712
	cmp	DWORD PTR 1088[rbp], 0
	setne	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR 1704[rbp], rax
	jmp	.L4517
.L4712:
	nop
.L4516:
	mov	QWORD PTR 1704[rbp], 0
.L4517:
	cmp	QWORD PTR 1704[rbp], 0
	je	.L4713
	mov	rax, QWORD PTR 1072[rbp]
	add	rax, 16
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	sete	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR 1696[rbp], rax
	jmp	.L4520
.L4713:
	nop
.L4519:
	mov	QWORD PTR 1696[rbp], 0
.L4520:
	cmp	QWORD PTR 1696[rbp], 0
	je	.L4714
	mov	rax, QWORD PTR 1072[rbp]
	lea	rdx, 16[rax]
	mov	eax, DWORD PTR 1088[rbp]
	mov	DWORD PTR [rdx], eax
	jmp	.L4523
.L4522:
.L4714:
	nop
.L4523:
	cmp	DWORD PTR 1088[rbp], 0
	jne	.L4715
	mov	rax, QWORD PTR 1104[rbp]
	add	rax, 4
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	setne	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR 1688[rbp], rax
	jmp	.L4526
.L4715:
	nop
.L4525:
	mov	QWORD PTR 1688[rbp], 0
.L4526:
	cmp	QWORD PTR 1688[rbp], 0
	je	.L4716
	mov	rax, QWORD PTR 1936[rbp]
	lea	rcx, 472[rax]
	lea	rax, 1944[rbp]
	mov	rdx, rax
	call	_ZN5ArrayIjE4PUSHERj
	mov	rax, QWORD PTR 1936[rbp]
	lea	rcx, 552[rax]
	lea	rax, 444[rbp]
	mov	rdx, rax
	call	_ZN5ArrayIjE4PUSHERj
	jmp	.L4529
.L4528:
.L4716:
	nop
.L4529:
	mov	rax, QWORD PTR 1104[rbp]
	add	rax, 36
	mov	edx, DWORD PTR [rax]
	mov	eax, DWORD PTR 444[rbp]
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 1936[rbp]
	call	_ZN3TKO7RESOLVE8BINDTHISERNS0_3CTXEjj
	mov	DWORD PTR 1684[rbp], 0
	mov	rax, QWORD PTR 1104[rbp]
	add	rax, 20
	mov	eax, DWORD PTR [rax]
	sub	eax, 1
	mov	DWORD PTR 1068[rbp], eax
	jmp	.L4530
.L4717:
	nop
.L4531:
	mov	rax, QWORD PTR 1104[rbp]
	add	rax, 16
	mov	edx, DWORD PTR [rax]
	mov	eax, DWORD PTR 1684[rbp]
	add	edx, eax
	mov	rax, QWORD PTR 1936[rbp]
	mov	rax, QWORD PTR [rax]
	add	rax, 560
	mov	rcx, rax
	call	_ZN5ArrayIjEixEi
	mov	QWORD PTR 1056[rbp], rax
	mov	edx, DWORD PTR 444[rbp]
	mov	rax, QWORD PTR 1056[rbp]
	mov	eax, DWORD PTR [rax]
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 1936[rbp]
	call	_ZN3TKO7RESOLVE8WALKSTMTERNS0_3CTXEjj
.L4532:
	add	DWORD PTR 1684[rbp], 1
.L4530:
	mov	eax, DWORD PTR 1684[rbp]
	cmp	eax, DWORD PTR 1068[rbp]
	jle	.L4717
	nop
.L4533:
	mov	edx, DWORD PTR 444[rbp]
	mov	rax, QWORD PTR 1104[rbp]
	add	rax, 8
	mov	eax, DWORD PTR [rax]
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 1936[rbp]
	call	_ZN3TKO7RESOLVE8WALKSTMTERNS0_3CTXEjj
	mov	rax, QWORD PTR 1936[rbp]
	lea	rdx, 64[rax]
	mov	eax, DWORD PTR 1100[rbp]
	mov	DWORD PTR [rdx], eax
	jmp	.L4540
.L4514:
.L4711:
	nop
.L4534:
	mov	eax, DWORD PTR 1944[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 1936[rbp]
	call	_ZN3TKO7RESOLVE6STMTOFERNS0_3CTXEj
	mov	QWORD PTR 1048[rbp], rax
	mov	rax, QWORD PTR 1048[rbp]
	mov	QWORD PTR 1040[rbp], rax
	cmp	QWORD PTR 1040[rbp], 0
	je	.L4718
	nop
.L4536:
	mov	edx, DWORD PTR 444[rbp]
	mov	rax, QWORD PTR 1040[rbp]
	add	rax, 4
	mov	eax, DWORD PTR [rax]
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 1936[rbp]
	call	_ZN3TKO7RESOLVE8WALKSTMTERNS0_3CTXEjj
	mov	edx, DWORD PTR 444[rbp]
	mov	rax, QWORD PTR 1040[rbp]
	add	rax, 8
	mov	eax, DWORD PTR [rax]
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 1936[rbp]
	call	_ZN3TKO7RESOLVE8WALKSTMTERNS0_3CTXEjj
	mov	edx, DWORD PTR 444[rbp]
	mov	rax, QWORD PTR 1040[rbp]
	add	rax, 12
	mov	eax, DWORD PTR [rax]
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 1936[rbp]
	call	_ZN3TKO7RESOLVE8WALKSTMTERNS0_3CTXEjj
	mov	DWORD PTR 1680[rbp], 0
	mov	rax, QWORD PTR 1040[rbp]
	add	rax, 20
	mov	eax, DWORD PTR [rax]
	sub	eax, 1
	mov	DWORD PTR 1036[rbp], eax
	jmp	.L4537
.L4719:
	nop
.L4538:
	mov	rax, QWORD PTR 1040[rbp]
	add	rax, 16
	mov	edx, DWORD PTR [rax]
	mov	eax, DWORD PTR 1680[rbp]
	add	edx, eax
	mov	rax, QWORD PTR 1936[rbp]
	mov	rax, QWORD PTR [rax]
	add	rax, 560
	mov	rcx, rax
	call	_ZN5ArrayIjEixEi
	mov	QWORD PTR 1024[rbp], rax
	mov	edx, DWORD PTR 444[rbp]
	mov	rax, QWORD PTR 1024[rbp]
	mov	eax, DWORD PTR [rax]
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 1936[rbp]
	call	_ZN3TKO7RESOLVE8WALKSTMTERNS0_3CTXEjj
.L4539:
	add	DWORD PTR 1680[rbp], 1
.L4537:
	mov	eax, DWORD PTR 1680[rbp]
	cmp	eax, DWORD PTR 1036[rbp]
	jle	.L4719
	jmp	.L4540
.L4185:
.L4585:
	nop
	jmp	.L4720
.L4594:
	nop
	jmp	.L4720
.L4681:
	nop
	jmp	.L4720
.L4682:
	nop
	jmp	.L4720
.L4685:
	nop
	jmp	.L4720
.L4718:
	nop
.L4540:
.L4720:
	nop
	add	rsp, 2040
	pop	rbx
	pop	rbp
	ret
	.seh_endproc
	.globl	_ZN3TKO7RESOLVE3RUNERNS_8ASTARENAEjRNS_11SYMBOLTABLEERNS_11TYPECONTEXTERNS_8INTERNERERNS_16DIAGNOSTICENGINEERNS_13SOURCEMANAGERERNS_12SEMANTICINFOERNS0_5STATSEPv
	.def	_ZN3TKO7RESOLVE3RUNERNS_8ASTARENAEjRNS_11SYMBOLTABLEERNS_11TYPECONTEXTERNS_8INTERNERERNS_16DIAGNOSTICENGINEERNS_13SOURCEMANAGERERNS_12SEMANTICINFOERNS0_5STATSEPv;	.scl	2;	.type	32;	.endef
	.seh_proc	_ZN3TKO7RESOLVE3RUNERNS_8ASTARENAEjRNS_11SYMBOLTABLEERNS_11TYPECONTEXTERNS_8INTERNERERNS_16DIAGNOSTICENGINEERNS_13SOURCEMANAGERERNS_12SEMANTICINFOERNS0_5STATSEPv
_ZN3TKO7RESOLVE3RUNERNS_8ASTARENAEjRNS_11SYMBOLTABLEERNS_11TYPECONTEXTERNS_8INTERNERERNS_16DIAGNOSTICENGINEERNS_13SOURCEMANAGERERNS_12SEMANTICINFOERNS0_5STATSEPv:
	push	rbp
	.seh_pushreg	rbp
	sub	rsp, 1520
	.seh_stackalloc	1520
	lea	rbp, 128[rsp]
	.seh_setframe	rbp, 128
	.seh_endprologue
	mov	QWORD PTR 1408[rbp], rcx
	mov	DWORD PTR 1416[rbp], edx
	mov	QWORD PTR 1424[rbp], r8
	mov	QWORD PTR 1432[rbp], r9
.L4722:
	lea	rax, -80[rbp]
	mov	rcx, rax
	call	_ZN3TKO7RESOLVE3CTXC1Ev
	lea	rax, -80[rbp]
	add	rax, 952
	mov	rdx, QWORD PTR 1480[rbp]
	mov	QWORD PTR [rax], rdx
	lea	rax, -80[rbp]
	add	rax, 32
	mov	rdx, QWORD PTR 1456[rbp]
	mov	QWORD PTR [rax], rdx
	lea	rax, -80[rbp]
	mov	rdx, QWORD PTR 1408[rbp]
	mov	QWORD PTR [rax], rdx
	lea	rax, -80[rbp]
	add	rax, 8
	mov	rdx, QWORD PTR 1424[rbp]
	mov	QWORD PTR [rax], rdx
	lea	rax, -80[rbp]
	add	rax, 16
	mov	rdx, QWORD PTR 1432[rbp]
	mov	QWORD PTR [rax], rdx
	lea	rax, -80[rbp]
	add	rax, 24
	mov	rdx, QWORD PTR 1440[rbp]
	mov	QWORD PTR [rax], rdx
	lea	rax, -80[rbp]
	add	rax, 40
	mov	rdx, QWORD PTR 1448[rbp]
	mov	QWORD PTR [rax], rdx
	lea	rax, -80[rbp]
	add	rax, 48
	mov	rdx, QWORD PTR 1464[rbp]
	mov	QWORD PTR [rax], rdx
	lea	rax, -80[rbp]
	add	rax, 56
	mov	rdx, QWORD PTR 1472[rbp]
	mov	QWORD PTR [rax], rdx
	lea	rax, -80[rbp]
	add	rax, 64
	mov	DWORD PTR [rax], 0
	mov	rcx, QWORD PTR 1408[rbp]
	call	_ZN3TKO8ASTARENA5COUNTEv
	mov	DWORD PTR 1388[rbp], eax
	mov	edx, DWORD PTR 1388[rbp]
	mov	rax, QWORD PTR 1464[rbp]
	mov	rcx, rax
	call	_ZN3TKO12SEMANTICINFO6RESIZEEi
	mov	r8, QWORD PTR 1448[rbp]
	mov	ecx, DWORD PTR 1416[rbp]
	lea	rax, -80[rbp]
	mov	rdx, QWORD PTR 1464[rbp]
	mov	QWORD PTR 32[rsp], rdx
	mov	r9, r8
	mov	r8d, ecx
	mov	rdx, QWORD PTR 1408[rbp]
	mov	rcx, rax
	call	_ZN3TKO7RESOLVE23DISCOVERINSTANTIATIONS_ERNS0_3CTXERNS_8ASTARENAEjRNS_16DIAGNOSTICENGINEERNS_12SEMANTICINFOE
	mov	edx, DWORD PTR 1416[rbp]
	lea	rax, -80[rbp]
	mov	r8d, 1
	mov	rcx, rax
	call	_ZN3TKO7RESOLVE8WALKSTMTERNS0_3CTXEjj
	lea	rax, -80[rbp]
	mov	rcx, rax
	call	_ZN3TKO7RESOLVE19INSTANTIATEPENDING_ERNS0_3CTXE
	lea	rax, -80[rbp]
	mov	rcx, rax
	call	_ZN3TKO7RESOLVE24INSTANTIATEPENDINGPROCS_ERNS0_3CTXE
	lea	rax, -80[rbp]
	mov	rcx, rax
	call	_ZN3TKO7RESOLVE17BACKPATCHTYPEDEFSERNS0_3CTXE
	lea	rax, -80[rbp]
	mov	rcx, rax
	call	_ZN3TKO7RESOLVE21CHECKNOMETHODSINPROC_ERNS0_3CTXE
	lea	rax, -80[rbp]
	mov	rcx, rax
	call	_ZN3TKO7RESOLVE3CTXD1Ev
	nop
	add	rsp, 1520
	pop	rbp
	ret
.L4723:
	.seh_endproc
	.section .rdata,"dr"
.LC7:
	.ascii "resolved: \0"
.LC8:
	.ascii " references, \0"
.LC9:
	.ascii " builtins, \0"
.LC10:
	.ascii " unresolved, \0"
.LC11:
	.ascii " type refs, \0"
.LC12:
	.ascii " calls, \0"
.LC13:
	.ascii " assignments\0"
.LC14:
	.ascii "\12\0"
.LC15:
	.ascii "  unresolved: \0"
.LC16:
	.ascii "  typeref #\0"
.LC17:
	.ascii " -> \0"
.LC18:
	.ascii "?\0"
.LC19:
	.ascii "call\0"
.LC20:
	.ascii "assign\0"
.LC21:
	.ascii "function-result\0"
.LC22:
	.ascii "error\0"
.LC23:
	.ascii "  stmt #\0"
	.text
	.globl	_ZN3TKO7RESOLVE4DUMPERNS_8ASTARENAERNS_11SYMBOLTABLEERNS_11TYPECONTEXTERNS_8INTERNERERNS_12SEMANTICINFOERNS0_5STATSE
	.def	_ZN3TKO7RESOLVE4DUMPERNS_8ASTARENAERNS_11SYMBOLTABLEERNS_11TYPECONTEXTERNS_8INTERNERERNS_12SEMANTICINFOERNS0_5STATSE;	.scl	2;	.type	32;	.endef
	.seh_proc	_ZN3TKO7RESOLVE4DUMPERNS_8ASTARENAERNS_11SYMBOLTABLEERNS_11TYPECONTEXTERNS_8INTERNERERNS_12SEMANTICINFOERNS0_5STATSE
_ZN3TKO7RESOLVE4DUMPERNS_8ASTARENAERNS_11SYMBOLTABLEERNS_11TYPECONTEXTERNS_8INTERNERERNS_12SEMANTICINFOERNS0_5STATSE:
	push	rbp
	.seh_pushreg	rbp
	sub	rsp, 1184
	.seh_stackalloc	1184
	lea	rbp, 128[rsp]
	.seh_setframe	rbp, 128
	.seh_endprologue
	mov	QWORD PTR 1072[rbp], rcx
	mov	QWORD PTR 1080[rbp], rdx
	mov	QWORD PTR 1088[rbp], r8
	mov	QWORD PTR 1096[rbp], r9
	lea	rax, 240[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
.L4725:
	lea	rax, 208[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9d, 1
	lea	r8, .LC4[rip]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrInit
	mov	rax, QWORD PTR 1112[rbp]
	add	rax, 20
	mov	eax, DWORD PTR [rax]
	mov	ecx, eax
	call	fb_IntToStr
	mov	QWORD PTR 1040[rbp], rax
	mov	rax, QWORD PTR 1112[rbp]
	add	rax, 16
	mov	eax, DWORD PTR [rax]
	mov	ecx, eax
	call	fb_IntToStr
	mov	QWORD PTR 1032[rbp], rax
	mov	rax, QWORD PTR 1112[rbp]
	add	rax, 12
	mov	eax, DWORD PTR [rax]
	mov	ecx, eax
	call	fb_IntToStr
	mov	QWORD PTR 1024[rbp], rax
	mov	rax, QWORD PTR 1112[rbp]
	add	rax, 8
	mov	eax, DWORD PTR [rax]
	mov	ecx, eax
	call	fb_IntToStr
	mov	QWORD PTR 1016[rbp], rax
	mov	rax, QWORD PTR 1112[rbp]
	add	rax, 4
	mov	eax, DWORD PTR [rax]
	mov	ecx, eax
	call	fb_IntToStr
	mov	QWORD PTR 1008[rbp], rax
	mov	rax, QWORD PTR 1112[rbp]
	mov	eax, DWORD PTR [rax]
	mov	ecx, eax
	call	fb_IntToStr
	mov	QWORD PTR 1000[rbp], rax
	lea	rax, 688[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	rdx, QWORD PTR 1000[rbp]
	lea	rax, 688[rbp]
	mov	QWORD PTR 32[rsp], -1
	mov	r9, rdx
	mov	r8d, 11
	lea	rdx, .LC7[rip]
	mov	rcx, rax
	call	fb_StrConcat
	mov	QWORD PTR 992[rbp], rax
	lea	rax, 656[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	rdx, QWORD PTR 992[rbp]
	lea	rax, 656[rbp]
	mov	QWORD PTR 32[rsp], 14
	lea	r9, .LC8[rip]
	mov	r8, -1
	mov	rcx, rax
	call	fb_StrConcat
	mov	QWORD PTR 984[rbp], rax
	lea	rax, 624[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	rcx, QWORD PTR 1008[rbp]
	mov	rdx, QWORD PTR 984[rbp]
	lea	rax, 624[rbp]
	mov	QWORD PTR 32[rsp], -1
	mov	r9, rcx
	mov	r8, -1
	mov	rcx, rax
	call	fb_StrConcat
	mov	QWORD PTR 976[rbp], rax
	lea	rax, 592[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	rdx, QWORD PTR 976[rbp]
	lea	rax, 592[rbp]
	mov	QWORD PTR 32[rsp], 12
	lea	r9, .LC9[rip]
	mov	r8, -1
	mov	rcx, rax
	call	fb_StrConcat
	mov	QWORD PTR 968[rbp], rax
	lea	rax, 560[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	rcx, QWORD PTR 1016[rbp]
	mov	rdx, QWORD PTR 968[rbp]
	lea	rax, 560[rbp]
	mov	QWORD PTR 32[rsp], -1
	mov	r9, rcx
	mov	r8, -1
	mov	rcx, rax
	call	fb_StrConcat
	mov	QWORD PTR 960[rbp], rax
	lea	rax, 528[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	rdx, QWORD PTR 960[rbp]
	lea	rax, 528[rbp]
	mov	QWORD PTR 32[rsp], 14
	lea	r9, .LC10[rip]
	mov	r8, -1
	mov	rcx, rax
	call	fb_StrConcat
	mov	QWORD PTR 952[rbp], rax
	lea	rax, 496[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	rcx, QWORD PTR 1024[rbp]
	mov	rdx, QWORD PTR 952[rbp]
	lea	rax, 496[rbp]
	mov	QWORD PTR 32[rsp], -1
	mov	r9, rcx
	mov	r8, -1
	mov	rcx, rax
	call	fb_StrConcat
	mov	QWORD PTR 944[rbp], rax
	lea	rax, 464[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	rdx, QWORD PTR 944[rbp]
	lea	rax, 464[rbp]
	mov	QWORD PTR 32[rsp], 13
	lea	r9, .LC11[rip]
	mov	r8, -1
	mov	rcx, rax
	call	fb_StrConcat
	mov	QWORD PTR 936[rbp], rax
	lea	rax, 432[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	rcx, QWORD PTR 1032[rbp]
	mov	rdx, QWORD PTR 936[rbp]
	lea	rax, 432[rbp]
	mov	QWORD PTR 32[rsp], -1
	mov	r9, rcx
	mov	r8, -1
	mov	rcx, rax
	call	fb_StrConcat
	mov	QWORD PTR 928[rbp], rax
	lea	rax, 400[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	rdx, QWORD PTR 928[rbp]
	lea	rax, 400[rbp]
	mov	QWORD PTR 32[rsp], 9
	lea	r9, .LC12[rip]
	mov	r8, -1
	mov	rcx, rax
	call	fb_StrConcat
	mov	QWORD PTR 920[rbp], rax
	lea	rax, 368[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	rcx, QWORD PTR 1040[rbp]
	mov	rdx, QWORD PTR 920[rbp]
	lea	rax, 368[rbp]
	mov	QWORD PTR 32[rsp], -1
	mov	r9, rcx
	mov	r8, -1
	mov	rcx, rax
	call	fb_StrConcat
	mov	QWORD PTR 912[rbp], rax
	lea	rax, 336[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	rdx, QWORD PTR 912[rbp]
	lea	rax, 336[rbp]
	mov	QWORD PTR 32[rsp], 13
	lea	r9, .LC13[rip]
	mov	r8, -1
	mov	rcx, rax
	call	fb_StrConcat
	mov	QWORD PTR 904[rbp], rax
	lea	rax, 304[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	rdx, QWORD PTR 904[rbp]
	lea	rax, 304[rbp]
	mov	QWORD PTR 32[rsp], 2
	lea	r9, .LC14[rip]
	mov	r8, -1
	mov	rcx, rax
	call	fb_StrConcat
	mov	QWORD PTR 896[rbp], rax
	lea	rax, 272[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	rcx, QWORD PTR 896[rbp]
	lea	rdx, 208[rbp]
	lea	rax, 272[rbp]
	mov	QWORD PTR 32[rsp], -1
	mov	r9, rcx
	mov	r8, -1
	mov	rcx, rax
	call	fb_StrConcat
	mov	QWORD PTR 888[rbp], rax
	mov	rdx, QWORD PTR 888[rbp]
	lea	rax, 208[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrAssign
	mov	DWORD PTR 1052[rbp], 0
	mov	rax, QWORD PTR 1112[rbp]
	add	rax, 24
	mov	rcx, rax
	call	_ZN5ArrayIjE5COUNTEv
	mov	DWORD PTR 884[rbp], eax
	mov	eax, DWORD PTR 884[rbp]
	sub	eax, 1
	mov	DWORD PTR 880[rbp], eax
	jmp	.L4726
.L4760:
	nop
.L4727:
	mov	rax, QWORD PTR 1112[rbp]
	lea	rcx, 24[rax]
	mov	eax, DWORD PTR 1052[rbp]
	mov	edx, eax
	call	_ZN5ArrayIjEixEi
	mov	QWORD PTR 744[rbp], rax
	mov	rax, QWORD PTR 744[rbp]
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 1096[rbp]
	mov	rcx, rax
	call	_ZN3TKO8INTERNER8SPELLINGEj
	mov	QWORD PTR 736[rbp], rax
	lea	rax, 176[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	rdx, QWORD PTR 736[rbp]
	lea	rax, 176[rbp]
	mov	QWORD PTR 32[rsp], -1
	mov	r9, rdx
	mov	r8d, 15
	lea	rdx, .LC15[rip]
	mov	rcx, rax
	call	fb_StrConcat
	mov	QWORD PTR 728[rbp], rax
	lea	rax, 144[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	rdx, QWORD PTR 728[rbp]
	lea	rax, 144[rbp]
	mov	QWORD PTR 32[rsp], 2
	lea	r9, .LC14[rip]
	mov	r8, -1
	mov	rcx, rax
	call	fb_StrConcat
	mov	QWORD PTR 720[rbp], rax
	lea	rax, 112[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	rcx, QWORD PTR 720[rbp]
	lea	rdx, 208[rbp]
	lea	rax, 112[rbp]
	mov	QWORD PTR 32[rsp], -1
	mov	r9, rcx
	mov	r8, -1
	mov	rcx, rax
	call	fb_StrConcat
	mov	QWORD PTR 712[rbp], rax
	mov	rdx, QWORD PTR 712[rbp]
	lea	rax, 208[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrAssign
.L4728:
	add	DWORD PTR 1052[rbp], 1
.L4726:
	mov	eax, DWORD PTR 1052[rbp]
	cmp	eax, DWORD PTR 880[rbp]
	jle	.L4760
	nop
.L4729:
	mov	DWORD PTR 1048[rbp], 1
	mov	rcx, QWORD PTR 1072[rbp]
	call	_ZN3TKO8ASTARENA5COUNTEv
	mov	DWORD PTR 876[rbp], eax
	mov	eax, DWORD PTR 876[rbp]
	mov	DWORD PTR 872[rbp], eax
	jmp	.L4730
.L4768:
	nop
.L4731:
	mov	eax, DWORD PTR 1048[rbp]
	mov	DWORD PTR 860[rbp], eax
	mov	eax, DWORD PTR 860[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 1072[rbp]
	call	_ZN3TKO8ASTARENA4KINDEj
	mov	QWORD PTR 848[rbp], rax
	mov	rax, QWORD PTR 848[rbp]
	mov	QWORD PTR 840[rbp], rax
	cmp	QWORD PTR 840[rbp], 28
	jne	.L4761
	mov	edx, DWORD PTR 860[rbp]
	mov	rax, QWORD PTR 1104[rbp]
	mov	rcx, rax
	call	_ZN3TKO12SEMANTICINFO7TYPEOF_Ej
	mov	DWORD PTR 836[rbp], eax
	mov	eax, DWORD PTR 836[rbp]
	mov	DWORD PTR 832[rbp], eax
	cmp	DWORD PTR 832[rbp], 0
	je	.L4762
	mov	edx, DWORD PTR 832[rbp]
	mov	rax, QWORD PTR 1088[rbp]
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT4NAMEEj
	mov	QWORD PTR 824[rbp], rax
	mov	eax, DWORD PTR 1048[rbp]
	mov	ecx, eax
	call	fb_IntToStr
	mov	QWORD PTR 816[rbp], rax
	lea	rax, 80[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	rdx, QWORD PTR 816[rbp]
	lea	rax, 80[rbp]
	mov	QWORD PTR 32[rsp], -1
	mov	r9, rdx
	mov	r8d, 12
	lea	rdx, .LC16[rip]
	mov	rcx, rax
	call	fb_StrConcat
	mov	QWORD PTR 808[rbp], rax
	lea	rax, 48[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	rdx, QWORD PTR 808[rbp]
	lea	rax, 48[rbp]
	mov	QWORD PTR 32[rsp], 5
	lea	r9, .LC17[rip]
	mov	r8, -1
	mov	rcx, rax
	call	fb_StrConcat
	mov	QWORD PTR 800[rbp], rax
	lea	rax, 16[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	rcx, QWORD PTR 824[rbp]
	mov	rdx, QWORD PTR 800[rbp]
	lea	rax, 16[rbp]
	mov	QWORD PTR 32[rsp], -1
	mov	r9, rcx
	mov	r8, -1
	mov	rcx, rax
	call	fb_StrConcat
	mov	QWORD PTR 792[rbp], rax
	lea	rax, -16[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	rdx, QWORD PTR 792[rbp]
	lea	rax, -16[rbp]
	mov	QWORD PTR 32[rsp], 2
	lea	r9, .LC14[rip]
	mov	r8, -1
	mov	rcx, rax
	call	fb_StrConcat
	mov	QWORD PTR 784[rbp], rax
	lea	rax, -48[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	rcx, QWORD PTR 784[rbp]
	lea	rdx, 208[rbp]
	lea	rax, -48[rbp]
	mov	QWORD PTR 32[rsp], -1
	mov	r9, rcx
	mov	r8, -1
	mov	rcx, rax
	call	fb_StrConcat
	mov	QWORD PTR 776[rbp], rax
	mov	rdx, QWORD PTR 776[rbp]
	lea	rax, 208[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrAssign
	jmp	.L4749
.L4735:
.L4762:
	nop
.L4736:
	jmp	.L4749
.L4761:
	nop
.L4733:
	cmp	QWORD PTR 840[rbp], 30
	jne	.L4763
	lea	rax, -80[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9d, 2
	lea	r8, .LC18[rip]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrInit
	mov	edx, DWORD PTR 860[rbp]
	mov	rax, QWORD PTR 1104[rbp]
	mov	rcx, rax
	call	_ZN3TKO12SEMANTICINFO11AMBIGUOUSOFEj
	mov	QWORD PTR 768[rbp], rax
	mov	rax, QWORD PTR 768[rbp]
	mov	QWORD PTR 760[rbp], rax
	cmp	QWORD PTR 760[rbp], 1
	jne	.L4764
	nop
.L4739:
	lea	rax, -80[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9d, 5
	lea	r8, .LC19[rip]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrAssign
	jmp	.L4747
.L4764:
	nop
.L4740:
	cmp	QWORD PTR 760[rbp], 2
	jne	.L4765
	nop
.L4742:
	lea	rax, -80[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9d, 7
	lea	r8, .LC20[rip]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrAssign
	jmp	.L4747
.L4765:
	nop
.L4743:
	cmp	QWORD PTR 760[rbp], 4
	jne	.L4766
	nop
.L4744:
	lea	rax, -80[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9d, 16
	lea	r8, .LC21[rip]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrAssign
	jmp	.L4747
.L4766:
	nop
.L4745:
	cmp	QWORD PTR 760[rbp], 5
	jne	.L4767
	nop
.L4746:
	lea	rax, -80[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9d, 6
	lea	r8, .LC22[rip]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrAssign
	jmp	.L4747
.L4741:
.L4767:
	nop
.L4747:
	lea	rax, 208[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9d, 9
	lea	r8, .LC23[rip]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrConcatAssign
	mov	eax, DWORD PTR 1048[rbp]
	mov	ecx, eax
	call	fb_IntToStr
	mov	QWORD PTR 752[rbp], rax
	mov	rdx, QWORD PTR 752[rbp]
	lea	rax, 208[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrConcatAssign
	lea	rax, 208[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9d, 5
	lea	r8, .LC17[rip]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrConcatAssign
	lea	rdx, -80[rbp]
	lea	rax, 208[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrConcatAssign
	lea	rax, 208[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9d, 2
	lea	r8, .LC14[rip]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrConcatAssign
	lea	rax, -80[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	jmp	.L4749
.L4737:
.L4748:
.L4763:
	nop
.L4749:
	add	DWORD PTR 1048[rbp], 1
.L4730:
	mov	eax, DWORD PTR 1048[rbp]
	cmp	eax, DWORD PTR 872[rbp]
	jle	.L4768
	nop
.L4750:
	lea	rdx, 208[rbp]
	lea	rax, 240[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrInit
	lea	rax, 208[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	nop
.L4751:
	lea	rax, 240[rbp]
	mov	rcx, rax
	call	fb_StrAllocTempResult
	mov	QWORD PTR 864[rbp], rax
	mov	rax, QWORD PTR 864[rbp]
	add	rsp, 1184
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
.L4770:
.L4771:
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
.L4773:
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
.L4774:
	mov	rax, QWORD PTR -16[rbp]
	cmp	rax, QWORD PTR -24[rbp]
	jnb	.L4779
	mov	rax, QWORD PTR -16[rbp]
	movzx	edx, BYTE PTR [rax]
	mov	rax, QWORD PTR -8[rbp]
	mov	BYTE PTR [rax], dl
	add	QWORD PTR -8[rbp], 1
	add	QWORD PTR -16[rbp], 1
	jmp	.L4774
.L4779:
	nop
.L4776:
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 72[rax]
	mov	rax, QWORD PTR 24[rbp]
	mov	eax, DWORD PTR 72[rax]
	mov	DWORD PTR [rdx], eax
	nop
	add	rsp, 80
	pop	rbp
	ret
.L4777:
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
.L4781:
.L4782:
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayErase
	nop
	add	rsp, 32
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN5ArrayI8FBSTRINGEC1Ev;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayI8FBSTRINGEC1Ev
_ZN5ArrayI8FBSTRINGEC1Ev:
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
.L4784:
.L4785:
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
.L4787:
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
.L4788:
	mov	rax, QWORD PTR -16[rbp]
	cmp	rax, QWORD PTR -24[rbp]
	jnb	.L4793
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
	jmp	.L4788
.L4793:
	nop
.L4790:
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 72[rax]
	mov	rax, QWORD PTR 24[rbp]
	mov	eax, DWORD PTR 72[rax]
	mov	DWORD PTR [rdx], eax
	nop
	add	rsp, 80
	pop	rbp
	ret
.L4791:
	.seh_endproc
	.def	_ZN5ArrayI8FBSTRINGED1Ev;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN5ArrayI8FBSTRINGED1Ev
_ZN5ArrayI8FBSTRINGED1Ev:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
.L4795:
.L4796:
	mov	rcx, QWORD PTR 16[rbp]
	call	fb_ArrayStrErase
	nop
	add	rsp, 32
	pop	rbp
	ret
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
.L4798:
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
.L4799:
	mov	rax, QWORD PTR -16[rbp]
	cmp	rax, QWORD PTR -24[rbp]
	jnb	.L4804
	mov	rax, QWORD PTR -16[rbp]
	mov	rdx, QWORD PTR 8[rax]
	mov	rax, QWORD PTR [rax]
	mov	rcx, QWORD PTR -8[rbp]
	mov	QWORD PTR [rcx], rax
	mov	QWORD PTR 8[rcx], rdx
	add	QWORD PTR -8[rbp], 16
	add	QWORD PTR -16[rbp], 16
	jmp	.L4799
.L4804:
	nop
.L4801:
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 72[rax]
	mov	rax, QWORD PTR 24[rbp]
	mov	eax, DWORD PTR 72[rax]
	mov	DWORD PTR [rdx], eax
	nop
	add	rsp, 80
	pop	rbp
	ret
.L4802:
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
.L4806:
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
.L4807:
	mov	rax, QWORD PTR -64[rbp]
	cmp	rax, QWORD PTR -72[rbp]
	jnb	.L4812
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
	jmp	.L4807
.L4812:
	nop
.L4809:
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
.L4810:
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
.L4814:
.L4815:
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
.L4817:
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
.L4818:
	mov	rax, QWORD PTR -16[rbp]
	cmp	rax, QWORD PTR -24[rbp]
	jnb	.L4823
	mov	rax, QWORD PTR -16[rbp]
	movzx	edx, WORD PTR [rax]
	mov	rax, QWORD PTR -8[rbp]
	mov	WORD PTR [rax], dx
	add	QWORD PTR -8[rbp], 2
	add	QWORD PTR -16[rbp], 2
	jmp	.L4818
.L4823:
	nop
.L4820:
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 72[rax]
	mov	rax, QWORD PTR 24[rbp]
	mov	eax, DWORD PTR 72[rax]
	mov	DWORD PTR [rdx], eax
	nop
	add	rsp, 80
	pop	rbp
	ret
.L4821:
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
.L4825:
.L4826:
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
.L4828:
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
.L4829:
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
.L4831:
.L4832:
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
.L4834:
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
.L4835:
	mov	rax, QWORD PTR -16[rbp]
	cmp	rax, QWORD PTR -24[rbp]
	jnb	.L4840
	mov	rax, QWORD PTR -8[rbp]
	mov	rdx, QWORD PTR -16[rbp]
	mov	rcx, QWORD PTR [rdx]
	mov	QWORD PTR [rax], rcx
	mov	edx, DWORD PTR 8[rdx]
	mov	DWORD PTR 8[rax], edx
	add	QWORD PTR -8[rbp], 12
	add	QWORD PTR -16[rbp], 12
	jmp	.L4835
.L4840:
	nop
.L4837:
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 72[rax]
	mov	rax, QWORD PTR 24[rbp]
	mov	eax, DWORD PTR 72[rax]
	mov	DWORD PTR [rdx], eax
	nop
	add	rsp, 80
	pop	rbp
	ret
.L4838:
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
.L4842:
.L4843:
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
.L4845:
.L4846:
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
.L4848:
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
.L4849:
	mov	rax, QWORD PTR -16[rbp]
	cmp	rax, QWORD PTR -24[rbp]
	jnb	.L4854
	mov	rax, QWORD PTR -16[rbp]
	mov	rdx, QWORD PTR [rax]
	mov	rax, QWORD PTR -8[rbp]
	mov	QWORD PTR [rax], rdx
	add	QWORD PTR -8[rbp], 8
	add	QWORD PTR -16[rbp], 8
	jmp	.L4849
.L4854:
	nop
.L4851:
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 72[rax]
	mov	rax, QWORD PTR 24[rbp]
	mov	eax, DWORD PTR 72[rax]
	mov	DWORD PTR [rdx], eax
	nop
	add	rsp, 80
	pop	rbp
	ret
.L4852:
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
.L4856:
.L4857:
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
.L4859:
.L4860:
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
.L4862:
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
.L4863:
	mov	rax, QWORD PTR -16[rbp]
	cmp	rax, QWORD PTR -24[rbp]
	jnb	.L4868
	mov	rax, QWORD PTR -8[rbp]
	mov	rdx, QWORD PTR -16[rbp]
	mov	rcx, QWORD PTR [rdx]
	mov	QWORD PTR [rax], rcx
	mov	edx, DWORD PTR 8[rdx]
	mov	DWORD PTR 8[rax], edx
	add	QWORD PTR -8[rbp], 12
	add	QWORD PTR -16[rbp], 12
	jmp	.L4863
.L4868:
	nop
.L4865:
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 72[rax]
	mov	rax, QWORD PTR 24[rbp]
	mov	eax, DWORD PTR 72[rax]
	mov	DWORD PTR [rdx], eax
	nop
	add	rsp, 80
	pop	rbp
	ret
.L4866:
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
.L4870:
.L4871:
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
.L4873:
.L4874:
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
.L4876:
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
.L4877:
	mov	rax, QWORD PTR -16[rbp]
	cmp	rax, QWORD PTR -24[rbp]
	jnb	.L4882
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
	jmp	.L4877
.L4882:
	nop
.L4879:
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 72[rax]
	mov	rax, QWORD PTR 24[rbp]
	mov	eax, DWORD PTR 72[rax]
	mov	DWORD PTR [rdx], eax
	nop
	add	rsp, 80
	pop	rbp
	ret
.L4880:
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
.L4884:
.L4885:
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
.L4887:
.L4888:
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
.L4890:
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
.L4891:
	mov	rax, QWORD PTR -16[rbp]
	cmp	rax, QWORD PTR -24[rbp]
	jnb	.L4896
	mov	rax, QWORD PTR -8[rbp]
	mov	rdx, QWORD PTR -16[rbp]
	mov	rcx, QWORD PTR [rdx]
	mov	QWORD PTR [rax], rcx
	mov	edx, DWORD PTR 8[rdx]
	mov	DWORD PTR 8[rax], edx
	add	QWORD PTR -8[rbp], 12
	add	QWORD PTR -16[rbp], 12
	jmp	.L4891
.L4896:
	nop
.L4893:
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 72[rax]
	mov	rax, QWORD PTR 24[rbp]
	mov	eax, DWORD PTR 72[rax]
	mov	DWORD PTR [rdx], eax
	nop
	add	rsp, 80
	pop	rbp
	ret
.L4894:
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
.L4898:
.L4899:
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
.L4901:
.L4902:
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
.L4904:
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
.L4905:
	mov	rax, QWORD PTR -16[rbp]
	cmp	rax, QWORD PTR -24[rbp]
	jnb	.L4910
	mov	rax, QWORD PTR -8[rbp]
	mov	rdx, QWORD PTR -16[rbp]
	mov	rcx, QWORD PTR [rdx]
	mov	QWORD PTR [rax], rcx
	mov	edx, DWORD PTR 8[rdx]
	mov	DWORD PTR 8[rax], edx
	add	QWORD PTR -8[rbp], 12
	add	QWORD PTR -16[rbp], 12
	jmp	.L4905
.L4910:
	nop
.L4907:
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 72[rax]
	mov	rax, QWORD PTR 24[rbp]
	mov	eax, DWORD PTR 72[rax]
	mov	DWORD PTR [rdx], eax
	nop
	add	rsp, 80
	pop	rbp
	ret
.L4908:
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
.L4912:
.L4913:
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
.L4915:
.L4916:
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
.L4918:
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
.L4919:
	mov	rax, QWORD PTR -64[rbp]
	cmp	rax, QWORD PTR -72[rbp]
	jnb	.L4924
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
	jmp	.L4919
.L4924:
	nop
.L4921:
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
.L4922:
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
.L4926:
.L4927:
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
.L4929:
.L4930:
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
.L4932:
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
.L4933:
	mov	rax, QWORD PTR -16[rbp]
	cmp	rax, QWORD PTR -24[rbp]
	jnb	.L4938
	mov	rax, QWORD PTR -16[rbp]
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR -8[rbp]
	mov	DWORD PTR [rax], edx
	add	QWORD PTR -8[rbp], 4
	add	QWORD PTR -16[rbp], 4
	jmp	.L4933
.L4938:
	nop
.L4935:
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 72[rax]
	mov	rax, QWORD PTR 24[rbp]
	mov	eax, DWORD PTR 72[rax]
	mov	DWORD PTR [rdx], eax
	nop
	add	rsp, 80
	pop	rbp
	ret
.L4936:
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
.L4940:
.L4941:
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
.L4943:
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
.L4944:
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
.L4946:
.L4947:
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
.L4949:
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
.L4950:
	mov	rax, QWORD PTR -16[rbp]
	cmp	rax, QWORD PTR -24[rbp]
	jnb	.L4955
	mov	rax, QWORD PTR -16[rbp]
	mov	rdx, QWORD PTR [rax]
	mov	rax, QWORD PTR -8[rbp]
	mov	QWORD PTR [rax], rdx
	add	QWORD PTR -8[rbp], 8
	add	QWORD PTR -16[rbp], 8
	jmp	.L4950
.L4955:
	nop
.L4952:
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 72[rax]
	mov	rax, QWORD PTR 24[rbp]
	mov	eax, DWORD PTR 72[rax]
	mov	DWORD PTR [rdx], eax
	nop
	add	rsp, 80
	pop	rbp
	ret
.L4953:
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
.L4957:
.L4958:
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
.L4960:
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
.L4961:
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
.L4963:
.L4964:
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
.L4966:
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
.L4967:
	mov	rax, QWORD PTR -16[rbp]
	cmp	rax, QWORD PTR -24[rbp]
	jnb	.L4972
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
	jmp	.L4967
.L4972:
	nop
.L4969:
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 72[rax]
	mov	rax, QWORD PTR 24[rbp]
	mov	eax, DWORD PTR 72[rax]
	mov	DWORD PTR [rdx], eax
	nop
	add	rsp, 80
	pop	rbp
	ret
.L4970:
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
.L4974:
.L4975:
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
.L4977:
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
.L4978:
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
.L4980:
.L4981:
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
.L4983:
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
.L4984:
	mov	rax, QWORD PTR -64[rbp]
	cmp	rax, QWORD PTR -72[rbp]
	jnb	.L4989
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
	jmp	.L4984
.L4989:
	nop
.L4986:
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
.L4987:
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
.L4991:
.L4992:
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
.L4994:
.L4995:
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
.L4997:
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
.L4998:
	mov	rax, QWORD PTR -16[rbp]
	cmp	rax, QWORD PTR -24[rbp]
	jnb	.L5003
	mov	rax, QWORD PTR -16[rbp]
	mov	rdx, QWORD PTR [rax]
	mov	rax, QWORD PTR -8[rbp]
	mov	QWORD PTR [rax], rdx
	add	QWORD PTR -8[rbp], 8
	add	QWORD PTR -16[rbp], 8
	jmp	.L4998
.L5003:
	nop
.L5000:
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 72[rax]
	mov	rax, QWORD PTR 24[rbp]
	mov	eax, DWORD PTR 72[rax]
	mov	DWORD PTR [rdx], eax
	nop
	add	rsp, 80
	pop	rbp
	ret
.L5001:
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
.L5005:
.L5006:
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
.L5008:
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
.L5009:
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
.L5011:
.L5012:
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
.L5014:
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
.L5015:
	mov	rax, QWORD PTR -64[rbp]
	cmp	rax, QWORD PTR -72[rbp]
	jnb	.L5020
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
	jmp	.L5015
.L5020:
	nop
.L5017:
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
.L5018:
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
.L5022:
.L5023:
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
.L5025:
.L5026:
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
.L5028:
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
.L5029:
	mov	rax, QWORD PTR -16[rbp]
	cmp	rax, QWORD PTR -24[rbp]
	jnb	.L5034
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
	jmp	.L5029
.L5034:
	nop
.L5031:
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 72[rax]
	mov	rax, QWORD PTR 24[rbp]
	mov	eax, DWORD PTR 72[rax]
	mov	DWORD PTR [rdx], eax
	nop
	add	rsp, 80
	pop	rbp
	ret
.L5032:
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
.L5036:
.L5037:
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
.L5039:
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
.L5040:
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
.L5042:
.L5043:
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
.L5045:
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
.L5046:
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
.L5048:
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
.L5049:
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
.L5051:
.L5052:
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
.L5054:
.L5055:
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
.L5057:
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
.L5058:
	mov	rax, QWORD PTR -16[rbp]
	cmp	rax, QWORD PTR -24[rbp]
	jnb	.L5063
	mov	rdx, QWORD PTR -16[rbp]
	mov	rax, QWORD PTR -8[rbp]
	mov	rcx, rax
	call	_ZN3TKO8DIAGNOTEaSERKS0_
	add	QWORD PTR -8[rbp], 40
	add	QWORD PTR -16[rbp], 40
	jmp	.L5058
.L5063:
	nop
.L5060:
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 72[rax]
	mov	rax, QWORD PTR 24[rbp]
	mov	eax, DWORD PTR 72[rax]
	mov	DWORD PTR [rdx], eax
	nop
	add	rsp, 80
	pop	rbp
	ret
.L5061:
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
.L5065:
.L5066:
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
.L5068:
.L5069:
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
.L5071:
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
.L5072:
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
.L5074:
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
.L5075:
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
.L5077:
.L5078:
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
.L5080:
.L5081:
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
.L5083:
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
.L5084:
	mov	rax, QWORD PTR -16[rbp]
	cmp	rax, QWORD PTR -24[rbp]
	jnb	.L5089
	mov	rdx, QWORD PTR -16[rbp]
	mov	rax, QWORD PTR -8[rbp]
	mov	rcx, rax
	call	_ZN3TKO10DIAGNOSTICaSERKS0_
	add	QWORD PTR -8[rbp], 136
	add	QWORD PTR -16[rbp], 136
	jmp	.L5084
.L5089:
	nop
.L5086:
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 72[rax]
	mov	rax, QWORD PTR 24[rbp]
	mov	eax, DWORD PTR 72[rax]
	mov	DWORD PTR [rdx], eax
	nop
	add	rsp, 80
	pop	rbp
	ret
.L5087:
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
.L5091:
.L5092:
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
.L5094:
.L5095:
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
.L5097:
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
.L5098:
	mov	rax, QWORD PTR -16[rbp]
	cmp	rax, QWORD PTR -24[rbp]
	jnb	.L5103
	mov	rax, QWORD PTR -16[rbp]
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR -8[rbp]
	mov	DWORD PTR [rax], edx
	add	QWORD PTR -8[rbp], 4
	add	QWORD PTR -16[rbp], 4
	jmp	.L5098
.L5103:
	nop
.L5100:
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 72[rax]
	mov	rax, QWORD PTR 24[rbp]
	mov	eax, DWORD PTR 72[rax]
	mov	DWORD PTR [rdx], eax
	nop
	add	rsp, 80
	pop	rbp
	ret
.L5101:
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
.L5105:
.L5106:
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
.L5108:
.L5109:
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
.L5111:
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
.L5112:
	mov	rax, QWORD PTR -16[rbp]
	cmp	rax, QWORD PTR -24[rbp]
	jnb	.L5117
	mov	rax, QWORD PTR -8[rbp]
	mov	rdx, QWORD PTR -16[rbp]
	mov	rcx, QWORD PTR [rdx]
	mov	QWORD PTR [rax], rcx
	mov	edx, DWORD PTR 8[rdx]
	mov	DWORD PTR 8[rax], edx
	add	QWORD PTR -8[rbp], 12
	add	QWORD PTR -16[rbp], 12
	jmp	.L5112
.L5117:
	nop
.L5114:
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 72[rax]
	mov	rax, QWORD PTR 24[rbp]
	mov	eax, DWORD PTR 72[rax]
	mov	DWORD PTR [rdx], eax
	nop
	add	rsp, 80
	pop	rbp
	ret
.L5115:
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
.L5119:
.L5120:
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
.L5122:
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
.L5123:
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
.L5125:
.L5126:
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
.L5128:
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
.L5129:
	mov	rax, QWORD PTR -16[rbp]
	cmp	rax, QWORD PTR -24[rbp]
	jnb	.L5134
	mov	rax, QWORD PTR -16[rbp]
	mov	rdx, QWORD PTR [rax]
	mov	rax, QWORD PTR -8[rbp]
	mov	QWORD PTR [rax], rdx
	add	QWORD PTR -8[rbp], 8
	add	QWORD PTR -16[rbp], 8
	jmp	.L5129
.L5134:
	nop
.L5131:
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 72[rax]
	mov	rax, QWORD PTR 24[rbp]
	mov	eax, DWORD PTR 72[rax]
	mov	DWORD PTR [rdx], eax
	nop
	add	rsp, 80
	pop	rbp
	ret
.L5132:
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
.L5136:
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
.L5137:
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
.L5139:
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
.L5140:
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
.L5142:
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
.L5143:
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
.L5145:
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
.L5146:
	.seh_endproc
	.def	_ZN3TKO7RESOLVE3CTXC1Ev;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN3TKO7RESOLVE3CTXC1Ev
_ZN3TKO7RESOLVE3CTXC1Ev:
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
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 32
	mov	QWORD PTR [rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 40
	mov	QWORD PTR [rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 48
	mov	QWORD PTR [rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 56
	mov	QWORD PTR [rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 64
	mov	DWORD PTR [rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	rcx, rax
	call	_ZN5ArrayIjEC1Ev
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 152
	mov	rcx, rax
	call	_ZN5ArrayIjEC1Ev
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 232
	mov	rcx, rax
	call	_ZN5ArrayIjEC1Ev
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 312
	mov	rcx, rax
	call	_ZN5ArrayIjEC1Ev
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 392
	mov	rcx, rax
	call	_ZN5ArrayIjEC1Ev
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 472
	mov	rcx, rax
	call	_ZN5ArrayIjEC1Ev
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 552
	mov	rcx, rax
	call	_ZN5ArrayIjEC1Ev
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 632
	mov	rcx, rax
	call	_ZN5ArrayIjEC1Ev
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 712
	mov	rcx, rax
	call	_ZN5ArrayIjEC1Ev
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 792
	mov	rcx, rax
	call	_ZN5ArrayIjEC1Ev
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 872
	mov	rcx, rax
	call	_ZN5ArrayIjEC1Ev
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 952
	mov	QWORD PTR [rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 960
	mov	rcx, rax
	call	_ZN5ArrayIjEC1Ev
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 1040
	mov	rcx, rax
	call	_ZN5ArrayIjEC1Ev
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 1120
	mov	DWORD PTR [rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 1128
	mov	rcx, rax
	call	_ZN5ArrayIjEC1Ev
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 1208
	mov	rcx, rax
	call	_ZN5ArrayIjEC1Ev
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 1288
	mov	DWORD PTR [rax], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 1296
	mov	rcx, rax
	call	_ZN5ArrayIjEC1Ev
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 1376
	mov	rcx, rax
	call	_ZN5ArrayIjEC1Ev
	nop
	add	rsp, 32
	pop	rbp
	ret
.L5148:
.L5149:
	.seh_endproc
	.def	_ZN3TKO7RESOLVE3CTXaSERKS1_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN3TKO7RESOLVE3CTXaSERKS1_
_ZN3TKO7RESOLVE3CTXaSERKS1_:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
.L5151:
	mov	rax, QWORD PTR 24[rbp]
	mov	rdx, QWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	mov	QWORD PTR [rax], rdx
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 8[rax]
	mov	rax, QWORD PTR 24[rbp]
	mov	rax, QWORD PTR 8[rax]
	mov	QWORD PTR [rdx], rax
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 16[rax]
	mov	rax, QWORD PTR 24[rbp]
	mov	rax, QWORD PTR 16[rax]
	mov	QWORD PTR [rdx], rax
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 24[rax]
	mov	rax, QWORD PTR 24[rbp]
	mov	rax, QWORD PTR 24[rax]
	mov	QWORD PTR [rdx], rax
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 32[rax]
	mov	rax, QWORD PTR 24[rbp]
	mov	rax, QWORD PTR 32[rax]
	mov	QWORD PTR [rdx], rax
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 40[rax]
	mov	rax, QWORD PTR 24[rbp]
	mov	rax, QWORD PTR 40[rax]
	mov	QWORD PTR [rdx], rax
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 48[rax]
	mov	rax, QWORD PTR 24[rbp]
	mov	rax, QWORD PTR 48[rax]
	mov	QWORD PTR [rdx], rax
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 56[rax]
	mov	rax, QWORD PTR 24[rbp]
	mov	rax, QWORD PTR 56[rax]
	mov	QWORD PTR [rdx], rax
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 64[rax]
	mov	rax, QWORD PTR 24[rbp]
	mov	eax, DWORD PTR 64[rax]
	mov	DWORD PTR [rdx], eax
	mov	rax, QWORD PTR 24[rbp]
	lea	rdx, 72[rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	rcx, rax
	call	_ZN5ArrayIjEaSERKS0_
	mov	rax, QWORD PTR 24[rbp]
	lea	rdx, 152[rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 152
	mov	rcx, rax
	call	_ZN5ArrayIjEaSERKS0_
	mov	rax, QWORD PTR 24[rbp]
	lea	rdx, 232[rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 232
	mov	rcx, rax
	call	_ZN5ArrayIjEaSERKS0_
	mov	rax, QWORD PTR 24[rbp]
	lea	rdx, 312[rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 312
	mov	rcx, rax
	call	_ZN5ArrayIjEaSERKS0_
	mov	rax, QWORD PTR 24[rbp]
	lea	rdx, 392[rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 392
	mov	rcx, rax
	call	_ZN5ArrayIjEaSERKS0_
	mov	rax, QWORD PTR 24[rbp]
	lea	rdx, 472[rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 472
	mov	rcx, rax
	call	_ZN5ArrayIjEaSERKS0_
	mov	rax, QWORD PTR 24[rbp]
	lea	rdx, 552[rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 552
	mov	rcx, rax
	call	_ZN5ArrayIjEaSERKS0_
	mov	rax, QWORD PTR 24[rbp]
	lea	rdx, 632[rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 632
	mov	rcx, rax
	call	_ZN5ArrayIjEaSERKS0_
	mov	rax, QWORD PTR 24[rbp]
	lea	rdx, 712[rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 712
	mov	rcx, rax
	call	_ZN5ArrayIjEaSERKS0_
	mov	rax, QWORD PTR 24[rbp]
	lea	rdx, 792[rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 792
	mov	rcx, rax
	call	_ZN5ArrayIjEaSERKS0_
	mov	rax, QWORD PTR 24[rbp]
	lea	rdx, 872[rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 872
	mov	rcx, rax
	call	_ZN5ArrayIjEaSERKS0_
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 952[rax]
	mov	rax, QWORD PTR 24[rbp]
	mov	rax, QWORD PTR 952[rax]
	mov	QWORD PTR [rdx], rax
	mov	rax, QWORD PTR 24[rbp]
	lea	rdx, 960[rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 960
	mov	rcx, rax
	call	_ZN5ArrayIjEaSERKS0_
	mov	rax, QWORD PTR 24[rbp]
	lea	rdx, 1040[rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 1040
	mov	rcx, rax
	call	_ZN5ArrayIjEaSERKS0_
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 1120[rax]
	mov	rax, QWORD PTR 24[rbp]
	mov	eax, DWORD PTR 1120[rax]
	mov	DWORD PTR [rdx], eax
	mov	rax, QWORD PTR 24[rbp]
	lea	rdx, 1128[rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 1128
	mov	rcx, rax
	call	_ZN5ArrayIjEaSERKS0_
	mov	rax, QWORD PTR 24[rbp]
	lea	rdx, 1208[rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 1208
	mov	rcx, rax
	call	_ZN5ArrayIjEaSERKS0_
	mov	rax, QWORD PTR 16[rbp]
	lea	rdx, 1288[rax]
	mov	rax, QWORD PTR 24[rbp]
	mov	eax, DWORD PTR 1288[rax]
	mov	DWORD PTR [rdx], eax
	mov	rax, QWORD PTR 24[rbp]
	lea	rdx, 1296[rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 1296
	mov	rcx, rax
	call	_ZN5ArrayIjEaSERKS0_
	mov	rax, QWORD PTR 24[rbp]
	lea	rdx, 1376[rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 1376
	mov	rcx, rax
	call	_ZN5ArrayIjEaSERKS0_
	nop
	add	rsp, 32
	pop	rbp
	ret
.L5152:
	.seh_endproc
	.def	_ZN3TKO7RESOLVE3CTXD1Ev;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN3TKO7RESOLVE3CTXD1Ev
_ZN3TKO7RESOLVE3CTXD1Ev:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
.L5154:
.L5155:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 1376
	mov	rcx, rax
	call	_ZN5ArrayIjED1Ev
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 1296
	mov	rcx, rax
	call	_ZN5ArrayIjED1Ev
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 1208
	mov	rcx, rax
	call	_ZN5ArrayIjED1Ev
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 1128
	mov	rcx, rax
	call	_ZN5ArrayIjED1Ev
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 1040
	mov	rcx, rax
	call	_ZN5ArrayIjED1Ev
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 960
	mov	rcx, rax
	call	_ZN5ArrayIjED1Ev
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 872
	mov	rcx, rax
	call	_ZN5ArrayIjED1Ev
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 792
	mov	rcx, rax
	call	_ZN5ArrayIjED1Ev
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 712
	mov	rcx, rax
	call	_ZN5ArrayIjED1Ev
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 632
	mov	rcx, rax
	call	_ZN5ArrayIjED1Ev
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 552
	mov	rcx, rax
	call	_ZN5ArrayIjED1Ev
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 472
	mov	rcx, rax
	call	_ZN5ArrayIjED1Ev
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 392
	mov	rcx, rax
	call	_ZN5ArrayIjED1Ev
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 312
	mov	rcx, rax
	call	_ZN5ArrayIjED1Ev
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 232
	mov	rcx, rax
	call	_ZN5ArrayIjED1Ev
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 152
	mov	rcx, rax
	call	_ZN5ArrayIjED1Ev
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 72
	mov	rcx, rax
	call	_ZN5ArrayIjED1Ev
	nop
	add	rsp, 32
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN3TKO6MANGLE13SUBSTITUTIONSaSERKS1_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN3TKO6MANGLE13SUBSTITUTIONSaSERKS1_
_ZN3TKO6MANGLE13SUBSTITUTIONSaSERKS1_:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
.L5157:
	mov	rax, QWORD PTR 24[rbp]
	mov	rdx, rax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN5ArrayI8FBSTRINGEaSERKS1_
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
	call	_ZN5ArrayIiEaSERKS0_
	mov	rax, QWORD PTR 24[rbp]
	lea	rdx, 320[rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 320
	mov	rcx, rax
	call	_ZN5ArrayIiEaSERKS0_
	nop
	add	rsp, 32
	pop	rbp
	ret
.L5158:
	.seh_endproc
	.def	_ZN3TKO5CHECK5STATSaSERKS1_;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN3TKO5CHECK5STATSaSERKS1_
_ZN3TKO5CHECK5STATSaSERKS1_:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 32
	.seh_stackalloc	32
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	QWORD PTR 24[rbp], rdx
.L5160:
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
	mov	rax, QWORD PTR 24[rbp]
	lea	rdx, 24[rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 24
	mov	rcx, rax
	call	_ZN5ArrayIiEaSERKS0_
	mov	rax, QWORD PTR 24[rbp]
	lea	rdx, 104[rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 104
	mov	rcx, rax
	call	_ZN5ArrayIjEaSERKS0_
	nop
	add	rsp, 32
	pop	rbp
	ret
.L5161:
	.seh_endproc
	.def	_ZN3TKO7RESOLVE13ISSTATICPROC_ERNS0_3CTXEj;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN3TKO7RESOLVE13ISSTATICPROC_ERNS0_3CTXEj
_ZN3TKO7RESOLVE13ISSTATICPROC_ERNS0_3CTXEj:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 96
	.seh_stackalloc	96
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
	mov	BYTE PTR -49[rbp], 0
.L5163:
	cmp	DWORD PTR 24[rbp], 0
	jne	.L5184
	mov	BYTE PTR -49[rbp], 0
	jmp	.L5166
.L5184:
	nop
.L5165:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 24[rbp]
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE8SYMBOLATEj
	mov	QWORD PTR -8[rbp], rax
	mov	rax, QWORD PTR -8[rbp]
	mov	QWORD PTR -16[rbp], rax
	cmp	QWORD PTR -16[rbp], 0
	jne	.L5185
	mov	BYTE PTR -49[rbp], 0
	jmp	.L5166
.L5185:
	nop
.L5168:
	mov	rax, QWORD PTR -16[rbp]
	movzx	eax, BYTE PTR [rax]
	cmp	al, 5
	je	.L5186
	mov	BYTE PTR -49[rbp], 0
	jmp	.L5166
.L5186:
	nop
.L5170:
	mov	rax, QWORD PTR -16[rbp]
	add	rax, 40
	mov	rax, QWORD PTR [rax]
	mov	DWORD PTR -20[rbp], eax
	cmp	DWORD PTR -20[rbp], 0
	jne	.L5187
	mov	BYTE PTR -49[rbp], 0
	jmp	.L5166
.L5187:
	nop
.L5172:
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN5ArrayIN3TKO7ASTNODEEE5COUNTEv
	mov	DWORD PTR -24[rbp], eax
	mov	eax, DWORD PTR -20[rbp]
	cmp	DWORD PTR -24[rbp], eax
	jg	.L5188
	mov	BYTE PTR -49[rbp], 0
	jmp	.L5166
.L5188:
	nop
.L5174:
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR -20[rbp]
	mov	rcx, rax
	call	_ZN3TKO8ASTARENA4KINDEj
	mov	QWORD PTR -32[rbp], rax
	cmp	QWORD PTR -32[rbp], 65
	je	.L5189
	mov	BYTE PTR -49[rbp], 0
	jmp	.L5166
.L5189:
	nop
.L5176:
	mov	eax, DWORD PTR -20[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN3TKO7RESOLVE6STMTOFERNS0_3CTXEj
	mov	QWORD PTR -40[rbp], rax
	mov	rax, QWORD PTR -40[rbp]
	mov	QWORD PTR -48[rbp], rax
	mov	rax, QWORD PTR -48[rbp]
	add	rax, 28
	mov	eax, DWORD PTR [rax]
	mov	eax, eax
	and	eax, 4
	test	rax, rax
	setne	al
	mov	BYTE PTR -49[rbp], al
	nop
.L5166:
	movzx	eax, BYTE PTR -49[rbp]
	add	rsp, 96
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN3TKO7RESOLVE12FILESCOPEOF_ERNS0_3CTXEj;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN3TKO7RESOLVE12FILESCOPEOF_ERNS0_3CTXEj
_ZN3TKO7RESOLVE12FILESCOPEOF_ERNS0_3CTXEj:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 80
	.seh_stackalloc	80
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
	mov	DWORD PTR -36[rbp], 0
.L5191:
	mov	eax, DWORD PTR 24[rbp]
	mov	DWORD PTR -12[rbp], eax
	mov	DWORD PTR -16[rbp], 0
.L5192:
	cmp	DWORD PTR -12[rbp], 0
	je	.L5206
	cmp	DWORD PTR -16[rbp], 255
	setle	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -8[rbp], rax
	jmp	.L5195
.L5206:
	nop
.L5194:
	mov	QWORD PTR -8[rbp], 0
.L5195:
	cmp	QWORD PTR -8[rbp], 0
	je	.L5207
	add	DWORD PTR -16[rbp], 1
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR -12[rbp]
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE7SCOPEATEj
	mov	QWORD PTR -24[rbp], rax
	mov	rax, QWORD PTR -24[rbp]
	mov	QWORD PTR -32[rbp], rax
	cmp	QWORD PTR -32[rbp], 0
	je	.L5208
	nop
.L5199:
	mov	rax, QWORD PTR -32[rbp]
	movzx	eax, BYTE PTR [rax]
	cmp	al, 1
	jne	.L5209
	mov	eax, DWORD PTR -12[rbp]
	mov	DWORD PTR -36[rbp], eax
	jmp	.L5202
.L5209:
	nop
.L5201:
	mov	rax, QWORD PTR -32[rbp]
	mov	eax, DWORD PTR 4[rax]
	mov	DWORD PTR -12[rbp], eax
	jmp	.L5192
.L5207:
	nop
	jmp	.L5197
.L5208:
	nop
.L5197:
	mov	DWORD PTR -36[rbp], 1
	nop
.L5202:
	mov	eax, DWORD PTR -36[rbp]
	add	rsp, 80
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN3TKO7RESOLVE19UNSIGNEDCOUNTERPARTERNS0_3CTXEj;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN3TKO7RESOLVE19UNSIGNEDCOUNTERPARTERNS0_3CTXEj
_ZN3TKO7RESOLVE19UNSIGNEDCOUNTERPARTERNS0_3CTXEj:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 80
	.seh_stackalloc	80
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
	mov	DWORD PTR -48[rbp], 0
.L5211:
	cmp	DWORD PTR 24[rbp], 0
	jne	.L5241
	mov	DWORD PTR -48[rbp], 0
	jmp	.L5214
.L5241:
	nop
.L5213:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 24[rbp]
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT4KINDEj
	mov	QWORD PTR -8[rbp], rax
	cmp	QWORD PTR -8[rbp], 1
	je	.L5242
	mov	DWORD PTR -48[rbp], 0
	jmp	.L5214
.L5242:
	nop
.L5216:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 24[rbp]
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT9BUILTINOFEj
	mov	QWORD PTR -16[rbp], rax
	mov	rax, QWORD PTR -16[rbp]
	mov	QWORD PTR -24[rbp], rax
	cmp	QWORD PTR -24[rbp], 2
	je	.L5243
	nop
.L5217:
	cmp	QWORD PTR -24[rbp], 3
	jne	.L5244
	jmp	.L5218
.L5243:
	nop
.L5218:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, 3
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT7BUILTINENS_11BUILTINTYPEE
	mov	DWORD PTR -44[rbp], eax
	mov	eax, DWORD PTR -44[rbp]
	mov	DWORD PTR -48[rbp], eax
	jmp	.L5214
.L5244:
	nop
.L5219:
	cmp	QWORD PTR -24[rbp], 4
	je	.L5245
	nop
.L5220:
	cmp	QWORD PTR -24[rbp], 5
	jne	.L5246
	jmp	.L5221
.L5245:
	nop
.L5221:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, 5
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT7BUILTINENS_11BUILTINTYPEE
	mov	DWORD PTR -40[rbp], eax
	mov	eax, DWORD PTR -40[rbp]
	mov	DWORD PTR -48[rbp], eax
	jmp	.L5214
.L5246:
	nop
.L5222:
	cmp	QWORD PTR -24[rbp], 6
	je	.L5247
	nop
.L5223:
	cmp	QWORD PTR -24[rbp], 7
	jne	.L5248
	jmp	.L5224
.L5247:
	nop
.L5224:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, 7
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT7BUILTINENS_11BUILTINTYPEE
	mov	DWORD PTR -36[rbp], eax
	mov	eax, DWORD PTR -36[rbp]
	mov	DWORD PTR -48[rbp], eax
	jmp	.L5214
.L5248:
	nop
.L5225:
	cmp	QWORD PTR -24[rbp], 8
	je	.L5249
	nop
.L5226:
	cmp	QWORD PTR -24[rbp], 9
	jne	.L5250
	jmp	.L5227
.L5249:
	nop
.L5227:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, 9
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT7BUILTINENS_11BUILTINTYPEE
	mov	DWORD PTR -32[rbp], eax
	mov	eax, DWORD PTR -32[rbp]
	mov	DWORD PTR -48[rbp], eax
	jmp	.L5214
.L5250:
	nop
.L5228:
	cmp	QWORD PTR -24[rbp], 10
	je	.L5251
	nop
.L5229:
	cmp	QWORD PTR -24[rbp], 11
	jne	.L5252
	jmp	.L5230
.L5251:
	nop
.L5230:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, 11
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT7BUILTINENS_11BUILTINTYPEE
	mov	DWORD PTR -28[rbp], eax
	mov	eax, DWORD PTR -28[rbp]
	mov	DWORD PTR -48[rbp], eax
	jmp	.L5214
.L5231:
.L5252:
	nop
.L5232:
	mov	DWORD PTR -48[rbp], 0
	nop
.L5214:
	mov	eax, DWORD PTR -48[rbp]
	add	rsp, 80
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN3TKO7RESOLVE18TYPELITTARGETTYPE_ERNS0_3CTXEjjRj;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN3TKO7RESOLVE18TYPELITTARGETTYPE_ERNS0_3CTXEjjRj
_ZN3TKO7RESOLVE18TYPELITTARGETTYPE_ERNS0_3CTXEjjRj:
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
	mov	QWORD PTR 40[rbp], r9
	mov	BYTE PTR -69[rbp], 0
.L5254:
	cmp	DWORD PTR 24[rbp], 0
	jne	.L5278
	mov	BYTE PTR -69[rbp], 0
	jmp	.L5257
.L5278:
	nop
.L5256:
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 24[rbp]
	mov	rcx, rax
	call	_ZN3TKO8ASTARENA4KINDEj
	mov	QWORD PTR -16[rbp], rax
	cmp	QWORD PTR -16[rbp], 19
	je	.L5279
	mov	BYTE PTR -69[rbp], 0
	jmp	.L5257
.L5279:
	nop
.L5259:
	mov	edx, DWORD PTR 24[rbp]
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN5ArrayIN3TKO7ASTNODEEEixEi
	mov	QWORD PTR -24[rbp], rax
	mov	rax, QWORD PTR -24[rbp]
	add	rax, 2
	movzx	eax, WORD PTR [rax]
	movzx	eax, ax
	and	eax, 128
	test	rax, rax
	jne	.L5280
	mov	BYTE PTR -69[rbp], 0
	jmp	.L5257
.L5261:
.L5280:
	nop
.L5262:
	mov	eax, DWORD PTR 24[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN3TKO7RESOLVE6LISTOFERNS0_3CTXEj
	mov	QWORD PTR -32[rbp], rax
	mov	rax, QWORD PTR -32[rbp]
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR -36[rbp], eax
	cmp	DWORD PTR -36[rbp], 0
	jne	.L5281
	mov	BYTE PTR -69[rbp], 0
	jmp	.L5257
.L5281:
	nop
.L5264:
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR -36[rbp]
	mov	rcx, rax
	call	_ZN3TKO8ASTARENA4KINDEj
	mov	QWORD PTR -48[rbp], rax
	cmp	QWORD PTR -48[rbp], 28
	je	.L5282
	mov	BYTE PTR -69[rbp], 0
	jmp	.L5257
.L5282:
	nop
.L5266:
	mov	edx, DWORD PTR 32[rbp]
	mov	eax, DWORD PTR -36[rbp]
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN3TKO7RESOLVE14RESOLVETYPEREFERNS0_3CTXEjj
	mov	DWORD PTR -52[rbp], eax
	mov	eax, DWORD PTR -52[rbp]
	mov	DWORD PTR -4[rbp], eax
	cmp	DWORD PTR -4[rbp], 0
	jne	.L5283
	mov	BYTE PTR -69[rbp], 0
	jmp	.L5257
.L5283:
	nop
.L5268:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR -4[rbp]
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT4KINDEj
	mov	QWORD PTR -64[rbp], rax
	cmp	QWORD PTR -64[rbp], 3
	jne	.L5284
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR -4[rbp]
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT5INNEREj
	mov	DWORD PTR -68[rbp], eax
	mov	eax, DWORD PTR -68[rbp]
	mov	DWORD PTR -4[rbp], eax
	jmp	.L5270
.L5284:
	nop
.L5270:
	mov	rax, QWORD PTR 40[rbp]
	mov	edx, DWORD PTR -4[rbp]
	mov	DWORD PTR [rax], edx
	mov	BYTE PTR -69[rbp], 1
	nop
.L5257:
	movzx	eax, BYTE PTR -69[rbp]
	add	rsp, 112
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN3TKO7RESOLVE18LOOKUPTYPEATPOINT_ERNS0_3CTXEjjj;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN3TKO7RESOLVE18LOOKUPTYPEATPOINT_ERNS0_3CTXEjjj
_ZN3TKO7RESOLVE18LOOKUPTYPEATPOINT_ERNS0_3CTXEjjj:
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
	mov	DWORD PTR 232[rbp], r9d
	mov	DWORD PTR 96[rbp], 0
.L5286:
	mov	rax, QWORD PTR 208[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	ecx, DWORD PTR 224[rbp]
	mov	edx, DWORD PTR 216[rbp]
	mov	r9d, 1
	mov	r8d, ecx
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE11LOOKUPTYPEDEjjb
	mov	DWORD PTR 172[rbp], eax
	mov	eax, DWORD PTR 172[rbp]
	mov	DWORD PTR 168[rbp], eax
	cmp	DWORD PTR 168[rbp], 0
	jne	.L5332
	mov	eax, DWORD PTR 168[rbp]
	mov	DWORD PTR 96[rbp], eax
	jmp	.L5289
.L5332:
	nop
.L5288:
	cmp	DWORD PTR 232[rbp], 0
	jne	.L5333
	mov	eax, DWORD PTR 168[rbp]
	mov	DWORD PTR 96[rbp], eax
	jmp	.L5289
.L5333:
	nop
.L5291:
	mov	rax, QWORD PTR 208[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 168[rbp]
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE8SYMBOLATEj
	mov	QWORD PTR 160[rbp], rax
	mov	rax, QWORD PTR 160[rbp]
	mov	QWORD PTR 152[rbp], rax
	cmp	QWORD PTR 152[rbp], 0
	jne	.L5334
	mov	eax, DWORD PTR 168[rbp]
	mov	DWORD PTR 96[rbp], eax
	jmp	.L5289
.L5334:
	nop
.L5293:
	mov	rax, QWORD PTR 152[rbp]
	add	rax, 20
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	jne	.L5335
	mov	eax, DWORD PTR 168[rbp]
	mov	DWORD PTR 96[rbp], eax
	jmp	.L5289
.L5335:
	nop
.L5295:
	mov	rax, QWORD PTR 208[rbp]
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 232[rbp]
	mov	rcx, rax
	call	_ZN3TKO8ASTARENA3LOCEj
	mov	DWORD PTR 148[rbp], eax
	mov	eax, DWORD PTR 148[rbp]
	mov	DWORD PTR 144[rbp], eax
	cmp	DWORD PTR 144[rbp], 0
	jne	.L5336
	mov	eax, DWORD PTR 168[rbp]
	mov	DWORD PTR 96[rbp], eax
	jmp	.L5289
.L5336:
	nop
.L5297:
	mov	rax, QWORD PTR 152[rbp]
	add	rax, 20
	mov	ecx, DWORD PTR [rax]
	mov	rax, QWORD PTR 208[rbp]
	add	rax, 32
	mov	rdx, QWORD PTR [rax]
	lea	rax, 32[rbp]
	mov	r8d, ecx
	mov	rcx, rax
	call	_ZN3TKO13SOURCEMANAGER6DECODEEj
	mov	rax, QWORD PTR 32[rbp]
	mov	rdx, QWORD PTR 40[rbp]
	mov	QWORD PTR 64[rbp], rax
	mov	QWORD PTR 72[rbp], rdx
	mov	rax, QWORD PTR 48[rbp]
	mov	QWORD PTR 80[rbp], rax
	mov	rax, QWORD PTR 208[rbp]
	add	rax, 32
	mov	rdx, QWORD PTR [rax]
	lea	rax, -32[rbp]
	mov	ecx, DWORD PTR 144[rbp]
	mov	r8d, ecx
	mov	rcx, rax
	call	_ZN3TKO13SOURCEMANAGER6DECODEEj
	mov	rax, QWORD PTR -32[rbp]
	mov	rdx, QWORD PTR -24[rbp]
	mov	QWORD PTR 0[rbp], rax
	mov	QWORD PTR 8[rbp], rdx
	mov	rax, QWORD PTR -16[rbp]
	mov	QWORD PTR 16[rbp], rax
	lea	rax, 64[rbp]
	mov	edx, DWORD PTR [rax]
	mov	rax, rbp
	mov	eax, DWORD PTR [rax]
	cmp	edx, eax
	je	.L5337
	mov	eax, DWORD PTR 168[rbp]
	mov	DWORD PTR 96[rbp], eax
	jmp	.L5289
.L5337:
	nop
.L5299:
	lea	rax, 64[rbp]
	add	rax, 16
	mov	edx, DWORD PTR [rax]
	mov	rax, rbp
	add	rax, 16
	mov	eax, DWORD PTR [rax]
	cmp	edx, eax
	jg	.L5338
	mov	eax, DWORD PTR 168[rbp]
	mov	DWORD PTR 96[rbp], eax
	jmp	.L5289
.L5338:
	nop
.L5301:
	mov	eax, DWORD PTR 216[rbp]
	mov	DWORD PTR 188[rbp], eax
.L5302:
	cmp	DWORD PTR 188[rbp], 0
	je	.L5339
	mov	rax, QWORD PTR 208[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 188[rbp]
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE7SCOPEATEj
	mov	QWORD PTR 136[rbp], rax
	mov	rax, QWORD PTR 136[rbp]
	mov	QWORD PTR 128[rbp], rax
	cmp	QWORD PTR 128[rbp], 0
	je	.L5340
	nop
.L5306:
	mov	rax, QWORD PTR 208[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	ecx, DWORD PTR 224[rbp]
	mov	edx, DWORD PTR 188[rbp]
	mov	r9d, 1
	mov	r8d, ecx
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE16LOOKUPLOCALTYPEDEjjb
	mov	DWORD PTR 124[rbp], eax
	mov	eax, DWORD PTR 124[rbp]
	mov	DWORD PTR 120[rbp], eax
	cmp	DWORD PTR 120[rbp], 0
	je	.L5341
	mov	rax, QWORD PTR 208[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 120[rbp]
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE8SYMBOLATEj
	mov	QWORD PTR 112[rbp], rax
	mov	rax, QWORD PTR 112[rbp]
	mov	QWORD PTR 104[rbp], rax
	cmp	QWORD PTR 104[rbp], 0
	je	.L5342
	mov	rax, QWORD PTR 104[rbp]
	add	rax, 20
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	je	.L5343
	mov	rax, QWORD PTR 104[rbp]
	add	rax, 20
	mov	ecx, DWORD PTR [rax]
	mov	rax, QWORD PTR 208[rbp]
	add	rax, 32
	mov	rdx, QWORD PTR [rax]
	lea	rax, -96[rbp]
	mov	r8d, ecx
	mov	rcx, rax
	call	_ZN3TKO13SOURCEMANAGER6DECODEEj
	mov	rax, QWORD PTR -96[rbp]
	mov	rdx, QWORD PTR -88[rbp]
	mov	QWORD PTR -64[rbp], rax
	mov	QWORD PTR -56[rbp], rdx
	mov	rax, QWORD PTR -80[rbp]
	mov	QWORD PTR -48[rbp], rax
	lea	rax, -64[rbp]
	mov	edx, DWORD PTR [rax]
	mov	rax, rbp
	mov	eax, DWORD PTR [rax]
	cmp	edx, eax
	jne	.L5344
	lea	rax, -64[rbp]
	add	rax, 16
	mov	edx, DWORD PTR [rax]
	mov	rax, rbp
	add	rax, 16
	mov	eax, DWORD PTR [rax]
	cmp	edx, eax
	setg	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR 176[rbp], rax
	jmp	.L5314
.L5344:
	nop
.L5313:
	mov	QWORD PTR 176[rbp], 0
.L5314:
	cmp	QWORD PTR 176[rbp], 0
	setne	al
	mov	BYTE PTR 103[rbp], al
	cmp	BYTE PTR 103[rbp], 0
	jne	.L5345
	mov	eax, DWORD PTR 120[rbp]
	mov	DWORD PTR 96[rbp], eax
	jmp	.L5289
.L5345:
	nop
.L5316:
	jmp	.L5320
.L5343:
	nop
.L5311:
	mov	eax, DWORD PTR 120[rbp]
	mov	DWORD PTR 96[rbp], eax
	jmp	.L5289
.L5308:
.L5317:
.L5318:
.L5319:
.L5341:
	nop
	jmp	.L5320
.L5342:
	nop
.L5320:
	mov	rax, QWORD PTR 128[rbp]
	mov	eax, DWORD PTR 4[rax]
	mov	DWORD PTR 188[rbp], eax
	jmp	.L5302
.L5339:
	nop
	jmp	.L5304
.L5340:
	nop
.L5304:
	mov	eax, DWORD PTR 168[rbp]
	mov	DWORD PTR 96[rbp], eax
	nop
.L5289:
	mov	eax, DWORD PTR 96[rbp]
	add	rsp, 320
	pop	rbp
	ret
	.seh_endproc
	.section .rdata,"dr"
.LC24:
	.ascii "..\0"
	.text
	.def	_ZN3TKO7RESOLVE22LOOKUPDOTTEDNAMESPACE_ERNS0_3CTXEjj;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN3TKO7RESOLVE22LOOKUPDOTTEDNAMESPACE_ERNS0_3CTXEjj
_ZN3TKO7RESOLVE22LOOKUPDOTTEDNAMESPACE_ERNS0_3CTXEjj:
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
	mov	DWORD PTR 36[rbp], 0
.L5347:
	mov	rax, QWORD PTR 240[rbp]
	add	rax, 24
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 256[rbp]
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
	mov	eax, DWORD PTR 248[rbp]
	mov	DWORD PTR 212[rbp], eax
	mov	BYTE PTR 211[rbp], 1
	mov	DWORD PTR 204[rbp], 0
	mov	rax, rbp
	mov	edx, 2
	mov	rcx, rax
	call	fb_LEFT
	mov	QWORD PTR 152[rbp], rax
	mov	rax, QWORD PTR 152[rbp]
	mov	r9d, 3
	lea	r8, .LC24[rip]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrCompare
	mov	DWORD PTR 148[rbp], eax
	cmp	DWORD PTR 148[rbp], 0
	jne	.L5395
	mov	DWORD PTR 204[rbp], 2
	mov	eax, DWORD PTR 248[rbp]
	mov	DWORD PTR 188[rbp], eax
	mov	DWORD PTR 184[rbp], 0
.L5350:
	cmp	DWORD PTR 188[rbp], 0
	je	.L5396
	cmp	DWORD PTR 184[rbp], 1023
	setle	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR 192[rbp], rax
	jmp	.L5353
.L5396:
	nop
.L5352:
	mov	QWORD PTR 192[rbp], 0
.L5353:
	cmp	QWORD PTR 192[rbp], 0
	je	.L5397
	add	DWORD PTR 184[rbp], 1
	mov	rax, QWORD PTR 240[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 188[rbp]
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE7SCOPEATEj
	mov	QWORD PTR 136[rbp], rax
	mov	rax, QWORD PTR 136[rbp]
	mov	QWORD PTR 128[rbp], rax
	cmp	QWORD PTR 128[rbp], 0
	je	.L5398
	nop
.L5357:
	mov	rax, QWORD PTR 128[rbp]
	add	rax, 4
	mov	eax, DWORD PTR [rax]
	cmp	eax, 1
	je	.L5399
	nop
.L5359:
	mov	rax, QWORD PTR 128[rbp]
	add	rax, 4
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	je	.L5400
	nop
.L5361:
	mov	rax, QWORD PTR 128[rbp]
	mov	eax, DWORD PTR 4[rax]
	mov	DWORD PTR 188[rbp], eax
	jmp	.L5350
.L5397:
	nop
	jmp	.L5355
.L5398:
	nop
	jmp	.L5355
.L5399:
	nop
	jmp	.L5355
.L5400:
	nop
.L5355:
	mov	eax, DWORD PTR 188[rbp]
	mov	DWORD PTR 212[rbp], eax
	jmp	.L5362
.L5349:
.L5395:
	nop
.L5362:
	mov	DWORD PTR 180[rbp], 0
	mov	DWORD PTR 176[rbp], 0
.L5363:
	mov	rax, rbp
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrLen
	mov	QWORD PTR 120[rbp], rax
	mov	eax, DWORD PTR 204[rbp]
	cdqe
	cmp	QWORD PTR 120[rbp], rax
	jl	.L5401
	cmp	DWORD PTR 176[rbp], 63
	setle	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR 216[rbp], rax
	jmp	.L5366
.L5401:
	nop
.L5365:
	mov	QWORD PTR 216[rbp], 0
.L5366:
	cmp	QWORD PTR 216[rbp], 0
	je	.L5402
	add	DWORD PTR 176[rbp], 1
	mov	edx, 1
	lea	rcx, .LC3[rip]
	call	fb_StrAllocTempDescZEx
	mov	QWORD PTR 112[rbp], rax
	mov	eax, DWORD PTR 204[rbp]
	cdqe
	lea	rcx, 1[rax]
	mov	rdx, QWORD PTR 112[rbp]
	mov	rax, rbp
	mov	r8, rdx
	mov	rdx, rax
	call	fb_StrInstr
	mov	QWORD PTR 104[rbp], rax
	mov	rax, QWORD PTR 104[rbp]
	mov	DWORD PTR 100[rbp], eax
	mov	eax, DWORD PTR 100[rbp]
	mov	DWORD PTR 172[rbp], eax
	cmp	DWORD PTR 172[rbp], 0
	jne	.L5403
	mov	rax, rbp
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrLen
	mov	QWORD PTR 88[rbp], rax
	mov	rax, QWORD PTR 88[rbp]
	add	eax, 1
	mov	DWORD PTR 172[rbp], eax
	jmp	.L5370
.L5403:
	nop
.L5370:
	mov	eax, DWORD PTR 172[rbp]
	movsx	rdx, eax
	mov	eax, DWORD PTR 204[rbp]
	cdqe
	sub	rdx, rax
	mov	rax, rdx
	lea	rcx, -1[rax]
	mov	eax, DWORD PTR 204[rbp]
	cdqe
	lea	rdx, 1[rax]
	mov	rax, rbp
	mov	r8, rcx
	mov	rcx, rax
	call	fb_StrMid
	mov	QWORD PTR 80[rbp], rax
	mov	rdx, QWORD PTR 80[rbp]
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
	mov	QWORD PTR 72[rbp], rax
	cmp	QWORD PTR 72[rbp], 0
	jne	.L5404
	mov	DWORD PTR 36[rbp], 0
	lea	rax, -64[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	mov	rax, rbp
	mov	rcx, rax
	call	fb_StrDelete
	jmp	.L5385
.L5404:
	nop
.L5372:
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
	mov	rax, QWORD PTR 240[rbp]
	add	rax, 24
	mov	rax, QWORD PTR [rax]
	lea	rdx, -32[rbp]
	mov	rcx, rax
	call	_ZN3TKO8INTERNER9GETSTRINGE8FBSTRING
	mov	DWORD PTR 68[rbp], eax
	mov	eax, DWORD PTR 68[rbp]
	mov	DWORD PTR 64[rbp], eax
	lea	rax, -32[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	mov	DWORD PTR -68[rbp], 0
	cmp	BYTE PTR 211[rbp], 0
	je	.L5405
	mov	rax, QWORD PTR 240[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	ecx, DWORD PTR 64[rbp]
	mov	edx, DWORD PTR 212[rbp]
	mov	r8d, ecx
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE6LOOKUPEjj
	mov	DWORD PTR 60[rbp], eax
	mov	eax, DWORD PTR 60[rbp]
	mov	DWORD PTR -68[rbp], eax
	jmp	.L5376
.L5405:
	nop
.L5375:
	mov	rax, QWORD PTR 240[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	ecx, DWORD PTR 64[rbp]
	mov	edx, DWORD PTR 212[rbp]
	mov	r8d, ecx
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE11LOOKUPLOCALEjj
	mov	DWORD PTR 56[rbp], eax
	mov	eax, DWORD PTR 56[rbp]
	mov	DWORD PTR -68[rbp], eax
.L5376:
	mov	edx, DWORD PTR -68[rbp]
	mov	rax, QWORD PTR 240[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE8SYMBOLATEj
	mov	QWORD PTR 48[rbp], rax
	mov	rax, QWORD PTR 48[rbp]
	mov	QWORD PTR 40[rbp], rax
	cmp	QWORD PTR 40[rbp], 0
	jne	.L5406
	mov	DWORD PTR 36[rbp], 0
	lea	rax, -64[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	mov	rax, rbp
	mov	rcx, rax
	call	fb_StrDelete
	jmp	.L5385
.L5406:
	nop
.L5378:
	mov	eax, DWORD PTR -68[rbp]
	mov	DWORD PTR 180[rbp], eax
	mov	BYTE PTR 211[rbp], 0
	cmp	DWORD PTR 100[rbp], 0
	jne	.L5407
	lea	rax, -64[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	jmp	.L5368
.L5407:
	nop
.L5380:
	mov	rax, QWORD PTR 40[rbp]
	movzx	eax, BYTE PTR [rax]
	cmp	al, 10
	je	.L5408
	mov	DWORD PTR 36[rbp], 0
	lea	rax, -64[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	mov	rax, rbp
	mov	rcx, rax
	call	fb_StrDelete
	jmp	.L5385
.L5408:
	nop
.L5382:
	mov	rax, QWORD PTR 40[rbp]
	add	rax, 36
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	jne	.L5409
	mov	DWORD PTR 36[rbp], 0
	lea	rax, -64[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	mov	rax, rbp
	mov	rcx, rax
	call	fb_StrDelete
	jmp	.L5385
.L5409:
	nop
.L5384:
	mov	rax, QWORD PTR 40[rbp]
	mov	eax, DWORD PTR 36[rax]
	mov	DWORD PTR 212[rbp], eax
	mov	eax, DWORD PTR 100[rbp]
	mov	DWORD PTR 204[rbp], eax
	lea	rax, -64[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	jmp	.L5363
.L5402:
	nop
.L5368:
	mov	eax, DWORD PTR 180[rbp]
	mov	DWORD PTR 36[rbp], eax
	mov	rax, rbp
	mov	rcx, rax
	call	fb_StrDelete
	nop
.L5385:
	mov	eax, DWORD PTR 36[rbp]
	add	rsp, 352
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN3TKO7RESOLVE12BASESCOPEOF_ERNS0_3CTXEj;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN3TKO7RESOLVE12BASESCOPEOF_ERNS0_3CTXEj
_ZN3TKO7RESOLVE12BASESCOPEOF_ERNS0_3CTXEj:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 192
	.seh_stackalloc	192
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
	mov	DWORD PTR -132[rbp], 0
.L5411:
	lea	rax, -128[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	lea	rax, -128[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9d, 5
	lea	r8, .LC6[rip]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrAssign
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 24
	mov	rax, QWORD PTR [rax]
	lea	rdx, -128[rbp]
	mov	rcx, rax
	call	_ZN3TKO8INTERNER9GETSTRINGE8FBSTRING
	mov	DWORD PTR -8[rbp], eax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 24
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR -8[rbp]
	mov	rcx, rax
	call	_ZN3TKO8INTERNER4FOLDEj
	mov	DWORD PTR -12[rbp], eax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	ecx, DWORD PTR -12[rbp]
	mov	edx, DWORD PTR 24[rbp]
	mov	r8d, ecx
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE11LOOKUPLOCALEjj
	mov	DWORD PTR -16[rbp], eax
	mov	eax, DWORD PTR -16[rbp]
	mov	DWORD PTR -20[rbp], eax
	lea	rax, -128[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	cmp	DWORD PTR -20[rbp], 0
	jne	.L5434
	mov	DWORD PTR -132[rbp], 0
	jmp	.L5414
.L5434:
	nop
.L5413:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR -20[rbp]
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE8SYMBOLATEj
	mov	QWORD PTR -32[rbp], rax
	mov	rax, QWORD PTR -32[rbp]
	mov	QWORD PTR -40[rbp], rax
	cmp	QWORD PTR -40[rbp], 0
	jne	.L5435
	mov	DWORD PTR -132[rbp], 0
	jmp	.L5414
.L5435:
	nop
.L5416:
	mov	rax, QWORD PTR -40[rbp]
	add	rax, 16
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	jne	.L5436
	mov	DWORD PTR -132[rbp], 0
	jmp	.L5414
.L5436:
	nop
.L5418:
	mov	rax, QWORD PTR -40[rbp]
	add	rax, 16
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT9UNQUALIFYEj
	mov	DWORD PTR -44[rbp], eax
	mov	eax, DWORD PTR -44[rbp]
	mov	DWORD PTR -48[rbp], eax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR -48[rbp]
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT4KINDEj
	mov	QWORD PTR -56[rbp], rax
	cmp	QWORD PTR -56[rbp], 6
	je	.L5437
	mov	DWORD PTR -132[rbp], 0
	jmp	.L5414
.L5437:
	nop
.L5420:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR -48[rbp]
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT6NAMEOFEj
	mov	DWORD PTR -60[rbp], eax
	mov	eax, DWORD PTR -60[rbp]
	mov	DWORD PTR -64[rbp], eax
	cmp	DWORD PTR -64[rbp], 0
	jne	.L5438
	mov	DWORD PTR -132[rbp], 0
	jmp	.L5414
.L5438:
	nop
.L5422:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR -48[rbp]
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT11DECLSCOPEOFEj
	mov	DWORD PTR -68[rbp], eax
	mov	eax, DWORD PTR -68[rbp]
	mov	DWORD PTR -72[rbp], eax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	ecx, DWORD PTR -64[rbp]
	mov	edx, DWORD PTR -72[rbp]
	mov	r9d, 1
	mov	r8d, ecx
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE16LOOKUPLOCALTYPEDEjjb
	mov	DWORD PTR -76[rbp], eax
	mov	eax, DWORD PTR -76[rbp]
	mov	DWORD PTR -4[rbp], eax
	cmp	DWORD PTR -4[rbp], 0
	jne	.L5439
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	ecx, DWORD PTR -64[rbp]
	mov	edx, DWORD PTR -72[rbp]
	mov	r9d, 1
	mov	r8d, ecx
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE11LOOKUPTYPEDEjjb
	mov	DWORD PTR -80[rbp], eax
	mov	eax, DWORD PTR -80[rbp]
	mov	DWORD PTR -4[rbp], eax
	jmp	.L5424
.L5439:
	nop
.L5424:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR -4[rbp]
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE8SYMBOLATEj
	mov	QWORD PTR -88[rbp], rax
	mov	rax, QWORD PTR -88[rbp]
	mov	QWORD PTR -96[rbp], rax
	cmp	QWORD PTR -96[rbp], 0
	jne	.L5440
	mov	DWORD PTR -132[rbp], 0
	jmp	.L5414
.L5440:
	nop
.L5426:
	mov	rax, QWORD PTR -96[rbp]
	mov	eax, DWORD PTR 36[rax]
	mov	DWORD PTR -132[rbp], eax
	nop
.L5414:
	mov	eax, DWORD PTR -132[rbp]
	add	rsp, 192
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN3TKO7RESOLVE17LOOKUPDOTTEDTYPE_ERNS0_3CTXEjj;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN3TKO7RESOLVE17LOOKUPDOTTEDTYPE_ERNS0_3CTXEjj
_ZN3TKO7RESOLVE17LOOKUPDOTTEDTYPE_ERNS0_3CTXEjj:
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
	mov	DWORD PTR 24[rbp], 0
.L5442:
	mov	rax, QWORD PTR 208[rbp]
	add	rax, 24
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 224[rbp]
	mov	rcx, rax
	call	_ZN3TKO8INTERNER8SPELLINGEj
	mov	QWORD PTR 128[rbp], rax
	mov	rdx, QWORD PTR 128[rbp]
	mov	rax, rbp
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrInit
	mov	eax, DWORD PTR 216[rbp]
	mov	DWORD PTR 188[rbp], eax
	mov	BYTE PTR 187[rbp], 1
	mov	DWORD PTR 180[rbp], 0
	mov	DWORD PTR 176[rbp], 0
.L5443:
	mov	rax, rbp
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrLen
	mov	QWORD PTR 120[rbp], rax
	mov	eax, DWORD PTR 180[rbp]
	cdqe
	cmp	QWORD PTR 120[rbp], rax
	jl	.L5485
	mov	edx, 1
	lea	rcx, .LC3[rip]
	call	fb_StrAllocTempDescZEx
	mov	QWORD PTR 112[rbp], rax
	mov	eax, DWORD PTR 180[rbp]
	cdqe
	lea	rcx, 1[rax]
	mov	rdx, QWORD PTR 112[rbp]
	mov	rax, rbp
	mov	r8, rdx
	mov	rdx, rax
	call	fb_StrInstr
	mov	QWORD PTR 104[rbp], rax
	mov	rax, QWORD PTR 104[rbp]
	mov	DWORD PTR 100[rbp], eax
	mov	eax, DWORD PTR 100[rbp]
	mov	DWORD PTR 156[rbp], eax
	cmp	DWORD PTR 156[rbp], 0
	jne	.L5486
	mov	rax, rbp
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrLen
	mov	QWORD PTR 88[rbp], rax
	mov	rax, QWORD PTR 88[rbp]
	add	eax, 1
	mov	DWORD PTR 156[rbp], eax
	jmp	.L5447
.L5486:
	nop
.L5447:
	mov	eax, DWORD PTR 156[rbp]
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
	mov	QWORD PTR 80[rbp], rax
	mov	rdx, QWORD PTR 80[rbp]
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
	mov	QWORD PTR 72[rbp], rax
	cmp	QWORD PTR 72[rbp], 0
	jne	.L5487
	mov	DWORD PTR 24[rbp], 0
	lea	rax, -64[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	mov	rax, rbp
	mov	rcx, rax
	call	fb_StrDelete
	jmp	.L5475
.L5487:
	nop
.L5449:
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
	add	rax, 24
	mov	rax, QWORD PTR [rax]
	lea	rdx, -32[rbp]
	mov	rcx, rax
	call	_ZN3TKO8INTERNER9GETSTRINGE8FBSTRING
	mov	DWORD PTR 68[rbp], eax
	mov	eax, DWORD PTR 68[rbp]
	mov	DWORD PTR 64[rbp], eax
	lea	rax, -32[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	mov	DWORD PTR -68[rbp], 0
	cmp	BYTE PTR 187[rbp], 0
	je	.L5488
	mov	rax, QWORD PTR 208[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	ecx, DWORD PTR 64[rbp]
	mov	edx, DWORD PTR 188[rbp]
	mov	r8d, ecx
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE6LOOKUPEjj
	mov	DWORD PTR 60[rbp], eax
	mov	eax, DWORD PTR 60[rbp]
	mov	DWORD PTR -68[rbp], eax
	jmp	.L5461
.L5488:
	nop
.L5452:
	mov	rax, QWORD PTR 208[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	ecx, DWORD PTR 64[rbp]
	mov	edx, DWORD PTR 188[rbp]
	mov	r9d, 1
	mov	r8d, ecx
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE16LOOKUPLOCALTYPEDEjjb
	mov	DWORD PTR 56[rbp], eax
	mov	eax, DWORD PTR 56[rbp]
	mov	DWORD PTR -68[rbp], eax
	mov	eax, DWORD PTR 188[rbp]
	mov	DWORD PTR 140[rbp], eax
	mov	DWORD PTR 136[rbp], 0
.L5454:
	mov	eax, DWORD PTR -68[rbp]
	test	eax, eax
	jne	.L5489
	cmp	DWORD PTR 136[rbp], 31
	setle	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR 144[rbp], rax
	jmp	.L5457
.L5489:
	nop
.L5456:
	mov	QWORD PTR 144[rbp], 0
.L5457:
	cmp	QWORD PTR 144[rbp], 0
	je	.L5490
	mov	eax, DWORD PTR 140[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 208[rbp]
	call	_ZN3TKO7RESOLVE12BASESCOPEOF_ERNS0_3CTXEj
	mov	DWORD PTR 52[rbp], eax
	mov	eax, DWORD PTR 52[rbp]
	mov	DWORD PTR 140[rbp], eax
	cmp	DWORD PTR 140[rbp], 0
	je	.L5491
	nop
.L5460:
	mov	rax, QWORD PTR 208[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	ecx, DWORD PTR 64[rbp]
	mov	edx, DWORD PTR 140[rbp]
	mov	r9d, 1
	mov	r8d, ecx
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE16LOOKUPLOCALTYPEDEjjb
	mov	DWORD PTR 48[rbp], eax
	mov	eax, DWORD PTR 48[rbp]
	mov	DWORD PTR -68[rbp], eax
	add	DWORD PTR 136[rbp], 1
	jmp	.L5454
.L5453:
.L5490:
	nop
	jmp	.L5461
.L5491:
	nop
.L5461:
	mov	edx, DWORD PTR -68[rbp]
	mov	rax, QWORD PTR 208[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE8SYMBOLATEj
	mov	QWORD PTR 40[rbp], rax
	mov	rax, QWORD PTR 40[rbp]
	mov	QWORD PTR 32[rbp], rax
	cmp	QWORD PTR 32[rbp], 0
	jne	.L5492
	mov	DWORD PTR 24[rbp], 0
	lea	rax, -64[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	mov	rax, rbp
	mov	rcx, rax
	call	fb_StrDelete
	jmp	.L5475
.L5492:
	nop
.L5463:
	mov	eax, DWORD PTR -68[rbp]
	mov	DWORD PTR 176[rbp], eax
	mov	BYTE PTR 187[rbp], 0
	cmp	DWORD PTR 100[rbp], 0
	jne	.L5493
	lea	rax, -64[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	jmp	.L5445
.L5493:
	nop
.L5465:
	mov	rax, QWORD PTR 32[rbp]
	movzx	eax, BYTE PTR [rax]
	cmp	al, 10
	je	.L5494
	mov	rax, QWORD PTR 32[rbp]
	movzx	eax, BYTE PTR [rax]
	cmp	al, 6
	sete	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR 168[rbp], rax
	jmp	.L5468
.L5494:
	nop
.L5467:
	mov	QWORD PTR 168[rbp], -1
.L5468:
	cmp	QWORD PTR 168[rbp], 0
	setne	al
	mov	BYTE PTR 31[rbp], al
	cmp	BYTE PTR 31[rbp], 0
	je	.L5495
	mov	rax, QWORD PTR 32[rbp]
	add	rax, 36
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	sete	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR 160[rbp], rax
	jmp	.L5471
.L5495:
	nop
.L5470:
	mov	QWORD PTR 160[rbp], -1
.L5471:
	cmp	QWORD PTR 160[rbp], 0
	je	.L5496
	mov	DWORD PTR 24[rbp], 0
	lea	rax, -64[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	mov	rax, rbp
	mov	rcx, rax
	call	fb_StrDelete
	jmp	.L5475
.L5473:
.L5496:
	nop
.L5474:
	mov	rax, QWORD PTR 32[rbp]
	mov	eax, DWORD PTR 36[rax]
	mov	DWORD PTR 188[rbp], eax
	mov	eax, DWORD PTR 100[rbp]
	mov	DWORD PTR 180[rbp], eax
	lea	rax, -64[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	jmp	.L5443
.L5485:
	nop
.L5445:
	mov	eax, DWORD PTR 176[rbp]
	mov	DWORD PTR 24[rbp], eax
	mov	rax, rbp
	mov	rcx, rax
	call	fb_StrDelete
	nop
.L5475:
	mov	eax, DWORD PTR 24[rbp]
	add	rsp, 320
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN3TKO7RESOLVE21CHECKSTATICMEMBERVAR_ERNS0_3CTXEjjjj;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN3TKO7RESOLVE21CHECKSTATICMEMBERVAR_ERNS0_3CTXEjjjj
_ZN3TKO7RESOLVE21CHECKSTATICMEMBERVAR_ERNS0_3CTXEjjjj:
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
	mov	DWORD PTR 264[rbp], r9d
.L5498:
	cmp	DWORD PTR 264[rbp], 0
	je	.L5526
	cmp	DWORD PTR 272[rbp], 0
	sete	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR 216[rbp], rax
	jmp	.L5501
.L5526:
	nop
.L5500:
	mov	QWORD PTR 216[rbp], -1
.L5501:
	cmp	QWORD PTR 216[rbp], 0
	jne	.L5527
	nop
.L5503:
	mov	edx, DWORD PTR 264[rbp]
	mov	eax, DWORD PTR 248[rbp]
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 240[rbp]
	call	_ZN3TKO7RESOLVE17LOOKUPDOTTEDTYPE_ERNS0_3CTXEjj
	mov	DWORD PTR 192[rbp], eax
	mov	eax, DWORD PTR 192[rbp]
	mov	DWORD PTR 188[rbp], eax
	mov	rax, QWORD PTR 240[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 188[rbp]
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE8SYMBOLATEj
	mov	QWORD PTR 176[rbp], rax
	mov	rax, QWORD PTR 176[rbp]
	mov	QWORD PTR 168[rbp], rax
	cmp	QWORD PTR 168[rbp], 0
	je	.L5528
	nop
.L5506:
	mov	rax, QWORD PTR 168[rbp]
	movzx	eax, BYTE PTR [rax]
	cmp	al, 6
	jne	.L5529
	nop
.L5508:
	mov	rax, QWORD PTR 168[rbp]
	add	rax, 36
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	je	.L5530
	nop
.L5510:
	mov	rax, QWORD PTR 168[rbp]
	mov	eax, DWORD PTR 36[rax]
	mov	DWORD PTR 204[rbp], eax
	mov	rax, QWORD PTR 240[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	ecx, DWORD PTR 272[rbp]
	mov	edx, DWORD PTR 204[rbp]
	mov	r9d, 1
	mov	r8d, ecx
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE16LOOKUPLOCALTYPEDEjjb
	mov	DWORD PTR 164[rbp], eax
	mov	eax, DWORD PTR 164[rbp]
	mov	DWORD PTR 200[rbp], eax
	mov	DWORD PTR 196[rbp], 0
.L5511:
	cmp	DWORD PTR 200[rbp], 0
	jne	.L5531
	cmp	DWORD PTR 196[rbp], 31
	setle	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR 208[rbp], rax
	jmp	.L5514
.L5531:
	nop
.L5513:
	mov	QWORD PTR 208[rbp], 0
.L5514:
	cmp	QWORD PTR 208[rbp], 0
	je	.L5532
	mov	eax, DWORD PTR 204[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 240[rbp]
	call	_ZN3TKO7RESOLVE12BASESCOPEOF_ERNS0_3CTXEj
	mov	DWORD PTR 160[rbp], eax
	mov	eax, DWORD PTR 160[rbp]
	mov	DWORD PTR 204[rbp], eax
	cmp	DWORD PTR 204[rbp], 0
	je	.L5533
	nop
.L5518:
	mov	rax, QWORD PTR 240[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	ecx, DWORD PTR 272[rbp]
	mov	edx, DWORD PTR 204[rbp]
	mov	r9d, 1
	mov	r8d, ecx
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE16LOOKUPLOCALTYPEDEjjb
	mov	DWORD PTR 156[rbp], eax
	mov	eax, DWORD PTR 156[rbp]
	mov	DWORD PTR 200[rbp], eax
	add	DWORD PTR 196[rbp], 1
	jmp	.L5511
.L5532:
	nop
	jmp	.L5516
.L5533:
	nop
.L5516:
	mov	rax, QWORD PTR 240[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 200[rbp]
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE8SYMBOLATEj
	mov	QWORD PTR 144[rbp], rax
	mov	rax, QWORD PTR 144[rbp]
	mov	QWORD PTR 136[rbp], rax
	cmp	QWORD PTR 136[rbp], 0
	je	.L5534
	mov	rax, QWORD PTR 136[rbp]
	add	rax, 4
	mov	eax, DWORD PTR [rax]
	mov	eax, eax
	and	eax, 2
	test	rax, rax
	jne	.L5535
	jmp	.L5523
.L5520:
.L5522:
.L5534:
	nop
.L5523:
	lea	rax, -64[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	lea	rax, -64[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9d, 1
	lea	r8, .LC4[rip]
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
	lea	r8, .LC4[rip]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrAssign
	mov	rax, rbp
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	rax, QWORD PTR 240[rbp]
	add	rax, 24
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 272[rbp]
	mov	rcx, rax
	call	_ZN3TKO8INTERNER8SPELLINGEj
	mov	QWORD PTR 128[rbp], rax
	mov	rax, QWORD PTR 240[rbp]
	add	rax, 24
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 264[rbp]
	mov	rcx, rax
	call	_ZN3TKO8INTERNER8SPELLINGEj
	mov	QWORD PTR 120[rbp], rax
	lea	rax, 64[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	rdx, QWORD PTR 120[rbp]
	lea	rax, 64[rbp]
	mov	QWORD PTR 32[rsp], 2
	lea	r9, .LC3[rip]
	mov	r8, -1
	mov	rcx, rax
	call	fb_StrConcat
	mov	QWORD PTR 112[rbp], rax
	lea	rax, 32[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	rcx, QWORD PTR 128[rbp]
	mov	rdx, QWORD PTR 112[rbp]
	lea	rax, 32[rbp]
	mov	QWORD PTR 32[rsp], -1
	mov	r9, rcx
	mov	r8, -1
	mov	rcx, rax
	call	fb_StrConcat
	mov	QWORD PTR 104[rbp], rax
	mov	rdx, QWORD PTR 104[rbp]
	mov	rax, rbp
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrAssign
	mov	rax, QWORD PTR 240[rbp]
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 256[rbp]
	mov	rcx, rax
	call	_ZN3TKO8ASTARENA3LOCEj
	mov	DWORD PTR 100[rbp], eax
	mov	eax, DWORD PTR 100[rbp]
	mov	ecx, eax
	call	_ZN3TKO10POINTRANGEEj
	mov	QWORD PTR -72[rbp], rax
	mov	rax, QWORD PTR 240[rbp]
	add	rax, 40
	mov	rax, QWORD PTR [rax]
	mov	r8, rbp
	mov	rcx, QWORD PTR -72[rbp]
	lea	rdx, -64[rbp]
	mov	QWORD PTR 40[rsp], rdx
	lea	rdx, -32[rbp]
	mov	QWORD PTR 32[rsp], rdx
	mov	r9, r8
	mov	r8, rcx
	mov	edx, 135
	mov	rcx, rax
	call	_ZN3TKO16DIAGNOSTICENGINE6REPORTENS_6DIAGIDENS_11SOURCERANGEE8FBSTRINGS3_S3_
	lea	rax, -64[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	lea	rax, -32[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	mov	rax, rbp
	mov	rcx, rax
	call	fb_StrDelete
	jmp	.L5536
.L5527:
	nop
	jmp	.L5536
.L5528:
	nop
	jmp	.L5536
.L5529:
	nop
	jmp	.L5536
.L5530:
	nop
	jmp	.L5536
.L5535:
	nop
.L5504:
.L5536:
	nop
	add	rsp, 352
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN3TKO7RESOLVE12ARRAYTOOBIG_ERNS0_3CTXEjjj;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN3TKO7RESOLVE12ARRAYTOOBIG_ERNS0_3CTXEjjj
_ZN3TKO7RESOLVE12ARRAYTOOBIG_ERNS0_3CTXEjjj:
	push	rbp
	.seh_pushreg	rbp
	sub	rsp, 304
	.seh_stackalloc	304
	lea	rbp, 128[rsp]
	.seh_setframe	rbp, 128
	.seh_endprologue
	mov	QWORD PTR 192[rbp], rcx
	mov	DWORD PTR 200[rbp], edx
	mov	DWORD PTR 208[rbp], r8d
	mov	DWORD PTR 216[rbp], r9d
.L5538:
	cmp	DWORD PTR 200[rbp], 0
	je	.L5567
	nop
.L5540:
	mov	rax, QWORD PTR 192[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 200[rbp]
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT4KINDEj
	mov	QWORD PTR 152[rbp], rax
	cmp	QWORD PTR 152[rbp], 4
	jne	.L5568
	nop
.L5543:
	mov	rax, QWORD PTR 192[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 200[rbp]
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT10ISDYNARRAYEj
	mov	BYTE PTR 151[rbp], al
	cmp	BYTE PTR 151[rbp], 0
	jne	.L5569
	nop
.L5545:
	mov	rax, QWORD PTR 192[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 200[rbp]
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT5INNEREj
	mov	DWORD PTR 144[rbp], eax
	mov	eax, DWORD PTR 144[rbp]
	mov	DWORD PTR 140[rbp], eax
	cmp	DWORD PTR 140[rbp], 0
	je	.L5570
	nop
.L5547:
	mov	rax, QWORD PTR 192[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 140[rbp]
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT6LAYOUTEj
	mov	QWORD PTR -72[rbp], rax
	mov	rax, QWORD PTR -72[rbp]
	mov	QWORD PTR 28[rbp], rax
	lea	rax, 28[rbp]
	mov	eax, DWORD PTR [rax]
	cdqe
	mov	QWORD PTR 128[rbp], rax
	cmp	QWORD PTR 128[rbp], 0
	jle	.L5571
	nop
.L5549:
	mov	edx, DWORD PTR 200[rbp]
	mov	rax, QWORD PTR 192[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN5ArrayIN3TKO8TYPEINFOEEixEi
	mov	QWORD PTR 120[rbp], rax
	mov	rax, QWORD PTR 120[rbp]
	mov	eax, DWORD PTR 24[rax]
	mov	DWORD PTR 116[rbp], eax
	cmp	DWORD PTR 116[rbp], 0
	jle	.L5572
	nop
.L5551:
	mov	edx, DWORD PTR 200[rbp]
	mov	rax, QWORD PTR 192[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN5ArrayIN3TKO8TYPEINFOEEixEi
	mov	QWORD PTR 104[rbp], rax
	mov	rax, QWORD PTR 104[rbp]
	mov	eax, DWORD PTR 16[rax]
	mov	DWORD PTR 100[rbp], eax
	mov	edx, DWORD PTR 200[rbp]
	mov	rax, QWORD PTR 192[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN5ArrayIN3TKO8TYPEINFOEEixEi
	mov	QWORD PTR 88[rbp], rax
	mov	rax, QWORD PTR 88[rbp]
	add	rax, 20
	mov	eax, DWORD PTR [rax]
	cdqe
	mov	edx, DWORD PTR 116[rbp]
	movsx	rdx, edx
	add	rdx, rdx
	cmp	rax, rdx
	jl	.L5573
	nop
.L5553:
	mov	QWORD PTR 168[rbp], 1
	mov	DWORD PTR 164[rbp], 0
	mov	eax, DWORD PTR 116[rbp]
	sub	eax, 1
	mov	DWORD PTR 84[rbp], eax
	jmp	.L5554
.L5576:
	nop
.L5555:
	mov	eax, DWORD PTR 164[rbp]
	cdqe
	add	rax, rax
	mov	edx, eax
	mov	eax, DWORD PTR 100[rbp]
	add	edx, eax
	mov	rax, QWORD PTR 192[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	add	rax, 160
	mov	rcx, rax
	call	_ZN5ArrayIxEixEi
	mov	QWORD PTR 72[rbp], rax
	mov	rax, QWORD PTR 72[rbp]
	mov	rax, QWORD PTR [rax]
	mov	QWORD PTR 64[rbp], rax
	mov	eax, DWORD PTR 164[rbp]
	cdqe
	add	rax, rax
	mov	edx, eax
	mov	eax, DWORD PTR 100[rbp]
	add	eax, edx
	lea	edx, 1[rax]
	mov	rax, QWORD PTR 192[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	add	rax, 160
	mov	rcx, rax
	call	_ZN5ArrayIxEixEi
	mov	QWORD PTR 56[rbp], rax
	mov	rax, QWORD PTR 56[rbp]
	mov	rax, QWORD PTR [rax]
	mov	QWORD PTR 48[rbp], rax
	mov	rax, QWORD PTR 48[rbp]
	cmp	rax, QWORD PTR 64[rbp]
	jl	.L5574
	nop
.L5557:
	mov	rax, QWORD PTR 48[rbp]
	sub	rax, QWORD PTR 64[rbp]
	lea	rdx, 1[rax]
	mov	rax, QWORD PTR 168[rbp]
	imul	rax, rdx
	mov	QWORD PTR 168[rbp], rax
	mov	eax, 2147483648
	cmp	QWORD PTR 168[rbp], rax
	jge	.L5575
.L5559:
	nop
.L5561:
	add	DWORD PTR 164[rbp], 1
.L5554:
	mov	eax, DWORD PTR 164[rbp]
	cmp	eax, DWORD PTR 84[rbp]
	jle	.L5576
	jmp	.L5560
.L5575:
	nop
.L5560:
	cmp	QWORD PTR 168[rbp], 0
	jle	.L5577
	nop
.L5563:
	mov	rax, QWORD PTR 128[rbp]
	imul	rax, QWORD PTR 168[rbp]
	mov	edx, 2147483648
	cmp	rax, rdx
	jl	.L5578
	nop
.L5565:
	lea	rax, -64[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	lea	rax, -64[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9d, 1
	lea	r8, .LC4[rip]
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
	lea	r8, .LC4[rip]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrAssign
	mov	rax, rbp
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	rax, QWORD PTR 192[rbp]
	add	rax, 24
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 216[rbp]
	mov	rcx, rax
	call	_ZN3TKO8INTERNER8SPELLINGEj
	mov	QWORD PTR 40[rbp], rax
	mov	rdx, QWORD PTR 40[rbp]
	mov	rax, rbp
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrAssign
	mov	rax, QWORD PTR 192[rbp]
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 208[rbp]
	mov	rcx, rax
	call	_ZN3TKO8ASTARENA3LOCEj
	mov	DWORD PTR 36[rbp], eax
	mov	eax, DWORD PTR 36[rbp]
	mov	ecx, eax
	call	_ZN3TKO10POINTRANGEEj
	mov	QWORD PTR -80[rbp], rax
	mov	rax, QWORD PTR 192[rbp]
	add	rax, 40
	mov	rax, QWORD PTR [rax]
	mov	r8, rbp
	mov	rcx, QWORD PTR -80[rbp]
	lea	rdx, -64[rbp]
	mov	QWORD PTR 40[rsp], rdx
	lea	rdx, -32[rbp]
	mov	QWORD PTR 32[rsp], rdx
	mov	r9, r8
	mov	r8, rcx
	mov	edx, 87
	mov	rcx, rax
	call	_ZN3TKO16DIAGNOSTICENGINE6REPORTENS_6DIAGIDENS_11SOURCERANGEE8FBSTRINGS3_S3_
	lea	rax, -64[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	lea	rax, -32[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	mov	rax, rbp
	mov	rcx, rax
	call	fb_StrDelete
	jmp	.L5579
.L5567:
	nop
	jmp	.L5579
.L5568:
	nop
	jmp	.L5579
.L5569:
	nop
	jmp	.L5579
.L5570:
	nop
	jmp	.L5579
.L5571:
	nop
	jmp	.L5579
.L5572:
	nop
	jmp	.L5579
.L5573:
	nop
	jmp	.L5579
.L5574:
	nop
	jmp	.L5579
.L5577:
	nop
	jmp	.L5579
.L5578:
	nop
.L5541:
.L5579:
	nop
	add	rsp, 304
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN3TKO7RESOLVE9UDTSYMOF_ERNS0_3CTXEj;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN3TKO7RESOLVE9UDTSYMOF_ERNS0_3CTXEj
_ZN3TKO7RESOLVE9UDTSYMOF_ERNS0_3CTXEj:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 64
	.seh_stackalloc	64
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
	mov	DWORD PTR -32[rbp], 0
.L5581:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 24[rbp]
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT6NAMEOFEj
	mov	DWORD PTR -8[rbp], eax
	mov	eax, DWORD PTR -8[rbp]
	mov	DWORD PTR -12[rbp], eax
	cmp	DWORD PTR -12[rbp], 0
	jne	.L5589
	mov	DWORD PTR -32[rbp], 0
	jmp	.L5584
.L5589:
	nop
.L5583:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 24[rbp]
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT11DECLSCOPEOFEj
	mov	DWORD PTR -16[rbp], eax
	mov	eax, DWORD PTR -16[rbp]
	mov	DWORD PTR -20[rbp], eax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	ecx, DWORD PTR -12[rbp]
	mov	edx, DWORD PTR -20[rbp]
	mov	r9d, 1
	mov	r8d, ecx
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE16LOOKUPLOCALTYPEDEjjb
	mov	DWORD PTR -24[rbp], eax
	mov	eax, DWORD PTR -24[rbp]
	mov	DWORD PTR -4[rbp], eax
	cmp	DWORD PTR -4[rbp], 0
	jne	.L5590
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	ecx, DWORD PTR -12[rbp]
	mov	edx, DWORD PTR -20[rbp]
	mov	r9d, 1
	mov	r8d, ecx
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE11LOOKUPTYPEDEjjb
	mov	DWORD PTR -28[rbp], eax
	mov	eax, DWORD PTR -28[rbp]
	mov	DWORD PTR -4[rbp], eax
	jmp	.L5586
.L5590:
	nop
.L5586:
	mov	eax, DWORD PTR -4[rbp]
	mov	DWORD PTR -32[rbp], eax
	nop
.L5584:
	mov	eax, DWORD PTR -32[rbp]
	add	rsp, 64
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN3TKO7RESOLVE11SLOTSGROUP_ERNS0_3CTXER5ArrayIjERiibi;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN3TKO7RESOLVE11SLOTSGROUP_ERNS0_3CTXER5ArrayIjERiibi
_ZN3TKO7RESOLVE11SLOTSGROUP_ERNS0_3CTXER5ArrayIjERiibi:
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
	mov	DWORD PTR 40[rbp], r9d
	mov	eax, DWORD PTR 48[rbp]
	mov	BYTE PTR -100[rbp], al
	mov	DWORD PTR -88[rbp], 0
.L5592:
	mov	DWORD PTR -4[rbp], 0
	mov	DWORD PTR -8[rbp], -2
	mov	BYTE PTR -9[rbp], 1
.L5593:
	mov	rax, QWORD PTR 24[rbp]
	mov	rcx, rax
	call	_ZN5ArrayIjE5COUNTEv
	mov	DWORD PTR -44[rbp], eax
	mov	rax, QWORD PTR 32[rbp]
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR -44[rbp], eax
	jle	.L5634
	mov	rax, QWORD PTR 32[rbp]
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 24[rbp]
	mov	rcx, rax
	call	_ZN5ArrayIjEixEi
	mov	QWORD PTR -56[rbp], rax
	mov	rax, QWORD PTR -56[rbp]
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE8SYMBOLATEj
	mov	QWORD PTR -64[rbp], rax
	mov	rax, QWORD PTR -64[rbp]
	mov	QWORD PTR -72[rbp], rax
	cmp	QWORD PTR -72[rbp], 0
	je	.L5635
	nop
.L5597:
	mov	rax, QWORD PTR -72[rbp]
	add	rax, 48
	movzx	eax, BYTE PTR [rax]
	movzx	eax, al
	mov	DWORD PTR -76[rbp], eax
	mov	eax, DWORD PTR -76[rbp]
	cmp	eax, DWORD PTR 40[rbp]
	jl	.L5636
	nop
.L5599:
	cmp	BYTE PTR -9[rbp], 0
	jne	.L5637
	cmp	DWORD PTR 40[rbp], 0
	setg	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -24[rbp], rax
	jmp	.L5602
.L5637:
	nop
.L5601:
	mov	QWORD PTR -24[rbp], 0
.L5602:
	cmp	QWORD PTR -24[rbp], 0
	je	.L5638
	mov	rax, QWORD PTR -72[rbp]
	add	rax, 49
	movzx	eax, BYTE PTR [rax]
	test	al, al
	setne	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -32[rbp], rax
	jmp	.L5605
.L5638:
	nop
.L5604:
	mov	QWORD PTR -32[rbp], 0
.L5605:
	cmp	QWORD PTR -32[rbp], 0
	je	.L5639
	mov	eax, DWORD PTR -76[rbp]
	movsx	rdx, eax
	mov	rax, QWORD PTR -72[rbp]
	add	rax, 49
	movzx	eax, BYTE PTR [rax]
	movzx	eax, al
	sub	rdx, rax
	mov	rax, rdx
	lea	rdx, 1[rax]
	mov	eax, DWORD PTR 40[rbp]
	cdqe
	cmp	rdx, rax
	jle	.L5640
	jmp	.L5610
.L5607:
.L5609:
.L5639:
	nop
.L5610:
	mov	DWORD PTR -36[rbp], 0
	mov	eax, DWORD PTR -76[rbp]
	cmp	eax, DWORD PTR 40[rbp]
	jle	.L5641
	mov	BYTE PTR -37[rbp], 0
	cmp	DWORD PTR 40[rbp], 15
	jg	.L5642
	mov	rax, QWORD PTR -72[rbp]
	add	rax, 50
	movzx	eax, WORD PTR [rax]
	mov	edx, DWORD PTR 40[rbp]
	and	edx, 63
	mov	r8d, 1
	mov	ecx, edx
	sal	r8, cl
	mov	rdx, r8
	and	eax, edx
	test	ax, ax
	setne	al
	mov	BYTE PTR -37[rbp], al
	jmp	.L5615
.L5614:
.L5642:
	nop
.L5615:
	movsx	edx, BYTE PTR -37[rbp]
	mov	eax, DWORD PTR 40[rbp]
	lea	r9d, 1[rax]
	mov	r8, QWORD PTR 32[rbp]
	mov	rax, QWORD PTR 24[rbp]
	mov	ecx, DWORD PTR 56[rbp]
	mov	DWORD PTR 40[rsp], ecx
	mov	DWORD PTR 32[rsp], edx
	mov	rdx, rax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN3TKO7RESOLVE11SLOTSGROUP_ERNS0_3CTXER5ArrayIjERiibi
	mov	DWORD PTR -80[rbp], eax
	mov	eax, DWORD PTR -80[rbp]
	mov	DWORD PTR -36[rbp], eax
	jmp	.L5616
.L5641:
	nop
.L5612:
	mov	eax, DWORD PTR 56[rbp]
	lea	edx, 1[rax]
	mov	rax, QWORD PTR -72[rbp]
	add	rax, 16
	mov	eax, DWORD PTR [rax]
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN3TKO7RESOLVE12SLOTSOFTYPE_ERNS0_3CTXEji
	mov	DWORD PTR -84[rbp], eax
	mov	eax, DWORD PTR -84[rbp]
	mov	DWORD PTR -36[rbp], eax
	mov	rax, QWORD PTR 32[rbp]
	mov	eax, DWORD PTR [rax]
	lea	edx, 1[rax]
	mov	rax, QWORD PTR 32[rbp]
	mov	DWORD PTR [rax], edx
.L5616:
	cmp	DWORD PTR -36[rbp], 0
	jns	.L5643
	mov	DWORD PTR -88[rbp], -1
	jmp	.L5619
.L5643:
	nop
.L5618:
	cmp	DWORD PTR -8[rbp], -2
	jne	.L5644
	mov	eax, DWORD PTR -36[rbp]
	mov	DWORD PTR -8[rbp], eax
	jmp	.L5621
.L5644:
	nop
.L5621:
	mov	eax, DWORD PTR -36[rbp]
	add	DWORD PTR -4[rbp], eax
	mov	BYTE PTR -9[rbp], 0
	jmp	.L5593
.L5634:
	nop
	jmp	.L5595
.L5635:
	nop
	jmp	.L5595
.L5636:
	nop
	jmp	.L5595
.L5640:
	nop
.L5595:
	cmp	BYTE PTR -100[rbp], 0
	je	.L5645
	cmp	DWORD PTR -8[rbp], -2
	jne	.L5646
	mov	DWORD PTR -88[rbp], -1
	jmp	.L5619
.L5646:
	nop
.L5625:
	mov	eax, DWORD PTR -8[rbp]
	mov	DWORD PTR -88[rbp], eax
	jmp	.L5619
.L5623:
.L5645:
	nop
.L5626:
	mov	eax, DWORD PTR -4[rbp]
	mov	DWORD PTR -88[rbp], eax
	nop
.L5619:
	mov	eax, DWORD PTR -88[rbp]
	add	rsp, 160
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN3TKO7RESOLVE11SLOTSOFUDT_ERNS0_3CTXEji;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN3TKO7RESOLVE11SLOTSOFUDT_ERNS0_3CTXEji
_ZN3TKO7RESOLVE11SLOTSOFUDT_ERNS0_3CTXEji:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 240
	.seh_stackalloc	240
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
	mov	DWORD PTR 32[rbp], r8d
	mov	DWORD PTR -84[rbp], 0
.L5648:
	mov	eax, DWORD PTR 24[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN3TKO7RESOLVE9UDTSYMOF_ERNS0_3CTXEj
	mov	DWORD PTR -16[rbp], eax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR -16[rbp]
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE8SYMBOLATEj
	mov	QWORD PTR -24[rbp], rax
	mov	rax, QWORD PTR -24[rbp]
	mov	QWORD PTR -32[rbp], rax
	cmp	QWORD PTR -32[rbp], 0
	jne	.L5680
	mov	DWORD PTR -84[rbp], -1
	jmp	.L5651
.L5680:
	nop
.L5650:
	mov	rax, QWORD PTR -32[rbp]
	add	rax, 36
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	jne	.L5681
	mov	DWORD PTR -84[rbp], -1
	jmp	.L5651
.L5681:
	nop
.L5653:
	mov	rax, QWORD PTR -32[rbp]
	add	rax, 36
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE7SCOPEATEj
	mov	QWORD PTR -40[rbp], rax
	mov	rax, QWORD PTR -40[rbp]
	mov	QWORD PTR -48[rbp], rax
	cmp	QWORD PTR -48[rbp], 0
	jne	.L5682
	mov	DWORD PTR -84[rbp], -1
	jmp	.L5651
.L5682:
	nop
.L5655:
	lea	rax, -176[rbp]
	mov	rcx, rax
	call	_ZN5ArrayIjEC1Ev
	mov	rax, QWORD PTR -48[rbp]
	mov	eax, DWORD PTR 12[rax]
	mov	DWORD PTR -180[rbp], eax
	mov	DWORD PTR -12[rbp], 0
.L5656:
	mov	eax, DWORD PTR -180[rbp]
	test	eax, eax
	je	.L5683
	cmp	DWORD PTR -12[rbp], 99999
	setle	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -8[rbp], rax
	jmp	.L5659
.L5683:
	nop
.L5658:
	mov	QWORD PTR -8[rbp], 0
.L5659:
	cmp	QWORD PTR -8[rbp], 0
	je	.L5684
	add	DWORD PTR -12[rbp], 1
	mov	edx, DWORD PTR -180[rbp]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE8SYMBOLATEj
	mov	QWORD PTR -56[rbp], rax
	mov	rax, QWORD PTR -56[rbp]
	mov	QWORD PTR -64[rbp], rax
	cmp	QWORD PTR -64[rbp], 0
	je	.L5685
	nop
.L5663:
	mov	rax, QWORD PTR -64[rbp]
	movzx	eax, BYTE PTR [rax]
	cmp	al, 4
	jne	.L5686
	mov	rax, QWORD PTR -64[rbp]
	add	rax, 4
	mov	eax, DWORD PTR [rax]
	mov	eax, eax
	and	eax, 16384
	test	rax, rax
	je	.L5687
	mov	DWORD PTR -84[rbp], -1
	lea	rax, -176[rbp]
	mov	rcx, rax
	call	_ZN5ArrayIjED1Ev
	jmp	.L5651
.L5687:
	nop
.L5667:
	mov	rax, QWORD PTR -64[rbp]
	add	rax, 4
	mov	eax, DWORD PTR [rax]
	mov	eax, eax
	and	eax, 3
	test	rax, rax
	setne	al
	mov	BYTE PTR -65[rbp], al
	cmp	BYTE PTR -65[rbp], 0
	jne	.L5688
	lea	rdx, -180[rbp]
	lea	rax, -176[rbp]
	mov	rcx, rax
	call	_ZN5ArrayIjE4PUSHERj
	jmp	.L5670
.L5665:
.L5669:
.L5686:
	nop
	jmp	.L5670
.L5688:
	nop
.L5670:
	mov	rax, QWORD PTR -64[rbp]
	mov	eax, DWORD PTR 32[rax]
	mov	DWORD PTR -180[rbp], eax
	jmp	.L5656
.L5684:
	nop
	jmp	.L5661
.L5685:
	nop
.L5661:
	lea	rax, -176[rbp]
	mov	rcx, rax
	call	_ZN5ArrayIjE5COUNTEv
	mov	DWORD PTR -72[rbp], eax
	cmp	DWORD PTR -72[rbp], 0
	jne	.L5689
	mov	DWORD PTR -84[rbp], -1
	lea	rax, -176[rbp]
	mov	rcx, rax
	call	_ZN5ArrayIjED1Ev
	jmp	.L5651
.L5689:
	nop
.L5672:
	mov	DWORD PTR -184[rbp], 0
	mov	rax, QWORD PTR -32[rbp]
	add	rax, 4
	mov	eax, DWORD PTR [rax]
	mov	eax, eax
	and	eax, 8192
	test	rax, rax
	setne	al
	mov	BYTE PTR -73[rbp], al
	movsx	edx, BYTE PTR -73[rbp]
	lea	r8, -184[rbp]
	lea	rax, -176[rbp]
	mov	ecx, DWORD PTR 32[rbp]
	mov	DWORD PTR 40[rsp], ecx
	mov	DWORD PTR 32[rsp], edx
	mov	r9d, 0
	mov	rdx, rax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN3TKO7RESOLVE11SLOTSGROUP_ERNS0_3CTXER5ArrayIjERiibi
	mov	DWORD PTR -80[rbp], eax
	mov	eax, DWORD PTR -80[rbp]
	mov	DWORD PTR -84[rbp], eax
	lea	rax, -176[rbp]
	mov	rcx, rax
	call	_ZN5ArrayIjED1Ev
	nop
.L5651:
	mov	eax, DWORD PTR -84[rbp]
	add	rsp, 240
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN3TKO7RESOLVE12INITTOOMANY_ERNS0_3CTXEjjjj;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN3TKO7RESOLVE12INITTOOMANY_ERNS0_3CTXEjjjj
_ZN3TKO7RESOLVE12INITTOOMANY_ERNS0_3CTXEjjjj:
	push	rbp
	.seh_pushreg	rbp
	sub	rsp, 256
	.seh_stackalloc	256
	lea	rbp, 128[rsp]
	.seh_setframe	rbp, 128
	.seh_endprologue
	mov	QWORD PTR 144[rbp], rcx
	mov	DWORD PTR 152[rbp], edx
	mov	DWORD PTR 160[rbp], r8d
	mov	DWORD PTR 168[rbp], r9d
.L5691:
	cmp	DWORD PTR 160[rbp], 0
	je	.L5710
	nop
.L5693:
	mov	rax, QWORD PTR 144[rbp]
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 160[rbp]
	mov	rcx, rax
	call	_ZN3TKO8ASTARENA4KINDEj
	mov	QWORD PTR 104[rbp], rax
	mov	rax, QWORD PTR 104[rbp]
	mov	QWORD PTR 96[rbp], rax
	cmp	QWORD PTR 96[rbp], 20
	je	.L5711
	cmp	QWORD PTR 96[rbp], 19
	sete	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR 120[rbp], rax
	jmp	.L5697
.L5711:
	nop
.L5696:
	mov	QWORD PTR 120[rbp], -1
.L5697:
	cmp	QWORD PTR 120[rbp], 0
	setne	al
	mov	BYTE PTR 95[rbp], al
	cmp	BYTE PTR 95[rbp], 0
	je	.L5712
	nop
.L5699:
	mov	edx, DWORD PTR 160[rbp]
	mov	rax, QWORD PTR 144[rbp]
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN5ArrayIN3TKO7ASTNODEEEixEi
	mov	QWORD PTR 80[rbp], rax
	mov	rax, QWORD PTR 80[rbp]
	add	rax, 8
	mov	eax, DWORD PTR [rax]
	mov	rdx, QWORD PTR 144[rbp]
	mov	rdx, QWORD PTR [rdx]
	lea	rcx, 400[rdx]
	mov	edx, eax
	call	_ZN5ArrayIN3TKO11LISTPAYLOADEEixEi
	mov	QWORD PTR 72[rbp], rax
	mov	rax, QWORD PTR 72[rbp]
	mov	QWORD PTR 64[rbp], rax
	mov	eax, DWORD PTR 152[rbp]
	mov	DWORD PTR 116[rbp], eax
	mov	rax, QWORD PTR 64[rbp]
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	je	.L5713
	mov	rax, QWORD PTR 64[rbp]
	mov	eax, DWORD PTR [rax]
	mov	edx, DWORD PTR 176[rbp]
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 144[rbp]
	call	_ZN3TKO7RESOLVE14RESOLVETYPEREFERNS0_3CTXEjj
	mov	DWORD PTR 60[rbp], eax
	mov	eax, DWORD PTR 60[rbp]
	mov	DWORD PTR 56[rbp], eax
	cmp	DWORD PTR 56[rbp], 0
	je	.L5714
	nop
.L5703:
	mov	eax, DWORD PTR 56[rbp]
	mov	DWORD PTR 116[rbp], eax
	jmp	.L5704
.L5701:
.L5713:
	nop
.L5704:
	mov	eax, DWORD PTR 116[rbp]
	mov	r8d, 0
	mov	edx, eax
	mov	rcx, QWORD PTR 144[rbp]
	call	_ZN3TKO7RESOLVE12SLOTSOFTYPE_ERNS0_3CTXEji
	mov	DWORD PTR 52[rbp], eax
	mov	eax, DWORD PTR 52[rbp]
	mov	DWORD PTR 48[rbp], eax
	cmp	DWORD PTR 48[rbp], 0
	js	.L5715
	nop
.L5706:
	mov	rax, QWORD PTR 64[rbp]
	add	rax, 8
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR 48[rbp], eax
	jge	.L5716
	nop
.L5708:
	lea	rax, -64[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	lea	rax, -64[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9d, 1
	lea	r8, .LC4[rip]
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
	lea	r8, .LC4[rip]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrAssign
	mov	rax, rbp
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	rax, QWORD PTR 144[rbp]
	add	rax, 24
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 168[rbp]
	mov	rcx, rax
	call	_ZN3TKO8INTERNER8SPELLINGEj
	mov	QWORD PTR 40[rbp], rax
	mov	rdx, QWORD PTR 40[rbp]
	mov	rax, rbp
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrAssign
	mov	rax, QWORD PTR 144[rbp]
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 160[rbp]
	mov	rcx, rax
	call	_ZN3TKO8ASTARENA3LOCEj
	mov	DWORD PTR 36[rbp], eax
	mov	eax, DWORD PTR 36[rbp]
	mov	ecx, eax
	call	_ZN3TKO10POINTRANGEEj
	mov	QWORD PTR -72[rbp], rax
	mov	rax, QWORD PTR 144[rbp]
	add	rax, 40
	mov	rax, QWORD PTR [rax]
	mov	r8, rbp
	mov	rcx, QWORD PTR -72[rbp]
	lea	rdx, -64[rbp]
	mov	QWORD PTR 40[rsp], rdx
	lea	rdx, -32[rbp]
	mov	QWORD PTR 32[rsp], rdx
	mov	r9, r8
	mov	r8, rcx
	mov	edx, 92
	mov	rcx, rax
	call	_ZN3TKO16DIAGNOSTICENGINE6REPORTENS_6DIAGIDENS_11SOURCERANGEE8FBSTRINGS3_S3_
	lea	rax, -64[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	lea	rax, -32[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	mov	rax, rbp
	mov	rcx, rax
	call	fb_StrDelete
	jmp	.L5717
.L5710:
	nop
	jmp	.L5717
.L5712:
	nop
	jmp	.L5717
.L5714:
	nop
	jmp	.L5717
.L5715:
	nop
	jmp	.L5717
.L5716:
	nop
.L5694:
.L5717:
	nop
	add	rsp, 256
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN3TKO7RESOLVE12SELCONSTVAL_ERNS0_3CTXEjjRx;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN3TKO7RESOLVE12SELCONSTVAL_ERNS0_3CTXEjjRx
_ZN3TKO7RESOLVE12SELCONSTVAL_ERNS0_3CTXEjjRx:
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
	mov	QWORD PTR 40[rbp], r9
	mov	BYTE PTR -1[rbp], 0
.L5719:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	r8, QWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 24
	mov	rcx, QWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 32
	mov	r11, QWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	mov	rdx, QWORD PTR [rax]
	lea	rax, -64[rbp]
	mov	r10d, DWORD PTR 24[rbp]
	mov	QWORD PTR 80[rsp], 0
	mov	QWORD PTR 72[rsp], 0
	mov	DWORD PTR 64[rsp], 0
	mov	r9d, DWORD PTR 32[rbp]
	mov	DWORD PTR 56[rsp], r9d
	mov	QWORD PTR 48[rsp], r8
	mov	DWORD PTR 40[rsp], 64
	mov	QWORD PTR 32[rsp], rcx
	mov	r9, r11
	mov	r8d, r10d
	mov	rcx, rax
	call	_ZN3TKO5CHECK7CONSTOFERNS_8ASTARENAEjRNS_13SOURCEMANAGERERNS_8INTERNEREiPNS_11SYMBOLTABLEEjiPNS_11TYPECONTEXTEPNS_12SEMANTICINFOE
	mov	rax, QWORD PTR -64[rbp]
	mov	rdx, QWORD PTR -56[rbp]
	mov	QWORD PTR -32[rbp], rax
	mov	QWORD PTR -24[rbp], rdx
	mov	rax, QWORD PTR -48[rbp]
	mov	QWORD PTR -16[rbp], rax
	lea	rax, -32[rbp]
	movzx	eax, BYTE PTR [rax]
	test	al, al
	jne	.L5725
	mov	BYTE PTR -1[rbp], 0
	jmp	.L5722
.L5725:
	nop
.L5721:
	mov	rdx, QWORD PTR -24[rbp]
	mov	rax, QWORD PTR 40[rbp]
	mov	QWORD PTR [rax], rdx
	mov	BYTE PTR -1[rbp], 1
	nop
.L5722:
	movzx	eax, BYTE PTR -1[rbp]
	add	rsp, 160
	pop	rbp
	ret
	.seh_endproc
	.section .rdata,"dr"
.LC25:
	.ascii "lbound\0"
.LC26:
	.ascii "ubound\0"
	.text
	.def	_ZN3TKO7RESOLVE16CONSTBOUNDCHECK_ERNS0_3CTXEjj;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN3TKO7RESOLVE16CONSTBOUNDCHECK_ERNS0_3CTXEjj
_ZN3TKO7RESOLVE16CONSTBOUNDCHECK_ERNS0_3CTXEjj:
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
.L5727:
	mov	eax, DWORD PTR 216[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 208[rbp]
	call	_ZN3TKO7RESOLVE6STMTOFERNS0_3CTXEj
	mov	QWORD PTR 176[rbp], rax
	mov	rax, QWORD PTR 176[rbp]
	mov	QWORD PTR 168[rbp], rax
	cmp	QWORD PTR 168[rbp], 0
	je	.L5757
	nop
.L5729:
	mov	rax, QWORD PTR 168[rbp]
	add	rax, 8
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	je	.L5758
	nop
.L5732:
	mov	rax, QWORD PTR 168[rbp]
	add	rax, 8
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 208[rbp]
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN3TKO8ASTARENA4KINDEj
	mov	QWORD PTR 160[rbp], rax
	cmp	QWORD PTR 160[rbp], 9
	jne	.L5759
	nop
.L5734:
	mov	rax, QWORD PTR 168[rbp]
	add	rax, 8
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 208[rbp]
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN5ArrayIN3TKO7ASTNODEEEixEi
	mov	QWORD PTR 152[rbp], rax
	mov	rax, QWORD PTR 152[rbp]
	add	rax, 8
	mov	eax, DWORD PTR [rax]
	mov	rdx, QWORD PTR 208[rbp]
	mov	rdx, QWORD PTR [rdx]
	lea	rcx, 400[rdx]
	mov	edx, eax
	call	_ZN5ArrayIN3TKO11LISTPAYLOADEEixEi
	mov	QWORD PTR 144[rbp], rax
	mov	rax, QWORD PTR 144[rbp]
	mov	QWORD PTR 136[rbp], rax
	mov	rax, QWORD PTR 136[rbp]
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	je	.L5760
	nop
.L5736:
	mov	rax, QWORD PTR 136[rbp]
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 208[rbp]
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN3TKO8ASTARENA4KINDEj
	mov	QWORD PTR 128[rbp], rax
	cmp	QWORD PTR 128[rbp], 6
	jne	.L5761
	nop
.L5738:
	mov	rax, QWORD PTR 136[rbp]
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 208[rbp]
	add	rax, 48
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN3TKO12SEMANTICINFO5REFOFEj
	mov	DWORD PTR 124[rbp], eax
	cmp	DWORD PTR 124[rbp], 0
	jne	.L5762
	nop
.L5740:
	mov	rax, QWORD PTR 136[rbp]
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 208[rbp]
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN5ArrayIN3TKO7ASTNODEEEixEi
	mov	QWORD PTR 112[rbp], rax
	mov	rax, QWORD PTR 112[rbp]
	add	rax, 8
	mov	eax, DWORD PTR [rax]
	mov	rdx, QWORD PTR 208[rbp]
	mov	rdx, QWORD PTR [rdx]
	lea	rcx, 320[rdx]
	mov	edx, eax
	call	_ZN5ArrayIN3TKO12IDENTPAYLOADEEixEi
	mov	QWORD PTR 104[rbp], rax
	mov	rax, QWORD PTR 104[rbp]
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR 100[rbp], eax
	mov	rax, QWORD PTR 208[rbp]
	add	rax, 24
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 100[rbp]
	mov	rcx, rax
	call	_ZN3TKO8INTERNER8SPELLINGEj
	mov	QWORD PTR 88[rbp], rax
	mov	rdx, QWORD PTR 88[rbp]
	lea	rax, 32[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrInit
	lea	rax, 32[rbp]
	mov	r9d, 7
	lea	r8, .LC25[rip]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrCompare
	mov	DWORD PTR 84[rbp], eax
	cmp	DWORD PTR 84[rbp], 0
	je	.L5763
	lea	rax, 32[rbp]
	mov	r9d, 7
	lea	r8, .LC26[rip]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrCompare
	mov	DWORD PTR 80[rbp], eax
	cmp	DWORD PTR 80[rbp], 0
	setne	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR 184[rbp], rax
	jmp	.L5743
.L5763:
	nop
.L5742:
	mov	QWORD PTR 184[rbp], 0
.L5743:
	cmp	QWORD PTR 184[rbp], 0
	je	.L5764
	lea	rax, 32[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	jmp	.L5730
.L5764:
	nop
.L5745:
	mov	rax, QWORD PTR 136[rbp]
	add	rax, 8
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	jg	.L5765
	lea	rax, 32[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	jmp	.L5730
.L5765:
	nop
.L5747:
	mov	rax, QWORD PTR 136[rbp]
	add	rax, 8
	mov	eax, DWORD PTR [rax]
	cmp	eax, 1
	jle	.L5766
	mov	rax, QWORD PTR 136[rbp]
	add	rax, 4
	mov	eax, DWORD PTR [rax]
	lea	edx, 1[rax]
	mov	rax, QWORD PTR 208[rbp]
	mov	rax, QWORD PTR [rax]
	add	rax, 560
	mov	rcx, rax
	call	_ZN5ArrayIjEixEi
	mov	QWORD PTR 72[rbp], rax
	mov	rax, QWORD PTR 72[rbp]
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR 68[rbp], eax
	mov	QWORD PTR 24[rbp], 0
	lea	rcx, 24[rbp]
	mov	edx, DWORD PTR 224[rbp]
	mov	eax, DWORD PTR 68[rbp]
	mov	r9, rcx
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 208[rbp]
	call	_ZN3TKO7RESOLVE12SELCONSTVAL_ERNS0_3CTXEjjRx
	mov	BYTE PTR 67[rbp], al
	cmp	BYTE PTR 67[rbp], 0
	jne	.L5767
	lea	rax, -64[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	lea	rax, -64[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9d, 1
	lea	r8, .LC4[rip]
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
	lea	r8, .LC4[rip]
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
	lea	r8, .LC4[rip]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrAssign
	mov	rax, QWORD PTR 168[rbp]
	add	rax, 8
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 208[rbp]
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN3TKO8ASTARENA3LOCEj
	mov	DWORD PTR 60[rbp], eax
	mov	eax, DWORD PTR 60[rbp]
	mov	ecx, eax
	call	_ZN3TKO10POINTRANGEEj
	mov	QWORD PTR -72[rbp], rax
	mov	rax, QWORD PTR 208[rbp]
	add	rax, 40
	mov	rax, QWORD PTR [rax]
	mov	r8, rbp
	mov	rcx, QWORD PTR -72[rbp]
	lea	rdx, -64[rbp]
	mov	QWORD PTR 40[rsp], rdx
	lea	rdx, -32[rbp]
	mov	QWORD PTR 32[rsp], rdx
	mov	r9, r8
	mov	r8, rcx
	mov	edx, 148
	mov	rcx, rax
	call	_ZN3TKO16DIAGNOSTICENGINE6REPORTENS_6DIAGIDENS_11SOURCERANGEE8FBSTRINGS3_S3_
	lea	rax, -64[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	lea	rax, -32[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	mov	rax, rbp
	mov	rcx, rax
	call	fb_StrDelete
	lea	rax, 32[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	jmp	.L5768
.L5751:
.L5752:
.L5749:
.L5766:
	nop
	jmp	.L5753
.L5767:
	nop
.L5753:
	lea	rax, 32[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	jmp	.L5768
.L5757:
	nop
	jmp	.L5768
.L5758:
	nop
	jmp	.L5768
.L5759:
	nop
	jmp	.L5768
.L5760:
	nop
	jmp	.L5768
.L5761:
	nop
	jmp	.L5768
.L5762:
	nop
.L5730:
.L5768:
	nop
	add	rsp, 320
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN3TKO7RESOLVE15DIVBYCONSTZERO_ERNS0_3CTXEjj;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN3TKO7RESOLVE15DIVBYCONSTZERO_ERNS0_3CTXEjj
_ZN3TKO7RESOLVE15DIVBYCONSTZERO_ERNS0_3CTXEjj:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 192
	.seh_stackalloc	192
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
	mov	DWORD PTR 32[rbp], r8d
.L5770:
	mov	edx, DWORD PTR 24[rbp]
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN5ArrayIN3TKO7ASTNODEEEixEi
	mov	QWORD PTR -8[rbp], rax
	mov	rax, QWORD PTR -8[rbp]
	add	rax, 8
	mov	eax, DWORD PTR [rax]
	mov	rdx, QWORD PTR 16[rbp]
	mov	rdx, QWORD PTR [rdx]
	lea	rcx, 160[rdx]
	mov	edx, eax
	call	_ZN5ArrayIN3TKO13BINARYPAYLOADEEixEi
	mov	QWORD PTR -16[rbp], rax
	mov	rax, QWORD PTR -16[rbp]
	mov	QWORD PTR -24[rbp], rax
	mov	rax, QWORD PTR -24[rbp]
	movzx	eax, WORD PTR [rax]
	movzx	eax, ax
	mov	QWORD PTR -32[rbp], rax
	cmp	QWORD PTR -32[rbp], 34
	je	.L5785
	nop
.L5771:
	cmp	QWORD PTR -32[rbp], 193
	jne	.L5786
	jmp	.L5772
.L5785:
	nop
.L5772:
	nop
.L5776:
	mov	rax, QWORD PTR -24[rbp]
	add	rax, 8
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	je	.L5787
	jmp	.L5784
.L5774:
.L5786:
	nop
.L5773:
	jmp	.L5775
.L5784:
	nop
.L5778:
	mov	QWORD PTR -136[rbp], 0
	mov	rax, QWORD PTR -24[rbp]
	add	rax, 8
	mov	eax, DWORD PTR [rax]
	lea	rcx, -136[rbp]
	mov	edx, DWORD PTR 32[rbp]
	mov	r9, rcx
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN3TKO7RESOLVE12SELCONSTVAL_ERNS0_3CTXEjjRx
	mov	BYTE PTR -33[rbp], al
	cmp	BYTE PTR -33[rbp], 0
	je	.L5788
	nop
.L5780:
	mov	rax, QWORD PTR -136[rbp]
	test	rax, rax
	jne	.L5789
	nop
.L5782:
	lea	rax, -128[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	lea	rax, -128[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9d, 1
	lea	r8, .LC4[rip]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrAssign
	lea	rax, -96[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	lea	rax, -96[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9d, 1
	lea	r8, .LC4[rip]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrAssign
	lea	rax, -64[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	lea	rax, -64[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9d, 1
	lea	r8, .LC4[rip]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrAssign
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 24[rbp]
	mov	rcx, rax
	call	_ZN3TKO8ASTARENA3LOCEj
	mov	DWORD PTR -40[rbp], eax
	mov	eax, DWORD PTR -40[rbp]
	mov	ecx, eax
	call	_ZN3TKO10POINTRANGEEj
	mov	QWORD PTR -144[rbp], rax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 40
	mov	rax, QWORD PTR [rax]
	lea	r8, -64[rbp]
	mov	rcx, QWORD PTR -144[rbp]
	lea	rdx, -128[rbp]
	mov	QWORD PTR 40[rsp], rdx
	lea	rdx, -96[rbp]
	mov	QWORD PTR 32[rsp], rdx
	mov	r9, r8
	mov	r8, rcx
	mov	edx, 145
	mov	rcx, rax
	call	_ZN3TKO16DIAGNOSTICENGINE6REPORTENS_6DIAGIDENS_11SOURCERANGEE8FBSTRINGS3_S3_
	lea	rax, -128[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	lea	rax, -96[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	lea	rax, -64[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	jmp	.L5790
.L5787:
	nop
	jmp	.L5790
.L5788:
	nop
	jmp	.L5790
.L5789:
	nop
.L5775:
.L5790:
	nop
	add	rsp, 192
	pop	rbp
	ret
	.seh_endproc
	.section .rdata,"dr"
.LC27:
	.ascii "8192\0"
	.text
	.def	_ZN3TKO7RESOLVE17SELECTCONSTCHECK_ERNS0_3CTXEjj;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN3TKO7RESOLVE17SELECTCONSTCHECK_ERNS0_3CTXEjj
_ZN3TKO7RESOLVE17SELECTCONSTCHECK_ERNS0_3CTXEjj:
	push	rbp
	.seh_pushreg	rbp
	sub	rsp, 752
	.seh_stackalloc	752
	lea	rbp, 128[rsp]
	.seh_setframe	rbp, 128
	.seh_endprologue
	mov	QWORD PTR 640[rbp], rcx
	mov	DWORD PTR 648[rbp], edx
	mov	DWORD PTR 656[rbp], r8d
.L5792:
	mov	eax, DWORD PTR 648[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 640[rbp]
	call	_ZN3TKO7RESOLVE6STMTOFERNS0_3CTXEj
	mov	QWORD PTR 584[rbp], rax
	mov	rax, QWORD PTR 584[rbp]
	mov	QWORD PTR 576[rbp], rax
	cmp	QWORD PTR 576[rbp], 0
	je	.L5852
	nop
.L5794:
	mov	rax, QWORD PTR 576[rbp]
	add	rax, 24
	movzx	eax, WORD PTR [rax]
	cmp	ax, 87
	jne	.L5853
	nop
.L5797:
	mov	rax, QWORD PTR 576[rbp]
	add	rax, 8
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	je	.L5854
	nop
.L5799:
	mov	rax, QWORD PTR 576[rbp]
	add	rax, 8
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 640[rbp]
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN5ArrayIN3TKO7ASTNODEEEixEi
	mov	QWORD PTR 568[rbp], rax
	mov	rax, QWORD PTR 568[rbp]
	add	rax, 8
	mov	eax, DWORD PTR [rax]
	mov	rdx, QWORD PTR 640[rbp]
	mov	rdx, QWORD PTR [rdx]
	lea	rcx, 400[rdx]
	mov	edx, eax
	call	_ZN5ArrayIN3TKO11LISTPAYLOADEEixEi
	mov	QWORD PTR 560[rbp], rax
	mov	rax, QWORD PTR 560[rbp]
	mov	QWORD PTR 552[rbp], rax
	mov	BYTE PTR 623[rbp], 0
	mov	QWORD PTR 608[rbp], 0
	mov	QWORD PTR 600[rbp], 0
	mov	DWORD PTR 596[rbp], 0
	mov	rax, QWORD PTR 552[rbp]
	add	rax, 8
	mov	eax, DWORD PTR [rax]
	sub	eax, 1
	mov	DWORD PTR 548[rbp], eax
	jmp	.L5800
.L5870:
	nop
.L5801:
	mov	rax, QWORD PTR 552[rbp]
	add	rax, 4
	mov	edx, DWORD PTR [rax]
	mov	eax, DWORD PTR 596[rbp]
	add	edx, eax
	mov	rax, QWORD PTR 640[rbp]
	mov	rax, QWORD PTR [rax]
	add	rax, 560
	mov	rcx, rax
	call	_ZN5ArrayIjEixEi
	mov	QWORD PTR 536[rbp], rax
	mov	rax, QWORD PTR 536[rbp]
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR 532[rbp], eax
	mov	rax, QWORD PTR 640[rbp]
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 532[rbp]
	mov	rcx, rax
	call	_ZN3TKO8ASTARENA4KINDEj
	mov	QWORD PTR 520[rbp], rax
	cmp	QWORD PTR 520[rbp], 34
	jne	.L5855
	nop
.L5803:
	mov	eax, DWORD PTR 532[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 640[rbp]
	call	_ZN3TKO7RESOLVE6STMTOFERNS0_3CTXEj
	mov	QWORD PTR 512[rbp], rax
	mov	rax, QWORD PTR 512[rbp]
	mov	QWORD PTR 504[rbp], rax
	cmp	QWORD PTR 504[rbp], 0
	je	.L5856
	nop
.L5806:
	mov	DWORD PTR 592[rbp], 0
	mov	rax, QWORD PTR 504[rbp]
	add	rax, 20
	mov	eax, DWORD PTR [rax]
	sub	eax, 1
	mov	DWORD PTR 500[rbp], eax
	jmp	.L5807
.L5869:
	nop
.L5808:
	mov	rax, QWORD PTR 504[rbp]
	add	rax, 16
	mov	edx, DWORD PTR [rax]
	mov	eax, DWORD PTR 592[rbp]
	add	edx, eax
	mov	rax, QWORD PTR 640[rbp]
	mov	rax, QWORD PTR [rax]
	add	rax, 560
	mov	rcx, rax
	call	_ZN5ArrayIjEixEi
	mov	QWORD PTR 488[rbp], rax
	mov	rax, QWORD PTR 488[rbp]
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR 484[rbp], eax
	cmp	DWORD PTR 484[rbp], 0
	je	.L5857
	nop
.L5810:
	mov	QWORD PTR 416[rbp], 0
	mov	QWORD PTR 408[rbp], 0
	mov	eax, DWORD PTR 484[rbp]
	mov	DWORD PTR 480[rbp], eax
	mov	rax, QWORD PTR 640[rbp]
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 484[rbp]
	mov	rcx, rax
	call	_ZN3TKO8ASTARENA4KINDEj
	mov	QWORD PTR 472[rbp], rax
	cmp	QWORD PTR 472[rbp], 35
	jne	.L5858
	mov	eax, DWORD PTR 484[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 640[rbp]
	call	_ZN3TKO7RESOLVE6STMTOFERNS0_3CTXEj
	mov	QWORD PTR 464[rbp], rax
	mov	rax, QWORD PTR 464[rbp]
	mov	QWORD PTR 456[rbp], rax
	cmp	QWORD PTR 456[rbp], 0
	je	.L5859
	nop
.L5815:
	mov	rax, QWORD PTR 456[rbp]
	add	rax, 24
	movzx	eax, WORD PTR [rax]
	test	ax, ax
	jne	.L5860
	nop
.L5817:
	mov	rax, QWORD PTR 456[rbp]
	add	rax, 4
	mov	eax, DWORD PTR [rax]
	lea	rcx, 416[rbp]
	mov	edx, DWORD PTR 656[rbp]
	mov	r9, rcx
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 640[rbp]
	call	_ZN3TKO7RESOLVE12SELCONSTVAL_ERNS0_3CTXEjjRx
	mov	BYTE PTR 455[rbp], al
	cmp	BYTE PTR 455[rbp], 0
	jne	.L5861
	lea	rax, 320[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	lea	rax, 320[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9d, 1
	lea	r8, .LC4[rip]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrAssign
	lea	rax, 352[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	lea	rax, 352[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9d, 1
	lea	r8, .LC4[rip]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrAssign
	lea	rax, 384[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	lea	rax, 384[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9d, 1
	lea	r8, .LC4[rip]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrAssign
	mov	rax, QWORD PTR 456[rbp]
	add	rax, 4
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 640[rbp]
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN3TKO8ASTARENA3LOCEj
	mov	DWORD PTR 448[rbp], eax
	mov	eax, DWORD PTR 448[rbp]
	mov	ecx, eax
	call	_ZN3TKO10POINTRANGEEj
	mov	QWORD PTR 312[rbp], rax
	mov	rax, QWORD PTR 640[rbp]
	add	rax, 40
	mov	rax, QWORD PTR [rax]
	lea	r8, 384[rbp]
	mov	rcx, QWORD PTR 312[rbp]
	lea	rdx, 320[rbp]
	mov	QWORD PTR 40[rsp], rdx
	lea	rdx, 352[rbp]
	mov	QWORD PTR 32[rsp], rdx
	mov	r9, r8
	mov	r8, rcx
	mov	edx, 88
	mov	rcx, rax
	call	_ZN3TKO16DIAGNOSTICENGINE6REPORTENS_6DIAGIDENS_11SOURCERANGEE8FBSTRINGS3_S3_
	lea	rax, 320[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	lea	rax, 352[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	lea	rax, 384[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	jmp	.L5841
.L5819:
.L5861:
	nop
.L5820:
	mov	rax, QWORD PTR 456[rbp]
	add	rax, 8
	mov	eax, DWORD PTR [rax]
	lea	rcx, 408[rbp]
	mov	edx, DWORD PTR 656[rbp]
	mov	r9, rcx
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 640[rbp]
	call	_ZN3TKO7RESOLVE12SELCONSTVAL_ERNS0_3CTXEjjRx
	mov	BYTE PTR 447[rbp], al
	cmp	BYTE PTR 447[rbp], 0
	jne	.L5862
	lea	rax, 224[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	lea	rax, 224[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9d, 1
	lea	r8, .LC4[rip]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrAssign
	lea	rax, 256[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	lea	rax, 256[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9d, 1
	lea	r8, .LC4[rip]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrAssign
	lea	rax, 288[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	lea	rax, 288[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9d, 1
	lea	r8, .LC4[rip]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrAssign
	mov	rax, QWORD PTR 456[rbp]
	add	rax, 8
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 640[rbp]
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN3TKO8ASTARENA3LOCEj
	mov	DWORD PTR 440[rbp], eax
	mov	eax, DWORD PTR 440[rbp]
	mov	ecx, eax
	call	_ZN3TKO10POINTRANGEEj
	mov	QWORD PTR 216[rbp], rax
	mov	rax, QWORD PTR 640[rbp]
	add	rax, 40
	mov	rax, QWORD PTR [rax]
	lea	r8, 288[rbp]
	mov	rcx, QWORD PTR 216[rbp]
	lea	rdx, 224[rbp]
	mov	QWORD PTR 40[rsp], rdx
	lea	rdx, 256[rbp]
	mov	QWORD PTR 32[rsp], rdx
	mov	r9, r8
	mov	r8, rcx
	mov	edx, 88
	mov	rcx, rax
	call	_ZN3TKO16DIAGNOSTICENGINE6REPORTENS_6DIAGIDENS_11SOURCERANGEE8FBSTRINGS3_S3_
	lea	rax, 224[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	lea	rax, 256[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	lea	rax, 288[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	jmp	.L5841
.L5822:
.L5862:
	nop
.L5823:
	mov	rdx, QWORD PTR 416[rbp]
	mov	rax, QWORD PTR 408[rbp]
	cmp	rdx, rax
	jle	.L5863
	lea	rax, 128[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	lea	rax, 128[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9d, 1
	lea	r8, .LC4[rip]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrAssign
	lea	rax, 160[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	lea	rax, 160[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9d, 1
	lea	r8, .LC4[rip]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrAssign
	lea	rax, 192[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	lea	rax, 192[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9d, 1
	lea	r8, .LC4[rip]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrAssign
	mov	rax, QWORD PTR 640[rbp]
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 484[rbp]
	mov	rcx, rax
	call	_ZN3TKO8ASTARENA3LOCEj
	mov	DWORD PTR 436[rbp], eax
	mov	eax, DWORD PTR 436[rbp]
	mov	ecx, eax
	call	_ZN3TKO10POINTRANGEEj
	mov	QWORD PTR 120[rbp], rax
	mov	rax, QWORD PTR 640[rbp]
	add	rax, 40
	mov	rax, QWORD PTR [rax]
	lea	r8, 192[rbp]
	mov	rcx, QWORD PTR 120[rbp]
	lea	rdx, 128[rbp]
	mov	QWORD PTR 40[rsp], rdx
	lea	rdx, 160[rbp]
	mov	QWORD PTR 32[rsp], rdx
	mov	r9, r8
	mov	r8, rcx
	mov	edx, 89
	mov	rcx, rax
	call	_ZN3TKO16DIAGNOSTICENGINE6REPORTENS_6DIAGIDENS_11SOURCERANGEE8FBSTRINGS3_S3_
	lea	rax, 128[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	lea	rax, 160[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	lea	rax, 192[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	jmp	.L5841
.L5825:
.L5863:
	nop
.L5826:
	jmp	.L5827
.L5858:
	nop
.L5813:
	lea	rcx, 416[rbp]
	mov	edx, DWORD PTR 656[rbp]
	mov	eax, DWORD PTR 484[rbp]
	mov	r9, rcx
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 640[rbp]
	call	_ZN3TKO7RESOLVE12SELCONSTVAL_ERNS0_3CTXEjjRx
	mov	BYTE PTR 435[rbp], al
	cmp	BYTE PTR 435[rbp], 0
	jne	.L5864
	lea	rax, 32[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	lea	rax, 32[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9d, 1
	lea	r8, .LC4[rip]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrAssign
	lea	rax, 64[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	lea	rax, 64[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9d, 1
	lea	r8, .LC4[rip]
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
	lea	r8, .LC4[rip]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrAssign
	mov	rax, QWORD PTR 640[rbp]
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 484[rbp]
	mov	rcx, rax
	call	_ZN3TKO8ASTARENA3LOCEj
	mov	DWORD PTR 428[rbp], eax
	mov	eax, DWORD PTR 428[rbp]
	mov	ecx, eax
	call	_ZN3TKO10POINTRANGEEj
	mov	QWORD PTR 24[rbp], rax
	mov	rax, QWORD PTR 640[rbp]
	add	rax, 40
	mov	rax, QWORD PTR [rax]
	lea	r8, 96[rbp]
	mov	rcx, QWORD PTR 24[rbp]
	lea	rdx, 32[rbp]
	mov	QWORD PTR 40[rsp], rdx
	lea	rdx, 64[rbp]
	mov	QWORD PTR 32[rsp], rdx
	mov	r9, r8
	mov	r8, rcx
	mov	edx, 88
	mov	rcx, rax
	call	_ZN3TKO16DIAGNOSTICENGINE6REPORTENS_6DIAGIDENS_11SOURCERANGEE8FBSTRINGS3_S3_
	lea	rax, 32[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	lea	rax, 64[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	lea	rax, 96[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	jmp	.L5841
.L5829:
.L5864:
	nop
.L5830:
	mov	rax, QWORD PTR 416[rbp]
	mov	QWORD PTR 408[rbp], rax
.L5827:
	cmp	BYTE PTR 623[rbp], 0
	jne	.L5865
	mov	BYTE PTR 623[rbp], 1
	mov	rax, QWORD PTR 416[rbp]
	mov	QWORD PTR 608[rbp], rax
	mov	rax, QWORD PTR 408[rbp]
	mov	QWORD PTR 600[rbp], rax
	jmp	.L5837
.L5865:
	nop
.L5832:
	mov	rax, QWORD PTR 416[rbp]
	cmp	QWORD PTR 608[rbp], rax
	jle	.L5866
	mov	rax, QWORD PTR 416[rbp]
	mov	QWORD PTR 608[rbp], rax
	jmp	.L5835
.L5866:
	nop
.L5835:
	mov	rax, QWORD PTR 408[rbp]
	cmp	QWORD PTR 600[rbp], rax
	jge	.L5867
	mov	rax, QWORD PTR 408[rbp]
	mov	QWORD PTR 600[rbp], rax
	jmp	.L5837
.L5833:
.L5867:
	nop
.L5837:
	mov	rax, QWORD PTR 600[rbp]
	sub	rax, QWORD PTR 608[rbp]
	add	rax, 1
	cmp	rax, 8192
	jle	.L5868
	lea	rax, -64[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	lea	rax, -64[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9d, 1
	lea	r8, .LC4[rip]
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
	lea	r8, .LC4[rip]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrAssign
	mov	rax, rbp
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	rax, rbp
	mov	DWORD PTR 32[rsp], 0
	mov	r9d, 5
	lea	r8, .LC27[rip]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrAssign
	mov	rax, QWORD PTR 640[rbp]
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 480[rbp]
	mov	rcx, rax
	call	_ZN3TKO8ASTARENA3LOCEj
	mov	DWORD PTR 424[rbp], eax
	mov	eax, DWORD PTR 424[rbp]
	mov	ecx, eax
	call	_ZN3TKO10POINTRANGEEj
	mov	QWORD PTR -72[rbp], rax
	mov	rax, QWORD PTR 640[rbp]
	add	rax, 40
	mov	rax, QWORD PTR [rax]
	mov	r8, rbp
	mov	rcx, QWORD PTR -72[rbp]
	lea	rdx, -64[rbp]
	mov	QWORD PTR 40[rsp], rdx
	lea	rdx, -32[rbp]
	mov	QWORD PTR 32[rsp], rdx
	mov	r9, r8
	mov	r8, rcx
	mov	edx, 90
	mov	rcx, rax
	call	_ZN3TKO16DIAGNOSTICENGINE6REPORTENS_6DIAGIDENS_11SOURCERANGEE8FBSTRINGS3_S3_
	lea	rax, -64[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	lea	rax, -32[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	mov	rax, rbp
	mov	rcx, rax
	call	fb_StrDelete
	jmp	.L5871
.L5839:
.L5840:
.L5857:
	nop
	jmp	.L5841
.L5859:
	nop
	jmp	.L5841
.L5860:
	nop
	jmp	.L5841
.L5868:
	nop
.L5841:
	add	DWORD PTR 592[rbp], 1
.L5807:
	mov	eax, DWORD PTR 592[rbp]
	cmp	eax, DWORD PTR 500[rbp]
	jle	.L5869
	jmp	.L5842
.L5804:
.L5855:
	nop
	jmp	.L5842
.L5856:
	nop
.L5842:
	add	DWORD PTR 596[rbp], 1
.L5800:
	mov	eax, DWORD PTR 596[rbp]
	cmp	eax, DWORD PTR 548[rbp]
	jle	.L5870
	jmp	.L5843
.L5795:
.L5852:
	nop
	jmp	.L5871
.L5853:
	nop
	jmp	.L5871
.L5854:
	nop
.L5843:
.L5871:
	nop
	add	rsp, 752
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN3TKO7RESOLVE10UDTSYMOFT_ERNS0_3CTXEj;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN3TKO7RESOLVE10UDTSYMOFT_ERNS0_3CTXEj
_ZN3TKO7RESOLVE10UDTSYMOFT_ERNS0_3CTXEj:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 64
	.seh_stackalloc	64
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
	mov	DWORD PTR -32[rbp], 0
.L5873:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 24[rbp]
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT6NAMEOFEj
	mov	DWORD PTR -8[rbp], eax
	mov	eax, DWORD PTR -8[rbp]
	mov	DWORD PTR -12[rbp], eax
	cmp	DWORD PTR -12[rbp], 0
	jne	.L5881
	mov	DWORD PTR -32[rbp], 0
	jmp	.L5876
.L5881:
	nop
.L5875:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 24[rbp]
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT11DECLSCOPEOFEj
	mov	DWORD PTR -16[rbp], eax
	mov	eax, DWORD PTR -16[rbp]
	mov	DWORD PTR -20[rbp], eax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	ecx, DWORD PTR -12[rbp]
	mov	edx, DWORD PTR -20[rbp]
	mov	r9d, 1
	mov	r8d, ecx
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE16LOOKUPLOCALTYPEDEjjb
	mov	DWORD PTR -24[rbp], eax
	mov	eax, DWORD PTR -24[rbp]
	mov	DWORD PTR -4[rbp], eax
	cmp	DWORD PTR -4[rbp], 0
	jne	.L5882
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	ecx, DWORD PTR -12[rbp]
	mov	edx, DWORD PTR -20[rbp]
	mov	r9d, 1
	mov	r8d, ecx
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE11LOOKUPTYPEDEjjb
	mov	DWORD PTR -28[rbp], eax
	mov	eax, DWORD PTR -28[rbp]
	mov	DWORD PTR -4[rbp], eax
	jmp	.L5878
.L5882:
	nop
.L5878:
	mov	eax, DWORD PTR -4[rbp]
	mov	DWORD PTR -32[rbp], eax
	nop
.L5876:
	mov	eax, DWORD PTR -32[rbp]
	add	rsp, 64
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN3TKO7RESOLVE16TYPEBRINGSPROCS_ERNS0_3CTXEji;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN3TKO7RESOLVE16TYPEBRINGSPROCS_ERNS0_3CTXEji
_ZN3TKO7RESOLVE16TYPEBRINGSPROCS_ERNS0_3CTXEji:
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
	mov	BYTE PTR -38[rbp], 0
.L5884:
	cmp	DWORD PTR 24[rbp], 0
	jne	.L5900
	mov	BYTE PTR -38[rbp], 0
	jmp	.L5887
.L5900:
	nop
.L5886:
	cmp	DWORD PTR 32[rbp], 16
	jle	.L5901
	mov	BYTE PTR -38[rbp], 0
	jmp	.L5887
.L5901:
	nop
.L5889:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 24[rbp]
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT9UNQUALIFYEj
	mov	DWORD PTR -4[rbp], eax
	mov	eax, DWORD PTR -4[rbp]
	mov	DWORD PTR -8[rbp], eax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR -8[rbp]
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT4KINDEj
	mov	QWORD PTR -16[rbp], rax
	mov	rax, QWORD PTR -16[rbp]
	mov	QWORD PTR -24[rbp], rax
	cmp	QWORD PTR -24[rbp], 1
	jne	.L5902
	nop
.L5890:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR -8[rbp]
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT9BUILTINOFEj
	mov	QWORD PTR -32[rbp], rax
	cmp	QWORD PTR -32[rbp], 15
	sete	al
	mov	BYTE PTR -38[rbp], al
	jmp	.L5887
.L5902:
	nop
.L5891:
	cmp	QWORD PTR -24[rbp], 6
	jne	.L5903
	nop
.L5892:
	mov	eax, DWORD PTR -8[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN3TKO7RESOLVE10UDTSYMOFT_ERNS0_3CTXEj
	mov	DWORD PTR -36[rbp], eax
	mov	eax, DWORD PTR 32[rbp]
	lea	edx, 1[rax]
	mov	eax, DWORD PTR -36[rbp]
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN3TKO7RESOLVE12UDTHASPROCS_ERNS0_3CTXEji
	mov	BYTE PTR -37[rbp], al
	movzx	eax, BYTE PTR -37[rbp]
	mov	BYTE PTR -38[rbp], al
	jmp	.L5887
.L5893:
.L5903:
	nop
.L5894:
	mov	BYTE PTR -38[rbp], 0
	nop
.L5887:
	movzx	eax, BYTE PTR -38[rbp]
	add	rsp, 80
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN3TKO7RESOLVE14SCOPEISINPROC_ERNS0_3CTXEj;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN3TKO7RESOLVE14SCOPEISINPROC_ERNS0_3CTXEj
_ZN3TKO7RESOLVE14SCOPEISINPROC_ERNS0_3CTXEj:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 80
	.seh_stackalloc	80
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
	mov	BYTE PTR -33[rbp], 0
.L5905:
	mov	eax, DWORD PTR 24[rbp]
	mov	DWORD PTR -12[rbp], eax
	mov	DWORD PTR -16[rbp], 0
.L5906:
	cmp	DWORD PTR -12[rbp], 0
	je	.L5922
	cmp	DWORD PTR -16[rbp], 999
	setle	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -8[rbp], rax
	jmp	.L5909
.L5922:
	nop
.L5908:
	mov	QWORD PTR -8[rbp], 0
.L5909:
	cmp	QWORD PTR -8[rbp], 0
	je	.L5923
	add	DWORD PTR -16[rbp], 1
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR -12[rbp]
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE7SCOPEATEj
	mov	QWORD PTR -24[rbp], rax
	mov	rax, QWORD PTR -24[rbp]
	mov	QWORD PTR -32[rbp], rax
	cmp	QWORD PTR -32[rbp], 0
	jne	.L5924
	mov	BYTE PTR -33[rbp], 0
	jmp	.L5914
.L5924:
	nop
.L5913:
	mov	rax, QWORD PTR -32[rbp]
	movzx	eax, BYTE PTR [rax]
	cmp	al, 4
	jne	.L5925
	mov	BYTE PTR -33[rbp], 1
	jmp	.L5914
.L5925:
	nop
.L5916:
	mov	rax, QWORD PTR -32[rbp]
	mov	eax, DWORD PTR 4[rax]
	mov	DWORD PTR -12[rbp], eax
	jmp	.L5906
.L5923:
	nop
.L5911:
	mov	BYTE PTR -33[rbp], 0
	nop
.L5914:
	movzx	eax, BYTE PTR -33[rbp]
	add	rsp, 80
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN3TKO7RESOLVE21CHECKNOMETHODSINPROC_ERNS0_3CTXE;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN3TKO7RESOLVE21CHECKNOMETHODSINPROC_ERNS0_3CTXE
_ZN3TKO7RESOLVE21CHECKNOMETHODSINPROC_ERNS0_3CTXE:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 240
	.seh_stackalloc	240
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
.L5927:
	mov	DWORD PTR -4[rbp], 0
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN5ArrayIN3TKO6SYMBOLEE5COUNTEv
	mov	DWORD PTR -12[rbp], eax
	mov	eax, DWORD PTR -12[rbp]
	sub	eax, 1
	mov	DWORD PTR -16[rbp], eax
	jmp	.L5928
.L5953:
	nop
.L5929:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR -4[rbp]
	mov	rcx, rax
	call	_ZN5ArrayIN3TKO6SYMBOLEEixEi
	mov	QWORD PTR -24[rbp], rax
	mov	rax, QWORD PTR -24[rbp]
	mov	QWORD PTR -32[rbp], rax
	mov	rax, QWORD PTR -32[rbp]
	movzx	eax, BYTE PTR [rax]
	cmp	al, 6
	jne	.L5948
	nop
.L5931:
	mov	rax, QWORD PTR -32[rbp]
	add	rax, 12
	mov	eax, DWORD PTR [rax]
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN3TKO7RESOLVE14SCOPEISINPROC_ERNS0_3CTXEj
	mov	BYTE PTR -33[rbp], al
	cmp	BYTE PTR -33[rbp], 0
	je	.L5949
	nop
.L5934:
	mov	BYTE PTR -6[rbp], 0
	mov	rax, QWORD PTR -32[rbp]
	add	rax, 36
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	je	.L5950
	lea	rax, -192[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	lea	rax, -192[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9d, 5
	lea	r8, .LC6[rip]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrAssign
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 24
	mov	rax, QWORD PTR [rax]
	lea	rdx, -192[rbp]
	mov	rcx, rax
	call	_ZN3TKO8INTERNER9GETSTRINGE8FBSTRING
	mov	DWORD PTR -40[rbp], eax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 24
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR -40[rbp]
	mov	rcx, rax
	call	_ZN3TKO8INTERNER4FOLDEj
	mov	DWORD PTR -44[rbp], eax
	mov	rax, QWORD PTR -32[rbp]
	add	rax, 36
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	ecx, DWORD PTR -44[rbp]
	mov	r8d, ecx
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE11LOOKUPLOCALEjj
	mov	DWORD PTR -48[rbp], eax
	cmp	DWORD PTR -48[rbp], 0
	setne	al
	mov	BYTE PTR -6[rbp], al
	lea	rax, -192[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	jmp	.L5937
.L5936:
.L5950:
	nop
.L5937:
	cmp	BYTE PTR -6[rbp], 0
	jne	.L5951
	mov	eax, DWORD PTR -4[rbp]
	mov	r8d, 0
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN3TKO7RESOLVE12UDTHASPROCS_ERNS0_3CTXEji
	mov	BYTE PTR -49[rbp], al
	cmp	BYTE PTR -49[rbp], 0
	sete	al
	mov	BYTE PTR -5[rbp], al
	jmp	.L5940
.L5951:
	nop
.L5939:
	mov	BYTE PTR -5[rbp], 0
.L5940:
	cmp	BYTE PTR -5[rbp], 0
	jne	.L5952
	nop
.L5942:
	lea	rax, -160[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	lea	rax, -160[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9d, 1
	lea	r8, .LC4[rip]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrAssign
	lea	rax, -128[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	lea	rax, -128[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9d, 1
	lea	r8, .LC4[rip]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrAssign
	lea	rax, -96[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	rax, QWORD PTR -32[rbp]
	add	rax, 8
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 24
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN3TKO8INTERNER8SPELLINGEj
	mov	QWORD PTR -64[rbp], rax
	mov	rdx, QWORD PTR -64[rbp]
	lea	rax, -96[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrAssign
	mov	rax, QWORD PTR -32[rbp]
	add	rax, 20
	mov	eax, DWORD PTR [rax]
	mov	ecx, eax
	call	_ZN3TKO10POINTRANGEEj
	mov	QWORD PTR -168[rbp], rax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 40
	mov	rax, QWORD PTR [rax]
	lea	r8, -96[rbp]
	mov	rcx, QWORD PTR -168[rbp]
	lea	rdx, -160[rbp]
	mov	QWORD PTR 40[rsp], rdx
	lea	rdx, -128[rbp]
	mov	QWORD PTR 32[rsp], rdx
	mov	r9, r8
	mov	r8, rcx
	mov	edx, 93
	mov	rcx, rax
	call	_ZN3TKO16DIAGNOSTICENGINE6REPORTENS_6DIAGIDENS_11SOURCERANGEE8FBSTRINGS3_S3_
	lea	rax, -160[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	lea	rax, -128[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	lea	rax, -96[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	jmp	.L5943
.L5948:
	nop
	jmp	.L5943
.L5949:
	nop
	jmp	.L5943
.L5952:
	nop
.L5943:
	add	DWORD PTR -4[rbp], 1
.L5928:
	mov	eax, DWORD PTR -4[rbp]
	cmp	eax, DWORD PTR -16[rbp]
	jle	.L5953
.L5944:
	nop
.L5945:
	nop
	add	rsp, 240
	pop	rbp
	ret
	.seh_endproc
	.section .rdata,"dr"
.LC28:
	.ascii "this\0"
	.text
	.def	_ZN3TKO7RESOLVE8BINDTHISERNS0_3CTXEjj;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN3TKO7RESOLVE8BINDTHISERNS0_3CTXEjj
_ZN3TKO7RESOLVE8BINDTHISERNS0_3CTXEjj:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 192
	.seh_stackalloc	192
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
	mov	DWORD PTR 32[rbp], r8d
.L5955:
	lea	rax, -144[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	lea	rax, -144[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9d, 5
	lea	r8, .LC28[rip]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrAssign
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 24
	mov	rax, QWORD PTR [rax]
	lea	rdx, -144[rbp]
	mov	rcx, rax
	call	_ZN3TKO8INTERNER9GETSTRINGE8FBSTRING
	mov	DWORD PTR -16[rbp], eax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 24
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR -16[rbp]
	mov	rcx, rax
	call	_ZN3TKO8INTERNER4FOLDEj
	mov	DWORD PTR -20[rbp], eax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	ecx, DWORD PTR -20[rbp]
	mov	edx, DWORD PTR 24[rbp]
	mov	r8d, ecx
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE11LOOKUPLOCALEjj
	mov	DWORD PTR -24[rbp], eax
	mov	eax, DWORD PTR -24[rbp]
	mov	DWORD PTR -28[rbp], eax
	lea	rax, -144[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	cmp	DWORD PTR -28[rbp], 0
	je	.L5991
	nop
.L5957:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR -28[rbp]
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE8SYMBOLATEj
	mov	QWORD PTR -40[rbp], rax
	mov	rax, QWORD PTR -40[rbp]
	mov	QWORD PTR -48[rbp], rax
	cmp	QWORD PTR -48[rbp], 0
	je	.L5992
	nop
.L5960:
	mov	rax, QWORD PTR -48[rbp]
	add	rax, 16
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	jne	.L5993
	nop
.L5962:
	mov	eax, DWORD PTR 24[rbp]
	mov	DWORD PTR -12[rbp], eax
.L5963:
	cmp	DWORD PTR -12[rbp], 0
	je	.L5994
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR -12[rbp]
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE7SCOPEATEj
	mov	QWORD PTR -56[rbp], rax
	mov	rax, QWORD PTR -56[rbp]
	mov	QWORD PTR -64[rbp], rax
	cmp	QWORD PTR -64[rbp], 0
	je	.L5995
	nop
.L5967:
	mov	rax, QWORD PTR -64[rbp]
	movzx	eax, BYTE PTR [rax]
	cmp	al, 3
	jne	.L5996
	mov	rax, QWORD PTR -64[rbp]
	add	rax, 8
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE8SYMBOLATEj
	mov	QWORD PTR -72[rbp], rax
	mov	rax, QWORD PTR -72[rbp]
	mov	QWORD PTR -80[rbp], rax
	cmp	QWORD PTR -80[rbp], 0
	je	.L5997
	mov	rax, QWORD PTR -80[rbp]
	add	rax, 16
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	je	.L5998
	mov	rax, QWORD PTR -80[rbp]
	add	rax, 16
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT8POINTER_Ej
	mov	DWORD PTR -84[rbp], eax
	mov	rax, QWORD PTR -48[rbp]
	lea	rdx, 16[rax]
	mov	eax, DWORD PTR -84[rbp]
	mov	DWORD PTR [rdx], eax
	jmp	.L5965
.L5971:
.L5973:
.L5974:
.L5997:
	nop
	jmp	.L5965
.L5998:
	nop
.L5975:
	jmp	.L5965
.L5969:
.L5996:
	nop
.L5976:
	mov	rax, QWORD PTR -64[rbp]
	mov	eax, DWORD PTR 4[rax]
	mov	DWORD PTR -12[rbp], eax
	jmp	.L5963
.L5994:
	nop
	jmp	.L5965
.L5995:
	nop
.L5965:
	mov	rax, QWORD PTR -48[rbp]
	add	rax, 16
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	jne	.L5999
	cmp	DWORD PTR 32[rbp], 0
	setne	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR -8[rbp], rax
	jmp	.L5979
.L5999:
	nop
.L5978:
	mov	QWORD PTR -8[rbp], 0
.L5979:
	cmp	QWORD PTR -8[rbp], 0
	je	.L6000
	mov	edx, DWORD PTR 32[rbp]
	mov	eax, DWORD PTR 24[rbp]
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN3TKO7RESOLVE17LOOKUPDOTTEDTYPE_ERNS0_3CTXEjj
	mov	DWORD PTR -88[rbp], eax
	mov	eax, DWORD PTR -88[rbp]
	mov	DWORD PTR -92[rbp], eax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR -92[rbp]
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE8SYMBOLATEj
	mov	QWORD PTR -104[rbp], rax
	mov	rax, QWORD PTR -104[rbp]
	mov	QWORD PTR -112[rbp], rax
	cmp	QWORD PTR -112[rbp], 0
	je	.L6001
	mov	rax, QWORD PTR -112[rbp]
	add	rax, 16
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	je	.L6002
	mov	rax, QWORD PTR -112[rbp]
	add	rax, 16
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT8POINTER_Ej
	mov	DWORD PTR -116[rbp], eax
	mov	rax, QWORD PTR -48[rbp]
	lea	rdx, 16[rax]
	mov	eax, DWORD PTR -116[rbp]
	mov	DWORD PTR [rdx], eax
	jmp	.L6003
.L5958:
.L5983:
.L5984:
.L5985:
.L5986:
.L5987:
.L5991:
	nop
	jmp	.L6003
.L5992:
	nop
	jmp	.L6003
.L5993:
	nop
	jmp	.L6003
.L6000:
	nop
	jmp	.L6003
.L6001:
	nop
	jmp	.L6003
.L6002:
	nop
.L5988:
.L6003:
	nop
	add	rsp, 192
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN3TKO7RESOLVE16INHERITEDMEMBER_ERNS0_3CTXEjjRj;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN3TKO7RESOLVE16INHERITEDMEMBER_ERNS0_3CTXEjjRj
_ZN3TKO7RESOLVE16INHERITEDMEMBER_ERNS0_3CTXEjjRj:
	push	rbp
	.seh_pushreg	rbp
	sub	rsp, 336
	.seh_stackalloc	336
	lea	rbp, 128[rsp]
	.seh_setframe	rbp, 128
	.seh_endprologue
	mov	QWORD PTR 224[rbp], rcx
	mov	DWORD PTR 232[rbp], edx
	mov	DWORD PTR 240[rbp], r8d
	mov	QWORD PTR 248[rbp], r9
	mov	BYTE PTR -65[rbp], 0
.L6005:
	mov	rax, QWORD PTR 248[rbp]
	mov	DWORD PTR [rax], 0
	lea	rax, -32[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	lea	rax, -32[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9d, 5
	lea	r8, .LC6[rip]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrAssign
	mov	rax, QWORD PTR 224[rbp]
	add	rax, 24
	mov	rax, QWORD PTR [rax]
	lea	rdx, -32[rbp]
	mov	rcx, rax
	call	_ZN3TKO8INTERNER9GETSTRINGE8FBSTRING
	mov	DWORD PTR 188[rbp], eax
	mov	rax, QWORD PTR 224[rbp]
	add	rax, 24
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 188[rbp]
	mov	rcx, rax
	call	_ZN3TKO8INTERNER4FOLDEj
	mov	DWORD PTR 184[rbp], eax
	mov	eax, DWORD PTR 184[rbp]
	mov	DWORD PTR 180[rbp], eax
	lea	rax, -32[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	mov	eax, DWORD PTR 240[rbp]
	cmp	eax, DWORD PTR 180[rbp]
	jne	.L6071
	mov	BYTE PTR -65[rbp], 0
	jmp	.L6008
.L6071:
	nop
.L6007:
	lea	rax, -64[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	lea	rax, -64[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9d, 5
	lea	r8, .LC28[rip]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrAssign
	mov	rax, QWORD PTR 224[rbp]
	add	rax, 24
	mov	rax, QWORD PTR [rax]
	lea	rdx, -64[rbp]
	mov	rcx, rax
	call	_ZN3TKO8INTERNER9GETSTRINGE8FBSTRING
	mov	DWORD PTR 176[rbp], eax
	mov	rax, QWORD PTR 224[rbp]
	add	rax, 24
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 176[rbp]
	mov	rcx, rax
	call	_ZN3TKO8INTERNER4FOLDEj
	mov	DWORD PTR 172[rbp], eax
	mov	rax, QWORD PTR 224[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	ecx, DWORD PTR 172[rbp]
	mov	edx, DWORD PTR 232[rbp]
	mov	r9d, 0
	mov	r8d, ecx
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE11LOOKUPTYPEDEjjb
	mov	DWORD PTR 168[rbp], eax
	mov	eax, DWORD PTR 168[rbp]
	mov	DWORD PTR 164[rbp], eax
	lea	rax, -64[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	cmp	DWORD PTR 164[rbp], 0
	jne	.L6072
	mov	BYTE PTR -65[rbp], 0
	jmp	.L6008
.L6072:
	nop
.L6010:
	mov	rax, QWORD PTR 224[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 164[rbp]
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE8SYMBOLATEj
	mov	QWORD PTR 152[rbp], rax
	mov	rax, QWORD PTR 152[rbp]
	mov	QWORD PTR 144[rbp], rax
	cmp	QWORD PTR 144[rbp], 0
	jne	.L6073
	mov	BYTE PTR -65[rbp], 0
	jmp	.L6008
.L6073:
	nop
.L6012:
	mov	rax, QWORD PTR 144[rbp]
	add	rax, 16
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	jne	.L6074
	mov	BYTE PTR -65[rbp], 0
	jmp	.L6008
.L6074:
	nop
.L6014:
	mov	rax, QWORD PTR 144[rbp]
	add	rax, 16
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 224[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT4KINDEj
	mov	QWORD PTR 136[rbp], rax
	cmp	QWORD PTR 136[rbp], 2
	je	.L6075
	mov	BYTE PTR -65[rbp], 0
	jmp	.L6008
.L6075:
	nop
.L6016:
	mov	rax, QWORD PTR 144[rbp]
	add	rax, 16
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 224[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT5INNEREj
	mov	DWORD PTR 132[rbp], eax
	mov	rax, QWORD PTR 224[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 132[rbp]
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT9UNQUALIFYEj
	mov	DWORD PTR 128[rbp], eax
	mov	eax, DWORD PTR 128[rbp]
	mov	DWORD PTR 204[rbp], eax
	mov	DWORD PTR 200[rbp], 0
.L6017:
	cmp	DWORD PTR 204[rbp], 0
	jne	.L6076
	mov	BYTE PTR -65[rbp], 0
	jmp	.L6008
.L6076:
	nop
.L6019:
	mov	rax, QWORD PTR 224[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 204[rbp]
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT4KINDEj
	mov	QWORD PTR 120[rbp], rax
	cmp	QWORD PTR 120[rbp], 6
	je	.L6077
	mov	BYTE PTR -65[rbp], 0
	jmp	.L6008
.L6077:
	nop
.L6021:
	mov	rax, QWORD PTR 224[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 204[rbp]
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT6NAMEOFEj
	mov	DWORD PTR 116[rbp], eax
	mov	eax, DWORD PTR 116[rbp]
	mov	DWORD PTR 112[rbp], eax
	cmp	DWORD PTR 112[rbp], 0
	jne	.L6078
	mov	BYTE PTR -65[rbp], 0
	jmp	.L6008
.L6078:
	nop
.L6023:
	mov	rax, QWORD PTR 224[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 204[rbp]
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT11DECLSCOPEOFEj
	mov	DWORD PTR 108[rbp], eax
	mov	eax, DWORD PTR 108[rbp]
	mov	DWORD PTR 104[rbp], eax
	mov	rax, QWORD PTR 224[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	ecx, DWORD PTR 112[rbp]
	mov	edx, DWORD PTR 104[rbp]
	mov	r9d, 1
	mov	r8d, ecx
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE16LOOKUPLOCALTYPEDEjjb
	mov	DWORD PTR 100[rbp], eax
	mov	eax, DWORD PTR 100[rbp]
	mov	DWORD PTR 196[rbp], eax
	cmp	DWORD PTR 196[rbp], 0
	jne	.L6079
	mov	rax, QWORD PTR 224[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	ecx, DWORD PTR 112[rbp]
	mov	edx, DWORD PTR 104[rbp]
	mov	r9d, 1
	mov	r8d, ecx
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE11LOOKUPTYPEDEjjb
	mov	DWORD PTR 96[rbp], eax
	mov	eax, DWORD PTR 96[rbp]
	mov	DWORD PTR 196[rbp], eax
	jmp	.L6025
.L6079:
	nop
.L6025:
	mov	rax, QWORD PTR 224[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 196[rbp]
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE8SYMBOLATEj
	mov	QWORD PTR 88[rbp], rax
	mov	rax, QWORD PTR 88[rbp]
	mov	QWORD PTR 80[rbp], rax
	cmp	QWORD PTR 80[rbp], 0
	jne	.L6080
	mov	BYTE PTR -65[rbp], 0
	jmp	.L6008
.L6080:
	nop
.L6027:
	mov	rax, QWORD PTR 80[rbp]
	add	rax, 36
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	jne	.L6081
	mov	BYTE PTR -65[rbp], 0
	jmp	.L6008
.L6081:
	nop
.L6029:
	mov	rax, QWORD PTR 80[rbp]
	add	rax, 36
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 224[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	ecx, DWORD PTR 180[rbp]
	mov	r8d, ecx
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE11LOOKUPLOCALEjj
	mov	DWORD PTR 76[rbp], eax
	mov	eax, DWORD PTR 76[rbp]
	mov	DWORD PTR 72[rbp], eax
	cmp	DWORD PTR 72[rbp], 0
	jne	.L6082
	mov	BYTE PTR -65[rbp], 0
	jmp	.L6008
.L6082:
	nop
.L6031:
	mov	rax, QWORD PTR 224[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 72[rbp]
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE8SYMBOLATEj
	mov	QWORD PTR 64[rbp], rax
	mov	rax, QWORD PTR 64[rbp]
	mov	QWORD PTR 56[rbp], rax
	cmp	QWORD PTR 56[rbp], 0
	jne	.L6083
	mov	BYTE PTR -65[rbp], 0
	jmp	.L6008
.L6083:
	nop
.L6033:
	mov	rax, QWORD PTR 56[rbp]
	add	rax, 16
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	jne	.L6084
	mov	BYTE PTR -65[rbp], 0
	jmp	.L6008
.L6084:
	nop
.L6035:
	mov	rax, QWORD PTR 56[rbp]
	add	rax, 16
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 224[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT9UNQUALIFYEj
	mov	DWORD PTR 52[rbp], eax
	mov	eax, DWORD PTR 52[rbp]
	mov	DWORD PTR 48[rbp], eax
	mov	eax, DWORD PTR 48[rbp]
	cmp	eax, DWORD PTR 204[rbp]
	jne	.L6085
	mov	BYTE PTR -65[rbp], 0
	jmp	.L6008
.L6085:
	nop
.L6037:
	mov	eax, DWORD PTR 48[rbp]
	mov	DWORD PTR 204[rbp], eax
	mov	rax, QWORD PTR 224[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 204[rbp]
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT6NAMEOFEj
	mov	DWORD PTR 44[rbp], eax
	mov	eax, DWORD PTR 44[rbp]
	mov	DWORD PTR 40[rbp], eax
	cmp	DWORD PTR 40[rbp], 0
	jne	.L6086
	mov	BYTE PTR -65[rbp], 0
	jmp	.L6008
.L6086:
	nop
.L6039:
	mov	rax, QWORD PTR 224[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 204[rbp]
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT11DECLSCOPEOFEj
	mov	DWORD PTR 36[rbp], eax
	mov	eax, DWORD PTR 36[rbp]
	mov	DWORD PTR 32[rbp], eax
	mov	rax, QWORD PTR 224[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	ecx, DWORD PTR 40[rbp]
	mov	edx, DWORD PTR 32[rbp]
	mov	r9d, 1
	mov	r8d, ecx
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE16LOOKUPLOCALTYPEDEjjb
	mov	DWORD PTR 28[rbp], eax
	mov	eax, DWORD PTR 28[rbp]
	mov	DWORD PTR 192[rbp], eax
	cmp	DWORD PTR 192[rbp], 0
	jne	.L6087
	mov	rax, QWORD PTR 224[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	ecx, DWORD PTR 40[rbp]
	mov	edx, DWORD PTR 32[rbp]
	mov	r9d, 1
	mov	r8d, ecx
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE11LOOKUPTYPEDEjjb
	mov	DWORD PTR 24[rbp], eax
	mov	eax, DWORD PTR 24[rbp]
	mov	DWORD PTR 192[rbp], eax
	jmp	.L6041
.L6087:
	nop
.L6041:
	mov	rax, QWORD PTR 224[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 192[rbp]
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE8SYMBOLATEj
	mov	QWORD PTR 16[rbp], rax
	mov	rax, QWORD PTR 16[rbp]
	mov	QWORD PTR 8[rbp], rax
	cmp	QWORD PTR 8[rbp], 0
	jne	.L6088
	mov	BYTE PTR -65[rbp], 0
	jmp	.L6008
.L6088:
	nop
.L6043:
	mov	rax, QWORD PTR 8[rbp]
	add	rax, 36
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	jne	.L6089
	mov	BYTE PTR -65[rbp], 0
	jmp	.L6008
.L6089:
	nop
.L6045:
	mov	rax, QWORD PTR 8[rbp]
	add	rax, 36
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 224[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	ecx, DWORD PTR 240[rbp]
	mov	r8d, ecx
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE11LOOKUPLOCALEjj
	mov	DWORD PTR 4[rbp], eax
	mov	eax, DWORD PTR 4[rbp]
	mov	DWORD PTR 0[rbp], eax
	cmp	DWORD PTR 0[rbp], 0
	je	.L6090
	mov	rax, QWORD PTR 248[rbp]
	mov	edx, DWORD PTR 0[rbp]
	mov	DWORD PTR [rax], edx
	mov	BYTE PTR -65[rbp], 1
	jmp	.L6008
.L6047:
.L6048:
.L6090:
	nop
.L6049:
	add	DWORD PTR 200[rbp], 1
.L6050:
	cmp	DWORD PTR 200[rbp], 31
	jg	.L6091
	jmp	.L6017
.L6091:
	nop
.L6051:
	mov	BYTE PTR -65[rbp], 0
	nop
.L6008:
	movzx	eax, BYTE PTR -65[rbp]
	add	rsp, 336
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN3TKO7RESOLVE16GENERICCTORCALL_ERNS0_3CTXEjPNS_11LISTPAYLOADEj;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN3TKO7RESOLVE16GENERICCTORCALL_ERNS0_3CTXEjPNS_11LISTPAYLOADEj
_ZN3TKO7RESOLVE16GENERICCTORCALL_ERNS0_3CTXEjPNS_11LISTPAYLOADEj:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 144
	.seh_stackalloc	144
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
	mov	QWORD PTR 32[rbp], r8
	mov	DWORD PTR 40[rbp], r9d
	mov	BYTE PTR -41[rbp], 0
.L6093:
	mov	rax, QWORD PTR 32[rbp]
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	jne	.L6114
	mov	BYTE PTR -41[rbp], 0
	jmp	.L6096
.L6114:
	nop
.L6095:
	mov	DWORD PTR -48[rbp], 0
	mov	DWORD PTR -52[rbp], 0
	mov	rax, QWORD PTR 16[rbp]
	mov	rax, QWORD PTR [rax]
	lea	r8, -52[rbp]
	lea	rcx, -48[rbp]
	mov	edx, DWORD PTR 24[rbp]
	mov	r9, r8
	mov	r8, rcx
	mov	rcx, rax
	call	_ZN3TKO8ASTARENA14CALLTYPEARGSOFEjRiS1_
	mov	BYTE PTR -1[rbp], al
	cmp	BYTE PTR -1[rbp], 0
	jne	.L6115
	mov	BYTE PTR -41[rbp], 0
	jmp	.L6096
.L6115:
	nop
.L6098:
	mov	eax, DWORD PTR -52[rbp]
	test	eax, eax
	jg	.L6116
	mov	BYTE PTR -41[rbp], 0
	jmp	.L6096
.L6116:
	nop
.L6100:
	mov	rax, QWORD PTR 32[rbp]
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 48
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN3TKO12SEMANTICINFO5REFOFEj
	mov	DWORD PTR -8[rbp], eax
	mov	eax, DWORD PTR -8[rbp]
	mov	DWORD PTR -12[rbp], eax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR -12[rbp]
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE8SYMBOLATEj
	mov	QWORD PTR -24[rbp], rax
	mov	rax, QWORD PTR -24[rbp]
	mov	QWORD PTR -32[rbp], rax
	cmp	QWORD PTR -32[rbp], 0
	jne	.L6117
	mov	BYTE PTR -41[rbp], 0
	jmp	.L6096
.L6117:
	nop
.L6102:
	mov	rax, QWORD PTR -32[rbp]
	movzx	eax, BYTE PTR [rax]
	cmp	al, 6
	je	.L6118
	mov	BYTE PTR -41[rbp], 0
	jmp	.L6096
.L6118:
	nop
.L6104:
	lea	rax, -96[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	QWORD PTR 24[rax], 0
	mov	QWORD PTR 32[rax], 0
	mov	DWORD PTR 40[rax], 0
	lea	rax, -96[rbp]
	mov	rdx, QWORD PTR -32[rbp]
	mov	edx, DWORD PTR 8[rdx]
	mov	DWORD PTR [rax], edx
	lea	rax, -96[rbp]
	add	rax, 16
	mov	edx, DWORD PTR -48[rbp]
	mov	DWORD PTR [rax], edx
	lea	rax, -96[rbp]
	add	rax, 20
	mov	edx, DWORD PTR -52[rbp]
	mov	DWORD PTR [rax], edx
	mov	r8d, DWORD PTR 40[rbp]
	lea	rcx, -96[rbp]
	mov	eax, DWORD PTR 24[rbp]
	mov	edx, DWORD PTR -12[rbp]
	mov	DWORD PTR 32[rsp], edx
	mov	r9d, r8d
	mov	r8, rcx
	mov	edx, eax
	mov	rcx, QWORD PTR 16[rbp]
	call	_ZN3TKO7RESOLVE19INSTANTIATEGENERIC_ERNS0_3CTXEjPNS_11STMTPAYLOADEjj
	mov	DWORD PTR -36[rbp], eax
	mov	eax, DWORD PTR -36[rbp]
	mov	DWORD PTR -40[rbp], eax
	cmp	DWORD PTR -40[rbp], 0
	jne	.L6119
	mov	BYTE PTR -41[rbp], 0
	jmp	.L6096
.L6119:
	nop
.L6106:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 48
	mov	rax, QWORD PTR [rax]
	mov	ecx, DWORD PTR -40[rbp]
	mov	edx, DWORD PTR 24[rbp]
	mov	r8d, ecx
	mov	rcx, rax
	call	_ZN3TKO12SEMANTICINFO7SETTYPEEjj
	mov	rax, QWORD PTR 32[rbp]
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 48
	mov	rax, QWORD PTR [rax]
	mov	ecx, DWORD PTR -40[rbp]
	mov	r8d, ecx
	mov	rcx, rax
	call	_ZN3TKO12SEMANTICINFO7SETTYPEEjj
	mov	BYTE PTR -41[rbp], 1
	nop
.L6096:
	movzx	eax, BYTE PTR -41[rbp]
	add	rsp, 144
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN3TKO7RESOLVE13GPARAMTYPEOF_ERNS0_3CTXEj;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN3TKO7RESOLVE13GPARAMTYPEOF_ERNS0_3CTXEj
_ZN3TKO7RESOLVE13GPARAMTYPEOF_ERNS0_3CTXEj:
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
.L6121:
	cmp	DWORD PTR 24[rbp], 0
	jne	.L6136
	mov	DWORD PTR -28[rbp], 0
	jmp	.L6124
.L6136:
	nop
.L6123:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 792
	mov	rcx, rax
	call	_ZN5ArrayIjE5COUNTEv
	mov	DWORD PTR -8[rbp], eax
	mov	eax, DWORD PTR -8[rbp]
	sub	eax, 1
	mov	DWORD PTR -4[rbp], eax
	jmp	.L6125
.L6138:
	nop
.L6126:
	mov	rax, QWORD PTR 16[rbp]
	lea	rcx, 792[rax]
	mov	eax, DWORD PTR -4[rbp]
	mov	edx, eax
	call	_ZN5ArrayIjEixEi
	mov	QWORD PTR -16[rbp], rax
	mov	rax, QWORD PTR -16[rbp]
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR 24[rbp], eax
	jne	.L6137
	mov	rax, QWORD PTR 16[rbp]
	lea	rcx, 872[rax]
	mov	eax, DWORD PTR -4[rbp]
	mov	edx, eax
	call	_ZN5ArrayIjEixEi
	mov	QWORD PTR -24[rbp], rax
	mov	rax, QWORD PTR -24[rbp]
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR -28[rbp], eax
	jmp	.L6124
.L6128:
.L6129:
.L6137:
	nop
.L6130:
	sub	DWORD PTR -4[rbp], 1
.L6125:
	cmp	DWORD PTR -4[rbp], 0
	jns	.L6138
	nop
.L6131:
	mov	DWORD PTR -28[rbp], 0
	nop
.L6124:
	mov	eax, DWORD PTR -28[rbp]
	add	rsp, 64
	pop	rbp
	ret
	.seh_endproc
	.section .rdata,"dr"
.LC29:
	.ascii "__ARG_\0"
	.text
	.def	_ZN3TKO7RESOLVE16BUILDSPAWNFRAME_ERNS0_3CTXEjj;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN3TKO7RESOLVE16BUILDSPAWNFRAME_ERNS0_3CTXEjj
_ZN3TKO7RESOLVE16BUILDSPAWNFRAME_ERNS0_3CTXEjj:
	push	rbp
	.seh_pushreg	rbp
	sub	rsp, 576
	.seh_stackalloc	576
	lea	rbp, 128[rsp]
	.seh_setframe	rbp, 128
	.seh_endprologue
	mov	QWORD PTR 464[rbp], rcx
	mov	DWORD PTR 472[rbp], edx
	mov	DWORD PTR 480[rbp], r8d
.L6140:
	mov	eax, DWORD PTR 472[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 464[rbp]
	call	_ZN3TKO7RESOLVE6STMTOFERNS0_3CTXEj
	mov	QWORD PTR 408[rbp], rax
	mov	rax, QWORD PTR 408[rbp]
	mov	QWORD PTR 400[rbp], rax
	mov	rax, QWORD PTR 400[rbp]
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	je	.L6204
	nop
.L6142:
	mov	rax, QWORD PTR 400[rbp]
	add	rax, 32
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	je	.L6205
	nop
.L6145:
	mov	rax, QWORD PTR 400[rbp]
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 464[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	r9d, 1
	mov	r8d, edx
	mov	edx, 1
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE16LOOKUPLOCALTYPEDEjjb
	mov	DWORD PTR 396[rbp], eax
	cmp	DWORD PTR 396[rbp], 0
	jne	.L6206
	nop
.L6147:
.L6148:
	mov	DWORD PTR 444[rbp], 0
	mov	DWORD PTR 440[rbp], 0
	mov	rax, QWORD PTR 400[rbp]
	add	rax, 32
	mov	ecx, DWORD PTR [rax]
	mov	rax, QWORD PTR 464[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 480[rbp]
	mov	r8d, ecx
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE6LOOKUPEjj
	mov	DWORD PTR 392[rbp], eax
	mov	eax, DWORD PTR 392[rbp]
	mov	DWORD PTR 436[rbp], eax
.L6149:
	cmp	DWORD PTR 436[rbp], 0
	je	.L6207
	mov	rax, QWORD PTR 464[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 436[rbp]
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE8SYMBOLATEj
	mov	QWORD PTR 384[rbp], rax
	mov	rax, QWORD PTR 384[rbp]
	mov	QWORD PTR 376[rbp], rax
	cmp	QWORD PTR 376[rbp], 0
	je	.L6208
	nop
.L6153:
	mov	rax, QWORD PTR 376[rbp]
	movzx	eax, BYTE PTR [rax]
	cmp	al, 5
	jne	.L6209
	nop
.L6155:
	mov	rax, QWORD PTR 376[rbp]
	add	rax, 40
	mov	rax, QWORD PTR [rax]
	mov	DWORD PTR 372[rbp], eax
	cmp	DWORD PTR 372[rbp], 0
	je	.L6210
	mov	rax, QWORD PTR 464[rbp]
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 372[rbp]
	mov	rcx, rax
	call	_ZN3TKO8ASTARENA4KINDEj
	mov	QWORD PTR 360[rbp], rax
	cmp	QWORD PTR 360[rbp], 65
	jne	.L6211
	mov	eax, DWORD PTR 372[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 464[rbp]
	call	_ZN3TKO7RESOLVE6STMTOFERNS0_3CTXEj
	mov	QWORD PTR 352[rbp], rax
	mov	rax, QWORD PTR 352[rbp]
	mov	QWORD PTR 344[rbp], rax
	mov	DWORD PTR 432[rbp], 0
	mov	DWORD PTR 428[rbp], 0
	mov	rax, QWORD PTR 344[rbp]
	add	rax, 20
	mov	eax, DWORD PTR [rax]
	sub	eax, 1
	mov	DWORD PTR 340[rbp], eax
	jmp	.L6159
.L6213:
	nop
.L6160:
	mov	rax, QWORD PTR 344[rbp]
	add	rax, 16
	mov	edx, DWORD PTR [rax]
	mov	eax, DWORD PTR 428[rbp]
	add	edx, eax
	mov	rax, QWORD PTR 464[rbp]
	mov	rax, QWORD PTR [rax]
	add	rax, 560
	mov	rcx, rax
	call	_ZN5ArrayIjEixEi
	mov	QWORD PTR 328[rbp], rax
	mov	rax, QWORD PTR 328[rbp]
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR 324[rbp], eax
	mov	rax, QWORD PTR 464[rbp]
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 324[rbp]
	mov	rcx, rax
	call	_ZN3TKO8ASTARENA4KINDEj
	mov	QWORD PTR 312[rbp], rax
	cmp	QWORD PTR 312[rbp], 66
	jne	.L6212
	add	DWORD PTR 432[rbp], 1
	jmp	.L6163
.L6162:
.L6212:
	nop
.L6163:
	add	DWORD PTR 428[rbp], 1
.L6159:
	mov	eax, DWORD PTR 428[rbp]
	cmp	eax, DWORD PTR 340[rbp]
	jle	.L6213
	nop
.L6164:
	mov	rax, QWORD PTR 400[rbp]
	add	rax, 28
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR 432[rbp], eax
	jne	.L6214
	mov	eax, DWORD PTR 436[rbp]
	mov	DWORD PTR 444[rbp], eax
	add	DWORD PTR 440[rbp], 1
	jmp	.L6170
.L6157:
.L6166:
.L6167:
.L6168:
.L6169:
.L6210:
	nop
	jmp	.L6170
.L6211:
	nop
	jmp	.L6170
.L6214:
	nop
.L6170:
	mov	rax, QWORD PTR 376[rbp]
	mov	eax, DWORD PTR 24[rax]
	mov	DWORD PTR 436[rbp], eax
	jmp	.L6149
.L6207:
	nop
	jmp	.L6151
.L6208:
	nop
	jmp	.L6151
.L6209:
	nop
.L6151:
	cmp	DWORD PTR 440[rbp], 1
	jne	.L6215
	nop
.L6172:
	mov	rax, QWORD PTR 464[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 444[rbp]
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE8SYMBOLATEj
	mov	QWORD PTR 304[rbp], rax
	mov	rax, QWORD PTR 304[rbp]
	mov	QWORD PTR 296[rbp], rax
	mov	rax, QWORD PTR 296[rbp]
	add	rax, 40
	mov	rax, QWORD PTR [rax]
	mov	DWORD PTR 292[rbp], eax
	mov	eax, DWORD PTR 292[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 464[rbp]
	call	_ZN3TKO7RESOLVE6STMTOFERNS0_3CTXEj
	mov	QWORD PTR 280[rbp], rax
	mov	rax, QWORD PTR 280[rbp]
	mov	QWORD PTR 272[rbp], rax
	mov	rax, rbp
	mov	rcx, rax
	call	_ZN5ArrayIjEC1Ev
	mov	DWORD PTR 424[rbp], 0
	mov	rax, QWORD PTR 272[rbp]
	add	rax, 20
	mov	eax, DWORD PTR [rax]
	sub	eax, 1
	mov	DWORD PTR 268[rbp], eax
	jmp	.L6173
.L6220:
	nop
.L6174:
	mov	rax, QWORD PTR 272[rbp]
	add	rax, 16
	mov	edx, DWORD PTR [rax]
	mov	eax, DWORD PTR 424[rbp]
	add	edx, eax
	mov	rax, QWORD PTR 464[rbp]
	mov	rax, QWORD PTR [rax]
	add	rax, 560
	mov	rcx, rax
	call	_ZN5ArrayIjEixEi
	mov	QWORD PTR 128[rbp], rax
	mov	rax, QWORD PTR 128[rbp]
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR 124[rbp], eax
	mov	rax, QWORD PTR 464[rbp]
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 124[rbp]
	mov	rcx, rax
	call	_ZN3TKO8ASTARENA4KINDEj
	mov	QWORD PTR 112[rbp], rax
	cmp	QWORD PTR 112[rbp], 66
	jne	.L6216
	nop
.L6176:
	mov	edx, DWORD PTR 124[rbp]
	mov	rax, QWORD PTR 464[rbp]
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN5ArrayIN3TKO7ASTNODEEEixEi
	mov	QWORD PTR 104[rbp], rax
	mov	rax, QWORD PTR 104[rbp]
	add	rax, 2
	movzx	eax, WORD PTR [rax]
	movzx	eax, ax
	and	eax, 16
	test	rax, rax
	je	.L6217
	mov	rax, rbp
	mov	rcx, rax
	call	_ZN5ArrayIjED1Ev
	jmp	.L6143
.L6217:
	nop
.L6179:
	mov	eax, DWORD PTR 124[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 464[rbp]
	call	_ZN3TKO7RESOLVE6STMTOFERNS0_3CTXEj
	mov	QWORD PTR 96[rbp], rax
	mov	rax, QWORD PTR 96[rbp]
	add	rax, 4
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 464[rbp]
	add	rax, 48
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN3TKO12SEMANTICINFO7TYPEOF_Ej
	mov	DWORD PTR 92[rbp], eax
	mov	eax, DWORD PTR 92[rbp]
	mov	DWORD PTR -8[rbp], eax
	mov	eax, DWORD PTR -8[rbp]
	test	eax, eax
	jne	.L6218
	mov	rax, rbp
	mov	rcx, rax
	call	_ZN5ArrayIjED1Ev
	jmp	.L6180
.L6218:
	nop
.L6182:
	mov	edx, DWORD PTR -8[rbp]
	mov	rax, QWORD PTR 464[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT4KINDEj
	mov	QWORD PTR 80[rbp], rax
	cmp	QWORD PTR 80[rbp], 3
	jne	.L6219
	mov	rax, rbp
	mov	rcx, rax
	call	_ZN5ArrayIjED1Ev
	jmp	.L6180
.L6219:
	nop
.L6184:
	lea	rdx, -8[rbp]
	mov	rax, rbp
	mov	rcx, rax
	call	_ZN5ArrayIjE4PUSHERj
	jmp	.L6177
.L6180:
	jmp	.L6225
.L6216:
	nop
.L6177:
	add	DWORD PTR 424[rbp], 1
.L6173:
	mov	eax, DWORD PTR 424[rbp]
	cmp	eax, DWORD PTR 268[rbp]
	jle	.L6220
	nop
.L6185:
	mov	rax, rbp
	mov	rcx, rax
	call	_ZN5ArrayIjE5COUNTEv
	mov	DWORD PTR 264[rbp], eax
	mov	rax, QWORD PTR 400[rbp]
	add	rax, 28
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR 264[rbp], eax
	je	.L6221
	mov	rax, rbp
	mov	rcx, rax
	call	_ZN5ArrayIjED1Ev
	jmp	.L6143
.L6221:
	nop
.L6187:
	mov	BYTE PTR -1[rbp], 0
	mov	rax, QWORD PTR 464[rbp]
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 472[rbp]
	mov	rcx, rax
	call	_ZN3TKO8ASTARENA3LOCEj
	mov	DWORD PTR 260[rbp], eax
	mov	eax, DWORD PTR 260[rbp]
	mov	DWORD PTR 256[rbp], eax
	mov	rax, QWORD PTR 400[rbp]
	mov	ecx, DWORD PTR [rax]
	mov	rax, QWORD PTR 464[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	lea	rdx, -1[rbp]
	mov	QWORD PTR 40[rsp], rdx
	mov	edx, DWORD PTR 256[rbp]
	mov	DWORD PTR 32[rsp], edx
	mov	r9d, 6
	mov	r8d, ecx
	mov	edx, 1
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE10DECLARESYMEjjNS_10SYMBOLKINDEjRb
	mov	DWORD PTR 252[rbp], eax
	mov	eax, DWORD PTR 252[rbp]
	mov	DWORD PTR 248[rbp], eax
	mov	rax, QWORD PTR 464[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 248[rbp]
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE8SYMBOLATEj
	mov	QWORD PTR 240[rbp], rax
	mov	rax, QWORD PTR 240[rbp]
	mov	QWORD PTR 232[rbp], rax
	cmp	QWORD PTR 232[rbp], 0
	jne	.L6222
	mov	rax, rbp
	mov	rcx, rax
	call	_ZN5ArrayIjED1Ev
	jmp	.L6143
.L6222:
	nop
.L6189:
	mov	rax, QWORD PTR 464[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 248[rbp]
	mov	r9d, edx
	mov	r8d, 1
	mov	edx, 3
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE9OPENSCOPEENS_9SCOPEKINDEjj
	mov	DWORD PTR 228[rbp], eax
	mov	eax, DWORD PTR 228[rbp]
	mov	DWORD PTR 224[rbp], eax
	mov	rax, QWORD PTR 232[rbp]
	lea	rdx, 36[rax]
	mov	eax, DWORD PTR 224[rbp]
	mov	DWORD PTR [rdx], eax
	mov	rax, QWORD PTR 400[rbp]
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 464[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	DWORD PTR 32[rsp], 0
	mov	r9d, 1
	mov	r8d, edx
	mov	edx, 6
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT9NAMEDTYPEENS_8TYPEKINDEjjj
	mov	DWORD PTR 220[rbp], eax
	mov	rax, QWORD PTR 232[rbp]
	lea	rdx, 16[rax]
	mov	eax, DWORD PTR 220[rbp]
	mov	DWORD PTR [rdx], eax
	mov	DWORD PTR 420[rbp], 0
	mov	rax, rbp
	mov	rcx, rax
	call	_ZN5ArrayIjE5COUNTEv
	mov	DWORD PTR 216[rbp], eax
	mov	eax, DWORD PTR 216[rbp]
	sub	eax, 1
	mov	DWORD PTR 212[rbp], eax
	jmp	.L6190
.L6224:
	nop
.L6191:
	lea	rax, -64[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	eax, DWORD PTR 420[rbp]
	mov	ecx, eax
	call	fb_IntToStr
	mov	QWORD PTR 200[rbp], rax
	mov	rax, QWORD PTR 200[rbp]
	mov	rcx, rax
	call	fb_TRIM
	mov	QWORD PTR 192[rbp], rax
	lea	rax, -32[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	rdx, QWORD PTR 192[rbp]
	lea	rax, -32[rbp]
	mov	QWORD PTR 32[rsp], -1
	mov	r9, rdx
	mov	r8d, 7
	lea	rdx, .LC29[rip]
	mov	rcx, rax
	call	fb_StrConcat
	mov	QWORD PTR 184[rbp], rax
	mov	rdx, QWORD PTR 184[rbp]
	lea	rax, -64[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrAssign
	mov	rax, QWORD PTR 464[rbp]
	add	rax, 24
	mov	rax, QWORD PTR [rax]
	lea	rdx, -64[rbp]
	mov	rcx, rax
	call	_ZN3TKO8INTERNER9GETSTRINGE8FBSTRING
	mov	DWORD PTR 180[rbp], eax
	mov	rax, QWORD PTR 464[rbp]
	add	rax, 24
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 180[rbp]
	mov	rcx, rax
	call	_ZN3TKO8INTERNER4FOLDEj
	mov	DWORD PTR 176[rbp], eax
	mov	eax, DWORD PTR 176[rbp]
	mov	DWORD PTR 172[rbp], eax
	lea	rax, -64[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	mov	BYTE PTR -65[rbp], 0
	mov	rax, QWORD PTR 464[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	r8d, DWORD PTR 172[rbp]
	mov	edx, DWORD PTR 224[rbp]
	lea	rcx, -65[rbp]
	mov	QWORD PTR 40[rsp], rcx
	mov	ecx, DWORD PTR 256[rbp]
	mov	DWORD PTR 32[rsp], ecx
	mov	r9d, 4
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE10DECLARESYMEjjNS_10SYMBOLKINDEjRb
	mov	DWORD PTR 168[rbp], eax
	mov	eax, DWORD PTR 168[rbp]
	mov	DWORD PTR 164[rbp], eax
	mov	rax, QWORD PTR 464[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 164[rbp]
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE8SYMBOLATEj
	mov	QWORD PTR 152[rbp], rax
	mov	rax, QWORD PTR 152[rbp]
	mov	QWORD PTR 144[rbp], rax
	cmp	QWORD PTR 144[rbp], 0
	je	.L6223
	mov	edx, DWORD PTR 420[rbp]
	mov	rax, rbp
	mov	rcx, rax
	call	_ZN5ArrayIjEixEi
	mov	QWORD PTR 136[rbp], rax
	mov	rax, QWORD PTR 144[rbp]
	lea	rdx, 16[rax]
	mov	rax, QWORD PTR 136[rbp]
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR [rdx], eax
	jmp	.L6194
.L6193:
.L6223:
	nop
.L6194:
	add	DWORD PTR 420[rbp], 1
.L6190:
	mov	eax, DWORD PTR 420[rbp]
	cmp	eax, DWORD PTR 212[rbp]
	jle	.L6224
	nop
.L6195:
	mov	rax, QWORD PTR 232[rbp]
	add	rax, 16
	mov	ecx, DWORD PTR [rax]
	mov	rax, QWORD PTR 464[rbp]
	add	rax, 48
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 472[rbp]
	mov	r8d, ecx
	mov	rcx, rax
	call	_ZN3TKO12SEMANTICINFO7SETTYPEEjj
	mov	rax, rbp
	mov	rcx, rax
	call	_ZN5ArrayIjED1Ev
	jmp	.L6225
.L6204:
	nop
	jmp	.L6225
.L6205:
	nop
	jmp	.L6225
.L6206:
	nop
	jmp	.L6225
.L6215:
	nop
.L6143:
.L6225:
	nop
	add	rsp, 576
	pop	rbp
	ret
	.seh_endproc
	.section .rdata,"dr"
.LC30:
	.ascii "__CAP_\0"
.LC31:
	.ascii "__fbinvoke\0"
	.text
	.def	_ZN3TKO7RESOLVE17BUILDCLOSURETYPE_ERNS0_3CTXEjj;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN3TKO7RESOLVE17BUILDCLOSURETYPE_ERNS0_3CTXEjj
_ZN3TKO7RESOLVE17BUILDCLOSURETYPE_ERNS0_3CTXEjj:
	push	rbp
	.seh_pushreg	rbp
	sub	rsp, 544
	.seh_stackalloc	544
	lea	rbp, 128[rsp]
	.seh_setframe	rbp, 128
	.seh_endprologue
	mov	QWORD PTR 432[rbp], rcx
	mov	DWORD PTR 440[rbp], edx
	mov	DWORD PTR 448[rbp], r8d
.L6227:
	mov	eax, DWORD PTR 440[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 432[rbp]
	call	_ZN3TKO7RESOLVE6STMTOFERNS0_3CTXEj
	mov	QWORD PTR 400[rbp], rax
	mov	rax, QWORD PTR 400[rbp]
	mov	QWORD PTR 392[rbp], rax
	mov	rax, QWORD PTR 392[rbp]
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	je	.L6271
	nop
.L6229:
	mov	rax, QWORD PTR 392[rbp]
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 432[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	r9d, 1
	mov	r8d, edx
	mov	edx, 1
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE16LOOKUPLOCALTYPEDEjjb
	mov	DWORD PTR 388[rbp], eax
	cmp	DWORD PTR 388[rbp], 0
	jne	.L6272
	nop
.L6232:
.L6233:
	lea	rax, 32[rbp]
	mov	rcx, rax
	call	_ZN5ArrayIjEC1Ev
	mov	DWORD PTR 412[rbp], 0
	mov	rax, QWORD PTR 392[rbp]
	add	rax, 20
	mov	eax, DWORD PTR [rax]
	sub	eax, 1
	mov	DWORD PTR 384[rbp], eax
	jmp	.L6234
.L6278:
	nop
.L6235:
	mov	rax, QWORD PTR 392[rbp]
	add	rax, 16
	mov	edx, DWORD PTR [rax]
	mov	eax, DWORD PTR 412[rbp]
	add	edx, eax
	mov	rax, QWORD PTR 432[rbp]
	mov	rax, QWORD PTR [rax]
	add	rax, 560
	mov	rcx, rax
	call	_ZN5ArrayIjEixEi
	mov	QWORD PTR 192[rbp], rax
	mov	rax, QWORD PTR 192[rbp]
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR 188[rbp], eax
	mov	rax, QWORD PTR 432[rbp]
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 188[rbp]
	mov	rcx, rax
	call	_ZN3TKO8ASTARENA4KINDEj
	mov	QWORD PTR 176[rbp], rax
	cmp	QWORD PTR 176[rbp], 6
	je	.L6273
	lea	rax, 32[rbp]
	mov	rcx, rax
	call	_ZN5ArrayIjED1Ev
	jmp	.L6230
.L6273:
	nop
.L6237:
	mov	eax, DWORD PTR 188[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 432[rbp]
	call	_ZN3TKO7RESOLVE11IDENTNAMEOFERNS0_3CTXEj
	mov	DWORD PTR 172[rbp], eax
	mov	rax, QWORD PTR 432[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	ecx, DWORD PTR 172[rbp]
	mov	edx, DWORD PTR 448[rbp]
	mov	r9d, 0
	mov	r8d, ecx
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE11LOOKUPTYPEDEjjb
	mov	DWORD PTR 168[rbp], eax
	mov	eax, DWORD PTR 168[rbp]
	mov	DWORD PTR 164[rbp], eax
	mov	rax, QWORD PTR 432[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 164[rbp]
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE8SYMBOLATEj
	mov	QWORD PTR 152[rbp], rax
	mov	rax, QWORD PTR 152[rbp]
	mov	QWORD PTR 144[rbp], rax
	cmp	QWORD PTR 144[rbp], 0
	jne	.L6274
	lea	rax, 32[rbp]
	mov	rcx, rax
	call	_ZN5ArrayIjED1Ev
	jmp	.L6238
.L6274:
	nop
.L6240:
	mov	rax, QWORD PTR 144[rbp]
	mov	eax, DWORD PTR 16[rax]
	mov	DWORD PTR 24[rbp], eax
	mov	eax, DWORD PTR 24[rbp]
	test	eax, eax
	jne	.L6275
	lea	rax, 32[rbp]
	mov	rcx, rax
	call	_ZN5ArrayIjED1Ev
	jmp	.L6238
.L6275:
	nop
.L6242:
	mov	edx, DWORD PTR 24[rbp]
	mov	rax, QWORD PTR 432[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT4KINDEj
	mov	QWORD PTR 136[rbp], rax
	cmp	QWORD PTR 136[rbp], 3
	jne	.L6276
	mov	edx, DWORD PTR 24[rbp]
	mov	rax, QWORD PTR 432[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT5INNEREj
	mov	DWORD PTR 132[rbp], eax
	mov	eax, DWORD PTR 132[rbp]
	mov	DWORD PTR 24[rbp], eax
	jmp	.L6244
.L6276:
	nop
.L6244:
	mov	rax, QWORD PTR 432[rbp]
	add	rax, 48
	mov	rax, QWORD PTR [rax]
	mov	ecx, DWORD PTR 164[rbp]
	mov	edx, DWORD PTR 188[rbp]
	mov	r8d, ecx
	mov	rcx, rax
	call	_ZN3TKO12SEMANTICINFO6SETREFEjj
	mov	ecx, DWORD PTR 24[rbp]
	mov	rax, QWORD PTR 432[rbp]
	add	rax, 48
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 188[rbp]
	mov	r8d, ecx
	mov	rcx, rax
	call	_ZN3TKO12SEMANTICINFO7SETTYPEEjj
	mov	edx, DWORD PTR 188[rbp]
	mov	rax, QWORD PTR 432[rbp]
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN5ArrayIN3TKO7ASTNODEEEixEi
	mov	QWORD PTR 120[rbp], rax
	mov	rax, QWORD PTR 120[rbp]
	add	rax, 2
	movzx	eax, WORD PTR [rax]
	movzx	eax, ax
	and	eax, 16
	test	rax, rax
	je	.L6277
	mov	edx, DWORD PTR 24[rbp]
	mov	rax, QWORD PTR 432[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT8POINTER_Ej
	mov	DWORD PTR 116[rbp], eax
	mov	eax, DWORD PTR 116[rbp]
	mov	DWORD PTR 24[rbp], eax
	jmp	.L6247
.L6246:
.L6277:
	nop
.L6247:
	lea	rdx, 24[rbp]
	lea	rax, 32[rbp]
	mov	rcx, rax
	call	_ZN5ArrayIjE4PUSHERj
	jmp	.L6267
.L6238:
	jmp	.L6284
.L6267:
.L6248:
	add	DWORD PTR 412[rbp], 1
.L6234:
	mov	eax, DWORD PTR 412[rbp]
	cmp	eax, DWORD PTR 384[rbp]
	jle	.L6278
	nop
.L6249:
	mov	BYTE PTR 31[rbp], 0
	mov	rax, QWORD PTR 432[rbp]
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 440[rbp]
	mov	rcx, rax
	call	_ZN3TKO8ASTARENA3LOCEj
	mov	DWORD PTR 380[rbp], eax
	mov	eax, DWORD PTR 380[rbp]
	mov	DWORD PTR 376[rbp], eax
	mov	rax, QWORD PTR 392[rbp]
	mov	ecx, DWORD PTR [rax]
	mov	rax, QWORD PTR 432[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	lea	rdx, 31[rbp]
	mov	QWORD PTR 40[rsp], rdx
	mov	edx, DWORD PTR 376[rbp]
	mov	DWORD PTR 32[rsp], edx
	mov	r9d, 6
	mov	r8d, ecx
	mov	edx, 1
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE10DECLARESYMEjjNS_10SYMBOLKINDEjRb
	mov	DWORD PTR 372[rbp], eax
	mov	eax, DWORD PTR 372[rbp]
	mov	DWORD PTR 368[rbp], eax
	mov	rax, QWORD PTR 432[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 368[rbp]
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE8SYMBOLATEj
	mov	QWORD PTR 360[rbp], rax
	mov	rax, QWORD PTR 360[rbp]
	mov	QWORD PTR 352[rbp], rax
	cmp	QWORD PTR 352[rbp], 0
	jne	.L6279
	lea	rax, 32[rbp]
	mov	rcx, rax
	call	_ZN5ArrayIjED1Ev
	jmp	.L6230
.L6279:
	nop
.L6251:
	mov	rax, QWORD PTR 432[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 368[rbp]
	mov	r9d, edx
	mov	r8d, 1
	mov	edx, 3
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE9OPENSCOPEENS_9SCOPEKINDEjj
	mov	DWORD PTR 348[rbp], eax
	mov	eax, DWORD PTR 348[rbp]
	mov	DWORD PTR 344[rbp], eax
	mov	rax, QWORD PTR 352[rbp]
	lea	rdx, 36[rax]
	mov	eax, DWORD PTR 344[rbp]
	mov	DWORD PTR [rdx], eax
	mov	rax, QWORD PTR 392[rbp]
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 432[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	DWORD PTR 32[rsp], 0
	mov	r9d, 1
	mov	r8d, edx
	mov	edx, 6
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT9NAMEDTYPEENS_8TYPEKINDEjjj
	mov	DWORD PTR 340[rbp], eax
	mov	rax, QWORD PTR 352[rbp]
	lea	rdx, 16[rax]
	mov	eax, DWORD PTR 340[rbp]
	mov	DWORD PTR [rdx], eax
	mov	DWORD PTR 408[rbp], 0
	mov	rax, QWORD PTR 392[rbp]
	add	rax, 20
	mov	eax, DWORD PTR [rax]
	sub	eax, 1
	mov	DWORD PTR 336[rbp], eax
	jmp	.L6252
.L6281:
	nop
.L6253:
	mov	rax, QWORD PTR 392[rbp]
	add	rax, 16
	mov	edx, DWORD PTR [rax]
	mov	eax, DWORD PTR 408[rbp]
	add	edx, eax
	mov	rax, QWORD PTR 432[rbp]
	mov	rax, QWORD PTR [rax]
	add	rax, 560
	mov	rcx, rax
	call	_ZN5ArrayIjEixEi
	mov	QWORD PTR 272[rbp], rax
	mov	rax, QWORD PTR 272[rbp]
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR 268[rbp], eax
	lea	rax, -32[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	eax, DWORD PTR 268[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 432[rbp]
	call	_ZN3TKO7RESOLVE11IDENTNAMEOFERNS0_3CTXEj
	mov	DWORD PTR 264[rbp], eax
	mov	rax, QWORD PTR 432[rbp]
	add	rax, 24
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 264[rbp]
	mov	rcx, rax
	call	_ZN3TKO8INTERNER8SPELLINGEj
	mov	QWORD PTR 256[rbp], rax
	mov	rax, rbp
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	rdx, QWORD PTR 256[rbp]
	mov	rax, rbp
	mov	QWORD PTR 32[rsp], -1
	mov	r9, rdx
	mov	r8d, 7
	lea	rdx, .LC30[rip]
	mov	rcx, rax
	call	fb_StrConcat
	mov	QWORD PTR 248[rbp], rax
	mov	rdx, QWORD PTR 248[rbp]
	lea	rax, -32[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrAssign
	mov	rax, QWORD PTR 432[rbp]
	add	rax, 24
	mov	rax, QWORD PTR [rax]
	lea	rdx, -32[rbp]
	mov	rcx, rax
	call	_ZN3TKO8INTERNER9GETSTRINGE8FBSTRING
	mov	DWORD PTR 244[rbp], eax
	mov	rax, QWORD PTR 432[rbp]
	add	rax, 24
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 244[rbp]
	mov	rcx, rax
	call	_ZN3TKO8INTERNER4FOLDEj
	mov	DWORD PTR 240[rbp], eax
	mov	eax, DWORD PTR 240[rbp]
	mov	DWORD PTR 236[rbp], eax
	lea	rax, -32[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	mov	BYTE PTR -33[rbp], 0
	mov	rax, QWORD PTR 432[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	r8d, DWORD PTR 236[rbp]
	mov	edx, DWORD PTR 344[rbp]
	lea	rcx, -33[rbp]
	mov	QWORD PTR 40[rsp], rcx
	mov	ecx, DWORD PTR 376[rbp]
	mov	DWORD PTR 32[rsp], ecx
	mov	r9d, 4
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE10DECLARESYMEjjNS_10SYMBOLKINDEjRb
	mov	DWORD PTR 232[rbp], eax
	mov	eax, DWORD PTR 232[rbp]
	mov	DWORD PTR 228[rbp], eax
	mov	rax, QWORD PTR 432[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 228[rbp]
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE8SYMBOLATEj
	mov	QWORD PTR 216[rbp], rax
	mov	rax, QWORD PTR 216[rbp]
	mov	QWORD PTR 208[rbp], rax
	cmp	QWORD PTR 208[rbp], 0
	je	.L6280
	mov	edx, DWORD PTR 408[rbp]
	lea	rax, 32[rbp]
	mov	rcx, rax
	call	_ZN5ArrayIjEixEi
	mov	QWORD PTR 200[rbp], rax
	mov	rax, QWORD PTR 208[rbp]
	lea	rdx, 16[rax]
	mov	rax, QWORD PTR 200[rbp]
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR [rdx], eax
	jmp	.L6256
.L6255:
.L6280:
	nop
.L6256:
	add	DWORD PTR 408[rbp], 1
.L6252:
	mov	eax, DWORD PTR 408[rbp]
	cmp	eax, DWORD PTR 336[rbp]
	jle	.L6281
	nop
.L6257:
	mov	rax, QWORD PTR 392[rbp]
	add	rax, 4
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	je	.L6282
	lea	rax, -64[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	lea	rax, -64[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9d, 11
	lea	r8, .LC31[rip]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrAssign
	mov	rax, QWORD PTR 432[rbp]
	add	rax, 24
	mov	rax, QWORD PTR [rax]
	lea	rdx, -64[rbp]
	mov	rcx, rax
	call	_ZN3TKO8INTERNER9GETSTRINGE8FBSTRING
	mov	DWORD PTR 332[rbp], eax
	mov	rax, QWORD PTR 432[rbp]
	add	rax, 24
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 332[rbp]
	mov	rcx, rax
	call	_ZN3TKO8INTERNER4FOLDEj
	mov	DWORD PTR 328[rbp], eax
	mov	eax, DWORD PTR 328[rbp]
	mov	DWORD PTR 324[rbp], eax
	lea	rax, -64[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	mov	BYTE PTR -65[rbp], 0
	mov	rax, QWORD PTR 432[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	r8d, DWORD PTR 324[rbp]
	mov	edx, DWORD PTR 344[rbp]
	lea	rcx, -65[rbp]
	mov	QWORD PTR 40[rsp], rcx
	mov	ecx, DWORD PTR 376[rbp]
	mov	DWORD PTR 32[rsp], ecx
	mov	r9d, 5
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE10DECLARESYMEjjNS_10SYMBOLKINDEjRb
	mov	DWORD PTR 320[rbp], eax
	mov	eax, DWORD PTR 320[rbp]
	mov	DWORD PTR 316[rbp], eax
	mov	rax, QWORD PTR 432[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 316[rbp]
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE8SYMBOLATEj
	mov	QWORD PTR 304[rbp], rax
	mov	rax, QWORD PTR 304[rbp]
	mov	QWORD PTR 296[rbp], rax
	cmp	QWORD PTR 296[rbp], 0
	je	.L6283
	mov	rax, QWORD PTR 392[rbp]
	add	rax, 4
	mov	eax, DWORD PTR [rax]
	mov	edx, eax
	mov	rcx, QWORD PTR 432[rbp]
	call	_ZN3TKO7RESOLVE6STMTOFERNS0_3CTXEj
	mov	QWORD PTR 288[rbp], rax
	mov	rax, QWORD PTR 288[rbp]
	mov	ecx, DWORD PTR [rax]
	mov	rax, QWORD PTR 432[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 448[rbp]
	mov	r8d, ecx
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE6LOOKUPEjj
	mov	DWORD PTR 284[rbp], eax
	mov	rax, QWORD PTR 296[rbp]
	lea	rdx, 40[rax]
	mov	eax, DWORD PTR 284[rbp]
	mov	QWORD PTR [rdx], rax
	jmp	.L6263
.L6261:
.L6262:
.L6259:
.L6282:
	nop
	jmp	.L6263
.L6283:
	nop
.L6263:
	mov	rax, QWORD PTR 352[rbp]
	add	rax, 16
	mov	ecx, DWORD PTR [rax]
	mov	rax, QWORD PTR 432[rbp]
	add	rax, 48
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 440[rbp]
	mov	r8d, ecx
	mov	rcx, rax
	call	_ZN3TKO12SEMANTICINFO7SETTYPEEjj
	lea	rax, 32[rbp]
	mov	rcx, rax
	call	_ZN5ArrayIjED1Ev
	jmp	.L6284
.L6271:
	nop
	jmp	.L6284
.L6272:
	nop
.L6230:
.L6284:
	nop
	add	rsp, 544
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN3TKO7RESOLVE8WALKEXPRERNS0_3CTXEjj;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN3TKO7RESOLVE8WALKEXPRERNS0_3CTXEjj
_ZN3TKO7RESOLVE8WALKEXPRERNS0_3CTXEjj:
	push	rbp
	.seh_pushreg	rbp
	sub	rsp, 768
	.seh_stackalloc	768
	lea	rbp, 128[rsp]
	.seh_setframe	rbp, 128
	.seh_endprologue
	mov	QWORD PTR 656[rbp], rcx
	mov	DWORD PTR 664[rbp], edx
	mov	DWORD PTR 672[rbp], r8d
.L6286:
	cmp	DWORD PTR 664[rbp], 0
	je	.L6502
	nop
.L6288:
	mov	rax, QWORD PTR 656[rbp]
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 664[rbp]
	mov	rcx, rax
	call	_ZN3TKO8ASTARENA4KINDEj
	mov	QWORD PTR 568[rbp], rax
	mov	rax, QWORD PTR 568[rbp]
	mov	QWORD PTR 560[rbp], rax
	mov	edx, DWORD PTR 664[rbp]
	mov	rax, QWORD PTR 656[rbp]
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN5ArrayIN3TKO7ASTNODEEEixEi
	mov	QWORD PTR 552[rbp], rax
	mov	rax, QWORD PTR 552[rbp]
	mov	QWORD PTR 544[rbp], rax
	cmp	QWORD PTR 560[rbp], 21
	jne	.L6503
	nop
.L6290:
	mov	edx, DWORD PTR 672[rbp]
	mov	eax, DWORD PTR 664[rbp]
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 656[rbp]
	call	_ZN3TKO7RESOLVE17BUILDCLOSURETYPE_ERNS0_3CTXEjj
	jmp	.L6475
.L6503:
	nop
.L6291:
	cmp	QWORD PTR 560[rbp], 6
	jne	.L6504
	nop
.L6292:
	mov	eax, DWORD PTR 664[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 656[rbp]
	call	_ZN3TKO7RESOLVE11IDENTNAMEOFERNS0_3CTXEj
	mov	DWORD PTR 540[rbp], eax
	mov	eax, DWORD PTR 540[rbp]
	mov	DWORD PTR -52[rbp], eax
	mov	ecx, DWORD PTR -52[rbp]
	mov	rax, QWORD PTR 656[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 672[rbp]
	mov	r9d, 0
	mov	r8d, ecx
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE11LOOKUPTYPEDEjjb
	mov	DWORD PTR 536[rbp], eax
	mov	eax, DWORD PTR 536[rbp]
	mov	DWORD PTR -56[rbp], eax
	mov	eax, DWORD PTR -56[rbp]
	test	eax, eax
	je	.L6505
	mov	ecx, DWORD PTR -56[rbp]
	mov	rax, QWORD PTR 656[rbp]
	add	rax, 48
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 664[rbp]
	mov	r8d, ecx
	mov	rcx, rax
	call	_ZN3TKO12SEMANTICINFO6SETREFEjj
	mov	rax, QWORD PTR 656[rbp]
	add	rax, 56
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 656[rbp]
	add	rax, 56
	mov	rax, QWORD PTR [rax]
	add	edx, 1
	mov	DWORD PTR [rax], edx
	mov	edx, DWORD PTR -56[rbp]
	mov	rax, QWORD PTR 656[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE8SYMBOLATEj
	mov	QWORD PTR 528[rbp], rax
	mov	rax, QWORD PTR 528[rbp]
	mov	QWORD PTR 520[rbp], rax
	cmp	QWORD PTR 520[rbp], 0
	je	.L6506
	mov	rax, QWORD PTR 520[rbp]
	add	rax, 4
	mov	eax, DWORD PTR [rax]
	mov	eax, eax
	and	eax, 1024
	test	rax, rax
	je	.L6507
	mov	rax, QWORD PTR 656[rbp]
	add	rax, 24
	mov	rcx, QWORD PTR [rax]
	mov	rax, QWORD PTR 656[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 672[rbp]
	mov	r8, rcx
	mov	rcx, rax
	call	_ZN3TKO6MANGLE17ENCLOSINGPROCNAMEERNS_11SYMBOLTABLEEjRNS_8INTERNERE
	mov	QWORD PTR 512[rbp], rax
	mov	rdx, QWORD PTR 512[rbp]
	lea	rax, -80[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrInit
	lea	rax, -80[rbp]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrLen
	mov	QWORD PTR 504[rbp], rax
	mov	rax, QWORD PTR 656[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, 16
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT7BUILTINENS_11BUILTINTYPEE
	mov	DWORD PTR 500[rbp], eax
	mov	rax, QWORD PTR 504[rbp]
	lea	ecx, 1[rax]
	mov	rax, QWORD PTR 656[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 500[rbp]
	mov	QWORD PTR 32[rsp], 0
	mov	r9d, ecx
	mov	r8d, 1
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT7ARRAYOFEjiiP5ArrayIxE
	mov	DWORD PTR 496[rbp], eax
	mov	rax, QWORD PTR 656[rbp]
	add	rax, 48
	mov	rax, QWORD PTR [rax]
	mov	ecx, DWORD PTR 496[rbp]
	mov	edx, DWORD PTR 664[rbp]
	mov	r8d, ecx
	mov	rcx, rax
	call	_ZN3TKO12SEMANTICINFO7SETTYPEEjj
	lea	rax, -80[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	jmp	.L6311
.L6297:
.L6299:
.L6300:
.L6506:
	nop
	jmp	.L6311
.L6507:
	nop
.L6301:
	jmp	.L6311
.L6505:
	nop
.L6295:
	mov	edx, DWORD PTR -52[rbp]
	lea	rcx, -56[rbp]
	mov	eax, DWORD PTR 672[rbp]
	mov	r9, rcx
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 656[rbp]
	call	_ZN3TKO7RESOLVE16INHERITEDMEMBER_ERNS0_3CTXEjjRj
	mov	BYTE PTR 495[rbp], al
	cmp	BYTE PTR 495[rbp], 0
	je	.L6508
	mov	ecx, DWORD PTR -56[rbp]
	mov	rax, QWORD PTR 656[rbp]
	add	rax, 48
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 664[rbp]
	mov	r8d, ecx
	mov	rcx, rax
	call	_ZN3TKO12SEMANTICINFO6SETREFEjj
	mov	rax, QWORD PTR 656[rbp]
	add	rax, 56
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 656[rbp]
	add	rax, 56
	mov	rax, QWORD PTR [rax]
	add	edx, 1
	mov	DWORD PTR [rax], edx
	jmp	.L6311
.L6508:
	nop
.L6304:
	mov	eax, DWORD PTR -52[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 656[rbp]
	call	_ZN3TKO7RESOLVE13GPARAMTYPEOF_ERNS0_3CTXEj
	mov	DWORD PTR 488[rbp], eax
	cmp	DWORD PTR 488[rbp], 0
	je	.L6509
	mov	eax, DWORD PTR -52[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 656[rbp]
	call	_ZN3TKO7RESOLVE13GPARAMTYPEOF_ERNS0_3CTXEj
	mov	DWORD PTR 484[rbp], eax
	mov	rax, QWORD PTR 656[rbp]
	add	rax, 48
	mov	rax, QWORD PTR [rax]
	mov	ecx, DWORD PTR 484[rbp]
	mov	edx, DWORD PTR 664[rbp]
	mov	r8d, ecx
	mov	rcx, rax
	call	_ZN3TKO12SEMANTICINFO7SETTYPEEjj
	jmp	.L6311
.L6509:
	nop
.L6306:
	mov	eax, DWORD PTR -52[rbp]
	cmp	eax, 247
	jg	.L6510
	mov	rax, QWORD PTR 656[rbp]
	add	rax, 56
	mov	rax, QWORD PTR [rax]
	add	rax, 4
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 656[rbp]
	add	rax, 56
	mov	rax, QWORD PTR [rax]
	add	rax, 4
	add	edx, 1
	mov	DWORD PTR [rax], edx
	jmp	.L6311
.L6510:
	nop
.L6308:
	mov	rax, QWORD PTR 656[rbp]
	add	rax, 56
	mov	rax, QWORD PTR [rax]
	add	rax, 8
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 656[rbp]
	add	rax, 56
	mov	rax, QWORD PTR [rax]
	add	rax, 8
	add	edx, 1
	mov	DWORD PTR [rax], edx
	mov	rax, QWORD PTR 656[rbp]
	add	rax, 56
	mov	rax, QWORD PTR [rax]
	add	rax, 24
	mov	rcx, rax
	call	_ZN5ArrayIjE5COUNTEv
	mov	DWORD PTR 480[rbp], eax
	cmp	DWORD PTR 480[rbp], 199999
	jg	.L6511
	mov	rax, QWORD PTR 656[rbp]
	add	rax, 56
	mov	rax, QWORD PTR [rax]
	lea	rcx, 24[rax]
	lea	rax, -52[rbp]
	mov	rdx, rax
	call	_ZN5ArrayIjE4PUSHERj
	jmp	.L6475
.L6302:
.L6310:
.L6511:
	nop
.L6311:
	jmp	.L6475
.L6504:
	nop
.L6293:
	cmp	QWORD PTR 560[rbp], 7
	je	.L6512
	nop
.L6312:
	cmp	QWORD PTR 560[rbp], 13
	je	.L6513
	nop
.L6314:
	cmp	QWORD PTR 560[rbp], 12
	jne	.L6514
	jmp	.L6313
.L6512:
	nop
	jmp	.L6313
.L6513:
	nop
.L6313:
	mov	rax, QWORD PTR 544[rbp]
	add	rax, 8
	mov	eax, DWORD PTR [rax]
	mov	rdx, QWORD PTR 656[rbp]
	mov	rdx, QWORD PTR [rdx]
	lea	rcx, 80[rdx]
	mov	edx, eax
	call	_ZN5ArrayIN3TKO12UNARYPAYLOADEEixEi
	mov	QWORD PTR -48[rbp], rax
	mov	rax, QWORD PTR -48[rbp]
	add	rax, 4
	mov	eax, DWORD PTR [rax]
	mov	edx, DWORD PTR 672[rbp]
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 656[rbp]
	call	_ZN3TKO7RESOLVE8WALKEXPRERNS0_3CTXEjj
	jmp	.L6475
.L6514:
	nop
.L6315:
	cmp	QWORD PTR 560[rbp], 8
	jne	.L6515
	nop
.L6316:
	mov	rax, QWORD PTR 544[rbp]
	add	rax, 8
	mov	eax, DWORD PTR [rax]
	mov	rdx, QWORD PTR 656[rbp]
	mov	rdx, QWORD PTR [rdx]
	lea	rcx, 160[rdx]
	mov	edx, eax
	call	_ZN5ArrayIN3TKO13BINARYPAYLOADEEixEi
	mov	QWORD PTR 472[rbp], rax
	mov	rax, QWORD PTR 472[rbp]
	mov	QWORD PTR 464[rbp], rax
	mov	rax, QWORD PTR 464[rbp]
	add	rax, 4
	mov	eax, DWORD PTR [rax]
	mov	edx, DWORD PTR 672[rbp]
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 656[rbp]
	call	_ZN3TKO7RESOLVE8WALKEXPRERNS0_3CTXEjj
	mov	rax, QWORD PTR 464[rbp]
	add	rax, 8
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 656[rbp]
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN3TKO8ASTARENA4KINDEj
	mov	QWORD PTR 456[rbp], rax
	cmp	QWORD PTR 456[rbp], 28
	jne	.L6516
	mov	rax, QWORD PTR 464[rbp]
	add	rax, 8
	mov	eax, DWORD PTR [rax]
	mov	edx, DWORD PTR 672[rbp]
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 656[rbp]
	call	_ZN3TKO7RESOLVE14RESOLVETYPEREFERNS0_3CTXEjj
	jmp	.L6320
.L6516:
	nop
.L6319:
	mov	rax, QWORD PTR 464[rbp]
	add	rax, 8
	mov	eax, DWORD PTR [rax]
	mov	edx, DWORD PTR 672[rbp]
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 656[rbp]
	call	_ZN3TKO7RESOLVE8WALKEXPRERNS0_3CTXEjj
.L6320:
	mov	edx, DWORD PTR 672[rbp]
	mov	eax, DWORD PTR 664[rbp]
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 656[rbp]
	call	_ZN3TKO7RESOLVE15DIVBYCONSTZERO_ERNS0_3CTXEjj
	jmp	.L6475
.L6515:
	nop
.L6317:
	cmp	QWORD PTR 560[rbp], 11
	jne	.L6517
	nop
.L6321:
	mov	rax, QWORD PTR 544[rbp]
	add	rax, 8
	mov	eax, DWORD PTR [rax]
	mov	rdx, QWORD PTR 656[rbp]
	mov	rdx, QWORD PTR [rdx]
	lea	rcx, 160[rdx]
	mov	edx, eax
	call	_ZN5ArrayIN3TKO13BINARYPAYLOADEEixEi
	mov	QWORD PTR 448[rbp], rax
	mov	rax, QWORD PTR 448[rbp]
	mov	QWORD PTR 440[rbp], rax
	mov	rax, QWORD PTR 440[rbp]
	add	rax, 4
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	jne	.L6518
	mov	rax, QWORD PTR 656[rbp]
	add	rax, 72
	mov	rcx, rax
	call	_ZN5ArrayIjE5COUNTEv
	mov	DWORD PTR 436[rbp], eax
	cmp	DWORD PTR 436[rbp], 0
	jle	.L6519
	mov	rax, QWORD PTR 656[rbp]
	add	rax, 72
	mov	rcx, rax
	call	_ZN5ArrayIjE5COUNTEv
	mov	DWORD PTR 432[rbp], eax
	mov	eax, DWORD PTR 432[rbp]
	lea	edx, -1[rax]
	mov	rax, QWORD PTR 656[rbp]
	add	rax, 72
	mov	rcx, rax
	call	_ZN5ArrayIjEixEi
	mov	QWORD PTR 424[rbp], rax
	mov	rax, QWORD PTR 440[rbp]
	lea	rdx, 4[rax]
	mov	rax, QWORD PTR 424[rbp]
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR [rdx], eax
	jmp	.L6337
.L6519:
	nop
.L6326:
	mov	rax, QWORD PTR 440[rbp]
	add	rax, 8
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 656[rbp]
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN3TKO8ASTARENA4KINDEj
	mov	QWORD PTR 416[rbp], rax
	cmp	QWORD PTR 416[rbp], 6
	jne	.L6520
	mov	rax, QWORD PTR 440[rbp]
	add	rax, 8
	mov	eax, DWORD PTR [rax]
	mov	edx, eax
	mov	rcx, QWORD PTR 656[rbp]
	call	_ZN3TKO7RESOLVE11IDENTNAMEOFERNS0_3CTXEj
	mov	DWORD PTR 412[rbp], eax
	mov	eax, DWORD PTR 672[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 656[rbp]
	call	_ZN3TKO7RESOLVE12FILESCOPEOF_ERNS0_3CTXEj
	mov	DWORD PTR 408[rbp], eax
	mov	rax, QWORD PTR 656[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	ecx, DWORD PTR 412[rbp]
	mov	edx, DWORD PTR 408[rbp]
	mov	r9d, 0
	mov	r8d, ecx
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE17LOOKUPINNAMESPACEEjji
	mov	DWORD PTR 404[rbp], eax
	mov	eax, DWORD PTR 404[rbp]
	mov	DWORD PTR 636[rbp], eax
	cmp	DWORD PTR 636[rbp], 0
	jne	.L6521
	mov	rax, QWORD PTR 440[rbp]
	add	rax, 8
	mov	eax, DWORD PTR [rax]
	mov	edx, eax
	mov	rcx, QWORD PTR 656[rbp]
	call	_ZN3TKO7RESOLVE11IDENTNAMEOFERNS0_3CTXEj
	mov	DWORD PTR 400[rbp], eax
	mov	rax, QWORD PTR 656[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	ecx, DWORD PTR 400[rbp]
	mov	edx, DWORD PTR 672[rbp]
	mov	r8d, ecx
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE19LOOKUPTHROUGHUSINGSEjj
	mov	DWORD PTR 396[rbp], eax
	mov	eax, DWORD PTR 396[rbp]
	mov	DWORD PTR 636[rbp], eax
	jmp	.L6330
.L6329:
.L6521:
	nop
.L6330:
	cmp	DWORD PTR 636[rbp], 0
	je	.L6522
	mov	rax, QWORD PTR 440[rbp]
	add	rax, 8
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 656[rbp]
	add	rax, 48
	mov	rax, QWORD PTR [rax]
	mov	ecx, DWORD PTR 636[rbp]
	mov	r8d, ecx
	mov	rcx, rax
	call	_ZN3TKO12SEMANTICINFO6SETREFEjj
	mov	rax, QWORD PTR 656[rbp]
	add	rax, 48
	mov	rax, QWORD PTR [rax]
	mov	ecx, DWORD PTR 636[rbp]
	mov	edx, DWORD PTR 664[rbp]
	mov	r8d, ecx
	mov	rcx, rax
	call	_ZN3TKO12SEMANTICINFO6SETREFEjj
	jmp	.L6475
.L6324:
.L6332:
.L6333:
.L6334:
.L6335:
.L6336:
.L6518:
	nop
	jmp	.L6337
.L6520:
	nop
	jmp	.L6337
.L6522:
	nop
.L6337:
	mov	rax, QWORD PTR 440[rbp]
	add	rax, 4
	mov	eax, DWORD PTR [rax]
	mov	edx, DWORD PTR 672[rbp]
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 656[rbp]
	call	_ZN3TKO7RESOLVE8WALKEXPRERNS0_3CTXEjj
	mov	rax, QWORD PTR 440[rbp]
	add	rax, 4
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 656[rbp]
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN3TKO8ASTARENA4KINDEj
	mov	QWORD PTR 384[rbp], rax
	cmp	QWORD PTR 384[rbp], 27
	jne	.L6523
	mov	rax, QWORD PTR 440[rbp]
	add	rax, 8
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 656[rbp]
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN3TKO8ASTARENA4KINDEj
	mov	QWORD PTR 376[rbp], rax
	cmp	QWORD PTR 376[rbp], 6
	jne	.L6524
	mov	rax, QWORD PTR 440[rbp]
	add	rax, 8
	mov	eax, DWORD PTR [rax]
	mov	edx, eax
	mov	rcx, QWORD PTR 656[rbp]
	call	_ZN3TKO7RESOLVE11IDENTNAMEOFERNS0_3CTXEj
	mov	DWORD PTR 372[rbp], eax
	mov	eax, DWORD PTR 672[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 656[rbp]
	call	_ZN3TKO7RESOLVE12FILESCOPEOF_ERNS0_3CTXEj
	mov	DWORD PTR 368[rbp], eax
	mov	rax, QWORD PTR 656[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	ecx, DWORD PTR 372[rbp]
	mov	edx, DWORD PTR 368[rbp]
	mov	r9d, 0
	mov	r8d, ecx
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE17LOOKUPINNAMESPACEEjji
	mov	DWORD PTR 364[rbp], eax
	mov	eax, DWORD PTR 364[rbp]
	mov	DWORD PTR 360[rbp], eax
	cmp	DWORD PTR 360[rbp], 0
	je	.L6525
	mov	rax, QWORD PTR 440[rbp]
	add	rax, 8
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 656[rbp]
	add	rax, 48
	mov	rax, QWORD PTR [rax]
	mov	ecx, DWORD PTR 360[rbp]
	mov	r8d, ecx
	mov	rcx, rax
	call	_ZN3TKO12SEMANTICINFO6SETREFEjj
	mov	rax, QWORD PTR 656[rbp]
	add	rax, 48
	mov	rax, QWORD PTR [rax]
	mov	ecx, DWORD PTR 360[rbp]
	mov	edx, DWORD PTR 664[rbp]
	mov	r8d, ecx
	mov	rcx, rax
	call	_ZN3TKO12SEMANTICINFO6SETREFEjj
	jmp	.L6475
.L6341:
.L6343:
.L6344:
.L6524:
	nop
	jmp	.L6475
.L6525:
	nop
.L6345:
	jmp	.L6475
.L6339:
.L6523:
	nop
.L6346:
	mov	rax, QWORD PTR 440[rbp]
	add	rax, 4
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 656[rbp]
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN3TKO8ASTARENA4KINDEj
	mov	QWORD PTR 352[rbp], rax
	cmp	QWORD PTR 352[rbp], 6
	jne	.L6526
	mov	rax, QWORD PTR 440[rbp]
	add	rax, 4
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 656[rbp]
	add	rax, 48
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN3TKO12SEMANTICINFO5REFOFEj
	mov	DWORD PTR 348[rbp], eax
	mov	rax, QWORD PTR 656[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 348[rbp]
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE8SYMBOLATEj
	mov	QWORD PTR 336[rbp], rax
	mov	rax, QWORD PTR 336[rbp]
	mov	QWORD PTR 328[rbp], rax
	cmp	QWORD PTR 328[rbp], 0
	je	.L6527
	mov	rax, QWORD PTR 328[rbp]
	movzx	eax, BYTE PTR [rax]
	cmp	al, 5
	jne	.L6528
	mov	rax, QWORD PTR 440[rbp]
	add	rax, 8
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 656[rbp]
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN3TKO8ASTARENA4KINDEj
	mov	QWORD PTR 320[rbp], rax
	cmp	QWORD PTR 320[rbp], 6
	jne	.L6529
	mov	rax, QWORD PTR 440[rbp]
	add	rax, 4
	mov	eax, DWORD PTR [rax]
	mov	edx, eax
	mov	rcx, QWORD PTR 656[rbp]
	call	_ZN3TKO7RESOLVE11IDENTNAMEOFERNS0_3CTXEj
	mov	DWORD PTR 316[rbp], eax
	mov	rax, QWORD PTR 656[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	ecx, DWORD PTR 316[rbp]
	mov	edx, DWORD PTR 672[rbp]
	mov	r9d, 1
	mov	r8d, ecx
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE11LOOKUPTYPEDEjjb
	mov	DWORD PTR 312[rbp], eax
	mov	eax, DWORD PTR 312[rbp]
	mov	DWORD PTR 308[rbp], eax
	mov	rax, QWORD PTR 656[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 308[rbp]
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE8SYMBOLATEj
	mov	QWORD PTR 296[rbp], rax
	mov	rax, QWORD PTR 296[rbp]
	mov	QWORD PTR 288[rbp], rax
	cmp	QWORD PTR 288[rbp], 0
	je	.L6530
	mov	rax, QWORD PTR 288[rbp]
	movzx	eax, BYTE PTR [rax]
	cmp	al, 6
	sete	al
	mov	BYTE PTR 287[rbp], al
	mov	rax, QWORD PTR 288[rbp]
	add	rax, 36
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	setne	al
	mov	BYTE PTR 286[rbp], al
	cmp	BYTE PTR 287[rbp], 0
	je	.L6531
	cmp	BYTE PTR 286[rbp], 0
	setne	al
	mov	BYTE PTR 635[rbp], al
	jmp	.L6355
.L6531:
	nop
.L6354:
	mov	BYTE PTR 635[rbp], 0
.L6355:
	cmp	BYTE PTR 635[rbp], 0
	je	.L6532
	mov	rax, QWORD PTR 440[rbp]
	add	rax, 8
	mov	eax, DWORD PTR [rax]
	mov	edx, eax
	mov	rcx, QWORD PTR 656[rbp]
	call	_ZN3TKO7RESOLVE11IDENTNAMEOFERNS0_3CTXEj
	mov	DWORD PTR 280[rbp], eax
	mov	rax, QWORD PTR 288[rbp]
	add	rax, 36
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 656[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	ecx, DWORD PTR 280[rbp]
	mov	r8d, ecx
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE11LOOKUPLOCALEjj
	mov	DWORD PTR 276[rbp], eax
	mov	eax, DWORD PTR 276[rbp]
	mov	DWORD PTR 272[rbp], eax
	cmp	DWORD PTR 272[rbp], 0
	je	.L6533
	mov	rax, QWORD PTR 440[rbp]
	add	rax, 4
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 656[rbp]
	add	rax, 48
	mov	rax, QWORD PTR [rax]
	mov	ecx, DWORD PTR 308[rbp]
	mov	r8d, ecx
	mov	rcx, rax
	call	_ZN3TKO12SEMANTICINFO6SETREFEjj
	jmp	.L6370
.L6348:
.L6358:
.L6359:
.L6360:
.L6361:
.L6362:
.L6363:
.L6364:
.L6365:
.L6366:
.L6367:
.L6368:
.L6369:
.L6526:
	nop
	jmp	.L6370
.L6527:
	nop
	jmp	.L6370
.L6528:
	nop
	jmp	.L6370
.L6529:
	nop
	jmp	.L6370
.L6530:
	nop
	jmp	.L6370
.L6532:
	nop
	jmp	.L6370
.L6533:
	nop
.L6370:
	mov	rax, QWORD PTR 440[rbp]
	add	rax, 4
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 656[rbp]
	add	rax, 48
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN3TKO12SEMANTICINFO5REFOFEj
	mov	DWORD PTR 268[rbp], eax
	mov	eax, DWORD PTR 268[rbp]
	mov	DWORD PTR 264[rbp], eax
	mov	rax, QWORD PTR 656[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 264[rbp]
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE8SYMBOLATEj
	mov	QWORD PTR 256[rbp], rax
	mov	rax, QWORD PTR 256[rbp]
	mov	QWORD PTR 248[rbp], rax
	cmp	QWORD PTR 248[rbp], 0
	je	.L6534
	mov	rax, QWORD PTR 248[rbp]
	movzx	eax, BYTE PTR [rax]
	cmp	al, 10
	jne	.L6535
	mov	rax, QWORD PTR 440[rbp]
	add	rax, 8
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 656[rbp]
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN3TKO8ASTARENA4KINDEj
	mov	QWORD PTR 240[rbp], rax
	cmp	QWORD PTR 240[rbp], 6
	jne	.L6536
	mov	rax, QWORD PTR 440[rbp]
	add	rax, 8
	mov	eax, DWORD PTR [rax]
	mov	edx, eax
	mov	rcx, QWORD PTR 656[rbp]
	call	_ZN3TKO7RESOLVE11IDENTNAMEOFERNS0_3CTXEj
	mov	DWORD PTR 236[rbp], eax
	mov	rax, QWORD PTR 248[rbp]
	add	rax, 36
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 656[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	ecx, DWORD PTR 236[rbp]
	mov	r9d, 0
	mov	r8d, ecx
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE17LOOKUPINNAMESPACEEjji
	mov	DWORD PTR 232[rbp], eax
	mov	eax, DWORD PTR 232[rbp]
	mov	DWORD PTR 228[rbp], eax
	cmp	DWORD PTR 228[rbp], 0
	je	.L6537
	mov	rax, QWORD PTR 440[rbp]
	add	rax, 8
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 656[rbp]
	add	rax, 48
	mov	rax, QWORD PTR [rax]
	mov	ecx, DWORD PTR 228[rbp]
	mov	r8d, ecx
	mov	rcx, rax
	call	_ZN3TKO12SEMANTICINFO6SETREFEjj
	mov	rax, QWORD PTR 656[rbp]
	add	rax, 48
	mov	rax, QWORD PTR [rax]
	mov	ecx, DWORD PTR 228[rbp]
	mov	edx, DWORD PTR 664[rbp]
	mov	r8d, ecx
	mov	rcx, rax
	call	_ZN3TKO12SEMANTICINFO6SETREFEjj
	jmp	.L6419
.L6376:
.L6378:
.L6379:
.L6536:
	nop
	jmp	.L6419
.L6537:
	nop
.L6380:
	jmp	.L6419
.L6535:
	nop
.L6374:
	mov	rax, QWORD PTR 248[rbp]
	movzx	eax, BYTE PTR [rax]
	cmp	al, 7
	jne	.L6538
	mov	rax, QWORD PTR 440[rbp]
	add	rax, 8
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 656[rbp]
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN3TKO8ASTARENA4KINDEj
	mov	QWORD PTR 216[rbp], rax
	cmp	QWORD PTR 216[rbp], 6
	jne	.L6539
	mov	rax, QWORD PTR 440[rbp]
	add	rax, 8
	mov	eax, DWORD PTR [rax]
	mov	edx, eax
	mov	rcx, QWORD PTR 656[rbp]
	call	_ZN3TKO7RESOLVE11IDENTNAMEOFERNS0_3CTXEj
	mov	DWORD PTR 212[rbp], eax
	mov	rax, QWORD PTR 248[rbp]
	add	rax, 36
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 656[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	ecx, DWORD PTR 212[rbp]
	mov	r8d, ecx
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE11LOOKUPLOCALEjj
	mov	DWORD PTR 208[rbp], eax
	mov	eax, DWORD PTR 208[rbp]
	mov	DWORD PTR 204[rbp], eax
	cmp	DWORD PTR 204[rbp], 0
	je	.L6540
	mov	rax, QWORD PTR 440[rbp]
	add	rax, 8
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 656[rbp]
	add	rax, 48
	mov	rax, QWORD PTR [rax]
	mov	ecx, DWORD PTR 204[rbp]
	mov	r8d, ecx
	mov	rcx, rax
	call	_ZN3TKO12SEMANTICINFO6SETREFEjj
	mov	rax, QWORD PTR 656[rbp]
	add	rax, 48
	mov	rax, QWORD PTR [rax]
	mov	ecx, DWORD PTR 204[rbp]
	mov	edx, DWORD PTR 664[rbp]
	mov	r8d, ecx
	mov	rcx, rax
	call	_ZN3TKO12SEMANTICINFO6SETREFEjj
	jmp	.L6419
.L6384:
.L6386:
.L6387:
.L6539:
	nop
	jmp	.L6419
.L6540:
	nop
.L6388:
	jmp	.L6419
.L6538:
	nop
.L6382:
	mov	rax, QWORD PTR 248[rbp]
	movzx	eax, BYTE PTR [rax]
	cmp	al, 6
	jne	.L6541
	mov	rax, QWORD PTR 440[rbp]
	add	rax, 8
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 656[rbp]
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN3TKO8ASTARENA4KINDEj
	mov	QWORD PTR 192[rbp], rax
	cmp	QWORD PTR 192[rbp], 6
	jne	.L6542
	mov	rax, QWORD PTR 440[rbp]
	add	rax, 8
	mov	eax, DWORD PTR [rax]
	mov	edx, eax
	mov	rcx, QWORD PTR 656[rbp]
	call	_ZN3TKO7RESOLVE11IDENTNAMEOFERNS0_3CTXEj
	mov	DWORD PTR 188[rbp], eax
	mov	rax, QWORD PTR 248[rbp]
	add	rax, 36
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 656[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	ecx, DWORD PTR 188[rbp]
	mov	r8d, ecx
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE11LOOKUPLOCALEjj
	mov	DWORD PTR 184[rbp], eax
	mov	eax, DWORD PTR 184[rbp]
	mov	DWORD PTR 616[rbp], eax
	mov	rax, QWORD PTR 248[rbp]
	mov	eax, DWORD PTR 36[rax]
	mov	DWORD PTR 612[rbp], eax
	mov	DWORD PTR 608[rbp], 0
.L6391:
	cmp	DWORD PTR 616[rbp], 0
	jne	.L6543
	cmp	DWORD PTR 608[rbp], 31
	setle	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR 624[rbp], rax
	jmp	.L6394
.L6543:
	nop
.L6393:
	mov	QWORD PTR 624[rbp], 0
.L6394:
	cmp	QWORD PTR 624[rbp], 0
	je	.L6544
	mov	eax, DWORD PTR 612[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 656[rbp]
	call	_ZN3TKO7RESOLVE12BASESCOPEOF_ERNS0_3CTXEj
	mov	DWORD PTR 180[rbp], eax
	mov	eax, DWORD PTR 180[rbp]
	mov	DWORD PTR 612[rbp], eax
	cmp	DWORD PTR 612[rbp], 0
	je	.L6545
	nop
.L6398:
	mov	rax, QWORD PTR 440[rbp]
	add	rax, 8
	mov	eax, DWORD PTR [rax]
	mov	edx, eax
	mov	rcx, QWORD PTR 656[rbp]
	call	_ZN3TKO7RESOLVE11IDENTNAMEOFERNS0_3CTXEj
	mov	DWORD PTR 176[rbp], eax
	mov	rax, QWORD PTR 656[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	ecx, DWORD PTR 176[rbp]
	mov	edx, DWORD PTR 612[rbp]
	mov	r8d, ecx
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE11LOOKUPLOCALEjj
	mov	DWORD PTR 172[rbp], eax
	mov	eax, DWORD PTR 172[rbp]
	mov	DWORD PTR 616[rbp], eax
	add	DWORD PTR 608[rbp], 1
	jmp	.L6391
.L6544:
	nop
	jmp	.L6396
.L6545:
	nop
.L6396:
	mov	rax, QWORD PTR 656[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 616[rbp]
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE8SYMBOLATEj
	mov	QWORD PTR 160[rbp], rax
	mov	rax, QWORD PTR 160[rbp]
	mov	QWORD PTR 152[rbp], rax
	mov	BYTE PTR 607[rbp], 0
	cmp	QWORD PTR 152[rbp], 0
	je	.L6546
	mov	rax, QWORD PTR 152[rbp]
	movzx	eax, BYTE PTR [rax]
	movzx	eax, al
	mov	QWORD PTR 144[rbp], rax
	cmp	QWORD PTR 144[rbp], 3
	je	.L6547
	nop
.L6401:
	cmp	QWORD PTR 144[rbp], 8
	je	.L6548
	nop
.L6403:
	cmp	QWORD PTR 144[rbp], 6
	je	.L6549
	nop
.L6404:
	cmp	QWORD PTR 144[rbp], 7
	je	.L6550
	nop
.L6405:
	cmp	QWORD PTR 144[rbp], 9
	jne	.L6551
	jmp	.L6402
.L6547:
	nop
	jmp	.L6402
.L6548:
	nop
	jmp	.L6402
.L6549:
	nop
	jmp	.L6402
.L6550:
	nop
.L6402:
	mov	BYTE PTR 607[rbp], 1
	jmp	.L6408
.L6400:
.L6406:
.L6407:
.L6546:
	nop
	jmp	.L6408
.L6551:
	nop
.L6408:
	mov	eax, DWORD PTR 616[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 656[rbp]
	call	_ZN3TKO7RESOLVE13ISSTATICPROC_ERNS0_3CTXEj
	mov	BYTE PTR 143[rbp], al
	cmp	BYTE PTR 143[rbp], 0
	jne	.L6552
	cmp	BYTE PTR 607[rbp], 0
	setne	al
	mov	BYTE PTR 623[rbp], al
	jmp	.L6411
.L6552:
	nop
.L6410:
	mov	BYTE PTR 623[rbp], 1
.L6411:
	cmp	BYTE PTR 623[rbp], 0
	je	.L6553
	mov	rax, QWORD PTR 440[rbp]
	add	rax, 8
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 656[rbp]
	add	rax, 48
	mov	rax, QWORD PTR [rax]
	mov	ecx, DWORD PTR 616[rbp]
	mov	r8d, ecx
	mov	rcx, rax
	call	_ZN3TKO12SEMANTICINFO6SETREFEjj
	mov	rax, QWORD PTR 656[rbp]
	add	rax, 48
	mov	rax, QWORD PTR [rax]
	mov	ecx, DWORD PTR 616[rbp]
	mov	edx, DWORD PTR 664[rbp]
	mov	r8d, ecx
	mov	rcx, rax
	call	_ZN3TKO12SEMANTICINFO6SETREFEjj
	jmp	.L6475
.L6372:
.L6413:
.L6414:
.L6415:
.L6416:
.L6417:
.L6418:
.L6534:
	nop
	jmp	.L6475
.L6541:
	nop
	jmp	.L6475
.L6542:
	nop
	jmp	.L6475
.L6553:
	nop
.L6419:
	jmp	.L6475
.L6517:
	nop
.L6322:
	cmp	QWORD PTR 560[rbp], 22
	jne	.L6554
	nop
.L6420:
	mov	eax, DWORD PTR 664[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 656[rbp]
	call	_ZN3TKO7RESOLVE6LISTOFERNS0_3CTXEj
	mov	QWORD PTR 128[rbp], rax
	mov	rax, QWORD PTR 128[rbp]
	mov	QWORD PTR 120[rbp], rax
	mov	rax, QWORD PTR 120[rbp]
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	je	.L6555
	mov	rax, QWORD PTR 120[rbp]
	mov	eax, DWORD PTR [rax]
	mov	edx, DWORD PTR 672[rbp]
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 656[rbp]
	call	_ZN3TKO7RESOLVE14RESOLVETYPEREFERNS0_3CTXEjj
	mov	DWORD PTR 116[rbp], eax
	mov	eax, DWORD PTR 116[rbp]
	mov	DWORD PTR 112[rbp], eax
	cmp	DWORD PTR 112[rbp], 0
	je	.L6556
	mov	rax, QWORD PTR 120[rbp]
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 656[rbp]
	add	rax, 48
	mov	rax, QWORD PTR [rax]
	mov	ecx, DWORD PTR 112[rbp]
	mov	r8d, ecx
	mov	rcx, rax
	call	_ZN3TKO12SEMANTICINFO7SETTYPEEjj
	jmp	.L6426
.L6423:
.L6425:
.L6555:
	nop
	jmp	.L6426
.L6556:
	nop
.L6426:
	mov	DWORD PTR 600[rbp], 0
	mov	rax, QWORD PTR 120[rbp]
	add	rax, 8
	mov	eax, DWORD PTR [rax]
	sub	eax, 1
	mov	DWORD PTR 108[rbp], eax
	jmp	.L6427
.L6557:
	nop
.L6428:
	mov	rax, QWORD PTR 120[rbp]
	add	rax, 4
	mov	edx, DWORD PTR [rax]
	mov	eax, DWORD PTR 600[rbp]
	add	edx, eax
	mov	rax, QWORD PTR 656[rbp]
	mov	rax, QWORD PTR [rax]
	add	rax, 560
	mov	rcx, rax
	call	_ZN5ArrayIjEixEi
	mov	QWORD PTR 96[rbp], rax
	mov	rax, QWORD PTR 96[rbp]
	mov	eax, DWORD PTR [rax]
	mov	edx, DWORD PTR 672[rbp]
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 656[rbp]
	call	_ZN3TKO7RESOLVE8WALKEXPRERNS0_3CTXEjj
.L6429:
	add	DWORD PTR 600[rbp], 1
.L6427:
	mov	eax, DWORD PTR 600[rbp]
	cmp	eax, DWORD PTR 108[rbp]
	jle	.L6557
	nop
.L6430:
	jmp	.L6475
.L6554:
	nop
.L6421:
	cmp	QWORD PTR 560[rbp], 51
	jne	.L6558
	nop
.L6431:
	mov	eax, DWORD PTR 664[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 656[rbp]
	call	_ZN3TKO7RESOLVE6STMTOFERNS0_3CTXEj
	mov	QWORD PTR 88[rbp], rax
	mov	rax, QWORD PTR 88[rbp]
	mov	QWORD PTR 80[rbp], rax
	mov	rax, QWORD PTR 80[rbp]
	add	rax, 4
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	je	.L6559
	mov	rax, QWORD PTR 80[rbp]
	add	rax, 4
	mov	eax, DWORD PTR [rax]
	mov	edx, DWORD PTR 672[rbp]
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 656[rbp]
	call	_ZN3TKO7RESOLVE8WALKEXPRERNS0_3CTXEjj
	jmp	.L6434
.L6559:
	nop
.L6434:
	mov	rax, QWORD PTR 80[rbp]
	add	rax, 8
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	je	.L6560
	mov	rax, QWORD PTR 80[rbp]
	add	rax, 8
	mov	eax, DWORD PTR [rax]
	mov	edx, DWORD PTR 672[rbp]
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 656[rbp]
	call	_ZN3TKO7RESOLVE8WALKEXPRERNS0_3CTXEjj
	jmp	.L6436
.L6560:
	nop
.L6436:
	mov	rax, QWORD PTR 80[rbp]
	add	rax, 12
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	je	.L6561
	mov	rax, QWORD PTR 80[rbp]
	add	rax, 12
	mov	eax, DWORD PTR [rax]
	mov	edx, DWORD PTR 672[rbp]
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 656[rbp]
	call	_ZN3TKO7RESOLVE8WALKEXPRERNS0_3CTXEjj
	jmp	.L6438
.L6561:
	nop
.L6438:
	mov	DWORD PTR 596[rbp], 0
	mov	rax, QWORD PTR 80[rbp]
	add	rax, 20
	mov	eax, DWORD PTR [rax]
	sub	eax, 1
	mov	DWORD PTR 76[rbp], eax
	jmp	.L6439
.L6563:
	nop
.L6440:
	mov	rax, QWORD PTR 80[rbp]
	add	rax, 16
	mov	edx, DWORD PTR [rax]
	mov	eax, DWORD PTR 596[rbp]
	add	edx, eax
	mov	rax, QWORD PTR 656[rbp]
	mov	rax, QWORD PTR [rax]
	add	rax, 560
	mov	rcx, rax
	call	_ZN5ArrayIjEixEi
	mov	QWORD PTR 64[rbp], rax
	mov	rax, QWORD PTR 64[rbp]
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR 60[rbp], eax
	mov	rax, QWORD PTR 656[rbp]
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 60[rbp]
	mov	rcx, rax
	call	_ZN3TKO8ASTARENA4KINDEj
	mov	QWORD PTR 48[rbp], rax
	cmp	QWORD PTR 48[rbp], 26
	je	.L6562
	mov	edx, DWORD PTR 672[rbp]
	mov	eax, DWORD PTR 60[rbp]
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 656[rbp]
	call	_ZN3TKO7RESOLVE8WALKEXPRERNS0_3CTXEjj
	jmp	.L6443
.L6442:
.L6562:
	nop
.L6443:
	add	DWORD PTR 596[rbp], 1
.L6439:
	mov	eax, DWORD PTR 596[rbp]
	cmp	eax, DWORD PTR 76[rbp]
	jle	.L6563
	nop
.L6444:
	jmp	.L6475
.L6558:
	nop
.L6432:
	cmp	QWORD PTR 560[rbp], 9
	je	.L6564
	nop
.L6445:
	cmp	QWORD PTR 560[rbp], 10
	je	.L6565
	nop
.L6447:
	cmp	QWORD PTR 560[rbp], 18
	je	.L6566
	nop
.L6448:
	cmp	QWORD PTR 560[rbp], 19
	je	.L6567
	nop
.L6449:
	cmp	QWORD PTR 560[rbp], 20
	je	.L6568
	nop
.L6450:
	cmp	QWORD PTR 560[rbp], 5
	jne	.L6569
	jmp	.L6446
.L6564:
	nop
	jmp	.L6446
.L6565:
	nop
	jmp	.L6446
.L6566:
	nop
	jmp	.L6446
.L6567:
	nop
	jmp	.L6446
.L6568:
	nop
.L6446:
	mov	eax, DWORD PTR 664[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 656[rbp]
	call	_ZN3TKO7RESOLVE6LISTOFERNS0_3CTXEj
	mov	QWORD PTR 40[rbp], rax
	mov	rax, QWORD PTR 40[rbp]
	mov	QWORD PTR 32[rbp], rax
	mov	rax, QWORD PTR 32[rbp]
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	je	.L6570
	mov	rax, QWORD PTR 32[rbp]
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 656[rbp]
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN3TKO8ASTARENA4KINDEj
	mov	QWORD PTR 24[rbp], rax
	cmp	QWORD PTR 24[rbp], 28
	sete	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR 584[rbp], rax
	jmp	.L6453
.L6570:
	nop
.L6452:
	mov	QWORD PTR 584[rbp], 0
.L6453:
	cmp	QWORD PTR 584[rbp], 0
	je	.L6571
	mov	rax, QWORD PTR 32[rbp]
	mov	eax, DWORD PTR [rax]
	mov	edx, DWORD PTR 672[rbp]
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 656[rbp]
	call	_ZN3TKO7RESOLVE14RESOLVETYPEREFERNS0_3CTXEjj
	jmp	.L6456
.L6571:
	nop
.L6455:
	mov	rax, QWORD PTR 32[rbp]
	mov	eax, DWORD PTR [rax]
	mov	edx, DWORD PTR 672[rbp]
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 656[rbp]
	call	_ZN3TKO7RESOLVE8WALKEXPRERNS0_3CTXEjj
.L6456:
	mov	DWORD PTR 580[rbp], 0
	mov	rax, QWORD PTR 32[rbp]
	add	rax, 8
	mov	eax, DWORD PTR [rax]
	sub	eax, 1
	mov	DWORD PTR 20[rbp], eax
	jmp	.L6457
.L6573:
	nop
.L6458:
	mov	rax, QWORD PTR 32[rbp]
	add	rax, 4
	mov	edx, DWORD PTR [rax]
	mov	eax, DWORD PTR 580[rbp]
	add	edx, eax
	mov	rax, QWORD PTR 656[rbp]
	mov	rax, QWORD PTR [rax]
	add	rax, 560
	mov	rcx, rax
	call	_ZN5ArrayIjEixEi
	mov	QWORD PTR -24[rbp], rax
	mov	rax, QWORD PTR -24[rbp]
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR -28[rbp], eax
	mov	rax, QWORD PTR 656[rbp]
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR -28[rbp]
	mov	rcx, rax
	call	_ZN3TKO8ASTARENA4KINDEj
	mov	QWORD PTR -40[rbp], rax
	cmp	QWORD PTR -40[rbp], 28
	jne	.L6572
	mov	edx, DWORD PTR 672[rbp]
	mov	eax, DWORD PTR -28[rbp]
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 656[rbp]
	call	_ZN3TKO7RESOLVE14RESOLVETYPEREFERNS0_3CTXEjj
	jmp	.L6462
.L6572:
	nop
.L6460:
	mov	edx, DWORD PTR 672[rbp]
	mov	eax, DWORD PTR -28[rbp]
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 656[rbp]
	call	_ZN3TKO7RESOLVE8WALKEXPRERNS0_3CTXEjj
.L6461:
.L6462:
	add	DWORD PTR 580[rbp], 1
.L6457:
	mov	eax, DWORD PTR 580[rbp]
	cmp	eax, DWORD PTR 20[rbp]
	jle	.L6573
	nop
.L6463:
	mov	rax, QWORD PTR 656[rbp]
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 664[rbp]
	mov	rcx, rax
	call	_ZN3TKO8ASTARENA4KINDEj
	mov	QWORD PTR 8[rbp], rax
	cmp	QWORD PTR 8[rbp], 9
	jne	.L6574
	mov	edx, DWORD PTR 672[rbp]
	mov	eax, DWORD PTR 664[rbp]
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 656[rbp]
	call	_ZN3TKO7RESOLVE23INSTANTIATEGENERICPROC_ERNS0_3CTXEjj
	mov	DWORD PTR 4[rbp], eax
	mov	eax, DWORD PTR 4[rbp]
	mov	DWORD PTR 0[rbp], eax
	cmp	DWORD PTR 0[rbp], 0
	je	.L6575
	mov	rax, QWORD PTR 656[rbp]
	add	rax, 48
	mov	rax, QWORD PTR [rax]
	mov	ecx, DWORD PTR 0[rbp]
	mov	edx, DWORD PTR 664[rbp]
	mov	r8d, ecx
	mov	rcx, rax
	call	_ZN3TKO12SEMANTICINFO6SETREFEjj
	mov	rax, QWORD PTR 32[rbp]
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 656[rbp]
	add	rax, 48
	mov	rax, QWORD PTR [rax]
	mov	ecx, DWORD PTR 0[rbp]
	mov	r8d, ecx
	mov	rcx, rax
	call	_ZN3TKO12SEMANTICINFO6SETREFEjj
	jmp	.L6475
.L6575:
	nop
.L6466:
	mov	ecx, DWORD PTR 672[rbp]
	mov	rdx, QWORD PTR 32[rbp]
	mov	eax, DWORD PTR 664[rbp]
	mov	r9d, ecx
	mov	r8, rdx
	mov	edx, eax
	mov	rcx, QWORD PTR 656[rbp]
	call	_ZN3TKO7RESOLVE16GENERICCTORCALL_ERNS0_3CTXEjPNS_11LISTPAYLOADEj
	mov	BYTE PTR -1[rbp], al
	cmp	BYTE PTR -1[rbp], 0
	jne	.L6576
	nop
.L6468:
	mov	rax, QWORD PTR 656[rbp]
	add	rax, 48
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 664[rbp]
	mov	rcx, rax
	call	_ZN3TKO12SEMANTICINFO5REFOFEj
	mov	DWORD PTR -8[rbp], eax
	cmp	DWORD PTR -8[rbp], 0
	jne	.L6577
	mov	rax, QWORD PTR 32[rbp]
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 656[rbp]
	add	rax, 48
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN3TKO12SEMANTICINFO5REFOFEj
	mov	DWORD PTR -12[rbp], eax
	mov	rax, QWORD PTR 656[rbp]
	add	rax, 48
	mov	rax, QWORD PTR [rax]
	mov	ecx, DWORD PTR -12[rbp]
	mov	edx, DWORD PTR 664[rbp]
	mov	r8d, ecx
	mov	rcx, rax
	call	_ZN3TKO12SEMANTICINFO6SETREFEjj
	jmp	.L6578
.L6289:
.L6470:
.L6471:
.L6472:
.L6473:
.L6474:
.L6502:
	nop
	jmp	.L6578
.L6569:
	nop
	jmp	.L6578
.L6574:
	nop
	jmp	.L6578
.L6576:
	nop
	jmp	.L6578
.L6577:
	nop
.L6475:
.L6578:
	nop
	add	rsp, 768
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN3TKO7RESOLVE21READCALLASSIGNASCALL_ERNS0_3CTXEjPNS_11STMTPAYLOADEj;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN3TKO7RESOLVE21READCALLASSIGNASCALL_ERNS0_3CTXEjPNS_11STMTPAYLOADEj
_ZN3TKO7RESOLVE21READCALLASSIGNASCALL_ERNS0_3CTXEjPNS_11STMTPAYLOADEj:
	push	rbp
	.seh_pushreg	rbp
	sub	rsp, 320
	.seh_stackalloc	320
	lea	rbp, 128[rsp]
	.seh_setframe	rbp, 128
	.seh_endprologue
	mov	QWORD PTR 208[rbp], rcx
	mov	DWORD PTR 216[rbp], edx
	mov	QWORD PTR 224[rbp], r8
	mov	DWORD PTR 232[rbp], r9d
	mov	BYTE PTR -57[rbp], 0
.L6580:
	mov	rax, QWORD PTR 224[rbp]
	add	rax, 4
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	jne	.L6644
	mov	BYTE PTR -57[rbp], 0
	jmp	.L6583
.L6644:
	nop
.L6582:
	mov	rax, QWORD PTR 224[rbp]
	add	rax, 8
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	jne	.L6645
	mov	BYTE PTR -57[rbp], 0
	jmp	.L6583
.L6645:
	nop
.L6585:
	mov	rax, QWORD PTR 224[rbp]
	add	rax, 4
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 208[rbp]
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN3TKO8ASTARENA4KINDEj
	mov	QWORD PTR 168[rbp], rax
	cmp	QWORD PTR 168[rbp], 9
	je	.L6646
	mov	BYTE PTR -57[rbp], 0
	jmp	.L6583
.L6646:
	nop
.L6587:
	mov	rax, QWORD PTR 224[rbp]
	add	rax, 24
	movzx	eax, WORD PTR [rax]
	cmp	ax, 24
	je	.L6647
	mov	BYTE PTR -57[rbp], 0
	jmp	.L6583
.L6647:
	nop
.L6589:
	mov	rax, QWORD PTR 208[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 232[rbp]
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE8SYMBOLATEj
	mov	QWORD PTR 160[rbp], rax
	mov	rax, QWORD PTR 160[rbp]
	mov	QWORD PTR 184[rbp], rax
	cmp	QWORD PTR 184[rbp], 0
	je	.L6648
	mov	rax, QWORD PTR 184[rbp]
	movzx	eax, BYTE PTR [rax]
	cmp	al, 5
	je	.L6649
	mov	rax, QWORD PTR 224[rbp]
	add	rax, 4
	mov	eax, DWORD PTR [rax]
	mov	edx, eax
	mov	rcx, QWORD PTR 208[rbp]
	call	_ZN3TKO7RESOLVE6LISTOFERNS0_3CTXEj
	mov	QWORD PTR 152[rbp], rax
	mov	rax, QWORD PTR 152[rbp]
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR 148[rbp], eax
	mov	rax, QWORD PTR 208[rbp]
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 148[rbp]
	mov	rcx, rax
	call	_ZN3TKO8ASTARENA4KINDEj
	mov	QWORD PTR 136[rbp], rax
	cmp	QWORD PTR 136[rbp], 11
	jne	.L6650
	mov	edx, DWORD PTR 148[rbp]
	mov	rax, QWORD PTR 208[rbp]
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN5ArrayIN3TKO7ASTNODEEEixEi
	mov	QWORD PTR 128[rbp], rax
	mov	rax, QWORD PTR 128[rbp]
	add	rax, 8
	mov	eax, DWORD PTR [rax]
	mov	rdx, QWORD PTR 208[rbp]
	mov	rdx, QWORD PTR [rdx]
	lea	rcx, 160[rdx]
	mov	edx, eax
	call	_ZN5ArrayIN3TKO13BINARYPAYLOADEEixEi
	mov	QWORD PTR 120[rbp], rax
	mov	rax, QWORD PTR 120[rbp]
	mov	QWORD PTR 112[rbp], rax
	mov	rax, QWORD PTR 184[rbp]
	add	rax, 16
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 208[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT9UNQUALIFYEj
	mov	DWORD PTR 108[rbp], eax
	mov	eax, DWORD PTR 108[rbp]
	mov	DWORD PTR 104[rbp], eax
	mov	rax, QWORD PTR 208[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 104[rbp]
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT4KINDEj
	mov	QWORD PTR 96[rbp], rax
	cmp	QWORD PTR 96[rbp], 6
	jne	.L6651
	mov	rax, QWORD PTR 208[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 104[rbp]
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT6NAMEOFEj
	mov	DWORD PTR 92[rbp], eax
	mov	eax, DWORD PTR 92[rbp]
	mov	DWORD PTR 88[rbp], eax
	cmp	DWORD PTR 88[rbp], 0
	je	.L6652
	mov	rax, QWORD PTR 208[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 104[rbp]
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT11DECLSCOPEOFEj
	mov	DWORD PTR 84[rbp], eax
	mov	eax, DWORD PTR 84[rbp]
	mov	DWORD PTR 80[rbp], eax
	mov	rax, QWORD PTR 208[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	ecx, DWORD PTR 88[rbp]
	mov	edx, DWORD PTR 80[rbp]
	mov	r9d, 1
	mov	r8d, ecx
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE16LOOKUPLOCALTYPEDEjjb
	mov	DWORD PTR 76[rbp], eax
	mov	eax, DWORD PTR 76[rbp]
	mov	DWORD PTR 180[rbp], eax
	cmp	DWORD PTR 180[rbp], 0
	jne	.L6653
	mov	rax, QWORD PTR 208[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	ecx, DWORD PTR 88[rbp]
	mov	edx, DWORD PTR 80[rbp]
	mov	r9d, 1
	mov	r8d, ecx
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE11LOOKUPTYPEDEjjb
	mov	DWORD PTR 72[rbp], eax
	mov	eax, DWORD PTR 72[rbp]
	mov	DWORD PTR 180[rbp], eax
	jmp	.L6597
.L6653:
	nop
.L6597:
	mov	rax, QWORD PTR 208[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 180[rbp]
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE8SYMBOLATEj
	mov	QWORD PTR 64[rbp], rax
	mov	rax, QWORD PTR 64[rbp]
	mov	QWORD PTR 56[rbp], rax
	cmp	QWORD PTR 56[rbp], 0
	je	.L6654
	mov	rax, QWORD PTR 56[rbp]
	add	rax, 36
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	je	.L6655
	mov	rax, QWORD PTR 112[rbp]
	add	rax, 8
	mov	eax, DWORD PTR [rax]
	mov	edx, eax
	mov	rcx, QWORD PTR 208[rbp]
	call	_ZN3TKO7RESOLVE11IDENTNAMEOFERNS0_3CTXEj
	mov	DWORD PTR 52[rbp], eax
	mov	rax, QWORD PTR 56[rbp]
	add	rax, 36
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 208[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	ecx, DWORD PTR 52[rbp]
	mov	r8d, ecx
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE11LOOKUPLOCALEjj
	mov	DWORD PTR 48[rbp], eax
	mov	eax, DWORD PTR 48[rbp]
	mov	DWORD PTR 44[rbp], eax
	mov	rax, QWORD PTR 208[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 44[rbp]
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE8SYMBOLATEj
	mov	QWORD PTR 32[rbp], rax
	mov	rax, QWORD PTR 32[rbp]
	mov	QWORD PTR 24[rbp], rax
	cmp	QWORD PTR 24[rbp], 0
	je	.L6656
	mov	rax, QWORD PTR 24[rbp]
	movzx	eax, BYTE PTR [rax]
	cmp	al, 5
	jne	.L6657
	mov	rax, QWORD PTR 24[rbp]
	add	rax, 40
	mov	rax, QWORD PTR [rax]
	mov	DWORD PTR 20[rbp], eax
	mov	BYTE PTR 179[rbp], 0
	cmp	DWORD PTR 20[rbp], 0
	je	.L6658
	mov	rax, QWORD PTR 208[rbp]
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 20[rbp]
	mov	rcx, rax
	call	_ZN3TKO8ASTARENA4KINDEj
	mov	QWORD PTR 8[rbp], rax
	cmp	QWORD PTR 8[rbp], 65
	jne	.L6659
	mov	eax, DWORD PTR 20[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 208[rbp]
	call	_ZN3TKO7RESOLVE6STMTOFERNS0_3CTXEj
	mov	QWORD PTR 0[rbp], rax
	mov	rax, QWORD PTR 0[rbp]
	add	rax, 24
	movzx	eax, WORD PTR [rax]
	cmp	ax, 219
	sete	al
	mov	BYTE PTR 179[rbp], al
	jmp	.L6607
.L6603:
.L6605:
.L6606:
.L6658:
	nop
	jmp	.L6607
.L6659:
	nop
.L6607:
	cmp	BYTE PTR 179[rbp], 0
	jne	.L6660
	mov	rax, QWORD PTR 24[rbp]
	mov	QWORD PTR 184[rbp], rax
	jmp	.L6626
.L6591:
.L6609:
.L6610:
.L6611:
.L6612:
.L6613:
.L6614:
.L6615:
.L6616:
.L6617:
.L6618:
.L6619:
.L6620:
.L6621:
.L6622:
.L6623:
.L6624:
.L6625:
.L6648:
	nop
	jmp	.L6626
.L6649:
	nop
	jmp	.L6626
.L6650:
	nop
	jmp	.L6626
.L6651:
	nop
	jmp	.L6626
.L6652:
	nop
	jmp	.L6626
.L6654:
	nop
	jmp	.L6626
.L6655:
	nop
	jmp	.L6626
.L6656:
	nop
	jmp	.L6626
.L6657:
	nop
	jmp	.L6626
.L6660:
	nop
.L6626:
	cmp	QWORD PTR 184[rbp], 0
	jne	.L6661
	mov	BYTE PTR -57[rbp], 0
	jmp	.L6583
.L6661:
	nop
.L6628:
	mov	rax, QWORD PTR 184[rbp]
	movzx	eax, BYTE PTR [rax]
	cmp	al, 5
	je	.L6662
	mov	BYTE PTR -57[rbp], 0
	jmp	.L6583
.L6662:
	nop
.L6630:
	mov	rax, QWORD PTR 224[rbp]
	add	rax, 4
	mov	eax, DWORD PTR [rax]
	mov	edx, eax
	mov	rcx, QWORD PTR 208[rbp]
	call	_ZN3TKO7RESOLVE6LISTOFERNS0_3CTXEj
	mov	QWORD PTR -8[rbp], rax
	mov	rax, QWORD PTR -8[rbp]
	mov	QWORD PTR -16[rbp], rax
	mov	rax, QWORD PTR -16[rbp]
	add	rax, 8
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	jg	.L6663
	mov	BYTE PTR -57[rbp], 0
	jmp	.L6583
.L6663:
	nop
.L6632:
	mov	rax, QWORD PTR -16[rbp]
	add	rax, 8
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	jg	.L6664
	mov	BYTE PTR -57[rbp], 0
	jmp	.L6583
.L6664:
	nop
.L6634:
	mov	rax, QWORD PTR -16[rbp]
	add	rax, 4
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR -16[rbp]
	add	rax, 8
	mov	eax, DWORD PTR [rax]
	add	eax, edx
	sub	eax, 1
	mov	DWORD PTR -20[rbp], eax
	lea	rax, -72[rbp]
	mov	QWORD PTR [rax], 0
	mov	DWORD PTR 8[rax], 0
	lea	rax, -72[rbp]
	mov	WORD PTR [rax], 24
	mov	rax, QWORD PTR 208[rbp]
	mov	rax, QWORD PTR [rax]
	lea	rcx, 560[rax]
	mov	eax, DWORD PTR -20[rbp]
	mov	edx, eax
	call	_ZN5ArrayIjEixEi
	mov	QWORD PTR -32[rbp], rax
	lea	rax, -72[rbp]
	add	rax, 4
	mov	rdx, QWORD PTR -32[rbp]
	mov	edx, DWORD PTR [rdx]
	mov	DWORD PTR [rax], edx
	lea	rax, -72[rbp]
	add	rax, 8
	mov	rdx, QWORD PTR 224[rbp]
	mov	edx, DWORD PTR 8[rdx]
	mov	DWORD PTR [rax], edx
	mov	rax, QWORD PTR 208[rbp]
	mov	rax, QWORD PTR [rax]
	lea	rcx, 160[rax]
	lea	rax, -72[rbp]
	mov	rdx, rax
	call	_ZN5ArrayIN3TKO13BINARYPAYLOADEE4PUSHERS1_
	lea	rax, -84[rbp]
	mov	QWORD PTR [rax], 0
	mov	DWORD PTR 8[rax], 0
	lea	rax, -84[rbp]
	mov	WORD PTR [rax], 8
	lea	rax, -84[rbp]
	add	rax, 2
	mov	WORD PTR [rax], 0
	mov	rax, QWORD PTR 208[rbp]
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 216[rbp]
	mov	rcx, rax
	call	_ZN3TKO8ASTARENA3LOCEj
	mov	DWORD PTR -36[rbp], eax
	lea	rax, -84[rbp]
	add	rax, 4
	mov	edx, DWORD PTR -36[rbp]
	mov	DWORD PTR [rax], edx
	mov	rax, QWORD PTR 208[rbp]
	mov	rax, QWORD PTR [rax]
	add	rax, 160
	mov	rcx, rax
	call	_ZN5ArrayIN3TKO13BINARYPAYLOADEE5COUNTEv
	mov	DWORD PTR -40[rbp], eax
	mov	eax, DWORD PTR -40[rbp]
	lea	edx, -1[rax]
	lea	rax, -84[rbp]
	add	rax, 8
	mov	DWORD PTR [rax], edx
	mov	rax, QWORD PTR 208[rbp]
	mov	rax, QWORD PTR [rax]
	lea	rdx, -84[rbp]
	mov	rcx, rax
	call	_ZN5ArrayIN3TKO7ASTNODEEE4PUSHERS1_
	mov	rax, QWORD PTR 208[rbp]
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN5ArrayIN3TKO7ASTNODEEE5COUNTEv
	mov	DWORD PTR -44[rbp], eax
	mov	rax, QWORD PTR 208[rbp]
	mov	rax, QWORD PTR [rax]
	lea	rcx, 560[rax]
	mov	eax, DWORD PTR -20[rbp]
	mov	edx, eax
	call	_ZN5ArrayIjEixEi
	mov	QWORD PTR -56[rbp], rax
	mov	eax, DWORD PTR -44[rbp]
	sub	eax, 1
	mov	edx, eax
	mov	rax, QWORD PTR -56[rbp]
	mov	DWORD PTR [rax], edx
	mov	rax, QWORD PTR 224[rbp]
	add	rax, 8
	mov	DWORD PTR [rax], 0
	mov	rax, QWORD PTR 224[rbp]
	add	rax, 24
	mov	WORD PTR [rax], 0
	mov	BYTE PTR -57[rbp], 1
	nop
.L6583:
	movzx	eax, BYTE PTR -57[rbp]
	add	rsp, 320
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN3TKO7RESOLVE16RESOLVEAMBIGUOUSERNS0_3CTXEjj;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN3TKO7RESOLVE16RESOLVEAMBIGUOUSERNS0_3CTXEjj
_ZN3TKO7RESOLVE16RESOLVEAMBIGUOUSERNS0_3CTXEjj:
	push	rbp
	.seh_pushreg	rbp
	sub	rsp, 576
	.seh_stackalloc	576
	lea	rbp, 128[rsp]
	.seh_setframe	rbp, 128
	.seh_endprologue
	mov	QWORD PTR 464[rbp], rcx
	mov	DWORD PTR 472[rbp], edx
	mov	DWORD PTR 480[rbp], r8d
.L6666:
	mov	eax, DWORD PTR 472[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 464[rbp]
	call	_ZN3TKO7RESOLVE6STMTOFERNS0_3CTXEj
	mov	QWORD PTR 376[rbp], rax
	mov	rax, QWORD PTR 376[rbp]
	mov	QWORD PTR 368[rbp], rax
	mov	rax, QWORD PTR 368[rbp]
	add	rax, 4
	mov	eax, DWORD PTR [rax]
	mov	edx, DWORD PTR 480[rbp]
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 464[rbp]
	call	_ZN3TKO7RESOLVE8WALKEXPRERNS0_3CTXEjj
	mov	rax, QWORD PTR 368[rbp]
	add	rax, 8
	mov	eax, DWORD PTR [rax]
	mov	edx, DWORD PTR 480[rbp]
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 464[rbp]
	call	_ZN3TKO7RESOLVE8WALKEXPRERNS0_3CTXEjj
	mov	DWORD PTR 444[rbp], 0
	mov	rax, QWORD PTR 368[rbp]
	add	rax, 20
	mov	eax, DWORD PTR [rax]
	sub	eax, 1
	mov	DWORD PTR 364[rbp], eax
	jmp	.L6667
.L6762:
	nop
.L6668:
	mov	rax, QWORD PTR 368[rbp]
	add	rax, 16
	mov	edx, DWORD PTR [rax]
	mov	eax, DWORD PTR 444[rbp]
	add	edx, eax
	mov	rax, QWORD PTR 464[rbp]
	mov	rax, QWORD PTR [rax]
	add	rax, 560
	mov	rcx, rax
	call	_ZN5ArrayIjEixEi
	mov	QWORD PTR 120[rbp], rax
	mov	rax, QWORD PTR 120[rbp]
	mov	eax, DWORD PTR [rax]
	mov	edx, DWORD PTR 480[rbp]
	mov	r8d, edx
	mov	edx, eax
	mov	rcx, QWORD PTR 464[rbp]
	call	_ZN3TKO7RESOLVE8WALKEXPRERNS0_3CTXEjj
.L6669:
	add	DWORD PTR 444[rbp], 1
.L6667:
	mov	eax, DWORD PTR 444[rbp]
	cmp	eax, DWORD PTR 364[rbp]
	jle	.L6762
	nop
.L6670:
	mov	rax, QWORD PTR 368[rbp]
	add	rax, 24
	movzx	eax, WORD PTR [rax]
	test	ax, ax
	setne	al
	mov	BYTE PTR 363[rbp], al
	mov	rax, QWORD PTR 368[rbp]
	add	rax, 4
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 464[rbp]
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN3TKO8ASTARENA4KINDEj
	mov	QWORD PTR 352[rbp], rax
	cmp	QWORD PTR 352[rbp], 24
	jne	.L6763
	mov	rax, QWORD PTR 464[rbp]
	add	rax, 48
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 472[rbp]
	mov	r8d, 4
	mov	rcx, rax
	call	_ZN3TKO12SEMANTICINFO12SETAMBIGUOUSEjNS_19AMBIGUOUSRESOLUTIONE
	mov	rax, QWORD PTR 464[rbp]
	add	rax, 56
	mov	rax, QWORD PTR [rax]
	add	rax, 20
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 464[rbp]
	add	rax, 56
	mov	rax, QWORD PTR [rax]
	add	rax, 20
	add	edx, 1
	mov	DWORD PTR [rax], edx
	jmp	.L6745
.L6672:
.L6763:
	nop
.L6674:
	mov	rax, QWORD PTR 368[rbp]
	mov	eax, DWORD PTR 4[rax]
	mov	DWORD PTR 440[rbp], eax
	mov	DWORD PTR 436[rbp], 0
.L6675:
	cmp	DWORD PTR 436[rbp], 63
	jg	.L6764
	add	DWORD PTR 436[rbp], 1
	mov	rax, QWORD PTR 464[rbp]
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 440[rbp]
	mov	rcx, rax
	call	_ZN3TKO8ASTARENA4KINDEj
	mov	QWORD PTR 344[rbp], rax
	mov	rax, QWORD PTR 344[rbp]
	mov	QWORD PTR 336[rbp], rax
	cmp	QWORD PTR 336[rbp], 11
	jne	.L6765
	mov	edx, DWORD PTR 440[rbp]
	mov	rax, QWORD PTR 464[rbp]
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN5ArrayIN3TKO7ASTNODEEEixEi
	mov	QWORD PTR 328[rbp], rax
	mov	rax, QWORD PTR 328[rbp]
	add	rax, 8
	mov	eax, DWORD PTR [rax]
	mov	rdx, QWORD PTR 464[rbp]
	mov	rdx, QWORD PTR [rdx]
	lea	rcx, 160[rdx]
	mov	edx, eax
	call	_ZN5ArrayIN3TKO13BINARYPAYLOADEEixEi
	mov	QWORD PTR 320[rbp], rax
	mov	rax, QWORD PTR 320[rbp]
	mov	eax, DWORD PTR 4[rax]
	mov	DWORD PTR 440[rbp], eax
	jmp	.L6680
.L6765:
	nop
.L6679:
	cmp	QWORD PTR 336[rbp], 9
	je	.L6766
	cmp	QWORD PTR 336[rbp], 10
	sete	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR 424[rbp], rax
	jmp	.L6683
.L6766:
	nop
.L6682:
	mov	QWORD PTR 424[rbp], -1
.L6683:
	cmp	QWORD PTR 424[rbp], 0
	je	.L6767
	mov	eax, DWORD PTR 440[rbp]
	mov	edx, eax
	mov	rcx, QWORD PTR 464[rbp]
	call	_ZN3TKO7RESOLVE6LISTOFERNS0_3CTXEj
	mov	QWORD PTR 312[rbp], rax
	mov	rax, QWORD PTR 312[rbp]
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR 440[rbp], eax
	jmp	.L6680
.L6767:
	nop
.L6685:
	jmp	.L6677
.L6680:
	jmp	.L6675
.L6764:
	nop
.L6677:
	mov	rax, QWORD PTR 464[rbp]
	add	rax, 48
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 440[rbp]
	mov	rcx, rax
	call	_ZN3TKO12SEMANTICINFO5REFOFEj
	mov	DWORD PTR 308[rbp], eax
	mov	eax, DWORD PTR 308[rbp]
	mov	DWORD PTR 420[rbp], eax
	mov	rax, QWORD PTR 368[rbp]
	add	rax, 4
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 464[rbp]
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN3TKO8ASTARENA4KINDEj
	mov	QWORD PTR 296[rbp], rax
	cmp	QWORD PTR 296[rbp], 11
	jne	.L6768
	mov	rax, QWORD PTR 368[rbp]
	add	rax, 4
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 464[rbp]
	add	rax, 48
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN3TKO12SEMANTICINFO5REFOFEj
	mov	DWORD PTR 292[rbp], eax
	mov	eax, DWORD PTR 292[rbp]
	mov	DWORD PTR 288[rbp], eax
	cmp	DWORD PTR 288[rbp], 0
	je	.L6769
	mov	eax, DWORD PTR 288[rbp]
	mov	DWORD PTR 420[rbp], eax
	jmp	.L6697
.L6769:
	nop
.L6689:
	jmp	.L6697
.L6768:
	nop
.L6687:
	mov	rax, QWORD PTR 368[rbp]
	add	rax, 4
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 464[rbp]
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN3TKO8ASTARENA4KINDEj
	mov	QWORD PTR 280[rbp], rax
	cmp	QWORD PTR 280[rbp], 9
	jne	.L6770
	mov	rax, QWORD PTR 368[rbp]
	add	rax, 4
	mov	eax, DWORD PTR [rax]
	mov	edx, eax
	mov	rcx, QWORD PTR 464[rbp]
	call	_ZN3TKO7RESOLVE6LISTOFERNS0_3CTXEj
	mov	QWORD PTR 272[rbp], rax
	mov	rax, QWORD PTR 272[rbp]
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR 268[rbp], eax
	mov	rax, QWORD PTR 464[rbp]
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 268[rbp]
	mov	rcx, rax
	call	_ZN3TKO8ASTARENA4KINDEj
	mov	QWORD PTR 256[rbp], rax
	cmp	QWORD PTR 256[rbp], 11
	jne	.L6771
	mov	rax, QWORD PTR 464[rbp]
	add	rax, 48
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 268[rbp]
	mov	rcx, rax
	call	_ZN3TKO12SEMANTICINFO5REFOFEj
	mov	DWORD PTR 252[rbp], eax
	mov	eax, DWORD PTR 252[rbp]
	mov	DWORD PTR 248[rbp], eax
	cmp	DWORD PTR 248[rbp], 0
	je	.L6772
	mov	eax, DWORD PTR 248[rbp]
	mov	DWORD PTR 420[rbp], eax
	jmp	.L6697
.L6690:
.L6694:
.L6695:
.L6696:
.L6770:
	nop
	jmp	.L6697
.L6771:
	nop
	jmp	.L6697
.L6772:
	nop
.L6697:
	mov	rax, QWORD PTR 464[rbp]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 420[rbp]
	mov	rcx, rax
	call	_ZN3TKO11SYMBOLTABLE8SYMBOLATEj
	mov	QWORD PTR 240[rbp], rax
	mov	rax, QWORD PTR 240[rbp]
	mov	QWORD PTR 232[rbp], rax
	cmp	BYTE PTR 363[rbp], 0
	je	.L6773
	mov	ecx, DWORD PTR 420[rbp]
	mov	rdx, QWORD PTR 368[rbp]
	mov	eax, DWORD PTR 472[rbp]
	mov	r9d, ecx
	mov	r8, rdx
	mov	edx, eax
	mov	rcx, QWORD PTR 464[rbp]
	call	_ZN3TKO7RESOLVE21READCALLASSIGNASCALL_ERNS0_3CTXEjPNS_11STMTPAYLOADEj
	mov	BYTE PTR 231[rbp], al
	cmp	BYTE PTR 231[rbp], 0
	je	.L6774
	mov	rax, QWORD PTR 464[rbp]
	add	rax, 48
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 472[rbp]
	mov	r8d, 1
	mov	rcx, rax
	call	_ZN3TKO12SEMANTICINFO12SETAMBIGUOUSEjNS_19AMBIGUOUSRESOLUTIONE
	mov	rax, QWORD PTR 464[rbp]
	add	rax, 56
	mov	rax, QWORD PTR [rax]
	add	rax, 16
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 464[rbp]
	add	rax, 56
	mov	rax, QWORD PTR [rax]
	add	rax, 16
	add	edx, 1
	mov	DWORD PTR [rax], edx
	jmp	.L6745
.L6699:
.L6701:
.L6702:
.L6773:
	nop
	jmp	.L6703
.L6774:
	nop
.L6703:
	cmp	BYTE PTR 363[rbp], 0
	je	.L6775
	mov	rax, QWORD PTR 368[rbp]
	add	rax, 4
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 464[rbp]
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN3TKO8ASTARENA4KINDEj
	mov	QWORD PTR 216[rbp], rax
	cmp	QWORD PTR 216[rbp], 6
	sete	al
	mov	BYTE PTR 215[rbp], al
	movsx	eax, BYTE PTR 215[rbp]
	neg	eax
	test	eax, eax
	je	.L6776
	cmp	QWORD PTR 232[rbp], 0
	setne	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR 408[rbp], rax
	jmp	.L6708
.L6776:
	nop
.L6707:
	mov	QWORD PTR 408[rbp], 0
.L6708:
	cmp	QWORD PTR 408[rbp], 0
	je	.L6777
	mov	rax, QWORD PTR 232[rbp]
	add	rax, 4
	mov	eax, DWORD PTR [rax]
	mov	eax, eax
	and	eax, 4
	test	rax, rax
	jne	.L6778
	mov	rax, QWORD PTR 232[rbp]
	movzx	eax, BYTE PTR [rax]
	cmp	al, 3
	sete	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR 392[rbp], rax
	jmp	.L6713
.L6778:
	nop
.L6712:
	mov	QWORD PTR 392[rbp], -1
.L6713:
	cmp	QWORD PTR 392[rbp], 0
	setne	al
	mov	BYTE PTR 214[rbp], al
	mov	rax, QWORD PTR 232[rbp]
	add	rax, 16
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 464[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT7ISCONSTEj
	mov	BYTE PTR 213[rbp], al
	movzx	eax, BYTE PTR 213[rbp]
	mov	BYTE PTR 212[rbp], al
	cmp	BYTE PTR 214[rbp], 0
	jne	.L6779
	cmp	BYTE PTR 212[rbp], 0
	setne	al
	mov	BYTE PTR 391[rbp], al
	jmp	.L6716
.L6779:
	nop
.L6715:
	mov	BYTE PTR 391[rbp], 1
.L6716:
	cmp	BYTE PTR 391[rbp], 0
	je	.L6780
	lea	rax, 32[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	lea	rax, 32[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9d, 1
	lea	r8, .LC4[rip]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrAssign
	lea	rax, 64[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	lea	rax, 64[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9d, 1
	lea	r8, .LC4[rip]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrAssign
	lea	rax, 96[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	rax, QWORD PTR 232[rbp]
	add	rax, 8
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 464[rbp]
	add	rax, 24
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN3TKO8INTERNER8SPELLINGEj
	mov	QWORD PTR 200[rbp], rax
	mov	rdx, QWORD PTR 200[rbp]
	lea	rax, 96[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrAssign
	mov	rax, QWORD PTR 368[rbp]
	add	rax, 4
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 464[rbp]
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN3TKO8ASTARENA3LOCEj
	mov	DWORD PTR 196[rbp], eax
	mov	eax, DWORD PTR 196[rbp]
	mov	ecx, eax
	call	_ZN3TKO10POINTRANGEEj
	mov	QWORD PTR 24[rbp], rax
	mov	rax, QWORD PTR 464[rbp]
	add	rax, 40
	mov	rax, QWORD PTR [rax]
	lea	r8, 96[rbp]
	mov	rcx, QWORD PTR 24[rbp]
	lea	rdx, 32[rbp]
	mov	QWORD PTR 40[rsp], rdx
	lea	rdx, 64[rbp]
	mov	QWORD PTR 32[rsp], rdx
	mov	r9, r8
	mov	r8, rcx
	mov	edx, 91
	mov	rcx, rax
	call	_ZN3TKO16DIAGNOSTICENGINE6REPORTENS_6DIAGIDENS_11SOURCERANGEE8FBSTRINGS3_S3_
	lea	rax, 32[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	lea	rax, 64[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	lea	rax, 96[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	mov	rax, QWORD PTR 464[rbp]
	add	rax, 48
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 472[rbp]
	mov	r8d, 5
	mov	rcx, rax
	call	_ZN3TKO12SEMANTICINFO12SETAMBIGUOUSEjNS_19AMBIGUOUSRESOLUTIONE
	jmp	.L6791
.L6710:
.L6718:
.L6719:
.L6777:
	nop
	jmp	.L6720
.L6780:
	nop
.L6720:
	mov	rax, QWORD PTR 464[rbp]
	add	rax, 64
	mov	eax, DWORD PTR [rax]
	test	eax, eax
	je	.L6781
	mov	rax, QWORD PTR 464[rbp]
	add	rax, 64
	mov	eax, DWORD PTR [rax]
	cmp	DWORD PTR 420[rbp], eax
	sete	al
	movzx	eax, al
	neg	eax
	cdqe
	mov	QWORD PTR 400[rbp], rax
	jmp	.L6723
.L6781:
	nop
.L6722:
	mov	QWORD PTR 400[rbp], 0
.L6723:
	cmp	QWORD PTR 400[rbp], 0
	setne	al
	mov	BYTE PTR 195[rbp], al
	cmp	BYTE PTR 195[rbp], 0
	je	.L6782
	mov	rax, QWORD PTR 464[rbp]
	add	rax, 48
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 472[rbp]
	mov	r8d, 4
	mov	rcx, rax
	call	_ZN3TKO12SEMANTICINFO12SETAMBIGUOUSEjNS_19AMBIGUOUSRESOLUTIONE
	jmp	.L6726
.L6782:
	nop
.L6725:
	mov	rax, QWORD PTR 464[rbp]
	add	rax, 48
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 472[rbp]
	mov	r8d, 2
	mov	rcx, rax
	call	_ZN3TKO12SEMANTICINFO12SETAMBIGUOUSEjNS_19AMBIGUOUSRESOLUTIONE
.L6726:
	mov	rax, QWORD PTR 464[rbp]
	add	rax, 56
	mov	rax, QWORD PTR [rax]
	add	rax, 20
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 464[rbp]
	add	rax, 56
	mov	rax, QWORD PTR [rax]
	add	rax, 20
	add	edx, 1
	mov	DWORD PTR [rax], edx
	jmp	.L6745
.L6705:
.L6775:
	nop
.L6727:
	cmp	QWORD PTR 232[rbp], 0
	jne	.L6783
	mov	rax, QWORD PTR 464[rbp]
	add	rax, 48
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 472[rbp]
	mov	r8d, 1
	mov	rcx, rax
	call	_ZN3TKO12SEMANTICINFO12SETAMBIGUOUSEjNS_19AMBIGUOUSRESOLUTIONE
	mov	rax, QWORD PTR 464[rbp]
	add	rax, 56
	mov	rax, QWORD PTR [rax]
	add	rax, 16
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 464[rbp]
	add	rax, 56
	mov	rax, QWORD PTR [rax]
	add	rax, 16
	add	edx, 1
	mov	DWORD PTR [rax], edx
	jmp	.L6745
.L6729:
.L6783:
	nop
.L6730:
	mov	rax, QWORD PTR 232[rbp]
	movzx	eax, BYTE PTR [rax]
	movzx	eax, al
	mov	QWORD PTR 184[rbp], rax
	cmp	QWORD PTR 184[rbp], 5
	jne	.L6784
	nop
.L6731:
	mov	rax, QWORD PTR 464[rbp]
	add	rax, 48
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 472[rbp]
	mov	r8d, 1
	mov	rcx, rax
	call	_ZN3TKO12SEMANTICINFO12SETAMBIGUOUSEjNS_19AMBIGUOUSRESOLUTIONE
	mov	rax, QWORD PTR 464[rbp]
	add	rax, 56
	mov	rax, QWORD PTR [rax]
	add	rax, 16
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 464[rbp]
	add	rax, 56
	mov	rax, QWORD PTR [rax]
	add	rax, 16
	add	edx, 1
	mov	DWORD PTR [rax], edx
	jmp	.L6745
.L6784:
	nop
.L6732:
	cmp	QWORD PTR 184[rbp], 6
	je	.L6785
	nop
.L6733:
	cmp	QWORD PTR 184[rbp], 7
	je	.L6786
	nop
.L6735:
	cmp	QWORD PTR 184[rbp], 9
	je	.L6787
	nop
.L6736:
	cmp	QWORD PTR 184[rbp], 10
	jne	.L6788
	jmp	.L6734
.L6785:
	nop
	jmp	.L6734
.L6786:
	nop
	jmp	.L6734
.L6787:
	nop
.L6734:
	mov	rax, QWORD PTR 368[rbp]
	add	rax, 4
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 464[rbp]
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN3TKO8ASTARENA4KINDEj
	mov	QWORD PTR 176[rbp], rax
	cmp	QWORD PTR 176[rbp], 9
	jne	.L6789
	mov	rax, QWORD PTR 368[rbp]
	add	rax, 4
	mov	eax, DWORD PTR [rax]
	mov	edx, eax
	mov	rcx, QWORD PTR 464[rbp]
	call	_ZN3TKO7RESOLVE6LISTOFERNS0_3CTXEj
	mov	QWORD PTR 168[rbp], rax
	mov	rax, QWORD PTR 168[rbp]
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR 164[rbp], eax
	mov	rax, QWORD PTR 464[rbp]
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 164[rbp]
	mov	rcx, rax
	call	_ZN3TKO8ASTARENA4KINDEj
	mov	QWORD PTR 152[rbp], rax
	cmp	QWORD PTR 152[rbp], 11
	jne	.L6790
	mov	rax, QWORD PTR 464[rbp]
	add	rax, 48
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 472[rbp]
	mov	r8d, 1
	mov	rcx, rax
	call	_ZN3TKO12SEMANTICINFO12SETAMBIGUOUSEjNS_19AMBIGUOUSRESOLUTIONE
	mov	rax, QWORD PTR 464[rbp]
	add	rax, 56
	mov	rax, QWORD PTR [rax]
	add	rax, 16
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 464[rbp]
	add	rax, 56
	mov	rax, QWORD PTR [rax]
	add	rax, 16
	add	edx, 1
	mov	DWORD PTR [rax], edx
	jmp	.L6791
.L6739:
.L6741:
.L6742:
.L6789:
	nop
	jmp	.L6743
.L6790:
	nop
.L6743:
	mov	rax, QWORD PTR 464[rbp]
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 472[rbp]
	mov	rcx, rax
	call	_ZN3TKO8ASTARENA3LOCEj
	mov	DWORD PTR 148[rbp], eax
	mov	eax, DWORD PTR 148[rbp]
	mov	ecx, eax
	call	_ZN3TKO10POINTRANGEEj
	mov	QWORD PTR -80[rbp], rax
	mov	rax, QWORD PTR -80[rbp]
	mov	QWORD PTR -72[rbp], rax
	lea	rax, -64[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	lea	rax, -64[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9d, 1
	lea	r8, .LC4[rip]
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrAssign
	lea	rax, -32[rbp]
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	rax, QWORD PTR 232[rbp]
	movzx	eax, BYTE PTR [rax]
	movzx	eax, al
	mov	rcx, rax
	call	_ZN3TKO14SYMBOLKINDNAMEENS_10SYMBOLKINDE
	mov	QWORD PTR 136[rbp], rax
	mov	rdx, QWORD PTR 136[rbp]
	lea	rax, -32[rbp]
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrAssign
	mov	rax, rbp
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR 8[rax], 0
	mov	QWORD PTR 16[rax], 0
	mov	rax, QWORD PTR 232[rbp]
	add	rax, 8
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 464[rbp]
	add	rax, 24
	mov	rax, QWORD PTR [rax]
	mov	rcx, rax
	call	_ZN3TKO8INTERNER8SPELLINGEj
	mov	QWORD PTR 128[rbp], rax
	mov	rdx, QWORD PTR 128[rbp]
	mov	rax, rbp
	mov	DWORD PTR 32[rsp], 0
	mov	r9, -1
	mov	r8, rdx
	mov	rdx, -1
	mov	rcx, rax
	call	fb_StrAssign
	mov	rax, QWORD PTR 464[rbp]
	add	rax, 40
	mov	rax, QWORD PTR [rax]
	mov	r8, rbp
	mov	rcx, QWORD PTR -72[rbp]
	lea	rdx, -64[rbp]
	mov	QWORD PTR 40[rsp], rdx
	lea	rdx, -32[rbp]
	mov	QWORD PTR 32[rsp], rdx
	mov	r9, r8
	mov	r8, rcx
	mov	edx, 76
	mov	rcx, rax
	call	_ZN3TKO16DIAGNOSTICENGINE6REPORTENS_6DIAGIDENS_11SOURCERANGEE8FBSTRINGS3_S3_
	lea	rax, -64[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	lea	rax, -32[rbp]
	mov	rcx, rax
	call	fb_StrDelete
	mov	rax, rbp
	mov	rcx, rax
	call	fb_StrDelete
	mov	rax, QWORD PTR 464[rbp]
	add	rax, 48
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 472[rbp]
	mov	r8d, 5
	mov	rcx, rax
	call	_ZN3TKO12SEMANTICINFO12SETAMBIGUOUSEjNS_19AMBIGUOUSRESOLUTIONE
	jmp	.L6745
.L6788:
	nop
.L6737:
	mov	rax, QWORD PTR 464[rbp]
	add	rax, 48
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR 472[rbp]
	mov	r8d, 1
	mov	rcx, rax
	call	_ZN3TKO12SEMANTICINFO12SETAMBIGUOUSEjNS_19AMBIGUOUSRESOLUTIONE
	mov	rax, QWORD PTR 464[rbp]
	add	rax, 56
	mov	rax, QWORD PTR [rax]
	add	rax, 16
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR 464[rbp]
	add	rax, 56
	mov	rax, QWORD PTR [rax]
	add	rax, 16
	add	edx, 1
	mov	DWORD PTR [rax], edx
	jmp	.L6791
.L6673:
.L6744:
.L6745:
.L6791:
	nop
	add	rsp, 576
	pop	rbp
	ret
	.seh_endproc
	.def	_ZN3TKO7RESOLVE17TYPEISINCOMPLETE_ERNS0_3CTXEj;	.scl	3;	.type	32;	.endef
	.seh_proc	_ZN3TKO7RESOLVE17TYPEISINCOMPLETE_ERNS0_3CTXEj
_ZN3TKO7RESOLVE17TYPEISINCOMPLETE_ERNS0_3CTXEj:
	push	rbp
	.seh_pushreg	rbp
	mov	rbp, rsp
	.seh_setframe	rbp, 0
	sub	rsp, 80
	.seh_stackalloc	80
	.seh_endprologue
	mov	QWORD PTR 16[rbp], rcx
	mov	DWORD PTR 24[rbp], edx
	mov	BYTE PTR -41[rbp], 0
.L6793:
	mov	eax, DWORD PTR 24[rbp]
	mov	DWORD PTR -4[rbp], eax
	mov	DWORD PTR -8[rbp], 0
.L6794:
	cmp	DWORD PTR -4[rbp], 0
	jne	.L6817
	mov	BYTE PTR -41[rbp], 0
	jmp	.L6797
.L6817:
	nop
.L6796:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR -4[rbp]
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT9UNQUALIFYEj
	mov	DWORD PTR -12[rbp], eax
	mov	eax, DWORD PTR -12[rbp]
	mov	DWORD PTR -4[rbp], eax
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR -4[rbp]
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT4KINDEj
	mov	QWORD PTR -24[rbp], rax
	mov	rax, QWORD PTR -24[rbp]
	mov	QWORD PTR -32[rbp], rax
	cmp	QWORD PTR -32[rbp], 2
	je	.L6818
	nop
.L6798:
	cmp	QWORD PTR -32[rbp], 3
	je	.L6819
	nop
.L6800:
	cmp	QWORD PTR -32[rbp], 4
	jne	.L6820
	jmp	.L6799
.L6818:
	nop
	jmp	.L6799
.L6819:
	nop
.L6799:
	mov	rax, QWORD PTR 16[rbp]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	edx, DWORD PTR -4[rbp]
	mov	rcx, rax
	call	_ZN3TKO11TYPECONTEXT5INNEREj
	mov	DWORD PTR -36[rbp], eax
	mov	eax, DWORD PTR -36[rbp]
	mov	DWORD PTR -40[rbp], eax
	cmp	DWORD PTR -40[rbp], 0
	jne	.L6821
	mov	BYTE PTR -41[rbp], 1
	jmp	.L6797
.L6821:
	nop
.L6803:
	mov	eax, DWORD PTR -40[rbp]
	mov	DWORD PTR -4[rbp], eax
	nop
.L6808:
	add	DWORD PTR -8[rbp], 1
.L6809:
	cmp	DWORD PTR -8[rbp], 15
	jg	.L6822
	jmp	.L6794
.L6804:
.L6807:
.L6820:
	nop
.L6801:
	cmp	QWORD PTR -32[rbp], 8
	jne	.L6823
	nop
.L6805:
	mov	BYTE PTR -41[rbp], 1
	jmp	.L6797
.L6823:
	nop
.L6806:
	mov	BYTE PTR -41[rbp], 0
	jmp	.L6797
.L6822:
	nop
.L6810:
	mov	BYTE PTR -41[rbp], 0
	nop
.L6797:
	movzx	eax, BYTE PTR -41[rbp]
	add	rsp, 80
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
	.def	_ZN3TKO11TYPECONTEXT8POINTER_Ej;	.scl	2;	.type	32;	.endef
	.def	_ZN3TKO11TYPECONTEXT7QUALIFYEjt;	.scl	2;	.type	32;	.endef
	.def	_ZN3TKO11TYPECONTEXT7BUILTINENS_11BUILTINTYPEE;	.scl	2;	.type	32;	.endef
	.def	_ZN3TKO11TYPECONTEXT9REFERENCEEj;	.scl	2;	.type	32;	.endef
	.def	_ZN3TKO11TYPECONTEXT9UNQUALIFYEj;	.scl	2;	.type	32;	.endef
	.def	_ZN3TKO11TYPECONTEXT4KINDEj;	.scl	2;	.type	32;	.endef
	.def	_ZN3TKO11TYPECONTEXT9BUILTINOFEj;	.scl	2;	.type	32;	.endef
	.def	_ZN3TKO11TYPECONTEXT10DYNARRAYOFEji;	.scl	2;	.type	32;	.endef
	.def	_ZN3TKO11TYPECONTEXT8PROCTYPEEjR5ArrayIjEb;	.scl	2;	.type	32;	.endef
	.def	fb_StrConcatAssign;	.scl	2;	.type	32;	.endef
	.def	fb_IntToStr;	.scl	2;	.type	32;	.endef
	.def	_ZN3TKO8ASTARENA3LOCEj;	.scl	2;	.type	32;	.endef
	.def	_ZN3TKO11TUPLEUDTFORERNS_11SYMBOLTABLEERNS_11TYPECONTEXTERNS_8INTERNERER5ArrayIjEj;	.scl	2;	.type	32;	.endef
	.def	_ZN3TKO11SYMBOLTABLE11LOOKUPTYPEDEjjb;	.scl	2;	.type	32;	.endef
	.def	_ZN3TKO11SYMBOLTABLE8SYMBOLATEj;	.scl	2;	.type	32;	.endef
	.def	_ZN3TKO11TYPECONTEXT5INNEREj;	.scl	2;	.type	32;	.endef
	.def	_ZN3TKO11SYMBOLTABLE6LOOKUPEjj;	.scl	2;	.type	32;	.endef
	.def	_ZN3TKO8INTERNER8SPELLINGEj;	.scl	2;	.type	32;	.endef
	.def	_ZN3TKO4TEXT10LOWERASCIIE8FBSTRING;	.scl	2;	.type	32;	.endef
	.def	fb_StrCompare;	.scl	2;	.type	32;	.endef
	.def	fb_LEFT;	.scl	2;	.type	32;	.endef
	.def	fb_StrLen;	.scl	2;	.type	32;	.endef
	.def	fb_StrAllocTempDescZEx;	.scl	2;	.type	32;	.endef
	.def	fb_StrInstr;	.scl	2;	.type	32;	.endef
	.def	fb_StrMid;	.scl	2;	.type	32;	.endef
	.def	_ZN3TKO8INTERNER9GETSTRINGE8FBSTRING;	.scl	2;	.type	32;	.endef
	.def	_ZN3TKO11SYMBOLTABLE16LOOKUPLOCALTYPEDEjjb;	.scl	2;	.type	32;	.endef
	.def	_ZN3TKO7RESOLVE19INSTANTIATEGENERIC_ERNS0_3CTXEjPNS_11STMTPAYLOADEjj;	.scl	2;	.type	32;	.endef
	.def	_ZN3TKO11TYPECONTEXT7ARRAYOFEjiiP5ArrayIxE;	.scl	2;	.type	32;	.endef
	.def	_ZN3TKO5CHECK7CONSTOFERNS_8ASTARENAEjRNS_13SOURCEMANAGERERNS_8INTERNEREiPNS_11SYMBOLTABLEEjiPNS_11TYPECONTEXTEPNS_12SEMANTICINFOE;	.scl	2;	.type	32;	.endef
	.def	_ZN3TKO10POINTRANGEEj;	.scl	2;	.type	32;	.endef
	.def	_ZN3TKO16DIAGNOSTICENGINE6REPORTENS_6DIAGIDENS_11SOURCERANGEE8FBSTRINGS3_S3_;	.scl	2;	.type	32;	.endef
	.def	_ZN3TKO11SYMBOLTABLE7SCOPEATEj;	.scl	2;	.type	32;	.endef
	.def	_ZN3TKO7RESOLVE14ARRAYFROMPAIRSERNS0_3CTXEjR5ArrayIjES5_jbj;	.scl	2;	.type	32;	.endef
	.def	_ZN3TKO16NODEKINDCATEGORYENS_8NODEKINDE;	.scl	2;	.type	32;	.endef
	.def	_ZN3TKO7RESOLVE10WALKBLOCK_ERNS0_3CTXEjj;	.scl	2;	.type	32;	.endef
	.def	_ZN3TKO11SYMBOLTABLE8ADDUSINGEjj;	.scl	2;	.type	32;	.endef
	.def	fb_StrConcat;	.scl	2;	.type	32;	.endef
	.def	_ZN3TKO8INTERNER4FOLDEj;	.scl	2;	.type	32;	.endef
	.def	_ZN3TKO11SYMBOLTABLE11LOOKUPLOCALEjj;	.scl	2;	.type	32;	.endef
	.def	_ZN3TKO11TYPECONTEXT9NAMEDTYPEENS_8TYPEKINDEjjj;	.scl	2;	.type	32;	.endef
	.def	_ZN3TKO7RESOLVE19ARRAYFROMBOUNDSNODEERNS0_3CTXEjjjj;	.scl	2;	.type	32;	.endef
	.def	_ZN3TKO7RESOLVE21FORWARDTYPEDEFTARGET_ERNS0_3CTXEPNS_11STMTPAYLOADEj;	.scl	2;	.type	32;	.endef
	.def	_ZN3TKO7RESOLVE13ITERELEMTYPE_ERNS0_3CTXEj;	.scl	2;	.type	32;	.endef
	.def	_ZN3TKO8ASTARENA5COUNTEv;	.scl	2;	.type	32;	.endef
	.def	_ZN3TKO7RESOLVE23DISCOVERINSTANTIATIONS_ERNS0_3CTXERNS_8ASTARENAEjRNS_16DIAGNOSTICENGINEERNS_12SEMANTICINFOE;	.scl	2;	.type	32;	.endef
	.def	_ZN3TKO7RESOLVE19INSTANTIATEPENDING_ERNS0_3CTXE;	.scl	2;	.type	32;	.endef
	.def	_ZN3TKO7RESOLVE24INSTANTIATEPENDINGPROCS_ERNS0_3CTXE;	.scl	2;	.type	32;	.endef
	.def	_ZN3TKO7RESOLVE17BACKPATCHTYPEDEFSERNS0_3CTXE;	.scl	2;	.type	32;	.endef
	.def	_ZN3TKO11TYPECONTEXT4NAMEEj;	.scl	2;	.type	32;	.endef
	.def	fb_ArrayRedimTo;	.scl	2;	.type	32;	.endef
	.def	_ZN3TKO13SOURCEMANAGER6DECODEEj;	.scl	2;	.type	32;	.endef
	.def	_ZN3TKO11TYPECONTEXT6NAMEOFEj;	.scl	2;	.type	32;	.endef
	.def	_ZN3TKO11TYPECONTEXT11DECLSCOPEOFEj;	.scl	2;	.type	32;	.endef
	.def	_ZN3TKO11TYPECONTEXT10ISDYNARRAYEj;	.scl	2;	.type	32;	.endef
	.def	_ZN3TKO11TYPECONTEXT6LAYOUTEj;	.scl	2;	.type	32;	.endef
	.def	_ZN3TKO8ASTARENA14CALLTYPEARGSOFEjRiS1_;	.scl	2;	.type	32;	.endef
	.def	_ZN3TKO11SYMBOLTABLE10DECLARESYMEjjNS_10SYMBOLKINDEjRb;	.scl	2;	.type	32;	.endef
	.def	_ZN3TKO11SYMBOLTABLE9OPENSCOPEENS_9SCOPEKINDEjj;	.scl	2;	.type	32;	.endef
	.def	fb_TRIM;	.scl	2;	.type	32;	.endef
	.def	_ZN3TKO6MANGLE17ENCLOSINGPROCNAMEERNS_11SYMBOLTABLEEjRNS_8INTERNERE;	.scl	2;	.type	32;	.endef
	.def	_ZN3TKO11SYMBOLTABLE17LOOKUPINNAMESPACEEjji;	.scl	2;	.type	32;	.endef
	.def	_ZN3TKO11SYMBOLTABLE19LOOKUPTHROUGHUSINGSEjj;	.scl	2;	.type	32;	.endef
	.def	_ZN3TKO7RESOLVE23INSTANTIATEGENERICPROC_ERNS0_3CTXEjj;	.scl	2;	.type	32;	.endef
	.def	_ZN3TKO11TYPECONTEXT7ISCONSTEj;	.scl	2;	.type	32;	.endef
	.def	_ZN3TKO14SYMBOLKINDNAMEENS_10SYMBOLKINDE;	.scl	2;	.type	32;	.endef
