@echo off
SETLOCAL ENABLEEXTENSIONS
    echo BATCH FILE FOR Harbour tBigNumber
    rem ============================================================================
    D:
    CD D:\GitHub\tBigNumber\mk\
    IF EXIST env_mkall.txt (
        DEL env_mkall.txt /F /Q
    )
    SET > env_mkall.txt
        SETLOCAL ENABLEEXTENSIONS
            rem ============================================================================
            SET HB_BUILD_MODE=cpp
            SET HB_USER_CFLAGS=-DHB_FM_STATISTICS -DHB_PARANOID_MEM_CHECK
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
            call mk.bat
            for /f %%e in (env_mkall.txt) do (
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
            call mk64.bat
            for /f %%e in (env_mkall.txt) do (
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
        ENDLOCAL
    D:
    CD D:\GitHub\tBigNumber\mk\
    for /f %%e in (env_mkall.txt) do (
        SET %%e
    )
    DEL env_mkall.txt /F /Q
ENDLOCAL
