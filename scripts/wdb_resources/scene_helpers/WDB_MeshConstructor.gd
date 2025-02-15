class_name WDB_MeshConstructor

var material_name  : String #имя используемого материала
var drawing_node     : Node #узел, вызывающий отрисовку
var vertex_container : Node #контейнер вершин
var index_container  : Node #контейнер индексов
var VIPM_container   : Node #контейнер с данными VIPM
var bones_container  : Node #контейнер с локаторами bones
var material_object  : Node #контейнер материала
var object_type      : int  #тип объекта (из NodeObject)
var object_flag      : int  #флаг объекта (из NodeObject)

var parent_node      : Node #родительский NodeObject
var scene_root       : Node #контейнер всей wdb-сцены

func initialize(target : Node, scn_root : Node) -> void:
	object_type = target.objectData.objectType
	object_flag = target.objectData.objectFlag
	for child in target.get_children():
		if child.tag == 201: #RefToContainer
			if child.Id == -1:
				material_name = child.reference
			else:
				var ref_obj : Node = child.ref_obj
				if ref_obj.tag == 309 or ref_obj.tag == 310 or ref_obj.tag == 311 or ref_obj.tag == 339:
					vertex_container = ref_obj
				elif ref_obj.tag == 314 or ref_obj.tag == 340:
					VIPM_container = ref_obj
				elif ref_obj.tag == 312 or ref_obj.tag == 313 or ref_obj.tag == 338:
					index_container = ref_obj

		if child.tag == 202: #RefToSelfContainer
			if !drawing_node:
				drawing_node = child.data #ContainerDrawPrimitive
			elif drawing_node.tag != 327 and drawing_node.tag != 328:
				drawing_node = null
				
			if child.data.tag == 329: #ContainerBonesRef
				bones_container = child.data
				#breakpoint
				
			#breakpoint
	
	parent_node = target
	scene_root  = scn_root


