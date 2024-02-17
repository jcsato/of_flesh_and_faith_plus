@echo off

for /f "eol=[ delims=" %%a in (ini.cfg) do (
    set "%%a"
)

echo.
echo Creating temporary directories...
echo.

@REM  /i means create tmp\scripts if it's not there, /e means copy subdirectories even if empty, /f outputs full src/dst paths (if you want), /y means overwrite, /c ignores errors
xcopy "%~dp0\scripts\" "%~dp0\tmp_scripts\" /i /e /y
xcopy "%~dp0\script_hooks\" "%~dp0\tmp_script_hooks\" /i /e /y
xcopy "%~dp0\ui\" "%~dp0\tmp_ui\" /i /e /y

cd "%modkitpath%"
CALL "%modkitpath%\masscompile.bat" "%~dp0\tmp_scripts"
CALL "%modkitpath%\masscompile.bat" "%~dp0\tmp_script_hooks"

REM %~dp0 refers to the drive letter + path of where THIS batch file lives

echo.
echo Copying files to dist\scripts
echo.

REM after build, copy scripts folder to dist\scripts folder. /i means create dist\scripts if it's not there, /e means copy subdirectories even if empty, /f outputs full src/dst paths (if you want), /y means overwrite, /c ignores errors
xcopy "%~dp0\tmp_scripts" "%~dp0\dist\scripts" /i /e /y /c /q
xcopy "%~dp0\tmp_script_hooks" "%~dp0\dist\script_hooks" /i /e /y /c /q
xcopy "%~dp0\tmp_ui" "%~dp0\dist\ui" /i /e /y /c /q
xcopy "%~dp0\brushes" "%~dp0\dist\brushes" /i /e /y /c /q
xcopy "%~dp0\gfx" "%~dp0\dist\gfx" /i /e /y /c /q

echo %~dp0

echo.
echo Removing temporary directories...
echo.

REM Remove tmp_scripts directory
rmdir "%~dp0\tmp_scripts" /s /q
rmdir "%~dp0\tmp_script_hooks" /s /q
rmdir "%~dp0\tmp_ui" /s /q

echo.
echo Removing uncompiled source from dist...
echo.

REM Remove uncompiled source from dist\scripts directory
for /r "%~dp0\dist\scripts" %%f in (*.nut) do del /f /q "%%f"
for /r "%~dp0\dist\script_hooks" %%f in (*.nut) do del /f /q "%%f"

echo.
echo Packaging mod into .zip...
echo.

REM Requires Powershell 5.0 / .NET Framework 4.x (some claim 4, some claim 4.5, some claim 4.8)
powershell.exe -nologo -noprofile -command "& { Compress-Archive -Force -Path '%~dp0\dist\brushes', '%~dp0\dist\gfx', '%~dp0\dist\ui', '%~dp0\dist\script_hooks', '%~dp0\dist\scripts' -DestinationPath '%~dp0\dist\%modname%_%version%.zip' }"

echo.
echo Cleaning up dist\scripts
echo.

REM Remove dist\scripts directory
rmdir "%~dp0\dist\scripts" /s /q
rmdir "%~dp0\dist\script_hooks" /s /q
rmdir "%~dp0\dist\ui" /s /q
rmdir "%~dp0\dist\brushes" /s /q
rmdir "%~dp0\dist\gfx" /s /q

echo Done.

pause
