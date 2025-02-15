class_name WDB_EventSimpleData extends WDB_SimpleNodeData

#wdb.dsr class description:
#( EventStruct eventInfo )

var eventInfo : WDB_EventStruct

func LoadFromBuffer(file : StreamPeerBuffer, loader : WDB_FileLoader) -> void:
	super(file, loader)
	eventInfo = WDB_EventStruct.new()
	eventInfo.LoadFromBuffer(file)
