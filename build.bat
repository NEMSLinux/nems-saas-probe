@echo off
setlocal EnableExtensions
SET SCRIPT_PATH=%~dp0

:uniqLoop
set "tmpdir=%tmp%\nems-saas~%RANDOM%"
if exist "%tmpdir%" goto :uniqLoop

md %tmpdir%
cp src\nems-saas-probe %tmpdir%\
cd %tmpdir%
python -m PyInstaller --onefile --icon=nemslinux.ico nems-saas-probe

move dist\nems-saas-probe.exe %SCRIPT_PATH%\windows\

del /r %tmpdir%
