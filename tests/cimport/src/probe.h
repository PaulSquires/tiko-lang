/* probe.h -- the shapes the libclang probe reports, using FREESTANDING headers only.
 *
 * stddef.h and stdint.h come from clang's own resource directory, never from a C
 * library, so this header parses for win64-msvc, win64 and linux-x86_64 on any host
 * with no SDK, MinGW or sysroot installed. That is what lets tests/cimport run every
 * target from one machine. */
#include <stddef.h>
#include <stdint.h>

/* 24 bytes on every target: 4 + pad 4 + 8 + 8 */
struct probe_pair {
    int32_t tag;
    double value;
    const char *name;
};

/* bit-fields: a 3-bit and a 5-bit field share the first byte */
struct probe_bits {
    unsigned int low : 3;
    unsigned int high : 5;
    unsigned char next;
};

union probe_word {
    uint32_t u;
    float f;
    unsigned char b[4];
};

enum probe_colour { PROBE_RED = 1, PROBE_GREEN = 2, PROBE_BLUE = 40 };

typedef struct probe_opaque probe_opaque;   /* declared, never defined */
typedef size_t probe_size;

int probe_add(int a, int b);
int probe_printf(const char *fmt, ...);
void probe_walk(struct probe_pair p, probe_opaque *o);

extern long probe_counter;
