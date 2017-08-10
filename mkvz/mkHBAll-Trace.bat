@echo off
SETLOCAL ENABLEEXTENSIONS
    echo BATCH FILE FOR Harbour tBigNumber
    rem ============================================================================
    D:
    CD D:\GitHub\tBigNumber\mkvz
    IF EXIST env_mkHBall.txt (
        DEL env_mkHBall.txt /F /Q
    )
    SET > env_mkHBall.txt
        SETLOCAL ENABLEEXTENSIONS
            rem ============================================================================
            SET HB_BUILD_MODE=cpp
            SET HB_USER_CFLAGS=-DHB_FM_STATISTICS
            SET HB_TR_LEVEL=HB_TR_DEBUG
            SET HB_TR_SYSOUT=Y
            SET HB_TR_WINOUT=1
            SET HB_TR_OUTPUT=hb_trace_dbg.log
            SET CFLAGS=-DHB_TR_LEVEL_DEBUG
            rem ============================================================================
            SET HB_CPU=
            SET HB_CCPATH=
            SET HB_PLATFORM=
            SET HB_COMPILER=
            call mkHB.bat %1
            for /f %%e in (env_mkHBall.txt) do (
                SET %%e
            )
        ENDLOCAL
        SETLOCAL ENABLEEXTENSIONS
            rem ============================================================================
            SET HB_BUILD_MODE=cpp
            SET HB_USER_CFLAGS=-DHB_FM_STATISTICS
            SET HB_TR_LEVEL=HB_TR_DEBUG
            SET HB_TR_SYSOUT=Y
            SET HB_TR_WINOUT=1
            SET HB_TR_OUTPUT=hb_trace_dbg.log
            SET CFLAGS=-DHB_TR_LEVEL_DEBUG
            rem ============================================================================
            SET HB_CPU=
            SET HB_CCPATH=
            SET HB_PLATFORM=
            SET HB_COMPILER=
            call mkHB64.bat %1
        ENDLOCAL
        SETLOCAL ENABLEEXTENSIONS
            rem ============================================================================
            SET HB_BUILD_MODE=
            SET HB_USER_CFLAGS=
            SET HB_TR_LEVEL=
            SET HB_TR_SYSOUT=
            SET HB_TR_WINOUT=
            SET HB_TR_OUTPUT=
            SET CFLAGS=
            rem ============================================================================
            SET HB_CPU=
            SET HB_CCPATH=
            SET HB_PLATFORM=
            SET HB_COMPILER=
            for /f %%e in (env_mkHBall.txt) do (
                SET %%e
            )
            rem call mkHBARM.bat %1
        ENDLOCAL
    D:
    CD D:\GitHub\tBigNumber\mkvz
    for /f %%e in (env_mkHBall.txt) do (
        SET %%e
    )
    DEL env_mkHBall.txt /F /Q
ENDLOCAL
