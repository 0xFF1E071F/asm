; -------------- Настройки ------------------------

.686P
.model flat,stdcall 
option casemap:none

; -------------- Подключаемые файлы ---------------

include \masm32\include\windows.inc
include \masm32\include\user32.inc
include \masm32\include\kernel32.inc
includelib \masm32\lib\user32.lib
includelib \masm32\lib\kernel32.lib

include objmacro.asm
include class.asm


; -------------- Объявление процедур --------------




; -------------- Сегмент данных -------------------

.data									
MBCaptionErr  db "Error",0
EMClassNotReg  db "Window class not registered!",0

.data?
hInstance dd ?
CommandLine dd ?
TestObj dd ?

; -------------- Сегмент кода ---------------------

.code
start:

	invoke GetModuleHandle, NULL
	mov  hInstance,eax
	invoke GetCommandLine
	mov  CommandLine,eax
	alloc_mem
	;;---------------------------

	mov TestObj, new_object(<TestClass>, offset EMClassNotReg, offset MBCaptionErr)
	method TestObj, TestClass.sum
	;method TestObj, TestClass.setstr, offset EMClassNotReg, offset MBCaptionErr
	method TestObj, TestClass.showmes
	delete_object TestObj, <TestClass> 
	
	;;----------------------------
	destroy_mem
	invoke ExitProcess, eax
	
	
rl_add_to proc obj:DWORD,s:DWORD,i:DWORD
	invoke MessageBox, NULL, addr EMClassNotReg, addr MBCaptionErr, MB_OK
	ret
rl_add_to endp

end start