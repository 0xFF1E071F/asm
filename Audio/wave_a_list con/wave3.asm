.686P				
.model flat,stdcall 
option casemap:none

include c:\masm32\include\windows.inc
include c:\masm32\include\user32.inc
include c:\masm32\include\kernel32.inc
include c:\masm32\include\masm32.inc
include c:\masm32\include\winmm.inc

includelib c:\masm32\lib\user32.lib
includelib c:\masm32\lib\kernel32.lib
includelib c:\masm32\lib\masm32.lib
includelib c:\masm32\lib\winmm.lib

.const

	conTitle 	db "Console", 0
	HSTDIN		dd -10
	HSTDOUT		dd -11

.data

	mbuf		db 255 dup(" "), 0
	mbufl		dd 256
	rbuf		db ?
	rbufl		dd 1
	wbuf		db "Hello, world!", 0
	wbufl		dd $-wbuf	
	c_read		dd 0
	c_write		dd 0

.data?

	hInstance 	dd ?
	CommandLine dd ?
	stdin		dd ?
	stdout		dd ?

.code
start:
	invoke GetModuleHandle, NULL
	mov	hInstance,eax
	invoke GetCommandLine
	mov	CommandLine,eax
	invoke GetStdHandle, HSTDOUT
  	mov stdout, eax 	
  	invoke waveOutGetNumDevs
  	mov eax, 31d
  	mov c_read, eax  	 
  	invoke WriteConsoleA, stdout, offset c_read, 4d, 0, 0
  	invoke Sleep,2000   	  
  	invoke ExitProcess, 0
end start

