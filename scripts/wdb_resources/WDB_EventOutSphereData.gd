class_name WDB_EventOutSphereData extends WDB_EventSimpleData

#wdb.dsr:
#( Sphere	sphere )

var sphere2 : WDB_Sphere

func LoadFromBuffer(file : StreamPeerBuffer, loader : WDB_FileLoader) -> void:
	super(file, loader)

	sphere2 = WDB_Sphere.new()
	sphere2.LoadFromBuffer(file)
