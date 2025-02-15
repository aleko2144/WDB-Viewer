class_name wdb2obj

var export_path : String
var file_name   : String
var obj : FileAccess

func initialize(path : String, scn_name : String) -> void:
	export_path = path
	file_name = scn_name
	
	var obj_path : String = "%s%s.obj" % [export_path, file_name]
	obj = FileAccess.open(obj_path, FileAccess.WRITE)

	obj.store_line('# WDB Viewer export')
	obj.store_line('mtllib %s.mtl' % file_name)

var obj_iter : int = 0
func exportObj(meshInfo : Array) -> Node:
	var mesh : MeshInstance3D = meshInfo[0]
	var mesh_dup : MeshInstance3D = meshInfo[0].duplicate()
	var transform : Transform3D = meshInfo[1]
	
	var mesh_name : String = 'object_%d' % [obj_iter]
	
	obj.store_line('o %s' % [mesh_name])
	
	var vertex_flags : WDB_VertexFlags = mesh.get_parent().meshData.vertex_container.vertex_flags
	var surface_data : Array = mesh_dup.mesh.surface_get_arrays(0)
	#surface_data[Mesh.ARRAY_VERTEX] = verts_modified
	#surface_data[Mesh.ARRAY_INDEX]  = indices
	#surface_data[Mesh.ARRAY_TEX_UV] = UV_data
	
	var verts_array : Array = surface_data[Mesh.ARRAY_VERTEX]
	var verts_count : int = len(verts_array)
	
	for i in range(verts_count):
		var vert : Vector3 = verts_array[i] * transform
		obj.store_line('v %f %f %f' % [vert.x, vert.y, vert.z])
		
	obj.store_line('s 1') #shading = on
	obj.store_line('usemtl %s' % [mesh.get_parent().meshData.material_object.material.resource_name])
	
	var index_array : Array = surface_data[Mesh.ARRAY_INDEX]
	var index_count : int = len(index_array)

	var idx_iter : int = 0
	while idx_iter < index_count:
		obj.store_line('f %d %d %d' % [index_array[idx_iter], index_array[idx_iter + 1], index_array[idx_iter + 2]])
		idx_iter += 3
	
	obj_iter += 1
	return mesh.get_parent().meshData.material_object
