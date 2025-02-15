class_name WDB_ContainerSimpleTexture extends WDB_DataContainer

#wdb.dsr description:
#( DWORD texture_type ( ( MNEMONICS "tex_*" ) ) )
#( WORD width )
#( WORD height )
#( TextureData data ( PARAMETRIZED ) )

var texture_type : int
var width        : int
var height       : int
var data         : PackedByteArray #Array
var data_size    : int

#Godot object
var image          : Image
var texture        : ImageTexture
var img_format     : Image.Format
var img_format_str : String

func LoadFromBuffer(file : StreamPeerBuffer, loader : WDB_FileLoader) -> void:
	super(file, loader)
	
	texture_type = file.get_32()
	width        = file.get_u16()
	height       = file.get_u16()
	
	var txr_pos : String = "%x" % file.get_position()
	
	#for i in range(width * height):
	#	data.append(file.get_u8())
	#var pos_in_file : int = file.get_position()
	data_size = file.get_32() #data_end_offset - file.get_position() - 4
	if (!data_size):
		breakpoint
	#data = file.get_data(data_size)[1]
	#file.seek(file.get_position() + 4)
	
	#file.seek(file.get_position() + 4)
	#var test = file.get_data(data_size)
	#breakpoint
	
	#data = file.data_array.slice(file.get_position(), data_size + file.get_position())
	#file.seek(file.get_position() + data_size)
	
	data = file.get_data(data_size)[1]
	
	#while (file.get_position() < data_end_offset):
	#	data.append(file.get_u8())
	#breakpoint
	
	#var img_format : Image.Format #= Image.FORMAT_DXT1
	#var img_format_str : String
	match texture_type:
		21: #4 bytes/pixel (lights glow txr, truck_parts_res.wdb)
			img_format = Image.FORMAT_RGBA8  
			img_format_str = "RGBA8"
			image = WDB_TextureLoader.loadFromBuffer(image, data, width, height, texture_type)
		22: #4 bytes/pixel, Gepard_res.wdb
			img_format = Image.FORMAT_RGBA8
			img_format_str = "RGBA8"
			image = WDB_TextureLoader.loadFromBuffer(image, data, width, height, texture_type)
			#image = Image.create_from_data(width, height, false, img_format, data)
		23: #2 bytes/pixel, cross_road_res.wdb текстура асфальта
			img_format = Image.FORMAT_RGB565
			img_format_str = "BGR565"
			image = WDB_TextureLoader.loadFromBuffer(image, data, width, height, texture_type)
		26: #2 bytes/pixel, забор с прозрачностью
			img_format = Image.FORMAT_RGBA4444
			img_format_str = "RGBA4444"
			image = WDB_TextureLoader.loadFromBuffer(image, data, width, height, texture_type)
		60: #2 bytes/pixel, не знаю, что это
			img_format = Image.FORMAT_RGBA4444
			img_format_str = "RGBA4444"
			image = Image.create_from_data(width, height, false, img_format, data)
		827611204:
			img_format = Image.FORMAT_DXT1
			img_format_str = "DXT1"
			image = Image.create_from_data(width, height, false, img_format, data)
		861165636:
			img_format = Image.FORMAT_DXT3
			img_format_str = "DXT3"
			image = Image.create_from_data(width, height, false, img_format, data)
		894720068:
			img_format = Image.FORMAT_DXT5
			img_format_str = "DXT5"
			image = Image.create_from_data(width, height, false, img_format, data)
		_:
			texture = ImageTexture.new()
			print("unknown texture type (%d): %dx%d=%d bytes, pos %s" % [texture_type, width, height, data_size, txr_pos])
			breakpoint
			return
	
	#if (texture_type != 21):
	#	image = Image.create_from_data(width, height, false, img_format, data)
	#else:
	#	#image = Image.create_empty(width, height, false, Image.FORMAT_RGBAF)
	#	image = Image.create_empty(width, height, false, Image.FORMAT_RGBA8)

		
	#image.srgb_to_linear()
	texture = ImageTexture.create_from_image(image)
	
	#texture.resource_name = object_name
	#print(object_name)
	
	#if (image.is_empty()):
	#	print(texture_type)
	#	breakpoint
	
	#if (!image.is_empty()):
	#	image.save_png("g:/d3/Dev/WDB_Viewer/test_tex_export/%s_%d_%s.png" % [self.offset_hex, self.texture_type, img_format_str])
	#	loader.test_iter += 1
	
	
	
	#if (texture_type == 23):
	#	image.save_png("g:/d3/Dev/WDB_Viewer/test_tex_export/%d_%s.png" % [loader.test_iter, img_format_str])
	#	loader.test_iter += 1
	
	#if (width > 512 and !image.is_empty()):
	#	image.save_png("g:/d3/Dev/WDB_Viewer/test_tex_export/%s_%s.png" % [self.offset_hex, img_format_str])
	
	#if (width > 1000 and !image.is_empty()):
	#	var testMTL : StandardMaterial3D = StandardMaterial3D.new()
	#	testMTL.flags_unshaded = 1
	#	testMTL.albedo_texture = texture
		
	#	var root_node : Node = loader.active_scene.get_parent().get_parent()
	#	var test_mesh : Node = root_node.get_node("test_mesh")
		
	#	if (!test_mesh.material_override):
	#		root_node.get_node("test_mesh").material_override = testMTL


	#breakpoint
	
func export_image(mtl_name : String, iter : int) -> void:
	var path : String = 'g:/d3/Dev/WDB_Viewer/test_tex_export'
	image.save_png('%s/%s_%d_type_%d.png' % [path, mtl_name, iter, texture_type])
	
