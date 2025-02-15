class_name WDB_ContainerIndexStatic extends WDB_ContainerIndex

func LoadFromBuffer(file : StreamPeerBuffer, loader : WDB_FileLoader) -> void:
	tag = 313
	
	super(file, loader)
	self.name = "IndexStatic_%s" % self.offset_hex
