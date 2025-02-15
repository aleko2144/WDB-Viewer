class_name WDB_ContainerDWORD extends WDB_DataContainer

var value : int

func LoadFromBuffer(file : StreamPeerBuffer, loader : WDB_FileLoader) -> void:
	tag = 321

	super(file, loader)
	value = file.get_32()
	
	self.name = WDB_ASCIIZ.ApplyName(self.object_name, "DWORD_%s" % self.offset_hex)

func initialize() -> void:
	if ('det_cab_Dword' in self.name):
		value = 1
