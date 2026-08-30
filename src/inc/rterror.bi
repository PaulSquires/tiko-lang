'' rterror.bi -- the FB_RTERROR codes the runtime sets internally.
''
'' THE INTERNAL CODE IS 1, NOT 5. FB_RTERROR is fbc's own enum and
'' ILLEGALFUNCTIONCALL is simply its second member; the 5 that BASIC's ERR
'' reports is a SEPARATE mapping applied later. Guessing the BASIC number here
'' set FB_RTERROR_OUTOFMEM on every failed seek once already -- a wrong error
'' rather than a missing one, which is why this lives in one place now.

#pragma once

const FB_RTERROR_OK = 0
const FB_RTERROR_ILLEGALFUNCTIONCALL = 1
