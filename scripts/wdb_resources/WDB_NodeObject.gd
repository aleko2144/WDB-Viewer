class_name WDB_NodeObject extends WDB_Object #WDB_NodeContainerChildless

var objectData : WDB_NodeObjectData

var meshData : WDB_MeshConstructor

func LoadFromBuffer(file : StreamPeerBuffer, loader : WDB_FileLoader) -> void:
	#super(file, loader)
	self.name = "NodeObject_%s" % self.offset_hex
	tag = 115
	
	#импорт NodeModelData
	file.seek(file.get_position() + 8) #skip tag (1) and size
	objectData = WDB_NodeObjectData.new()
	objectData.LoadFromBuffer(file, loader)
	
	for i in range(objectData.NumOfEntries):
		var child_obj : Node = loader.read_WDBNode(file, loader)
		if (child_obj): #чтобы не было ошибок при импорте
			self.add_child(child_obj)

func initialize(scene_root : Node, debug_meshes : bool, disableMeshesBindex : bool) -> void:
	meshData = WDB_MeshConstructor.new()
	meshData.initialize(self, scene_root)
	var mesh_obj : Node = meshData.createMesh(debug_meshes, disableMeshesBindex)
	#scene_root.mesh_nodes.append(mesh_obj)
	#for child in self.get_children():
	#	if child.tag == 202: #RefToSelfContainer
