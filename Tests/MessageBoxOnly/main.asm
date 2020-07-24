.686P
.model flat,stdcall 
option casemap:none

include		c:\masm32\include\windows.inc
include		c:\masm32\include\kernel32.inc
include		c:\masm32\include\user32.inc
includelib	c:\masm32\lib\kernel32.lib
includelib	c:\masm32\lib\user32.lib

.data
msgCapt db 'Сообщение', 0
msgTest db 'Привет, мир!', 0

.data?
;hInstance dd ?

.code
start:
	invoke MessageBox, NULL, addr msgTest, addr msgCapt, MB_OK	
	invoke	ExitProcess,0
end start