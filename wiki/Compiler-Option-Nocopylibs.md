[Home](Home) › **Compiler Option: -nocopylibs**

# Compiler Option: -nocopylibs

> **In tiko:** do not copy a vendor package's dynamic library beside the output.

## Syntax

`-nocopylibs`

## Description

A program that imports a [vendor package](Vendor-Packages) with `link dynamic` needs the package's DLL or `.so` at run time, and the toolchain's copy is where no loader looks. So after the link the library is copied into the output's directory, under the name the program loads it by -- unless a copy there has the same size and is no older. `-nocopylibs` skips the copy, for a build that places its libraries itself.

### See also

- [Vendor Packages](Vendor-Packages)
- [Compiler Option: -Wl](Compiler-Option-Wl)
