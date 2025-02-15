class_name WDB_ContainerSimpleTextureDynamic extends WDB_ContainerSimpleTexture

func LoadFromBuffer(file : StreamPeerBuffer, loader : WDB_FileLoader) -> void:
	super(file, loader)

	tag = 325
	self.name = "SimpleTextureDynamic_%s" % self.offset_hex
