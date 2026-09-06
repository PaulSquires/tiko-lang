/* msvcobject.c -- fb_Object$'s default constructor and its RTTI record.
**
** NOT NAMED oop_object.c, AND THAT IS LOAD-BEARING. build/gate.sh merges
** tiko-rt's objects into fbc's archive BY MEMBER NAME, so a file called
** oop_object.c produces oop_object.o and REPLACES fbc's member of that name.
** On the gnu targets this file is empty, so that replacement deleted
** _ZN10fb_Object$C1Ev from the merged archive and the win64 gate stopped
** building fbcunit. Measured: `llvm-nm` on obj/gate/win64/lib/libfb.a showed
** oop_object.o carrying nothing but @feat.00 and the constructor gone.
**
** The first version of this comment worried about the opposite -- TWO
** definitions reaching the merged archive. The real hazard was ZERO.
**
** EMPTY EXCEPT ON THE MICROSOFT ABI, exactly like msvcinit.c.  On the gnu
** targets fbc's own oop_object.o supplies both symbols and the gate links it;
** defining them here as well would put two definitions of _ZN10fb_Object$C1Ev
** into the merged archive and trip build.sh's one-symbol-one-member check.
** Under MSVC there is no fbc archive to borrow from, and that is the whole
** reason this file exists.
**
** HOW IT WAS FOUND.  build/gatemsvc.sh built all 728 linkable modules of fbc's
** own suite for x86_64-pc-windows-msvc and the link came up three symbols
** short; two of them were these.  Nothing else could have seen it --
** diffmsvc's 114 programs never construct an Object, abidelta compares symbol
** tables and this is absent from BOTH, and the MinGW and Linux gates link
** fbc's copy without noticing.  docs/tiko-rt/RFC-0008 section 18.4.
**
** WHY C AND NOT FREEBASIC.  __fb_ZTS6Object is RESERVED BY fbc: any module it
** compiles gets an automatic "external global" declaration of it, so a
** FreeBASIC file that also defines it emits the name twice and clang refuses
** the module.  Measured -- the .ll carries both lines:
**
**     @__fb_ZTS6Object = external global %"8fb_RTTI$"
**     @__fb_ZTS6Object = internal global %"10TKORT_RTTI" zeroinitializer
**
** src/oop/object_copyctor.bas recorded this when it was written; it is why
** that file calls the constructor instead of being the constructor.
**
** THE LAYOUT IS MEASURED FROM fbc's OWN OBJECT, not read from its sources.
** llvm-objdump of oop_object.o in src/lib/win64/libfb.a gives .data of 0x30:
**
**     +0x00  __fb_ZTS6Object   { NULL, ->".rdata", NULL }   the RTTI, 24 bytes
**     +0x18  (8 bytes padding, alignment)
**     +0x20  Object_VT         { NULL, ->.data+0 }          the vtable, 16
**     .rdata                   "6OBJECT\0"                  the id string
**
** and the constructor is six instructions that store .data+0x30 -- which is
** Object_VT PLUS sizeof(vtable header) -- into *this.  That bias is not an
** accident of this object: src/inc/oop.bi and src/oop/istypeof.bas both
** describe it, because a vptr names the first METHOD slot and the header sits
** behind it.  istypeof.bas subtracts exactly the same amount to walk back.
**
** THE ID STRING IS "6OBJECT": fbc's length-prefixed, upper-cased type name.
** istypeof.bas compares these with strcmp rather than by address, because two
** DLLs each carry their own copy of the record.
*/

#ifdef TKORT_MSVC

/* The two shapes, from src/inc/oop.bi.  Pointers only, so nothing here is
** target-dependent. */
typedef struct _tkort_rtti {
	void                *stdlistVT;
	const char          *id;
	struct _tkort_rtti  *pRTTIBase;
} tkort_rtti;

typedef struct _tkort_basevt {
	void        *nullPtr;
	tkort_rtti  *pRTTI;
} tkort_basevt;

/* PUBLIC, and named exactly as fbc names it. */
tkort_rtti __fb_ZTS6Object = { 0, "6OBJECT", 0 };

/* LOCAL, as it is in fbc's object (nm reports a lowercase 'd'). */
static tkort_basevt Object_VT = { 0, &__fb_ZTS6Object };

/* The mangled name carries a '$', which is not a portable C identifier
** character, so the symbol is set with an asm label rather than spelled. */
void tkort_ObjectCtor( void *this_ ) __asm__( "_ZN10fb_Object$C1Ev" );

void tkort_ObjectCtor( void *this_ )
{
	/* The vptr is biased PAST the header -- see the file comment. */
	*(void **)this_ = (void *)( (char *)&Object_VT + sizeof( tkort_basevt ) );
}

#else

/* Deliberately empty. See the header: fbc's own oop_object.o supplies both
** symbols on the gnu targets. A TYPEDEF and not a static, matching
** src/c/msvcinit.c -- an unreferenced static draws -Wunused-const-variable and
** the build is meant to be warning-free. */
typedef int tkort_oop_object_not_used_here_;

#endif
