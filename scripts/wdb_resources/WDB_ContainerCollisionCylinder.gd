class_name WDB_ContainerCollisionCylinder extends WDB_ContainerCollisionPrimitive

#wdb.dsr:
#( DWORD num )
#( Cylinder cylinders  ( ( ITERATED num ) ) ) 

var num       : int
var cylinders : Array

func LoadFromBuffer(file : StreamPeerBuffer, loader : WDB_FileLoader) -> void:
	tag = 318
	
	super(file, loader)
	self.name = "CollisionCylinder_%s" % self.offset_hex
	
	num = file.get_32()
	for i in range(num):
		var cylinder : WDB_Cylinder
		cylinder = WDB_Cylinder.new()
		cylinder.LoadFromBuffer(file)
		cylinders.append(cylinder)
