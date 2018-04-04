.686P
.model flat,stdcall 
option casemap:none

include		c:\masm32\include\windows.inc
include		c:\masm32\include\kernel32.inc
include		c:\masm32\include\user32.inc
include		c:\masm32\include\Comctl32.inc
include		c:\masm32\include\shell32.inc
include		c:\masm32\include\masm32.inc
includelib	c:\masm32\lib\kernel32.lib
includelib	c:\masm32\lib\user32.lib
includelib	c:\masm32\lib\Comctl32.lib
includelib	c:\masm32\lib\shell32.lib
includelib	c:\masm32\lib\masm32.lib

DlgProc PROTO :HWND,:UINT,:WPARAM,:LPARAM

.const
IDD_MAIN equ 1000
IDC_EDT1 equ 1001
IDC_STC1 equ 1002
IDC_BTN1 equ 1003

.data?
hInstance dd ?
hWnd dd ?

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
				
				;invoke MakeSound				
			.elseif eax==IDCANCEL
				
			.endif
		.endif
	.elseif	eax==WM_CLOSE
		;invoke Finalize
		invoke EndDialog,hWin,0
	.else
		mov	eax,FALSE
		ret
	.endif
	mov	eax,TRUE
	ret
DlgProc endp

end start