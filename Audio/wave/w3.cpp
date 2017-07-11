// ��������� ������������ Waveform-Audio �������
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
 
// ��� ������ ��������� � �����������. ������ ��� ��������!
// � �������� ����������� - ���� ��������� ���������, ���� �������,
// ���� ��� �� ��������� ������� ��������� "�����" ����� waveOutWrite
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
 
  // ��������� �����: ������������� �������� �������� nRate / 200;
  // ��� nRate = 44100 �������� 220,5 ��
  // (��������� ������ ������ ������� 220,46 ��)
  for (UINT i = 0; i < nSamples; i++)
  {
    if((i/100)%2)
      aswBuffer[i] =  32767;
    else
      aswBuffer[i] = -32767;
  }
 
  
  WAVEFORMATEX wfx; // ��� ��������� ��������� ��������� ����������:
  wfx.wFormatTag = WAVE_FORMAT_PCM;   // wav-������
  wfx.nChannels = 1; // ���� - ����
  wfx.nSamplesPerSec = nRate; // 44100 ��
  wfx.nAvgBytesPerSec = nBytesPerSample * nRate; // ���� � �������
  wfx.nBlockAlign = nBytesPerSample; // 2 ����� �� �����-�������
  wfx.wBitsPerSample = nBits; // 16-������ �����-�������
  wfx.cbSize = 0; // For only WAVE_FORMAT_PCM formats, this member is ignored
 
  HWAVEOUT hWO; // handle identifying the open waveform-audio output device
  MMRESULT mmResult = waveOutOpen(&hWO, WAVE_MAPPER, &wfx, (DWORD)waveOutProc, 0, CALLBACK_FUNCTION);
 
  if(mmResult == MMSYSERR_NOERROR)
  {
      printf("waveOutOpen() ��������� �������! hWO = 0%08X\n", hWO);
  }
  else
    printf("waveOutOpen() �� ���������! %s\n", GetMMSysError(mmResult));
 
  WAVEHDR whdr;
  whdr.lpData = (LPSTR)aswBuffer;
  whdr.dwBufferLength = nBytes; // ������ ������ � ������.
  whdr.dwFlags = 0; // ����� ����������� (������������ � ������)
  whdr.dwLoops = 0; // � ������� ������, ��� ������, ���� ������ ���� �������.
 
  mmResult = waveOutPrepareHeader(hWO, &whdr, sizeof(whdr));
  if(mmResult == MMSYSERR_NOERROR)
  {
      printf("waveOutPrepareHeader() ��������� �������!\n");
  }
  else
    printf("waveOutPrepareHeader() �� ���������! %s\n", GetMMSysError(mmResult));
 
  waveOutSetVolume(hWO, 0xFFFF);
 
  mmResult = waveOutWrite(hWO, &whdr, sizeof(whdr));
  if(mmResult == MMSYSERR_NOERROR)
  {
      printf("waveOutWrite() ��������� �������!\n");
  }
  else
    printf("waveOutWrite() �� ���������! %s\n", GetMMSysError(mmResult));
 
  printf("�������� waveOutGetNumDevs() ����� %d", waveOutGetNumDevs());
 
  // � �������� ���������, ���� �����, ��� �� ������...
  for(;;){
      if(bDone) break;
  }
 
  waveOutClose(hWO);
 
  return 0;
}