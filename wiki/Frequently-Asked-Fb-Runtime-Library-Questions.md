[Home](Home) › [FAQs](Category-FAQs) › **Frequently Asked FB Runtime Library Questions**

# Frequently Asked FB Runtime Library Questions

**FreeBASIC Runtime Library questions:**

**- How do I play sound?**
 **- How do I access the serial ports?**
 **- How do I print?**
 **- How do I access the hardware ports?**

**FreeBASIC Runtime Library questions**

 **How do I play sound?**

Of the QB's sound keywords only BEEP is implemented in FB.  
 If PC speaker sound is required, it should be programmed using IN and OUT. See the example in the OUT keyword for a replacement of SOUND.  
 There is a library called QBSound that allows to emulate qb's ability to PLAY in the background tunes encoded in strings, it uses the soundcard's synthesizer.  
 If what's required is to play .wav or .mp3 files thru a soundcard, external libraries as FMOD or BASS can be used in Linux and Windows. For DOS see the [DOS FAQ section](Dos-Related-Faq).

Back to top

 **How do I access the serial ports?**

**DOS**
 See [DOS FAQ section](Dos-Related-Faq).

 **Windows and Linux**
 See [Open Com](Open-Com).

Back to top

 **How do I print?**

FB supports character output to printer.  
 To print graphics two approaches are possible:

- Preprocess the graphics data, program the printer, and send the data to it (see [wikipedia.org/wiki/ESC/P](http://en.wikipedia.org/wiki/ESC/P)). This is OS-portable but depends on the printer model. The only way for DOS, see also [DOS FAQ section](Dos-Related-Faq).
  In Windows and Linux there are specific API calls. This is not OS-portable but the OS's printer driver makes it printer-independent.

Back to top

 **How do I access the hardware ports?**

INP, OUT and WAIT known from QB are implemented in FB.  
 The GfxLib intercepts the calls to some VGA ports to emulate the widely used QB's palette manipulation and vsync methods. So ports &H3DA, &H3C7, &H3C8 and &H3C9 can't be accessed it GfxLib is used. All other ports are accessible.  
 No further tricks are required to use INP and OUT in Linux or DOS. For the Windows version the required device driver is installed each first time the program is run in a windows session; this requires Administrator rights for this first run or the program will end with an error. Note that accessing hardware ports by applications is not common practice in Windows and Linux.

Back to top

See also

- [Compiler FAQ](Frequently-Asked-Questions)
- [Frequently Asked FreeBASIC Graphics Library Questions](Frequently-Asked-Freebasic-Graphics-Library-Questions)

and

- [Win32 related FAQ](Windows-Related-Faq)
- [DOS related FAQ](Dos-Related-Faq)

---

**Category:** [FAQs](Category-FAQs)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
