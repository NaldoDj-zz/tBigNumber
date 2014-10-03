@echo off
echo BATCH FILE FOR Harbour tBigNumber
rem ============================================================================
SET > env_mkallLib.txt
    SET HB_CPU=
    SET HB_PLATFORM=
    SET HB_COMPILER=
    SET HB_CCPATH=
	call mkLib.bat
    for /f %%e in (env_mkallLib.txt) do (
        SET %%e
    )
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
	rem call mkLibARM.bat
for /f %%e in (env_mkallLib.txt) do (
    SET %%e
)
DEL env_mkallLib.txt