/* sdlshapes.h -- SDL3's shapes the corpus found: a typedef whose name is tiko's own type,
   a calling convention a macro spells inside a function-pointer typedef, and #if inside an
   enum's and a struct's body. */
#pragma once
#include <stdint.h>

#if defined(_WIN32)
#define SH_CALL __cdecl
#else
#define SH_CALL
#endif
#define SH_LIL 1234
#define SH_BIG 4321
#define SH_ORDER SH_LIL

typedef uint8_t Uint8;          /* tiko's own uint8: nothing to declare */
typedef uint32_t Uint32;

typedef struct SH_GUID {
    Uint8 data[16];
} SH_GUID;

typedef struct SH_Data { int line; } SH_Data;
typedef int (SH_CALL *SH_Handler)(
                                 const SH_Data *data, void *userdata);

typedef enum SH_Format
{
    SH_U8    = 0x0008u,  /**< Unsigned 8-bit */
    SH_S16LE = 0x8010u,  /**< Signed 16-bit */
    SH_S16BE = 0x9010u,

    /* These represent the current system's byteorder. */
    #if SH_ORDER == SH_LIL
    SH_S16 = SH_S16LE
    #else
    SH_S16 = SH_S16BE
    #endif
} SH_Format;

typedef struct SH_Opt {
    int a;          /* always */
#ifdef _WIN32
    void *handle;   /* Windows only */
#else
    int fd;         /* elsewhere */
#endif
} SH_Opt;

int sh_use(SH_GUID g, SH_Format f, SH_Opt *o, SH_Handler h, Uint32 n);
