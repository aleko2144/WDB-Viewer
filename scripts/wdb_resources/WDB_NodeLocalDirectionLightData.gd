class_name WDB_NodeLocalDirectionLightData extends WDB_NodeLocalLightData

#( Vector direction )

var direction : Vector3

func LoadFromBuffer(file : StreamPeerBuffer, loader : WDB_FileLoader) -> void:
	super(file, loader)
	direction = VectorUtils.LoadDVec3FromBuffer(file)
