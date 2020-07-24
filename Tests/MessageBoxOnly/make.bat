del *.exe
del *.obj
del *.res
del *.i64

c:\masm32\bin\ml.exe /c /coff /Cp main.asm
c:\masm32\bin\link.exe /SUBSYSTEM:WINDOWS  /LIBPATH:c:\masm32\lib  main.obj
main.exe