@echo off
rem lint.bat -- runs build\lint.sh.
rem
rem The checks are POSIX shell because they are text scans over the source tree and
rem writing them twice would guarantee the two drift. Git for Windows ships the sh
rem this needs, and the FreeBASIC toolchain assumes a comparable environment.
rem Planned to be replaced by tools\tiko-lang-lint once tiko-lang compiles itself.
setlocal
where sh >nul 2>&1
if errorlevel 1 (
    echo lint: 'sh' not found on PATH; install Git for Windows or run build/lint.sh 1>&2
    exit /b 3
)
sh "%~dp0lint.sh" %*
exit /b %errorlevel%
