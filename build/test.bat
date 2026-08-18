@echo off
rem test.bat -- build everything and run the suite. The Linux peer is build/test.sh.
setlocal
set "ROOT=%~dp0.."
call "%ROOT%\build\build.bat" Debug --test-runner
if errorlevel 1 exit /b 1
pushd "%ROOT%"
"bin\fbx-test.exe" %*
set "RC=%errorlevel%"
popd
exit /b %RC%
