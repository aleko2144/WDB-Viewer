class_name WDB_ContainerData extends WDB_DataContainer

func LoadFromBuffer(file : StreamPeerBuffer, loader : WDB_FileLoader) -> void:
	tag = 404

	super(file, loader)
	
	self.name = WDB_ASCIIZ.ApplyName(self.object_name, "Data_%s" % self.offset_hex)
	
	var contents_length : int = file.get_32()
	for i in range(contents_length):
		var child_obj : Node = loader.read_WDBNode(file, loader)
		if (child_obj): #чтобы не было ошибок при импорте
			self.add_child(child_obj)
