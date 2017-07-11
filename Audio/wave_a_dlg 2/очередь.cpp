
	
	Заполнить wfx - WAVEFORMATEX
	Заполнить whdr - WAVEHDR		    
	
	invoke waveOutOpen, addr hWO, WAVE_MAPPER, addr wfx, 0, 0, CALLBACK_NULL
	invoke waveOutPrepareHeader, hWO, addr whdr, sizeof WAVEHDR
    invoke waveOutWrite, hWO, addr whdr, sizeof WAVEHDR
    invoke waveOutUnprepareHeader, hWO, addr whdr, sizeof WAVEHDR
    invoke waveOutReset, hWO
    invoke waveOutClose, hWO

	
	HWAVEOUT hPlay;
	WAVEHDR Header[2];
	
	HANDLE hEvent = CreateEvent(0, FALSE, FALSE, 0);	
	waveOutOpen(&hPlay, WAVE_MAPPER, &wfx, (DWORD) hEvent, 0, CALLBACK_EVENT)
	
	__try
	{
		Header[0].lpData = выделить память		
		Header[1].lpData = Header[0].lpData+BlockSize;
		Header[0].dwBufferLength = Header[1].dwBufferLength = BlockSize; - указать размер
		
		waveOutPrepareHeader(hPlay, Header, sizeof(WAVEHDR))
		waveOutPrepareHeader(hPlay, Header+1, sizeof(WAVEHDR))
		
		int ii=0;
		//if(DataSize<=BlockSize) ResetEvent(hEvent);
		for(__int64 PlayPosition=0; PlayPosition<DataSize; PlayPosition+=BlockSize)
		{
						
				waveOutWrite(hPlay, curhdr, sizeof(WAVEHDR));  // воспроизводим
			}
			if(WAIT_TIMEOUT==WaitForSingleObject(hEvent, WaitTime))  // ждем освобождения объекта
				throw "Не удаётся воспроизвести данные - вышел лимит времени";
		}
	}
	
	// всё закрываем и очищаем
	
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