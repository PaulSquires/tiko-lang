[Home](Home) › **Compiler Option: -nocopylibs**

# Compiler Option: -nocopylibs

> **In tiko:** do not copy vendor libraries or modules' runtime files beside the output.

## Syntax

`-nocopylibs`

## Description

A program that imports a [vendor package](Vendor-Packages) with `link dynamic` needs the package's DLL or `.so` at run time, and the toolchain's copy is where no loader looks. So after the link the library is copied into the output's directory, under the name the program loads it by -- unless a copy there has the same size and is no older. The files a package lists in `[vendor.<module>] runtime` -- fonts, a library the program loads itself -- are copied the same way, for each module the program imports. `-nocopylibs` skips both copies, for a build that places its files itself; the runtime files are then not looked for either.

### See also

- [Vendor Packages](Vendor-Packages)
- [Compiler Option: -Wl](Compiler-Option-Wl)
