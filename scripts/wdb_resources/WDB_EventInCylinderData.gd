class_name WDB_EventInCylinderData extends WDB_EventSimpleData

#wdb.dsr:
#( Cylinder	Cylinder )

var cylinder : WDB_Cylinder

func LoadFromBuffer(file : StreamPeerBuffer, loader : WDB_FileLoader) -> void:
	super(file, loader)

	cylinder = WDB_Cylinder.new()
	cylinder.LoadFromBuffer(file)
