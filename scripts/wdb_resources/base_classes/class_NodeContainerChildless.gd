class_name WDB_NodeContainerChildless extends WDB_Container

var data : WDB_SimpleNodeData
#( SimpleNodeData  data )
#( Container childNodes ( ITERATED NONAME) )

func LoadFromBuffer(file : StreamPeerBuffer, loader : WDB_FileLoader) -> void:
	data = WDB_SimpleNodeData.new()
	data.LoadFromBuffer(file, loader)
