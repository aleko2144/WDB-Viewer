class_name WDB_ContainerCollisionPolygon extends WDB_ContainerCollisionPrimitive

#wdb.dsr:
#( DWORD num )
#( DWORD event_polygon_flag ( ( MNEMONICS "FEPF_*" ) ) )
#( CollisionPolygon polygons ( PARAMETRIZED ( ITERATED num ) ) )

var num                : int
var event_polygon_flag : int
var polygons           : Array

func LoadFromBuffer(file : StreamPeerBuffer, loader : WDB_FileLoader) -> void:
	tag = 316
	
	super(file, loader)
	self.name = "CollisionPolygon_%s" % self.offset_hex
	
	num = file.get_32()
	event_polygon_flag = file.get_32()
	
	for i in range(num):
		polygons.append([file.get_u16(), file.get_u16(), file.get_u16(), VectorUtils.LoadDVec3FromBuffer(file)])
