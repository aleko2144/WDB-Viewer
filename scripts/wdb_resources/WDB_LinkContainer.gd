class_name WDB_LinkContainer extends WDB_Container

#wdb.dsr description:
#( DWORD n)
#( Container v ( (ITERATED n) NONAME) )
var n : int

func LoadFromBuffer(file : StreamPeerBuffer, loader : WDB_FileLoader) -> void:
	self.name = "LinkContainer_%s" % self.offset_hex
	tag       = 2
	n         = file.get_32()
	
	for k in range(n):
		var child_obj : Node = loader.read_WDBNode(file, loader)
		if (child_obj): #чтобы не было ошибок при импорте
			self.add_child(child_obj)
