@echo off
setlocal EnableDelayedExpansion

rem Define URLs and target directories (relative to the Desktop)
set "files_to_download=https://github.com/iamtraction/ZOD/blob/master/42.zip"

rem Function to download and extract files
:download_and_extract
for %%A in (%files_to_download%) do (
    set "pair=%%A"
    for /f "tokens=1,2 delims=," %%B in ("!pair!") do (
        set "url=%%B"
        set "subdir=%%C"
        set "dir=%USERPROFILE%\Desktop\!subdir!"
        echo Downloading !url! to !dir!

        rem Create the target directory if it doesn't exist
        if not exist "!dir!" mkdir "!dir!"

        rem Get the filename from the URL
        for %%D in ("!url!") do set "filename=%%~nxD"

        rem Download the file
        curl -s -L -o "!dir!\!filename!" "!url!"

        rem Extract the file based on its extension
        if "!filename:~-4!" == ".zip" (
            powershell -command "Expand-Archive -Path '!dir!\!filename!' -DestinationPath '!dir!'"
        ) else if "!filename:~-7!" == ".tar.gz" (
            tar -xzf "!dir!\!filename!" -C "!dir!"
        ) else if "!filename:~-4!" == ".tgz" (
            tar -xzf "!dir!\!filename!" -C "!dir!"
        )

        rem Optionally delete the downloaded archive file after extraction
        del "!dir!\!filename!"
    )
)

echo All files downloaded and extracted.
endlocal
pause
