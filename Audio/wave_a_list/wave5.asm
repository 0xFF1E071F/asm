.686
.model flat, stdcall  
option casemap :none  

include		windows.inc
include		kernel32.inc
include		user32.inc
include		Comctl32.inc
include		shell32.inc
include 	winmm.inc
includelib	kernel32.lib
includelib	user32.lib
includelib	Comctl32.lib
includelib	shell32.lib
includelib 	winmm.lib

DlgProc	PROTO :HWND,:UINT,:WPARAM,:LPARAM
ShowWaveDevices PROTO :HWND

.const

IDD_MAIN	equ		101
IDC_CBO1	equ		102
IDC_LST1	equ		103

zsWhiteString	db " ",0

.data?

hInstance	dd		?
hListBox	dd		?

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
		invoke GetDlgItem,hWin,IDC_LST1
		mov hListBox, eax	
		invoke ShowWaveDevices, hListBox
	.elseif	eax==WM_COMMAND
		mov edx,wParam
		movzx eax,dx
		shr edx,16
		.if edx==BN_CLICKED
			.if eax==IDOK
								
			.elseif eax==IDCANCEL
				invoke	SendMessage,hWin,WM_CLOSE,NULL,NULL
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

ShowWaveDevices proc hList:HWND 
	LOCAL inCaps: WAVEINCAPS
	LOCAL outCaps: WAVEOUTCAPS	
	LOCAL count: DWORD			
	push ebx
	invoke waveInGetNumDevs
	mov count, eax	
	test eax, eax
    jle loop_in_end	
    xor ebx, ebx
loop_in:
	push ebx
	invoke waveInGetDevCaps,ebx,addr inCaps,SIZEOF WAVEINCAPS
	invoke SendMessage,hList,LB_ADDSTRING,0,addr inCaps.szPname
	pop ebx
	inc ebx	
	cmp ebx, count
	jl loop_in
loop_in_end: 		
	invoke SendMessage,hList,LB_ADDSTRING,0,addr zsWhiteString	
	invoke waveOutGetNumDevs
	mov count, eax	
	test eax, eax
    jle loop_out_end	
    xor ebx,ebx	
loop_out:
	push ebx
	invoke waveOutGetDevCaps,ebx,addr outCaps,SIZEOF WAVEOUTCAPS
	invoke SendMessage,hList,LB_ADDSTRING,0,addr outCaps.szPname
	pop ebx
	inc ebx	
	cmp ebx, count
	jl loop_out
loop_out_end:
	pop ebx			
	ret
ShowWaveDevices endp

end start
