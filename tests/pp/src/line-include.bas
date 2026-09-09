'' A RELATIVE '#include' RESOLVES AGAINST THE '#line' NAME, not against the file the
'' bytes are really in. Measured, and it was not what I expected:
''
''     #line 5 "sub/fake.bas"
''     #include "h.bi"          picks sub/h.bi
''
'' ...and falls back to the working directory only when sub/h.bi does not exist. The
'' generator that emitted the '#line' is saying where the text came FROM, and fbc
'' takes it at its word.
''
'' There is a decoy beside this file -- src/target.bi -- so the test distinguishes
'' the two answers instead of merely finding A file. Without the '#line' below, the
'' decoy is what an ordinary relative include finds.
#line 5 "tests/pp/src/lineinc/fake.bas"
#include "target.bi"
