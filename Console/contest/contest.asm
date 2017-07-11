.686P				
.model flat,stdcall 
option casemap:none

include c:\masm32\include\windows.inc
include c:\masm32\include\user32.inc
include c:\masm32\include\kernel32.inc
include c:\masm32\include\masm32.inc
includelib c:\masm32\lib\user32.lib
includelib c:\masm32\lib\kernel32.lib
includelib c:\masm32\lib\masm32.lib

InitConsole proto

.const

	conTitle 	DB "Console", 0
	HSTDIN		DD -10
	HSTDOUT		DD -11

.data

	stdin		DD 0
	stdout		DD 0

	mbuf		DB 255 dup(" "), 0
	mbufl		DD 256
	rbuf		DB ?
	rbufl		DD 1
	wbuf		DB "Hello, world!", 0
	wbufl		DD $-wbuf
	
	c_read		DD 0
	c_write		DD 0

.data?
	hInstance 		DD ?
	CommandLine 	DD ?

.code
start:
	invoke GetModuleHandle, NULL
	mov	hInstance,eax
	invoke GetCommandLine
	mov	CommandLine,eax
	invoke InitConsole 	
  	invoke WriteConsoleA, stdout, offset wbuf, wbufl, offset c_write, 0
  	invoke Sleep,2000   	  
  	invoke ExitProcess, 0
		
InitConsole proc	
	;invoke AllocConsole
	;test eax, eax
	;jz IC_EXIT
	;invoke SetConsoleTitleA, offset conTitle
	;test eax, eax
	;jz IC_EXIT		
  	invoke GetStdHandle, HSTDOUT
  	mov stdout, eax
	invoke GetStdHandle, HSTDIN
  	mov stdin, eax
IC_EXIT:
	ret
InitConsole endp
		
end start

