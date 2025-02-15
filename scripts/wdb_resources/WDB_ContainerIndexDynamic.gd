class_name WDB_ContainerIndexDynamic extends WDB_ContainerIndex

func LoadFromBuffer(file : StreamPeerBuffer, loader : WDB_FileLoader) -> void:
	tag = 312
	
	super(file, loader)
	self.name = "IndexDynamic_%s" % self.offset_hex
