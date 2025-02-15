class_name WDB_ContainerCollisionPrimitive extends WDB_DataContainer

var mask : int

func LoadFromBuffer(file : StreamPeerBuffer, loader : WDB_FileLoader) -> void:
	super(file, loader)
	mask = file.get_32()
