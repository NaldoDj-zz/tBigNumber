:: Batch for setting Harbour Environment in Windows with MSVC compiler (based in GnuCOBOL)
:: x86/win32 version

@echo off

:: the architecture to set / check
set arch=x86
set arch_full=x86

:: restore old PATH to not expand it endlessly
if not "%COB_OLD_PATH%" == "" (
   set "PATH=%COB_OLD_PATH%"
   set "COB_OLD_PATH=%PATH%"
)


echo Setup Visual Studio (%arch%/%arch_full%)...
echo.

:: check if cl.exe with matching architecture is already in path
where cl.exe 1>nul 2>nul
if not "%errorlevel%" == "0" (
   goto :vsvars
)
cl.exe 2>&1 | findstr %arch% > nul
if "%errorlevel%" == "0" (
   echo cl.exe already in PATH
   echo no further initialization is done for the C compiler
   echo.
   goto :gc
)

:vsvars

:: Check for valid MSC Environment and let it do it's work.
:: If not found try Windows SDKs in standard installation folders

:: Visual Studio 2017: no VS150COMNTOOLS globally or vsvars any more...
if exist "%ProgramFiles(x86)%\Microsoft Visual Studio\2017\Community\Common7\Tools\VsDevCmd.bat" (
   call "%ProgramFiles(x86)%\Microsoft Visual Studio\2017\Community\Common7\Tools\VsDevCmd.bat" -arch=%arch_full%
   goto :gc
)
if exist "%ProgramFiles(x86)%\Microsoft Visual Studio\2017\Professional\Common7\Tools\VsDevCmd.bat" (
   call "%ProgramFiles(x86)%\Microsoft Visual Studio\2017\Professional\Common7\Tools\VsDevCmd.bat" -arch=%arch_full%
   goto :gc
)
if exist "%ProgramFiles(x86)%\Microsoft Visual Studio\2017\Enterprise\Common7\Tools\VsDevCmd.bat" (
   call "%ProgramFiles(x86)%\Microsoft Visual Studio\2017\Enterprise\Common7\Tools\VsDevCmd.bat" -arch=%arch_full%
   goto :gc
)
if exist "%ProgramFiles(x86)%\Microsoft Visual Studio\2017\BuildTools\Common7\Tools\VsDevCmd.bat" (
   call "%ProgramFiles(x86)%\Microsoft Visual Studio\2017\BuildTools\Common7\Tools\VsDevCmd.bat" -arch=%arch_full%
   goto :gc
)

:: Visual Studio 2015
if exist "%VS140COMNTOOLS%vsvars32.bat" (
   call "%VS140COMNTOOLS%vsvars32.bat"
   goto :gc
)
:: Visual Studio 2013
if exist "%VS120COMNTOOLS%vsvars32.bat" (
   call "%VS120COMNTOOLS%vsvars32.bat"
   goto :gc
)
:: Visual Studio 2012
if exist "%VS110COMNTOOLS%vsvars32.bat" (
   call "%VS110COMNTOOLS%vsvars32.bat"
   goto :gc
)
:: Visual Studio 2010
if exist "%VS100COMNTOOLS%vsvars32.bat" (
   call "%VS100COMNTOOLS%vsvars32.bat"
   goto :gc
)
:: Visual Studio 2008
if exist "%VS90COMNTOOLS%vsvars32.bat" (
   call "%VS90COMNTOOLS%vsvars32.bat"
   goto :gc
)
:: Visual Studio 2005
if exist "%VS80COMNTOOLS%vsvars32.bat" (
   call "%VS80COMNTOOLS%vsvars32.bat"
   goto :gc
)

