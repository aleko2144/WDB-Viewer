class_name WDB_DataContainer extends WDB_Container

#wdb.dsr class description:
# (ASCIIZ name)

var object_name : String

func LoadFromBuffer(file : StreamPeerBuffer, _loader : WDB_FileLoader) -> void:
	object_name = WDB_ASCIIZ.LoadFromBuffer(file)
	#print("loaded name=%s" % object_name)
