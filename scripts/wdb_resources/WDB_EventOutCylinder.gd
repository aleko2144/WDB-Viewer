class_name WDB_EventOutCylinder extends WDB_EventSimple

var eventData : WDB_EventOutCylinderData

func LoadFromBuffer(file : StreamPeerBuffer, loader : WDB_FileLoader) -> void:
	self.name = "EventOutCylinder_%s" % self.offset_hex
	tag = 130
	
	#импорт данных
	file.seek(file.get_position() + 8) #skip tag (1) and size
	eventData = WDB_EventOutCylinderData.new()
	eventData.LoadFromBuffer(file, loader)
	
	while (file.get_position() < data_end_offset):
		var child_obj : Node = loader.read_WDBNode(file, loader)
		if (child_obj): #чтобы не было ошибок при импорте
			call_deferred("add_child", child_obj)
