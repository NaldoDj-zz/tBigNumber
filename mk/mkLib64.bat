@echo off
echo BATCH FILE FOR Harbour MinGW64
rem ============================================================================
SET _PATH=%PATH%
SET _HB_PATH=%HB_PATH%
SET HB_PATH=D:\GitHub\core\
SET MinGW64_PATH=D:\MinGW64\BIN\
SET PATH=%PATH%;%HB_PATH%
SET PATH=%PATH%;%MinGW64_PATH%
SET HB_CPU=x86_64
SET HB_PLATFORM=win
SET HB_COMPILER=mingw64
SET HB_CCPATH=%MinGW64_PATH%
   %HB_PATH%bin\win\mingw64\hbmk2.exe -plat=win -cpu=x86_64 -jobs=10 -cpp -compr=no -comp=mingw64 ..\hbp\_tbigNumber.hbp	
SET HB_PATH=%_HB_PATH%
SET PATH=%_PATH%