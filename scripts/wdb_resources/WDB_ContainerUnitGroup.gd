class_name WDB_ContainerUnitGroup extends WDB_DataContainer

func LoadFromBuffer(file : StreamPeerBuffer, loader : WDB_FileLoader) -> void:
	tag = 403
	
	super(file, loader)
	self.name = WDB_ASCIIZ.ApplyName(self.object_name, "UnitGroup_%s" % self.offset_hex)
	
	var contents_length : int = file.get_32()
	for i in range(contents_length):
		var child_obj : Node = loader.read_WDBNode(file, loader)
		if (child_obj): #чтобы не было ошибок при импорте
			call_deferred("add_child", child_obj)
