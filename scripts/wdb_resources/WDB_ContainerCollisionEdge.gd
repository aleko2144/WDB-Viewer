class_name WDB_ContainerCollisionEdge extends WDB_ContainerCollisionPrimitive

#wdb.dsr:
#( DWORD num )
#( DWORD collision_edge_flag ( ( MNEMONICS "FEEF_*" ) ) )
#( CollisionEdge edges ( PARAMETRIZED ( ITERATED num ) ) )

var num                 : int
var collision_edge_flag : int
var edges               : Array

func LoadFromBuffer(file : StreamPeerBuffer, loader : WDB_FileLoader) -> void:
	tag = 330
	
	super(file, loader)
	self.name = "ContainerCollisionEdge_%s" % self.offset_hex
	
	num                 = file.get_32()
	collision_edge_flag = file.get_32()
	
	for i in range(num):
		edges.append([file.get_u16(), file.get_u16()])
