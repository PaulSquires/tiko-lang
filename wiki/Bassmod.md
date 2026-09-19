[Home](Home) › [Tutorials](Category-Tutorials) › **BASSMOD**

# BASSMOD

BASSMOD is a MOD only (XM, IT, S3M, MOD, MTM, UMX) version of BASS - useful for demos, or anything else where you want to play some MOD music.

 Website: http://www.un4seen.com/bassmod.html  
 Platforms supported: Win32, Linux  
 Headers to include: bassmod.bi  
 Header version: 2.0  
 Examples: in examples/sound/BASS/

Example

```freebasic
#include Once "bassmod.bi"

Const SOUND_FILE = "test.mod"

If (BASSMOD_GetVersion() < 2) Then

    Print "BASSMOD version 2 or above required!"

    End 1

End If

If (BASSMOD_Init(-1, 44100, 0) = 0) Then

    Print "Could not initialize BASSMOD"

    End 1

End If

If (BASSMOD_MusicLoad(False, SOUND_FILE, 0, 0, BASS_MUSIC_LOOP) = 0) Then

    Print "BASSMOD could not load '" & SOUND_FILE & "'"

    BASSMOD_Free()

    End 1

End If

BASSMOD_MusicPlay()

Print "Sound playing; waiting for keypress to stop and exit..."

Sleep

BASSMOD_MusicStop()

BASSMOD_MusicFree()

BASSMOD_Free()
```

---

**Category:** [Tutorials](Category-Tutorials)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
