// ��������� ������������ Waveform-Audio �������
#include <windows.h>
#include <mmsystem.h>
//#include <windowsx.h>
int WINAPI WinMain(HINSTANCE hInstance, HINSTANCE, LPSTR, int)
{
    char szText[80];
 
    WAVEHDR whdr; // ����� ��� �����
    char szBuffer[88200]; // ������� ���� �� 1 ��������� ����� �������������
    for (UINT i=0; i<88200; i++) // ��������� �������� ������
    {
                     szBuffer = rand(); // ���������� ��������� ����� ��� ����
    }
    whdr.lpData = szBuffer; // ��������� ��������� ������ (��� char *).
    whdr.dwBufferLength = 88200; // ������ ������ � ������.
    whdr.dwFlags = WHDR_PREPARED; // ����� ����������� (������������ � ������)
    whdr.dwLoops = 0; // � ������� ������, ��� ������, ���� ������ ���� �������.
    
    WAVEFORMATEX wfx; // ��� ��������� ��������� ��������� ����������:
    wfx.wFormatTag = WAVE_FORMAT_PCM;   // wav-������
    wfx.nChannels = 1; // ���� - ����
    wfx.nSamplesPerSec = 44100; // 44100 ��
    wfx.nAvgBytesPerSec = 88200; // ���� � �������
    wfx.nBlockAlign = 2; // 2 ����� �� �����-�������
    wfx.wBitsPerSample = 16; // 16-������ �����-�������
    wfx.cbSize = 0; // For only WAVE_FORMAT_PCM formats, this member is ignored
 
    HWAVEOUT hWO; // handle identifying the open waveform-audio output device
    if(waveOutOpen(&hWO, WAVE_MAPPER, &wfx, 0, 0, CALLBACK_NULL) == MMSYSERR_NOERROR)
    {
        wsprintf(szText, "waveOutOpen() ��������� �������! hWO = 0%X", hWO);
        MessageBox(NULL, szText, "GOOD INFO", MB_OK);
    }
    else
        MessageBox(NULL, "waveOutOpen() �� ���������!", "ERROR", MB_OK);
 
    waveOutPrepareHeader(hWO, &whdr, sizeof(whdr));
 
    waveOutWrite(hWO, &whdr, sizeof(whdr));
 
    UINT X;
    X = auxGetNumDevs(); // A return value of zero means that no devices are present or that an error occurred.
 
    wsprintf(szText, "�������� ����� %d", X);
    MessageBox(NULL, szText, "�������� ���������� X", MB_OK);
 
    waveOutReset(/*HWAVEOUT hwo*/ hWO);
    waveOutClose(/*HWAVEOUT hwo*/ hWO);
 
    return 0;
}