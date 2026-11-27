/* vendor/miniaudio's one translation unit: miniaudio with stb_vorbis as its Ogg Vorbis decoder,
   the order miniaudio.h documents -- stb_vorbis's declarations, miniaudio's implementation,
   then stb_vorbis's implementation. */
#define STB_VORBIS_HEADER_ONLY
#include "stb_vorbis.c"
#define MINIAUDIO_IMPLEMENTATION
#include "miniaudio.h"
#undef STB_VORBIS_HEADER_ONLY
#include "stb_vorbis.c"
