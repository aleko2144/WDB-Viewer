class_name WDB_ContainerVIPM2Operation extends WDB_DataContainer

#wdb.dsr description:
#( DWORD num )
#( WORD data ( ( ITERATED num ) ) )

var num_data : int
var data     : Array

func LoadFromBuffer(file : StreamPeerBuffer, loader : WDB_FileLoader) -> void:
	tag = 341
	
	super(file, loader)
	self.name = "VIPM2Operation_%s" % self.offset_hex

	num_data = file.get_32()
	
	for i in range(num_data):
		data.append(file.get_u16())
