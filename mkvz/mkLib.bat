@echo off
SETLOCAL ENABLEEXTENSIONS
    echo BATCH FILE FOR Harbour mingw32
    rem ============================================================================
    D:
    CD D:\GitHub\tBigNumber\mkvz
    IF EXIST env_mkLib.txt (
        DEL env_mkLib.txt /F /Q
    )
    SET > env_mkLib.txt
        SET HB_PATH=D:\GitHub\harbour-core\
        SET MinGW_PATH=D:\MinGW\bin\
        SET PATH=%PATH%;%HB_PATH%
        SET PATH=%PATH%;%MinGW_PATH%
        SET HB_CPU=x86
        SET HB_PLATFORM=win
        SET HB_COMPILER=mingw
        SET HB_CCPATH=%MinGW_PATH%
        %HB_PATH%bin\win\mingw\hbmk2.exe -plat=win -cpu=x86 -jobs=10 -cpp -compr=no -comp=mingw -xhb ..\hbpvz\_tbigNumber.hbp
    D:
    CD D:\GitHub\tBigNumber\mkvz
    for /f %%e in (env_mkLib.txt ) do (
        SET %%e
    )
    DEL env_mkLib.txt /F /Q
ENDLOCAL
