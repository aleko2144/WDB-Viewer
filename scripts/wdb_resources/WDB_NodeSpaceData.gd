class_name WDB_NodeSpaceData extends WDB_SimpleSpaceData

var type : int

func LoadFromBuffer(file : StreamPeerBuffer, loader : WDB_FileLoader) -> void:
	super(file, loader)
	type = file.get_32()
