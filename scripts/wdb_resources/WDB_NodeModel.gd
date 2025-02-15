class_name WDB_NodeModel extends WDB_NodeContainer

var data : WDB_NodeModelData

func LoadFromBuffer(file : StreamPeerBuffer, loader : WDB_FileLoader) -> void:
	self.name = "NodeModel_%s" % self.offset_hex
	tag = 123
	
	#импорт NodeModelData
	file.seek(file.get_position() + 8) #skip tag (1) and size
	data = WDB_NodeModelData.new()
	data.LoadFromBuffer(file, loader)
	
	while (file.get_position() < data_end_offset):
		var child_obj : Node = loader.read_WDBNode(file, loader)
		if (child_obj): #чтобы не было ошибок при импорте
			self.add_child(child_obj)
