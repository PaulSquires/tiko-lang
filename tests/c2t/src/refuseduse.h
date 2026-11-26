/* refuseduse.h -- a record left as a TODO, and a declaration that points to it. */
#include <stddef.h>

typedef struct _POLLER {
    max_align_t pad;
    int events;
} POLLER;

int poller_wait(POLLER *fds, unsigned int nfds);
