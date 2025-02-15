class_name WDB_NodeLocalPointLightData extends WDB_NodeLocalLightData

#( Vector position )
#( Vector direction )
#( float att0 )
#( float att1 )
#( float att2 )

var v_position  : Vector3
var att0      : float
var att1      : float
var att2      : float

func LoadFromBuffer(file : StreamPeerBuffer, loader : WDB_FileLoader) -> void:
	super(file, loader)
	v_position = VectorUtils.LoadDVec3FromBuffer(file)
	att0       = file.get_float()
	att1       = file.get_float()
	att2       = file.get_float()
