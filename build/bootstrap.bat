@echo off
rem bootstrap.bat -- the self-hosting fixpoint: tiko-lang compiles itself, twice.
rem
rem   build\bootstrap.bat [-O^<n^>] [--target ^<name^>] [--stage1 ^<tiko.exe^>] [--seed ^<tiko.exe^>] [--gate]
rem
rem The Linux peer is build/bootstrap.sh and is kept line-for-line analogous; its header
rem says what each of the four assertions is for and what each has already caught.
rem
rem   stage0  the seed builds tiko-lang                          -> stage1
rem   stage1  compiles tiko-lang's own sources                   -> stage2
rem   stage2  compiles them again                                -> stage3
rem
rem   1. stage1 lowers every statement of every module, and every module verifies.
rem   2. stage2 and stage3 are byte-identical files.
rem   3. stage3 compiles a program and it prints what the seed's build of it prints.
rem   4. with --gate, the suite against stage2 fails exactly what it fails against stage1.
rem
rem Headers: TKO_BOOT_INC, else the tree's inc\, else the seed's. Libraries: TKO_BOOT_LIBDIRS (separated
rem by spaces), else per target below. The caller's TKO_LIBPATH and TKO_INCLUDE are not
rem inherited. Everything lands in build\.bootstrap\, cleared first.
rem
rem STAGE0 IS A SEED: --seed ^<tiko.exe^> (or TKO_SEED), else defaultseed.bat's pick -- a
rem packaged tiko, where FBC-Modern was until 2026-10-10; nothing here runs or reads fbc.
rem The seed builds stage1 with stage2's own command, so
rem stage1 == stage2 is checked too; headers, libraries and hello's reference are the seed's.
rem build/bootstrap.sh's header has the reasoning.

setlocal enabledelayedexpansion

set "ROOT=%~dp0.."
pushd "%ROOT%"
set "ROOT=%CD%"

set "OPT="
set "TARGET=windows-x86_64"
set "STAGE1="
set "GATE=0"
:argloop
if "%~1"=="" goto argsdone
set "A=%~1"
if "!A:~0,2!"=="-O" ( set "OPT=%~1" & shift & goto argloop )
if /i "%~1"=="--target" ( set "TARGET=%~2" & shift & shift & goto argloop )
if /i "%~1"=="--stage1" ( set "STAGE1=%~2" & shift & shift & goto argloop )
if /i "%~1"=="--gate" ( set "GATE=1" & shift & goto argloop )
if /i "%~1"=="--seed" ( set "TKO_SEED=%~2" & shift & shift & goto argloop )
echo bootstrap: unknown argument '%~1' 1>&2
popd & exit /b 2
:argsdone

rem THE SEED IS STAGE0, as in build.bat: TKO_SEED or --seed, else defaultseed.bat's pick.
rem TKO_STAGE0 -- fbc, until 2026-10-10 -- is ignored, and said so.
if not "%TKO_STAGE0%"=="" echo bootstrap: TKO_STAGE0 is retired and ignored -- the seed is stage0 1>&2
if "%TKO_SEED%"=="" call "%ROOT%\build\defaultseed.bat" "%ROOT%"
if "%TKO_SEED%"=="" set "TKO_SEED=%DEFAULT_SEED%"
if "%TKO_SEED%"=="" (
    echo bootstrap: no seed compiler -- seed/fetch-seed.sh, or --seed ^<tiko.exe^> 1>&2
    popd & exit /b 3
)
if not exist "%TKO_SEED%" (
    echo bootstrap: no seed compiler at %TKO_SEED% ^(a tiko executable^) 1>&2
    popd & exit /b 3
)
set "SEEDDIR="
for %%d in ("%TKO_SEED%") do set "SEEDDIR=%%~dpd"
rem The tree's own headers first (phase H), as build.bat uses them.
if "%TKO_BOOT_INC%"=="" if exist "%ROOT%\inc\" set "TKO_BOOT_INC=%ROOT%\inc"
if "%TKO_BOOT_INC%"=="" set "TKO_BOOT_INC=%SEEDDIR%inc"
if not exist "%TKO_BOOT_INC%\" (
    echo bootstrap: no header directory %TKO_BOOT_INC% ^(set TKO_BOOT_INC^) 1>&2
    popd & exit /b 3
)

