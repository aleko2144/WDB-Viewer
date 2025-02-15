class_name wdb2mtl

var export_path    : String
var file_name      : String

var material_names : Array
var materials      : Array

var texture_names  : Array
var textures       : Array

func initialize(path : String, scn_name : String) -> void:
	export_path = path
	file_name = scn_name

func addMaterial(mtl : Node) -> void:
	if (not material_names.has(mtl.material.resource_name)):
		material_names.append(mtl.material.resource_name)
		materials.append(mtl)
		#materials.append(mtl.material)

func exportMtl() -> void:
	var mtl_path : String = "%s%s.mtl" % [export_path, file_name]
	var mtl : FileAccess = FileAccess.open(mtl_path, FileAccess.WRITE)

	mtl.store_line('# WDB Viewer export')
	mtl.store_line('')

	var tex_iter : int = 0
	for mtlNode in materials:
		mtl.store_line('newmtl %s' % mtlNode.material.resource_name)
		if (mtlNode.material.albedo_texture):
			var txr_name : String = mtlNode.material.albedo_texture.resource_name
			
			if (!txr_name):
				txr_name = 'tex_%d' % tex_iter
				tex_iter += 1
				mtlNode.material.albedo_texture.resource_name = txr_name
			
			mtl.store_line('map_Kd ./txr/%s.png' % mtlNode.material.albedo_texture.resource_name)
			
			if (not texture_names.has(txr_name)):
				texture_names.append(txr_name)
				mtlNode.mt_image.resource_name = txr_name
				textures.append(mtlNode.mt_image)
				
		mtl.store_line('')
	
	mtl.close()
	
	for texture in textures:
		var tex_path : String = export_path + '/txr/'
		texture.save_png("%s%s.png" % [tex_path, texture.resource_name])
