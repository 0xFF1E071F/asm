rm -f *.o list.exe
g++ -c devicelist.cpp
g++  devicelist.o  c:\MinGW\lib\libwinmm.a -o list.exe 
list