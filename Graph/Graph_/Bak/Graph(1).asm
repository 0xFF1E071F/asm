.686P
.model flat,stdcall 
option casemap:none

include Graph.inc

.code
start:
	invoke GetModuleHandle, NULL
	mov  hInstance,eax
	invoke GetCommandLine
	mov  CommandLine,eax
	invoke WinMain, hInstance, NULL, CommandLine, SW_SHOWDEFAULT
	invoke ExitProcess, eax
WinMain proc hInst:HINSTANCE, hPrevInst:HINSTANCE, CmdLine:LPSTR, CmdShow:DWORD	
	LOCAL msg:MSG	
	invoke RegWndClass
	.IF (!eax)
		invoke MessageBox, NULL, addr EMClassNotReg, addr MBCaptionErr, MB_OK
		ret
	.ENDIF	
	invoke LoadMenu, hInstance, IDR_MENU
	mov   hMenu, eax
	invoke CreateWindowEx, NULL, addr ClassName, addr AppName, WS_OVERLAPPEDWINDOW, 
		   CW_USEDEFAULT, CW_USEDEFAULT, CW_USEDEFAULT, CW_USEDEFAULT, NULL, hMenu, hInstance, NULL
	.IF (!eax)
		invoke MessageBox, NULL, addr EMWinNotCreate, addr MBCaptionErr, MB_OK
		ret
	.ENDIF
	mov  hWin, eax
	invoke ShowWindow, hWin, SW_SHOWNORMAL
	invoke UpdateWindow, hWin	
	.WHILE TRUE
		invoke GetMessage, addr msg, NULL, 0, 0
		.BREAK .IF (!eax)
		invoke TranslateMessage, addr msg
		invoke DispatchMessage, addr msg
	.ENDW
	mov  eax, msg.wParam
	ret
WinMain endp
RegWndClass proc 
	LOCAL wc:WNDCLASSEX	
	mov  wc.cbSize, sizeof WNDCLASSEX
	mov  wc.style, CS_HREDRAW or CS_VREDRAW	
	mov  wc.lpfnWndProc, offset WndProc
	mov  wc.cbClsExtra, NULL
	mov  wc.cbWndExtra, NULL
	push hInstance
    pop  wc.hInstance	
	invoke LoadIcon, NULL, IDI_APPLICATION
	mov  wc.hIcon, eax
	mov  wc.hIconSm, eax
	invoke LoadCursor, NULL, IDC_ARROW
	mov  wc.hCursor, eax	
	mov  wc.hbrBackground, COLOR_WINDOW+1
	mov  wc.lpszMenuName, NULL	
	mov  wc.lpszClassName, offset ClassName 		
	invoke RegisterClassEx, addr wc	
	ret
RegWndClass endp
WndProc proc hWnd:HWND,uMsg:UINT,wParam:WPARAM,lParam:LPARAM
	mov		eax,uMsg
	.if eax==WM_CREATE
		invoke InitGL
		invoke InitScene
	.elseif eax==WM_COMMAND
		mov		eax,wParam
		and		eax,0FFFFh
		.if eax==IDM_EXIT
			invoke SendMessage,hWnd,WM_CLOSE,NULL,NULL
		.elseif eax==IDM_HELP
			invoke MessageBox, NULL, addr MSAbout, addr MBCaptionAbt, MB_OK
		.endif
	.elseif eax==WM_CLOSE 
		invoke DestroyWindow,hWnd
	.elseif eax==WM_DESTROY
		invoke PostQuitMessage,NULL
	.else
		invoke DefWindowProc,hWnd,uMsg,wParam,lParam
		ret
	.endif
	xor    eax,eax
	ret
WndProc endp
InitGL proc	
	LOCAL iPF : DWORD	
	invoke 	GetDC,hWin
	.if (!eax)		
		ret
	.endif	
	mov	hDC,eax
	mov ebx, size PIXELFORMATDESCRIPTOR
	mov ecx, ebx
	xor ax,ax
	mov edi, offset pfd
    rep stosb     
    mov	ax, size PIXELFORMATDESCRIPTOR
	mov	pfd.nSize, ax
	mov	pfd.nVersion, 1
	mov	pfd.dwFlags, PFD_DRAW_TO_WINDOW or PFD_SUPPORT_OPENGL or PFD_DOUBLEBUFFER
	mov	pfd.dwLayerMask, PFD_MAIN_PLANE
	mov	pfd.iPixelType, PFD_TYPE_RGBA
	mov	pfd.cColorBits, 32
	mov	pfd.cDepthBits, 32
	mov	pfd.cRedBits, 8
    mov	pfd.cRedShift, 16
    mov	pfd.cGreenBits, 8
    mov	pfd.cGreenShift, 8
    mov	pfd.cBlueBits, 8
    mov	pfd.cAccumBits, 64    
    mov	pfd.cAccumRedBits, 16
    mov	pfd.cAccumGreenBits, 16
    mov	pfd.cAccumBlueBits, 16    
    mov	pfd.cStencilBits, 8 
    invoke	ChoosePixelFormat,hDC,addr pfd    
    mov	iPF,eax
    .if (!eax)		
		mov	iPF,1
		invoke 	DescribePixelFormat, hDC, iPF, size PIXELFORMATDESCRIPTOR, addr pfd
		.if (!eax)						
			ret
		.endif
	.endif		
	invoke	SetPixelFormat, hDC, iPF, addr pfd
	.if (!eax)
		ret
	.endif	
	invoke	wglCreateContext,hDC
	.if (!eax)
		ret
	.endif 
	mov	hRC,eax	
	invoke	wglMakeCurrent,hDC,hRC 
	ret
InitGL endp
FinalGL proc
	.if (hRC)
		invoke wglMakeCurrent, 0, 0
		invoke wglDeleteContext, hRC
		mov hRC, 0
	.endif
	.if (hDC)
		invoke ReleaseDC, hWin, hDC
		mov hDC, 0
	.endif
FinalGL endp
InitScene proc	
	invoke glShadeModel, GL_SMOOTH	
	invoke glClearColor, _1d0, _0d7, _1d0, _0d5	
	push __1d0
	push __1d1
	call glClearDepth
	invoke glEnable, GL_DEPTH_TEST
	invoke glDepthFunc, GL_LEQUAL
	invoke glHint, GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST
	mov eax, 1
	ret
InitScene endp
DrawScene proc
	push L (GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT)
	call glClear
	call glLoadIdentity
	_glTranslatef _m15,0,_m6
	_glBegin GL_TRIANGLES
	_glVertex3f   0, _1, 0
	_glVertex3f _m1,_m1, 0
	_glVertex3f  _1,_m1, 0
	call glEnd
	_glTranslatef _3,0, 0
	_glBegin GL_QUADS
	_glVertex3f _m1, _1, 0
	_glVertex3f  _1, _1, 0
   	_glVertex3f  _1,_m1, 0
	_glVertex3f _m1,_m1, 0
	call glEnd
	xor eax,eax
	ret 
DrawScene endp

end start