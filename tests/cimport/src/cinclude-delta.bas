'' Two #cinclude lines that share a header: the second is imported together with the first
'' and written as only what is new, so ci_common_t is declared once. b.h's CI_B_LIMIT is
'' defined in terms of a.h's CI_A_LIMIT and still folds, and b.h's function ci_a_limit,
'' one name with a.h's constant once case is ignored, is renamed rather than duplicated.
#cinclude "tests/cimport/src/ci/a.h"
#cinclude "tests/cimport/src/ci/b.h"
#cinclude "tests/cimport/src/ci/a.h"
dim as ci_a ar
dim as ci_b br
ar.c.tag = CI_COMMON_ONE
br.b = 1.5
print sizeof( ci_a ), sizeof( ci_b ), sizeof( ci_common_t ), CI_A_LIMIT, CI_B_LIMIT, ar.c.tag, br.b
