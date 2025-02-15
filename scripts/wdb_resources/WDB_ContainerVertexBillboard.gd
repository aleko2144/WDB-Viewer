class_name WDB_ContainerVertexBillboard extends WDB_ContainerVertexDynamic

func LoadFromBuffer(file : StreamPeerBuffer, loader : WDB_FileLoader) -> void:
	tag = 311
	
	breakpoint
	#тут формат недописан, надо смотреть по wdb-файлу, что там хранится
	super(file, loader)
	self.name = "VertexDynamic_%s" % self.offset_hex
