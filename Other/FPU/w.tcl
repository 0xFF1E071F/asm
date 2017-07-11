set app_name "Программа"
set app_width 300
set app_heigth 300

set elem_source " "
set elem_create " "
set elem_calls " "
set elem_events " "
set static_sourses " "
set proc_defenition " "
set proc_release " "

proc window {name width heigth} {
	set app_name $name
	set app_width $width
	set app_heigth $heigth
}

proc button {name left top width heigth caption} {

upvar elem_source source
upvar elem_create create
upvar elem_calls calls
upvar elem_events events

set source "$source 
	TBT_$name	DB '$caption'
	HBT_$name	DD 0"

set create "$create 
		invoke CreateWindowEx, 0, OFFSET CLSBT, OFFSET TBT_$name, STYLBT, $left, $top, $width, $heigth, hWnd, 0, hInstance, 0
		   mov HBT_$name, EAX"
	
set calls "$calls 
		   mov EAX, HBT_$name 
           cmp lParam, EAX
            je BT_CLICK_$name"
			
set events "$events   
BT_CLICK_$name:
	   	
	   jmp END_MESS"
}

proc edit {name left top width heigth text} {

upvar elem_source source
upvar elem_create create

set source "$source
	TED_$name	DB '$text'
	HED_$name	DD 0"
	
set create "$create
		invoke CreateWindowEx, 0, OFFSET CLSED, OFFSET TED_$name, STYLED, $left, $top, $width, $heigth, hWnd, 0, hInstance, 0
		   mov HED_$name, EAX"
}

proc label {name left top width heigth text} {

upvar elem_source source
upvar elem_create create

set source "$source
	TLB_$name	DB '$text'
	HLB_$name	DD 0"

set create "$create
		invoke CreateWindowEx, 0, OFFSET CLSLB, OFFSET TLB_$name, STYLLB, $left, $top, $width, $heigth, hWnd, 0, hInstance, 0
		   mov HLB_$name, EAX"
}


label Other 	20 10 110 20 " Введите число"
edit Ed1 		130 10 240 20 " "
button Cancel 	380 10 30 20 "ОК"

edit Ed2 		20 40 240 20 " "
label Other1 	270 40 30 20 " *10"
edit Ed3 		310 40 60 20 " "

edit Ed4 		20 70 520 20 " "
label Other2 	550 70 20 20 " *2"
edit Ed5 		580 70 130 20 " "

edit Ed6 		20 100 520 20 " "
label Other3 	550 100 20 20 " *2"
edit Ed7 		580 100 130 20 " "

set of 140
label Other4 	20 $of 45 20 " +"
edit Ed8 		35 $of 70 20 "01111111"
label Other5 	110 $of 45 20 " (+127)"
edit Ed9 		20 [expr "$of + 30"] 15 20 "1"
edit Ed10		35 [expr "$of + 30"] 70 20 "23412341"
edit Ed11		105 [expr "$of + 30"] 190 20 "23412341234123412341234"
label Other6 	41 [expr "$of + 50"] 8 20 "8"
label Other7 	74 [expr "$of + 50"] 8 20 "8"
label Other8 	111 [expr "$of + 50"] 8 20 "8"
label Other9 	143 [expr "$of + 50"] 8 20 "8"
label Other10 	175 [expr "$of + 50"] 8 20 "8"
label Other11 	207 [expr "$of + 50"] 8 20 "8"
label Other12 	239 [expr "$of + 50"] 8 20 "8"
label Other13 	271 [expr "$of + 50"] 8 20 "8"
edit Ed12 	225 $of 70 20 "88888888"

set of 230
label Other14 	20 $of 45 20 " +"
edit Ed13 		35 $of 93 20 "01111111111"
label Other15 	128 $of 60 20 " (+1023)"
edit Ed14 		20 [expr "$of + 30"] 15 20 "1"
edit Ed15		35 [expr "$of + 30"] 93 20 "23412341234"
edit Ed16		128 [expr "$of + 30"] 420 20 "1234123412341234123412341234123412341234123412341234"
label Other16 	41 [expr "$of + 50"] 8 20 "8"
label Other17 	74 [expr "$of + 50"] 8 20 "8"
label Other18 	106 [expr "$of + 50"] 8 20 "8"
label Other19 	143 [expr "$of + 50"] 8 20 "8"
label Other20 	175 [expr "$of + 50"] 8 20 "8"
label Other21 	207 [expr "$of + 50"] 8 20 "8"
label Other22 	239 [expr "$of + 50"] 8 20 "8"
label Other23 	271 [expr "$of + 50"] 8 20 "8"
label Other24 	303 [expr "$of + 50"] 8 20 "8"
label Other25 	335 [expr "$of + 50"] 8 20 "8"
label Other26 	367 [expr "$of + 50"] 8 20 "8"
label Other27 	399 [expr "$of + 50"] 8 20 "8"
label Other28 	431 [expr "$of + 50"] 8 20 "8"
label Other29 	463 [expr "$of + 50"] 8 20 "8"
label Other30 	495 [expr "$of + 50"] 8 20 "8"
label Other31 	527 [expr "$of + 50"] 8 20 "8"
edit Ed17 	413 $of 135 20 "8888888888888888"

