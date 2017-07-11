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

; -------------- Объявление процедур --------------

WinMain proto :HINSTANCE,:HINSTANCE,:LPSTR,:DWORD
RegWndClass proto
WndProc proto :HWND,:UINT,:WPARAM,:LPARAM

; -------------- Сегмент данных -------------------

.data									
ClassName db "WinClass",0
AppName  db "Window",0
MBCaptionErr  db "Error",0
EMClassNotReg  db "Window class not registered!",0
EMWinNotCreate  db "Window not created!",0

.data?
hInstance dd ?
CommandLine dd ?

; -------------- Сегмент кода ---------------------

.code
start:
	invoke GetModuleHandle, NULL
	mov  hInstance,eax
	invoke GetCommandLine
	mov  CommandLine,eax
	invoke WinMain, hInstance, NULL, CommandLine, SW_SHOWDEFAULT
	invoke ExitProcess, eax

; --- Главная функция ---

WinMain proc hInst:HINSTANCE, hPrevInst:HINSTANCE, CmdLine:LPSTR, CmdShow:DWORD	
	LOCAL msg:MSG
	LOCAL hwnd:HWND
	invoke RegWndClass
	.IF (!eax)
		invoke MessageBox, NULL, addr EMClassNotReg, addr MBCaptionErr, MB_OK
		ret
	.ENDIF	
	invoke CreateWindowEx, NULL, addr ClassName, addr AppName, WS_OVERLAPPEDWINDOW, 
		   CW_USEDEFAULT, CW_USEDEFAULT, CW_USEDEFAULT, CW_USEDEFAULT, NULL, NULL, hInst, NULL
	.IF (!eax)
		invoke MessageBox, NULL, addr EMWinNotCreate, addr MBCaptionErr, MB_OK
		ret
	.ENDIF
	mov  hwnd, eax
	invoke ShowWindow, hwnd, SW_SHOWNORMAL
	invoke UpdateWindow, hwnd
	.WHILE TRUE
		invoke GetMessage, addr msg, NULL, 0, 0
		.BREAK .IF (!eax)
		invoke TranslateMessage, addr msg
		invoke DispatchMessage, addr msg
	.ENDW
	mov  eax, msg.wParam
	ret
WinMain endp

; --- Регистрация класса окна ---

RegWndClass proc 
	LOCAL wc:WNDCLASSEX	
	mov  wc.cbSize, sizeof WNDCLASSEX
	mov  wc.style, CS_HREDRAW or CS_VREDRAW	
	mov  wc.lpfnWndProc, offset WndProc
	mov  wc.cbClsExtra, NULL
	mov  wc.cbWndExtra, NULL
	push hInstance
    pop  wc.hInstance	
	invoke LoadIcon, NULL, IDI_APPLICATION
	mov  wc.hIcon, eax
	mov  wc.hIconSm, eax
	invoke LoadCursor, NULL, IDC_ARROW
	mov  wc.hCursor, eax	
	mov  wc.hbrBackground, COLOR_WINDOW+1
	mov  wc.lpszMenuName, NULL	
	mov  wc.lpszClassName, offset ClassName 		
	invoke RegisterClassEx, addr wc	
	ret
RegWndClass endp

; --- Процедура окна ---

WndProc proc hWnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM
	.IF uMsg==WM_DESTROY
		invoke PostQuitMessage, NULL
	.ELSE
		invoke DefWindowProc, hWnd, uMsg, wParam, lParam		
		ret
	.ENDIF
	xor eax,eax
	ret
WndProc endp

end start