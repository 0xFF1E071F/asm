.386
.model flat,stdcall
option casemap:none

includelib kernel32.lib

SetConsoleTitleA PROTO :DWORD
GetStdHandle PROTO     :DWORD
WriteConsoleA PROTO    :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
ExitProcess PROTO      :DWORD
Sleep PROTO            :DWORD

.const

sConsoleTitle  db 'My First Console Application',0
sWriteText  db 'hEILo, Wo(R)LD!!'
HSTDOUT	DD -11

.data

stdout	DD 0

.code

Main PROC  
  invoke SetConsoleTitleA, offset sConsoleTitle
  invoke GetStdHandle, HSTDOUT
  mov stdout, eax
  invoke WriteConsoleA, stdout, offset sWriteText, 16d, 0, 0  
  invoke WriteConsoleA, stdout, offset sWriteText, 16d, 0, 0  
  invoke ExitProcess, 0
Main ENDP

end Main