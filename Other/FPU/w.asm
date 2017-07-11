.386				
.model flat,stdcall 
option casemap:none

include c:\masm32\include\windows.inc
include c:\masm32\include\user32.inc
include c:\masm32\include\kernel32.inc
includelib c:\masm32\lib\user32.lib
includelib c:\masm32\lib\kernel32.lib

STYLBT equ WS_CHILD+BS_DEFPUSHBUTTON+WS_VISIBLE
STYLED equ WS_CHILD+WS_VISIBLE+WS_BORDER+WS_TABSTOP
STYLLB equ WS_CHILD+WS_VISIBLE

WinMain proto :DWORD,:DWORD,:DWORD,:DWORD

.data

	ClassName	DB 'WinClass',0
	CLSBT 		DB 'BUTTON',0
	CLSED		DB 'EDIT',0
	CLSLB		DB 'STATIC',0

	AppName  	DB 'Программа',0

	uType           EQU 0
	lpMessCaption   DB 'Сообщение',0
	lpMess          DB 'Результат:', 6 dup(' '),0
 
	TLB_Other	DB ' Введите число'
	HLB_Other	DD 0
	TED_Ed1	DB ' '
	HED_Ed1	DD 0 
	TBT_Cancel	DB 'ОК'
	HBT_Cancel	DD 0
	TED_Ed2	DB ' '
	HED_Ed2	DD 0
	TLB_Other1	DB ' *10'
	HLB_Other1	DD 0
	TED_Ed3	DB ' '
	HED_Ed3	DD 0
	TED_Ed4	DB ' '
	HED_Ed4	DD 0
	TLB_Other2	DB ' *2'
	HLB_Other2	DD 0
	TED_Ed5	DB ' '
	HED_Ed5	DD 0
	TED_Ed6	DB ' '
	HED_Ed6	DD 0
	TLB_Other3	DB ' *2'
	HLB_Other3	DD 0
	TED_Ed7	DB ' '
	HED_Ed7	DD 0
	TLB_Other4	DB ' +'
	HLB_Other4	DD 0
	TED_Ed8	DB '01111111'
	HED_Ed8	DD 0
	TLB_Other5	DB ' (+127)'
	HLB_Other5	DD 0
	TED_Ed9	DB '1'
	HED_Ed9	DD 0
	TED_Ed10	DB '23412341'
	HED_Ed10	DD 0
	TED_Ed11	DB '23412341234123412341234'
	HED_Ed11	DD 0
	TLB_Other6	DB '8'
	HLB_Other6	DD 0
	TLB_Other7	DB '8'
	HLB_Other7	DD 0
	TLB_Other8	DB '8'
	HLB_Other8	DD 0
	TLB_Other9	DB '8'
	HLB_Other9	DD 0
	TLB_Other10	DB '8'
	HLB_Other10	DD 0
	TLB_Other11	DB '8'
	HLB_Other11	DD 0
	TLB_Other12	DB '8'
	HLB_Other12	DD 0
	TLB_Other13	DB '8'
	HLB_Other13	DD 0
	TED_Ed12	DB '88888888'
	HED_Ed12	DD 0
	TLB_Other14	DB ' +'
	HLB_Other14	DD 0
	TED_Ed13	DB '01111111111'
	HED_Ed13	DD 0
	TLB_Other15	DB ' (+1023)'
	HLB_Other15	DD 0
	TED_Ed14	DB '1'
	HED_Ed14	DD 0
	TED_Ed15	DB '23412341234'
	HED_Ed15	DD 0
	TED_Ed16	DB '1234123412341234123412341234123412341234123412341234'
	HED_Ed16	DD 0
	TLB_Other16	DB '8'
	HLB_Other16	DD 0
	TLB_Other17	DB '8'
	HLB_Other17	DD 0
	TLB_Other18	DB '8'
	HLB_Other18	DD 0
	TLB_Other19	DB '8'
	HLB_Other19	DD 0
	TLB_Other20	DB '8'
	HLB_Other20	DD 0
	TLB_Other21	DB '8'
	HLB_Other21	DD 0
	TLB_Other22	DB '8'
	HLB_Other22	DD 0
	TLB_Other23	DB '8'
	HLB_Other23	DD 0
	TLB_Other24	DB '8'
	HLB_Other24	DD 0
	TLB_Other25	DB '8'
	HLB_Other25	DD 0
	TLB_Other26	DB '8'
	HLB_Other26	DD 0
	TLB_Other27	DB '8'
	HLB_Other27	DD 0
	TLB_Other28	DB '8'
	HLB_Other28	DD 0
	TLB_Other29	DB '8'
	HLB_Other29	DD 0
	TLB_Other30	DB '8'
	HLB_Other30	DD 0
	TLB_Other31	DB '8'
	HLB_Other31	DD 0
	TED_Ed17	DB '8888888888888888'
	HED_Ed17	DD 0
	TLB_Other32	DB ' +'
	HLB_Other32	DD 0
	TED_Ed18	DB '011111111111111'
	HED_Ed18	DD 0
	TLB_Other33	DB ' (+16383)'
	HLB_Other33	DD 0
	TED_Ed19	DB '1'
	HED_Ed19	DD 0
	TED_Ed20	DB '234123412341234'
	HED_Ed20	DD 0
	TED_Ed21	DB '1234123412341234123412341234123412341234123412341234123412341234'
	HED_Ed21	DD 0
	TLB_Other34	DB '8'
	HLB_Other34	DD 0
	TLB_Other35	DB '8'
	HLB_Other35	DD 0
	TLB_Other36	DB '8'
	HLB_Other36	DD 0
	TLB_Other37	DB '8'
	HLB_Other37	DD 0
	TLB_Other38	DB '8'
	HLB_Other38	DD 0
	TLB_Other39	DB '8'
	HLB_Other39	DD 0
	TLB_Other40	DB '8'
	HLB_Other40	DD 0
	TLB_Other41	DB '8'
	HLB_Other41	DD 0
	TLB_Other42	DB '8'
	HLB_Other42	DD 0
	TLB_Other43	DB '8'
	HLB_Other43	DD 0
	TLB_Other44	DB '8'
	HLB_Other44	DD 0
	TLB_Other45	DB '8'
	HLB_Other45	DD 0
	TLB_Other46	DB '8'
	HLB_Other46	DD 0
	TLB_Other47	DB '8'
	HLB_Other47	DD 0
	TLB_Other48	DB '8'
	HLB_Other48	DD 0
	TLB_Other49	DB '8'
	HLB_Other49	DD 0
	TLB_Other50	DB '8'
	HLB_Other50	DD 0
	TLB_Other51	DB '8'
	HLB_Other51	DD 0
	TLB_Other52	DB '8'
	HLB_Other52	DD 0
	TLB_Other53	DB '8'
	HLB_Other53	DD 0
	TED_Ed22	DB '88888888888888888888'
	HED_Ed22	DD 0

