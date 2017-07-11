del bin\*.obj
del bin\*.exe

set "vc_path=c:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\"
rem set "vc_path=c:\Program Files\Microsoft Visual Studio\VC98\"
rem set "vcsdk_path=c:\Program Files (x86)\Microsoft SDKs\Windows\v7.0A\"

set "bin=bin\"
set "src=src\"
set "progname=main"

"%vc_path%bin\cvtres.exe" /l 0x419 /fo"%bin%%progname%.res" /d "_DEBUG" %src%%progname%.rc

"%vc_path%bin\cl.exe" /nologo /W3 /Gm /ZI /Od /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /D "_MBCS" /Fp"%bin%%progname%.pch" /Fo"%bin%%progname%.obj" /Fd"%bin%%progname%.pdb" /FD /c %src%%progname%.cpp

"%vc_path%bin\link.exe" /INCREMENTAL:NO /OUT:"%bin%%progname%.exe" kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib winmm.lib /nologo /subsystem:windows /pdb:"%bin%%progname%.pdb" /debug /machine:I386 %bin%%progname%.obj "%bin%%progname%.res"

call "%bin%%progname%.exe"

rem pause
