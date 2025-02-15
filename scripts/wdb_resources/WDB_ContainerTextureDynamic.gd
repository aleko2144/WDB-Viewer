class_name WDB_ContainerTextureDynamic extends WDB_ContainerSimpleTextureDynamic

func LoadFromBuffer(file : StreamPeerBuffer, loader : WDB_FileLoader) -> void:
	super(file, loader)

	tag = 326
	self.name = "TextureDynamic_%s" % self.offset_hex
	
	if (self.object_name):
		texture.resource_name = self.object_name
