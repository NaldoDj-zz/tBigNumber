@echo off
echo BATCH FILE FOR Harbour MinGW64
rem ============================================================================
SET _PATH=%PATH%
SET _HB_PATH=%HB_PATH%
SET HB_PATH=c:\hb32\
SET cygwin_PATH=c:\cygwin64\
SET MinGW64_PATH=C:\MinGW64\
SET PATH=%HB_PATH%bin\
SET PATH=%PATH%;%cygwin_PATH%bin\
SET PATH=%PATH%;%cygwin_PATH%usr\bin\
SET path=%PATH%;%MinGW64_PATH%bin\

   %HB_PATH%bin\hbmk2.exe -cpp -compr=no -comp=mingw64 ..\hbp\_tbigNumber.hbp	

SET HB_PATH=%_HB_PATH%
SET PATH=%_PATH%