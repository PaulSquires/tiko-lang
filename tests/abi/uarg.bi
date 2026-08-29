#ifndef __TKORT_TEST_UARG_BI__
#define __TKORT_TEST_UARG_BI__

'' uarg.bi -- the ustring (pointer, size) argument pair, as ONE token.
''
'' WHY THIS EXISTS. Nearly every ustring entry point takes a pointer and a size
'' that together say which of the argument forms is being passed, and the pointer
'' MEANS SOMETHING DIFFERENT in each:
''
''     var-len    the pointer is an FBUSTRING DESCRIPTOR,  size = -1
''     fixed-len  the pointer is a RAW UNIT BUFFER,        size = n or FB_STRISFIXED
''     bare       the pointer is a RAW UNIT BUFFER,        size = 0
''
'' Spelling the two out separately at each call site means nothing stops a
'' descriptor being paired with a fixed size -- and that mistake was made in TWO
'' consecutive batches, in ucore-parity.bas and again in ucore2-parity.bas. Both
'' times every affected line printed the descriptor's own bytes as text.
''
'' It is worth noting HOW the two failed, because it was not the same way. Those
'' two failed LOUDLY: the misread descriptors held different addresses under the
'' two runtimes, so the outputs disagreed and build/diff.sh flagged them. The
'' structurally identical bug in uwconv-parity.bas printed 0000 on BOTH sides and
'' PASSED. One class of mistake, two failure modes, and only one announces itself
'' -- which is the argument for removing the chance to make it rather than
'' relying on the differential to notice.
''
'' Each macro expands to BOTH arguments, so the pointer and the size can no
'' longer disagree:
''
''     pLen( UVAR( d ) )              descriptor, var-len
''     pLen( UFIX( buf, 6 ) )         raw ARRAY, USTRING * 6
''     pLen( URAW( buf ) )            raw ARRAY, length unknown

#define TKORT_T_VARLEN  (-1)
#define TKORT_T_FIXBIT  cast( integer, &h8000000000000000ull )

'' A DESCRIPTOR. Anything else here is a bug, and the cptr is what makes the
'' compiler say so if a raw ushort buffer is passed by mistake.
#define UVAR( d )       cptr( any ptr, @(d) ), TKORT_T_VARLEN

'' A RAW UNIT BUFFER of capacity n. The length is WALKED to the NUL, not taken
'' from n -- USTRING * N is NUL-padded and n carries the capacity.
'' NOTE IT TAKES THE ARRAY NAME, NOT AN ELEMENT ADDRESS, and that is the whole
'' point rather than a convenience. `@arr(0)` does not compile unless `arr`
'' really is an array, so UFIX( da, 6 ) -- a DESCRIPTOR with a fixed size, the
'' mistake made in two consecutive batches -- is now a compile error instead of
'' a program that prints the descriptor's own bytes as text.
#define UFIX( arr, n )  cptr( any ptr, @arr(0) ), ((n) or TKORT_T_FIXBIT)

'' A RAW UNIT BUFFER with no declared capacity.
#define URAW( arr )     cptr( any ptr, @arr(0) ), 0

#endif '' __TKORT_TEST_UARG_BI__
