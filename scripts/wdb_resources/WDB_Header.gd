class_name WDB_Header extends WDB_Object
var contents : Array

func LoadFromBuffer(file : StreamPeerBuffer, loader : WDB_FileLoader) -> void:
	self.tag = 406
	self.name = "Header"
	
	#file.seek(file.get_position() + 0x24) #пропуск заголовка
	
	file.seek(file.get_position() + 4)
	var WDB_version_bin : PackedByteArray = file.get_data(4)[1] #825241649
	var WDB_VERSION : int = int(WDB_version_bin.get_string_from_utf8())
	
	#get_parent().WDB_VERSION = WDB_VERSION
	
	if (WDB_VERSION == 1000):
		pass
	elif (WDB_VERSION == 1001):
		file.seek(file.get_position() + 0x1C) #пропуск заголовка
	else:
		var errorMsg : String
		var wdbName : String = loader.scene_name
		errorMsg = '"%s" - unsupported WDB version (only 1001 supported, but got %d)' % [wdbName, WDB_VERSION]
		LogSystem.writeToErrorLog(errorMsg)
		breakpoint
	
	var contents_length = file.get_32()
	
	for i in range(contents_length):
		#пропуск тега ContainerContents (401) и длины блока
		file.seek(file.get_position() + 8)
		
		var type : int = file.get_32()
		var offset : int = file.get_32()
		var size : int = file.get_32()
		
		contents.append([type, offset, size])
