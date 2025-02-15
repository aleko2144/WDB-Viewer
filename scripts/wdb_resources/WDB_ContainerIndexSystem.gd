class_name WDB_ContainerIndexSystem extends WDB_ContainerIndex

func LoadFromBuffer(file : StreamPeerBuffer, loader : WDB_FileLoader) -> void:
	tag = 338
	
	super(file, loader)
	self.name = "IndexSystem_%s" % self.offset_hex
