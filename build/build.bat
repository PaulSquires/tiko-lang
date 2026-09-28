@echo off
rem build.bat -- build tiko-lang with the stage0 compiler (FBC-Modern).
rem
rem   build\build.bat [Debug^|Release^|RelWithDebInfo^|MinSizeRel] [--test-runner] [--no-dll]
rem   build\build.bat [Release^|MinSizeRel] --dll
rem
rem A compiler build also builds the editor's bin\tikoParser.dll and copies it beside
rem tiko-editor.exe (%TKO_EDITOR_DIR%, default C:\dev\tiko-editor-tiko). '--no-dll' skips both.
rem
rem The Linux peer is build/build.sh and is kept line-for-line analogous.
rem Configuration flags live here and nowhere else (docs/plan/02 section 3).

setlocal enabledelayedexpansion

set "ROOT=%~dp0.."
set "CFG=%~1"
if "%CFG%"=="" set "CFG=Debug"
if "%CFG%"=="--test-runner" set "CFG=Debug"
if "%CFG%"=="--no-dll" set "CFG=Debug"
rem '--dll' anywhere: build the editor's tikoParser.dll INSTEAD of the compiler (below).
set "DLL=0"
set "NODLL=0"
set "TESTRUNNER=0"
for %%a in (%*) do (
    if /i "%%~a"=="--dll" set "DLL=1"
    if /i "%%~a"=="--no-dll" set "NODLL=1"
    if /i "%%~a"=="--test-runner" set "TESTRUNNER=1"
)
if "%CFG%"=="--dll" set "CFG=Release"

if "%TKO_STAGE0%"=="" set "TKO_STAGE0=C:\dev\fbc-modern\toolchains\fbc-modern-windows\fbc64.exe"

if not exist "%TKO_STAGE0%" (
    echo build: stage0 compiler not found at %TKO_STAGE0% 1>&2
    echo build: set TKO_STAGE0 to an FBC-Modern fbc 1>&2
    exit /b 3
)

if /i "%CFG%"=="Debug"          set "FLAGS=-g -exx -w all"
if /i "%CFG%"=="RelWithDebInfo" set "FLAGS=-g -w all"
rem Release and MinSizeRel as build.sh has them -- its comments say why: -O 2 because
rem fbc's default is -O 0, and size through the gcc backend because '-O s' is ignored.
if /i "%CFG%"=="Release"        set "FLAGS=-O 2 -w all"
if /i "%CFG%"=="MinSizeRel"     set "FLAGS=-gen gcc -Wc -Os -w all"
if "%FLAGS%"=="" (
    echo build: unknown configuration '%CFG%' 1>&2
    exit /b 2
)

rem The first entry of sources.txt is the main module; -m makes that explicit so the
rem runtime initialises the command line before any module constructor runs.
set "SOURCES="
set "MAINMOD="
for /f "usebackq delims=" %%f in ("%ROOT%\build\sources.txt") do (
    set "LINE=%%f"
    if not "!LINE!"=="" if not "!LINE:~0,1!"=="#" (
        set "SOURCES=!SOURCES! %%f"
        if "!MAINMOD!"=="" for %%n in ("%%f") do set "MAINMOD=%%~nn"
    )
)

if not exist "%ROOT%\bin" mkdir "%ROOT%\bin"
if not exist "%ROOT%\build\obj\%CFG%" mkdir "%ROOT%\build\obj\%CFG%"

rem THE EDITOR'S DLL -- see the peer note in build.sh. The main module is left out, and
rem NEVER -exx: a failed runtime check ends the process, and in a DLL that is the editor.
if "%DLL%"=="1" (
    call :builddll
    if errorlevel 1 exit /b 1
    echo build: ok
    exit /b 0
)
goto :compiler

:builddll
    set "LIBSRC="
    for %%f in (!SOURCES!) do if /i not "%%~nf"=="!MAINMOD!" set "LIBSRC=!LIBSRC! %%f"
    set "DLLFLAGS=!FLAGS:-exx=!"
    echo build: tikoParser.dll [%CFG%] with %TKO_STAGE0%
    pushd "%ROOT%"
    "%TKO_STAGE0%" -dll !LIBSRC! src\api\tikoparser.bas -i src !DLLFLAGS! -x "bin\tikoParser.dll"
    if errorlevel 1 ( popd & exit /b 1 )
    popd
    rem Beside tiko-editor.exe, which loads it from there. A failed copy (a running editor
    rem holds the DLL open) warns and does not fail the build -- see build.sh.
    set "EDITOR=%TKO_EDITOR_DIR%"
    if "!EDITOR!"=="" set "EDITOR=C:\dev\tiko-editor-tiko"
    if not exist "!EDITOR!\" (
        echo build: no editor at !EDITOR! -- tikoParser.dll stays in bin\ ^(set TKO_EDITOR_DIR^)
        exit /b 0
    )
    copy /y "%ROOT%\bin\tikoParser.dll" "!EDITOR!\tikoParser.dll" >nul 2>&1
    if errorlevel 1 (
        echo build: WARNING: could not copy tikoParser.dll to !EDITOR! -- is tiko-editor running? 1>&2
    ) else (
        echo build: tikoParser.dll -^> !EDITOR!
    )
    exit /b 0

:compiler
echo build: tiko-lang [%CFG%] with %TKO_STAGE0%
pushd "%ROOT%"
"%TKO_STAGE0%" !SOURCES! -m !MAINMOD! -i src %FLAGS% -x "bin\tiko.exe"
if errorlevel 1 ( popd & exit /b 1 )

if "%TESTRUNNER%"=="1" goto :buildrunner
goto :done

:buildrunner
echo build: tiko-test [%CFG%]
"%TKO_STAGE0%" tools\tiko-test\tikotest.bas -i src %FLAGS% -mt -x "bin\tiko-test.exe"
if errorlevel 1 ( popd & exit /b 1 )

:done
rem What bin\ now holds -- see the peer note in build.sh.
if not exist "%ROOT%\build\obj" mkdir "%ROOT%\build\obj"
<nul set /p "=%CFG%|%TKO_STAGE0%">"%ROOT%\build\obj\.build-stamp"
popd
if not "%NODLL%"=="1" (
    call :builddll
    if errorlevel 1 exit /b 1
)
echo build: ok
exit /b 0
