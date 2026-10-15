/* bitfields.h -- bit-field records whose layout differs between fbc's rule, MSVC's and
   SysV's. Imported as 'extern "c"', tiko lays each out by the target's C rule, so --verify
   refuses none of them. Freestanding. */

struct bf_mixed      { char a : 3; int b : 5; };                       /* MSVC: new unit at int */
struct bf_short_gap  { short s : 4; char c; int i : 7; };
struct bf_wide       { long long q : 40; int r : 10; };
struct bf_after_char { char c; long long q : 3; };
struct bf_tail       { unsigned x : 3; unsigned y : 5; char c; };      /* SysV: c at byte 1 */
struct bf_bytes      { unsigned char a : 3; unsigned char b : 6; };
struct bf_signs      { int a : 3; unsigned b : 3; };
struct bf_then_char  { unsigned a : 3; char y; };
struct bf_overflow   { int a : 30; int b : 5; };
struct bf_sizes      { char a : 3; short b : 3; char c : 3; };
struct bf_into_char  { char x; int a : 3; };
struct bf_ll_middle  { int a : 3; long long b : 3; int c : 3; };
struct bf_bool       { _Bool f : 1; char c : 2; };
struct bf_ull        { unsigned long long a : 3; unsigned b : 3; unsigned long long c : 3; };
struct bf_unnamed    { char c; int : 5; int d : 4; };
struct bf_enum       { enum { BF_E0, BF_E1 } e : 2; short s : 3; };
union  bf_union      { char a : 3; int b : 5; };                       /* MSVC: aligned to 1 */
struct bf_anon       { int a : 3; union { char u : 2; short v; }; int c : 2; };
struct bf_nested     { char h; struct { int x : 4; char y : 2; } in; short t : 3; };

#pragma pack(push, 1)
struct bf_pack1      { char a : 3; int b : 5; };
struct bf_pack1_span { char p; int a : 20; short b : 14; };            /* SysV: b at bit 28 */
struct bf_pack1_end  { char a : 4; int b : 20; };                      /* SysV: 3 bytes */
#pragma pack(pop)
#pragma pack(push, 2)
struct bf_pack2      { char a : 3; int b : 5; char c; };
#pragma pack(pop)
