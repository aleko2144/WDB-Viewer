class_name WDB_EventObject extends WDB_NodeContainerChildless

var objectData : WDB_EventObjectData

func LoadFromBuffer(file : StreamPeerBuffer, loader : WDB_FileLoader) -> void:
	self.name = "EventObject_%s" % self.offset_hex
	tag = 134
	
	#импорт NodeRootData
	file.seek(file.get_position() + 8) #skip tag (1) and size
	objectData = WDB_EventObjectData.new()
	objectData.LoadFromBuffer(file, loader)
	
	for i in range(objectData.NumOfEntries):
		var child_obj : Node = loader.read_WDBNode(file, loader)
		if (child_obj): #чтобы не было ошибок при импорте
			call_deferred("add_child", child_obj)
