class_name WDB_ContainerCollisionPlane extends WDB_ContainerCollisionPrimitive

#wdb.dsr:
#( DWORD num )
#( Plane planes  ( ( ITERATED num ) ) )

var num    : int
var planes : Array

func LoadFromBuffer(file : StreamPeerBuffer, loader : WDB_FileLoader) -> void:
	tag = 317
	
	super(file, loader)
	self.name = "CollisionPlane_%s" % self.offset_hex
	
	num = file.get_32()
	for i in range(num):
		planes.append(VectorUtils.LoadDVec4FromBuffer(file))
