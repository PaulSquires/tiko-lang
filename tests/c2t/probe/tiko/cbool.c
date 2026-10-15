/* probe 8: C _Bool results handed to tiko's boolean */
_Bool cb_true(void) { return 1; }
_Bool cb_false(void) { return 0; }
int cb_take(_Bool b) { return b ? 100 : 200; }
