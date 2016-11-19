@echo off
SETLOCAL ENABLEEXTENSIONS
    echo BATCH FILE FOR Harbour MinGW64
    rem ============================================================================
    D:
    CD D:\GitHub\tBigNumber\mk\
    IF EXIST env_mk64.txt (
        DEL env_mk64.txt /F /Q
    )
    SET > env_mk64.txt
        SET HB_PATH=D:\GitHub\core\
        SET MinGW64_PATH=D:\MinGW64\BIN\
        SET PATH=%PATH%;%HB_PATH%
        SET PATH=%PATH%;%MinGW64_PATH%
        SET HB_CPU=x86_64
        SET HB_PLATFORM=win
        SET HB_COMPILER=mingw64
        SET HB_CCPATH=%MinGW64_PATH%
        %HB_PATH%bin\win\mingw64\hbmk2.exe -plat=win -cpu=x86_64 -jobs=10 -cpp -compr=max -comp=mingw64 -gui ..\hbp\tBigNtst.hbp
        %HB_PATH%bin\win\mingw64\hbmk2.exe -plat=win -cpu=x86_64 -jobs=10 -cpp -compr=max -comp=mingw64 -gui ..\hbp\tBigNtst_array.hbp
        %HB_PATH%bin\win\mingw64\hbmk2.exe -plat=win -cpu=x86_64 -jobs=10 -cpp -compr=max -comp=mingw64 -gui ..\hbp\tBigNtst_array_assignv.hbp
        %HB_PATH%bin\win\mingw64\hbmk2.exe -plat=win -cpu=x86_64 -jobs=10 -cpp -compr=max -comp=mingw64 -gui ..\hbp\tBigNtst_array_assignv_dyn_obj.hbp
        %HB_PATH%bin\win\mingw64\hbmk2.exe -plat=win -cpu=x86_64 -jobs=10 -cpp -compr=max -comp=mingw64 -gui ..\hbp\tBigNtst_array_dyn_obj.hbp
        %HB_PATH%bin\win\mingw64\hbmk2.exe -plat=win -cpu=x86_64 -jobs=10 -cpp -compr=max -comp=mingw64 -gui ..\hbp\tBigNtst_assignv.hbp
        %HB_PATH%bin\win\mingw64\hbmk2.exe -plat=win -cpu=x86_64 -jobs=10 -cpp -compr=max -comp=mingw64 -gui ..\hbp\tBigNtst_assignv_dyn_obj.hbp
        %HB_PATH%bin\win\mingw64\hbmk2.exe -plat=win -cpu=x86_64 -jobs=10 -cpp -compr=max -comp=mingw64 -gui ..\hbp\tBigNtst_dbfile.hbp
        %HB_PATH%bin\win\mingw64\hbmk2.exe -plat=win -cpu=x86_64 -jobs=10 -cpp -compr=max -comp=mingw64 -gui ..\hbp\tBigNtst_dbfile_assignv.hbp
        %HB_PATH%bin\win\mingw64\hbmk2.exe -plat=win -cpu=x86_64 -jobs=10 -cpp -compr=max -comp=mingw64 -gui ..\hbp\tBigNtst_dbfile_dyn_obj.hbp
        %HB_PATH%bin\win\mingw64\hbmk2.exe -plat=win -cpu=x86_64 -jobs=10 -cpp -compr=max -comp=mingw64 -gui ..\hbp\tBigNtst_dbfile_memio.hbp
        %HB_PATH%bin\win\mingw64\hbmk2.exe -plat=win -cpu=x86_64 -jobs=10 -cpp -compr=max -comp=mingw64 -gui ..\hbp\tBigNtst_dbfile_memio_assignv.hbp
        %HB_PATH%bin\win\mingw64\hbmk2.exe -plat=win -cpu=x86_64 -jobs=10 -cpp -compr=max -comp=mingw64 -gui ..\hbp\tBigNtst_dbfile_memio_dyn_obj.hbp
        %HB_PATH%bin\win\mingw64\hbmk2.exe -plat=win -cpu=x86_64 -jobs=10 -cpp -compr=max -comp=mingw64 -gui ..\hbp\tBigNtst_dbfile_memio_dyn_obj_assignv.hbp
        %HB_PATH%bin\win\mingw64\hbmk2.exe -plat=win -cpu=x86_64 -jobs=10 -cpp -compr=max -comp=mingw64 -gui ..\hbp\tBigNtst_dyn_obj.hbp
    D:
    CD D:\GitHub\tBigNumber\mk\
    for /f %%e in (env_mk64.txt) do (
        SET %%e
    )
    DEL env_mk64.txt /F /Q
ENDLOCAL
