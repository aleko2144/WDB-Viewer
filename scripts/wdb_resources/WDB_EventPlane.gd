class_name WDB_EventPlane extends WDB_EventSimple

var eventData : WDB_EventPlaneData

func LoadFromBuffer(file : StreamPeerBuffer, loader : WDB_FileLoader) -> void:
	self.name = "EventPlane_%s" % self.offset_hex
	tag = 133
	
	#импорт данных
	file.seek(file.get_position() + 8) #skip tag (1) and size
	eventData = WDB_EventPlaneData.new()
	eventData.LoadFromBuffer(file, loader)
	
	while (file.get_position() < data_end_offset):
		var child_obj : Node = loader.read_WDBNode(file, loader)
		if (child_obj): #чтобы не было ошибок при импорте
			self.add_child(child_obj)
