class_name WDB_NodeGlobalDirectionLightData extends WDB_NodeGlobalLightData

#( Vector direction )

var direction : Vector3

func LoadFromBuffer(file : StreamPeerBuffer, loader : WDB_FileLoader) -> void:
	super(file, loader)
	direction = VectorUtils.LoadDVec3FromBuffer(file)
