@echo off
echo BATCH FILE FOR Harbour MinGW64
rem ============================================================================
SET _PATH=%PATH%
SET _HB_PATH=%HB_PATH%
SET HB_PATH=d:\hb32\
SET MinGW64_PATH=d:\MinGW64\
SET PATH=%HB_PATH%bin\
SET path=%PATH%;%MinGW64_PATH%bin\

   %HB_PATH%bin\hbmk2.exe -strip- -jobs=10 -cpp -compr=no -comp=mingw64 ..\hbp\_tbigNumber.hbp	

SET HB_PATH=%_HB_PATH%
SET PATH=%_PATH%