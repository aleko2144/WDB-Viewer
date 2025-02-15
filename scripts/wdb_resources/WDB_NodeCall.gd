class_name WDB_NodeCall extends WDB_NodeContainerChildless

var voidData: WDB_NodeCallData
var initialized : bool

func LoadFromBuffer(file : StreamPeerBuffer, loader : WDB_FileLoader) -> void:
	self.name = "NodeCall_%s" % self.offset_hex
	tag = 122
	#super(file, loader)
	
	#импорт data
	file.seek(file.get_position() + 8) #skip tag (1) and size
	voidData = WDB_NodeCallData.new()
	voidData.LoadFromBuffer(file, loader)
	
	#while (file.get_position() < data_end_offset):
	#	var child_obj : Node = loader.read_WDBNode(file, loader)
	#	if (child_obj): #чтобы не было ошибок при импорте
	#		call_deferred("add_child", child_obj)
	#breakpoint

func initialize(disableAutoSpace : bool) -> void:
	if (voidData.node):
		var child : Node = voidData.node
		var ref : Node
		if child.tag == 201: #RefToContainer
			if (!child.ref_obj):
				return
			ref = child.ref_obj.duplicate()
			##ref = child.ref_obj.call_deferred("duplicate")
			call_deferred("add_child", ref)

			if (!voidData.space.ref_obj):
				return
			
			if (!disableAutoSpace):
				var space_obj : Node = voidData.space.ref_obj
				var target_transform #: Transform3D
				
				#заглушка, нужно переделывать
				#до внедрения многопоточности работало нормально
				target_transform = space_obj.call_deferred('get_global_transform')
				if (target_transform != null):
					print(target_transform)
					ref.call_deferred('set_global_transform', target_transform)
				else:
					target_transform = space_obj.global_transform
					ref.global_transform = target_transform
				
				#target_transform = space_obj.call_deferred_thread_group('call_deferred')
				
				#target_transform = space_obj.call_deferred('get_global_transform')
				#ref.call_deferred('set_global_transform', target_transform)
				
				#target_transform = space_obj.call_deferred_thread_group('get_global_transform')
				#ref.call_deferred_thread_group('set_global_transform', target_transform)
				
				#приемлемо для игрового мира, но не для грузовиков
				##if (space_obj):
				#target_transform = space_obj.global_transform
				#ref.global_transform = target_transform
				
				#target_transform = voidData.space.ref_obj.call_deferred('get_global_transform')
				#ref.call_deferred('set_global_transform', target_transform)
				
				#ref.set_global_transform(voidData.space.ref_obj.get_global_transform())
		
	initialized = true
