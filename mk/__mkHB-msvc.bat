SET HB_COMPILER=msvc
call "c:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\vcvarsall.bat" X86
..\..\core\bin\win\msvc\hbmk2 -plat=win -cpu=x86_64 -jobs=10 -cpp -compr=no  -comp=msvc -hbcppmm- ..\hbp\_tbigNumber.hbp
..\..\core\bin\win\msvc\hbmk2 -plat=win -cpu=x86_64 -jobs=10 -cpp -compr=max -comp=msvc -hbcppmm- -gui ..\hbp\tBigNtst.hbp
