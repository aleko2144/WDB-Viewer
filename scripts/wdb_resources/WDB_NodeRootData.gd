class_name WDB_NodeRootData extends WDB_SimpleNodeData

var rootType : int

func LoadFromBuffer(file : StreamPeerBuffer, loader : WDB_FileLoader) -> void:
	super(file, loader)
	rootType = file.get_32()
