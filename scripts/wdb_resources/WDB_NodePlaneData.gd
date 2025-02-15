class_name WDB_NodePlaneData extends WDB_NodeSortData

var plane : Vector4

func LoadFromBuffer(file : StreamPeerBuffer, loader : WDB_FileLoader) -> void:
	super(file, loader)
	plane = VectorUtils.LoadDVec4FromBuffer(file)
