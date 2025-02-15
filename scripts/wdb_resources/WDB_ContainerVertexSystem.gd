class_name WDB_ContainerVertexSystem extends WDB_ContainerVertex

func LoadFromBuffer(file : StreamPeerBuffer, loader : WDB_FileLoader) -> void:
	tag = 339
	
	super(file, loader)
	self.name = "VertexSystem_%s" % self.offset_hex
