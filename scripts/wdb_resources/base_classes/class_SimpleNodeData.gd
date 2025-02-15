class_name WDB_SimpleNodeData extends WDB_Container

#wdb.dsr class description:
# (ASCIIZ name)
# (Sphere sphere)

var object_name : String
var sphere      : WDB_Sphere

func LoadFromBuffer(file : StreamPeerBuffer, _loader : WDB_FileLoader) -> void:
	object_name = WDB_ASCIIZ.LoadFromBuffer(file)
	sphere      = WDB_Sphere.new()
	sphere.LoadFromBuffer(file)
