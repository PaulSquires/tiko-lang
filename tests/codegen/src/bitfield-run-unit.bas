type m1 field=1 : as ubyte a :7 : as ushort d :10 : end type
type m2 field=1 : as ubyte a :3 : as ubyte b :4 : as ushort d :10 : as ubyte e : end type
type m3 field=1 : as ushort a :12 : as ubyte b :6 : end type
type m4 field=1 : as ulong a :30 : as ushort b :5 : end type
type m5 field=2 : as ubyte a :7 : as ulong d :30 : end type
type m6 : as ubyte a :7 : as ulong d :30 : end type
type m7 : as ushort a :12 : as ubyte b :6 : as ubyte c :6 : end type
type m8 : as ulong a :30 : as ushort b :5 : as ubyte c : end type
type m9 : as ulongint a :60 : as ulong b :10 : end type
type m10 field=1 : as ulongint a :60 : as ubyte b :6 : end type
type m11 field=4 : as ubyte a :5 : as ushort b :12 : as ulong c :20 : end type
type m12 : as short a :10 : as long b :25 : as byte c :3 : end type
print sizeof(m1); sizeof(m2); sizeof(m3); sizeof(m4); sizeof(m5); sizeof(m6)
print sizeof(m7); sizeof(m8); sizeof(m9); sizeof(m10); sizeof(m11); sizeof(m12)
dim as m1 v1 : v1.a = 127 : v1.d = 1023 : print v1.a; v1.d
dim as m2 v2 : v2.a = 7 : v2.b = 15 : v2.d = 1000 : v2.e = 200 : print v2.a; v2.b; v2.d; v2.e
dim as m3 v3 : v3.a = 4095 : v3.b = 63 : print v3.a; v3.b
dim as m4 v4 : v4.a = 1073741823 : v4.b = 31 : print v4.a; v4.b
dim as m5 v5 : v5.a = 100 : v5.d = 1000000000 : print v5.a; v5.d
dim as m7 v7 : v7.a = 4000 : v7.b = 60 : v7.c = 33 : print v7.a; v7.b; v7.c
dim as m10 v10 : v10.a = 1152921504606846975ull : v10.b = 63 : print v10.a; v10.b
dim as m11 v11 : v11.a = 31 : v11.b = 4095 : v11.c = 1048575 : print v11.a; v11.b; v11.c
dim as m12 v12 : v12.a = -5 : v12.b = 123456 : v12.c = 3 : print v12.a; v12.b; v12.c
type u1f31f : as ubyte a :7 : as ulong d :30 : as ubyte c : end type
type u2f31f : as ubyte a :7 : as ushort d :10 : as ubyte c : end type
type u3f31f field=2 : as ubyte a :7 : as ulong d :30 : as ubyte c : end type
type u4f31f field=1 : as ubyte a :7 : as ulong d :30 : as ubyte c : end type
type u5f31f field=1 : as ushort a :12 : as ulong d :30 : as ubyte c : end type
type u6f31f : as ushort a :12 : as ulong d :30 : as ubyte c : end type
type u7f31f : as ubyte p : as ubyte a :7 : as ulong d :30 : as ubyte c : end type
type u8f31f field=1 : as long a :20 : as long b :20 : as ubyte c : end type
type u9f31f field=1 : as ubyte p : as long a :20 : as long b :20 : as ubyte c : end type
type u10f31f field=1 : as ubyte p : as long a :20 : as ushort b :14 : as ubyte c : end type
print sizeof(u1f31f); offsetof(u1f31f,c); sizeof(u2f31f); offsetof(u2f31f,c); sizeof(u3f31f); offsetof(u3f31f,c); sizeof(u4f31f); offsetof(u4f31f,c); sizeof(u5f31f); offsetof(u5f31f,c)
print sizeof(u6f31f); offsetof(u6f31f,c); sizeof(u7f31f); offsetof(u7f31f,c); sizeof(u8f31f); offsetof(u8f31f,c); sizeof(u9f31f); offsetof(u9f31f,c); sizeof(u10f31f); offsetof(u10f31f,c)
type w1f31g field=1 : as long a :20 : as ulong b :20 : as ubyte c : end type
type w2f31g field=1 : as short a :10 : as ushort b :10 : as ubyte c : end type
type w3f31g field=1 : as ubyte p : as ulong a :20 : as long b :20 : as ubyte c : end type
type w4f31g : as ubyte a :5 : as ubyte b :5 : as ubyte c : end type
type w5f31g field=1 : as ulongint a :40 : as ulong b :30 : as ubyte c : end type
type w6f31g : as ulongint a :40 : as ulong b :30 : as ubyte c : end type
type w7f31g field=1 : as ulong a :30 : as ulongint b :40 : as ubyte c : end type
type w8f31g : as ulong a :30 : as ulongint b :40 : as ubyte c : end type
print sizeof(w1f31g); offsetof(w1f31g,c); sizeof(w2f31g); offsetof(w2f31g,c); sizeof(w3f31g); offsetof(w3f31g,c); sizeof(w4f31g); offsetof(w4f31g,c)
print sizeof(w5f31g); offsetof(w5f31g,c); sizeof(w6f31g); offsetof(w6f31g,c); sizeof(w7f31g); offsetof(w7f31g,c); sizeof(w8f31g); offsetof(w8f31g,c)
dim as w7f31g v : v.a = 1073741823 : v.b = 1099511627775ull : v.c = 9 : print v.a; v.b; v.c
type k1f31h : as ulong a :5 : as ushort b :12 : as ubyte c : end type
type k2f31h field=1 : as ulong a :13 : as ushort b :10 : as ubyte c : end type
type k3f31h : as ulong a :13 : as ushort b :10 : as ubyte c : end type
type k4f31h field=1 : as ubyte p : as ulong a :5 : as ushort b :12 : end type
print sizeof(k1f31h); offsetof(k1f31h,c); sizeof(k2f31h); offsetof(k2f31h,c); sizeof(k3f31h); offsetof(k3f31h,c); sizeof(k4f31h)
dim as k1f31h v1f31h : v1f31h.a = 31 : v1f31h.b = 4095 : v1f31h.c = 7 : print v1f31h.a; v1f31h.b; v1f31h.c
dim as k2f31h v2f31h : v2f31h.a = 8191 : v2f31h.b = 1023 : v2f31h.c = 7 : print v2f31h.a; v2f31h.b; v2f31h.c
dim as k3f31h v3f31h : v3f31h.a = 8191 : v3f31h.b = 1000 : v3f31h.c = 7 : print v3f31h.a; v3f31h.b; v3f31h.c
dim as k4f31h v4f31h : v4f31h.p = 9 : v4f31h.a = 31 : v4f31h.b = 4000 : print v4f31h.p; v4f31h.a; v4f31h.b
