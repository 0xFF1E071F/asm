#include <windows.h>
#include <string.h>
#include <mmsystem.h>

void _fastcall PlayFile();
void _fastcall LoadFile();

char msg[300];

HANDLE hFile, hData=0;
WAVEFORMATEX wfx;
__int64 DataSize, DataOffset, FileSize;

int WINAPI WinMain(HINSTANCE, HINSTANCE, LPSTR lpCmdLine, int)
{
	hFile = CreateFile(lpCmdLine, GENERIC_READ, FILE_SHARE_READ, 0,
		OPEN_EXISTING, FILE_ATTRIBUTE_ARCHIVE, 0);

	try
	{
		if(INVALID_HANDLE_VALUE==hFile) throw "Не удаётся открыть файл";
		LoadFile();
		PlayFile();
	}
	catch(char *Message)
	{
		MessageBox(0, Message, "Ошибка!", MB_ICONSTOP);
	}
	catch(...)
	{
		MessageBox(0, "Неизвестная ошибка", "Ошибка!", MB_ICONSTOP);
	}

	if(hData!=0) CloseHandle(hData);
	if(hFile!=INVALID_HANDLE_VALUE) CloseHandle(hFile);

	return 0;
}

void _fastcall Win32Check(bool IsOk) // throw(char*)
{
	if(IsOk) return;
	FormatMessage(FORMAT_MESSAGE_IGNORE_INSERTS|FORMAT_MESSAGE_FROM_SYSTEM, 0, GetLastError(), 
		0, msg, sizeof(msg)-1, 0);
	throw msg;
}

void _fastcall WaveOutCheck(MMRESULT result) // throw(char*)
{
	switch(result)
	{
	case MMSYSERR_NOERROR:
		return;
	case MMSYSERR_ALLOCATED:
		throw "Драйвер уже открыт";
	case MMSYSERR_BADDEVICEID:
		throw "Неверный идентификатор устройства";
	case MMSYSERR_NODRIVER:
		throw "Отсутствует драйвер устройства";
	case MMSYSERR_NOMEM:
		throw "Невозможно распределить или зафиксировать память";
	case WAVERR_BADFORMAT:
		throw "Неверный формат данных";
	case WAVERR_SYNC:
		throw "Попытка воспроизведения на синхронном устройстве";
	case MMSYSERR_INVALHANDLE:
		throw "Неверный ключ устройства";
	case WAVERR_UNPREPARED:
		throw "Попытка воспроизведения неподготовленного блока данных";
	case WAVERR_STILLPLAYING:
		throw "Блок данных находится в очереди на воспроизведение";
	}
}

void _fastcall LoadFile()
{
	__int8 ID[8];
	FileSize = GetFileSize(hFile, 0);
	Win32Check(FileSize!=0xFFFFFFFF);
	if(FileSize < 28+sizeof(wfx)) throw "Неизвестный формат";
	Win32Check(SetFilePointer(hFile, 8, 0, FILE_BEGIN)!=0xFFFFFFFF);
	DWORD BytesReaded;
	Win32Check(ReadFile(hFile, (void*)ID, 8, &BytesReaded, 0)!=0);
	if(strncmp(ID,"WAVEfmt ", 8)!=0) throw "Неизвестный формат";
	DWORD Size;
	Win32Check(ReadFile(hFile, (void*)&Size, sizeof(Size), &BytesReaded, 0)!=0);
	if(Size>sizeof(wfx)) throw "Неизвестный формат";
	ZeroMemory((void*)&wfx, sizeof(wfx));
	Win32Check(ReadFile(hFile, (void*)&wfx, Size, &BytesReaded, 0)!=0);
	if(wfx.wFormatTag!=WAVE_FORMAT_PCM) throw "Не поддерживается сжатие данных";
	wfx.cbSize = 0;
	Win32Check(ReadFile(hFile, (void*)ID, 8, &BytesReaded, 0)!=0);
	if(strncmp(ID,"data", 4)!=0) throw "Неизвестный формат";
	DataSize = *((DWORD*)(void*)(ID+4));
	DataOffset = SetFilePointer(hFile, 0, 0, FILE_CURRENT);
	Win32Check(DataOffset!=0xFFFFFFFF);
	if(Size<=0) throw "Отсутствуют данные";
	hData = CreateFileMapping(hFile, 0, PAGE_READONLY, 0, int(FileSize), 0);
	Win32Check(hData!=0);
}

