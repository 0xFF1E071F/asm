del *.exe
del *.obj
del *.res
del *.i64

rem c:\masm32\bin\rc.exe wave.rc
c:\masm32\bin\ml.exe /c /coff /Cp wave.asm
c:\masm32\bin\link.exe /SUBSYSTEM:WINDOWS  /LIBPATH:c:\masm32\lib  wave.obj 
wave.exe