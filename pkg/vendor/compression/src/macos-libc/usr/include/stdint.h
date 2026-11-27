/* stand-in <stdint.h> (see ../README): every type is clang's own predefined one for the target,
** so arm64-apple-macosx13.0 gets Darwin's (int64_t is long long). */
#pragma once
typedef __INT8_TYPE__ int8_t;     typedef __UINT8_TYPE__ uint8_t;
typedef __INT16_TYPE__ int16_t;   typedef __UINT16_TYPE__ uint16_t;
typedef __INT32_TYPE__ int32_t;   typedef __UINT32_TYPE__ uint32_t;
typedef __INT64_TYPE__ int64_t;   typedef __UINT64_TYPE__ uint64_t;
typedef __INTPTR_TYPE__ intptr_t; typedef __UINTPTR_TYPE__ uintptr_t;
typedef __INTMAX_TYPE__ intmax_t; typedef __UINTMAX_TYPE__ uintmax_t;
#define UINT32_MAX __UINT32_MAX__
#define UINT64_MAX __UINT64_MAX__
#define INT64_MAX __INT64_MAX__
#define SIZE_MAX __SIZE_MAX__
#define UINT32_C(c) c##U
#define UINT64_C(c) c##ULL
#define INT64_C(c) c##LL
