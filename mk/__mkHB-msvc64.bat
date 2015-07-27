SET HB_COMPILER=msvc64
call "c:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\vcvarsall.bat" X64
..\..\core\bin\win\msvc64\hbmk2 -plat=win -cpu=x86_64 -jobs=10 -cpp -compr=no  -comp=msvc64 -hbcppmm- ..\hbp\_tbigNumber.hbp
..\..\core\bin\win\msvc64\hbmk2 -plat=win -cpu=x86_64 -jobs=10 -cpp -compr=max -comp=msvc64 -hbcppmm- -gui ..\hbp\tBigNtst.hbp
