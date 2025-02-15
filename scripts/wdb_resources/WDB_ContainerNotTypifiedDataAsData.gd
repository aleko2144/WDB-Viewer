class_name WDB_ContainerNotTypifiedDataAsData extends WDB_Container

#wdb.dsr:
#( NTData data ( PARAMETRIZED ) )

var data      : PackedByteArray
var data_size : int

func LoadFromBuffer(file : StreamPeerBuffer, loader : WDB_FileLoader) -> void:
	tag = 336
	
	self.name = "NotTypifiedDataAsData_%s" % self.offset_hex
	
	data_size = data_end_offset - file.get_position()
	data = file.get_data(data_size)[1]
