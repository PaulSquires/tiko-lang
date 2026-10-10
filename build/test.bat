@echo off
rem test.bat -- build everything and run the suite. The Linux peer is build/test.sh.
rem
rem   build\test.bat [suite...] [--accept] [--filter <pat>] [-j N] [-v] [--no-build]
rem
rem THE BUILD IS SKIPPED WHEN NOTHING IT DEPENDS ON HAS CHANGED. Building tiko-lang is
rem one fbc invocation over every module and takes about 80 seconds -- more than three
rem times the suite itself -- and it ran unconditionally, so re-running one --filter,
rem accepting a golden, or re-reading a failure each paid it for nothing.
rem
rem What counts as a dependency is deliberately COARSE: for the compiler, anything
rem under src\ plus the source list and build.bat; for the runner, anything under
rem tools\. A .bi is included by whatever includes it and 23 of the .bas files under
rem src\ are #included rather than compiled, so per-file dependency tracking is not
rem something a timestamp can do honestly -- and being wrong in that direction means
rem NOT rebuilding, which is the expensive kind of wrong.
rem
rem TIMESTAMPS ALONE ARE NOT ENOUGH, because they cannot tell a Debug binary from a
rem Release one: 'build\build.bat Release' leaves bin\tiko.exe newer than every source,
rem and the Debug suite would then run the Release binary and report nothing about it.
rem So build.bat -- either peer -- records what it built in build\obj\.build-stamp, and
rem this rebuilds whenever that is missing, is for another configuration, or names
rem another compiler. The compiler ITSELF is a dependency too: a rebuilt stage0 changes
rem what every one of these binaries is.
rem
rem THE COMPARISON IS DONE BY POWERSHELL, which is the one thing here that is not a
rem line-for-line peer of test.sh. cmd has no 'find -newer': forfiles compares whole
rem DAYS, and parsing 'dir' timestamps is locale-dependent. A file-mtime test has to
rem be right or the guard is worse than no guard, so :newer shells out for it.
rem
rem TKO_TEST_REBUILD=1 forces the build; --no-build skips it even when stale.

setlocal
set "ROOT=%~dp0.."
set "CFG=Debug"
set "TIKO=%ROOT%\bin\tiko.exe"
set "RUNNER=%ROOT%\bin\tiko-test.exe"
set "STAMP=%ROOT%\build\obj\.build-stamp"

rem --no-build is ours, not the runner's: strip it before the arguments are passed on.
set "ARGS="
set "NOBUILD=0"
:argloop
if "%~1"=="" goto argsdone
if /i "%~1"=="--no-build" (set "NOBUILD=1") else (set "ARGS=%ARGS% %1")
shift
goto argloop
:argsdone

set "STAMPCFG="
set "STAMPCC="

if "%TKO_TEST_REBUILD%"=="1" goto stale
if not exist "%TIKO%" goto stale
if not exist "%RUNNER%" goto stale
if not exist "%STAMP%" goto stale

set "STAMPED="
set /p STAMPED=<"%STAMP%"
if not defined STAMPED goto stale
for /f "tokens=1,2 delims=|" %%a in ("%STAMPED%") do (
    set "STAMPCFG=%%a"
    set "STAMPCC=%%b"
)
if not "%STAMPCFG%"=="%CFG%" goto stale
rem A different stage0 than bin\ was built with, chosen as build.bat chooses it.
set "WANTCC=%TKO_ORACLE_FBC%"
if not "%TKO_SEED%"=="" set "WANTCC=%TKO_SEED%"
if "%WANTCC%"=="" call "%ROOT%\build\defaultseed.bat" "%ROOT%"
if "%WANTCC%"=="" set "WANTCC=%DEFAULT_SEED%"
if "%WANTCC%"=="" goto ccok
if not "%STAMPCC%"=="%WANTCC%" goto stale
:ccok

call :newer "%TIKO%" "%ROOT%\src" "%ROOT%\build\sources.txt" "%ROOT%\build\build.bat" "%STAMPCC%"
if errorlevel 1 goto stale
call :newer "%RUNNER%" "%ROOT%\tools" "%STAMPCC%"
if errorlevel 1 goto stale
goto fresh

:stale
if "%NOBUILD%"=="1" goto nobuild
call "%ROOT%\build\build.bat" %CFG% --test-runner --no-dll
if errorlevel 1 exit /b 1
goto run

:nobuild
if not exist "%TIKO%" goto nobuildmissing
if not exist "%RUNNER%" goto nobuildmissing
goto run
:nobuildmissing
echo test: --no-build, but bin\tiko.exe or bin\tiko-test.exe is missing 1>&2
exit /b 3

:fresh
echo build: tiko-lang [%CFG%] up to date

:run
pushd "%ROOT%"
"bin\tiko-test.exe"%ARGS%
set "RC=%errorlevel%"
popd
exit /b %RC%

rem ---------------------------------------------------------------------------------
rem IS ANY FILE UNDER THESE NEWER THAN THE REFERENCE? Sets errorlevel 1 when one is.
rem
rem '-File' is load-bearing, not tidiness. fbc writes its objects beside the sources
rem and deletes them after linking, so every directory under src\ ends a build with a
rem timestamp NEWER THAN THE EXECUTABLE it just produced -- and a test that looks at
rem directories therefore says 'stale' immediately after every successful build, which
rem is exactly the bug this guard exists to remove. The '.o' exclusion is the same
rem hazard from the other side: one left behind by an interrupted build would do it.
:newer
setlocal
set "REF=%~1"
shift
set "LIST="
:newerloop
if "%~1"=="" goto newerrun
if defined LIST (set "LIST=%LIST%,'%~1'") else (set "LIST='%~1'")
shift
goto newerloop
:newerrun
if not defined LIST endlocal & exit /b 0
powershell -NoProfile -NonInteractive -Command "$ref = (Get-Item -LiteralPath '%REF%').LastWriteTime; $p = @(%LIST%) | Where-Object { Test-Path -LiteralPath $_ }; if (-not $p) { exit 0 }; $hit = Get-ChildItem -LiteralPath $p -Recurse -File -ErrorAction SilentlyContinue | Where-Object { $_.Extension -ne '.o' -and $_.LastWriteTime -gt $ref } | Select-Object -First 1; if ($hit) { exit 1 } else { exit 0 }"
endlocal & exit /b %errorlevel%
