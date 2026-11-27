/* typedefcase.h -- a typedef named like its struct but for case: one name to tiko. */
typedef struct pgNotify { char *relname; int be_pid; } PGnotify;
PGnotify *tc_notifies(void);
