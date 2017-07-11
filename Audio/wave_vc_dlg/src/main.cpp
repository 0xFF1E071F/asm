#include <windows.h>
#include <mmsystem.h>
#include <Wincrypt.h>

#define IDD_MAIN 101
#define IDC_LST1 103


BOOL CALLBACK DlgProc(HWND,UINT,WPARAM,LPARAM);
void MakeSound();

int WINAPI WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, int nShowCmd)
{
	//HWND hWnd = GetDesktopWindow();	
	//MessageBox(hWnd, "123", "Hello", 0);
	DialogBox( hInstance, MAKEINTRESOURCE(IDD_MAIN), 0, DlgProc);	
	return 0;
}

BOOL CALLBACK DlgProc(HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam) 
{ 
    switch (message) 
    {
        case WM_COMMAND: 
        {
            switch(wParam)
			{
				case IDOK:
				{
					//HWND hList = GetDlgItem(hWnd,IDC_LST1);
					MakeSound();
					return FALSE;
				}
				case IDCANCEL: 
				{
					EndDialog(hWnd, NULL); 
					return TRUE;					
				}   
				default: return FALSE;
			}
        }
        default: return FALSE; 
    }	
}


void FillBuffer(byte* buffer, int size)
{
	for (int i=0; i<size; i++) // формируем звуковой массив случайных чисел (ШУМ)
    {
        buffer[i] = rand();
    }		
}


void MakeSound()
{
	WAVEHDR whdr; // структура для буфера звука
	WAVEFORMATEX wfx; // для получения описателя звукового устройства:
    HCRYPTPROV  hcp;
	const int SIZE = 88200; // количество байтов для сэмпла
	byte szBuffer[SIZE]; // сколько байт на сэмпл потребовалось (88200 для 1 секунды звучания)
	char szText[80];
    	
		/*
	CryptAcquireContext(&hcp,0,0, PROV_RSA_FULL,0);
	CryptGenRandom(hcp, SIZE, szBuffer);
	CryptReleaseContext(hcp,0);
	*/
	   
    ZeroMemory(&whdr, sizeof(whdr));
    whdr.lpData = (char*)szBuffer; // указатель звукового буфера (тип char *).
    whdr.dwBufferLength = SIZE; // размер буфера в байтах.
    
    
    ZeroMemory(&wfx, sizeof(wfx));
    wfx.wFormatTag = WAVE_FORMAT_PCM;   // wav-формат
    wfx.nChannels = 1; // моно - звук
    wfx.nSamplesPerSec = 44100; // 44100 Гц
    wfx.nAvgBytesPerSec = 4*44100;
    wfx.nBlockAlign = 4;
    wfx.wBitsPerSample = 16; // 16-битный звук
    wfx.cbSize = sizeof(wfx);
 
    HWAVEOUT hWO; // handle identifying the open waveform-audio output device
    if(waveOutOpen(&hWO, WAVE_MAPPER, &wfx, 0, 0, CALLBACK_NULL) == MMSYSERR_NOERROR)
    {
        wsprintfA(szText, "waveOutOpen() СРАБОТАЛА УСПЕШНО! hWO = 0%X", hWO);
        MessageBoxA(NULL, szText, "GOOD INFO", MB_OK);
    }
    else
        MessageBoxA(NULL, "waveOutOpen() НЕ СРАБОТАЛА!","ERROR", MB_OK);
 
    waveOutPrepareHeader(hWO, &whdr, sizeof(whdr));
    waveOutWrite(hWO, &whdr, sizeof(whdr));
 
    // вообще-то MessageBox в данном случае, чтобы успеть насладиться звуком.
 
    UINT X;
    X = auxGetNumDevs(); // A return value of zero means that no devices are present or that an error occurred.
    wsprintfA(szText, "Количество аудиоустройств = %d", X);
    MessageBoxA(NULL, szText, "Значение переменной X", MB_OK);
 
    waveOutUnprepareHeader(hWO, &whdr, sizeof(whdr));
    waveOutReset(hWO);
    waveOutClose(hWO);
 
}