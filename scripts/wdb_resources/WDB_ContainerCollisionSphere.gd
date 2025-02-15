class_name WDB_ContainerCollisionSphere extends WDB_ContainerCollisionPrimitive

#wdb.dsr:
#( DWORD num )
#( Sphere spheres  ( ( ITERATED num ) ) ) 

var num     : int
var spheres : Array

func LoadFromBuffer(file : StreamPeerBuffer, loader : WDB_FileLoader) -> void:
	tag = 319
	
	super(file, loader)
	self.name = "CollisionSphere_%s" % self.offset_hex
	
	num = file.get_32()
	for i in range(num):
		var sphere : WDB_Sphere
		sphere = WDB_Sphere.new()
		sphere.LoadFromBuffer(file)
		spheres.append(sphere)
