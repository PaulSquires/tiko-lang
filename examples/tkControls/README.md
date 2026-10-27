# tkControls examples

A self-test and (for most controls) a demo for every control of `vendor/tkControls`, which
comes with the toolchain. Each folder is a `tiko build` project: `tiko build` writes
`selftest.exe` and `demo.exe` beside its sources.

```
cd tkButton
tiko build
selftest.exe
demo.exe
```

`selftest.exe` drives the control through real SDL events, prints `PASS` / `FAIL` lines and a
summary (`tkButton selftest: 130 passed, 0 failed`), and exits non-zero on a failure.
`demo.exe` is the control to try by hand; `demo.exe --shot out.bmp --scale 1.75` saves a
screenshot.

| Folder | What |
| --- | --- |
| `tpad` | the Notepad Tutorial on tkControls; `tpad --selftest` |
| `tkApp`, `tkHost`, `tkPaint`, `tkTheme`, `tkKeys` | the framework and the core |
| every other `tk*` | one control each |
| `tools/` | `run-all.sh` (the Windows battery), `run-linux.sh` (X11 + Wayland under WSLg), `shots.sh` + `bmpdiff.py` (screenshots), `build-linux-libs.sh` |

On Linux the programs link the system's SDL3, SDL3_ttf and SDL3_image; a distribution without
SDL3 packages can build them with `tools/build-linux-libs.sh`.

`FINDINGS.md` and `PORTING.md` are the notes from porting PsControls to SDL3: what was
measured, the traps, and the rules every control follows. They were written when the package
was its own repository, so `tests/<Name>` there is `examples/tkControls/<Name>` here.

The examples are under the [Mozilla Public License 2.0](LICENSE), as the controls are.
