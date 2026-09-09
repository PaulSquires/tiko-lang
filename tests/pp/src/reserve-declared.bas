'' '#pragma reserve NAME' TAKES A NAME OUT OF CIRCULATION -- fbc error 4 for anything
'' that then declares it. The two halves of that fact live in different phases: the
'' reserved name is the PREPROCESSOR's and the declaration is COLLECT's.
#pragma reserve foo

dim as integer foo
