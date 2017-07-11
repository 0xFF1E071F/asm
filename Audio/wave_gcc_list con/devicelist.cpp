#include <iostream>
#include <windows.h>
#include <mmsystem.h>

using namespace std;

int main() {
	
	cout <<"Out: "<<waveOutGetNumDevs() <<endl;
	cout <<"In: "<<waveInGetNumDevs() <<endl;	
	
	return 0;
	
}