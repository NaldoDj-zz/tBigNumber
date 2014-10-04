@echo off
echo BATCH FILE FOR Harbour tBigNumber
rem ============================================================================
D:
CD D:\GitHub\tBigNumber\mk\
SET > env_mkHBall.txt
    SET HB_CPU=
    SET HB_PLATFORM=
    SET HB_COMPILER=
    SET HB_CCPATH=
	call mkHB.bat %1
    for /f %%e in (env_mkHBall.txt) do (
        SET %%e
    )
    SET HB_CPU=
    SET HB_PLATFORM=
    SET HB_COMPILER=
    SET HB_CCPATH=
	call mkHB64.bat %1
    SET HB_CPU=
    SET HB_PLATFORM=
    SET HB_COMPILER=
    SET HB_CCPATH=
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