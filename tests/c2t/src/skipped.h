/* skipped.h -- branches this pass does not take. */
#ifndef SKIPPED_H
#define SKIPPED_H

#ifdef _WIN32
int win_only;
#else
int linux_only;
#endif

#if 0
this text is not even C
#endif

#endif
