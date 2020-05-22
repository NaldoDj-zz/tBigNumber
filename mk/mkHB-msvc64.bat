@echo off
SETLOCAL ENABLEEXTENSIONS
    echo BATCH FILE FOR Harbour msvc64
    rem ============================================================================
    D:
    CD D:\GitHub\tBigNumber\mk\
    IF EXIST env_msvc64.txt (
        DEL env_msvc64.txt /F /Q
    )
    SET > env_msvc64.txt
        SET HB_PATH=D:\GitHub\core\
        IF EXIST "c:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat" (
            CALL "c:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat" X64
            SET msvc64_PATH="C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\bin"
            SET msvc64_PATH
        ) ELSE IF EXIST "c:\Program Files (x86)\Microsoft Visual Studio 13.0\VC\vcvarsall.bat" (
            CALL "c:\Program Files (x86)\Microsoft Visual Studio 13.0\VC\vcvarsall.bat" X64
            SET msvc64_PATH="C:\Program Files (x86)\Microsoft Visual Studio 13.0\VC\bin"
            SET msvc64_PATH
        ) ELSE IF EXIST "c:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\vcvarsall.bat" (
            CALL "c:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\vcvarsall.bat" X64
            SET msvc64_PATH="C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\bin"
            SET msvc64_PATH
        ) ELSE IF EXIST "c:\Program Files (x86)\Microsoft Visual Studio 11.0\VC\vcvarsall.bat" (
            CALL "c:\Program Files (x86)\Microsoft Visual Studio 11.0\VC\vcvarsall.bat" X64
            SET msvc64_PATH="C:\Program Files (x86)\Microsoft Visual Studio 11.0\VC\bin"
            SET msvc64_PATH
        ) ELSE IF EXIST "c:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\vcvarsall.bat" (
            CALL "c:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\vcvarsall.bat" X64
            SET msvc64_PATH="C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\bin"
            SET msvc64_PATH
        ) ELSE (
            SET msvc64_PATH=""
            SET msvc64_PATH
        )
        SET PATH=%msvc64_PATH%;%HB_PATH%;%PATH%;
        SET PATH
        SET HB_CPU=x86_64
        SET HB_CPU
        SET HB_PLATFORM=win
        SET HB_PLATFORM
        SET HB_COMPILER=msvc64
        SET HB_COMPILER
        SET HB_CCPATH=%msvc64_PATH%
        SET HB_CCPATH
        IF EXIST D:\OpenSSL (
            SET HB_WITH_OPENSSL=D:\OpenSSL
            IF EXIST D:\OpenSSL\MS (
                SET HB_WITH_OPENSSL=D:\OpenSSL\MS\
            )
            SET HB_WITH_OPENSSL
        )
        IF EXIST D:\FreeImage\Dist\x64 (
            SET HB_WITH_FREEIMAGE="D:\FreeImage\Dist\x64"
            SET HB_WITH_FREEIMAGE
        )
        IF EXIST D:\mxml (
            SET HB_WITH_MXML="D:\mxml"
            SET HB_WITH_MXML
        )
        rem SET HB_BUILD_VERBOSE=yes
           D:
           CD %HB_PATH%
           IF "%1"=="-B" (
                IF EXIST ".\bin\win\msvc64" (
                    rmdir ".\bin\win\msvc64" /s /q
                )
                IF EXIST ".\lib\win\msvc64" (
                    rmdir ".\lib\win\msvc64" /s /q
                )
           )
           %HB_PATH%\win-make.exe -f MakeFile %1
    D:
    CD D:\GitHub\tBigNumber\mk\
    for /f %%e in (env_msvc64.txt) do (
        SET %%e
    )
    DEL env_msvc64.txt /F /Q
ENDLOCAL
