del *.obj
del *.exe
ml /c /coff hello.asm
link /SUBSYSTEM:CONSOLE /LIBPATH:c:\masm32\lib hello.obj
hello.exe