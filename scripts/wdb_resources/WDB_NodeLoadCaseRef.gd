class_name WDB_NodeLoadCaseRef extends WDB_NodeContainer

var objectData : WDB_NodeLoadCaseRefData

#
var dword : Node
var dont_process : bool
var switch_value : int = -1
var prev_switch_value : int = -1
var switch_max   : int
var ref_object : Node

func LoadFromBuffer(file : StreamPeerBuffer, loader : WDB_FileLoader) -> void:
	self.name = "NodeLoadCaseRef_%s" % self.offset_hex
	tag = 146
	#super(file, loader)
	
	#импорт NodeEmptyCallData
	file.seek(file.get_position() + 8) #skip tag (1) and size
	objectData = WDB_NodeLoadCaseRefData.new()
	objectData.LoadFromBuffer(file, loader)
	
	while (file.get_position() < data_end_offset):
		var child_obj : Node = loader.read_WDBNode(file, loader)
		if (child_obj): #чтобы не было ошибок при импорте
			self.add_child(child_obj)

func initialize() -> void:
	if !self.objectData.ref.ref_obj:
		return
	
	dword = self.objectData.ref.ref_obj
	switch_value = dword.value
	
	if (switch_value > len(self.objectData.refs) - 1):
		return
	
	ref_object = self.objectData.refs[switch_value].ref_obj #.clone()
	if (ref_object):
		self.add_child(ref_object.duplicate())
		#self.add_child(ref_object.clone())

func _process_bak(_delta: float) -> void:
	if !self.objectData.ref.ref_obj:
		dont_process = true
	
	if dont_process:
		return
		
	if (prev_switch_value == -1):
		dword = self.objectData.ref.ref_obj
		
		switch_value = dword.value
		switch_max   = len(self.objectData.refs) - 1
		prev_switch_value = switch_value
		
		ref_object = self.objectData.refs[switch_value].ref_obj.clone()
		if (ref_object):
			self.add_child(ref_object.clone())
			
	switch_value = dword.value
	
	if (switch_value > switch_max):
		switch_value = switch_max
		
	if (switch_value < 0):
		switch_value = 0
	
	if (prev_switch_value != switch_value):
		prev_switch_value = switch_value
		
		if (ref_object):
			self.remove_child(ref_object)
			ref_object.queue_free()
		
		ref_object = self.objectData.refs[switch_value].ref_obj.clone()
		if (ref_object):
			self.add_child(ref_object.clone())
