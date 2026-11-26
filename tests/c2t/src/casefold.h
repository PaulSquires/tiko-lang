/* casefold.h -- an opaque record and a procedure that differ only in case. */
typedef struct Thing_URL THINGU;

THINGU *thing_url(void);
void thing_url_cleanup(THINGU *handle);
