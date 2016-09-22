@echo off
echo BATCH FILE FOR Harbour tBigNumber
rem ============================================================================
D:
CD D:\GitHub\tBigNumber\mk\
SET > env_mkHBall.txt
    rem ============================================================================
    SET HB_BUILD_MODE=cpp
    SET HB_USER_CFLAGS=-DHB_FM_STATISTICS
    SET HB_TR_LEVEL=DEBUG
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
    rem ============================================================================
    SET HB_BUILD_MODE=cpp
    SET HB_USER_CFLAGS=-DHB_FM_STATISTICS
    SET HB_TR_LEVEL=DEBUG
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
D:
CD D:\GitHub\tBigNumber\mk\
for /f %%e in (env_mkHBall.txt) do (
    SET %%e
)
DEL env_mkHBall.txt
