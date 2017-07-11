// ��������� ������������ Waveform-Audio �������
#include <windows.h>
#include <mmsystem.h>
//#include <windowsx.h>
int WINAPI WinMain(HINSTANCE hInstance, HINSTANCE, LPSTR, int)
{
    char szText[80];
    const int SIZE = 88200; // ���������� ������ ��� ������
 
    WAVEHDR whdr; // ��������� ��� ������ �����
    char szBuffer[SIZE]; // ������� ���� �� ����� ������������� (88200 ��� 1 ������� ��������)
    for (UINT i=0; i<SIZE; i++) // ��������� �������� ������ ��������� ����� (���)
    {
        szBuffer[i] = rand();
    }
    ZeroMemory(&whdr, sizeof(whdr));
    whdr.lpData = szBuffer; // ��������� ��������� ������ (��� char *).
    whdr.dwBufferLength = SIZE; // ������ ������ � ������.
    
    WAVEFORMATEX wfx; // ��� ��������� ��������� ��������� ����������:
    ZeroMemory(&wfx, sizeof(wfx));
    wfx.wFormatTag = WAVE_FORMAT_PCM;   // wav-������
    wfx.nChannels = 1; // ���� - ����
    wfx.nSamplesPerSec = 44100; // 44100 ��
    wfx.nAvgBytesPerSec = 4*44100;
    wfx.nBlockAlign = 4;
    wfx.wBitsPerSample = 16; // 16-������ ����
    wfx.cbSize = sizeof(wfx);
 
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
 
    // ������-�� MessageBox � ������ ������, ����� ������ ����������� ������.
 
    UINT X;
    X = auxGetNumDevs(); // A return value of zero means that no devices are present or that an error occurred.
    wsprintf(szText, "���������� �������������� = %d", X);
    MessageBox(NULL, szText, "�������� ���������� X", MB_OK);
 
    waveOutUnprepareHeader(hWO, &whdr, sizeof(whdr));
    waveOutReset(hWO);
    waveOutClose(hWO);
 
    return 0;
}