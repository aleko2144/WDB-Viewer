class_name WDB_BackRefContainer extends WDB_Container

#wdb.dsr description:
#(	DWORD		id )
var id : int

func LoadFromBuffer(file : StreamPeerBuffer, _loader : WDB_FileLoader) -> void:
	self.name = "BackRefContainer_%s" % self.offset_hex
	tag       = 3
	id        = file.get_32()
