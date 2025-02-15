class_name WDB_ContainerPyramid extends WDB_DataContainer

#wdb.dsr description:
#( float nearPlane )
#( float farPlane )
#( float fov )
#( float aspect )

var nearPlane : float
var farPlane : float
var fov : float
var aspect : float

func LoadFromBuffer(file : StreamPeerBuffer, loader : WDB_FileLoader) -> void:
	tag = 323

	super(file, loader)
	self.name = WDB_ASCIIZ.ApplyName(self.object_name, "Pyramid_%s" % self.offset_hex)
	
	nearPlane = file.get_float()
	farPlane  = file.get_float()
	fov       = file.get_float()
	aspect    = file.get_float()
