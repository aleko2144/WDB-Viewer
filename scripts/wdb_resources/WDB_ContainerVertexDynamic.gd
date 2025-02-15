class_name WDB_ContainerVertexDynamic extends WDB_ContainerVertex

func LoadFromBuffer(file : StreamPeerBuffer, loader : WDB_FileLoader) -> void:
	tag = 309
	
	super(file, loader)
	self.name = "VertexDynamic_%s" % self.offset_hex
