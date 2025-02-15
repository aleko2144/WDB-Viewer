class_name WDB_NodeSpace extends WDB_NodeSimpleSpace

var objectData : WDB_NodeSpaceData

func LoadFromBuffer(file : StreamPeerBuffer, loader : WDB_FileLoader) -> void:
	#super(file, root)
	self.name = "NodeSpace_%s" % self.offset_hex
	tag = 116
	
	#импорт NodeModelData
	file.seek(file.get_position() + 8) #skip tag (1) and size
	objectData = WDB_NodeSpaceData.new()
	objectData.LoadFromBuffer(file, loader)
	
	#var mtx_rot : Vector3 = objectData.matrix.mtx.basis.get_euler()
	#from_euler
	#self.set_rotation(Vector3(-mtx_rot.x, mtx_rot.y, mtx_rot.z))
	
	#self.set_transform(objectData.matrix.mtx)
	#self.set_position(objectData.matrix.pos)
	
	
	#self.set_global_transform(objectData.matrix.mtx)
	##self.set_transform(objectData.matrix.mtx)
	#self.transform.basis = objectData.matrix.mtx.basis
	#self.set_position(objectData.matrix.pos)
	
	self.set_transform(objectData.matrix.mtx)
	
	var old_rot : Vector3 = self.rotation_degrees
	self.rotation_degrees.x =  old_rot.x
	self.rotation_degrees.y =  -old_rot.z
	self.rotation_degrees.z =  -old_rot.y
	
	self.set_position(objectData.matrix.pos)
	
	while (file.get_position() < data_end_offset):
		var child_obj : Node = loader.read_WDBNode(file, loader)
		if (child_obj): #чтобы не было ошибок при импорте
			call_deferred("add_child", child_obj)

func appendToNormal(target : Vector3) -> Vector3:
	return (target * self.get_global_transform().basis)
	

func appendToVertex(target : Vector3) -> Vector3:
	return (target * self.get_global_transform().basis) + self.get_global_position()
	##var result : Vector3 #= target
	#result = target * self.get_global_transform().basis
	#result = target * self.get_transform().basis
	#result += self.get_global_position()
	##result = (target * self.get_global_transform().basis) + self.get_global_position()
	##return result
	##гооол!
	##return (target * objectData.matrix.mtx) + self.get_global_position()
	#return (target * objectData.matrix.mtx) + objectData.matrix.pos
	##	return target * objectData.matrix.mtx
	#return target + objectData.matrix.mtx.origin
	#return target + objectData.matrix.mtx.origin
	#return target * self.get_global_transform()
	#return target * objectData.matrix.mtx
	
	#var result : Vector3 = target
	#result = target * objectData.matrix.mtx.basis
	#result += objectData.matrix.mtx.origin
	#return result
	#var result_transform : Transform3D = self.get_transform()
	#result = target * result_transform.basis
	#применение позиции
	#result += result_transform.origin
	
	#var result_transform : Transform3D = self.get_global_transform()
	##var result_transform : Transform3D = self.get_transform()
	#result = target * result_transform.basis
	#применение позиции
	#result += self.get_position()
	
	#return result
