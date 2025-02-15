class_name WDB_NodeViewerData extends WDB_SimpleNodeData

#wdb.dsr description:
#( Ref node )
#( Ref space )
#( Ref pyramid )

var node : Node
var space : Node
var pyramid : Node

func LoadFromBuffer(file : StreamPeerBuffer, loader : WDB_FileLoader) -> void:
	super(file, loader)
	node    = loader.read_WDBNode(file, loader)
	space   = loader.read_WDBNode(file, loader)
	pyramid = loader.read_WDBNode(file, loader)
