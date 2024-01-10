@echo off
SETLOCAL ENABLEEXTENSIONS
    echo BATCH FILE FOR Harbour tBigNumber
    rem ============================================================================
    D:
    CD D:\GitHub\tBigNumber\mkvz
    IF EXIST env_mkallLib.txt (
        DEL env_mkallLib.txt /F /Q
    )
    SET > env_mkallLib.txt
        SETLOCAL ENABLEEXTENSIONS
            SET HB_CPU=
            SET HB_PLATFORM=
            SET HB_COMPILER=
            SET HB_CCPATH=
            call mkLib.bat
            for /f %%e in (env_mkallLib.txt) do (
                SET %%e
            )
        ENDLOCAL
        SETLOCAL ENABLEEXTENSIONS
            SET HB_CPU=
            SET HB_PLATFORM=
            SET HB_COMPILER=
            SET HB_CCPATH=
            call mkLib64.bat
            SET HB_CPU=
            SET HB_PLATFORM=
            SET HB_COMPILER=
            SET HB_CCPATH=
            for /f %%e in (env_mkallLib.txt) do (
                SET %%e
            )
        ENDLOCAL
        SETLOCAL ENABLEEXTENSIONS
            rem call mkLibARM.bat
        ENDLOCAL
    D:
    CD D:\GitHub\tBigNumber\mkvz
    for /f %%e in (env_mkallLib.txt) do (
        SET %%e
    )
    DEL env_mkallLib.txt /F /Q
ENDLOCAL
