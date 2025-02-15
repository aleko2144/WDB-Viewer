class_name WDB_NodeCaseRefMaskData extends WDB_SimpleNodeData

var ref : Node

func LoadFromBuffer(file : StreamPeerBuffer, loader : WDB_FileLoader) -> void:
	super(file, loader)
	ref = loader.read_WDBNode(file, loader)   
