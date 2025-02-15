class_name WDB_Cylinder

var pos : Vector3
var n   : Vector3
var v1  : float
var v2  : float

func LoadFromBuffer(file : StreamPeerBuffer) -> void:
	pos = VectorUtils.LoadDVec3FromBuffer(file)
	n   = VectorUtils.LoadDVec3FromBuffer(file)
	v1  = file.get_double()
	v2  = file.get_double()
