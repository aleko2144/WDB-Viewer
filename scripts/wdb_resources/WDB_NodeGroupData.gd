class_name WDB_NodeGroupData extends WDB_NodeSimpleGroupData

var space : Node

func LoadFromBuffer(file : StreamPeerBuffer, loader : WDB_FileLoader) -> void:
	super(file, loader)
	space = loader.read_WDBNode(file, loader) 
