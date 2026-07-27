@echo off
rem Build script for Customize Toolbar, a plugin for Notepad++
rem
rem Builds a 64-bit Unicode DLL using the Microsoft C++ compiler. The C runtime is linked
rem statically (/MT), so that the DLL does not depend on the Visual C++ redistributable.
rem
rem Usage:  build.bat  [x64 | Win32]     (default is x64)

setlocal enabledelayedexpansion

rem The target is deliberately not held in a variable named PLATFORM: vcvars32.bat and
rem vcvars64.bat both set PLATFORM themselves, to x86 and x64 respectively, which would
rem silently redirect the output of a Win32 build to bin\x86 instead of bin\Win32.

set "ROOT=%~dp0"
set "TARGET=%~1"
if "%TARGET%"=="" set "TARGET=x64"

if /i "%TARGET%"=="x64" (
    set "VCVARS=vcvars64.bat"
    set "MACHINE=X64"
) else if /i "%TARGET%"=="Win32" (
    set "VCVARS=vcvars32.bat"
    set "MACHINE=X86"
) else (
    echo ERROR: target must be x64 or Win32
    exit /b 1
)

rem -- Locate Visual Studio and set up the compiler environment ------------------------------

rem Delayed expansion is used below because the path to vswhere.exe contains "(x86)", and the
rem closing bracket would otherwise end the FOR /F clause early

set "VSWHERE=%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe"
if not exist "!VSWHERE!" (
    echo ERROR: vswhere.exe not found - Visual Studio does not appear to be installed
    exit /b 1
)

set "VSPATH="
for /f "usebackq tokens=*" %%i in (`"!VSWHERE!" -latest -products * -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath`) do set "VSPATH=%%i"

if not defined VSPATH (
    echo ERROR: no Visual Studio installation with the C++ tools was found
    echo        install the "Desktop development with C++" workload
    exit /b 1
)

call "%VSPATH%\VC\Auxiliary\Build\%VCVARS%" >nul 2>&1
if errorlevel 1 (
    echo ERROR: failed to set up the compiler environment
    exit /b 1
)

rem -- Compile ------------------------------------------------------------------------------

cd /d "%ROOT%"

set "OBJDIR=build\%TARGET%"
set "BINDIR=bin\%TARGET%"

if not exist "%OBJDIR%" mkdir "%OBJDIR%"
if not exist "%BINDIR%" mkdir "%BINDIR%"

echo Compiling resources ...
rc /nologo /I "inc" /I "src" /I "." /fo "%OBJDIR%\CustomizeToolbar.res" "src\CustomizeToolbar.rc"
if errorlevel 1 goto :failed

echo Compiling sources ...
cl /nologo /c /EHsc /O2 /W3 /MT /GS /DWIN32 /DNDEBUG /D_WINDOWS /D_USRDLL /DUNICODE /D_UNICODE ^
   /I "inc" /I "src" /Fo"%OBJDIR%\\" ^
   "src\CustomizeToolbar.cpp" "src\PluginDefinition.cpp"
if errorlevel 1 goto :failed

echo Linking ...
link /nologo /DLL /MACHINE:%MACHINE% /OUT:"%BINDIR%\CustomizeToolbar.dll" ^
   "%OBJDIR%\CustomizeToolbar.obj" "%OBJDIR%\PluginDefinition.obj" "%OBJDIR%\CustomizeToolbar.res" ^
   kernel32.lib user32.lib gdi32.lib comctl32.lib shlwapi.lib
if errorlevel 1 goto :failed

echo.
echo Built %BINDIR%\CustomizeToolbar.dll
echo.
echo To install, copy it over:
echo   %%ProgramFiles%%\Notepad++\plugins\CustomizeToolbar\CustomizeToolbar.dll
exit /b 0

:failed
echo.
echo BUILD FAILED
exit /b 1
