rem pacman -S mingw-w64-x86_64-curl
rem pacman -S mingw-w64-x86_64-openssl
rem pacman -S mingw-w64-x86_64-icu
rem pacman -S mingw-w64-x86_64-postgresql
rem pacman -S mingw-w64-x86_64-libmariadbclient
rem pacman -S mingw-w64-x86_64-rabbitmq-c
rem pacman -S mingw-w64-x86_64-cairo
rem pacman -S mingw-w64-x86_64-freeimage
rem pacman -S mingw-w64-x86_64-libmagic
rem pacman -S mingw-w64-x86_64-gd
rem pacman -S mingw-w64-x86_64-ghostscript

export HB_WITH_CURL=/mingw64/include
export HB_WITH_OPENSSL=/mingw64/include
export HB_WITH_ICU=/mingw64/include
export HB_WITH_PGSQL=/mingw64/include
export HB_WITH_MYSQL=/mingw64/include/mysql
export HB_WITH_RABBITMQ=/mingw64/include
export HB_WITH_CAIRO=/mingw64/include/cairo
export HB_WITH_FREEIMAGE=/mingw64/include
export HB_WITH_LIBMAGIC=/usr/include
export HB_WITH_GD=/ucrt64/include/libwmf/gd
export HBMK_WITH_GS=/mingw64/include
export HB_WITH_OCILIB=/f/ocilib/include 

export HB_BUILD_DEBUG=yes
export HB_TR_LEVEL=debug
export HB_TR_OUTPUT=/c/tmp/hb_trace.log
export HB_TR_SYSOUT=yes
export HB_USER_CFLAGS=-DHB_FM_STATISTICS

unset HB_BUILD_DEBUG
unset HB_TR_LEVEL
unset HB_TR_OUTPUT
unset HB_TR_SYSOUT
unset HB_USER_CFLAGS

unset HB_WITH_LIBMAGIC
unset HB_WITH_GD
