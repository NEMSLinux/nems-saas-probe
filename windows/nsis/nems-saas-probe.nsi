##################################################################
## NEMS SaaS Probe v1.0
## By Robbie Ferguson
## https://nemslinux.com/
##################################################################
#
setcompressor /SOLID lzma

!define NAME "NEMS SaaS Probe"
!define REGPATH_UNINSTSUBKEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${NAME}"
Name "${NAME}"
OutFile "../nems-saas-probe-installer.exe"
Unicode True
RequestExecutionLevel Admin ; Request admin rights on WinVista+ (when UAC is turned on)
InstallDir "$ProgramFiles\$(^Name)"
InstallDirRegKey HKLM "${REGPATH_UNINSTSUBKEY}" "UninstallString"

!include LogicLib.nsh
!include Integration.nsh

Page Directory
Page InstFiles

Uninstpage UninstConfirm
Uninstpage InstFiles

!macro EnsureAdminRights
  UserInfo::GetAccountType
  Pop $0
  ${If} $0 != "admin" ; Require admin rights on WinNT4+
    MessageBox MB_IconStop "Administrator rights required!"
    SetErrorLevel 740 ; ERROR_ELEVATION_REQUIRED
    Quit
  ${EndIf}
!macroend

Function .onInit
  SetShellVarContext All
  !insertmacro EnsureAdminRights
FunctionEnd

Function un.onInit
  SetShellVarContext All
  !insertmacro EnsureAdminRights
FunctionEnd


Section "Program files (Required)"
  SectionIn Ro

  SetOutPath $InstDir
  WriteUninstaller "$InstDir\Uninst.exe"
  WriteRegStr HKLM "${REGPATH_UNINSTSUBKEY}" "DisplayName" "${NAME}"
  WriteRegStr HKLM "${REGPATH_UNINSTSUBKEY}" "DisplayIcon" "$InstDir\nems-saas-probe.exe,0"
  WriteRegStr HKLM "${REGPATH_UNINSTSUBKEY}" "UninstallString" '"$InstDir\Uninst.exe"'
  WriteRegStr HKLM "${REGPATH_UNINSTSUBKEY}" "QuietUninstallString" '"$InstDir\Uninst.exe" /S'
  WriteRegDWORD HKLM "${REGPATH_UNINSTSUBKEY}" "NoModify" 1
  WriteRegDWORD HKLM "${REGPATH_UNINSTSUBKEY}" "NoRepair" 1

  File "..\nems-saas-probe.exe"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Run" "nems-saas-probe" '"$InstDir\nems-saas-probe.exe"'

SectionEnd


!macro DeleteFileOrAskAbort path
  ClearErrors
  Delete "${path}"
  IfErrors 0 +3
    MessageBox MB_ABORTRETRYIGNORE|MB_ICONSTOP 'Unable to delete "${path}"!' IDRETRY -3 IDIGNORE +2
    Abort "Aborted"
!macroend

Section -Uninstall
  !insertmacro DeleteFileOrAskAbort "$InstDir\nems-saas-probe.exe"
  Delete "$InstDir\Uninst.exe"
  RMDir "$InstDir"
  DeleteRegKey HKLM "${REGPATH_UNINSTSUBKEY}"

  ${UnpinShortcut} "$SMPrograms\${NAME}.lnk"
  Delete "$SMPrograms\${NAME}.lnk"
SectionEnd
