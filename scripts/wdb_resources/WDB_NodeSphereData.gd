class_name WDB_NodeSphereData extends WDB_NodeOptData

#( Sphere opt)
var opt : WDB_Sphere

func LoadFromBuffer(file : StreamPeerBuffer, loader : WDB_FileLoader) -> void:
	super(file, loader)
	opt = WDB_Sphere.new()
	opt.LoadFromBuffer(file)
