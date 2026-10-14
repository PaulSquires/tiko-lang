[Home](Home) › [Tutorials](Category-Tutorials) › **Embed and Access binary Data in Executable**

# Embed and Access binary Data in Executable

How to **embed** binary **data** into an **executable** file at compile time, and **access** it from program code.  
 `(based from forum posts of caseih and coderJeff)`

 This article describes a way to include binary data in a compiled program, and how to access them.

Principle

The (G)LD linker (included in the FreeBASIC distribution) can process binary data in a file, by turning them into an object file. This object file exports symbols that can be accessed from the program code to read the data.  
 The linker will so build two byte symbols based on the file name provided:

- a symbol for the beginning of the data block (the first data byte),
 - another symbol for the end of the data block (just after the last data byte).

By compiling the user program with the object file, the addresses of these byte symbols allow to get pointers to the beginning and end of the data.

 **Note:** It may be advantageous to apply this principle for example to an audio data file which can thus be included in the executable file. Both a pointer to the start of the audio data and the size of the audio data can be passed to any audio player function.

Example

Simple example to only demonstrate the principle (tested on linux/win 32/64-bit gas/gas64/gcc).  
 This example uses as binary data the ASCII code bytes of a text inserted in a `hello.txt` text file:

`hello.txt` text file for example:

```freebasic
Hello!
Welcome to the forum.

```

Invoke the LD linker manually to turn the `hello.txt` text file into an `hello.o` object file exporting symbols:

`...\ld -r -b binary -o hello.o hello.txt`

Two byte symbols are exported from the `hello.o` object file:

**-** on Windows 32-bit:

`binary_hello_txt_start` : beginning of the data block (the first data byte)  
 `binary_hello_txt_end` : end of the data block (just after the last data byte)

**-** otherwise:

`_binary_hello_txt_start` : beginning of the data block (the first data byte)  
 `_binary_hello_txt_end` : end of the data block (just after the last data byte)

Include the `hello.o` object file in the command-line when compiling the following program (which prints the ASCII code bytes embedded in the executable):

```freebasic
Extern "C"

    #if defined(__FB_WIN32__) And Not defined(__FB_64BIT__)

        Extern hello_txt_start Alias "binary_hello_txt_start" As Const Byte

        Extern hello_txt_end Alias "binary_hello_txt_end" As Const Byte

    #else

        Extern hello_txt_start Alias "_binary_hello_txt_start" As Const Byte

        Extern hello_txt_end Alias "_binary_hello_txt_end" As Const Byte

    #endif

End Extern

Dim hello_ptr As Const Byte Const Ptr = @hello_txt_start

Dim hello_length As Const UInteger = @hello_txt_end - @hello_txt_start

For i As UInteger = 0 To hello_length - 1

    Print Chr(hello_ptr[i]);

Next

Print

Sleep
```

See also

- [Executables](Executables)
- [Compiling a program](Quick-Start#compile-a-program)

---

**Category:** [Tutorials](Category-Tutorials)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
