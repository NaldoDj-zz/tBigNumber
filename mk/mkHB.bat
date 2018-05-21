@echo off
SETLOCAL ENABLEEXTENSIONS
    echo BATCH FILE FOR Harbour mingw32
    rem ============================================================================
    D:
    CD D:\GitHub\tBigNumber\mk\
    IF EXIST env_mkHB.txt (
        DEL env_mkHB.txt /F /Q
    )
    SET > env_mkHB.txt
        SET HB_PATH=D:\GitHub\core\
        SET MinGW_PATH=D:\mingw\bin\
        SET PATH=%MinGW_PATH%;%HB_PATH%;%PATH%
        SET HB_CPU=x86
        SET HB_PLATFORM=win
        SET HB_COMPILER=mingw
        SET HB_CCPATH=%MinGW_PATH%
        IF EXIST D:\OpenSSL-Win32\include (
            SET HB_WITH_OPENSSL=D:\OpenSSL-Win32\include
        )
        IF EXIST D:\FreeImage\Dist\x32 (
            SET HB_WITH_FREEIMAGE=D:\FreeImage\Dist\x32
        )
        IF EXIST D:\mxml (
            SET HB_WITH_MXML=D:\mxml
        )
        IF EXIST D:\libgd\bin (
            SET HB_WITH_GD=D:\libgd\include
        )
        REM SET HB_BUILD_VERBOSE=yes
           D:
           CD %HB_PATH%
           IF "%1"=="-B" (
                IF EXIST ".\bin\win\mingw" (
                    rmdir ".\bin\win\mingw" /s /q
                )
                IF EXIST ".\lib\win\mingw" (
                    rmdir ".\lib\win\mingw" /s /q
                )
           )
           %HB_PATH%\win-make.exe -f MakeFile %1
    D:
    CD D:\GitHub\tBigNumber\mk\
    for /f %%e in (env_mkHB.txt) do (
        SET %%e
    )
    DEL env_mkHB.txt /F /Q
ENDLOCAL
