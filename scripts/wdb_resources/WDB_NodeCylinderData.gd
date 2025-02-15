class_name WDB_NodeCylinderData extends WDB_NodeOptData

#( Sphere opt)
var cyl : WDB_Cylinder

func LoadFromBuffer(file : StreamPeerBuffer, loader : WDB_FileLoader) -> void:
	super(file, loader)
	cyl = WDB_Cylinder.new()
	cyl.LoadFromBuffer(file)