echo Warning: Not possible to set %arch_full% environment for Microsoft Visual Studio!
:: Windows SDK 10 (Windows 10 / VS 2015 compiler) - untested
if exist "%ProgramFiles(x86)%\Microsoft SDKs\Windows\v10\Bin\SetEnv.Cmd" (
   call "%ProgramFiles(x86)%\Microsoft SDKs\Windows\v10\Bin\SetEnv.Cmd" /%arch% /release
   goto :gcc
)
if exist "%ProgramFiles%\Microsoft SDKs\Windows\v10\Bin\SetEnv.Cmd" (
   call "%ProgramFiles%\Microsoft SDKs\Windows\v10\Bin\SetEnv.Cmd" /%arch% /release
   goto :gcc
)
:: Windows SDK 8.1 (Windows 8.1 and .NET 4.5.1 / VS 2013 compiler)
if exist "%ProgramFiles(x86)%\Microsoft SDKs\Windows\v8.1\Bin\SetEnv.Cmd" (
   call "%ProgramFiles(x86)%\Microsoft SDKs\Windows\v8.1\Bin\SetEnv.Cmd" /%arch% /release
   goto :gcc
)
if exist "%ProgramFiles%\Microsoft SDKs\Windows\v8.1\Bin\SetEnv.Cmd" (
   call "%ProgramFiles%\Microsoft SDKs\Windows\v8.1\Bin\SetEnv.Cmd" /%arch% /release
   goto :gcc
)
:: Windows SDK 8.0 (Windows 8 and .NET 4.5 / VS 2012 compiler)
if exist "%ProgramFiles(x86)%\Microsoft SDKs\Windows\v8.0\Bin\SetEnv.Cmd" (
   call "%ProgramFiles(x86)%\Microsoft SDKs\Windows\v8.0\Bin\SetEnv.Cmd" /%arch% /release
   goto :gcc
)
if exist "%ProgramFiles%\Microsoft SDKs\Windows\v8.0\Bin\SetEnv.Cmd" (
   call "%ProgramFiles%\Microsoft SDKs\Windows\v8.0\Bin\SetEnv.Cmd" /%arch% /release
   goto :gcc
)
:: Windows SDK 7.1 (Windows 7 and .NET 4 / VS 2010 SP1 compiler)
if exist "%ProgramFiles(x86)%\Microsoft SDKs\Windows\v7.1\Bin\SetEnv.Cmd" (
   call "%ProgramFiles(x86)%\Microsoft SDKs\Windows\v7.1\Bin\SetEnv.Cmd" /%arch% /release
   goto :gcc
)
if exist "%ProgramFiles%\Microsoft SDKs\Windows\v7.1\Bin\SetEnv.Cmd" (
   call "%ProgramFiles%\Microsoft SDKs\Windows\v7.1\Bin\SetEnv.Cmd" /%arch% /release
   goto :gcc
)
:: Windows SDK 7.0 (Windows 7 and .NET 3.5 SP1 / VS 2008 compiler)
if exist "%ProgramFiles(x86)%\Microsoft SDKs\Windows\v7.0\Bin\SetEnv.Cmd" (
   call "%ProgramFiles(x86)%\Microsoft SDKs\Windows\v7.0\Bin\SetEnv.Cmd" /%arch% /release
   goto :gcc
)
if exist "%ProgramFiles%\Microsoft SDKs\Windows\v7.0\Bin\SetEnv.Cmd" (
   call "%ProgramFiles%\Microsoft SDKs\Windows\v7.0\Bin\SetEnv.Cmd" /%arch% /release
   goto :gcc
)
:: Windows SDK 6.1 (Windows 2008 Server and .NET 3.5 / VS 2008 compiler)
if exist "%ProgramFiles(x86)%\Microsoft SDKs\Windows\v6.1\Bin\SetEnv.Cmd" (
   call "%ProgramFiles(x86)%\Microsoft SDKs\Windows\v6.1\Bin\SetEnv.Cmd" /%arch% /release
   goto :gcc
)
if exist "%ProgramFiles%\Microsoft SDKs\Windows\v6.1\Bin\SetEnv.Cmd" (
   call "%ProgramFiles%\Microsoft SDKs\Windows\v6.1\Bin\SetEnv.Cmd" /%arch% /release
   goto :gcc
)

color 0C
echo Warning: Not possible to set %arch_full% environment for Microsoft Windows SDK!

:gcc
color 07

:gc

:: check if cl.exe is already in path
where cl.exe 1>nul 2>nul
if "%errorlevel%" == "0" (
   echo cl.exe that will be used by cobc:
   cl.exe 1>nul
) else (
   echo ERROR: cl.exe not found!
)

echo.
echo.
:: Now the stuff for GnuCOBOL
echo Setting environment for GnuCOBOL.

:: Get the main dir from the batch's position (only works in NT environments)
set "COB_MAIN_DIR=%~dp0"

:: Set the necessary folders for cobc
set "COB_CONFIG_DIR=%COB_MAIN_DIR%config"
set "COB_COPY_DIR=%COB_MAIN_DIR%copy"

set "LOCALEDIR=%COB_MAIN_DIR%po"

:: Set the necessary options for MSC compiler
set "COB_CFLAGS=/I "%COB_MAIN_DIR%include""
set "COB_LIB_PATHS=/LIBPATH:"%COB_MAIN_DIR%lib""
::if "%COB_LIBS%"       EQU "" (
::   if exist "%COB_MAIN_DIR%lib\mpir.lib"	set COB_LIBS=libcob.lib mpir.lib
::   if exist "%COB_MAIN_DIR%lib\libgmp.lib" 	set COB_LIBS=libcob.lib libgmp.lib
::)

:: save current PATH and add the bin path of GnuCOBOL to PATH for further references
if "%COB_OLD_PATH%" == "" (
   set "COB_OLD_PATH=%PATH%"
)
set "PATH=%COB_MAIN_DIR%bin;%PATH%"