rem THE SEED'S NAME FOR THE TARGET. windows-x86_64 was win64-msvc until 2026-10-12, and a seed
rem from before then knows only the old name -- for -target and for its lib\ directory.
rem The seed is asked: the second line of --version names its default target (bootstrap.sh).
set "SEED_TARGET=%TARGET%"
set "SEED_DEFAULT="
for /f "tokens=2 delims=, " %%a in ('call "%TKO_SEED%" --version 2^>nul ^| findstr /b /c:"target "') do set "SEED_DEFAULT=%%a"
if /i "%TARGET%"=="windows-x86_64" if /i "%SEED_DEFAULT%"=="win64-msvc" set "SEED_TARGET=win64-msvc"

rem The seed's runtime and import libraries, and for win64 the MinGW runtime where it has one.
if "%TKO_BOOT_LIBDIRS%"=="" (
    set "TKO_BOOT_LIBDIRS=%SEEDDIR%lib\%SEED_TARGET%"
    if exist "%SEEDDIR%lib\%SEED_TARGET%-fb\" set "TKO_BOOT_LIBDIRS=%SEEDDIR%lib\%SEED_TARGET% %SEEDDIR%lib\%SEED_TARGET%-fb"
)
if "%TKO_BOOT_LIBDIRS%"=="" (
    if /i "%TARGET%"=="windows-x86_64" set "TKO_BOOT_LIBDIRS=%ROOT%\toolchains\tiko-windows\lib\windows-x86_64"
    rem MinGW needs its CRT objects beside the runtime; see cmdline.bas.
    if /i "%TARGET%"=="win64" set "TKO_BOOT_LIBDIRS=%ROOT%\toolchains\tiko-windows\lib\win64"
    if /i "%TARGET%"=="win64" if exist "%ROOT%\toolchains\tiko-windows\lib\win64-fb\" set "TKO_BOOT_LIBDIRS=%ROOT%\toolchains\tiko-windows\lib\win64 %ROOT%\toolchains\tiko-windows\lib\win64-fb"
)
if "%TKO_BOOT_LIBDIRS%"=="" (
    echo bootstrap: unknown target '%TARGET%' 1>&2
    popd & exit /b 2
)
set "LIBP="
for %%d in (%TKO_BOOT_LIBDIRS%) do (
    if not exist "%%~d\" (
        echo bootstrap: no library directory %%~d ^(set TKO_BOOT_LIBDIRS^) 1>&2
        popd & exit /b 3
    )
    set "LIBP=!LIBP! -p "%%~d""
)

set "TKO_LIBPATH="
set "TKO_INCLUDE=%TKO_BOOT_INC%"
rem The tree's std modules: the compiler's source imports std/containers and std/fs.
set "TKO_PKG=%ROOT%\pkg"

set "SOURCES="
set "MAINMOD="
set "NMOD=0"
for /f "usebackq delims=" %%f in ("%ROOT%\build\sources.txt") do (
    set "LINE=%%f"
    if not "!LINE!"=="" if not "!LINE:~0,1!"=="#" (
        set "SOURCES=!SOURCES! %%f"
        set /a NMOD+=1
        if "!MAINMOD!"=="" for %%n in ("%%f") do set "MAINMOD=%%~nn"
    )
)

set "OUT=%ROOT%\build\.bootstrap"
if exist "%OUT%" rmdir /s /q "%OUT%"
mkdir "%OUT%\stage1" "%OUT%\stage2" "%OUT%\stage3" "%OUT%\hello"

set "SHOWOPT=%OPT%"
if "%SHOWOPT%"=="" set "SHOWOPT=-O0"
echo bootstrap: target %TARGET% %SHOWOPT%, %NMOD% modules, headers %TKO_BOOT_INC%

