@echo off
SETLOCAL ENABLEEXTENSIONS
    echo BATCH FILE FOR Harbour tBigNumber
    rem ============================================================================
    D:
    CD D:\GitHub\tBigNumber\mkvz
    IF EXIST env_mkall.txt (
        DEL env_mkall.txt /F /Q
    )
    SET > env_mkall.txt
        SETLOCAL ENABLEEXTENSIONS
            SET HB_CPU=
            SET HB_PLATFORM=
            SET HB_COMPILER=
            SET HB_CCPATH=
            call mk.bat
            for /f %%e in (env_mkall.txt) do (
                SET %%e
            )
        ENDLOCAL
        SETLOCAL ENABLEEXTENSIONS
            SET HB_CPU=
            SET HB_PLATFORM=
            SET HB_COMPILER=
            SET HB_CCPATH=
            call mk64.bat
            for /f %%e in (env_mkall.txt) do (
                SET %%e
            )
        ENDLOCAL
        SETLOCAL ENABLEEXTENSIONS
            SET HB_CPU=
            SET HB_PLATFORM=
            SET HB_COMPILER=
            SET HB_CCPATH=
            rem call mkarm.bat
        ENDLOCAL
    D:
    CD D:\GitHub\tBigNumber\mkvz
    for /f %%e in (env_mkall.txt) do (
        SET %%e
    )
    DEL env_mkall.txt /F /Q
ENDLOCAL
