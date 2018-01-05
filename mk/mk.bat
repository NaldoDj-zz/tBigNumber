@echo off
SETLOCAL ENABLEEXTENSIONS
    echo BATCH FILE FOR Harbour mingw32
    rem ============================================================================
    D:
    CD D:\GitHub\tBigNumber\mk\
    IF EXIST env_mk.txt (
        DEL env_mk.txt /F /Q
    )
    SET > env_mk.txt
        SET HB_PATH=D:\GitHub\core\
        SET MinGW_PATH=D:\MinGW\bin\
        SET PATH=%PATH%;%HB_PATH%
        SET PATH=%PATH%;%MinGW_PATH%
        SET HB_CPU=x86
        SET HB_PLATFORM=win
        SET HB_COMPILER=mingw
        SET HB_CCPATH=%MinGW_PATH%
        %HB_PATH%bin\win\mingw\hbmk2.exe -plat=win -cpu=x86 -strip- -jobs=10 -cpp  -compr=max -comp=mingw -gui ..\hbp\tBigNtst.hbp -l ../hbc/tbigNumber.hbc
        %HB_PATH%bin\win\mingw\hbmk2.exe -plat=win -cpu=x86 -strip- -jobs=10 -cpp  -compr=max -comp=mingw -gui ..\hbp\tBigNtst_array.hbp -l ../hbc/tbigNumber_array.hbc
        %HB_PATH%bin\win\mingw\hbmk2.exe -plat=win -cpu=x86 -strip- -jobs=10 -cpp  -compr=max -comp=mingw -gui ..\hbp\tBigNtst_array_assignv.hbp -l ../hbc/tbigNumber_array_assignv.hbc
        %HB_PATH%bin\win\mingw\hbmk2.exe -plat=win -cpu=x86 -strip- -jobs=10 -cpp  -compr=max -comp=mingw -gui ..\hbp\tBigNtst_array_assignv_dyn_obj.hbp -l ../hbc/tbigNumber_array_assignv_dyn_obj.hbc
        %HB_PATH%bin\win\mingw\hbmk2.exe -plat=win -cpu=x86 -strip- -jobs=10 -cpp  -compr=max -comp=mingw -gui ..\hbp\tBigNtst_array_dyn_obj.hbp -l ../hbc/tbigNumber_array_dyn_obj.hbc
        %HB_PATH%bin\win\mingw\hbmk2.exe -plat=win -cpu=x86 -strip- -jobs=10 -cpp  -compr=max -comp=mingw -gui ..\hbp\tBigNtst_assignv.hbp -l ../hbc/tbigNumber_assignv.hbc
        %HB_PATH%bin\win\mingw\hbmk2.exe -plat=win -cpu=x86 -strip- -jobs=10 -cpp  -compr=max -comp=mingw -gui ..\hbp\tBigNtst_assignv_dyn_obj.hbp -l ../hbc/tbigNumber_assignv_dyn_obj.hbc
        %HB_PATH%bin\win\mingw\hbmk2.exe -plat=win -cpu=x86 -strip- -jobs=10 -cpp  -compr=max -comp=mingw -gui ..\hbp\tBigNtst_dbfile.hbp -l ../hbc/tbigNumber_dbfile.hbc
        %HB_PATH%bin\win\mingw\hbmk2.exe -plat=win -cpu=x86 -strip- -jobs=10 -cpp  -compr=max -comp=mingw -gui ..\hbp\tBigNtst_dbfile_assignv.hbp -l ../hbc/tbigNumber_dbfile_assignv.hbc
        %HB_PATH%bin\win\mingw\hbmk2.exe -plat=win -cpu=x86 -strip- -jobs=10 -cpp  -compr=max -comp=mingw -gui ..\hbp\tBigNtst_dbfile_dyn_obj.hbp -l ../hbc/tbigNumber_dbfile_dyn_obj.hbc
        %HB_PATH%bin\win\mingw\hbmk2.exe -plat=win -cpu=x86 -strip- -jobs=10 -cpp  -compr=max -comp=mingw -gui ..\hbp\tBigNtst_dbfile_memio.hbp -l ../hbc/tbigNumber_dbfile_memio.hbc
        %HB_PATH%bin\win\mingw\hbmk2.exe -plat=win -cpu=x86 -strip- -jobs=10 -cpp  -compr=max -comp=mingw -gui ..\hbp\tBigNtst_dbfile_memio_assignv.hbp -l ../hbc/tbigNumber_dbfile_memio_assignv.hbc
        %HB_PATH%bin\win\mingw\hbmk2.exe -plat=win -cpu=x86 -strip- -jobs=10 -cpp  -compr=max -comp=mingw -gui ..\hbp\tBigNtst_dbfile_memio_dyn_obj.hbp -l ../hbc/tbigNumber_dbfile_memio_dyn_obj.hbc
        %HB_PATH%bin\win\mingw\hbmk2.exe -plat=win -cpu=x86 -strip- -jobs=10 -cpp  -compr=max -comp=mingw -gui ..\hbp\tBigNtst_dbfile_memio_dyn_obj_assignv.hbp -l ../hbc/tbigNumber_dbfile_memio_dyn_obj_assignv.hbc
        %HB_PATH%bin\win\mingw\hbmk2.exe -plat=win -cpu=x86 -strip- -jobs=10 -cpp  -compr=max -comp=mingw -gui ..\hbp\tBigNtst_dyn_obj.hbp -l ../hbc/tbigNumber_dyn_obj.hbc
    D:
    CD D:\GitHub\tBigNumber\mk\
    for /f %%e in (env_mk.txt) do (
        SET %%e
    )
    DEL env_mk.txt /F /Q
ENDLOCAL
