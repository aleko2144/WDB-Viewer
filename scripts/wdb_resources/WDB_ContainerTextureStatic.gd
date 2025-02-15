class_name WDB_ContainerTextureStatic extends WDB_ContainerSimpleTextureStatic

func LoadFromBuffer(file : StreamPeerBuffer, loader : WDB_FileLoader) -> void:
	super(file, loader)

	tag = 306
	self.name = "TextureStatic_%s" % self.offset_hex
	
	if (self.object_name):
		texture.resource_name = self.object_name
