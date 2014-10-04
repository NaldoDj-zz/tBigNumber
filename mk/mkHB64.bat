@echo off
echo BATCH FILE FOR Harbour MinGW64
rem ============================================================================
D:
CD D:\GitHub\tBigNumber\mk\
SET > env_mkHB64.txt
    SET HB_PATH=D:\GitHub\core\
    SET MinGW64_PATH=D:\MinGW64\BIN\
    SET PATH=%PATH%;%HB_PATH%
    SET PATH=%PATH%;%MinGW64_PATH%
    SET HB_CPU=x86_64
    SET HB_PLATFORM=win
    SET HB_COMPILER=mingw64
    SET HB_CCPATH=%MinGW64_PATH%
       D:
       CD %HB_PATH%
       %HB_PATH%\win-make.exe -f MakeFile %1
D:
CD D:\GitHub\tBigNumber\mk\
for /f %%e in (env_mkHB64.txt) do (
    SET %%e
)
DEL env_mkHB64.txt