class_name WDB_ContainerNodeFunction extends WDB_DataContainer

#wdb.dsr:
#( DWORD flag )
#( DWORD num_ref )
#( Ref refs ( (ITERATED num_ref) ) )
#( ContainerNotTypifiedDataAsData data )

var flag    : int
var num_ref : int
var refs    : Array
var data    : Node

func LoadFromBuffer(file : StreamPeerBuffer, loader : WDB_FileLoader) -> void:
	tag = 337
	
	super(file, loader)
	self.name = WDB_ASCIIZ.ApplyName(self.object_name, "NodeFunction_%s" % self.offset_hex)
	
	flag = file.get_32()
	num_ref = file.get_32()
	
	for i in range(num_ref):
		var child_obj : Node = loader.read_WDBNode(file, loader)
		if (child_obj): #чтобы не было ошибок при импорте
			refs.append(child_obj)
			
	data = loader.read_WDBNode(file, loader)
	
	
