#IfWinActive GTA: Vice City
;Press , to install car bomb
,::
{	
	memory := MemoryOpenFromName("gta-vc.exe")
	
	; get current version
	version := MemoryRead(memory, 0x608578, "byte", 1)
	
	;get current veh address
	if (version == 0x44) ; JP
		{
		playerPointer := 0x947D30
		vehPointer := 0x7E19C8
		}
	else if (version == 0x5D) ; INTL 1.0
		{
		playerPointer := 0x94AD28
		vehPointer := 0x7E49C0
		}
	
	veh := MemoryRead(memory, vehPointer)
	
	;get current veh driver pointer
	driverPointer := MemoryRead(memory, veh, "int", 4, 0x1A8)
	
	;if player is on a vehicle
	if (MemoryRead(memory, driverPointer) != 0)
	{
		;write detonator pointer as driver pointer, write carbomb state as 11
		MemoryWrite(memory, veh, driverPointer, "int", 4, 0x210)
		MemoryWrite(memory, veh, 11, "byte", 1, 0x1FE)
		
		;give tommy detonator
		playerPointed := MemoryRead(memory, playerPointer)		;read player pointer
		MemoryWrite(memory, playerPointed, 34, "int", 4, 0x4E0)	;give detonator at slot 9 (0x408 + 0x18 * 9)
		MemoryWrite(memory, playerPointed, 1, "int", 4, 0x4E8)	;current clip
		MemoryWrite(memory, playerPointed, 1, "int", 4, 0x4EC)	;current ammo
	}
	MemoryClose(memory)
}

MemoryOpenFromPID(PID, Privilege=0x1F0FFF)
{
	HWND := DllCall("OpenProcess", "Uint", Privilege, "int", 0, "int", PID)
	return HWND
}

MemoryOpenFromName(Name, Privilege=0x1F0FFF)
{
	Process, Exist, %Name%
	PID := ErrorLevel
	Return MemoryOpenFromPID(PID, Privilege)
}

MemoryClose(hwnd)
{
	return DllCall("CloseHandle", "int", hwnd)
}

MemoryWrite(hwnd, address, writevalue, datatype="int", length=4, offset=0)
{
	VarSetCapacity(finalvalue, length, 0)
	NumPut(writevalue, finalvalue, 0, datatype)
	return DllCall("WriteProcessMemory", "Uint", hwnd, "Uint", address+offset, "Uint", &finalvalue, "Uint", length, "Uint", 0)
}

MemoryRead(hwnd, address, datatype="int", length=4, offset=0)
{
	VarSetCapacity(readvalue,length, 0)
	DllCall("ReadProcessMemory","Uint",hwnd,"Uint",address+offset,"Str",readvalue,"Uint",length,"Uint *",0)
	finalvalue := NumGet(readvalue,0,datatype)
	return finalvalue
}
