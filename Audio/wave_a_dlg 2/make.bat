del *.exe
del *.obj
del *.res
del *.i64

c:\masm32\bin\ml.exe /c /coff /Cp wave6.asm
c:\masm32\bin\rc.exe wave6.rc
c:\masm32\bin\link.exe /SUBSYSTEM:WINDOWS  /LIBPATH:c:\masm32\lib  wave6.obj wave6.res
wave6.exe