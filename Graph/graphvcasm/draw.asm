
.586P
.MODEL FLAT, C

include c:\masm32\include\opengl32.inc
includelib c:\masm32\lib\opengl32.lib

PUBLIC DRAWQUAD

_TEXT SEGMENT

DRAWQUAD PROC
	push ebp
	mov	ebp,esp	
	push 00000009h
	call glBegin
	push 0
	push 0
	call glVertex2f
	push 3F000000h
	push 0
	call glVertex2f
	push 3F000000h
	push 3F800000h
	call glVertex2f
	push 0
	push 3F800000h
	call glVertex2f
	call glEnd	
	leave
	ret
DRAWQUAD ENDP

_TEXT ENDS
END