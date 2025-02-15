class_name WDB_NodeScreenData extends WDB_NodeOptData

#( Plane pl)
var pl : Vector4

func LoadFromBuffer(file : StreamPeerBuffer, loader : WDB_FileLoader) -> void:
	super(file, loader)
	pl = VectorUtils.LoadDVec4FromBuffer(file)
