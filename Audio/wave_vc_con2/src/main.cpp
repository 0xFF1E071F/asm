#include <windows.h>
#include <mmsystem.h>
#include <wincrypt.h>

void MakeSound();

int WINAPI WinMain(HINSTANCE hInstance, HINSTANCE, LPSTR, int)
{    
    MakeSound();
    return 0;
}

void MakeSound()
{	
	WAVEHDR whdr; // ��������� ��� ������ �����
    WAVEFORMATEX wfx; // ��� ��������� ��������� ��������� ����������:
	HWAVEOUT hWO; // handle identifying the open waveform-audio output device
	HCRYPTPROV  hcp;
	const int SIZE = 88200; // ���������� ������ ��� ������
	unsigned char szBuffer[SIZE]; // ������� ���� �� ����� ������������� (88200 ��� 1 ������� ��������)
	char szText[80];    
	UINT X;
    
    //for (UINT i=0; i<SIZE; i++) szBuffer[i] = rand(); // ��������� �������� ������ ��������� ����� (���)         
		
	CryptAcquireContext(&hcp,0,0, PROV_RSA_FULL,0);
	CryptGenRandom(hcp, SIZE, szBuffer);
	CryptReleaseContext(hcp,0);
    	
    ZeroMemory(&whdr, sizeof(whdr));
    whdr.lpData = (char*)szBuffer; // ��������� ��������� ������ (��� char *).
    whdr.dwBufferLength = SIZE; // ������ ������ � ������.
        
    ZeroMemory(&wfx, sizeof(wfx));
    wfx.wFormatTag = WAVE_FORMAT_PCM;   // wav-������
    wfx.nChannels = 1; // ���� - ����
    wfx.nSamplesPerSec = 44100; // 44100 ��
    wfx.nAvgBytesPerSec = 4*44100;
    wfx.nBlockAlign = 4;
    wfx.wBitsPerSample = 16; // 16-������ ����
    wfx.cbSize = sizeof(wfx);
     
    if(waveOutOpen(&hWO, WAVE_MAPPER, &wfx, 0, 0, CALLBACK_NULL) == MMSYSERR_NOERROR) {
        wsprintf(szText, "waveOutOpen() ��������� �������! hWO = 0%X", hWO);
        MessageBox(NULL, szText, "GOOD INFO", MB_OK);
    } else
        MessageBox(NULL, "waveOutOpen() �� ���������!", "ERROR", MB_OK);
 
    waveOutPrepareHeader(hWO, &whdr, sizeof(whdr));
    waveOutWrite(hWO, &whdr, sizeof(whdr));
 
    // ������-�� MessageBox � ������ ������, ����� ������ ����������� ������.
    X = auxGetNumDevs(); // A return value of zero means that no devices are present or that an error occurred.
    wsprintf(szText, "���������� �������������� = %d", X);
    MessageBox(NULL, szText, "�������� ���������� X", MB_OK);
 
    waveOutUnprepareHeader(hWO, &whdr, sizeof(whdr));
    waveOutReset(hWO);
    waveOutClose(hWO);
}