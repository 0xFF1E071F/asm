	; Пример класса
TestClass STRUCT
      _a   dd  ?
      _b   dd  ?
      _c   dd  ?
	  Capt dd  ?
	  Mess dd  ?
      sum  dd  ?
	  setstr dd ?
	  showmes dd ?
TestClass ENDS

.code
	
	; Конструктор
TestClass_constructor proc obj:DWORD, adrMes: DWORD, adrCapt: DWORD
	mov esi, obj
	assume esi:ptr TestClass 
	mov [esi]._a, 1
	mov [esi]._b, 2
	mov [esi]._c, 0
	mov eax, adrMes
	mov [esi].Mess, eax
	mov eax, adrCapt
	mov [esi].Capt, eax
	mov [esi].sum, offset TestClass_aplusb
	mov [esi].setstr, offset TestClass_setstr
	mov [esi].showmes, offset TestClass_showmes	
	assume esi: nothing
	mov eax, obj
	ret
TestClass_constructor endp

	; деструктор
TestClass_destructor proc obj:DWORD
	mov esi, obj
	assume esi:ptr TestClass
	mov [esi]._a, 0
	mov [esi]._b, 0
	mov [esi]._c, 0
	mov [esi].sum, 0
	mov [esi].setstr, 0
	mov [esi].showmes, 0
	assume esi: nothing
	ret
TestClass_destructor endp

	; c = a + b
TestClass_aplusb proc obj:DWORD
	mov esi, obj
	assume esi:ptr TestClass
    mov eax, [esi]._a 
	add eax, [esi]._b 
    mov [esi]._c, eax
	assume esi: nothing
	ret
TestClass_aplusb endp

	; Устанавливает заголовок и текст сообщения
TestClass_setstr proc obj:DWORD, adrMes: DWORD, adrCapt: DWORD
	mov esi, obj
	assume esi:ptr TestClass
    mov eax, adrMes
	mov [esi].Mess, eax
	mov eax, adrCapt
	mov [esi].Capt, eax
	assume esi: nothing
	ret
TestClass_setstr endp

	; Выводит сообщение
TestClass_showmes proc obj:DWORD
	mov esi, obj
	assume esi:ptr TestClass
	invoke MessageBox, NULL, [esi].Mess, [esi].Capt, MB_OK
	assume esi: nothing
	ret
TestClass_showmes endp