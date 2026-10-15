/* macros.h -- every row of RFC-0001 section 5.5, the function-like refusals, the #if forms. */
#ifndef MACROS_H
#define MACROS_H

#define M_XOR     (0x0F ^ 0x3C)
#define M_OR      (1 | 2 | 4)
#define M_AND     (0xFF & 0x0F)
#define M_NOT     (~0)
#define M_SHL     (1 << 6)
#define M_SHR     (256 >> 2)
#define M_SUM     (1 + 2 << 3)      /* C: (1 + 2) << 3; tiko's shl binds tighter */
#define M_LAND    (1 && 2)          /* a C truth value is 1; tiko's is -1: clang's value */
#define M_LOR     (0 || 0)
#define M_MOD     (17 % 5)
#define M_EQ      (3 == 3)
#define M_LNOT    (!0)
#define M_IDIV    (7 / 2)           /* integer division is \ in tiko */
#define M_FDIV    (7.0 / 2)
#define M_TERN    (1 ? 10 : 20)
#define M_CAST    ((unsigned char)300)
#define M_NULLP   ((void*)0)        /* a pointer: a TODO */
#define M_HEX     0x1Fu
#define M_OCT     017
#define M_BIN     0b101
#define M_ULL     18446744073709551615ULL
#define M_LONG    100L
#define M_FLOAT   1.5f
#define M_DOUBLE  2.25
#define M_CHAR    'a'
#define M_ESC     '\n'
#define M_STR     "plain"
#define M_STRESC  "tab\there\n"
#define M_OCTSTR  "\033[0m"
#define M_CONCAT  "ab" "cd"
#define M_WIDE    L"wide"           /* a wide string: a TODO */
#define M_REF     (M_SHL + 1)       /* an earlier macro */
#define M_EMPTY
#define M_ALIAS   lib_function

int lib_function(int x);

/* function-like */
#define F_MAX(a, b)   ((a) > (b) ? (a) : (b))
#define F_SQ(x)       ((x) * (x))
#define F_CALL(x)     lib_function(x)
#define F_ISPOW2(x)   (((x) & ((x) - 1)) == 0)   /* a truth value as a number: a TODO */
#define F_HALF(x)     ((x) / 2)                  /* integer or float division: a TODO */
#define F_STR(x)      #x                         /* stringify: a TODO */
#define F_CAT(a, b)   a##b                       /* paste: a TODO */
#define F_LOG(...)    lib_function(0)            /* variadic: a TODO */

/* conditions */
#if defined(_WIN32) && !defined(__APPLE__)
#define ON_WINDOWS 1
#elif defined(__linux__)
#define ON_LINUX 1
#else
#define ON_OTHER 1
#endif

#if M_SHL == 64
#define SHL_OK 1
#endif

#ifdef _MSC_VER                     /* a compiler's identity: the group is a TODO */
#define BY_MSVC 1
#endif

#endif
