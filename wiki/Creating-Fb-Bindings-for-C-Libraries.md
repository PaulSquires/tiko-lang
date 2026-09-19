[Home](Home) › [Compiler Internals](Category-Compiler-Internals) › **Creating FB bindings for C libraries**

# Creating FB bindings for C libraries

This page aims to document the problems and solutions commonly encountered when creating FB bindings for C libraries.

 In general, FB and C/C++ are very similar. FB follows the same ABI as GCC where applicable, in order to be binary-compatible as much as possible. The language syntax is also similar to C/C++. As a result, a lot of type and procedure declarations can be translated directly 1:1 between C and FB. However, there also are constructs which cannot be translated directly, for example: typedefs declaring function types. FB has function pointer types, but not plain function types.

- The good news: We have tools ([fbfrog](http://www.freebasic.net/forum/viewtopic.php?f=8&t=18712) and [h_2_bi](http://www.freebasic.net/forum/viewtopic.php?f=8&t=15364)) which can do most of the translation automatically.
  The bad news: There always are some problems which cannot be solved automatically and thus need to be fixed manually.

***Data types***

| C/C++ type | Size in bytes (GCC on Linux/Windows) | Corresponding FreeBASIC type (on 32bit or 64bit) |
| --- | --- | --- |
| char | 1 | Byte |
| short \[int\] | 2 | Short |
| int | 4 | Long |
| enum (underlying type int) | 4 | Long |
| long long \[int\] | 8 | LongInt |
| float | 4 | Single |
| double | 8 | Double |
| long double | 12 on 32bit, 16 on 64bit | CLongDouble from crt/longdouble.bi |
| \_Bool/bool | 1 | Byte / Boolean |
| \* (pointer) | 4 on 32bit, 8 on 64bit | Ptr/Pointer |
| ssize_t, intptr_t | 4 on 32bit, 8 on 64bit | Integer |
| size_t, uintptr_t | 4 on 32bit, 8 on 64bit | UInteger |
| long \[int\] | 4 on 32bit systems and Win64 (!), 8 on 64bit Linux/BSD | CLong from crt/long.bi |

- Caveat: `int`/`long` is not `Integer`/`Long`. In FB, `Integer` corresponds to `Pointer` - it's 32bit on 32bit and 64bit on 64bit (on all operating systems). `Long` stays 32bit everywhere. In C, `int` stays 32bit everywhere, and `long` only corresponds to pointers on Linux/BSD systems, but not on Win64, where `long` is still 32bit. On Win64, `long long` is the only 64bit integer type in C. Thus, neither C's `int` nor C's `long` are compatible to FB's `Integer`.
  Caveat: `long int` is not `LongInt`. FB's `LongInt` corresponds to C's `long long`, not C's `long`.  
  `int` can be translated to `Long`, as both are 32bit consistently.  
  `ssize_t` or `intptr_t` can be translated to `Integer` because they typically have the same size as pointers.  
  `long` cannot be translated directly, but we have `crt/long.bi` which provides the target-specific `clong` and `culong` type aliases.  
  `long double` cannot be translated directly, but we have `crt/longdouble.bi` which provides the target-specific `clongdouble` type.  
  `enum` is a special case. Typically their underlying type is `int` (32bit), but in FB `Enum` uses `Integer` (32bit/64bit) and it does not allow changing that. Thus `enums` (used as data type in declarations) cannot be translated as `Enums`.

For example:

```freebasic
Enum MyEnum {

    A,

    B

}
```

has to be translated as:

```freebasic
Type MyEnum As Long

Enum

    A

    B

End Enum
```

- `BOOL` from `windows.h` is just a typedef for `int`, and should not be confused with the C `_Bool` or C++ `bool` types.

***Symbol name conflicts***

- C/C++ is case-sensitive, with ~50 keywords
  FreeBASIC is case-insensitive, with ~400 keywords  
  C code sometimes uses FB keywords as symbol identifiers, for example `INT`, `string`, `open`. Such symbols must be renamed.  
  C code often contains identifiers which differ only in case, for example `GET_VERSION` and `get_version`. This is not allowed in FB; one of the symbols must be renamed.  
  In C, a macro can have the same identifier as a function. This is not allowed in FB; one of the symbols must be renamed.

**Examples**

C code using FB keywords as identifiers:

```freebasic
typedef Int Int;

void Open(void);
```

```freebasic
Type INT_ As Long

Declare Sub open_ cdecl Alias "open"()
```

 C code relying on case-sensitivity:

```freebasic
void foo(void);

void Foo(void);

void FOO(void);
```

```freebasic
'' Wrong translation:

Extern "C"

    Declare Sub foo()

    Declare Sub Foo()  '' error: duplicate definition

    Declare Sub FOO()  '' error: duplicate definition

End Extern
```

```freebasic
'' Correct translation:

Extern "C"

    Declare Sub foo()

    Declare Sub Foo_ Alias "Foo"()

    Declare Sub FOO__ Alias "FOO"()

End Extern
```

 Another classic example where this kind of conflict happens:

```freebasic
#define GET_VERSION_NUMBER 123

Int get_version_number(void);
```

```freebasic
Extern "C"

    #define GET_VERSION_NUMBER_ 123  '' renamed to avoid conflict

    Declare Function get_version_number() As Long

End Extern
```

 Conflict between procedure and macro:

```freebasic
void f(Int);

#define f(i) f(i + 1)
```

```freebasic
Extern "C"

    Declare Sub f(ByVal As Long)

    #define f_(i) f(i + 1)  '' renamed to avoid conflict

End Extern
```

**Solutions**

```freebasic
Type UdtWithKeywordFields

    As ZString Ptr String  '' Field "String" of type ZString Ptr

    As Long Type  '' Field "Type" of type "Long"

    As Long As  '' Field "As" of type "Long"

End Type
```

***Function types***

In C it's possible to have typedefs with function types. Dereferencing a function pointer type results in a function type. FB only has function pointer types, but not function types.

```freebasic
// A Function typedef (Function result = void, no parameters)

typedef void F(void);

// Using it To Declare a Function called f1

F f1;

// Usually f1 would be declared like This (use of Function typedefs Is pretty rare):

void f1(void);

// A more Common use For Function typedefs Is To Declare pointers To them (Function pointers):

Extern F *pf1;
```

 Since FB does not have function types, such typedefs have to be solved out, or turned into a function pointer:

```freebasic
Extern "C"

Type F As Sub()  '' Function pointer type

'' Declaring procedures is only possible with Declare in FB

Declare Sub f1()

'' But at least FB has function pointer types.

'' Since F already is the function pointer in the FB translation, there is no extra PTR here

Extern pf1 As F

End Extern
```

---

**Category:** [Compiler Internals](Category-Compiler-Internals)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
