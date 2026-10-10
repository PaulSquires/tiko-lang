/'  crt/win32/locale.bi -- setlocale's CATEGORY NUMBERS on Windows.

    THE PARENT FILE IS glibc's, VERBATIM, AND ITS NUMBERS ARE glibc's. There was
    no win32 arm here at all, so every FreeBASIC program on Windows -- MinGW as
    well as MSVC -- has been getting POSIX categories:

        LC_ALL     glibc 6    Windows 0
        LC_CTYPE   glibc 0    Windows 2
        LC_NUMERIC glibc 1    Windows 4
        LC_TIME    glibc 2    Windows 5

    Two consequences, both measured:

      * setlocale( LC_ALL, ... ) passes 6, which is not a category. MSVCRT
        returns NULL and the call silently does nothing; the UCRT validates the
        argument and its default invalid-parameter handler is __fastfail, so the
        process dies with 0xC0000409 and no output. fbc's own
        tests/chrono/iso.bas does this in no_locale_leakage_ -- which means that
        test has never tested anything on Windows: every call returned NULL and
        its assertions compared unchanged values against unchanged values.

      * LC_CTYPE is 0, which on Windows IS LC_ALL. Any program calling
        setlocale( LC_CTYPE, "" ) to fix multibyte conversion has been setting
        the WHOLE locale, including LC_NUMERIC -- which moves the decimal
        separator, and with it every float-to-string conversion in the program.

    The values below are the C standard's four plus Windows' two, taken from the
    UCRT's own locale.h. LC_MESSAGES AND THE glibc EXTENSIONS ARE DELIBERATELY
    ABSENT: Windows has no LC_MESSAGES, LC_PAPER, LC_NAME, LC_ADDRESS,
    LC_TELEPHONE, LC_MEASUREMENT or LC_IDENTIFICATION, and defining them to
    plausible numbers would hand a caller a value setlocale rejects. Code using
    them stops compiling on Windows, which is the correct outcome and is better
    than what it does today.
'/

#define LC_ALL      0
#define LC_COLLATE  1
#define LC_CTYPE    2
#define LC_MONETARY 3
#define LC_NUMERIC  4
#define LC_TIME     5

#define LC_MIN      LC_ALL
#define LC_MAX      LC_TIME
