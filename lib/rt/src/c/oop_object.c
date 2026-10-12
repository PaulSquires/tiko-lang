/* oop_object.c -- fb_Object$'s default constructor and its RTTI record.
**
** ON EVERY TARGET since 2026-09-19 (decision 0015, D15). Until then this file
** was msvcobject.c and EMPTY on the gnu targets, where fbc's own oop_object.o
** supplied both symbols from the lib/<target>-fb/ archive linked behind
** tiko-rt's. Retiring fbc's libfb from that directory needs them here too.
**
** THE NAME IS NOW fbc's MEMBER NAME, deliberately. build/gate.sh deletes every
** fbc member that defines a symbol tiko-rt also defines and then adds ours, so
** fbc's oop_object.o goes on either name -- and this one says what it replaces.
** It defines exactly what fbc's does, measured with llvm-nm over
** lib/win64-fb/libfb.a: _ZN10fb_Object$C1Ev (T), __fb_ZTS6Object (D) and the
** local Object_VT (d).
**
** THE NAME WAS ONCE LOAD-BEARING THE OTHER WAY. While this file was empty on
** the gnu targets, an object called oop_object.o would have REPLACED fbc's
** member by name with an empty one; the gate did exactly that, deleted
** _ZN10fb_Object$C1Ev from the merged archive, and stopped building fbcunit.
** That hazard needed the file to be empty somewhere, and it no longer is.
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
** src/oop/object_copyctor.tiko recorded this when it was written; it is why
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
** accident of this object: src/inc/oop.ti and src/oop/istypeof.tiko both
** describe it, because a vptr names the first METHOD slot and the header sits
** behind it.  istypeof.tiko subtracts exactly the same amount to walk back.
**
** THE ID STRING IS "6OBJECT": fbc's length-prefixed, upper-cased type name.
** istypeof.tiko compares these with strcmp rather than by address, because two
** DLLs each carry their own copy of the record.
*/

/* The two shapes, from src/inc/oop.ti.  Pointers only, so nothing here is
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

