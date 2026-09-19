[Home](Home) › [Tutorials](Category-Tutorials) › **JNI, The Java Native Interface**

# JNI, The Java Native Interface

Standard programming interface for writing Java native methods and embedding the Java virtual machine into native applications.

 Website: http://download.oracle.com/javase/6/docs/technotes/guides/jni/index.html, http://java.sun.com/docs/books/jni/  
 Platforms supported: Win32, Linux  
 Headers to include: jni.bi  
 Header version: from 2006  
 Examples: in examples/other-languages/Java/

Example

Three files:

- `mylib.bas` - A DLL writting in FreeBASIC

```freebasic
#include "jni.bi"

'' Note: The mangling must be "windows-ms" or the JRE won't find any function

Extern "windows-ms"

    Function Java_MyLib_add( env As JNIEnv Ptr, obj As jobject, l As jint, r As jint ) As jint Export

        Return l + r

    End Function

End Extern
```

- `Mylib.java` - The Java class that represents the interface to the FreeBASIC code and ensures the FreeBASIC DLL is loaded

```freebasic
(cpp)
class MyLib {
	public native int add( int l, int r );
	static {
		System.loadLibrary( "mylib" );
	}
}
```

- `Test.java` - The Java main() that uses the Mylib class

```freebasic
(cpp)
class Test {
	public static void main(String[] args) {
		MyLib lib = new MyLib();
		System.out.println( "2+2=" + lib.add( 2, 2 ) );
	}
}
```

 Steps to test it:

- *Compile the FreeBASIC DLL:* `fbc mylib.bas -dll`
- *Compile the two Java classes:* `javac Mylib.java Test.java`
- *Run the `Test` class:* `java Test`

---

**Category:** [Tutorials](Category-Tutorials)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
