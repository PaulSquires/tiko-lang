[Home](Home) › [2D Drawing Functions](Category-2D-Drawing-Functions) › **ImageDestroy**

# ImageDestroy

Frees an image made by ImageCreate.

## Syntax

```freebasic
Declare Sub ImageDestroy ( ByVal image As Any Ptr )
```

## Parameters

- `image`

## Description

Destroys the image pointed to by `image`, which must be an address returned from a call to [`ImageCreate`](Imagecreate).

 Calling `ImageDestroy` on a null pointer induces no action.

## Remarks

### Usage

`ImageDestroy( image )`

### Dialect Differences

- Not available in the *[-lang qb](Compiler-Option-Lang)* dialect unless referenced with the alias `__Imagedestroy`.

### Differences from QB

- New to FreeBASIC

### See also

- [`ImageCreate`](Imagecreate)

## Examples

See [`ImageCreate`](Imagecreate) for an example on using `ImageDestroy`.

---

**Category:** [2D Drawing Functions](Category-2D-Drawing-Functions)  
**Kind:** sub

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