rem ------------------------------------------------------------------ stage1
if not "%STAGE1%"=="" (
    if not exist "%STAGE1%" ( set "WHY=no stage1 compiler at %STAGE1%" & goto fail )
    copy /y "%STAGE1%" "%OUT%\stage1\tiko.exe" >nul
    echo bootstrap: stage1  %STAGE1%
    goto stage1done
)
rem stage1 BY THE SEED, with stage2's own command; --gate's runner is the seed's too.
call :buildstage "%TKO_SEED%" stage1 %SEED_TARGET%
if errorlevel 1 goto fail
if not "%GATE%"=="1" goto stage1done
call "%ROOT%\build\build.bat" Debug --test-runner --no-dll > "%OUT%\runner.log" 2>&1
if errorlevel 1 ( type "%OUT%\runner.log" 1>&2 & set "WHY=the seed could not build the test runner" & goto fail )
:stage1done
set "S1=%OUT%\stage1\tiko.exe"

rem -------------------------------------------- 1. every statement lowers
set "TKO_MODCACHE=%OUT%\lowered.modcache"
"%S1%" --dump-ir -target %TARGET% -i src %SOURCES% 2>&1 | findstr /b /c:"lowered:" /c:"verify:" > "%OUT%\lowered.txt"
for /f %%n in ('findstr /b /c:"lowered:" "%OUT%\lowered.txt" ^| "%SystemRoot%\System32\find.exe" /c /v ""') do set "NLOW=%%n"
for /f %%n in ('findstr /b /c:"verify: ok" "%OUT%\lowered.txt" ^| "%SystemRoot%\System32\find.exe" /c /v ""') do set "NVER=%%n"
for /f %%n in ('findstr /b /c:"lowered:" "%OUT%\lowered.txt" ^| findstr /v /c:" 0 statements not lowered" ^| "%SystemRoot%\System32\find.exe" /c /v ""') do set "NDEC=%%n"
if not "%NLOW%"=="%NMOD%" ( set "WHY=--dump-ir reported %NLOW% modules of %NMOD% (see %OUT%\lowered.txt)" & goto fail )
if not "%NVER%"=="%NMOD%" ( set "WHY=only %NVER% of %NMOD% modules verified (see %OUT%\lowered.txt)" & goto fail )
if not "%NDEC%"=="0" ( set "WHY=%NDEC% modules have statements stage1 does not lower (see %OUT%\lowered.txt)" & goto fail )
echo bootstrap: stage1  lowers every statement of all %NMOD% modules; all verify

rem ------------------------------------------------------------ stage2, stage3
call :buildstage "%S1%" stage2 %TARGET%
if errorlevel 1 goto fail
call :buildstage "%OUT%\stage2\tiko.exe" stage3 %TARGET%
if errorlevel 1 goto fail

rem ------------------------------------------------------------- 2. fixpoint
fc /b "%OUT%\stage2\tiko.exe" "%OUT%\stage3\tiko.exe" >nul
if errorlevel 1 ( set "WHY=stage2 and stage3 differ" & goto fail )
set "HASH="
for /f "skip=1 delims=" %%h in ('certutil -hashfile "%OUT%\stage3\tiko.exe" SHA256') do if not defined HASH set "HASH=%%h"
echo bootstrap: fixpoint  stage2 == stage3, sha256 !HASH:~0,16!...
if not "%STAGE1%"=="" goto fixdone
fc /b "%OUT%\stage1\tiko.exe" "%OUT%\stage2\tiko.exe" >nul
if errorlevel 1 ( set "WHY=stage1 (the seed's build) and stage2 differ" & goto fail )
echo bootstrap: fixpoint  stage1 == stage2 as well: the seed reproduces this commit's compiler
:fixdone

rem ------------------------------------------ 3. stage3 builds a working program
> "%OUT%\hello\hello.bas" (
    echo namespace Boot
    echo     const WHO as string = "stage3"
    echo end namespace
    echo function Twice^( byval n as long ^) as long
    echo     return n * 2
    echo end function
    echo dim as string s = "hello from " ^& Boot.WHO
    echo print s; Twice^( 21 ^); " "; len^( s ^)
)
"%OUT%\stage3\tiko.exe" "%OUT%\hello\hello.bas" -target %TARGET% %LIBP% -o "%OUT%\hello\hello3.exe" > "%OUT%\hello\build3.log" 2>&1
if errorlevel 1 ( type "%OUT%\hello\build3.log" 1>&2 & set "WHY=stage3 could not build hello.bas" & goto fail )
"%OUT%\hello\hello3.exe" > "%OUT%\hello\out3.txt" 2>&1
if errorlevel 1 ( set "WHY=stage3's hello did not run" & goto fail )
pushd "%OUT%\hello"
"%TKO_SEED%" hello.bas -target %SEED_TARGET% %LIBP% -o hello0.exe > build0.log 2>&1
set "RC=%ERRORLEVEL%"
popd
if not "%RC%"=="0" ( set "WHY=the reference compiler could not build hello.bas" & goto fail )
"%OUT%\hello\hello0.exe" > "%OUT%\hello\out0.txt" 2>&1
fc /b "%OUT%\hello\out0.txt" "%OUT%\hello\out3.txt" >nul
if errorlevel 1 ( set "WHY=stage3's hello prints differently from the seed's" & goto fail )
echo bootstrap: stage3  builds hello.bas, and it prints what the seed's build prints

