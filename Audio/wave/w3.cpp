// ПРОГРАММА ТЕСТИРОВАНИЯ Waveform-Audio ФУНКЦИЙ
#include <windows.h>
#include <mmsystem.h>
 
#include <stdio.h>
#pragma comment(lib, "winmm.lib")
#pragma comment(lib, "user32.lib")
 
const int nRate = 44100;
const int nBits = 16;
const int nBytesPerSample = nBits / 8;
 
const int nSeconds = 1;
 
const int nSamples = nRate * nSeconds;
const int nBytes   = nSamples * nBytesPerSample;
 
typedef signed short SWORD;
 
LPCSTR GetMMSysError(MMRESULT mmResult){
    const int nBufferSize = 512;
    static CHAR acError[nBufferSize];
 
  waveOutGetErrorText(mmResult, acError, nBufferSize);
  CharToOem(acError, acError);
  return acError;
}
 
// Так делать некрасиво и неправильно. Только для простоты!
// В реальных приложениях - либо обработка сообщений, либо мутексы,
// либо эта же процедура выводит очередной "кусок" через waveOutWrite
LONG bDone = FALSE;
 
void CALLBACK waveOutProc(
  HWAVEOUT hwo, UINT uMsg,        
  DWORD dwInstance, DWORD dwParam1, DWORD dwParam2)
{
  if(uMsg == WOM_DONE || uMsg == WOM_CLOSE)
      InterlockedIncrement(&bDone);
}
 
int main(void){
  static SWORD aswBuffer[nSamples];
 
  // генерация звука: прямоугольные импульсы частотой nRate / 200;
  // при nRate = 44100 получаем 220,5 Гц
  // (частотный анализ записи показал 220,46 Гц)
  for (UINT i = 0; i < nSamples; i++)
  {
    if((i/100)%2)
      aswBuffer[i] =  32767;
    else
      aswBuffer[i] = -32767;
  }
 
  
  WAVEFORMATEX wfx; // для получения описателя звукового устройства:
  wfx.wFormatTag = WAVE_FORMAT_PCM;   // wav-формат
  wfx.nChannels = 1; // моно - звук
  wfx.nSamplesPerSec = nRate; // 44100 Гц
  wfx.nAvgBytesPerSec = nBytesPerSample * nRate; // байт в секунду
  wfx.nBlockAlign = nBytesPerSample; // 2 байта на сэмпл-столбик
  wfx.wBitsPerSample = nBits; // 16-битный сэмпл-столбик
  wfx.cbSize = 0; // For only WAVE_FORMAT_PCM formats, this member is ignored
 
  HWAVEOUT hWO; // handle identifying the open waveform-audio output device
  MMRESULT mmResult = waveOutOpen(&hWO, WAVE_MAPPER, &wfx, (DWORD)waveOutProc, 0, CALLBACK_FUNCTION);
 
  if(mmResult == MMSYSERR_NOERROR)
  {
      printf("waveOutOpen() СРАБОТАЛА УСПЕШНО! hWO = 0%08X\n", hWO);
  }
  else
    printf("waveOutOpen() НЕ СРАБОТАЛА! %s\n", GetMMSysError(mmResult));
 
  WAVEHDR whdr;
  whdr.lpData = (LPSTR)aswBuffer;
  whdr.dwBufferLength = nBytes; // размер буфера в байтах.
  whdr.dwFlags = 0; // Буфер подготовлен (зафиксирован в памяти)
  whdr.dwLoops = 0; // В обычном режиме, без циклов, поле должно быть нулевым.
 
  mmResult = waveOutPrepareHeader(hWO, &whdr, sizeof(whdr));
  if(mmResult == MMSYSERR_NOERROR)
  {
      printf("waveOutPrepareHeader() СРАБОТАЛА УСПЕШНО!\n");
  }
  else
    printf("waveOutPrepareHeader() НЕ СРАБОТАЛА! %s\n", GetMMSysError(mmResult));
 
  waveOutSetVolume(hWO, 0xFFFF);
 
  mmResult = waveOutWrite(hWO, &whdr, sizeof(whdr));
  if(mmResult == MMSYSERR_NOERROR)
  {
      printf("waveOutWrite() СРАБОТАЛА УСПЕШНО!\n");
  }
  else
    printf("waveOutWrite() НЕ СРАБОТАЛА! %s\n", GetMMSysError(mmResult));
 
  printf("Значение waveOutGetNumDevs() равно %d", waveOutGetNumDevs());
 
  // В реальной программе, само собой, так не делают...
  for(;;){
      if(bDone) break;
  }
 
  waveOutClose(hWO);
 
  return 0;
}