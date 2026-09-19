[Home](Home) › [FAQs](Category-FAQs) › **Linux Related FAQ**

# Linux Related FAQ

**FreeBASIC Linux questions:**

**- FreeBASIC gives me an error 'ld: can't find -lX11' or something similar!**
 **- How do I install FreeBASIC in Ubuntu?**

**FreeBASIC Linux questions**

 **FreeBASIC gives me an error 'ld: can't find -lX11' or something similar!**

FreeBASIC uses ld to link its files under linux. This program requires that any libraries you use have the '-dev' versions installed. For example, for the above error message, you'd want to install xlib-dev for your distribution. Other common errors are for glibc, which requires glibc-dev, and sdl, which requires sdl-dev. Most distributions make these easily available on your install media.

Back to top

 **How do I install FreeBASIC in Ubuntu?"**

See [This thread in the FB forums](http://www.freebasic.net/forum/viewtopic.php?t=3991&postdays=0&postorder=asc&highlight=install+ubuntu&start=0)

Back to top

See also

[Compiler FAQ](Frequently-Asked-Questions)  
 [FB Runtime Library FAQ](Frequently-Asked-Fb-Runtime-Library-Questions)

---

**Category:** [FAQs](Category-FAQs)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
