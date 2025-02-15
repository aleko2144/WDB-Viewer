class_name WDB_ContainerVertexStatic extends WDB_ContainerVertex

func LoadFromBuffer(file : StreamPeerBuffer, loader : WDB_FileLoader) -> void:
	tag = 310
	
	super(file, loader)
	self.name = "VertexStatic_%s" % self.offset_hex
