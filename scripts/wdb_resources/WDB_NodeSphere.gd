class_name WDB_NodeSphere extends WDB_NodeOpt

var objectData : WDB_NodeSphereData

func LoadFromBuffer(file : StreamPeerBuffer, loader : WDB_FileLoader) -> void:
	self.name = "NodeSphere_%s" % self.offset_hex
	tag = 105
	
	#импорт данных
	file.seek(file.get_position() + 8) #skip tag (1) and size
	objectData = WDB_NodeSphereData.new()
	objectData.LoadFromBuffer(file, loader)
	
	while (file.get_position() < data_end_offset):
		var child_obj : Node = loader.read_WDBNode(file, loader)
		if (child_obj): #чтобы не было ошибок при импорте
			self.add_child(child_obj)
