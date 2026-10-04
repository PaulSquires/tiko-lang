import itertools, subprocess, re, sys
FBC='C:/dev/fbc-modern/toolchains/fbc-modern-windows/fbc64.exe'
bins=["^","*","/","\\","mod","+","-","shl","shr","=","<>","<",">","<=",">=","and","or","xor","eqv","imp","andalso","orelse"]
uns=["-","not"]
A,B,C="6","3","2"
code=[]
for o1,o2 in itertools.product(bins,bins):
    code.append(f"print \"{o1}|{o2}\"; {A} {o1} {B} {o2} {C}")
for u,o in itertools.product(uns,bins):
    code.append(f"print \"{u}|{o}\"; {u} {A} {o} {B}")
pp=[]
ppbins=[o for o in bins if o not in ("^","/")]
for o1,o2 in itertools.product(ppbins,ppbins):
    pp.append((f"{A} {o1} {B} {o2} {C}", f"{o1}|{o2}"))
lines=list(code)
for i,(e,lab) in enumerate(pp):
    lines.append(f"#if {e}\nprint \"#{lab} T\"\n#else\nprint \"#{lab} F\"\n#endif")
def build(ls):
    open('prec.bas','w',newline='\n').write("\n".join(ls)+"\n")
    r=subprocess.run([FBC,'prec.bas','-x','prec_f.exe'],capture_output=True,text=True)
    return r.stdout+r.stderr
for it in range(20):
    out=build(lines)
    errs=sorted({int(m) for m in re.findall(r'prec\.bas\((\d+)\) error',out)})
    if not errs: break
    # map file line -> lines index
    idx=[];ln=1
    for k,l in enumerate(lines):
        for _ in l.split("\n"): idx.append(k)
    drop={idx[e-1] for e in errs if e-1<len(idx)}
    lines=[l for k,l in enumerate(lines) if k not in drop]
print(len(lines), "kept;", "errors left" if errs else "clean")
