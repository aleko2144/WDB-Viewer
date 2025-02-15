class_name WDB_SimpleSpaceData extends WDB_SimpleNodeData

#wdb.dsr class description:
#( Matrix matrix )

var matrix : WDB_Matrix

func LoadFromBuffer(file : StreamPeerBuffer, loader : WDB_FileLoader) -> void:
	super(file, loader)
	matrix = WDB_Matrix.new()
	matrix.LoadFromBuffer(file)
