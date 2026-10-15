/* begin.h -- decoration only, SDL_begin_code.h's shape: opened, closed by end.h. */
#ifdef DECO_BEGIN_H
#error Nested inclusion of begin.h
#endif
#define DECO_BEGIN_H

#if defined(__clang__) || defined(__GNUC__)
#define DECO_API __attribute__((visibility("default")))
#define DECO_MALLOC __attribute__((malloc))
#define DECO_ALIGNED(x) __attribute__((aligned(x)))
#define DECO_HAS_BUILTIN(x) __has_builtin(x)
#elif defined(_MSC_VER)
#define DECO_API __declspec(dllexport)
#define DECO_MALLOC
#define DECO_ALIGNED(x) __declspec(align(x))
#else
#define DECO_ALIGNED(x) PLEASE_DEFINE_DECO_ALIGNED
#endif
#define DECO_CALL __cdecl
#define DECO_INLINE static __inline
#define DECO_NODISCARD [[nodiscard]]

#pragma pack(push, 8)