func createMesh(debug_meshes : bool, disableBindex : bool) -> Node:
	#print("create mesh")
	var use_index = true
	if !vertex_container:
		breakpoint
		return
	if !index_container:
		use_index = false
		#breakpoint
		#return
	#else:
	#	return
	
	#if !bones_container:
	#	print("!ContainerBonesRef")
	
	if !drawing_node:
		breakpoint
		return
	if drawing_node.tag != 327 and drawing_node.tag != 328:
		#breakpoint
		return
	
	#костыль чтобы не импортировать остекление самолёта
	#if !drawing_node.baseIndex:
	#	return
	
	#костыль чтобы не импортировать фюзеляж самолёта
	#if drawing_node.baseIndex:
	#	return
	
	var debug : bool = false
	var MeshNode : MeshInstance3D = MeshInstance3D.new()
	MeshNode.name = parent_node.name + '_mesh'
	MeshNode.mesh = ArrayMesh.new()
	
	#327 тоже бывает, см. Freight_Sport
	#if drawing_node.tag == 328:
	#	pass
	
	var verts   : PackedVector3Array #verts_node.vertex_data
	var col_dif : PackedColorArray   #массив цветов вершин
	var col_spe : PackedColorArray   #массив цветов вершин
	var v_bidx  : PackedInt32Array   #массив bindex
	#var v_bones : PackedInt32Array   #bones модели
	var UV_data : PackedVector2Array #verts_node.uv_data
	var normals : PackedVector3Array #verts_node.normals_data
	var indices : PackedInt32Array  
	var surface_data : Array
	surface_data.resize(Mesh.ARRAY_MAX)
	
	var verts_start_idx : int = 0 #drawing_node.startNumber
	var verts_end_idx   : int = len(vertex_container.verts_packedArray)
	
	var index_start_idx : int = 0
	var index_end_idx   : int = drawing_node.primitiveCount * 3
	#var index_end_idx   : int = len(index_container.index_data)
	
	if debug_meshes:
		LogSystem.writeToErrorLogNoPrint(" Draw container (%d, %s):" % [drawing_node.tag, drawing_node.offset_hex])
		LogSystem.writeToErrorLogNoPrint(" (parent NodeObject -> %s):" % [parent_node.offset_hex])
		#LogSystem.writeToErrorLogNoPrint("draw object %s" % drawing_node.offset_hex)
		LogSystem.writeToErrorLogNoPrint(" * verts in container=%d" % vertex_container.num_verts)
		if (use_index):
			LogSystem.writeToErrorLogNoPrint(" * indices in container=%d" % index_container.num_index)
		else:
			LogSystem.writeToErrorLogNoPrint(" * indices container not linked")
		LogSystem.writeToErrorLogNoPrint(" *  primitiveType=%d" % drawing_node.primitiveType)
		LogSystem.writeToErrorLogNoPrint(" *  startNumber=%d" % drawing_node.startNumber)
		LogSystem.writeToErrorLogNoPrint(" *  primitiveCount=%d" % drawing_node.primitiveCount)
	
	if drawing_node.tag == 328:
		if debug:
			LogSystem.writeToErrorLogNoPrint(" *  minIndex=%d" % drawing_node.minIndex)
			LogSystem.writeToErrorLogNoPrint(" *  numVertices=%d" % drawing_node.numVertices)
			LogSystem.writeToErrorLogNoPrint(" *  baseIndex=%d\n" % drawing_node.baseIndex)
		
		verts_end_idx   = verts_start_idx + drawing_node.numVertices

		if (use_index):
			var prim_n : int = drawing_node.primitiveCount * 3
			
			index_start_idx = drawing_node.startNumber
			index_end_idx = index_start_idx + prim_n
	
	
	if (index_start_idx > index_end_idx and use_index):
		print("! index_start_idx > index_end_idx")
		#index_end_idx  += drawing_node.startNumber + drawing_node.minIndex 
		#index_end_idx = len(index_container.index_data)
		breakpoint
		#return
		#index_end_idx = len(index_container.index_data)
	
	#verts = vertex_container.verts_packedArray
	if (use_index):
		verts   = vertex_container.verts_packedArray
		v_bidx  = vertex_container.bindex_packedArray
		UV_data = vertex_container.UV_packedArray
		normals = vertex_container.normals_packedArray
		col_dif = vertex_container.diffuse_colorsArray
		col_spe = vertex_container.specular_colorsArray
		indices = index_container.index_data.slice(index_start_idx, index_end_idx)
		var len_indices = len(indices)
		if (len_indices % 3):
			print("len(indices) % 3")
			breakpoint
			return
		#else:
		#	print("ok")
		
		for i in range(len_indices):
			indices[i] += drawing_node.baseIndex
	else:
		verts_start_idx = drawing_node.startNumber
		verts_end_idx   = verts_start_idx + (drawing_node.primitiveCount * 3)
		
		if (drawing_node.tag == 328):
			verts_end_idx = verts_start_idx + drawing_node.numVertices
		
		verts   = vertex_container.verts_packedArray.slice(verts_start_idx, verts_end_idx)
		v_bidx  = vertex_container.bindex_packedArray.slice(verts_start_idx, verts_end_idx)
		UV_data = vertex_container.UV_packedArray.slice(verts_start_idx, verts_end_idx)
		normals = vertex_container.normals_packedArray.slice(verts_start_idx, verts_end_idx)
	
		col_dif = vertex_container.diffuse_colorsArray.slice(verts_start_idx, verts_end_idx)
		col_spe = vertex_container.specular_colorsArray.slice(verts_start_idx, verts_end_idx)
		
		#print(len(verts) % 3)
		#breakpoint
		if (len(verts) % 3):
			print("len(verts) % 3 (%d)" % len(verts))
			breakpoint
			return
			
	#verts = vertex_container.verts_packedArray
	var verts_modified   : PackedVector3Array = verts.duplicate()
	var normals_modified : PackedVector3Array = normals.duplicate()
	#bindex
	if (!disableBindex):
		if (vertex_container.vertex_flags.flag_bindex):
			var bindex_list : Array

			for idx in indices:
				var vert_bindex : int = v_bidx[idx]
				if not bindex_list.has(vert_bindex):
					bindex_list.append(vert_bindex)
			
			bindex_list.sort()

			var bindex_count : int = len(bindex_list)
			var spaces_count : int = bones_container.num

			if (bindex_count == spaces_count):
				var b_spaces : Array
				for ref in bones_container.space:
					b_spaces.append(ref.ref_obj)
					#matrices.append(ref.ref_obj.objectData.matrix)
					#if (ref.tag == 201): #RefToContainer
						#var space : Node = ref.ref_obj
							#if (space):
							#matrices.append(space.objectData.matrix)
							#var space_pos : Vector3 = space.objectData.matrix.pos
							#print(space.tag)
				
				#что это? это расстановка всех вершин имеющий i-й
				# bindex в позиции i-го NodeSpace из ContainerBonesRef
				
				if (debug_meshes):
					for i in range(bindex_count):
						var msg : String
						msg = '  ** bindex %d -> space (name="%s", offset=%s)' % [bindex_list[i], b_spaces[i].objectData.object_name, b_spaces[i].offset_hex]
						LogSystem.writeToErrorLogNoPrint(msg)
				
				for k in range(len(v_bidx)):
					#verts_modified[k] = verts[k]
					for i in range(bindex_count):
						if v_bidx[k] == bindex_list[i]:
							verts_modified[k] = b_spaces[i].appendToVertex(verts[k])
							if (vertex_container.vertex_flags.flag_normals):
								normals_modified[k] = b_spaces[i].appendToNormal(normals[k])
			
			else:
				print('!!! bindex_count != spaces_count !!! -> draw_obj %s (%d != %d)' % [parent_node.offset_hex, bindex_count, spaces_count])
	
	#var verts2 : PackedVector3Array
	#for vtx in verts:
	#	verts2.append(Vector3(-vtx.x, vtx.z, vtx.y))
	#for k in range(len(verts)):
	#	var old_vtx : Vector3 = verts[k]
	#	var new_vtx : Vector3
	#	
	#	new_vtx.x = -old_vtx.x
	#	new_vtx.y =  old_vtx.z
	#	new_vtx.z =  old_vtx.y
	#	
	#	verts[k] = new_vtx
	
	#surface_data[Mesh.ARRAY_VERTEX] = verts2
	surface_data[Mesh.ARRAY_VERTEX] = verts_modified
	#surface_data[Mesh.ARRAY_VERTEX] = verts
	#surface_data[Mesh.ARRAY_BONES]  = v_bones

	if (use_index):
		indices.reverse()
		surface_data[Mesh.ARRAY_INDEX]  = indices
		
	if (vertex_container.vertex_flags.flag_uv):
		surface_data[Mesh.ARRAY_TEX_UV] = UV_data
	
	#не знаю, как это применять
	if (vertex_container.vertex_flags.flag_diffuse):
		surface_data[Mesh.ARRAY_COLOR] = col_dif
	
	#if (vertex_container.vertex_flags.flag_specular):
	#	surface_data[Mesh.ARRAY_COLOR] = col_spe
		
	#if (vertex_container.vertex_flags.flag_bindex):
		#print(len(verts))
		#print(len(v_bones))
	#	surface_data[Mesh.ARRAY_BONES]  = v_bones
	
	if (vertex_container.vertex_flags.flag_normals):	
		var testlen1 : int = len(verts)
		var testlen2 : int = len(normals)
		
		#var testlen11 : int = len(vertex_container.verts_packedArray)
		#var testlen22 : int = len(vertex_container.normals_packedArray)
		
		if (testlen1 == testlen2):
			surface_data[Mesh.ARRAY_NORMAL] = normals_modified
			#surface_data[Mesh.ARRAY_NORMAL] = normals
		else:
			print("!!! %d != %d !!!" % [testlen1, testlen2])
			breakpoint

	MeshNode.mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, surface_data)

	#if (parent_node.name == "NodeObject_CCFF"):
	#	breakpoint

	#if (parent_node.name == "NodeObject_2BA6"):
	#	breakpoint

	var material_node : Node3D
	material_node = scene_root.searchMaterial(material_name)
	
	if (material_node):
		material_object = material_node
		MeshNode.material_override = material_node.material
		MeshNode.cast_shadow = material_node.cast_shadow
		#if (!material_node.material.albedo_texture):
		#	LogSystem.writeToErrorLogNoPrint("mtl '%s' has no texture!" % material_name)
	#else:
	#	print('"%s" -> "%s" not found' % [parent_node.name, material_name])
	
	if debug_meshes:
		LogSystem.writeToErrorLogNoPrint(" * material = '%s'" % material_name)
		LogSystem.writeToErrorLogNoPrint("")
	
	parent_node.call_deferred('add_child', MeshNode)
	#parent_node.add_child(MeshNode)
	return MeshNode
