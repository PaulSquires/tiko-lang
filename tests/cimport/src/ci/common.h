/* common.h -- shared by a.h and b.h: the second #cinclude must not declare it again. */
#ifndef CI_COMMON_H
#define CI_COMMON_H
typedef struct ci_common_s { int tag; short s; } ci_common_t;
#define CI_COMMON_ONE 1
#endif
