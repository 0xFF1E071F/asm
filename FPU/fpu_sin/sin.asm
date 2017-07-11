.data
alpha dd 45.0;
sin dd ?;sin(45)=0,70710678118654752440084436210485
.code
     finit   ; инициализация
     fld alpha;st(0)=45.0   ;  загрузка из памяти в ST
    
	db 68h   ;push 3C8EFA35h   ???  объявление локальной переменной в стеке ???
    dd 0.017453292519943295769236907684886   ;pi/180  ???
    
	fmul dword ptr [esp]   ;st(0)=0,78539816339744830961566084581988  - умножение ST на содержимое вершины стека
    fsin  ; sin ST 
    pop eax  ; из вершины стека в eax
    fstp sin  ; перенос результата из ST в sin с освобождением
	
	// sin cos
	
	finit		; инициализация
    fld alpha  ;st(0)=45.0   ; загрузка аргумента в ST
    push 3C8EFA35h  ;pi/180    ; грузим коэффициент для перевода в радианы в вершину стека 
    fmul dword ptr [esp]   ;st(0)=0,78539816339744830961566084581988  - умножаем ST на коэффициент
    fsincos  ;  вычисляем одновременно синус и косинус
    pop eax  ;  выталкиваем вершину стека - наверное для восстановления стека в исходное положение
    fxch st(1)  ; обмениваем ST0 и ST1
    fstp sin  ; извлекаем результат из ST
	
	st <- t
loop:
	st1 <- t+dt ( t+dt*w)
	st * w
	st sin
	st -> buf[i]
	inc i
	jmp loop
	
	; передвигаем указатель 2 раза
	;fincstp    
	;fincstp
		
	fcomi st(0), st(1)	
	fcomip st(0), st(1)	
	jl label
	fsub st(0), st(4)  ; отнимаем 2pi
label
	
FillBufferSinus proc pBuffer:DWORD, bufSize:DWORD
	LOCAL res : DWORD 		
	finit		
	fld1										
	fild dword ptr bufSize							; получили dt			
	fdiv
	fld _2pi 										
	fmul freq    							; получили w=2*Pi*freq
	fmul										; получить w*dt		
	mov ebx, pBuffer 				; подготовка цикла
	xor esi, esi
	fld startt											
	fld st	
loop_sin:	
	fsin
	fmul ampl	
	fistp dword ptr res
	mov eax, res
	mov byte ptr [ebx+esi], al				; выгрузка в массив
	fadd st, st(1)	
	fld st	
	inc esi										; переход на следующий шаг
	cmp esi, bufSize
	jl loop_sin	
	fstp startt								; сохранение времени, до которого расчитали	
	ret
FillBufferSinus endp
	
	