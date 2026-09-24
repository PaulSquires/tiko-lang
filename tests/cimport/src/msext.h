/* msext.h -- what the MSVC headers are written with. Freestanding.
   Under MS extensions -- win64-msvc -- an anonymous member may be a NAMED record or a
   typedef of one, written with no member name; winuser.h's tagMOUSEHOOKSTRUCTEX and
   objidl.h's _userSTGMEDIUM are both. To C they declare nothing, and to the gnu targets
   they are a warning and a smaller record. */
typedef struct ms_base { int a; int b; } MS_BASE;
struct ms_by_typedef { MS_BASE; unsigned long extra; };
struct ms_by_tag { struct ms_inner { int x; double y; }; void *p; };

/* MSVC's winnt.h pads with unnamed bit-fields where MinGW's names them. */
struct ms_unnamed_bits { unsigned int a : 1; int : 7; unsigned int b : 8; };

#ifdef _WIN32
__declspec(dllimport) extern int ms_imported;
__declspec(dllimport) int ms_imported_fn(int v);
#endif
static __inline int ms_inline(int v) { return v + 1; }
