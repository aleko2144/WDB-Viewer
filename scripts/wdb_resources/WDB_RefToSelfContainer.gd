class_name WDB_RefToSelfContainer extends WDB_RefContainer

var data : Node

func LoadFromBuffer(file : StreamPeerBuffer, loader : WDB_FileLoader) -> void:
	self.name = "RefToSelfContainer_%s" % self.offset_hex
	tag = 202

	data = loader.read_WDBNode(file, loader)
	
	#var child_obj : Node = loader.read_WDBNode(file, loader)
	#if (child_obj): #чтобы не было ошибок при импорте
	#	self.add_child(child_obj)
