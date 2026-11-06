@echo off
rem defaultseed.bat ^<root^> -- sets DEFAULT_SEED to the seed stage0 builds with when neither
rem TIKO_SEED nor TIKO_ORACLE_FBC says otherwise, or to nothing when there is none.
rem
rem   call "%ROOT%\build\defaultseed.bat" "%ROOT%"
rem
rem The peer of build/defaultseed.sh, whose header has the order and the reasons: the
rem pinned seed in seed\cache, a packaged toolchain, then both again in the main checkout.

set "DEFAULT_SEED="
set "DS_MAIN="
for /f "delims=" %%g in ('git -C "%~1" rev-parse --path-format^=absolute --git-common-dir 2^>nul') do set "DS_MAIN=%%~dpg"
for %%c in ("%~1\seed\cache\windows\tiko-windows\tiko.exe" "%~1\toolchains\tiko-windows\tiko.exe") do (
    if not defined DEFAULT_SEED if exist "%%~c" set "DEFAULT_SEED=%%~fc"
)
if defined DS_MAIN for %%c in ("%DS_MAIN%seed\cache\windows\tiko-windows\tiko.exe" "%DS_MAIN%toolchains\tiko-windows\tiko.exe") do (
    if not defined DEFAULT_SEED if exist "%%~c" set "DEFAULT_SEED=%%~fc"
)
set "DS_MAIN="
exit /b 0
