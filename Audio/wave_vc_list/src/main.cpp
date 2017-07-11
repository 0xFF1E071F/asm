#include <windows.h>
#include <mmsystem.h>

#define IDD_MAIN 101
#define IDC_LST1 103

BOOL CALLBACK DlgProc(HWND,UINT,WPARAM,LPARAM);
void ShowWaveDevices (HWND hList);

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
					HWND hList = GetDlgItem(hWnd,IDC_LST1);
					ShowWaveDevices (hList);
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

void ShowWaveDevices (HWND hList)
{
	char szText[80];
	WAVEINCAPS inCaps;
	WAVEOUTCAPS outCaps;
	int i, nDevs = waveInGetNumDevs();
	for (i=0; i<nDevs; i++){
		waveInGetDevCaps(i,&inCaps,sizeof(inCaps));
		wsprintfA(szText, "Номер 0%X", i);
		SendMessage(hList,LB_ADDSTRING,0,(LPARAM)szText);
		SendMessage(hList,LB_ADDSTRING,0,(LPARAM)inCaps.szPname);
	}		
	SendMessage(hList,LB_ADDSTRING,0,(LPARAM)" ");	
	nDevs = waveOutGetNumDevs();
	for (i=0; i<nDevs; i++){
		waveOutGetDevCaps(i,&outCaps,sizeof(outCaps));
		wsprintfA(szText, "Номер 0%X", i);
		SendMessage(hList,LB_ADDSTRING,0,(LPARAM)szText);
		SendMessage(hList,LB_ADDSTRING,0,(LPARAM)outCaps.szPname);
	}	
}