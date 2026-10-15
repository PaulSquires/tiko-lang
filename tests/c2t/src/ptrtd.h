/* ptrtd.h -- typedefs of a pointer to a record named in the same declaration (SDL_iconv_t). */
#pragma once

typedef struct pt_iconv_data *pt_iconv_t;     /* never defined: an opaque handle */
typedef struct pt_known *pt_known_p;          /* defined just below */
struct pt_known { int a; };
typedef struct pt_later *pt_later_p, **pt_later_pp;
int pt_use(pt_iconv_t cd, pt_later_p l, pt_later_pp ll);
struct pt_later { int b; };
