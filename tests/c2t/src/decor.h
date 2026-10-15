/* decor.h -- export macros, one defined through another, and a feature switch. */
#ifndef DECOR_H
#define DECOR_H

#define FEATURE_X
#ifdef _WIN32
#  define LIB_EXPORT __declspec(dllimport)
#else
#  define LIB_EXPORT __attribute__((visibility("default")))
#endif
#define LIBAPI LIB_EXPORT
#define LIBCALL __cdecl

#ifdef FEATURE_X
LIBAPI int LIBCALL lib_feature(void);
#endif

#endif
