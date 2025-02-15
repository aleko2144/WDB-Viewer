class_name WDB_NodeGlobalPointLight extends WDB_NodeGlobalLight

var lightData : WDB_NodeGlobalPointLightData

func LoadFromBuffer(file : StreamPeerBuffer, loader : WDB_FileLoader) -> void:
	self.name = "NodeGlobalPointLight_%s" % self.offset_hex
	tag = 113

	#импорт данных
	file.seek(file.get_position() + 8) #skip tag (1) and size
	lightData = WDB_NodeGlobalPointLightData.new()
	lightData.LoadFromBuffer(file, loader)

	while (file.get_position() < data_end_offset):
		var child_obj : Node = loader.read_WDBNode(file, loader)
		if (child_obj): #чтобы не было ошибок при импорте
			self.add_child(child_obj)
