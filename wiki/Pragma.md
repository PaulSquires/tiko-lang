[Home](Home) › [Preprocessor](Category-Preprocessor) › **#pragma**

# #pragma

Preprocessor directive

## Syntax

```freebasic
#pragma option [ = value ]
#pragma push ( option [, value ] )
#pragma pop ( option )
```

## Parameters

- `option`
- `value`

## Description

Allows the setting of compiler options inside the source code.

 **Push** saves the current value of the *option* onto a stack, then assigns the new *value* (or *True*) to it. **Pop** restores the *option* to its previous value, and removes it from the stack. This mechanism allows options to be changed for a certain part of source code, regardless of the setting used by the context, which is especially useful inside #include header files.

 **`constness`** pragma is added for testing fbc compiler. It will be removed in future at should not be relied upon.

## Remarks

### Version

- *#pragma private* and *#pragma profile* added in version 1.20.0
- *#pragma lookup108* added in version 1.09.0, and to be removed in next minor release

### Differences from QB

- New to FreeBASIC

### See also

- [`#Pragma Reserve`](Pragma-Reserve)
- [`#include`](procedures-Include)
- [`#Cmdline`](Cmdline)
- [Preprocessor Overview](programmer-s-guide-Preprocessor)

## Examples

```freebasic
'' MSVC-compatible bitfields: save the current setting and then enable them

#pragma push(msbitfields)

'' do something that requires MS-compatible bitfields here

'' restore original setting

#pragma pop(msbitfields)
```

---

**Category:** [Preprocessor](Category-Preprocessor)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
