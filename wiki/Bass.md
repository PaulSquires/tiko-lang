[Home](Home) › [Tutorials](Category-Tutorials) › **BASS**

# BASS

Audio library for use in Windows with a Beta Version for Linux.

 Website: http://www.un4seen.com/bass.html  
 Platforms supported: Win32, Linux (beta)  
 Headers to include: bass.bi  
 Header version: 2.4.14  
 Examples: in examples/sound/BASS/

Example

```freebasic
#include Once "bass.bi"

'' this mod file should be available in the FreeBASIC package:

Const SOUND_FILE = "..\..\sound\data\dne_trtn.mod"

If (BASS_GetVersion() < MAKELONG(2,2)) Then

    Print "BASS version 2.2 or above required!"

    End 1

End If

If (BASS_Init(-1, 44100, 0, 0, 0) = 0) Then

    Print "Could not initialize BASS"

    End 1

End If

Dim As HMUSIC test = BASS_MusicLoad(False, @SOUND_FILE, 0, 0, BASS_MUSIC_LOOP, 0)

If (test = 0) Then

    Print "BASS could not load '" & SOUND_FILE & "'"

    BASS_Free()

    End 1

End If

BASS_ChannelPlay(test, False)

Print "Sound playing; waiting to keypress to stop and exit..."

Sleep

BASS_ChannelStop(test)

BASS_MusicFree(test)

BASS_Stop()

BASS_Free()
```

---

**Category:** [Tutorials](Category-Tutorials)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
