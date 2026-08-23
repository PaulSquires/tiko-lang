# Cleanup traces — the specification, taken from fbc

Construction and destruction **order is observable behaviour**, so it is compatibility
surface (docs/plan/08 §6). These programs print a trace of every constructor,
destructor and `defer`, and the `.fbc-trace` files beside them are what **fbc actually
printed when the program was run** — not what the manual says, and not what tiko-lang
produces.

They are the specification. When tiko-lang can emit code, its output must match these byte
for byte; until then they pin the rules that lowering has to reproduce, and every rule
in `docs/internals/phase-6-cleanup.md` is derived from a line in one of them.

`trace-copies` and `trace-rvo` cover the copy rules. Note what to count there: the
implicit copy is BITWISE and calls nothing, so a copy that happens leaves **no
constructor call** -- only an extra destructor. Counting constructors to detect one
finds nothing.

`trace-goto` covers the scope-crossing jump: it shows the cleanups running
**innermost-first and before the branch**, and that the scope the label sits in is not
cleaned because control stays inside it. See
`docs/internals/phase-6-control.md`.

Regenerate with fbc, never by hand:

```
fbc tests/semantic/cleanup/trace-order.bas -x t.exe && ./t.exe > trace-order.fbc-trace
```
