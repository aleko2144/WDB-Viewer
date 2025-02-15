class_name WDB_ContainerSound extends WDB_DataContainer

func LoadFromBuffer(file : StreamPeerBuffer, loader : WDB_FileLoader) -> void:
	tag = 324

	super(file, loader)
	self.name = WDB_ASCIIZ.ApplyName(self.object_name, "Sound_%s" % self.offset_hex)
