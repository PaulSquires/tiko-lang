[Home](Home) › [FAQs](Category-FAQs) › **Frequently Asked FreeBASIC Graphics Library Questions**

# Frequently Asked FreeBASIC Graphics Library Questions

**FreeBASIC Graphics Library questions:**

**- How can I link/use Gfxlib?**
 **- What about the fbgfx.bi header file?**
 **- How are Get/Put arrays managed?**
 **- Why is Bsave/Bload crashing?**
 **- How can I get the red, green, blue, or alpha component of a colour?**
 **- How can I make the 'x' button in the window header close my application?**
 **- Can't run programs using Screen 13 or 14 in fullscreen !**
 **- Why does Imagecreate return a NULL pointer?**

**FreeBASIC Graphics Library questions**

 **How can I link/use Gfxlib?**

Gfxlib is "built in" into the language, it is not necessary to include any .bi file or to link any library explicitly. FreeBASIC detects you want to use Gfxlib when you use the [Screen (Graphics)](Screen-Graphics) or [ScreenRes](Screenres) statements. So to use Gfxlib, just start a graphics screen mode and use the graphics commands.

Back to top

 **What about the `fbgfx.bi` header file?**

The `fbgfx.bi` header file is available for inclusion by your program, and contains constant and type definitions that may be helpful to the programmer when using Gfxlib. You do not have to explicitly include this file to use Gfxlib however; the header is only available as an aid. It contains the constants for the mode flags that can be passed to [Screen (Graphics)](Screen-Graphics) and [ScreenRes](Screenres), and also definitions of [Keyboard scancodes](Dos-Keyboard-Scancodes) and the [fb.Image buffer structure](Internal-Graphics-Formats).

Back to top

 **How are Get/Put arrays managed?**

In FreeBASIC, images can be used as arrays (as in QB) or as pointers. Either way, the image data is contained in one continuous chunk. The chunk consists of an header followed by the image data. The header can be of two types (old-style and new-style) and determines the format of the following image data, for details see GfxInternalFormats .

Back to top

 **Why is Bsave/Bload crashing?**

Bsave/Bload can only be used to load and save graphics screens in FreeBASIC. It can't be used to save a text mode screen. To load and save an array check this [snippet using file Get/Put](Bload-Bsave-Text-Mode-Work-Around) .

Back to top

 **How can I get the red, green, blue, or alpha component of a color?**

Each byte in a color attribute corresponds with the red, green, blue, and alpha components. The following example shows how to extract the component values from a 16, 24, or 32 bit color attribute.

```freebasic
#define rgb_a(x) ((x) Shr 24)

#define rgb_r(x) ((x) Shr 16 And 255)

#define rgb_g(x) ((x) Shr 8 And 255)

#define rgb_b(x) ((x) And 255)

Dim As UInteger c

Dim As Integer x, y

Dim As UByte red, green, blue, Alpha

'' Assume a 16, 24, or 32 bit screen mode has been set

c = Point(x, y)

red = rgb_r(c)

green = rgb_g(c)

blue = rgb_b(c)

Alpha = rgb_a(c)
```

 Back to top

 **How can I make the 'x' button in the window header close my application?**

In windowed graphics mode you can test for the press of the window's X (close) button with [`Inkey`](Inkey), checking for the value Chr( 255 ) + "k" (which is also the code returned for Alt+F4). This applies to Win32 and Linux, in DOS there is no "X" button.

 Here is a small example:

```freebasic
'' "X" close button example , Win32 and Linux only

Dim As String key

Screen 13

Do

  Print "Click the 'x' to close this app."

  Sleep

  key = Inkey

Loop Until key = Chr(27) Or key = Chr(255, 107) 'escape or x-button
```

 Back to top

 **Can't run programs using Screen 13 or 14 in full-screen!**

It's a hardware/driver limitation (Win32 and Linux only?). Video cards don't implement those low resolution graphic modes nowadays. If full-screen is required you should rewrite it using at least Screen 17 or 18, or a resolution of 640x480 or higher to be sure modern hardware can handle it.

Back to top

 **Why does Imagecreate return a NULL pointer?**

[ImageCreate](Imagecreate) needs to create an image buffer that fits the current screen's pixel format, and it cannot do so if there is no screen mode setup yet, so it returns NULL, very likely resulting in a NULL pointer access later on that crashes the program.

 This is known to happen when Imagecreate is called *before* the graphics library was initialized with a call to [Screen (Graphics)](Screen-Graphics) or [ScreenRes](Screenres), as may happen when Imagecreate is called in a global constructor that is invoked before the Screen or Screenres call in the main part of the program. In such a case it is necessary to move the screen initialization into a constructor too, and have it execute before the image-creating constructors.

Back to top

See also

- [Compiler FAQ](Frequently-Asked-Questions)
- [FB Runtime Library FAQ](Frequently-Asked-Fb-Runtime-Library-Questions)
- [Frequently Asked FreeBASIC Graphics Library Questions](Frequently-Asked-Freebasic-Graphics-Library-Questions)

---

**Category:** [FAQs](Category-FAQs)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
