class_name WDB_ContainerNotTypifiedData extends WDB_DataContainer

#wdb.dsr:
#( NTData data ( PARAMETRIZED ) )

var data      : PackedByteArray
var data_size : int

func LoadFromBuffer(file : StreamPeerBuffer, loader : WDB_FileLoader) -> void:
	tag = 322
	
	super(file, loader)
	#self.name = "NotTypifiedData_%s" % self.offset_hex
	self.name = WDB_ASCIIZ.ApplyName(self.object_name, "NotTypifiedData_%s" % self.offset_hex)
	
	data_size = data_end_offset - file.get_position()
	data = file.get_data(data_size)[1]
