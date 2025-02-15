class_name WDB_ContainerCollisionTriangleEdge extends WDB_ContainerCollisionPrimitive

#wdb.dsr:
#( DWORD num )
#( DWORD edge_num )
#( DWORD faceIndex ( PARAMETRIZED ( ITERATED edge_num ) ) )
#( DWORD collision_edge_flag ( ( MNEMONICS "FEEF_*" ) ) )
#( CollisionEdge edges ( PARAMETRIZED ( ITERATED num ) ) )

var num                 : int
var edge_num            : int
var faceIndex           : Array
var collision_edge_flag : int
var edges               : Array

func LoadFromBuffer(file : StreamPeerBuffer, loader : WDB_FileLoader) -> void:
	tag = 331
	
	super(file, loader)
	self.name = "CollisionTriangleEdge_%s" % self.offset_hex
	
	num                 = file.get_32()
	edge_num            = file.get_32()
	
	for i in range(edge_num):
		faceIndex.append(file.get_32())
		
	collision_edge_flag = file.get_32()
	
	for i in range(num):
		edges.append([file.get_u16(), file.get_u16()])
