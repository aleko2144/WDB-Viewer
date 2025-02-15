class_name WDBClass extends WDB_Object

var nodes_list    : Array #все объекты WDB-файла
var unit_nodes    : Array #объекты внутри ContainerUnitGroup
var data_nodes    : Array #объекты внутри ContainerData
var ref_table     : Node  #таблица объектов для RefToContainer

var object_nodes   : Array #объекты NodeObject
var refToCnt_nodes : Array #объекты RefToContainer
var refToMtp_nodes : Array #объекты RefToMultiple
var material_nodes : Array #объекты ContainerMaterial
var LOD_nodes      : Array #объекты NodeLevelOfDetail
var group_nodes    : Array #объекты NodeSimpleGroup
var switch_nodes   : Array #объекты NodeCaseRefSwitch
var caseRef_nodes  : Array #объекты NodeLoadCaseRef
var posCall_nodes  : Array #объекты NodeCall (с позиционированием)
var call_nodes     : Array #объекты NodeCall (без позиционирования)
var viewer_nodes   : Array #объекты NodeViewer
var function_nodes : Array #объекты NodeFunction
var dword_nodes    : Array #объекты ContainerDWORD
#var texture_nodes  : Array #объекты 
#var drawing_nodes  : Array #объекты DrawPrimitive
#var vertex_nodes  : Array #объекты VertexContainer
#var index_nodes   : Array #объекты IndexContainer

#var mesh_nodes : Array
var meshes_list : Array #объекты MeshInstance (создаются Godot)

var hideAfterInit    : bool
var removeAfterInit  : bool
var disableAutoSpace : bool

func new() -> void:
	tag = 541213783
	
func LoadFromFile(file : StreamPeerBuffer, loader : WDB_FileLoader) -> void:
	#var header = WDB_Header.new()
	#self.add_child(header)
	
	#header.LoadFromFile(file)
	
	size   = file.get_32()
	offset = file.get_position() - 8
	offset_hex = ("%x" % offset).to_upper()
	data_end_offset = offset + size
	
	while (file.get_position() < data_end_offset):
		var child_obj : Node = loader.read_WDBNode(file, loader)
		if (child_obj): #чтобы не было ошибок при импорте
			self.add_child(child_obj)

#возвращает объект из ContainerRefTable1
func getRefObjectById(id : int) -> Object:
	return ref_table.getObjectByID(id)
	
func getRefObjectByName(reference : String) -> Object:
	return ref_table.getObjectByName(reference)

func addRefSearchQuery(reference : String, sender : Node) -> void:
	get_parent().reference_search_queries_list.append([reference, sender])
	
func searchMaterial(mtl_name : String) -> Object:
	return get_parent().searchMaterial(mtl_name)

func initializeReferences() -> void:
	pass

func initializeScene(hide_LOD : bool, debug_meshes : bool, init_caseRefSwitch : bool, debug_materials : bool) -> void:
	ref_table.initialize(self)
	
	if (hide_LOD):
		for dword in dword_nodes:
			dword.initialize()
	
	for obj in refToCnt_nodes:
		obj.initialize(self)
		
	#for obj in refToMtp_nodes:
	#	obj.initialize(self)
	
	for obj in material_nodes:
		obj.initialize(self, debug_materials)
	
	for nodeObject in object_nodes:
		nodeObject.initialize(self, debug_meshes, disableAutoSpace)
		#nodeObject.visible = false
		
	for caseRef in caseRef_nodes:
		caseRef.initialize()
		
	for nodeCall in posCall_nodes:
		nodeCall.initialize(disableAutoSpace)
		
	for nodeCall in call_nodes:
		nodeCall.initialize()
		
	#прячет все объекты в NodeCaseRefSwitch, кроме первого
	#breakpoint
	if (init_caseRefSwitch):
		for nodeCase in switch_nodes:
			var nodeCase_obj_cnt : int = nodeCase.get_child_count()
			for i in range(nodeCase_obj_cnt):
				nodeCase.get_child(i).visible = false
			nodeCase.get_child(0).visible = true
			
	
	#прячет все объекты в NodeLevelOfDetail, кроме последнего,
	#который содержит дочерние элементы
	if (hide_LOD):
		for LOD_container in LOD_nodes:
			var LOD_obj_cnt : int = LOD_container.get_child_count()
			for i in range(LOD_obj_cnt):
				LOD_container.get_child(i).visible = false
				
			var iter : int = LOD_obj_cnt - 1
			while true:
				var child_obj : Node = LOD_container.get_child(iter)
				if child_obj.get_child_count():
					child_obj.visible = true
					break
				if (iter - 1 < 0):
					break
				else:
					iter -= 1
			
	if (!disableAutoSpace):
		for group in group_nodes:
			var ref_node : Node = group.objectData.space
			#breakpoint
			if (!ref_node):
				break
			if (ref_node.tag == 201): #RefToContainer
				var space_node : Node = ref_node.ref_obj
				#group.set_transform(space_node.get_transform())
				group.set_global_transform(space_node.get_global_transform())
		
	#for caseRef in caseRef_nodes:
	#	caseRef.initialize()
		
	#for nodeCall in posCall_nodes:
	#	nodeCall.initialize(disableAutoSpace)
		
	#for nodeCall in call_nodes:
	#	nodeCall.initialize()