.data?
	hInstance 		DD ?
	CommandLine 	DD ?

.code
start:
	invoke GetModuleHandle, NULL
	mov    hInstance,eax
	invoke GetCommandLine
	mov    CommandLine,eax
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
	INVOKE CreateWindowEx,NULL,ADDR ClassName,ADDR AppName, WS_OVERLAPPEDWINDOW,CW_USEDEFAULT, CW_USEDEFAULT,730,450,NULL,NULL, hInst,NULL
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
		 
		invoke CreateWindowEx, 0, OFFSET CLSLB, OFFSET TLB_Other, STYLLB, 20, 10, 110, 20, hWnd, 0, hInstance, 0
		   mov HLB_Other, EAX
		invoke CreateWindowEx, 0, OFFSET CLSED, OFFSET TED_Ed1, STYLED, 130, 10, 240, 20, hWnd, 0, hInstance, 0
		   mov HED_Ed1, EAX 
		invoke CreateWindowEx, 0, OFFSET CLSBT, OFFSET TBT_Cancel, STYLBT, 380, 10, 30, 20, hWnd, 0, hInstance, 0
		   mov HBT_Cancel, EAX
		invoke CreateWindowEx, 0, OFFSET CLSED, OFFSET TED_Ed2, STYLED, 20, 40, 240, 20, hWnd, 0, hInstance, 0
		   mov HED_Ed2, EAX
		invoke CreateWindowEx, 0, OFFSET CLSLB, OFFSET TLB_Other1, STYLLB, 270, 40, 30, 20, hWnd, 0, hInstance, 0
		   mov HLB_Other1, EAX
		invoke CreateWindowEx, 0, OFFSET CLSED, OFFSET TED_Ed3, STYLED, 310, 40, 60, 20, hWnd, 0, hInstance, 0
		   mov HED_Ed3, EAX
		invoke CreateWindowEx, 0, OFFSET CLSED, OFFSET TED_Ed4, STYLED, 20, 70, 520, 20, hWnd, 0, hInstance, 0
		   mov HED_Ed4, EAX
		invoke CreateWindowEx, 0, OFFSET CLSLB, OFFSET TLB_Other2, STYLLB, 550, 70, 20, 20, hWnd, 0, hInstance, 0
		   mov HLB_Other2, EAX
		invoke CreateWindowEx, 0, OFFSET CLSED, OFFSET TED_Ed5, STYLED, 580, 70, 130, 20, hWnd, 0, hInstance, 0
		   mov HED_Ed5, EAX
		invoke CreateWindowEx, 0, OFFSET CLSED, OFFSET TED_Ed6, STYLED, 20, 100, 520, 20, hWnd, 0, hInstance, 0
		   mov HED_Ed6, EAX
		invoke CreateWindowEx, 0, OFFSET CLSLB, OFFSET TLB_Other3, STYLLB, 550, 100, 20, 20, hWnd, 0, hInstance, 0
		   mov HLB_Other3, EAX
		invoke CreateWindowEx, 0, OFFSET CLSED, OFFSET TED_Ed7, STYLED, 580, 100, 130, 20, hWnd, 0, hInstance, 0
		   mov HED_Ed7, EAX
		invoke CreateWindowEx, 0, OFFSET CLSLB, OFFSET TLB_Other4, STYLLB, 20, 140, 45, 20, hWnd, 0, hInstance, 0
		   mov HLB_Other4, EAX
		invoke CreateWindowEx, 0, OFFSET CLSED, OFFSET TED_Ed8, STYLED, 35, 140, 70, 20, hWnd, 0, hInstance, 0
		   mov HED_Ed8, EAX
		invoke CreateWindowEx, 0, OFFSET CLSLB, OFFSET TLB_Other5, STYLLB, 110, 140, 45, 20, hWnd, 0, hInstance, 0
		   mov HLB_Other5, EAX
		invoke CreateWindowEx, 0, OFFSET CLSED, OFFSET TED_Ed9, STYLED, 20, 170, 15, 20, hWnd, 0, hInstance, 0
		   mov HED_Ed9, EAX
		invoke CreateWindowEx, 0, OFFSET CLSED, OFFSET TED_Ed10, STYLED, 35, 170, 70, 20, hWnd, 0, hInstance, 0
		   mov HED_Ed10, EAX
		invoke CreateWindowEx, 0, OFFSET CLSED, OFFSET TED_Ed11, STYLED, 105, 170, 190, 20, hWnd, 0, hInstance, 0
		   mov HED_Ed11, EAX
		invoke CreateWindowEx, 0, OFFSET CLSLB, OFFSET TLB_Other6, STYLLB, 41, 190, 8, 20, hWnd, 0, hInstance, 0
		   mov HLB_Other6, EAX
		invoke CreateWindowEx, 0, OFFSET CLSLB, OFFSET TLB_Other7, STYLLB, 74, 190, 8, 20, hWnd, 0, hInstance, 0
		   mov HLB_Other7, EAX
		invoke CreateWindowEx, 0, OFFSET CLSLB, OFFSET TLB_Other8, STYLLB, 111, 190, 8, 20, hWnd, 0, hInstance, 0
		   mov HLB_Other8, EAX
		invoke CreateWindowEx, 0, OFFSET CLSLB, OFFSET TLB_Other9, STYLLB, 143, 190, 8, 20, hWnd, 0, hInstance, 0
		   mov HLB_Other9, EAX
		invoke CreateWindowEx, 0, OFFSET CLSLB, OFFSET TLB_Other10, STYLLB, 175, 190, 8, 20, hWnd, 0, hInstance, 0
		   mov HLB_Other10, EAX
		invoke CreateWindowEx, 0, OFFSET CLSLB, OFFSET TLB_Other11, STYLLB, 207, 190, 8, 20, hWnd, 0, hInstance, 0
		   mov HLB_Other11, EAX
		invoke CreateWindowEx, 0, OFFSET CLSLB, OFFSET TLB_Other12, STYLLB, 239, 190, 8, 20, hWnd, 0, hInstance, 0
		   mov HLB_Other12, EAX
		invoke CreateWindowEx, 0, OFFSET CLSLB, OFFSET TLB_Other13, STYLLB, 271, 190, 8, 20, hWnd, 0, hInstance, 0
		   mov HLB_Other13, EAX
		invoke CreateWindowEx, 0, OFFSET CLSED, OFFSET TED_Ed12, STYLED, 225, 140, 70, 20, hWnd, 0, hInstance, 0
		   mov HED_Ed12, EAX
		invoke CreateWindowEx, 0, OFFSET CLSLB, OFFSET TLB_Other14, STYLLB, 20, 230, 45, 20, hWnd, 0, hInstance, 0
		   mov HLB_Other14, EAX
		invoke CreateWindowEx, 0, OFFSET CLSED, OFFSET TED_Ed13, STYLED, 35, 230, 93, 20, hWnd, 0, hInstance, 0
		   mov HED_Ed13, EAX
		invoke CreateWindowEx, 0, OFFSET CLSLB, OFFSET TLB_Other15, STYLLB, 128, 230, 60, 20, hWnd, 0, hInstance, 0
		   mov HLB_Other15, EAX
		invoke CreateWindowEx, 0, OFFSET CLSED, OFFSET TED_Ed14, STYLED, 20, 260, 15, 20, hWnd, 0, hInstance, 0
		   mov HED_Ed14, EAX
		invoke CreateWindowEx, 0, OFFSET CLSED, OFFSET TED_Ed15, STYLED, 35, 260, 93, 20, hWnd, 0, hInstance, 0
		   mov HED_Ed15, EAX
		invoke CreateWindowEx, 0, OFFSET CLSED, OFFSET TED_Ed16, STYLED, 128, 260, 420, 20, hWnd, 0, hInstance, 0
		   mov HED_Ed16, EAX
		invoke CreateWindowEx, 0, OFFSET CLSLB, OFFSET TLB_Other16, STYLLB, 41, 280, 8, 20, hWnd, 0, hInstance, 0
		   mov HLB_Other16, EAX
		invoke CreateWindowEx, 0, OFFSET CLSLB, OFFSET TLB_Other17, STYLLB, 74, 280, 8, 20, hWnd, 0, hInstance, 0
		   mov HLB_Other17, EAX
		invoke CreateWindowEx, 0, OFFSET CLSLB, OFFSET TLB_Other18, STYLLB, 106, 280, 8, 20, hWnd, 0, hInstance, 0
		   mov HLB_Other18, EAX
		invoke CreateWindowEx, 0, OFFSET CLSLB, OFFSET TLB_Other19, STYLLB, 143, 280, 8, 20, hWnd, 0, hInstance, 0
		   mov HLB_Other19, EAX
		invoke CreateWindowEx, 0, OFFSET CLSLB, OFFSET TLB_Other20, STYLLB, 175, 280, 8, 20, hWnd, 0, hInstance, 0
		   mov HLB_Other20, EAX
		invoke CreateWindowEx, 0, OFFSET CLSLB, OFFSET TLB_Other21, STYLLB, 207, 280, 8, 20, hWnd, 0, hInstance, 0
		   mov HLB_Other21, EAX
		invoke CreateWindowEx, 0, OFFSET CLSLB, OFFSET TLB_Other22, STYLLB, 239, 280, 8, 20, hWnd, 0, hInstance, 0
		   mov HLB_Other22, EAX
		invoke CreateWindowEx, 0, OFFSET CLSLB, OFFSET TLB_Other23, STYLLB, 271, 280, 8, 20, hWnd, 0, hInstance, 0
		   mov HLB_Other23, EAX
		invoke CreateWindowEx, 0, OFFSET CLSLB, OFFSET TLB_Other24, STYLLB, 303, 280, 8, 20, hWnd, 0, hInstance, 0
		   mov HLB_Other24, EAX
		invoke CreateWindowEx, 0, OFFSET CLSLB, OFFSET TLB_Other25, STYLLB, 335, 280, 8, 20, hWnd, 0, hInstance, 0
		   mov HLB_Other25, EAX
		invoke CreateWindowEx, 0, OFFSET CLSLB, OFFSET TLB_Other26, STYLLB, 367, 280, 8, 20, hWnd, 0, hInstance, 0
		   mov HLB_Other26, EAX
		invoke CreateWindowEx, 0, OFFSET CLSLB, OFFSET TLB_Other27, STYLLB, 399, 280, 8, 20, hWnd, 0, hInstance, 0
		   mov HLB_Other27, EAX
		invoke CreateWindowEx, 0, OFFSET CLSLB, OFFSET TLB_Other28, STYLLB, 431, 280, 8, 20, hWnd, 0, hInstance, 0
		   mov HLB_Other28, EAX
		invoke CreateWindowEx, 0, OFFSET CLSLB, OFFSET TLB_Other29, STYLLB, 463, 280, 8, 20, hWnd, 0, hInstance, 0
		   mov HLB_Other29, EAX
		invoke CreateWindowEx, 0, OFFSET CLSLB, OFFSET TLB_Other30, STYLLB, 495, 280, 8, 20, hWnd, 0, hInstance, 0
		   mov HLB_Other30, EAX
		invoke CreateWindowEx, 0, OFFSET CLSLB, OFFSET TLB_Other31, STYLLB, 527, 280, 8, 20, hWnd, 0, hInstance, 0
		   mov HLB_Other31, EAX
		invoke CreateWindowEx, 0, OFFSET CLSED, OFFSET TED_Ed17, STYLED, 413, 230, 135, 20, hWnd, 0, hInstance, 0
		   mov HED_Ed17, EAX
		invoke CreateWindowEx, 0, OFFSET CLSLB, OFFSET TLB_Other32, STYLLB, 20, 320, 45, 20, hWnd, 0, hInstance, 0
		   mov HLB_Other32, EAX
		invoke CreateWindowEx, 0, OFFSET CLSED, OFFSET TED_Ed18, STYLED, 35, 320, 125, 20, hWnd, 0, hInstance, 0
		   mov HED_Ed18, EAX
		invoke CreateWindowEx, 0, OFFSET CLSLB, OFFSET TLB_Other33, STYLLB, 162, 320, 67, 20, hWnd, 0, hInstance, 0
		   mov HLB_Other33, EAX
		invoke CreateWindowEx, 0, OFFSET CLSED, OFFSET TED_Ed19, STYLED, 20, 350, 15, 20, hWnd, 0, hInstance, 0
		   mov HED_Ed19, EAX
		invoke CreateWindowEx, 0, OFFSET CLSED, OFFSET TED_Ed20, STYLED, 35, 350, 125, 20, hWnd, 0, hInstance, 0
		   mov HED_Ed20, EAX
		invoke CreateWindowEx, 0, OFFSET CLSED, OFFSET TED_Ed21, STYLED, 160, 350, 518, 20, hWnd, 0, hInstance, 0
		   mov HED_Ed21, EAX
		invoke CreateWindowEx, 0, OFFSET CLSLB, OFFSET TLB_Other34, STYLLB, 41, 370, 8, 20, hWnd, 0, hInstance, 0
		   mov HLB_Other34, EAX
		invoke CreateWindowEx, 0, OFFSET CLSLB, OFFSET TLB_Other35, STYLLB, 74, 370, 8, 20, hWnd, 0, hInstance, 0
		   mov HLB_Other35, EAX
		invoke CreateWindowEx, 0, OFFSET CLSLB, OFFSET TLB_Other36, STYLLB, 106, 370, 8, 20, hWnd, 0, hInstance, 0
		   mov HLB_Other36, EAX
		invoke CreateWindowEx, 0, OFFSET CLSLB, OFFSET TLB_Other37, STYLLB, 138, 370, 8, 20, hWnd, 0, hInstance, 0
		   mov HLB_Other37, EAX
		invoke CreateWindowEx, 0, OFFSET CLSLB, OFFSET TLB_Other38, STYLLB, 175, 370, 8, 20, hWnd, 0, hInstance, 0
		   mov HLB_Other38, EAX
		invoke CreateWindowEx, 0, OFFSET CLSLB, OFFSET TLB_Other39, STYLLB, 207, 370, 8, 20, hWnd, 0, hInstance, 0
		   mov HLB_Other39, EAX
		invoke CreateWindowEx, 0, OFFSET CLSLB, OFFSET TLB_Other40, STYLLB, 239, 370, 8, 20, hWnd, 0, hInstance, 0
		   mov HLB_Other40, EAX
		invoke CreateWindowEx, 0, OFFSET CLSLB, OFFSET TLB_Other41, STYLLB, 271, 370, 8, 20, hWnd, 0, hInstance, 0
		   mov HLB_Other41, EAX
		invoke CreateWindowEx, 0, OFFSET CLSLB, OFFSET TLB_Other42, STYLLB, 303, 370, 8, 20, hWnd, 0, hInstance, 0
		   mov HLB_Other42, EAX
		invoke CreateWindowEx, 0, OFFSET CLSLB, OFFSET TLB_Other43, STYLLB, 335, 370, 8, 20, hWnd, 0, hInstance, 0
		   mov HLB_Other43, EAX
		invoke CreateWindowEx, 0, OFFSET CLSLB, OFFSET TLB_Other44, STYLLB, 367, 370, 8, 20, hWnd, 0, hInstance, 0
		   mov HLB_Other44, EAX
		invoke CreateWindowEx, 0, OFFSET CLSLB, OFFSET TLB_Other45, STYLLB, 399, 370, 8, 20, hWnd, 0, hInstance, 0
		   mov HLB_Other45, EAX
		invoke CreateWindowEx, 0, OFFSET CLSLB, OFFSET TLB_Other46, STYLLB, 431, 370, 8, 20, hWnd, 0, hInstance, 0
		   mov HLB_Other46, EAX
		invoke CreateWindowEx, 0, OFFSET CLSLB, OFFSET TLB_Other47, STYLLB, 463, 370, 8, 20, hWnd, 0, hInstance, 0
		   mov HLB_Other47, EAX
		invoke CreateWindowEx, 0, OFFSET CLSLB, OFFSET TLB_Other48, STYLLB, 495, 370, 8, 20, hWnd, 0, hInstance, 0
		   mov HLB_Other48, EAX
		invoke CreateWindowEx, 0, OFFSET CLSLB, OFFSET TLB_Other49, STYLLB, 527, 370, 8, 20, hWnd, 0, hInstance, 0
		   mov HLB_Other49, EAX
		invoke CreateWindowEx, 0, OFFSET CLSLB, OFFSET TLB_Other50, STYLLB, 559, 370, 8, 20, hWnd, 0, hInstance, 0
		   mov HLB_Other50, EAX
		invoke CreateWindowEx, 0, OFFSET CLSLB, OFFSET TLB_Other51, STYLLB, 591, 370, 8, 20, hWnd, 0, hInstance, 0
		   mov HLB_Other51, EAX
		invoke CreateWindowEx, 0, OFFSET CLSLB, OFFSET TLB_Other52, STYLLB, 623, 370, 8, 20, hWnd, 0, hInstance, 0
		   mov HLB_Other52, EAX
		invoke CreateWindowEx, 0, OFFSET CLSLB, OFFSET TLB_Other53, STYLLB, 655, 370, 8, 20, hWnd, 0, hInstance, 0
		   mov HLB_Other53, EAX
		invoke CreateWindowEx, 0, OFFSET CLSED, OFFSET TED_Ed22, STYLED, 513, 320, 165, 20, hWnd, 0, hInstance, 0
		   mov HED_Ed22, EAX	
	
	.elseif uMsg==WM_COMMAND
		  
		   mov EAX, HBT_Cancel 
           cmp lParam, EAX
            je BT_CLICK_Cancel
		
	.else
		
		invoke DefWindowProc, hWnd, uMsg, wParam, lParam		
		ret
		
	.endif
	jmp	END_MESS

    
BT_CLICK_Cancel:
	   	
	   jmp END_MESS
	
END_MESS:
	   xor eax,eax
	   ret
WndProc endp

end start
