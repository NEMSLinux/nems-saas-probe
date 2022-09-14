@echo off
setlocal EnableExtensions
SET SCRIPT_PATH=%~dp0

:uniqLoop
set "tmpdir=%tmp%\nems-saas~%RANDOM%"
if exist "%tmpdir%" goto :uniqLoop

md "%tmpdir%"
copy src\nems-saas-probe "%tmpdir%\"
cd "%tmpdir%"
python -m PyInstaller -w --onefile --icon="%SCRIPT_PATH%nemslinux.ico" nems-saas-probe

copy dist\nems-saas-probe.exe "%SCRIPT_PATH%\windows\"
