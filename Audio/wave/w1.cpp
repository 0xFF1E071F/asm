// ПРОГРАММА ТЕСТИРОВАНИЯ Waveform-Audio ФУНКЦИЙ
#include <windows.h>
#include <mmsystem.h>
//#include <windowsx.h>
int WINAPI WinMain(HINSTANCE hInstance, HINSTANCE, LPSTR, int)
{
    char szText[80];
 
    WAVEHDR whdr; // буфер для звука
    char szBuffer[88200]; // столько байт на 1 секундный сэмпл потребовалось
    for (UINT i=0; i<88200; i++) // формируем звуковой массив
    {
                     szBuffer = rand(); // генерируем случайные числа для шума
    }
    whdr.lpData = szBuffer; // указатель звукового буфера (тип char *).
    whdr.dwBufferLength = 88200; // размер буфера в байтах.
    whdr.dwFlags = WHDR_PREPARED; // Буфер подготовлен (зафиксирован в памяти)
    whdr.dwLoops = 0; // В обычном режиме, без циклов, поле должно быть нулевым.
    
    WAVEFORMATEX wfx; // для получения описателя звукового устройства:
    wfx.wFormatTag = WAVE_FORMAT_PCM;   // wav-формат
    wfx.nChannels = 1; // моно - звук
    wfx.nSamplesPerSec = 44100; // 44100 Гц
    wfx.nAvgBytesPerSec = 88200; // байт в секунду
    wfx.nBlockAlign = 2; // 2 байта на сэмпл-столбик
    wfx.wBitsPerSample = 16; // 16-битный сэмпл-столбик
    wfx.cbSize = 0; // For only WAVE_FORMAT_PCM formats, this member is ignored
 
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
 
    UINT X;
    X = auxGetNumDevs(); // A return value of zero means that no devices are present or that an error occurred.
 
    wsprintf(szText, "Значение равно %d", X);
    MessageBox(NULL, szText, "Значение переменной X", MB_OK);
 
    waveOutReset(/*HWAVEOUT hwo*/ hWO);
    waveOutClose(/*HWAVEOUT hwo*/ hWO);
 
    return 0;
}