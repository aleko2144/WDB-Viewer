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
	#		self.add_child(child_obj)
	#breakpoint

func initialize(disableAutoSpace : bool) -> void:
	if (voidData.node):
		var child : Node = voidData.node
		var ref : Node
		if child.tag == 201: #RefToContainer
			if (!child.ref_obj):
				return
			ref = child.ref_obj.duplicate()
			self.add_child(ref)

			if (!voidData.space.ref_obj):
				return
			
			if (!disableAutoSpace):
				ref.set_global_transform(voidData.space.ref_obj.get_global_transform())
		
	initialized = true
