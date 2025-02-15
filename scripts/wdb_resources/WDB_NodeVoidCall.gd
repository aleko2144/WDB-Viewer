class_name WDB_NodeVoidCall extends WDB_NodeContainerChildless

var voidData: WDB_NodeVoidCallData
var initialized : bool

func LoadFromBuffer(file : StreamPeerBuffer, loader : WDB_FileLoader) -> void:
	self.name = "NodeVoidCall_%s" % self.offset_hex
	tag = 140
	#super(file, loader)
	
	#импорт data
	file.seek(file.get_position() + 8) #skip tag (1) and size
	voidData = WDB_NodeVoidCallData.new()
	voidData.LoadFromBuffer(file, loader)
	
	#while (file.get_position() < data_end_offset):
	#	var child_obj : Node = loader.read_WDBNode(file, loader)
	#	if (child_obj): #чтобы не было ошибок при импорте
	#		self.add_child(child_obj)
	#breakpoint

func initialize() -> void:
	if (voidData.node):
		var child : Node = voidData.node
		var ref : Node
		if child.tag == 201: #RefToContainer
			if (!child.ref_obj):
				return
			ref = child.ref_obj.duplicate()
			self.add_child(ref)
		
	initialized = true
