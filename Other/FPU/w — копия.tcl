set fileid [open "w.asm" w+]

# директивы
puts $fileid \
".386				
.model flat,stdcall 
option casemap:none"

# инклуды
puts $fileid "
include c:\\masm32\\include\\windows.inc
include c:\\masm32\\include\\user32.inc
include c:\\masm32\\include\\kernel32.inc
includelib c:\\masm32\\lib\\user32.lib
includelib c:\\masm32\\lib\\kernel32.lib"

# <<<<< стилистические константы
puts $fileid "
STYLBT equ WS_CHILD+BS_DEFPUSHBUTTON+WS_VISIBLE
STYLED equ WS_CHILD+WS_VISIBLE+WS_BORDER+WS_TABSTOP
STYLLB equ WS_CHILD+WS_VISIBLE"

# прототипы функций
puts $fileid "
WinMain proto :DWORD,:DWORD,:DWORD,:DWORD"

# ------------ статические переменные ------------
puts $fileid "
.data"

# <<<<<<  классы элементов управления
puts $fileid "
	ClassName	DB 'WinClass',0
	CLSBT 		DB 'BUTTON',0
	CLSED		DB 'EDIT',0
	CLSLB		DB 'STATIC',0"
	
# <<<<<<  ресурсы элементов управления
puts $fileid "
	AppName  		DB 'Программа',0
	CapBT_Run       DB 'Расчитать',0
	HBT_Run         DD 0
	CapED_First     DB ' ',0
	HED_First       DD 0
	CapED_Sec       DB ' ',0
	HED_Sec         DD 0
	CapLB_Main      DB 'Введите числa:',0
	HLB_Main        DD 0

	uType           EQU 0
	lpMessCaption   DB 'Сообщение',0
	lpMess          DB 'Результат:', 6 dup(' '),0"


# <<<<<<  прочие константы
puts $fileid " $comm "


# ---- динамические переменные ---- 
puts $fileid "
.data?
	hInstance 		DD ?
	CommandLine 	DD ?"
# []

# стартовый код
puts $fileid "
.code
start:
	invoke GetModuleHandle, NULL
	mov    hInstance,eax
	invoke GetCommandLine
	mov    CommandLine,eax
	invoke WinMain, hInstance, NULL, CommandLine, SW_SHOWDEFAULT
	invoke ExitProcess, eax"

# функция WinMain
puts $fileid "
WinMain proc hInst:HINSTANCE, hPrevInst:HINSTANCE, CmdLine:LPSTR, CmdShow:DWORD
	LOCAL wc:WNDCLASSEX
	LOCAL msg:MSG
	LOCAL hwnd:HWND
	
	mov   wc.cbSize, SIZEOF WNDCLASSEX
	mov   wc.style, CS_HREDRAW or CS_VREDRAW
	mov   wc.lpfnWndProc, OFFSET WndProc
	mov   wc.cbClsExtra, NULL
	mov   wc.cbWndExtra, NULL
	push  hInstance
	pop   wc.hInstance
	mov   wc.hbrBackground, COLOR_WINDOW+1
	mov   wc.lpszMenuName, NULL
	mov   wc.lpszClassName, OFFSET ClassName
	invoke LoadIcon, NULL, IDI_APPLICATION
	mov   wc.hIcon, eax
	mov   wc.hIconSm, eax
	invoke LoadCursor, NULL, IDC_ARROW
	mov   wc.hCursor, eax
	invoke RegisterClassEx, addr wc
	INVOKE CreateWindowEx,NULL,ADDR ClassName,ADDR AppName,\
           WS_OVERLAPPEDWINDOW,CW_USEDEFAULT,\
           CW_USEDEFAULT,300,300,NULL,NULL,\
           hInst,NULL
	mov   hwnd, eax
	invoke ShowWindow, hwnd, SW_SHOWNORMAL
	invoke UpdateWindow, hwnd
	.WHILE TRUE
		invoke GetMessage, ADDR msg, NULL, 0, 0
		.BREAK .IF (!eax)
		invoke TranslateMessage, ADDR msg
		invoke DispatchMessage, ADDR msg
	.ENDW
	mov     eax,msg.wParam
	ret
WinMain endp"

# процедура окна
puts $fileid "
WndProc proc hWnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM
	
	.if uMsg==WM_DESTROY
		
		invoke PostQuitMessage, NULL

	.elseif uMsg==WM_CREATE

		invoke CreateWindowEx,0,OFFSET CLSLB,OFFSET CapLB_Main, STYLLB,20,10,200,20, hWnd,0,hInstance,0
           mov HLB_Main, EAX                         
	    invoke CreateWindowEx,0,OFFSET CLSED,OFFSET CapED_First,STYLED,20,50,100,20,hWnd,0,hInstance,0
           mov HED_First, EAX                        
		invoke CreateWindowEx,0,OFFSET CLSED,OFFSET CapED_Sec,  STYLED,20,90,100,20,hWnd,0,hInstance,0
           mov HED_Sec, EAX                        
		invoke CreateWindowEx,0,OFFSET CLSBT,OFFSET CapBT_Run,  STYLBT,20,130,100,20, hWnd,0,hInstance,0
		   mov HBT_Run, EAX                                               
	
	.elseif uMsg==WM_COMMAND
		
		   mov EAX, HBT_Run 
           cmp lParam, EAX
            je BT_Run_CLICK
		
	.else
		
		invoke DefWindowProc, hWnd, uMsg, wParam, lParam		
		ret
		
	.endif
	jmp	END_MESS
	
BT_Run_CLICK:
	
	invoke MessageBoxA, NULL, OFFSET lpMess, OFFSET lpMessCaption, uType
	   jmp END_MESS
	
END_MESS:
	   xor eax,eax
	   ret
WndProc endp"

# []

# конец программы
puts $fileid "
end start"

close $fileid