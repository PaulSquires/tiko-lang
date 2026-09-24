#include "common.h"
struct ci_b { ci_common_t c; double b; };
/* a macro of b.h's in terms of a.h's: probed in the unit both are imported into */
#define CI_B_LIMIT (CI_A_LIMIT * 2)
/* a function 'ci_a_limit' beside a.h's constant CI_A_LIMIT: one name to FreeBASIC */
int ci_a_limit(void);
