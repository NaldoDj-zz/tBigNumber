@echo off
SETLOCAL ENABLEEXTENSIONS
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

        %HB_PATH%bin\hbmk2.exe -jobs=10 -cpp -compr=max -comp=mingwarm ..\hbpvz\tBigNtst.hbp                  -l ...\hbc\tBigNumber.hbc
        %HB_PATH%bin\hbmk2.exe -jobs=10 -cpp -compr=max -comp=mingwarm ..\hbpvz\tBigNtst_dyn_obj.hbp          -l ...\hbc\tBigNumber_dyn_obj.hbc
        %HB_PATH%bin\hbmk2.exe -jobs=10 -cpp -compr=max -comp=mingwarm ..\hbpvz\tBigNtst_array.hbp            -l ...\hbc\tBigNumber_array.hbc
        %HB_PATH%bin\hbmk2.exe -jobs=10 -cpp -compr=max -comp=mingwarm ..\hbpvz\tBigNtst_array_dyn_obj.hbp    -l ...\hbc\tBigNumber_array_dyn_obj.hbc
        %HB_PATH%bin\hbmk2.exe -jobs=10 -cpp -compr=max -comp=mingwarm ..\hbpvz\tBigNtst_dbfile.hbp           -l ...\hbc\tBigNumber_dbfile.hbc
        %HB_PATH%bin\hbmk2.exe -jobs=10 -cpp -compr=max -comp=mingwarm ..\hbpvz\tBigNtst_dbfile_dyn_obj.hbp   -l ...\hbc\tBigNumber_dbfile_dyn_obj.hbc

    SET cygwin_PATH=%_cygwin_PATH%
    SET HB_PATH=%_HB_PATH%
    SET PATH=%_PATH%
ENDLOCAL
