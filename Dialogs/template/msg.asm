.686P				
.model flat,stdcall 
option casemap:none

include c:\masm32\include\windows.inc
include c:\masm32\include\user32.inc
;include c:\masm32\include\kernel32.inc
;include c:\masm32\include\masm32.inc
includelib c:\masm32\lib\user32.lib
;includelib c:\masm32\lib\kernel32.lib
;includelib c:\masm32\lib\masm32.lib

public ShowMsg 

.data
msgCapt db 'Сообщение', 0

.code

ShowMsg proc msgp :DWORD
	invoke MessageBox, NULL, msgp, addr msgCapt, MB_OK
ShowMsg endp

end