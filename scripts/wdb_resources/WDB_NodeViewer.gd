class_name WDB_NodeViewer extends WDB_NodeContainer

var objectData : WDB_NodeViewerData

func LoadFromBuffer(file : StreamPeerBuffer, loader : WDB_FileLoader) -> void:
	self.name = "NodeViewer_%s" % self.offset_hex
	tag = 119

	#импорт NodeViewerData
	file.seek(file.get_position() + 8) #skip tag (1) and size
	objectData = WDB_NodeViewerData.new()
	objectData.LoadFromBuffer(file, loader)

	while (file.get_position() < data_end_offset):
		var child_obj : Node = loader.read_WDBNode(file, loader)
		if (child_obj): #чтобы не было ошибок при импорте
			call_deferred("add_child", child_obj)
