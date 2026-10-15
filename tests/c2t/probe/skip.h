/* c2t P0 probe 2: where clang_getSkippedRanges starts and ends each inactive branch. */
#define FEATURE 1

#if 0
int dead0;
#endif

#ifdef FEATURE
int live1;
#else
int dead1;
#endif

#if defined(NOPE)
int dead2a;
#elif FEATURE
int live2;
#else
int dead2b;
#endif

#ifndef FEATURE
#  if 1
int dead3nested;
#  endif
#endif

#ifdef _WIN32
int win_only;
#else
int linux_only;
#endif

/* a block comment that hides a directive:
#if 0
*/
int after_comment;
