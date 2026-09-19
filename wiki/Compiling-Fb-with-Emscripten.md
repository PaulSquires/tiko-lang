[Home](Home) › [Compiler Internals](Category-Compiler-Internals) › **Compiling FB with Emscripten**

# Compiling FB with Emscripten

***Build FB and a program on Windows for Emscripten***

 **Prerequisites**

- git installed
- development environment for fbc, rtlib, & gfxlib2
- understand PATH environment variable
- comfortable using a command prompt
- build of latest fbc (that includes latest changes)

**Install Emscripten (on Windows)**

d:/emsdk.git is assumed for installation directory

```freebasic
	d:
	cd \
	git clone https://github.com/emscripten-core/emsdk.git emsdk.git
	cd emsdk.git
	emsdk install latest
	emsdk activate latest
	emsdk_env.bat
```

**Build FBC libraries (on Windows)**

d:/fb.git is assumed for latest fbc checked out from repository

```freebasic
	d:
	cd \fb.git

	REM whatever you use to set-up your fbc build environment (sets PATH)
	call c:\batch\setpath.bat fbgit32

	REM add-in the emscripten build environment (also sets PATH)
	call d:\emsdk.git\emsdk_env.bat

	REM build the rtlib and gfxlib for emscripten
	make rtlib gfxlib2 TARGET=asmjs-unknown-emscripten ENABLE_STANDALONE=1
```

**Hook for 'emcc.bat' (on Windows)**

Here's the issue: fbc expects the supporting tools to be executable and emscripten font-end on windows uses 'emcc.bat' (plus python in the background) and fbc can't directly call a .BAT file. Here's a cheap hack to make it work:  
 Compile the following source and copy 'emcc.exe' to 'd:/fb.git/bin/js-asmjs/emcc.exe'

```freebasic
	'' emcc.exe to call emcc.bat and pass all arguments
	''
	'' tested, but not well tested...
	''
	function EscapeArg( byref arg as const string ) as string
		dim ret as string = """"

		for i as integer = 1 to len(arg)
			select case mid( arg, i, 1 )
			case """"
				ret &= """"""
			case else
				ret &= mid( arg, i, 1 )
			end select
		next

		ret &= """"

		function = ret

	end function

	dim cmd as string = "emcc.bat"

	dim i as integer = 1
	while( command(i) > "" )
		cmd += " " & EscapeArg( command(i) )
		i += 1
	wend

	'' assumes 'emcc.bat' is on PATH

	var result = shell( cmd )

	end result
```

```freebasic
	fbc emcc.bas
	copy emcc.exe d:\fb.git\bin\js-asmjs\emcc.exe
```

**Build an FBC program from fbc source**

The first time this runs, emcc takes a long time because emscripten needs to build it's own runtime library and store the result. After the first time, compile times should be much quicker.

```freebasic
	REM whatever you use to set-up your fbc build environment (sets PATH)
	call c:\batch\setpath.bat fbgit32

	REM add-in the emscripten build environment (also sets PATH)
	call d:\emsdk.git\emsdk_env.bat

	REM build program.bas
	fbc -target js-asmjs program.bas
```

**Run 'program.html'**

In the directory where 'program.html', 'program.js' & 'program.wasm' was created

 Start a server:

`> python -m http.server`

Then, browse to the directory:

`http://localhost:8000/##`

Or the program:

http://localhost:8000/program.html##

---

**Category:** [Compiler Internals](Category-Compiler-Internals)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
