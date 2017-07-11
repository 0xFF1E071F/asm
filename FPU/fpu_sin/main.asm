.686
.model flat, stdcall  
option casemap :none  

include		c:\masm32\include\windows.inc
include		c:\masm32\include\kernel32.inc
include		c:\masm32\include\user32.inc
include		c:\masm32\include\Comctl32.inc
include		c:\masm32\include\shell32.inc
include 		c:\masm32\include\winmm.inc
include		c:\masm32\include\masm32.inc
includelib	c:\masm32\lib\kernel32.lib
includelib	c:\masm32\lib\user32.lib
includelib	c:\masm32\lib\Comctl32.lib
includelib	c:\masm32\lib\shell32.lib
includelib 	c:\masm32\lib\winmm.lib
includelib	c:\masm32\lib\masm32.lib

DlgProc PROTO :HWND,:UINT,:WPARAM,:LPARAM
CalcSin PROTO :DWORD	

.const

IDD_MAIN	equ		101
SIZE_BUF	equ		88200

.data

MBCaption  db "Sound",0
MStart  db "Start",0
MFinish  db "Finish",0
MGo db "Go",0
MFail  db "Fail",0
szBuffer db SIZE_BUF dup (0)
_2 dq 2.0
_2pi1 dt 4001c90fdaa22168c235h


.data?

hInstance	dd		?
hListBox	dd		?
_2pi dt ?

.code
start:
	invoke	GetModuleHandle,NULL
	mov	hInstance,eax
	invoke	InitCommonControls
	invoke	DialogBoxParam,hInstance,IDD_MAIN,NULL,addr DlgProc,NULL
	invoke	ExitProcess,0

DlgProc	proc hWin:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM		
	mov	eax,uMsg
	.if	eax==WM_INITDIALOG		
		
	.elseif	eax==WM_COMMAND
		mov edx,wParam
		movzx eax,dx
		shr edx,16
		.if edx==BN_CLICKED
			.if eax==IDOK
				invoke CalcSin, 45				
			.elseif eax==IDCANCEL
				invoke MessageBox, NULL, addr MFinish, addr MBCaption, MB_OK
			.endif
		.endif
	.elseif	eax==WM_CLOSE
		invoke	EndDialog,hWin,0
	.else
		mov	eax,FALSE
		ret
	.endif
	mov	eax,TRUE
	ret
DlgProc endp

CalcSin proc alpha :DWORD		
	finit   
    fldpi
	fld _2
	fmul
	fstp _2pi
	fincstp
	fld _2pi1	
	;push 3C 8E FA 35 h
	;fmul dword ptr [esp]
    ;fsin  
    ;pop eax  
    ;fstp alpha
	ret
CalcSin endp

end start
