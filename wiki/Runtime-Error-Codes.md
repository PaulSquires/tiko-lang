[Home](Home) › [Miscellaneous](Category-Miscellaneous) › **Runtime Error Codes**

# Runtime Error Codes

Runtime error codes and messages used by the runtime library.

Description

Freebasic returns the following runtime error codes:

| 0 | No error |
| --- | --- |
| 1 | Illegal function call |
| 2 | File not found signal |
| 3 | File I/O error |
| 4 | Out of memory |
| 5 | Illegal resume |
| 6 | Out of bounds array access |
| 7 | Null Pointer Access |
| 8 | No privileges |
| 9 | interrupted signal |
| 10 | illegal instruction signal |
| 11 | floating point error signal |
| 12 | segmentation violation signal |
| 13 | Termination request signal |
| 14 | abnormal termination signal |
| 15 | quit request signal |
| 16 | return without gosub |
| 17 | end of file |

 No user error code range is defined. If [`Error`](Error) is used to set an error code it is wise to use high values to avoid collisions with the list of built-in error codes. (This built-in list may be expanded later.)

See also

- [`Err`](Err)
- [`Error`](Error)
- [`On Error`](On-Error)
- [Error Handling](Error-Handling)

---

**Category:** [Miscellaneous](Category-Miscellaneous)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
