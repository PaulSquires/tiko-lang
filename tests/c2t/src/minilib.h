#ifndef MINILIB_H
#define MINILIB_H

#include <stdbool.h>

#if defined(_WIN32) && defined(BUILD_LIBTYPE_SHARED)
    #define MLAPI __declspec(dllexport)
#else
    #define MLAPI
#endif

#define ML_FLAG_VSYNC   (1 << 6)   // Set to try enabling V-Sync
#define ML_MAX(a, b)    ((a) > (b) ? (a) : (b))
#define ML_LOG(fmt, ...) printf(fmt, __VA_ARGS__)

// Color, 4 components, R8G8B8A8 (32bit)
typedef struct Color {
    unsigned char r;        // Color red value
    unsigned char a;        // Color alpha value
} Color;

typedef struct Image Image;   // defined by the implementation

/* Trace log level */
typedef enum {
    LOG_ALL = 0,        // Display all logs
    LOG_NONE = 7        // Disable logging
} TraceLogLevel;

#if defined(__cplusplus)
extern "C" {
#endif

MLAPI void InitWindow(int width, int height,
                      const char *title);   // Initialize window
MLAPI bool LoadImageInto(Image *image, const char *fileName);
static inline int Clamp(int v, int lo, int hi) { return v < lo ? lo : v > hi ? hi : v; }

#if defined(__cplusplus)
}
#endif

#endif // MINILIB_H
