c:\masm32\bin\ml.exe /c /coff /Cp win.asm
c:\masm32\bin\rc.exe win.rc
c:\masm32\bin\link.exe /SUBSYSTEM:WINDOWS  /LIBPATH:c:\masm32\lib  win.obj win.res
win.exe