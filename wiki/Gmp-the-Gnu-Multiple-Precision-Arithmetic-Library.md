[Home](Home) › [Tutorials](Category-Tutorials) › **gmp, The GNU Multiple Precision Arithmetic Library**

# gmp, The GNU Multiple Precision Arithmetic Library

Free library for arbitrary precision arithmetic, operating on signed integers, rational numbers, and floating point numbers.

 Website: https://www.gmplib.org  
 Platforms supported: Win32, Linux  
 Headers to include: gmp.bi  
 Header version: 4.1.4

Example

```freebasic
#include Once "gmp.bi"

Dim As mpz_ptr bignum = Allocate(SizeOf(__mpz_struct))

mpz_init_set_si(bignum, 2)

mpz_pow_ui(bignum, bignum, 65536)

Print "2^65536 = ";

Dim As ZString Ptr s = mpz_get_str(0, 10, bignum)

Print *s;

Deallocate(s)

Print

mpz_clear(bignum)

Deallocate(bignum)
```

---

**Category:** [Tutorials](Category-Tutorials)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
