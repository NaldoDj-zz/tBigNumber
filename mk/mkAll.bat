@echo off
echo BATCH FILE FOR Harbour tBigNumber
rem ============================================================================
D:
CD D:\GitHub\tBigNumber\mk\
SET > env_mkall.txt
    SET HB_CPU=
    SET HB_PLATFORM=
    SET HB_COMPILER=
    SET HB_CCPATH=
	call mk.bat
    for /f %%e in (env_mkall.txt) do (
        SET %%e
    )
    SET HB_CPU=
    SET HB_PLATFORM=
    SET HB_COMPILER=
    SET HB_CCPATH=
	call mk64.bat
    for /f %%e in (env_mkall.txt) do (
        SET %%e
    )
    SET HB_CPU=
    SET HB_PLATFORM=
    SET HB_COMPILER=
    SET HB_CCPATH=
	rem call mkarm.bat
D:
CD D:\GitHub\tBigNumber\mk\
for /f %%e in (env_mkall.txt) do (
    SET %%e
)
DEL env_mkall.txt