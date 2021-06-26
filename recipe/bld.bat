@ECHO ON

:: set pkg-config path so that host deps can be found
:: (set as env var so it's used by both meson and during build with g-ir-scanner)
set "PKG_CONFIG_PATH=%LIBRARY_LIB%\pkgconfig;%LIBRARY_PREFIX%\share\pkgconfig;%BUILD_PREFIX%\Library\lib\pkgconfig"

:: ensure gir files are found
set "XDG_DATA_DIRS=%XDG_DATA_DIRS%;%LIBRARY_PREFIX%\share"

:: force use of clang-cl
:: set CXX as well, even though there is no C++ code, as this is necessary for g-ir-scanner to switch to using clang-cl as well...
set "CC=clang-cl"
set "CXX=clang-cl"

%BUILD_PREFIX%\Scripts\meson.exe setup builddir --wrap-mode=nofallback --buildtype=release --prefix=%LIBRARY_PREFIX% --backend=ninja -Dwith_introspection=true -Dwith_vapi=false -Denable_tests=false
if errorlevel 1 exit 1

ninja -v -C builddir -j %CPU_COUNT%
if errorlevel 1 exit 1

ninja -C builddir install -j %CPU_COUNT%
if errorlevel 1 exit 1

del %LIBRARY_PREFIX%\bin\*.pdb
