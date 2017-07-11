.686p
.model flat,stdcall
option casemap:none

STYLBTN equ WS_CHILD + BS_DEFPUSHBUTTON + WS_VISIBLE
STYLEDT equ WS_CHILD+WS_VISIBLE+WS_BORDER+WS_TABSTOP 

WinMain PROTO :DWORD,:DWORD,:DWORD,:DWORD
TestFunction PROTO 

include c:\masm32\include\windows.inc
include c:\masm32\include\user32.inc
include c:\masm32\include\kernel32.inc
includelib c:\masm32\lib\user32.lib
includelib c:\masm32\lib\kernel32.lib

.DATA
    ClassName db "WinClass",0
    AppName  db "Function test",0
        ;data button
   
    CLSBUTN         DB 'BUTTON',0
    CPBUT1          DB 'Test',0
    HWNDBTN1        DD 0
	    
    CLSEDIT         DB 'EDIT',0
    CPEDT1          DB ' ',0
    HWNDEDT1        DD 0
 
.DATA?
    hInstance       HINSTANCE ?
    CommandLine     LPSTR ?
 
.CODE
START:
	invoke GetModuleHandle, NULL
	   mov    hInstance,eax                                                
	invoke GetCommandLine                                                 
	invoke WinMain, hInstance,NULL,CommandLine, SW_SHOWDEFAULT             
	invoke ExitProcess,eax                                                 
                                                                             
WinMain PROC hInst:HINSTANCE,hPrevInst:HINSTANCE,CmdLine:LPSTR,CmdShow:DWORD
	LOCAL wc:WNDCLASSEX
	LOCAL msg:MSG
	LOCAL hwnd:HWND
	   mov   wc.cbSize,SIZEOF WNDCLASSEX
	   mov   wc.style, CS_HREDRAW or CS_VREDRAW
	   mov   wc.lpfnWndProc, OFFSET WndProc
	   mov   wc.cbClsExtra,NULL
	   mov   wc.cbWndExtra,NULL
	  push  hInst
	   pop   wc.hInstance
	   mov   wc.hbrBackground,2   ;COLOR_MENU;COLOR_WINDOW
	   mov   wc.lpszMenuName,NULL
	   mov   wc.lpszClassName,OFFSET ClassName
	invoke LoadIcon,NULL,IDI_APPLICATION 
	   mov   wc.hIcon,eax                                                  
	   mov   wc.hIconSm,0
	invoke LoadCursor,NULL,IDC_ARROW
	   mov   wc.hCursor,eax                                                
	invoke RegisterClassEx, addr wc                                        
                                                                             
	invoke CreateWindowEx,NULL,ADDR ClassName,ADDR AppName,WS_OVERLAPPEDWINDOW,20,20,300,200,NULL,NULL,hInst,NULL
	   mov   hwnd,eax                                     
	invoke ShowWindow, hwnd,SW_SHOWNORMAL                                  
	invoke UpdateWindow, hwnd                                              
                                                                             
	.WHILE TRUE
		invoke GetMessage, ADDR msg,NULL,0,0                         
		.BREAK .IF (!eax)                           
		invoke TranslateMessage, ADDR msg                            
		invoke DispatchMessage, ADDR msg                    
	.ENDW
	   mov     eax,msg.wParam                                     
	   ret
WinMain endp
                                                               
WndProc PROC hWnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM

	.IF uMsg==WM_DESTROY
		invoke PostQuitMessage,NULL  
      .ELSEIF uMsg==WM_COMMAND
                mov EAX, HWNDBTN1 
                cmp lParam, EAX
                je  BUTTON1_CLICK                

      .ELSEIF uMsg==WM_CREATE    
                                                                               
            invoke CreateWindowEx, 0,OFFSET CLSBUTN,OFFSET CPBUT1,STYLBTN,10,10,100,20,hWnd,0,hInstance,0
                mov HWNDBTN1, EAX                                                                                                                                         
            invoke CreateWindowEx, 0,OFFSET CLSEDIT,OFFSET CPEDT1,STYLEDT,10,70,200,20,hWnd,0,hInstance,0
                mov HWNDEDT1, EAX                                              
                 
	.ELSE
		invoke DefWindowProc,hWnd,uMsg,wParam,lParam                        
		    ret
	.ENDIF
      jmp ENDMESS
      
BUTTON1_CLICK:                                                                  
	invoke TestFunction
	jmp ENDMESS
            
ENDMESS:
	xor    eax,eax
	ret
WndProc ENDP
    
; функция для проверки
TestFunction PROC
    push ebx
    push ecx
   
    

    pop ecx
    pop ebx
    xor    eax,eax
    ret
TestFunction ENDP

END START

