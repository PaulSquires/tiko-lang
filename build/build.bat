@echo off
rem build.bat -- build tiko-lang with the stage0 compiler (FBC-Modern).
rem
rem   build\build.bat [Debug^|Release^|RelWithDebInfo] [--test-runner]
rem
rem The Linux peer is build/build.sh and is kept line-for-line analogous.
rem Configuration flags live here and nowhere else (docs/plan/02 section 3).

setlocal enabledelayedexpansion

set "ROOT=%~dp0.."
set "CFG=%~1"
if "%CFG%"=="" set "CFG=Debug"
if "%CFG%"=="--test-runner" set "CFG=Debug"

if "%TKO_STAGE0%"=="" set "TKO_STAGE0=C:\dev\fbc-modern\toolchains\fbc-modern-windows\fbc64.exe"

if not exist "%TKO_STAGE0%" (
    echo build: stage0 compiler not found at %TKO_STAGE0% 1>&2
    echo build: set TKO_STAGE0 to an FBC-Modern fbc 1>&2
    exit /b 3
)

if /i "%CFG%"=="Debug"          set "FLAGS=-g -exx -w all"
if /i "%CFG%"=="RelWithDebInfo" set "FLAGS=-g -w all"
if /i "%CFG%"=="Release"        set "FLAGS=-w all"
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

echo build: tiko-lang [%CFG%] with %TKO_STAGE0%
pushd "%ROOT%"
"%TKO_STAGE0%" !SOURCES! -m !MAINMOD! -i src %FLAGS% -x "bin\tiko.exe"
if errorlevel 1 ( popd & exit /b 1 )

if /i "%~1"=="--test-runner" goto :buildrunner
if /i "%~2"=="--test-runner" goto :buildrunner
goto :done

:buildrunner
echo build: tiko-test [%CFG%]
"%TKO_STAGE0%" tools\tiko-test\tikotest.bas -i src %FLAGS% -x "bin\tiko-test.exe"
if errorlevel 1 ( popd & exit /b 1 )

:done
popd
echo build: ok
exit /b 0
