class_name WDB_EventPlaneData extends WDB_EventSimpleData

#wdb.dsr:
#( Sphere	sphere )

var plane : Vector4

func LoadFromBuffer(file : StreamPeerBuffer, loader : WDB_FileLoader) -> void:
	super(file, loader)
	plane = VectorUtils.LoadDVec4FromBuffer(file)