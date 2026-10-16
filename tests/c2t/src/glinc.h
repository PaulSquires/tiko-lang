/* glinc.h -- OpenGL's header, and decoration-only macros, as rlgl.h has them. */
#ifdef _WIN32
#include <windows.h>
#include <GL/gl.h>               /* tiko's GL/gl.bi: GLenum, GLsizei may now be named */
GLenum glinc_error(GLsizei n);
#endif

#define GLINC_APIENTRY  __stdcall
#define GLINC_IMPORT    __declspec(dllimport)
#define GLINC_VISIBLE   __attribute__((visibility("default")))
