/* macromade.h -- declarations a macro invocation produces. */
#define DECLARE_HANDLE(n) struct n##__ { int unused; }; typedef struct n##__ *n

DECLARE_HANDLE(HWIDGET);
DECLARE_HANDLE(HGADGET);
