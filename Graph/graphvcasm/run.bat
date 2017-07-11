set "vc_path=c:\Program Files\Microsoft Visual Studio\VC98\bin\"



"%vc_path%cl.exe" /nologo /MLd /W3 /Gm /GX /ZI /Od /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /D "_MBCS" /Fp"main.pch" /YX /Fo"main.obj" /Fd"main.pdb" /FD /GZ /c main.cpp

"%vc_path%link.exe" /OUT:"graph.exe" kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:windows /incremental:yes /pdb:"main.pdb" /debug /machine:I386 /pdbtype:sept main.obj draw.obj

call graph.exe"

pause