func clearArrays() -> void:
	nodes_list.resize(0)
	unit_nodes.resize(0)
	data_nodes.resize(0)

	LOD_nodes.resize(0)
	group_nodes.resize(0)
	call_nodes.resize(0)
	posCall_nodes.resize(0)
	function_nodes.resize(0)
	
func afterInit() -> void:
	clearArrays()
	getChildMeshes(self)

func getChildMeshes(n_parent : Node) -> void:
	for child in n_parent.get_children():
		if child.visible:
			if child.is_class("MeshInstance3D"):
				meshes_list.append([child, child.get_global_transform()])
			getChildMeshes(child)

func optimizeScene() -> void:
	#getChildMeshes(self)
	
	var mesh_container : Node3D = Node3D.new()
	mesh_container.name = "meshes_container"
	self.add_child(mesh_container)
	
	for obj in meshes_list:
		var original_transform : Transform3D = obj[1]
		obj[0].get_parent().remove_child(obj[0])
		mesh_container.add_child(obj[0])
		obj[0].set_global_transform(original_transform)
		
	for i in range(self.get_child_count() - 1):
		self.get_child(i).queue_free()

func exportAsGLTF(export_path : String) -> void:
	if (!len(meshes_list)):
		return
	
	export_path = export_path + self.name + '/'
	
	#чтобы при импорте gltf положение объекта
	#соответствовало WDB, а не Godot
	self.rotation_degrees.y = 180
	
	var gltf : GLTFDocument = GLTFDocument.new()
	var gltf_state : GLTFState = GLTFState.new()

	gltf.append_from_scene(self, gltf_state)

	var dir_access : DirAccess = DirAccess.open(".")
	var path_check : bool = dir_access.dir_exists(export_path)
	
	#print(export_path)
	#print(path_check)
	#return

	if (!path_check):
		dir_access.make_dir(export_path)
	
	var file_name : String = '%s.gltf' % self.name
	export_path += file_name
	
	gltf.write_to_filesystem(gltf_state, export_path)

	self.rotation_degrees.y = 0
	
func exportAsObj(export_path : String) -> void:
	if (!len(meshes_list)):
		return
	
	export_path = export_path + self.name + '/'
	
	#чтобы при импорте gltf положение объекта
	#соответствовало WDB, а не Godot
	self.rotation_degrees.y = 180

	var dir_access : DirAccess = DirAccess.open(".")
	var path_check : bool = dir_access.dir_exists(export_path)

	if (!path_check):
		dir_access.make_dir(export_path)
		
	path_check = dir_access.dir_exists(export_path + '/txr/')
	if (!path_check):
		dir_access.make_dir(export_path + '/txr/')
		
	var mtl_exporter : wdb2mtl = wdb2mtl.new()
	var obj_exporter : wdb2obj = wdb2obj.new()
	
	mtl_exporter.initialize(export_path, self.name)
	obj_exporter.initialize(export_path, self.name)
	
	for mesh in meshes_list:
		mtl_exporter.addMaterial(obj_exporter.exportObj(mesh))
	
	mtl_exporter.exportMtl()
	
	#breakpoint
	
	#var file_name : String = '%s.gltf' % self.name
	#export_path += file_name

	self.rotation_degrees.y = 0
