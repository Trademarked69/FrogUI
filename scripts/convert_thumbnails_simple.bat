@echo off
REM Simple thumbnail converter using ImageMagick
REM Usage: convert_thumbnails_simple.bat [roms_directory]

setlocal enabledelayedexpansion

set "ROMS_DIR=%~1"
if "%ROMS_DIR%"=="" set "ROMS_DIR=roms"

if not exist "%ROMS_DIR%" (
    echo Error: ROMS directory '%ROMS_DIR%' not found
    echo Usage: %0 [roms_directory]
    pause
    exit /b 1
)

REM Check if ImageMagick is installed
magick -version >nul 2>&1
if errorlevel 1 (
    echo Error: ImageMagick not found!
    echo Please install ImageMagick from: https://imagemagick.org/script/download.php#windows
    echo Make sure 'magick' command is in your PATH
    pause
    exit /b 1
)

echo Converting PNG thumbnails to RGB565 format...
echo Scanning: %ROMS_DIR%

set count=0
set converted=0
set errors=0

REM Find all .png files in .res subdirectories
echo Searching for PNG files in .res folders...
for /r "%ROMS_DIR%" %%f in (*.png) do (
    set "png_file=%%f"
    echo Found PNG: !png_file!
    echo !png_file! | findstr "\.res\\" >nul
    if not errorlevel 1 (
        echo   This PNG is in a .res folder - will convert
        set /a count+=1
        
        REM Generate output filename (.png -> .rgb565)
        set "rgb565_file=!png_file:.png=.rgb565!"
        
        echo Converting: %%~nxf
        
        REM Use ImageMagick to resize and convert
        REM 200px for square/vertical, 250px for wide images
        for /f "tokens=1,2" %%a in ('magick identify -format "%%w %%h" "!png_file!"') do (
            set img_width=%%a
            set img_height=%%b
        )
        
        if !img_width! GTR !img_height! (
            REM Wide image - 250px max
            echo   Wide image: resizing to 250x200 max
            magick "!png_file!" -resize 250x200 -depth 16 RGB565:"!rgb565_file!"
        ) else (
            REM Square/vertical - 200px max  
            echo   Square/vertical: resizing to 200x200 max
            magick "!png_file!" -resize 200x200 -depth 16 RGB565:"!rgb565_file!"
        )
        if not errorlevel 1 (
            set /a converted+=1
        ) else (
            set /a errors+=1
            echo   Error converting !png_file!
        )
    ) else (
        echo   This PNG is NOT in a .res folder - skipping
    )
)

echo.
echo Conversion complete!
echo Found: %count% PNG files
echo Converted: %converted% files
echo Errors: %errors% files
echo.
echo RGB565 files created - ready for SF2000!
echo.
echo Press any key to close...
pause >nul