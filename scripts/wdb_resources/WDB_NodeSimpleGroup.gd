class_name WDB_NodeSimpleGroup extends WDB_NodeContainer

var objectData : WDB_NodeSimpleGroupData

func LoadFromBuffer(file : StreamPeerBuffer, loader : WDB_FileLoader) -> void:
	self.name = "NodeSimpleGroup_%s" % self.offset_hex
	tag = 117
	
	#импорт NodeRootData
	file.seek(file.get_position() + 8) #skip tag (1) and size
	objectData = WDB_NodeSimpleGroupData.new()
	objectData.LoadFromBuffer(file, loader)
	
	while (file.get_position() < data_end_offset):
		var child_obj : Node = loader.read_WDBNode(file, loader)
		if (child_obj): #чтобы не было ошибок при импорте
			call_deferred("add_child", child_obj)
