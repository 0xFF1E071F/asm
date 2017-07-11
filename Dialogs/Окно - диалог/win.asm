.386
.model flat, stdcall
option casemap :none

include \masm32\include\windows.inc
include \masm32\macros\macros.asm
uselib kernel32, user32, masm32, comctl32

WndProc PROTO :DWORD,:DWORD,:DWORD,:DWORD

TEST_DIALOG = 1000
TEST_BTN = 1001
EXIT_BTN = 1002

.data?
  hInstance dd ?
  hWnd dd ?
  icce INITCOMMONCONTROLSEX <>

.code
  start:
    mov icce.dwSize, SIZEOF INITCOMMONCONTROLSEX
    mov icce.dwICC, ICC_DATE_CLASSES or \
                    ICC_INTERNET_CLASSES or \
                    ICC_PAGESCROLLER_CLASS or \
                    ICC_COOL_CLASSES

    invoke InitCommonControlsEx, offset icce

    invoke GetModuleHandle, NULL
    mov hInstance, eax

    invoke DialogBoxParam, hInstance, TEST_DIALOG, 0, offset WndProc, 0

    invoke ExitProcess,eax

WndProc proc hWin :DWORD, uMsg :DWORD, wParam :DWORD, lParam :DWORD
  switch uMsg
    case WM_INITDIALOG
      invoke SendMessage, hWin, WM_SETICON, 1, FUNC(LoadIcon, NULL, IDI_ASTERISK)

    case WM_COMMAND
      switch wParam
        case TEST_BTN
          invoke MessageBox, hWin, chr$("Hello, world!"), chr$("Test"), 0
        case EXIT_BTN
          jmp exit_program
      endsw
    case WM_CLOSE
      exit_program:
      invoke EndDialog, hWin, 0

    endsw

  xor eax,eax
ret
WndProc ENDP

end start