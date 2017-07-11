
	
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
		if(DataSize<=BlockSize) ResetEvent(hEvent);
		for(__int64 PlayPosition=0; PlayPosition<DataSize; PlayPosition+=BlockSize)
		{
			if(PlayPosition<DataSize)
			{
				WAVEHDR *curhdr = Header+((ii++)&1); // выбираем нужный блок
				if(BlockSize>DataSize-PlayPosition) 
					BlockSize = int(DataSize-PlayPosition); // обрезаем размер, если осталось меньше одного блока				
				curhdr->dwBufferLength = (DWORD) BlockSize;
				__int64 ofs = PlayPosition+DataOffset;
				
				void *p = MapViewOfFile(hData, FILE_MAP_READ, int((ofs>>32)&0xFFFFFFFF), int(ofs&0xFFFFFFFF), size);  // читаем из файла						
				__try
				{
					memcpy(curhdr->lpData, ((__int8*)p)+shift, min(size-shift,BlockSize));  // копируем в блок то, что прочитали
				}
				__finally
				{
					UnmapViewOfFile(p);  // закрываем файл
				}
				UnmapViewOfFile(p);
				
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