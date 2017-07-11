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

public GetConsole

.data
	conTitle 	DB "Application console", 0
	
	hStdInp		DD 0
	hStdOut		DD 0
	
	STD_INP_H	equ -10
	STD_OUT_H	equ -11

.code

GetConsole proc		; инициализация окна консоли
	
		invoke	AllocConsole
		test	EAX, EAX
		jz		EXIT_GC 	
		
		invoke	SetConsoleTitleA, offset conTitle
		test	EAX, EAX
		jz		EXIT_GC
		
		invoke	GetStdHandle, STD_OUT_H
		mov		hStdOut, EAX
		
		invoke	GetStdHandle, STD_INP_H
		mov		hStdInp, EAX
		
		mov EAX, hStdOut
		
EXIT_GC:
		
		ret

GetConsole endp

end 
	
	