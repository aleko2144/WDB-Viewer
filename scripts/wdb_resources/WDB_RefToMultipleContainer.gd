class_name WDB_RefToMultipleContainer extends WDB_RefContainer

#wdb.dsr description:
#( DWORD num)
#( RefToContainer refs ( (ITERATED num) ) )
#( RefToContainer dword )

var num   : int
var refs  : Array
var dword : Node

#new
var dont_process : bool
var switch_state : int = -1

func LoadFromBuffer(file : StreamPeerBuffer, loader : WDB_FileLoader) -> void:
	self.name = "RefToMultipleContainer_%s" % self.offset_hex
	tag = 204
	
	num = file.get_32()
	
	for i in range(num):
		var child_obj : Node = loader.read_WDBNode(file, loader)
		if (child_obj): #чтобы не было ошибок при импорте
			refs.append(child_obj)

	dword = loader.read_WDBNode(file, loader) 
	
	if !dword:
		dont_process = true

#func _process(_delta: float) -> void:
#	if dont_process:
#		return
	
	#if switch_state == -1:
	#	switch_state = dword.

#func initialize(scene_root : Node) -> void:
#	if Id != -1:
#		ref_obj = scene_root.getRefObject(Id)
