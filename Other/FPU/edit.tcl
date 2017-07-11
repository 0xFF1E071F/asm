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
		invoke CreateWindowEx, 0, OFFSET CLSED, OFFSET TLB_$name, STYLED, $left, $top, $width, $heigth, hWnd, 0, hInstance, 0
		   mov HLB_$name, EAX"
}


label Other 120 10 100 20 "Проба"
button Cancel 120 50 100 20 "Нажать"
edit Get 120 90 100 20 "12345" 

exec run.bat




