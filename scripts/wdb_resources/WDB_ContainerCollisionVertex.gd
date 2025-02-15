class_name WDB_ContainerCollisionVertex extends WDB_ContainerCollisionPrimitive

#wdb.dsr:
#( DWORD		num )
#( DWORD		event_vertex_flag ( ( MNEMONICS "FEVF_*" ) ) )
#( CollisionVertex vertices ( PARAMETRIZED ( ITERATED num ) ) )

var num               : int
var event_vertex_flag : int
var vertices          : Array

func LoadFromBuffer(file : StreamPeerBuffer, loader : WDB_FileLoader) -> void:
	tag = 315
	
	super(file, loader)
	self.name = "CollisionVertex_%s" % self.offset_hex
	
	num = file.get_32()
	event_vertex_flag = file.get_32()
	
	for i in range(num):
		vertices.append(VectorUtils.LoadDVec3FromBuffer(file))
