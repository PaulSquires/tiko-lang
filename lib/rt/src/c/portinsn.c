/* portinsn.c -- the x86 IN and OUT instructions, and nothing else.
**
** LINUX ONLY. src/sys/ports.tiko is fb_hIn and fb_hOut, the INP and OUT
** statements' back end, and on linux-x86_64 they are real port I/O: fbc's
** own member does the permission check and then executes `inb` / `outb`.
** tiko-rt keeps the check in FreeBASIC (ports.tiko reads __fb_con.has_perm,
** which src/init/hinitposix.tiko sets from ioperm) and puts ONLY the two
** instructions here, because -gen llvm rejects inline ASM -- measured, and
** recorded in ports.tiko -- and there is no API that performs port I/O: ioperm
** only stops the instruction from faulting.
**
** THIS WAS PREDICTED. src/c/README.md's first table lists sys_portio.c for
** exactly this reason. It is not named that: gate.sh deletes fbc members BY
** SYMBOL, so the name has nothing to replace, and it would only suggest that
** the whole of fbc's member lives here when the logic does not.
**
** Until 2026-09-19 linux-x86_64 linked fbc's sys_portio.o from
** lib/linux-x86_64-fb/, behind tiko-rt. src/io/hookkey.tiko refers to fb_hIn
** and fb_hOut from the same object as INKEY, GETKEY and WAIT, so with fbc's
** libfb retired (decision 0015, D15) every program using INKEY would otherwise
** fail to link on Linux.
**
** EMPTY on the Windows targets, where ports.tiko reports ILLEGALFUNCTIONCALL
** as every 64-bit Windows build of FreeBASIC does.
*/

#if defined( __linux__ ) && defined( __x86_64__ )

unsigned char tkort_inb( unsigned short port )
{
	unsigned char value;
	__asm__ volatile ( "inb %1, %0" : "=a" ( value ) : "Nd" ( port ) );
	return value;
}

void tkort_outb( unsigned short port, unsigned char value )
{
	__asm__ volatile ( "outb %0, %1" : : "a" ( value ), "Nd" ( port ) );
}

#else

/* A TYPEDEF and not a static, matching src/c/msvcinit.c: the build is meant to
** be warning-free and an unreferenced static draws -Wunused-const-variable. */
typedef int tkort_portinsn_not_used_here_;

#endif
