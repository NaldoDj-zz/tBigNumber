@echo off
echo BATCH FILE FOR Harbour MinGW64
rem ============================================================================
SET _PATH=%PATH%
SET _HB_PATH=%HB_PATH%
SET HB_PATH=d:\hb32\
SET MinGW64_PATH=d:\MinGW64\
SET PATH=%HB_PATH%bin\win\mingw64\
SET PATH=%PATH%;%MinGW64_PATH%bin\

    hbmk2.exe -strip- -jobs=10 -cpp -compr=max -comp=mingw64 ..\hbp\tBigNtst.hbp
    hbmk2.exe -strip- -jobs=10 -cpp -compr=max -comp=mingw64 ..\hbp\tBigNtst_array.hbp
    hbmk2.exe -strip- -jobs=10 -cpp -compr=max -comp=mingw64 ..\hbp\tBigNtst_array_assignv.hbp
    hbmk2.exe -strip- -jobs=10 -cpp -compr=max -comp=mingw64 ..\hbp\tBigNtst_array_assignv_dyn_obj.hbp
    hbmk2.exe -strip- -jobs=10 -cpp -compr=max -comp=mingw64 ..\hbp\tBigNtst_array_dyn_obj.hbp
    hbmk2.exe -strip- -jobs=10 -cpp -compr=max -comp=mingw64 ..\hbp\tBigNtst_array_mt.hbp
    hbmk2.exe -strip- -jobs=10 -cpp -compr=max -comp=mingw64 ..\hbp\tBigNtst_array_mt_assignv.hbp
    hbmk2.exe -strip- -jobs=10 -cpp -compr=max -comp=mingw64 ..\hbp\tBigNtst_array_mt_assignv_dyn_obj.hbp
    hbmk2.exe -strip- -jobs=10 -cpp -compr=max -comp=mingw64 ..\hbp\tBigNtst_array_mt_dyn_obj.hbp
    hbmk2.exe -strip- -jobs=10 -cpp -compr=max -comp=mingw64 ..\hbp\tBigNtst_assignv.hbp
    hbmk2.exe -strip- -jobs=10 -cpp -compr=max -comp=mingw64 ..\hbp\tBigNtst_assignv_dyn_obj.hbp
    hbmk2.exe -strip- -jobs=10 -cpp -compr=max -comp=mingw64 ..\hbp\tBigNtst_dbfile.hbp
    hbmk2.exe -strip- -jobs=10 -cpp -compr=max -comp=mingw64 ..\hbp\tBigNtst_dbfile_assignv.hbp
    hbmk2.exe -strip- -jobs=10 -cpp -compr=max -comp=mingw64 ..\hbp\tBigNtst_dbfile_dyn_obj.hbp
    hbmk2.exe -strip- -jobs=10 -cpp -compr=max -comp=mingw64 ..\hbp\tBigNtst_dbfile_memio.hbp
    hbmk2.exe -strip- -jobs=10 -cpp -compr=max -comp=mingw64 ..\hbp\tBigNtst_dbfile_memio_assignv.hbp
    hbmk2.exe -strip- -jobs=10 -cpp -compr=max -comp=mingw64 ..\hbp\tBigNtst_dbfile_memio_dyn_obj.hbp
    hbmk2.exe -strip- -jobs=10 -cpp -compr=max -comp=mingw64 ..\hbp\tBigNtst_dbfile_memio_dyn_obj_assignv.hbp
    hbmk2.exe -strip- -jobs=10 -cpp -compr=max -comp=mingw64 ..\hbp\tBigNtst_dbfile_memio_mt.hbp
    hbmk2.exe -strip- -jobs=10 -cpp -compr=max -comp=mingw64 ..\hbp\tBigNtst_dbfile_memio_mt_assignv.hbp
    hbmk2.exe -strip- -jobs=10 -cpp -compr=max -comp=mingw64 ..\hbp\tBigNtst_dbfile_memio_mt_dyn_obj.hbp
    hbmk2.exe -strip- -jobs=10 -cpp -compr=max -comp=mingw64 ..\hbp\tBigNtst_dbfile_memio_mt_dyn_obj_assignv.hbp
    hbmk2.exe -strip- -jobs=10 -cpp -compr=max -comp=mingw64 ..\hbp\tBigNtst_dbfile_mt.hbp
    hbmk2.exe -strip- -jobs=10 -cpp -compr=max -comp=mingw64 ..\hbp\tBigNtst_dbfile_mt_assignv.hbp
    hbmk2.exe -strip- -jobs=10 -cpp -compr=max -comp=mingw64 ..\hbp\tBigNtst_dbfile_mt_assignv_dyn_obj.hbp
    hbmk2.exe -strip- -jobs=10 -cpp -compr=max -comp=mingw64 ..\hbp\tBigNtst_dbfile_mt_dyn_obj.hbp
    hbmk2.exe -strip- -jobs=10 -cpp -compr=max -comp=mingw64 ..\hbp\tBigNtst_dyn_obj.hbp
    hbmk2.exe -strip- -jobs=10 -cpp -compr=max -comp=mingw64 ..\hbp\tBigNtst_mt.hbp
    hbmk2.exe -strip- -jobs=10 -cpp -compr=max -comp=mingw64 ..\hbp\tBigNtst_mt_assignv.hbp
    hbmk2.exe -strip- -jobs=10 -cpp -compr=max -comp=mingw64 ..\hbp\tBigNtst_mt_dyn_obj.hbp

SET HB_PATH=%_HB_PATH%
SET PATH=%_PATH%