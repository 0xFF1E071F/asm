
;COMAPIas v.1.00
;htpp:\\www.softelectro.ru
;Electron18.  
.386
.model flat,stdcall
option casemap:none

STYLBTN equ WS_CHILD + BS_DEFPUSHBUTTON + WS_VISIBLE
STYLEDT equ WS_CHILD+WS_VISIBLE+WS_BORDER+WS_TABSTOP 

WinMain PROTO :DWORD,:DWORD,:DWORD,:DWORD
PurgeBuf PROTO 

include \masm32\include\windows.inc
include \masm32\include\user32.inc
include \masm32\include\kernel32.inc
includelib \masm32\lib\user32.lib
includelib \masm32\lib\kernel32.lib

.DATA
    ClassName db "SimpleWinClass",0
    AppName  db "COMAPIas v.1.00",0
        ;data button
   
    CLSBUTN         DB 'BUTTON',0
    CPBUT1          DB 'Open port',0
    HWNDBTN1        DD 0
    CPBUT2          DB 'Close port',0
    HWNDBTN2        DD 0
    CPBUT3          DB 'Read port',0
    HWNDBTN3        DD 0
    CPBUT4          DB 'Write port',0
    HWNDBTN4        DD 0
        ;data edit
    CLSEDIT         DB 'EDIT',0
    CPEDT1          DB ' ',0
    HWNDEDT1        DD 0
    CPEDT2          DB 'Hello World!',0
    HWNDEDT2        DD 0
    TEXT            DB 'Строка редактирования',0

        ;Message App
        ;App message
    uType           EQU 0
    lpCapApp        DB "App message",0
    lpApp1          DB "Open port HANDLE:", 6 dup(" "),0
    lpApp2          DB "Close port",0
    lpApp3          DB "Data read: Ok",0
    lpApp4          DB "Data write: Ok",0
    
        ;error message
    lpCapERR        DB "Error Message",0       
    lpERR1          DB "Open port Error:",10 dup(" "),0
    lpERR2          DB "DCB Structure ERROR:",10 dup(" "),0
    lpERR3          DB "SetComm Function ERROR:",10 dup(" "),0
    lpERR4          DB "Read port ERROR:",10 dup(" "),0
    lpERR5          DB "Write port ERROR:",10 dup(" "),0
    lpERR6          DB "Close port ERROR:",10 dup(" "),0
   
        ;data com port
    Mem1            DD 0
    Par1            DB "%lu",0
    Buf             DB 255 dup(" "),0
    HWNDCOM         DD 0
    LenBuf          DD 0
    NumCOM          DB "COM1:",0
    COMSETTING      DB "Com1: baud=1200 parity=N data=8 stop=1",0
    DCB1            DCB <>  

.DATA?
    hInstance       HINSTANCE ?
    CommandLine     LPSTR ?
   

.CODE
START:
	INVOKE GetModuleHandle, NULL
	   mov    hInstance,eax                                                ;handle app
	INVOKE GetCommandLine                                                  ;handle command line
	INVOKE WinMain, hInstance,NULL,CommandLine, SW_SHOWDEFAULT             ;input to app
	INVOKE ExitProcess,eax                                                 ;exit app
                                                                             ;main window
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
	   mov   wc.hbrBackground,4;COLOR_MENU;COLOR_WINDOW
	   mov   wc.lpszMenuName,NULL
	   mov   wc.lpszClassName,OFFSET ClassName
	INVOKE LoadIcon,NULL,IDI_APPLICATION 
	   mov   wc.hIcon,eax                                                  ;handle icon
	   mov   wc.hIconSm,0
	INVOKE LoadCursor,NULL,IDC_ARROW
	   mov   wc.hCursor,eax                                                ;handle cursor
	INVOKE RegisterClassEx, addr wc                                        ;register class window
                                                                             ;create main window
	INVOKE CreateWindowEx,NULL,ADDR ClassName,ADDR AppName,WS_OVERLAPPEDWINDOW,20,20,800,200,NULL,NULL,hInst,NULL
	   mov   hwnd,eax                                     
	INVOKE ShowWindow, hwnd,SW_SHOWNORMAL                                  ;show window
	INVOKE UpdateWindow, hwnd                                              ;update window

                                                                             ;loop message
	.WHILE TRUE
                INVOKE GetMessage, ADDR msg,NULL,0,0                         ;get message
                .BREAK .IF (!eax)                           
                INVOKE TranslateMessage, ADDR msg                            ;get key char
                INVOKE DispatchMessage, ADDR msg                             ;call Win Proc
                
	.ENDW
	           mov     eax,msg.wParam                                     
	           ret
WinMain endp


                                                                             ;procedure window
