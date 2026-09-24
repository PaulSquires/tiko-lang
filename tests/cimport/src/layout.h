/* layout.h -- records whose layout tiko's frontend must be checked against clang's.
   Freestanding: nothing beyond the compiler's own <stddef.h>. */

/* SysV packs 'tail' into the bit-fields' storage unit (bit 8, size 4); Windows starts a
   new unit (bit 32, size 8). FreeBASIC's bit-field containers can only say the second. */
struct lay_bits {
    unsigned int lo : 3;
    unsigned int hi : 5;
    unsigned char tail;
};

/* ...and whatever holds one by value goes with it. A pointer to one is still fine. */
struct lay_holds_bits {
    struct lay_bits b;
    int after;
};
struct lay_points_bits {
    struct lay_bits *b;
    int after;
};

/* A packed record is 1-aligned to C, and embeds at offset 1. */
#pragma pack(push, 1)
struct lay_packed {
    char c;
    int i;
};
#pragma pack(pop)
struct lay_holds_packed {
    char c;
    struct lay_packed p;
};
/* ...but in a record that is not packed, FreeBASIC places a 'field = 1' type at its
   members' natural alignment -- 'p' at 4 where C has 1. */
struct lay_holds_packed4 {
    char c;
    struct lay_packed p;
    int x;
};

/* Over-aligned: C aligns it to 16. FreeBASIC aligns nothing past 8; the size is padded
   to C's and the record is kept. */
struct lay_over {
    long long a;
} __attribute__((aligned(16)));

struct lay_plain {
    char c;
    double d;
    short s;
};
