class_name WDB_NodeCaseRefMaskD extends WDB_NodeCase

var objectData : WDB_NodeCaseRefMaskDData

func LoadFromBuffer(file : StreamPeerBuffer, loader : WDB_FileLoader) -> void:
	self.name = "NodeCaseRefMaskD_%s" % self.offset_hex
	tag = 145
	
	#импорт NodeCaseRefMaskDData
	file.seek(file.get_position() + 8) #skip tag (1) and size
	objectData = WDB_NodeCaseRefMaskDData.new()
	objectData.LoadFromBuffer(file, loader)
	
	while (file.get_position() < data_end_offset):
		var child_obj : Node = loader.read_WDBNode(file, loader)
		if (child_obj): #чтобы не было ошибок при импорте
			self.add_child(child_obj)
