class_name WDB_Matrix

var mtx : Transform3D
var pos : Vector3
	
func LoadFromBuffer(file : StreamPeerBuffer) -> void:
	var m0_0 : Vector3 = VectorUtils.LoadDVec3FromBuffer(file)
	var m1_0 : Vector3 = VectorUtils.LoadDVec3FromBuffer(file)
	var m2_0 : Vector3 = VectorUtils.LoadDVec3FromBuffer(file)

	mtx = Transform3D(Vector3(m0_0.x, m0_0.y, m0_0.z),
					  Vector3(m1_0.x, m1_0.y, m1_0.z),
					  Vector3(m2_0.x, m2_0.y, m2_0.z),
					  Vector3(0, 0, 0))

	pos = VectorUtils.LoadXZYDVec3FromBuffer(file)

func appendToVertex(target : Vector3) -> Vector3:
	var result : Vector3
	
	result = target * mtx.basis
	#result = target * rot_node.transform.basis
	
	#применение позиции
	result += pos
	
	return result
