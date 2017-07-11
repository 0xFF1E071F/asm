  ; -----------------------------------------------------------
  ; Выделяет память для динамических объектов
  ; -----------------------------------------------------------

alloc_mem Macro 
.data?
	hObjects_Heap dd ?
.code
	invoke HeapCreate, 0, 1024, 0
	mov hObjects_Heap,eax
endm  

  ; -----------------------------------------------------------
  ; Уничтожает память динамических объектов
  ; -----------------------------------------------------------
  
destroy_mem Macro 
	invoke HeapDestroy, hObjects_Heap
endm  

  ; -----------------------------------------------------------
  ; Создает новый динамический объект:
  ; выделяет память из кучи,
  ; если определен конструктор, то вызывает его 
  ; (конструктор может быть с параметрами,
  ; адрес объекта передается через первый аргумент,
  ; конструктор должен вернуть адрес объекта в eax)
  ; -----------------------------------------------------------

new_object Macro Object_Type,p:VARARG
	LOCAL Constr
	LOCAL txt, arg
	invoke HeapAlloc, hObjects_Heap, HEAP_ZERO_MEMORY, TYPE(Object_Type)
	Constr EQU @CatStr (Object_Type, <_constructor>)
	IFDEF Constr
		IFNB <p>
			txt TEXTEQU <>	; собираем аргументы в строку в обратном порядке
			FOR arg, <p>	
				txt CATSTR <arg>, <!,>, txt
			ENDM
			txt SUBSTR  txt, 1, @SizeStr( %txt ) - 1	; удаляем последнюю зпятую
			txt CATSTR  <!<>, txt, <!>>		; добавляем кавычки
			% FOR arg, txt	; складываем аргументы в стек
				push arg
			ENDM
		ENDIF
		push eax
		call Constr
	ENDIF
	exitm <eax>
endm

  ; -----------------------------------------------------------
  ; Удаляет динамический объект из памяти,
  ; вызывает деструктор, если есть
  ; -----------------------------------------------------------

delete_object Macro adrObj, Object_Type 
	LOCAL Destr
	Destr EQU @CatStr (Object_Type, <_destructor>)
	IFDEF Destr
		push adrObj
		call Destr
	ENDIF
	invoke HeapFree, hObjects_Heap, 0, adrObj
endm

  ; -----------------------------------------------------------
  ; Вызывает метод объекта: 
  ; адрес объекта передается через первый аргумент,
  ; порядок вызова:  method адрес_объекта, тип.метод, аргументы
  ; -----------------------------------------------------------
  
method Macro obj,f,p:VARARG
    LOCAL typ, met, adr 
    LOCAL poz
    LOCAL txt, arg
	%poz INSTR 1,<f>,<.>
    typ SUBSTR <f>, 1, poz-1
	met SUBSTR <f>, poz+1
	adr CATSTR <(>, typ, < PTR [esi]).>, met
	IFNB <p>
		txt TEXTEQU <>	; собираем аргументы в строку в обратном порядке
		FOR arg, <p>	
			txt CATSTR <arg>, <!,>, txt
		ENDM
		txt SUBSTR  txt, 1, @SizeStr( %txt ) - 1	; удаляем последнюю зпятую
		txt CATSTR  <!<>, txt, <!>>		; добавляем кавычки
		% FOR arg, txt	; складываем аргументы в стек
			push arg
		ENDM
	ENDIF
    push obj
	call adr
endm
