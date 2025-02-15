class_name WDB_ContainerTextureLevels extends WDB_DataContainer

#wdb.dsr description:
#( DWORD num )
#( Container	text ( (ITERATED num ) ) )

var num  : int
var text : Array

func LoadFromBuffer(file : StreamPeerBuffer, loader : WDB_FileLoader) -> void:
	tag = 307

	super(file, loader)
	self.name = WDB_ASCIIZ.ApplyName(self.object_name, "TextureLevels_%s" % self.offset_hex)
	
	num = file.get_32()
	
	for i in range(num):
		var child_obj : Node = loader.read_WDBNode(file, loader)
		if (child_obj): #чтобы не было ошибок при импорте
			text.append(child_obj)
			if (self.object_name):
				child_obj.texture.resource_name = "%s_%d" % [self.object_name, i]
				#print(object_name)
			
	#debug
	#if (width > 512 and !image.is_empty()):
	#	image.save_png("g:/d3/Dev/WDB_Viewer/test_tex_export/%s_%s.png" % [self.offset_hex, img_format_str])
	#экспорт оригинала и сгенерированной текстуры
	#var test_img : Node = text[0]
	#if (test_img):
	#	test_img.image.save_png("g:/d3/Dev/WDB_Viewer/test_tex_export/%s_%s_%d.png" % [test_img.offset_hex, test_img.img_format_str, test_img.texture_type])
	#	var file_name : String = "g:/d3/Dev/WDB_Viewer/test_tex_export/bin/%s_%s_%d.bin" % [test_img.offset_hex, test_img.img_format_str, test_img.texture_type]
	#	var file_obj : FileAccess = FileAccess.open(file_name, FileAccess.WRITE)
	#	file_obj.store_buffer(test_img.data)
	
