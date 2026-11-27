/* vendor/pl_mpeg: a STAND-IN for the macOS SDK's <stdio.h>, for c2t's macOS pass run on Windows, where
   no Apple file may be (prepare.py). pl_mpeg.h's declarations need FILE, as an incomplete type --
   all they ever do is pass a FILE pointer -- and nothing else from it. */
#pragma once
typedef struct __sFILE FILE;
