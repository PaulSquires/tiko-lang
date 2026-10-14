[Home](Home) › [Standard Data Types](Category-Standard-Data-Types) › **Alias (Modifier)**

# Alias (Modifier)

Modifies the data type name mangling (decoration) of a public symbol

## Syntax

```freebasic
... As [ Const ] datatype alias "modifier" [ Const [ Ptr ... ] ]
```

## Parameters

- `datatype`
- `modifier`

## Description

`Alias "modifier"`, when specified following a data type, gives an alternate meaning to the data type, which may be needed for linking with languages other than FreeBASIC.

 Public symbol names are mangled (decorated) to encode information about the data type that is used for the symbol. When linking with the c language, the special meaning of the `alias` modifier is meaningless, since the extra information is not encoded in to the public name. When linking with the c++ language, typically more information is encoded in to the public symbol, and the `alias` modifier may be required. The public name is written to the compiled object file, and used by the linker to match symbol names from one object module to another.

 The same rules for mapping data types is used regardless of which backend (gas or gcc) code emitter is used, And the intent is that FB's compiled code can link consistently with it's own object modules and object modules (or libraries) compiled from other languages.

 *Supported Modifiers*

`Byte alias "char"`  
 `UByte alias "char"`

Used to map FB's 8-bit byte types to c/c++'s 8-bit `char` type.

`Long alias "long"`  
 `ULong alias "long"`

On Win 64-bit targets, used to map FB's 32-bit [`Long`](Long) and [`ULong`](Ulong) types to c/c++'s 32-bit `long [int]` type, instead of the 32-bit `int` type.

`Any alias "char" Ptr`

Maps `any ptr` to c/c++'s `char *`. In c/c++, `char`, `signed char`, and `unsigned char`, are three distinct types.

`any alias "__builtin_va_list" ptr`

Maps the data type to gcc's \_\_builtin_va_list type

`alias "__builtin_va_list"`

Maps the data type to gcc's \_\_builtin_va_list type

`alias "__builtin_va_list[]"`

Maps the data type to gcc's \_\_builtin_va_list type

*Data Type Mapping Details*

 *On all targets, FB to c/c++:*
 Several of FB's data types are consistently mapped across all targets:

*On Dos/Win/Linux 32-bit targets, FB to c/c++:*
 [`Integer`](Integer) on 32-bit targets is 32-bits wide

*On Linux 64-bit targets, FB to c/c++:*
 [`Integer`](Integer) on 64-bit targets is 64-bits wide

*On Win 64-bit targets, FB to c/c++:*
 [`Integer`](Integer) on 64-bit targets is 64-bits wide. However, on Win target, c/c++'s `long int` type is 32-bit, not 64-bit, and we can't use the `long long int` mangling because it's already used by FB's [`LongInt`](Longint) type. Reusing the same mangling (decoration) for two different data types would cause function overloading to fail or have duplicate definitions. To preserve FB's behaviour that `Integer` on 64-bit targets is always 64-bits, we mangle (decorate) the symbol with a custom datatype and keep the size at 64-bit.

To create a data type in FB that will map to c/c++'s `long [int]` 32-bit on win, we must use `alias` modifier.

For example `extern c++ : declare sub proc( byval as long alias "long" ) : end extern`. This allows FreeBASIC to call external c++ procedures (on win-64) requiring a 32-bit `long int` type. Usage of `Alias` in this way affects win-64 targets only, and is ignored on all other targets.

## Remarks

### Usage

```freebasic
Dim variable As datatype alias "modifier"

Type name As datatype alias "modifier"

Declare Sub name ( param As datatype alias "modifier", ... )

Declare Function name ( param As datatype alias "modifier", ... ) As datatype alias "modifier"
```

### Differences from QB

- In QB, `Alias` only worked with [`Declare`](Declare).

### See also

- [`Alias (Name)`](Alias-Name)
- [`Declare`](Declare)
- [`Export`](Export)
- [`Type (Alias)`](Type-Alias)

## Examples

See example at [`Alias (Name)`](Alias-Name).

---

**Category:** [Standard Data Types](Category-Standard-Data-Types)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
