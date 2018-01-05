@echo off
SETLOCAL ENABLEEXTENSIONS
    echo BATCH FILE FOR Harbour msvc
    rem ============================================================================
    D:
    CD D:\GitHub\tBigNumber\mk\
    IF EXIST env_mkLib_msvc.txt (
        DEL env_mkLib_msvc.txt /F /Q
    )
    SET > env_mkLib_msvc.txt
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
        SET PATH=%msvc_PATH%;%HB_PATH%;%PATH%
        SET HB_CPU=x86_64
        SET HB_PLATFORM=win
        SET HB_COMPILER=msvc
        SET HB_CCPATH=%msvc_PATH%
           %HB_PATH%bin\win\msvc\hbmk2.exe -plat=win -cpu=x86_64 -jobs=10 -cpp -compr=no -comp=msvc -xhb ..\hbp\tbigNumber.hbp
    D:
    CD D:\GitHub\tBigNumber\mk\
    for /f %%e in (env_mkLib_msvc.txt) do (
        SET %%e
    )
    DEL env_mkLib_msvc.txt /F /Q
ENDLOCAL
