class_name WDB_EventObjectData extends WDB_EventSimpleData

#wdb.dsr:
#( DWORD eventType ( ( MNEMONICS "event*" ) ) )
#( DWORD eventFlag )
#( DWORD NumOfEntries )
#( Ref entry   ( (ITERATED NumOfEntries ) ) )

var eventType    : int
var eventFlag    : int
var NumOfEntries : int
#var entry : Array

func LoadFromBuffer(file : StreamPeerBuffer, loader : WDB_FileLoader) -> void:
	super(file, loader)
	eventType = file.get_32()
	eventFlag = file.get_32()
	NumOfEntries = file.get_32()
