class_name WDB_NodeLocalSpotLightData extends WDB_NodeLocalLightData

#( Vector position )
#( Vector direction )
#( float falloff )
#( float att0 )
#( float att1 )
#( float att2 )
#( float theta )
#( float phi )

var v_position  : Vector3
var direction : Vector3
var falloff   : float
var att0      : float
var att1      : float
var att2      : float
var theta     : float
var phi       : float

func LoadFromBuffer(file : StreamPeerBuffer, loader : WDB_FileLoader) -> void:
	super(file, loader)
	v_position  = VectorUtils.LoadDVec3FromBuffer(file)
	direction = VectorUtils.LoadDVec3FromBuffer(file)
	falloff   = file.get_float()
	att0      = file.get_float()
	att1      = file.get_float()
	att2      = file.get_float()
	theta     = file.get_float()
	phi       = file.get_float()
