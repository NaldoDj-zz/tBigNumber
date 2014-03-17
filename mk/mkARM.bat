@echo off
echo BATCH FILE FOR Harbour MinGW CE ARM
rem ============================================================================
SET _PATH=%PATH%
SET _HB_PATH=%HB_PATH%
SET _cygwin_PATH=%cygwin_PATH%
SET HB_PATH=d:\hb32\
SET cygwin_PATH=d:\cygwin\
SET CYGWIN=nodosfilewarning
SET PATH=%HB_PATH%bin\
SET PATH=%PATH%;%HB_PATH%comp\mingwarm\bin\
SET PATH=%PATH%;%HB_PATH%comp\mingwarm\libexec\gcc\arm-mingw32ce\4.4.0\
SET PATH=%PATH%;%cygwin_PATH%bin\
SET PATH=%PATH%;%cygwin_PATH%usr\bin\
    
    %HB_PATH%bin\hbmk2.exe -strip- -jobs=10 -cpp -compr=max -comp=mingwarm ..\hbp\tBigNtst.hbp
    %HB_PATH%bin\hbmk2.exe -strip- -jobs=10 -cpp -compr=max -comp=mingwarm ..\hbp\tBigNtst_mt.hbp
    %HB_PATH%bin\hbmk2.exe -strip- -jobs=10 -cpp -compr=max -comp=mingwarm ..\hbp\tBigNtst_dyn_obj.hbp
    %HB_PATH%bin\hbmk2.exe -strip- -jobs=10 -cpp -compr=max -comp=mingwarm ..\hbp\tBigNtst_mt_dyn_obj.hbp    
    %HB_PATH%bin\hbmk2.exe -strip- -jobs=10 -cpp -compr=max -comp=mingwarm ..\hbp\tBigNtst_array.hbp
    %HB_PATH%bin\hbmk2.exe -strip- -jobs=10 -cpp -compr=max -comp=mingwarm ..\hbp\tBigNtst_array_mt.hbp    
    %HB_PATH%bin\hbmk2.exe -strip- -jobs=10 -cpp -compr=max -comp=mingwarm ..\hbp\tBigNtst_array_dyn_obj.hbp
    %HB_PATH%bin\hbmk2.exe -strip- -jobs=10 -cpp -compr=max -comp=mingwarm ..\hbp\tBigNtst_array_mt_dyn_obj.hbp    
    %HB_PATH%bin\hbmk2.exe -strip- -jobs=10 -cpp -compr=max -comp=mingwarm ..\hbp\tBigNtst_dbfile.hbp
    %HB_PATH%bin\hbmk2.exe -strip- -jobs=10 -cpp -compr=max -comp=mingwarm ..\hbp\tBigNtst_dbfile_mt.hbp
    %HB_PATH%bin\hbmk2.exe -strip- -jobs=10 -cpp -compr=max -comp=mingwarm ..\hbp\tBigNtst_dbfile_dyn_obj.hbp
    %HB_PATH%bin\hbmk2.exe -strip- -jobs=10 -cpp -compr=max -comp=mingwarm ..\hbp\tBigNtst_dbfile_mt_dyn_obj.hbp

SET cygwin_PATH=%_cygwin_PATH%
SET HB_PATH=%_HB_PATH%
SET PATH=%_PATH%