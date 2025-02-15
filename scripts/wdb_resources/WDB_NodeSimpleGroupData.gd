class_name WDB_NodeSimpleGroupData extends WDB_SimpleNodeData

var rootType : int

func LoadFromBuffer(file : StreamPeerBuffer, loader : WDB_FileLoader) -> void:
	super(file, loader)