rem ------------------------------------------------- 4. the suite, both ways
if not "%GATE%"=="1" goto done
if not exist "%ROOT%\bin\tiko-test.exe" ( set "WHY=--gate needs bin\tiko-test.exe (build.bat Debug --test-runner)" & goto fail )
set "TKO_INCLUDE="
rem The package tree, named: a stage's default ^<exe-dir^>\..\pkg is none -- see bootstrap.sh.
set "TKO_PKG=%ROOT%\pkg"
call "%ROOT%\build\test.bat" --no-build --tiko-lang "%S1%" > "%OUT%\gate1.log" 2>&1
call "%ROOT%\build\test.bat" --no-build --tiko-lang "%OUT%\stage2\tiko.exe" > "%OUT%\gate2.log" 2>&1
findstr /b /c:"FAIL " "%OUT%\gate1.log" | "%SystemRoot%\System32\sort.exe" > "%OUT%\fail1.txt"
findstr /b /c:"FAIL " "%OUT%\gate2.log" | "%SystemRoot%\System32\sort.exe" > "%OUT%\fail2.txt"
set "SUM1="
set "SUM2="
for /f "delims=" %%s in ('findstr /b /c:"tiko-test" "%OUT%\gate1.log"') do set "SUM1=%%s"
for /f "delims=" %%s in ('findstr /b /c:"tiko-test" "%OUT%\gate2.log"') do set "SUM2=%%s"
if "%SUM1%"=="" ( set "WHY=the suite did not report a result (see %OUT%\gate1.log)" & goto fail )
if "%SUM2%"=="" ( set "WHY=the suite did not report a result (see %OUT%\gate2.log)" & goto fail )
echo bootstrap: suite   stage1: %SUM1:*: =%
echo bootstrap: suite   stage2: %SUM2:*: =%
fc "%OUT%\fail1.txt" "%OUT%\fail2.txt" >nul
if errorlevel 1 ( fc "%OUT%\fail1.txt" "%OUT%\fail2.txt" 1>&2 & set "WHY=the suite fails differently against stage2 than against stage1" & goto fail )
echo bootstrap: suite   stage2 fails exactly what stage1 fails

:done
echo bootstrap: ok
popd
exit /b 0

:fail
echo bootstrap: FAILED -- %WHY% 1>&2
popd
exit /b 1

rem %1 = the compiler, %2 = the stage it builds, %3 = its name for the target
:buildstage
rem Each stage compiles the std modules itself, into a cache of its own (bootstrap.sh).
set "TKO_MODCACHE=%OUT%\%~2.modcache"
"%~1" %SOURCES% -m %MAINMOD% -i src -target %~3 %OPT% %LIBP% -o "%OUT%\%~2\tiko.exe" > "%OUT%\%~2.log" 2>&1
if errorlevel 1 ( type "%OUT%\%~2.log" 1>&2 & set "WHY=%~2 did not build" & exit /b 1 )
if not exist "%OUT%\%~2\tiko.exe" ( set "WHY=%~2 reported success and wrote no compiler" & exit /b 1 )
for %%z in ("%OUT%\%~2.log") do if %%~zz gtr 0 ( type "%OUT%\%~2.log" 1>&2 & set "WHY=%~2's build printed diagnostics" & exit /b 1 )
for %%z in ("%OUT%\%~2\tiko.exe") do set "SZ=%%~zz"
echo bootstrap: %~2  built, !SZ! bytes
exit /b 0
