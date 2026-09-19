[Home](Home) › [Tutorials](Category-Tutorials) › **big_int**

# big_int

Library for using arbitrarily large integers. Note: This library seems to be dead, a possible alternative is [gmp](Gmp-the-Gnu-Multiple-Precision-Arithmetic-Library).

 Website: https://web.archive.org/web/20060112164857/http://valyala.narod.ru/big_int/ http://valyala.narod.ru/big_int/ (archived copy)  
 Github: https://github.com/valyala/big_int  
 Platforms supported: Win32, Linux  
 Headers to include: big_int/big_int.bi  
 Header version: from 2005  
 Examples: in examples/math/big_int/

Example

```freebasic
#include Once "big_int/big_int_full.bi"

Sub print_num(ByVal num As big_int Ptr)

    Dim As big_int_str Ptr s = big_int_str_create(1)

    If (s = 0) Then

        Exit Sub

    End If

    If (big_int_to_str(num, 10, s) <> 0) Then

        Exit Sub

    End If

    Print *s->Str;

    big_int_str_destroy(s)

End Sub

    Dim As big_int Ptr bignum = big_int_create(1)

    big_int_from_int(2, bignum)

    big_int_pow(bignum, 65536, bignum)

    Print "2^65536 = ";

    print_num(bignum)

    Print

    big_int_destroy(bignum)
```

---

**Category:** [Tutorials](Category-Tutorials)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
