class_name WDB_ContainerMaterial extends WDB_DataContainer

#wdb.dsr description:
#( ASCIIZ typeName )
#( DWORD	numOfTextures )
#( Ref textures ( ( ITERATED numOfTextures ) ) )
#( DWORD numOfParams )
#( MaterialParamStruct params ( ( ITERATED numOfParams ) ) )

var typeName      : String
var numOfTextures : int
var textures_refs : Array
var numOfParams   : int
var params        : Array

#для Godot
var material : StandardMaterial3D
var mt_image : Image
var cast_shadow : bool = true #false
var gen_mipmaps : bool = false

func LoadFromBuffer(file : StreamPeerBuffer, loader : WDB_FileLoader) -> void:
	tag = 320

	super(file, loader)
	self.name = WDB_ASCIIZ.ApplyName(self.object_name, "Material_%s" % self.offset_hex)
	
	typeName      = WDB_ASCIIZ.LoadFromBuffer(file)
	numOfTextures = file.get_32()
	
	for i in range(numOfTextures):
		var child_obj : Node = loader.read_WDBNode(file, loader)
		if (child_obj): #чтобы не было ошибок при импорте
			textures_refs.append(child_obj)
			
	numOfParams = file.get_32()
	
	for i in range(numOfParams):
		var mtl_struct : WDB_MaterialParamStruct = WDB_MaterialParamStruct.new()
		mtl_struct.LoadFromBuffer(file)
		params.append(mtl_struct)

func getTextureNodeFromRef(tex_node : Node) -> Node:
	var result : Node
	
	if (tex_node.tag == 201): #RefToContainer
		tex_node = textures_refs[0]
		if (tex_node.Id != -1):
			var tex_obj : Node = tex_node.ref_obj
			if !tex_obj:
				return
			#ContainerTextureLevels
			if (tex_obj.tag == 307 or tex_obj.tag == 342):
				result = tex_obj.text[0]#.texture
			else:
				result = tex_obj#.texture
			
	elif (tex_node.tag == 204): #RefToMultipleContainer
		tex_node = textures_refs[0].refs[0]
		#if (tex_node.Id != -1):
			#var txr : ImageTexture = tex_node.ref_obj.text[0].texture
		var tex_obj : Node = tex_node.ref_obj
		if !tex_obj:
			return
		#ContainerTextureLevels
		if (tex_obj.tag == 307 or tex_obj.tag == 342):
			result = tex_obj.text[0]#.texture
		elif (tex_obj.tag == 305 or tex_obj.tag == 325 or tex_obj.tag == 306 or tex_obj.tag == 326):
			result = tex_obj#.texture
		#else:
			
		#if (!result): #если ссылка есть, а Id = -1:
			
	
	return result

func getTextureFromRef(tex_node : Node) -> Object:
	var result : ImageTexture
	
	if (tex_node.tag == 201): #RefToContainer
		tex_node = textures_refs[0]
		if (tex_node.Id != -1):
			var tex_obj : Node = tex_node.ref_obj
			if !tex_obj:
				return
			#ContainerTextureLevels
			if (tex_obj.tag == 307 or tex_obj.tag == 342):
				result = tex_obj.text[0].texture
			else:
				result = tex_obj.texture
			
	elif (tex_node.tag == 204): #RefToMultipleContainer
		tex_node = textures_refs[0].refs[0]
		#if (tex_node.Id != -1):
			#var txr : ImageTexture = tex_node.ref_obj.text[0].texture
		var tex_obj : Node = tex_node.ref_obj
		if !tex_obj:
			return
		#ContainerTextureLevels
		if (tex_obj.tag == 307 or tex_obj.tag == 342):
			result = tex_obj.text[0].texture
		elif (tex_obj.tag == 305 or tex_obj.tag == 325 or tex_obj.tag == 306 or tex_obj.tag == 326):
			result = tex_obj.texture
		#else:
			
		#if (!result): #если ссылка есть, а Id = -1:
			
	
	return result


