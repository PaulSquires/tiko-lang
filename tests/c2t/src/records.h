/* records.h -- the record shapes c2t P3 translates, and the ones it refuses. */
#ifndef RECORDS_H
#define RECORDS_H

#include <stdint.h>

/* Bit-fields, one unnamed (padding). */
typedef struct Flags {
    unsigned visible : 1;   /* shown */
    unsigned         : 3;   /* padding */
    unsigned layer   : 4;
    unsigned color;         /* a tiko word as a field name */
} Flags;

/* An anonymous union inside a struct, and an anonymous struct inside that. */
typedef struct Variant {
    int kind;
    union {
        int    i;           /* when kind == 0 */
        double d;           /* when kind == 1 */
        struct {
            short lo, hi;
        };
    };
} Variant;

/* A named record declared inside another, and a field of an unnamed record type. */
struct Outer {
    struct Inner { int a; } inner;
    struct { int x, y; } point;
};

#pragma pack(push, 1)
typedef struct Packed1 {
    uint8_t  tag;
    uint32_t value;         /* at offset 1 */
} Packed1;
#pragma pack(pop)

/* Case-insensitive collisions between fields. */
typedef struct Case {
    int Handler;
    int handler;
} Case;

typedef struct Big {
    _Alignas(32) char data[32];   /* over-aligned: refused */
} Big;

typedef struct Flex {
    int  count;
    char bytes[];           /* a flexible array member: refused */
} Flex;

#endif
