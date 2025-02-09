#IfWinActive GTA: Vice City


vehPointerJP := 0x7E19C8
vehPointerINTL := 0x7E49C0

;Press , to install car bomb FOR JP version
,::installCarbomb(vehPointerJP)

;Press . to install car bomb FOR INTL version
.::installCarbomb(vehPointerINTL)



installCarbomb(vehPointer)
{	
	memory := MemoryOpenFromName("gta-vc.exe")
	
	;get current veh address
	veh := MemoryRead(memory, vehPointer)
	
	;get current veh driver pointer
	driverPointer := MemoryRead(memory, veh, "int", 4, 0x1A8)
	
	;if player is on a vehicle
	if (MemoryRead(memory, driverPointer) != 0)
	{
		;write detonator pointer as driver pointer, write carbomb state as 11
		MemoryWrite(memory, veh, driverPointer, "int", 4, 0x210)
		MemoryWrite(memory, veh, 11, "byte", 1, 0x1FE)
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
