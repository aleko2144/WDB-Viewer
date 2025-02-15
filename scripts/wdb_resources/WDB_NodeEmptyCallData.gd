class_name WDB_NodeEmptyCallData extends WDB_SimpleNodeData 

#wdb.dsr:
#( Ref pump_unit )	
#( Ref node )

var pump_unit : Node
var node      : Node

func LoadFromBuffer(file : StreamPeerBuffer, loader : WDB_FileLoader) -> void:
	super(file, loader)
	
	pump_unit = loader.read_WDBNode(file, loader)
	node      = loader.read_WDBNode(file, loader)
