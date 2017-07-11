
include windows.inc
include user32.inc
include kernel32.inc
include gdi32.inc
include opengl32.inc
include glu32.inc
include glaux.inc
includelib user32.lib
includelib kernel32.lib
includelib gdi32.lib
includelib opengl32.lib
includelib glu32.lib
includelib glaux.lib

WinMain proto :HINSTANCE,:HINSTANCE,:LPSTR,:DWORD
RegWndClass proto
WndProc proto :HWND,:UINT,:WPARAM,:LPARAM
InitGL proto
FinalGL proto
InitScene proto
DrawScene proto  

.const
IDR_MENU equ 10000
IDM_FILE equ 10001
IDM_EDIT equ 10002
IDM_HELP equ 10003
IDM_OPEN equ 10004
IDM_CLOSE equ 10005
IDM_EXIT equ 10006

.data									
ClassName db "WinClass",0
AppName  db "Window",0
MenuName  db "IDR_MENU",0
MBCaptionErr  db "Error",0
MBCaptionAbt  db "About",0
EMClassNotReg  db "Window class not registered!",0
EMWinNotCreate  db "Window not created!",0
EMDCNotGet  db "Device context not get!",0
MSAbout  db "Window with menu.",0

_1d0 dd 1.0
_0d7 dd 0.7
_0d5 dd 0.5
__1d0	equ 1072693248
__1d1	equ 0 		;1.0


.data?
hInstance dd ?
CommandLine dd ?
hMenu HMENU ?
hDC dd ?
hRC dd ?
hWin HWND ?
pfd PIXELFORMATDESCRIPTOR <>