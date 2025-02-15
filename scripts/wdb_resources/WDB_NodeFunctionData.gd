class_name WDB_NodeFunctionData extends WDB_NodeSimpleGroupData

#wdb.dsr:
#( ASCIIZ functionName )	
#( Ref data )

var functionName : String
var data : Node

func LoadFromBuffer(file : StreamPeerBuffer, loader : WDB_FileLoader) -> void:
	super(file, loader)
	functionName = WDB_ASCIIZ.LoadFromBuffer(file)
	data         = loader.read_WDBNode(file, loader)  
