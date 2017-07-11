#include <windows.h>
#include <mmsystem.h>
#include <Wincrypt.h>

#define IDD_MAIN 101
#define IDC_LST1 103


BOOL CALLBACK DlgProc(HWND,UINT,WPARAM,LPARAM);
void MakeSound();
void FillBuffer(byte* buffer, int size);
void SaveToFile(byte* buffer, int size, char* path);

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
	for (int i=0; i<size; i++) // ��������� �������� ������ ��������� ����� (���)
    {
        buffer[i] = rand();
    }		
}

void SaveToFile(byte* buffer, int size, char* path)
{
	HANDLE hFile;	 
    hFile = CreateFile(path, GENERIC_READ|GENERIC_WRITE, 
		FILE_SHARE_READ|FILE_SHARE_WRITE, NULL,
        CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, NULL);	
	WriteFile(hFile, (LPVOID)buffer, size, NULL, NULL);
	CloseHandle(hFile);    
}


void MakeSound()
{
	WAVEHDR whdr; // ��������� ��� ������ �����
	WAVEFORMATEX wfx; // ��� ��������� ��������� ��������� ����������:
    HCRYPTPROV  hcp;
	const int SIZE = 88200; // ���������� ������ ��� ������
	byte buffer[SIZE]; // ������� ���� �� ����� ������������� (88200 ��� 1 ������� ��������)
	char szText[80];
    	
	FillBuffer(buffer, SIZE);
	SaveToFile(buffer, SIZE, "c:\\123.bin");
		
		/*
	CryptAcquireContext(&hcp,0,0, PROV_RSA_FULL,0);
	CryptGenRandom(hcp, SIZE, szBuffer);
	CryptReleaseContext(hcp,0);
	*/
	   
    ZeroMemory(&whdr, sizeof(whdr));
    whdr.lpData = (char*)buffer; // ��������� ��������� ������ (��� char *).
    whdr.dwBufferLength = SIZE; // ������ ������ � ������.
    
    
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
        wsprintfA(szText, "waveOutOpen() ��������� �������! hWO = 0%X", hWO);
        MessageBoxA(NULL, szText, "GOOD INFO", MB_OK);
    }
    else
        MessageBoxA(NULL, "waveOutOpen() �� ���������!","ERROR", MB_OK);
 
    waveOutPrepareHeader(hWO, &whdr, sizeof(whdr));
    waveOutWrite(hWO, &whdr, sizeof(whdr));
 
    // ������-�� MessageBox � ������ ������, ����� ������ ����������� ������.
 
    UINT X;
    X = auxGetNumDevs(); // A return value of zero means that no devices are present or that an error occurred.
    wsprintfA(szText, "���������� �������������� = %d", X);
    MessageBoxA(NULL, szText, "�������� ���������� X", MB_OK);
 
    waveOutUnprepareHeader(hWO, &whdr, sizeof(whdr));
    waveOutReset(hWO);
    waveOutClose(hWO);
 
}