[Home](Home) › [Reference](Category-Reference) › **BLOAD/BSAVE text mode work-around**

# BLOAD/BSAVE text mode work-around

These functions allow you to use BSAVE and BLOAD in a text mode.

```freebasic
Sub _bsave( file As String, p As Any Ptr, sz As Integer )

  Dim As Long ff

  ff = FreeFile

  Open file For Binary As ff

    fb_fileput( ff, 0, ByVal p, sz )

  Close

End Sub

Sub _bload( file As String, p As Any Ptr )

  Dim As Long ff

  ff = FreeFile

  Open file For Binary As ff

    fb_fileget( ff, 0, ByVal p, LOF( ff ) )

  Close

End Sub
```

---

**Category:** [Reference](Category-Reference)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
