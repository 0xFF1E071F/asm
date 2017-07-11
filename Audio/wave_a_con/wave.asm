.686P				
.model flat,stdcall 
option casemap:none

include c:\masm32\include\windows.inc
include c:\masm32\include\user32.inc
include c:\masm32\include\kernel32.inc
include c:\masm32\include\masm32.inc
include c:\masm32\include\winmm.inc
include	c:\masm32\include\advapi32.inc

includelib c:\masm32\lib\user32.lib
includelib c:\masm32\lib\kernel32.lib
includelib c:\masm32\lib\masm32.lib
includelib c:\masm32\lib\winmm.lib
includelib	c:\masm32\lib\advapi32.lib

MakeSound PROTO

.const

	conTitle 	db "Console", 0
	HSTDIN		dd -10
	HSTDOUT		dd -11
	IDD_MAIN	equ		101
	SIZE_BUF	equ		88200

.data

	mbuf		db 255 dup(" "), 0
	mbufl		dd 256
	rbuf		db ?
	rbufl		dd 1
	wbuf		db "Hello, world!", 0
	wbufl		dd $-wbuf	
	c_read		dd 0
	c_write		dd 0
	
	MBCaption  db "Sound",0
	MStart  db "Start",0
	MFinish  db "Finish",0
	MGo db "Go",0
	MFail  db "Fail",0
	szBuffer db SIZE_BUF dup (0)

.data?

	hInstance 	dd ?
	CommandLine dd ?
	stdin		dd ?
	stdout		dd ?
	
.code
start:
	invoke GetModuleHandle, NULL
	mov	hInstance,eax
	invoke GetCommandLine
	mov	CommandLine,eax
	invoke GetStdHandle, HSTDOUT
  	mov stdout, eax 	
  	
	invoke MakeSound		
	
	invoke Sleep,2000   	  
  	invoke ExitProcess, 0

MakeSound proc	   
    LOCAL whdr:WAVEHDR	
	LOCAL wfx: WAVEFORMATEX
	LOCAL hWO: DWORD 
	LOCAL hProv: DWORD
	
	invoke CryptAcquireContext, addr hProv,0,0, PROV_RSA_FULL,0
	invoke CryptGenRandom, hProv, SIZE_BUF, addr szBuffer
	invoke CryptReleaseContext, hProv,0
		
	invoke RtlZeroMemory, addr whdr, sizeof WAVEHDR
	mov whdr.lpData, offset szBuffer
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