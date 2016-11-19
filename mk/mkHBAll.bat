@echo off
SETLOCAL ENABLEEXTENSIONS
    echo BATCH FILE FOR Harbour tBigNumber
    rem ============================================================================
    D:
    CD D:\GitHub\tBigNumber\mk\
    IF EXIST env_mkHBall.txt (
        DEL env_mkHBall.txt /F /Q
    )
    SET > env_mkHBall.txt
        SETLOCAL ENABLEEXTENSIONS
            SET HB_CPU=
            SET CFLAGS=
            SET HB_CCPATH=
            SET HB_PLATFORM=
            SET HB_COMPILER=
            SET HB_BUILD_MODE=
            SET HB_USER_CFLAGS=
            SET HB_TR_LEVEL=
            SET HB_TR_SYSOUT=
            SET HB_TR_WINOUT=
            SET HB_TR_OUTPUT=
            call mkHB.bat %1
            for /f %%e in (env_mkHBall.txt) do (
                SET %%e
            )
        ENDLOCAL
        SETLOCAL ENABLEEXTENSIONS
            SET HB_CPU=
            SET CFLAGS=
            SET HB_CCPATH=
            SET HB_PLATFORM=
            SET HB_COMPILER=
            SET HB_BUILD_MODE=
            SET HB_USER_CFLAGS=
            SET HB_TR_LEVEL=
            SET HB_TR_SYSOUT=
            SET HB_TR_WINOUT=
            SET HB_TR_OUTPUT=
            call mkHB64.bat %1
            SET HB_CPU=
            SET CFLAGS=
            SET HB_CCPATH=
            SET HB_PLATFORM=
            SET HB_COMPILER=
            SET HB_BUILD_MODE=
            SET HB_USER_CFLAGS=
            SET HB_TR_LEVEL=
            SET HB_TR_SYSOUT=
            SET HB_TR_WINOUT=
            SET HB_TR_OUTPUT=
            for /f %%e in (env_mkHBall.txt) do (
                SET %%e
            )
        ENDLOCAL
        SETLOCAL ENABLEEXTENSIONS
            rem call mkHBARM.bat %1
        ENDLOCAL
    D:
    CD D:\GitHub\tBigNumber\mk\
    for /f %%e in (env_mkHBall.txt) do (
        SET %%e
    )
    DEL env_mkHBall.txt /F /Q
ENDLOCAL
