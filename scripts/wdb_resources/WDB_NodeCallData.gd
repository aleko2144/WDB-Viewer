class_name WDB_NodeCallData extends WDB_SimpleNodeData 

#wdb.dsr:
#( Ref pump_unit )	
#( Ref node )
#( Ref space )

var pump_unit : Node
var node      : Node
var space     : Node

func LoadFromBuffer(file : StreamPeerBuffer, loader : WDB_FileLoader) -> void:
	super(file, loader)
	
	pump_unit = loader.read_WDBNode(file, loader)
	node      = loader.read_WDBNode(file, loader)
	space     = loader.read_WDBNode(file, loader)
