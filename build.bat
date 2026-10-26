@echo off
echo Building enhance project...

if not exist "build" mkdir build
cd build

cmake .. -G "Visual Studio 17 2022" -A x64
if %errorlevel% neq 0 (
    echo CMake configuration failed!
    cd ..
    exit /b 1
)

cmake --build . --config Release
if %errorlevel% neq 0 (
    echo Build failed!
    cd ..
    exit /b 1
)

echo.
echo Build completed successfully!
echo DLL: build\Release\opengl32.dll
echo Injector: build\Release\injector.exe
cd ..