set of 320
label Other32 	20 $of 45 20 " +"
edit Ed18 		35 $of 125 20 "011111111111111"
label Other33 	162 $of 67 20 " (+16383)"
edit Ed19 		20 [expr "$of + 30"] 15 20 "1"
edit Ed20		35 [expr "$of + 30"] 125 20 "234123412341234"
edit Ed21		160 [expr "$of + 30"] 518 20 "1234123412341234123412341234123412341234123412341234123412341234"
label Other34 	41 [expr "$of + 50"] 8 20 "8"
label Other35 	74 [expr "$of + 50"] 8 20 "8"
label Other36 	106 [expr "$of + 50"] 8 20 "8"
label Other37 	138 [expr "$of + 50"] 8 20 "8"
label Other38 	175 [expr "$of + 50"] 8 20 "8"
label Other39 	207 [expr "$of + 50"] 8 20 "8"
label Other40 	239 [expr "$of + 50"] 8 20 "8"
label Other41 	271 [expr "$of + 50"] 8 20 "8"
label Other42 	303 [expr "$of + 50"] 8 20 "8"
label Other43 	335 [expr "$of + 50"] 8 20 "8"
label Other44 	367 [expr "$of + 50"] 8 20 "8"
label Other45 	399 [expr "$of + 50"] 8 20 "8"
label Other46 	431 [expr "$of + 50"] 8 20 "8"
label Other47 	463 [expr "$of + 50"] 8 20 "8"
label Other48 	495 [expr "$of + 50"] 8 20 "8"
label Other49 	527 [expr "$of + 50"] 8 20 "8"
label Other50 	559 [expr "$of + 50"] 8 20 "8"
label Other51 	591 [expr "$of + 50"] 8 20 "8"
label Other52 	623 [expr "$of + 50"] 8 20 "8"
label Other53 	655 [expr "$of + 50"] 8 20 "8"
edit Ed22 	513 $of 165 20 "88888888888888888888"



set fileid [open "w.asm" w+]

# директивы
puts $fileid \
".386				
.model flat,stdcall 
option casemap:none"

# инклуды
puts $fileid "
include c:\\masm32\\include\\windows.inc
include c:\\masm32\\include\\user32.inc
include c:\\masm32\\include\\kernel32.inc
includelib c:\\masm32\\lib\\user32.lib
includelib c:\\masm32\\lib\\kernel32.lib"

# <<<<< стилистические константы
puts $fileid "
STYLBT equ WS_CHILD+BS_DEFPUSHBUTTON+WS_VISIBLE
STYLED equ WS_CHILD+WS_VISIBLE+WS_BORDER+WS_TABSTOP
STYLLB equ WS_CHILD+WS_VISIBLE"

# прототипы функций
puts $fileid "
WinMain proto :DWORD,:DWORD,:DWORD,:DWORD"

# ------------ статические переменные ------------
puts $fileid "
.data"

# <<<<<<  классы элементов управления
puts $fileid "
	ClassName	DB 'WinClass',0
	CLSBT 		DB 'BUTTON',0
	CLSED		DB 'EDIT',0
	CLSLB		DB 'STATIC',0"
	
# <<<<<<  ресурсы элементов управления
puts $fileid "
	AppName  	DB 'Программа',0

	uType           EQU 0
	lpMessCaption   DB 'Сообщение',0
	lpMess          DB 'Результат:', 6 dup(' '),0"

puts $fileid "$elem_source"


# ---- динамические переменные ---- 
puts $fileid "
.data?
	hInstance 		DD ?
	CommandLine 	DD ?"
# []

# стартовый код
puts $fileid "
.code
start:
	invoke GetModuleHandle, NULL
	mov    hInstance,eax
	invoke GetCommandLine
	mov    CommandLine,eax
	invoke WinMain, hInstance, NULL, CommandLine, SW_SHOWDEFAULT
	invoke ExitProcess, eax"

# функция WinMain
puts $fileid "
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
	INVOKE CreateWindowEx,NULL,ADDR ClassName,ADDR AppName,\
           WS_OVERLAPPEDWINDOW,CW_USEDEFAULT,\
           CW_USEDEFAULT,730,450,NULL,NULL,\
           hInst,NULL
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
WinMain endp"

# процедура окна
puts $fileid "
WndProc proc hWnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM
	
	.if uMsg==WM_DESTROY
		
		invoke PostQuitMessage, NULL

	.elseif uMsg==WM_CREATE
		$elem_create	
	
	.elseif uMsg==WM_COMMAND
		$elem_calls
		
	.else
		
		invoke DefWindowProc, hWnd, uMsg, wParam, lParam		
		ret
		
	.endif
	jmp	END_MESS

$elem_events
	
END_MESS:
	   xor eax,eax
	   ret
WndProc endp"

# []

# конец программы
puts $fileid "
end start"

close $fileid