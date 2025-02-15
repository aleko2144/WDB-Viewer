class_name WDB_NodeLocalObjectGroup extends WDB_Container

var data : WDB_LocalObjectGroupData

func LoadFromBuffer(file : StreamPeerBuffer, loader : WDB_FileLoader) -> void:
	tag = 142
	
	self.name = "NodeLocalObjectGroup_%s" % self.offset_hex
	
	#импорт данных
	file.seek(file.get_position() + 8) #skip tag (1) and size
	data = WDB_LocalObjectGroupData.new()
	data.LoadFromBuffer(file, loader)
