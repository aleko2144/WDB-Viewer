class_name WDB_ContainerSimpleTextureStatic extends WDB_ContainerSimpleTexture

func LoadFromBuffer(file : StreamPeerBuffer, loader : WDB_FileLoader) -> void:
	super(file, loader)

	tag = 305
	self.name = "SimpleTextureStatic_%s" % self.offset_hex
