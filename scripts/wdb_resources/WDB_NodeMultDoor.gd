class_name WDB_NodeMultDoor extends WDB_Container

var data : WDB_NodeMultDoorData

func LoadFromBuffer(file : StreamPeerBuffer, loader : WDB_FileLoader) -> void:
	tag = 141
	
	self.name = "NodeMultDoor_%s" % self.offset_hex
	
	#импорт данных
	file.seek(file.get_position() + 8) #skip tag (1) and size
	data = WDB_NodeMultDoorData.new()
	data.LoadFromBuffer(file, loader)
