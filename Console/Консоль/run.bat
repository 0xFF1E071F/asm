c:\masm32\bin\ml.exe /c /coff /Cp c.asm
c:\masm32\bin\ml.exe /c /coff /Cp w.asm
c:\masm32\bin\link.exe /SUBSYSTEM:WINDOWS  /LIBPATH:c:\masm32\lib  w.obj c.obj
w.exe