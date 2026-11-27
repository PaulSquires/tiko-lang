/* liblzma's config.h for vendor/compression (claude-docs tiko-vendor RFC-0006 CP-9): what xz's own
 * CMakeLists.txt (5.8.4) defines for a default build -- every check, filter, match finder and
 * the lzip decoder, threads on -- written by hand so no CMake or autotools runs. Included
 * through -DHAVE_CONFIG_H (src/common/sysdefs.h). One file for every target, branching on
 * the compiler's own predefines. */

#define HAVE_CHECK_CRC32 1
#define HAVE_CHECK_CRC64 1
#define HAVE_CHECK_SHA256 1

#define HAVE_ENCODERS 1
#define HAVE_DECODERS 1
#define HAVE_ENCODER_LZMA1 1
#define HAVE_ENCODER_LZMA2 1
#define HAVE_ENCODER_DELTA 1
#define HAVE_ENCODER_X86 1
#define HAVE_ENCODER_ARM 1
#define HAVE_ENCODER_ARMTHUMB 1
#define HAVE_ENCODER_ARM64 1
#define HAVE_ENCODER_POWERPC 1
#define HAVE_ENCODER_IA64 1
#define HAVE_ENCODER_SPARC 1
#define HAVE_ENCODER_RISCV 1
#define HAVE_DECODER_LZMA1 1
#define HAVE_DECODER_LZMA2 1
#define HAVE_DECODER_DELTA 1
#define HAVE_DECODER_X86 1
#define HAVE_DECODER_ARM 1
#define HAVE_DECODER_ARMTHUMB 1
#define HAVE_DECODER_ARM64 1
#define HAVE_DECODER_POWERPC 1
#define HAVE_DECODER_IA64 1
#define HAVE_DECODER_SPARC 1
#define HAVE_DECODER_RISCV 1
#define HAVE_LZIP_DECODER 1

#define HAVE_MF_HC3 1
#define HAVE_MF_HC4 1
#define HAVE_MF_BT2 1
#define HAVE_MF_BT3 1
#define HAVE_MF_BT4 1

#define HAVE_STDBOOL_H 1
#define HAVE__BOOL 1
#define HAVE_STDINT_H 1
#define HAVE_INTTYPES_H 1
#define ASSUME_RAM 128
#define TUKLIB_SYMBOL_PREFIX lzma_

#if defined(_WIN32)
#  define MYTHREAD_VISTA 1
#  define HAVE_VISIBILITY 0
#else
#  define MYTHREAD_POSIX 1
#  define HAVE_VISIBILITY 1
#  define HAVE_CLOCK_GETTIME 1
#  define HAVE_CLOCK_MONOTONIC 1
#  define HAVE_FUNC_ATTRIBUTE_CONSTRUCTOR 1
#  ifndef _GNU_SOURCE
#    define _GNU_SOURCE 1   /* sched_getaffinity, CPU_COUNT (CMake: tuklib_use_system_extensions) */
#  endif
#  if defined(__APPLE__)
#    define TUKLIB_CPUCORES_SYSCTL 1
#    define TUKLIB_PHYSMEM_SYSCTL 1
#  else
#    define HAVE_PTHREAD_CONDATTR_SETCLOCK 1
#    define TUKLIB_CPUCORES_SCHED_GETAFFINITY 1
#    define TUKLIB_PHYSMEM_SYSCONF 1
#  endif
#endif

#if defined(__x86_64__) || defined(_M_X64)
#  define HAVE_IMMINTRIN_H 1
#  define HAVE__MM_MOVEMASK_EPI8 1
#  define HAVE_USABLE_CLMUL 1
#  if !defined(_MSC_VER)
#    define HAVE_CPUID_H 1
#  endif
#endif

#if defined(__aarch64__) && defined(__linux__) && !defined(__ANDROID__)
#  define HAVE_ARM64_CRC32 1
#  define HAVE_GETAUXVAL 1
#endif
