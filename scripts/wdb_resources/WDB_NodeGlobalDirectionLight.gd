class_name WDB_NodeGlobalDirectionLight extends WDB_NodeGlobalLight

var lightData : WDB_NodeGlobalDirectionLightData

func LoadFromBuffer(file : StreamPeerBuffer, loader : WDB_FileLoader) -> void:
	self.name = "NodeGlobalDirectionLight_%s" % self.offset_hex
	tag = 114

	#импорт данных
	file.seek(file.get_position() + 8) #skip tag (1) and size
	lightData = WDB_NodeGlobalDirectionLightData.new()
	lightData.LoadFromBuffer(file, loader)

	while (file.get_position() < data_end_offset):
		var child_obj : Node = loader.read_WDBNode(file, loader)
		if (child_obj): #чтобы не было ошибок при импорте
			self.add_child(child_obj)
