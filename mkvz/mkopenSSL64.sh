CROSS_COMPILE="x86_64-w64-mingw32-" ./Configure mingw64 no-asm shared --prefix=/opt/mingw64
PATH=$PATH:/opt/mingw64/bin make clean && make
sudo PATH=$PATH:/opt/mingw64/bin make install
