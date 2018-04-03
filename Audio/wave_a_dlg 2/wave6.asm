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
Initialize PROTO
Finalize PROTO
FillBufferRandom PROTO :DWORD, :DWORD, :DWORD
FillBufferSinus PROTO :DWORD, :DWORD
SaveToFile PROTO :DWORD, :DWORD, :DWORD
MakeSound PROTO
TestAddr proto

.const

IDD_MAIN	equ		101
SIZE_BUF	equ		88200

.data

MBCaption	db "Sound",0
MStart  	db "Start",0
MFinish  	db "Finish",0
MGo 		db "Go",0
MFail  		db "Fail",0
fileName1 	db 'c:\\1.bin',0
fileName2 	db 'c:\\2.bin',0
header 	dd 0
header1  	dd 0
header2 	dd 0
Buffer1 	db SIZE_BUF dup (0)
Buffer2 	db SIZE_BUF dup (0)

freq		dq 1000.0
startt	dq 0.0
ampl 	dq 255.0

_2pi	dt 4001c90fdaa22168c235h

.data?

hInstance	dd		?
hListBox		dd		?

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
		invoke Initialize
	.elseif	eax==WM_COMMAND
		mov edx,wParam
		movzx eax,dx
		shr edx,16
		.if edx==BN_CLICKED
			.if eax==IDOK				
				invoke FillBufferRandom, header1,  SIZE_BUF, 0ffh
				invoke FillBufferSinus, header2,  SIZE_BUF
				invoke SaveToFile, addr fileName1, header1, SIZE_BUF
				invoke SaveToFile, addr fileName2, header2, SIZE_BUF
				;invoke MakeSound				
			.elseif eax==IDCANCEL
				invoke MessageBox, NULL, addr MFinish, addr MBCaption, MB_OK
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

Initialize proc	
	mov header1, offset Buffer1	
	mov header2, offset Buffer2
	ret
Initialize endp

Finalize proc
	xor eax, eax
	ret
Finalize endp

FillBufferRandom proc pBuffer:DWORD, bufSize:DWORD, level:DWORD
	invoke  GetTickCount    
	invoke  nseed, eax
	mov ebx, pBuffer
	xor esi, esi
loop_rnd:	
	invoke  nrandom, level    ;0ffh	;mov eax, level	
	mov byte ptr [ebx+esi], al	
	inc esi
	cmp esi, bufSize
	jl loop_rnd
	ret
FillBufferRandom endp
	
FillBufferSinus proc pBuffer:DWORD, bufSize:DWORD
	LOCAL res : DWORD 		
	finit		
	fld _2pi 										
	fld1										
	fild dword ptr bufSize							; получили dt			
	fdiv	
	fmul freq    							; получили freq*dt
	fmul st, st(1)						; получили w*dt		
	mov ebx, pBuffer 				; подготовка цикла
	xor esi, esi
	fld startt											
	fld st	
loop_sin:		
	fsin
	fmul ampl	
	fistp dword ptr res
	mov eax, res
	mov ah, al
	mov word ptr [ebx+esi], ax		; выгрузка в массив		
	fadd st, st(1)							; прибавляем wdt
	fcomi st, st(2)							; проверяем, что не стало больше 2pi
	jg less_2pi
	fsub st, st(2)  							; отнимаем 2pi
less_2pi:	
	fld st		
	add esi, 2								; переход на следующий шаг
	cmp esi, bufSize						
	jl loop_sin	
	fstp startt								; сохранение времени, до которого расчитали	
	ret
FillBufferSinus endp


SaveToFile proc pFileName:DWORD, pBuffer:DWORD, szBuffer:DWORD
	LOCAL SizeReadWrite: DWORD 
	LOCAL hFile: DWORD
	invoke CreateFile, pFileName, \ 
				GENERIC_READ or GENERIC_WRITE, \ 
				FILE_SHARE_READ or FILE_SHARE_WRITE, NULL, \ 
				CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, NULL
	mov hFile, eax	
	invoke WriteFile, hFile, pBuffer, szBuffer, addr SizeReadWrite, NULL
	invoke CloseHandle,hFile		
	ret
SaveToFile endp

MakeSound proc	   
    LOCAL whdr:WAVEHDR	
	LOCAL wfx: WAVEFORMATEX
	LOCAL hWO: DWORD 
	
	invoke RtlZeroMemory, addr whdr, sizeof WAVEHDR
	mov whdr.lpData, offset Buffer1
    mov whdr.dwBufferLength, SIZE_BUF
	    
	invoke RtlZeroMemory, addr wfx, sizeof WAVEFORMATEX
    mov wfx.wFormatTag, WAVE_FORMAT_PCM
    mov wfx.nChannels, 1
    mov wfx.nSamplesPerSec, 44100
    mov wfx.nAvgBytesPerSec, 4*44100
    mov wfx.nBlockAlign, 4
    mov wfx.wBitsPerSample, 16
    mov wfx.cbSize, sizeof WAVEFORMATEX
     
	invoke waveOutOpen, addr hWO, WAVE_MAPPER, addr wfx, 0, 0, CALLBACK_NULL
	.if eax == MMSYSERR_NOERROR	         
        invoke MessageBox, NULL, addr MGo, addr MBCaption, MB_OK				
    .else
        invoke MessageBox, NULL, addr MFail, addr MBCaption, MB_OK
	.endif 
    invoke waveOutPrepareHeader, hWO, addr whdr, sizeof WAVEHDR
    invoke waveOutWrite, hWO, addr whdr, sizeof WAVEHDR  
    invoke MessageBox, NULL, addr MGo, addr MBCaption, MB_OK 
    invoke waveOutUnprepareHeader, hWO, addr whdr, sizeof WAVEHDR
    invoke waveOutReset, hWO
    invoke waveOutClose, hWO

	ret
MakeSound endp

end start
