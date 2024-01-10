@echo off
SETLOCAL ENABLEEXTENSIONS
    echo BATCH FILE FOR Harbour msvc
    rem ============================================================================
    D:
    CD D:\GitHub\tBigNumber\mk\
    IF EXIST env_msvc.txt (
        DEL env_msvc.txt /F /Q
    )
    SET > env_msvc.txt
        SET HB_PATH=D:\GitHub\core\
        IF EXIST "c:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat" (
            CALL "c:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat" X86
            SET msvc_PATH="C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\bin"
        ) ELSE IF EXIST "c:\Program Files (x86)\Microsoft Visual Studio 13.0\VC\vcvarsall.bat" (
            CALL "c:\Program Files (x86)\Microsoft Visual Studio 13.0\VC\vcvarsall.bat" X86
            SET msvc_PATH="C:\Program Files (x86)\Microsoft Visual Studio 13.0\VC\bin"
        ) ELSE IF EXIST "c:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\vcvarsall.bat" (
            CALL "c:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\vcvarsall.bat" X86
            SET msvc_PATH="C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\bin"
        ) ELSE IF EXIST "c:\Program Files (x86)\Microsoft Visual Studio 11.0\VC\vcvarsall.bat" (
            CALL "c:\Program Files (x86)\Microsoft Visual Studio 11.0\VC\vcvarsall.bat" X86
            SET msvc_PATH="C:\Program Files (x86)\Microsoft Visual Studio 11.0\VC\bin"
        ) ELSE IF EXIST "c:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\vcvarsall.bat" (
            CALL "c:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\vcvarsall.bat" X86
            SET msvc_PATH="C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\bin"
        )
        SET PATH=%msvc_PATH%;%HB_PATH%;%PATH%;
        SET HB_CPU=x86_64
        SET HB_PLATFORM=win
        SET HB_COMPILER=msvc
        SET HB_CCPATH=%msvc_PATH%
        IF EXIST D:\OpenSSL (
            IF EXIST D:\OpenSSL\INC32 (
                SET HB_WITH_OPENSSL=D:\OpenSSL\INC32
            ) ELSE IF EXIST D:\OpenSSL\INCLUDE (
                SET HB_WITH_OPENSSL=D:\OpenSSL\INCLUDE
            )
        )
        IF EXIST D:\FreeImage\Dist\X32 (
            SET HB_WITH_FREEIMAGE=D:\FreeImage\Dist\X32
        )
        IF EXIST D:\mxml (
            SET HB_WITH_MXML=D:\mxml
        )
        rem SET HB_BUILD_VERBOSE=yes
           D:
           CD %HB_PATH%
           IF "%1"=="-B" (
                IF EXIST ".\bin\win\msvc" (
                    rmdir ".\bin\win\msvc" /s /q
                )
                IF EXIST ".\lib\win\msvc" (
                    rmdir ".\lib\win\msvc" /s /q
                )
           )
           %HB_PATH%\win-make.exe -f MakeFile %1
    D:
    CD D:\GitHub\tBigNumber\mk\
    for /f %%e in (env_msvc.txt) do (
        SET %%e
    )
    DEL env_msvc.txt /F /Q
ENDLOCAL
