class_name WDB_NodeRoom extends WDB_NodeContainer

var data : WDB_NodeRoomData

func LoadFromBuffer(file : StreamPeerBuffer, loader : WDB_FileLoader) -> void:
	self.name = "NodeRoom_%s" % self.offset_hex
	tag = 125
	
	#импорт NodeRoomData
	file.seek(file.get_position() + 8) #skip tag (1) and size
	data = WDB_NodeRoomData.new()
	data.LoadFromBuffer(file, loader)
	
	while (file.get_position() < data_end_offset):
		var child_obj : Node = loader.read_WDBNode(file, loader)
		if (child_obj): #чтобы не было ошибок при импорте
			self.add_child(child_obj)
