del *.obj
del *.res
del *.exe

c:\masm32\bin\ml.exe /c /coff /Cp main.asm
c:\masm32\bin\rc.exe main.rc
c:\masm32\bin\link.exe /SUBSYSTEM:WINDOWS  /LIBPATH:c:\masm32\lib  main.obj main.res
main.exe