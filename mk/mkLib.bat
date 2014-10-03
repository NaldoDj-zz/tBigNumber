@echo off
echo BATCH FILE FOR Harbour mingw32
rem ============================================================================
SET _PATH=%PATH%
SET _HB_PATH=%HB_PATH%
SET HB_PATH=D:\GitHub\core\
SET MinGW_PATH=D:\MinGW\bin\
SET PATH=%_PATH%;%HB_PATH%
SET PATH=%PATH%;%MinGW_PATH%
SET HB_CPU=x86
SET HB_PLATFORM=win
SET HB_COMPILER=mingw
SET HB_CCPATH=%MinGW_PATH%
    %HB_PATH%bin\win\mingw\hbmk2.exe -plat=win -cpu=x86 -jobs=10 -cpp -compr=no -comp=mingw ..\hbp\_tbigNumber.hbp 
SET HB_PATH=%_HB_PATH%
SET PATH=%_PATH%

