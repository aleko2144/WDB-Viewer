class_name WDB_NodeEmptyCall extends WDB_NodeContainerChildless

var callData : WDB_NodeEmptyCallData
var initialized : bool

func LoadFromBuffer(file : StreamPeerBuffer, loader : WDB_FileLoader) -> void:
	self.name = "NodeEmptyCall_%s" % self.offset_hex
	tag = 143
	#super(file, loader)
	
	#импорт NodeEmptyCallData
	file.seek(file.get_position() + 8) #skip tag (1) and size
	callData = WDB_NodeEmptyCallData.new()
	callData.LoadFromBuffer(file, loader)
	
	#while (file.get_position() < data_end_offset):
	#	var child_obj : Node = loader.read_WDBNode(file, loader)
	#	if (child_obj): #чтобы не было ошибок при импорте
	#		call_deferred("add_child", child_obj)
	#breakpoint

func initialize() -> void:
	if (callData.node):
		var child : Node = callData.node
		var ref : Node
		if child.tag == 201: #RefToContainer
			if (!child.ref_obj):
				return
			#ref = child.ref_obj.preload().instance()
			##ref = child.ref_obj.call_deferred("duplicate")
			ref = child.ref_obj.duplicate()
			#ref = child.ref_obj.clone()
			#ref = child.ref_obj.duplicate(DuplicateFlags.DUPLICATE_USE_INSTANTIATION)
			call_deferred("add_child", ref)
		
		#elif child.tag == 204: #RefToContainer
		#	if (!child.ref_obj):
		#		return
		#	#ref = child.ref_obj.preload().instance()
		#	ref = child.ref_obj.clone()
		#	#ref = child.ref_obj.duplicate(DuplicateFlags.DUPLICATE_USE_INSTANTIATION)
		#	call_deferred("add_child", ref)
			
		#if child.tag == 143:
		#	if !child.initialized:
		#		child.initialize()
		
	initialized = true