void _fastcall PlayFile()
{
	int BlockSize = 64*1024;
	HANDLE hEvent = CreateEvent(0, FALSE, FALSE, 0);
	HWAVEOUT hPlay;
	__int64 PlayPosition = 0;
	int WaitTime = BlockSize*2000/(wfx.nAvgBytesPerSec);
	SYSTEM_INFO si;
	GetSystemInfo(&si);
	WAVEHDR Header[2];
	ZeroMemory(Header, sizeof(Header));
	WaveOutCheck(waveOutOpen(&hPlay, WAVE_MAPPER, &wfx, (DWORD) hEvent, 0, CALLBACK_EVENT));
	__try
	{
		Header[0].lpData = (LPSTR) VirtualAlloc(0, 
			(BlockSize*2+si.dwPageSize-1)/si.dwPageSize*si.dwPageSize,
			MEM_RESERVE|MEM_COMMIT, PAGE_READWRITE);
		Win32Check(Header[0].lpData != (LPSTR)0);
		Header[1].lpData = Header[0].lpData+BlockSize;
		Header[0].dwBufferLength = Header[1].dwBufferLength = BlockSize;
		WaveOutCheck(waveOutPrepareHeader(hPlay, Header, sizeof(WAVEHDR)));
		WaveOutCheck(waveOutPrepareHeader(hPlay, Header+1, sizeof(WAVEHDR)));
		int ii=0;
		if(DataSize<=BlockSize) ResetEvent(hEvent);
		for(__int64 PlayPosition=0; PlayPosition<DataSize; PlayPosition+=BlockSize)
		{
			if(PlayPosition<DataSize)
			{
				WAVEHDR *curhdr = Header+((ii++)&1);
				if(BlockSize>DataSize-PlayPosition) 
					BlockSize = int(DataSize-PlayPosition);
				curhdr->dwBufferLength = (DWORD) BlockSize;
				__int64 ofs = PlayPosition+DataOffset;
				int shift = int(ofs%si.dwAllocationGranularity);
				ofs -= shift;
				int size = int(BlockSize+ofs+si.dwPageSize-1);
				size -= size % si.dwPageSize;
				if(size>FileSize-ofs) size = int(FileSize-ofs);
				void *p = MapViewOfFile(hData, FILE_MAP_READ, int((ofs>>32)&0xFFFFFFFF),
					int(ofs&0xFFFFFFFF), size);
				Win32Check(p!=(void*)0);
				__try
				{
					memcpy(curhdr->lpData, ((__int8*)p)+shift, min(size-shift,BlockSize));
				}
				__finally
				{
					UnmapViewOfFile(p);
				}
				UnmapViewOfFile(p);
				WaveOutCheck(waveOutWrite(hPlay, curhdr, sizeof(WAVEHDR)));
			}
			if(WAIT_TIMEOUT==WaitForSingleObject(hEvent, WaitTime))
				throw "Не удаётся воспроизвести данные - вышел лимит времени";
		}
	}
	__finally
	{
		waveOutUnprepareHeader(hPlay, Header, sizeof(WAVEHDR));
		waveOutUnprepareHeader(hPlay, Header+1, sizeof(WAVEHDR));
		if(Header[0].lpData!=(LPSTR)0) VirtualFree((void*)Header[0].lpData, 0, MEM_RELEASE);
		waveOutClose(hPlay);
	}
	waveOutUnprepareHeader(hPlay, Header, sizeof(WAVEHDR));
	waveOutUnprepareHeader(hPlay, Header+1, sizeof(WAVEHDR));
	if(Header[0].lpData!=(LPSTR)0) VirtualFree((void*)Header[0].lpData, 0, MEM_RELEASE);
	waveOutClose(hPlay);
}