func initialize(scene_root : Node, debug_mode : bool) -> void:
	var scenes_base : Node = scene_root.get_parent()
	var texture  : ImageTexture
	var tex_node : Node
	
	material = StandardMaterial3D.new()
	material.resource_name = self.object_name
	#material.albedo_texture = texture

	var dont_add_next_pass : bool = true
	if (numOfParams):
		for mtl_param in params:
			if mtl_param.paramName == "mpGlassTransparent":
				material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA_DEPTH_PRE_PASS
				material.albedo_color.a = mtl_param.paramValue.decode_float(0)
				#material.albedo_color.a = mtl_param.parValueFt
				#print(mtl_param.parValueFt)
			elif mtl_param.paramName == "mpNoZWrite":
				material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
				
			elif mtl_param.paramName == "mpUseTrueReflection":
				material.roughness = 0.25
			
			#отключено, т.к. используется в т.ч. на рекламных стендах
			elif mtl_param.paramName == "mpMaterialEmissive":
				pass
				#material.emission_enabled = true
				#material.emission.r8 = mtl_param.paramValue[0]
				#material.emission.g8 = mtl_param.paramValue[1]
				#material.emission.b8 = mtl_param.paramValue[2]
				#material.emission.a8 = mtl_param.paramValue[3]
				
			elif mtl_param.paramName == "mpMaterialDiffuse":
				pass
				#material.albedo_color.r8 = mtl_param.paramValue[0]
				#material.albedo_color.g8 = mtl_param.paramValue[1]
				#material.albedo_color.b8 = mtl_param.paramValue[2]
				#material.albedo_color.a8 = 255 - mtl_param.paramValue[3]
				#material.vertex_color_use_as_albedo = true	
			
			#elif mtl_param.paramName == "mpMaterialDiffuse":
			#	pass
			#	material.albedo_color.r8 = mtl_param.paramValue[0]
			#	material.albedo_color.g8 = mtl_param.paramValue[1]
			#	material.albedo_color.b8 = mtl_param.paramValue[2]
			#	material.albedo_color.a8 = 255 - mtl_param.paramValue[3]
			#	#material.vertex_color_use_as_albedo = true
			
			elif mtl_param.paramName == "mpMaterialAmbient":
				pass
				
			elif mtl_param.paramName == "mpDoShadowCasting":
				cast_shadow = true
			
			#если включать, то тогда неправильно ложится текстура
			#на модели деревьев в Oxnard/OV_03.wdb
			elif mtl_param.paramName == "mpNoTile":
			#	material.texture_repeat = false
				pass
			
			#elif mtl_param.paramName == "Wiper":
			#	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
			#	material.albedo_color.a = 1
			#	return
				
			#elif mtl_param.paramName == "mpWindowsTransparency":
			#	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
			#	material.albedo_color.a = 1
			#	return
			
			else:
				if debug_mode:
					if (not scenes_base.unknown_material_par.has(mtl_param.paramName)):
						scenes_base.unknown_material_par.append(mtl_param.paramName)
						scenes_base.unknown_material_par_mtl.append(self.name)
	
	
	if (typeName == "CarGlass"):
		material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA_DEPTH_PRE_PASS
		material.albedo_color.r8 = 32
		material.albedo_color.g8 = 64
		material.albedo_color.b8 = 64
		material.albedo_color.a8 = 96
		material.roughness = 0.1
	elif (typeName == "Simple"):
		material.roughness = 0.9
	#шины?
	elif (typeName == "Simple+Alpha"):
		material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA_DEPTH_PRE_PASS	
		material.roughness = 0.9
	
	#шрифт дорожных знаков (texture_type = 26)
	elif (typeName == "Simple+Alpha+VertexColor"):
		material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA_SCISSOR
		material.roughness = 1.0
		#material.vertex_color_use_as_albedo = true
	
	#тоже шрифт дорожных знаков
	elif (typeName == "Simple+Alpha+VertexColor+SimpleLightMap"):
		material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA_DEPTH_PRE_PASS
		material.roughness = 1.0
		#material.vertex_color_use_as_albedo = true
	
	#lightmap дорожных знаков
	elif (typeName == "Simple+Alpha+SimpleLightMap"):
		material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA_DEPTH_PRE_PASS
		material.roughness = 1.0
		#?
		#material.vertex_color_use_as_albedo = true
		
	#дорожная разметка (стрелочки)
	elif (typeName == "RoadSign1"):
		material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA_DEPTH_PRE_PASS
		material.roughness = 1.0
		
	#трава
	elif (typeName == "Details_Simple"):
		gen_mipmaps = true

	#материал обшивки салона Hercules Sport
	elif (typeName == "Details_Alpha_Blend_Reflection"):
		#material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA	
		#material.roughness = 0.25
		pass
	#заглушки, т.к. не понятно, как правильно быть с этими типами
	elif (typeName == "AdvTruckWindow"):
		material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA_SCISSOR
		material.albedo_color.a8 = 0
		#material.texture = null
		return
	elif (typeName == "TruckWindowInTexture"):
		material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA_SCISSOR
		material.albedo_color.a8 = 0
		#material.texture = null
		return
	elif (typeName == "Wiper"):
		material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA_SCISSOR
		material.albedo_color.a8 = 0
		#material.texture = null
		return
	elif (typeName == "Grass"):
		material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA_SCISSOR
		material.albedo_color.a8 = 0
		
		#material.texture = null
		#return
		#dont_add_next_pass = true
		
		#if (numOfTextures > 1):
		#	tex_node = textures_refs[1]
		#	material.albedo_texture = getTextureFromRef(tex_node)

		#	tex_node = textures_refs[0]
		#	texture = getTextureFromRef(tex_node)
		
		#	#if (texture):
		#	var next_pass_mtl : StandardMaterial3D = StandardMaterial3D.new()
		#	next_pass_mtl.albedo_texture = texture
		#	material.next_pass = next_pass_mtl
		
	#mat_repair_stella_stolb_110
	elif (typeName == "Reflection"):
		pass
		
	#mat_shadow_all_110 -> common_res.wdb
	elif (typeName == "SimpleShadow"):
		material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA_SCISSOR
		material.albedo_color.a8 = 0
		#white color is alpha?
	
	elif (typeName == "Road1"):
		dont_add_next_pass = true
		material.metallic = 0
		material.metallic_specular = 0
		material.roughness = 0.9
		
		#не нужно, т.к. в textures_refs[i] лежат копии той же текстуры
		#if (numOfTextures > 1):
		#	tex_node = textures_refs[1]
		#	texture = getTextureFromRef(tex_node)
			
			#if (texture):
				#material.detail_enabled = true
				#material.detail_mask    = texture
				#material.detail_albedo  = texture
				
	else:
		if (debug_mode and typeName):
			if (not scenes_base.unknown_material_typ.has(typeName)):
				scenes_base.unknown_material_typ.append(typeName)
				scenes_base.unknown_material_typ_mtl.append(self.name)
	
	#экспорт текстур
	#for i in range(numOfTextures):
	#	tex_node = textures_refs[i]
	#	var tex_obj : Node = getTextureNodeFromRef(tex_node)
	#	if (tex_obj):
	#		tex_obj.export_image(self.name, i)
	
	if (numOfTextures):
		tex_node = textures_refs[0]
		texture = getTextureFromRef(tex_node)

		if (texture):
			material.albedo_texture = texture
			mt_image = getTextureNodeFromRef(tex_node).image
			#breakpoint
			
		if (dont_add_next_pass):
			return
		
		var prev_material : StandardMaterial3D = material
		for i in range(numOfTextures - 1):
			tex_node = textures_refs[i + 1]
			texture = getTextureFromRef(tex_node)
			if (texture):
				var next_pass_mtl : StandardMaterial3D = prev_material.duplicate()
				next_pass_mtl.albedo_texture = texture
				prev_material.next_pass = next_pass_mtl
				prev_material = next_pass_mtl
