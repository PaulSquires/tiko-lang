[Home](Home) › [Tutorials](Category-Tutorials) › **Using FreeBASIC Built Libraries with GCC**

# Using FreeBASIC Built Libraries with GCC

*by Jeff Marshall*

 Shows how to create a static library with FreeBASIC and then call it from a C program using GCC as the compiler.

 This article shows Windows usage throughout, but application to FreeBASIC on other platforms is similar.

 ***In this tutorial:***

A Simple Test  
 FreeBASIC Library With Dependencies  
 Using FreeBASIC as a Smart Linker

***A Simple Test***

 For this simple test we are going to create a FreeBASIC static library, one without any dependencies. This will make it easier the first time around, and will allow us to check that the basics are working:

 First we need a library, and for for this it will be just a single trivial function that will add two integers together and return the result. Notice the use of `cdecl` and `Alias` in our procedure definition. By default, C uses the `cdecl` calling convention. Using `Alias` in the FreeBASIC declaration makes matching case sensitivity between FreeBASIC and C easier. *C is case sensitive, whereas FreeBASIC normally is not.*

```freebasic
'' mylib1.bas

Function Add2Numbers cdecl Alias "Add2Numbers" _

    ( _

        ByVal x As Integer, _

        ByVal y As Integer _

    ) As Integer

    Return x + y

End Function
```

 Create a file called `mylib1.bas` as above and compile it with:

`fbc -lib mylib1.bas`.

This will create our static library `libmylib1.a`. Next we need a C program that is going to call the library we just made. We must add a prototype that exactly matches the function we have in the FreeBASIC library. The C listing below is our main entry point, will set up a couple of variables to call `Add2Numbers()`, and print the results.

```freebasic
/* test1.c */

#include <stdio.h>

/* Prototype from libmylib.a */

Int Add2Numbers( Int x, Int y );

Int main ()

{

    Int a = 5;

    Int b = 7;

    Int c = Add2Numbers( a, b );

    printf( "a = %d\n", a );

    printf( "c = %d\n", b );

    printf( "a + b = %d\n", c );

    Return 0;

}
```

 To compile this C program using the FreeBASIC library we just made we need to compile `test1.c` as we normally would but also tell it which libraries are needed. In our case, it is `libmylib1.a`.

`gcc test1.c -L . -l mylib1 -o test1.exe`

The '-L .' option tells the linker to search in the current directory for libraries, and the '-l mylib1' indicates that we want to link with the library we just created. This is the simplest case becase the libmylib1.a library has no dependencies. If mylib1.bas needed other libraries, for example the FreeBASIC run-time library libfb.a, we would need to specify that as well to gcc.

 ***FreeBASIC Library With Dependencies***

 Here we create a FreeBASIC library that uses some features from the FreeBASIC runtime and graphics library. In this case we will have to specify any additional needed libraries to GCC.

```freebasic
'' mylib2.bas

Sub TestGfx cdecl Alias "TestGfx" ()

    Screen 12

    Line (0,0)-(100,100),15

    Sleep

End Sub
```

 Create a file called `mylib2.bas` with the listing above and compile it with:

`fbc -lib mylib2.bas`.

This will create our static library `libmylib2.a`. Next we need a C program that is going to call the library we just made. We must add a prototype that exactly matches the function we have in the FreeBASIC library. This C listing will provide our entry point and just call `TestGfx()` before terminating.

```freebasic
/* test2.c */

void TestGfx();

Int main()

{

    TestGfx();

    Return 0;

}
```

 To compile and link `test2.c` directly with `gcc`, not only do we need to tell `gcc` that we want to link with `libmylib2.a`, but also every other library that `libmylib2.a` needs.

```freebasic
gcc test2.c -L. -lmylib2 -L"C:\FreeBASIC\lib\win32" "C:\FreeBASIC\lib\win32\fbrt0.o" -lfbgfx -lfb -lgdi32 -o test2.exe
```

Depending on what our FreeBASIC library uses, it we may use several additional libraries, we must specify all the names of the libraries on the `gcc` command line. In this example, FreeBASIC is located in "C:\\FreeBASIC", but you should specify whatever directory you installed FreeBASIC to. "C:\\"FreeBASIC\\lib\\win32\\fbrt0.o" is a special startup file that will initialize the FreeBASIC runtime library. More specifically, it is initialized after the C runtime library, but before any of our program code is called. The additional `-lfbgfx`, `-lfb`, `-lgdi32`, are the additional libraries needed to complete linking. The actual libraries will vary depending on which FreeBASIC runtime functions are used, and which platform, for DOS or Linux, the program is being compiled for.

 ***Using FreeBASIC as a Smart Linker***

 FreeBASIC has a neat built-in feature that stores a little bit of extra information in the library indicating what compile time options were used, and which dependent libraries are needed. This is a FreeBASIC only feature, so this kind of capability won't be found when using `gcc` as the main compiler and linker.

 If we reuse the examples from the previous section, `mylib2.bas` and `test2.c`, but just go about compiling and linking them differently, we can save ourselves a bunch of typing. Plus we usually won't have to know or remember what our FreeBASIC built library's dependencies are. Compile `mylib2.bas` as before in to a static library.

`fbc -lib mytest2.bas`

Next we compile our C test program. Notice the '-c' option for the `gcc` command line. This indicates that we are just going to compile the C source, but not link it yet. `test2.o` will still have the entry point, but we are going to put it in an object file instead of trying to create an executable right away.

`gcc -c test2.c -o test2.o`

Lastly, we use `fbc` to perform the link step. We are not compiling any basic source files here, but we are going to use the smart linking capabilities of FreeBASIC such that the command line is fairly simple:

`fbc test2.o -l mylib2`

This will create an executable named `test2.exe` because `test2.o` was specified first on the command line. FreeBASIC will read the extra information stored in `libmylib2.a` and automatically know which additional libraries to link with. That's loads easier than using `gcc` directly, especially when many extra FreeBASIC built libraries are needed.

See also

- [Static Libraries](Static-Libraries)

---

**Category:** [Tutorials](Category-Tutorials)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