WndProc PROC hWnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM

	.IF uMsg==WM_DESTROY
		INVOKE PostQuitMessage,NULL  
      .ELSEIF uMsg==WM_COMMAND
                mov EAX, HWNDBTN1 
                cmp lParam, EAX
                je  BUTTON1_CLICK

                mov EAX, HWNDBTN2 
                cmp lParam, EAX
                je  BUTTON2_CLICK

                mov EAX, HWNDBTN3 
                cmp lParam, EAX
                je  BUTTON3_CLICK

                mov EAX, HWNDBTN4 
                cmp lParam, EAX
                je  BUTTON4_CLICK     

      .ELSEIF uMsg==WM_CREATE    
                                                                                ;create button1..4
            INVOKE CreateWindowEx, 0,OFFSET CLSBUTN,OFFSET CPBUT1,STYLBTN,10,10,100,20,hWnd,0,hInstance,0
                mov HWNDBTN1, EAX                                               ; handle button1
            INVOKE CreateWindowEx, 0,OFFSET CLSBUTN,OFFSET CPBUT2,STYLBTN,10,40,100,20,hWnd,0,hInstance,0
                mov HWNDBTN2, EAX                                               ; handle button2
            INVOKE CreateWindowEx, 0,OFFSET CLSBUTN,OFFSET CPBUT3,STYLBTN,10,70,100,20,hWnd,0,hInstance,0
                mov HWNDBTN3, EAX                                               ; handle button3
            INVOKE CreateWindowEx, 0,OFFSET CLSBUTN,OFFSET CPBUT4,STYLBTN,10,100,100,20,hWnd,0,hInstance,0
                mov HWNDBTN4, EAX                                               ; handle button4
                                                                                ;create edit1 and edit2
            INVOKE CreateWindowEx, 0,OFFSET CLSEDIT,OFFSET CPEDT1,STYLEDT,120,70,600,20,hWnd,0,hInstance,0
                mov HWNDEDT1, EAX                                               ; handle edit1
            INVOKE CreateWindowEx, 0,OFFSET CLSEDIT,OFFSET CPEDT2,STYLEDT,120,100,600,20,hWnd,0,hInstance,0
                mov HWNDEDT2, EAX                                               ; handle edit2
      
	.ELSE
		INVOKE DefWindowProc,hWnd,uMsg,wParam,lParam                        ;default message
		    ret
	.ENDIF
      jmp ENDMESS
      
BUTTON1_CLICK:                                                                  ;open port
            INVOKE CreateFile,OFFSET NumCOM, GENERIC_READ or GENERIC_WRITE, NULL, NULL, OPEN_EXISTING, NULL,NULL
                mov HWNDCOM, eax
                .IF EAX==-1
                    INVOKE GetLastError
                        mov Mem1,eax
                    INVOKE wsprintf,OFFSET lpERR1(17),OFFSET Par1,Mem1;
                    INVOKE MessageBoxA,NULL,OFFSET lpERR1,OFFSET lpCapERR,uType
                .ELSE
                    INVOKE wsprintf,OFFSET lpApp1(18),OFFSET Par1,HWNDCOM
                    INVOKE MessageBoxA,NULL,OFFSET lpApp1,OFFSET lpCapApp,uType
                    INVOKE BuildCommDCB,OFFSET COMSETTING, OFFSET DCB1
                    .IF EAX==0
                        INVOKE GetLastError
                            mov Mem1,eax
                        INVOKE wsprintf,OFFSET lpERR2(21),OFFSET Par1,Mem1;
                        INVOKE MessageBoxA,NULL,OFFSET lpERR2,OFFSET lpCapERR,uType
                    .ENDIF
                    INVOKE SetCommState,HWNDCOM,OFFSET DCB1
                    .IF EAX==0
                        INVOKE GetLastError
                            mov Mem1,eax
                        INVOKE wsprintf,OFFSET lpERR3(24),OFFSET Par1,Mem1;
                        INVOKE MessageBoxA,NULL,OFFSET lpERR3,OFFSET lpCapERR,uType
                    .ENDIF
                .ENDIF
            jmp ENDMESS
            
BUTTON2_CLICK:                                                                  ;close port
            INVOKE CloseHandle,HWNDCOM
             .IF EAX==0
                INVOKE GetLastError
                    mov Mem1,eax
                INVOKE wsprintf,OFFSET lpERR6(18),OFFSET Par1,Mem1;
                INVOKE MessageBoxA,NULL,OFFSET lpERR6,OFFSET lpCapERR,uType
            .ELSE
                INVOKE MessageBoxA,NULL,OFFSET lpApp2,OFFSET lpCapApp,uType
            .ENDIF


            
            jmp ENDMESS
            
BUTTON3_CLICK:
            CALL  PurgeBuf                                                                   ;read port                          
            INVOKE ReadFile,HWNDCOM,OFFSET Buf, SIZEOF Buf,OFFSET LenBuf, NULL
            .IF EAX==0
                INVOKE GetLastError
                    mov Mem1,eax
                INVOKE wsprintf,OFFSET lpERR4(17),OFFSET Par1,Mem1;
                INVOKE MessageBoxA,NULL,OFFSET lpERR4,OFFSET lpCapERR,uType
            .ELSE
                INVOKE SendMessage,HWNDEDT1,WM_SETTEXT,SIZEOF Buf,OFFSET Buf
                INVOKE MessageBoxA,NULL,OFFSET lpApp3,OFFSET lpCapApp,uType
            .ENDIF
            jmp ENDMESS
            
BUTTON4_CLICK:                                                                  ;write port
                CALL  PurgeBuf
                INVOKE SendMessage,HWNDEDT2,WM_GETTEXT,SIZEOF Buf,OFFSET Buf
                INVOKE WriteFile,HWNDCOM,OFFSET Buf, SIZEOF Buf,OFFSET LenBuf, NULL
            .IF EAX==0
                INVOKE GetLastError
                    mov Mem1,eax
                INVOKE wsprintf,OFFSET lpERR5(18),OFFSET Par1,Mem1;
                INVOKE MessageBoxA,NULL,OFFSET lpERR5,OFFSET lpCapERR,uType
            .ELSE
                INVOKE MessageBoxA,NULL,OFFSET lpApp4,OFFSET lpCapApp,uType
            .ENDIF
 
            jmp ENDMESS



ENDMESS:
	xor    eax,eax
	ret
WndProc ENDP
                                                                ; clear buffer
PurgeBuf PROC
    push ebx
    push ecx
   
    mov cx,255
    mov ebx,offset Buf
    mov al,20h
 L:
    mov [ebx],al
    inc ebx
    LOOP L

    pop ecx
    pop ebx
    xor    eax,eax
    ret
PurgeBuf ENDP

END START

