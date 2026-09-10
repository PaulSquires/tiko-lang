'' 'var s = *pz' OVER A 'zstring ptr' IS A STRING, and getting no type at all made the
'' LLVM emitter die: 'local void s4' and 'ICE: an alloca of a void slot'. It reported
'' "0 statements not lowered" and PASSED THE VERIFIER -- mirsweep runs '--dump-ir', which
'' stops before codegen, so it called the file clean. build/icescan.sh is what found it.
''
'' Measured with fbc's own typeof:
''
''     *pz                  ZSTRING
''     var s = *pz          STRING     -- a var cannot hold an UNSIZED zstring
''     var zf = zb          STRING     -- and a SIZED source copies into one too
''
'' THE WIDE TWIN IS A DIFFERENT ANSWER and is deliberately not inferred: 'var w = *pw'
'' and 'var wf = wb' are both fbc ERROR 24, Invalid data types. Inferring WSTRING for
'' them would accept two programs fbc refuses. They still ICE, which is its own bug and
'' is recorded in HANDOFF -- an over-acceptance wants a diagnostic, not an inference.
dim as zstring * 8 buf = "fOObAR"
dim as zstring ptr tpz = @buf
var s4 = *tpz

dim as zstring * 8 zb = "abc"
var zf = zb

print s4, zf
