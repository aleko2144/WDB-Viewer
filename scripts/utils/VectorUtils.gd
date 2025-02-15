class_name VectorUtils

static func LoadDVec4FromBuffer(file : StreamPeerBuffer) -> Vector4:
	var x : float = file.get_double()
	var y : float = file.get_double()
	var z : float = file.get_double()
	var w : float = file.get_double()
	return Vector4(x, y, z, w)
	
static func LoadXZYDVec4FromBuffer(file : StreamPeerBuffer) -> Vector4:
	var x : float = file.get_double()
	var y : float = file.get_double()
	var z : float = file.get_double()
	var w : float = file.get_double()
	return Vector4(-x, z, y, w) #Godot xzy, VWI xyz

static func LoadDVec3FromBuffer(file : StreamPeerBuffer) -> Vector3:
	var x : float = file.get_double()
	var y : float = file.get_double()
	var z : float = file.get_double()
	return Vector3(x, y, z)
	
static func LoadXZYDVec3FromBuffer(file : StreamPeerBuffer) -> Vector3:
	var x : float = file.get_double()
	var y : float = file.get_double()
	var z : float = file.get_double()
	return Vector3(-x, z, y) #Godot xzy, VWI xyz

static func LoadVec2FromBuffer(file : StreamPeerBuffer) -> Vector2:
	var x : float = file.get_float()
	var y : float = file.get_float()
	return Vector2(x, y)

static func LoadVec3FromBuffer(file : StreamPeerBuffer) -> Vector3:
	var x : float = file.get_float()
	var y : float = file.get_float()
	var z : float = file.get_float()
	return Vector3(x, y, z)
	
static func LoadXZYVec3FromBuffer(file : StreamPeerBuffer) -> Vector3:
	var x : float = file.get_float()
	var y : float = file.get_float()
	var z : float = file.get_float()
	return Vector3(x, z, y)
