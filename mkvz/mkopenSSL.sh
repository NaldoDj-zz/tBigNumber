CROSS_COMPILE="i686-w64-mingw32-" ./Configure mingw32 no-asm shared --prefix=/opt/mingw32
PATH=$PATH:/opt/mingw32/bin clean && make
sudo PATH=$PATH:/opt/mingw32/bin make install
