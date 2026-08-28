#ifndef __TKORT_LIST_BI__
#define __TKORT_LIST_BI__

'' list.bi -- declarations for the intrusive list in src/support/list.bas.
''
'' Declared here rather than in each caller so there is one place where the
'' signatures live. All six are non-FBCALL in fb.h, so plain cdecl.

#include once "inc/descriptors.bi"

extern "c"   '' NON-FBCALL: fb.h declares all six without FBCALL.
	declare sub fb_hListInit alias "fb_hListInit" _
		( byval lst as FB_LIST ptr, byval table_ as any ptr, _
		  byval elem_size as uinteger, byval size as uinteger )
	declare function fb_hListAllocElem alias "fb_hListAllocElem" _
		( byval lst as FB_LIST ptr ) as FB_LISTELEM ptr
	declare sub fb_hListFreeElem alias "fb_hListFreeElem" _
		( byval lst as FB_LIST ptr, byval e as FB_LISTELEM ptr )
	declare sub fb_hListDynInit alias "fb_hListDynInit" ( byval lst as FB_LIST ptr )
	declare sub fb_hListDynElemAdd alias "fb_hListDynElemAdd" _
		( byval lst as FB_LIST ptr, byval e as FB_LISTELEM ptr )
	declare sub fb_hListDynElemRemove alias "fb_hListDynElemRemove" _
		( byval lst as FB_LIST ptr, byval e as FB_LISTELEM ptr )
end extern

#endif '' __TKORT_LIST_BI__
