del bin\main.*

set "vc_path=c:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\"
rem set "vc_path=c:\Program Files\Microsoft Visual Studio\VC98\"
set "vcsdk_path=c:\Program Files (x86)\Microsoft SDKs\Windows\v7.0A\"

set "bin=bin\"
set "src=src\"
set "progname=main"

"%vcsdk_path%bin\rc.exe" /l 0x419 /fo"%bin%%progname%.res" /d "_DEBUG" %src%%progname%.rc

"%vc_path%bin\cl.exe" /nologo /W3 /O2 /D "WIN32" /D "_WINDOWS" /Fo"%bin%%progname%.obj" /Fd"%bin%%progname%.pdb" /FD /c %src%%progname%.cpp

"%vc_path%bin\link.exe" /nologo /subsystem:windows /machine:X86 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib winmm.lib Advapi32.lib /out:"%bin%%progname%.exe" /pdb:"%bin%%progname%.pdb" %bin%%progname%.obj "%bin%%progname%.res"

call "%bin%%progname%.exe"

rem pause
