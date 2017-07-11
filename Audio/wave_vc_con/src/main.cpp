// ПРОГРАММА ТЕСТИРОВАНИЯ Waveform-Audio ФУНКЦИЙ
#include <windows.h>
#include <mmsystem.h>
//#include <windowsx.h>
int WINAPI WinMain(HINSTANCE hInstance, HINSTANCE, LPSTR, int)
{
    char szText[80];
    const int SIZE = 88200; // количество байтов для сэмпла
 
    WAVEHDR whdr; // структура для буфера звука
    char szBuffer[SIZE]; // сколько байт на сэмпл потребовалось (88200 для 1 секунды звучания)
    for (UINT i=0; i<SIZE; i++) // формируем звуковой массив случайных чисел (ШУМ)
    {
        szBuffer[i] = rand();
    }
    ZeroMemory(&whdr, sizeof(whdr));
    whdr.lpData = szBuffer; // указатель звукового буфера (тип char *).
    whdr.dwBufferLength = SIZE; // размер буфера в байтах.
    
    WAVEFORMATEX wfx; // для получения описателя звукового устройства:
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
        wsprintf(szText, "waveOutOpen() СРАБОТАЛА УСПЕШНО! hWO = 0%X", hWO);
        MessageBox(NULL, szText, "GOOD INFO", MB_OK);
    }
    else
        MessageBox(NULL, "waveOutOpen() НЕ СРАБОТАЛА!", "ERROR", MB_OK);
 
    waveOutPrepareHeader(hWO, &whdr, sizeof(whdr));
    waveOutWrite(hWO, &whdr, sizeof(whdr));
 
    // вообще-то MessageBox в данном случае, чтобы успеть насладиться звуком.
 
    UINT X;
    X = auxGetNumDevs(); // A return value of zero means that no devices are present or that an error occurred.
    wsprintf(szText, "Количество аудиоустройств = %d", X);
    MessageBox(NULL, szText, "Значение переменной X", MB_OK);
 
    waveOutUnprepareHeader(hWO, &whdr, sizeof(whdr));
    waveOutReset(hWO);
    waveOutClose(hWO);
 
    return 0;
}