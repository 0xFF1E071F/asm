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


WinMain proto :DWORD,:DWORD,:DWORD,:DWORD

GetConsole proto

.data

	include data.inc

	uType           EQU 0
	lpMessCaption   DB 'Сообщение',0
	lpMess          DB 'Результат:', 6 dup(' '),0
	
	; для вызова консоли
	conTitle 	DB "Application console", 0
	mbuf		DB 255 dup(" "), 0
	l_mbuf		DD 256
	rbuf		DB ?
	l_rbuf		DD 1
	wbuf		DB "Hello, world!", 0
	l_wbuf		DD $-wbuf
	hStdInp		DD 0
	hStdOut		DD 0
	c_read		DD 0
	c_write		DD 0
	
	STD_INP_H	DD -10
	STD_OUT_H	DD -11

.data?
	hInstance 		DD ?
	CommandLine 	DD ?

.code
start:
	invoke GetModuleHandle, NULL
	mov	hInstance,eax
	invoke GetCommandLine
	mov	CommandLine,eax
	invoke GetConsole
	mov hStdOut, EAX
	invoke WinMain, hInstance, NULL, CommandLine, SW_SHOWDEFAULT
	invoke ExitProcess, eax

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
	invoke CreateWindowEx,NULL,ADDR ClassName,ADDR AppName, WS_OVERLAPPEDWINDOW,CW_USEDEFAULT, CW_USEDEFAULT,170,170,NULL,NULL, hInst,NULL
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
WinMain endp

WndProc proc hWnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM
	
	.if uMsg==WM_DESTROY
		
		invoke PostQuitMessage, NULL

	.elseif uMsg==WM_CREATE
		 
		invoke CreateWindowEx, 0, OFFSET CLSLB, OFFSET TLB_L1, STYLLB, 10, 20, 120, 20, hWnd, 0, hInstance, 0
		   mov HLB_L1, EAX
		invoke CreateWindowEx, 0, OFFSET CLSED, OFFSET TED_Ed1, STYLED, 10, 50, 60, 20, hWnd, 0, hInstance, 0
		   mov HED_Ed1, EAX
		invoke CreateWindowEx, 0, OFFSET CLSED, OFFSET TED_Ed2, STYLED, 10, 80, 60, 20, hWnd, 0, hInstance, 0
		   mov HED_Ed2, EAX 
		invoke CreateWindowEx, 0, OFFSET CLSBT, OFFSET TBT_BtConsole, STYLBT, 80, 50, 80, 20, hWnd, 0, hInstance, 0
		   mov HBT_BtConsole, EAX 
		invoke CreateWindowEx, 0, OFFSET CLSBT, OFFSET TBT_BtEdit, STYLBT, 80, 80, 80, 20, hWnd, 0, hInstance, 0
		   mov HBT_BtEdit, EAX	
		invoke CreateWindowEx, 0, OFFSET CLSBT, OFFSET TBT_BtMessage, STYLBT, 80, 110, 80, 20, hWnd, 0, hInstance, 0
		   mov HBT_BtMessage, EAX
	
	.elseif uMsg==WM_COMMAND
		  
		   mov EAX, HBT_BtConsole 
           cmp lParam, EAX
            je BT_CLICK_BtConsole 
			
		   mov EAX, HBT_BtEdit 
           cmp lParam, EAX
            je BT_CLICK_BtEdit
			
		   mov EAX, HBT_BtMessage
           cmp lParam, EAX
            je BT_CLICK_BtMessage
		
	.else
		
		invoke DefWindowProc, hWnd, uMsg, wParam, lParam		
		ret
		
	.endif
	jmp	END_MESS

    
BT_CLICK_BtConsole:
		
		invoke SendMessage, HED_Ed1, WM_GETTEXT, l_mbuf, offset mbuf
		invoke WriteConsoleA, hStdOut, offset mbuf, 3, c_write, 0
		;invoke ReadConsoleA,  hStdInp, offset rbuf, l_rbuf, c_read,  0
		jmp	END_MESS   
		
BT_CLICK_BtEdit:
	   	
	   invoke SendMessage, HED_Ed1, WM_GETTEXT, l_mbuf, offset mbuf
	   invoke SendMessage, HED_Ed2, WM_SETTEXT, l_mbuf, offset mbuf
	   jmp	END_MESS
	   
BT_CLICK_BtMessage:

		invoke SendMessage, HED_Ed1, WM_GETTEXT, l_mbuf, offset mbuf
		invoke MessageBox, 0, offset mbuf, offset lpMessCaption, MB_OK	   	
	    jmp END_MESS
	
END_MESS:
	   xor eax,eax
	   ret
WndProc endp



end start
